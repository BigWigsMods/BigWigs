-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Proximity")
if not plugin then return end

plugin.defaultDB = {
	posx = nil,
	posy = nil,
	objects = {
		ability = true,
		tooltip = true,
		title = true,
		background = true,
		sound = true,
		close = true,
	},
	lock = nil,
	width = 140,
	height = 120,
	sound = true,
	soundDelay = 1,
	soundName = "BigWigs: Alarm",
	disabled = nil,
	proximity = true,
	font = nil,
	fontSize = nil,
	graphical = true,
}

-------------------------------------------------------------------------------
-- Locals
--

local db = nil

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")

local media = LibStub("LibSharedMedia-3.0")

local mute = "Interface\\AddOns\\BigWigs\\Textures\\icons\\mute"
local unmute = "Interface\\AddOns\\BigWigs\\Textures\\icons\\unmute"

local inConfigMode = nil
local activeProximityFunction = nil
local activeRange = nil
local activeSpellID = nil
local activeMap = nil
local maxPlayers = 0
local classCache = nil
local anchor = nil

local OnOptionToggled = nil -- Function invoked when the proximity option is toggled on a module.

local setDot, hideDots, testDots -- funcs defined later

local hexColors = {}
local vertexColors = {}
for k, v in pairs(RAID_CLASS_COLORS) do
	hexColors[k] = ("|cff%02x%02x%02x"):format(v.r * 255, v.g * 255, v.b * 255)
	vertexColors[k] = { v.r, v.g, v.b }
end

-- Helper table to cache colored player names.
local coloredNames = setmetatable({}, {__index =
	function(self, key)
		if type(key) == "nil" then return nil end
		local _, class = UnitClass(key)
		if class then
			self[key] = hexColors[class] .. key .. "|r"
			return self[key]
		else
			return key
		end
	end
})

--Radial upvalues
local GetPlayerMapPosition = GetPlayerMapPosition
local GetPlayerFacing = GetPlayerFacing
local format = string.format
local UnitInRange = UnitInRange
local UnitIsDead = UnitIsDead
local UnitIsUnit = UnitIsUnit
local GetTime = GetTime
local min = math.min
local pi = math.pi
local cos = math.cos
local sin = math.sin
local tremove = table.remove
local unpack = unpack

-------------------------------------------------------------------------------
-- Range functions
--

local bandages = {
	53051, -- Dense Embersilk Bandage
	53050, -- Heavy Embersilk Bandage
	53049, -- Embersilk Bandage
	34722, -- Heavy Frostweave Bandage
	34721, -- Frostweave Bandage
	21991, -- Heavy Netherweave Bandage
	21990, -- Netherweave Bandage
	14530, -- Heavy Runecloth Bandage
	14529, -- Runecloth Bandage
	8545, -- Heavy Mageweave Bandage
	8544, -- Mageweave Bandage
	6451, -- Heavy Silk Bandage
	6450, -- Silk Bandage
	3531, -- Heavy Wool Bandage
	3530, -- Wool Bandage
	2581, -- Heavy Linen Bandage
	1251, -- Linen Bandage
}

local ranges = {
	[15] = function(unit)
		for i, v in next, bandages do
			local r = IsItemInRange(v, unit)
			if type(r) == "number" then
				if r == 1 then return true end
				break
			end
		end
	end,
}


do
	local checkInteractDistance = nil
	local _, r = UnitRace("player")
	if r == "Tauren" then
		checkInteractDistance = { [3] = 6, [2] = 7, [4] = 25 }
	elseif r == "Scourge" then
		checkInteractDistance = { [3] = 7, [2] = 8, [4] = 27 }
	else
		checkInteractDistance = { [3] = 8, [2] = 9, [4] = 28 }
	end
	for index, range in pairs(checkInteractDistance) do
		ranges[range] = function(unit) return CheckInteractDistance(unit, index) end
	end

	local spells = {
		DEATHKNIGHT = { 49016 },
		DRUID = { 5185, 467 },
		-- HUNTER = { 34477 }, -- Misdirect is like 100y range, so forget it!
		HUNTER = {},
		MAGE = { 475, 1459 },
		PALADIN = { 635, 19740, 20473 },
		PRIEST = { 2050, 6346 },
		ROGUE = { 57934 },
		SHAMAN = { 331, 546 },
		WARRIOR = { 50720, 3411 },
		WARLOCK = { 5697 },
	}
	local _, class = UnitClass("player")
	local mySpells = spells[class]
	-- Gift of the Naaru
	if r == "Draenei" then mySpells[#mySpells+1] = 28880 end
	if mySpells then
		for i, spell in next, mySpells do
			local name, _, _, _, _, _, _, minRange, range = GetSpellInfo(spell)
			if name and range then
				local works = IsSpellInRange(name, "player")
				if type(works) == "number" then
					range = math.floor(range + 0.5)
					if range == 0 then range = 5 end
					if not ranges[range] then
						ranges[range] = function(unit)
							if IsSpellInRange(name, unit) == 1 then return true end
						end
					end
				end
			end
		end
	end
end

-- Copied from LibMapData-1.0 (All Rights Reserved) with permission from kagaro
local mapData = {
	StormwindCity = {
		{ 1737.499958992,1158.3330078125 },
	},
	Orgrimmar = {
		{ 1739.375,1159.58349609375 },
	},
	TheBastionofTwilight = {
		{ 1078.33402252197, 718.889984130859 },
		{ 778.343017578125, 518.894958496094 },
		{ 1042.34202575684, 694.894958496094 },
	},
	BaradinHold = {
		{ 585, 390 },
	},
	BlackwingDescent = {
		{ 849.69401550293, 566.462341070175 },
		{ 999.692977905273, 666.462005615234 },
	},
	ThroneoftheFourWinds = {
		{ 1500, 1000 },
	},
}

local function findClosest(toRange)
	local closest = 15
	local closestDiff = math.abs(toRange - 15)
	for range, func in pairs(ranges) do
		local diff = math.abs(toRange - range)
		if diff < closestDiff then
			closest = range
			closestDiff = diff
		end
	end
	return ranges[closest], closest
end

local function getClosestRangeFunction(toRange)
	if ranges[toRange] then return ranges[toRange], toRange end
	SetMapToCurrentZone()
	local floors = mapData[(GetMapInfo())]
	if not floors then return findClosest(toRange) end
	local currentFloor = GetCurrentMapDungeonLevel()
	if currentFloor == 0 then currentFloor = 1 end
	local id = floors[currentFloor]
	if not ranges[id] then	-- note to the confused: id is a tableref here, not an integer
		ranges[id] = function(unit, srcX, srcY)
			local dstX, dstY = GetPlayerMapPosition(unit)
			local x = (dstX - srcX) * id[1]
			local y = (dstY - srcY) * id[2]
			return (x*x + y*y) ^ 0.5 < activeRange*1.1	-- add 10% because of mapData inaccuracies, e.g. 6 yards actually testing for 5.5 on chimaeron = ouch
		end
	end
	return ranges[id], toRange
end

--------------------------------------------------------------------------------
-- Options
--

local function updateSoundButton()
	if not anchor then return end
	anchor.sound:SetNormalTexture(db.sound and unmute or mute)
end
local function toggleSound()
	db.sound = not db.sound
	updateSoundButton()
end

-------------------------------------------------------------------------------
-- Display Window
--

local function onDragStart(self) self:StartMoving() end
local function onDragStop(self)
	self:StopMovingOrSizing()
	local s = self:GetEffectiveScale()
	db.posx = self:GetLeft() * s
	db.posy = self:GetTop() * s
end
local function OnDragHandleMouseDown(self) self.frame:StartSizing("BOTTOMRIGHT") end
local function OnDragHandleMouseUp(self, button) self.frame:StopMovingOrSizing() end
local function onResize(self, width, height)
	db.width = width
	db.height = height
	if inConfigMode then
		testDots()
	else
		local width, height = anchor:GetWidth(), anchor:GetHeight()
		local range = activeRange and activeRange or 10
		local pixperyard = min(width, height) / (range*3)
		anchor.rangeCircle:SetSize(range*2*pixperyard, range*2*pixperyard)
	end
end

local function setConfigureTarget(self, button)
	if not inConfigMode or button ~= "LeftButton" then return end
	plugin:SendMessage("BigWigs_SetConfigureTarget", plugin)
end

local function onDisplayEnter(self)
	if not db.objects.tooltip then return end
	if not activeSpellID and not inConfigMode then return end
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
	GameTooltip:SetHyperlink("spell:" .. (activeSpellID or 44318))
	GameTooltip:Show()
end

local locked = nil
local function lockDisplay()
	if locked then return end
	anchor:SetMovable(false)
	anchor:SetResizable(false)
	anchor:RegisterForDrag()
	anchor:SetScript("OnSizeChanged", nil)
	anchor:SetScript("OnDragStart", nil)
	anchor:SetScript("OnDragStop", nil)
	anchor:SetScript("OnMouseUp", nil)
	anchor.drag:Hide()
	locked = true
end
local function unlockDisplay()
	if not locked then return end
	anchor:SetMovable(true)
	anchor:SetResizable(true)
	anchor:RegisterForDrag("LeftButton")
	anchor:SetScript("OnSizeChanged", onResize)
	anchor:SetScript("OnDragStart", onDragStart)
	anchor:SetScript("OnDragStop", onDragStop)
	anchor:SetScript("OnMouseUp", setConfigureTarget)
	anchor.drag:Show()
	locked = nil
end

local function onControlEnter(self)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	GameTooltip:AddLine(self.tooltipHeader)
	GameTooltip:AddLine(self.tooltipText, 1, 1, 1, 1)
	GameTooltip:Show()
end
local function onControlLeave() GameTooltip:Hide() end

local function onNormalClose()
	BigWigs:Print(L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."])
	plugin:Close()
end

local function breakThings()
	anchor.sound:SetScript("OnEnter", nil)
	anchor.sound:SetScript("OnLeave", nil)
	anchor.sound:SetScript("OnClick", nil)
	anchor.close:SetScript("OnEnter", nil)
	anchor.close:SetScript("OnLeave", nil)
	anchor.close:SetScript("OnClick", nil)
end

local function makeThingsWork()
	anchor.sound:SetScript("OnEnter", onControlEnter)
	anchor.sound:SetScript("OnLeave", onControlLeave)
	anchor.sound:SetScript("OnClick", toggleSound)
	anchor.close:SetScript("OnEnter", onControlEnter)
	anchor.close:SetScript("OnLeave", onControlLeave)
	anchor.close:SetScript("OnClick", onNormalClose)
end

local function ensureDisplay()
	if anchor then return end

	local display = CreateFrame("Frame", "BigWigsProximityAnchor", UIParent)
	display:SetWidth(db.width or plugin.defaultDB.width)
	display:SetHeight(db.height or plugin.defaultDB.height)
	display:SetMinResize(100, 30)
	display:SetClampedToScreen(true)
	display:EnableMouse(true)
	display:SetScript("OnEnter", onDisplayEnter)
	display:SetScript("OnLeave", onControlLeave)
	local bg = display:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints(display)
	bg:SetBlendMode("BLEND")
	bg:SetTexture(0, 0, 0, 0.3)
	display.background = bg

	local close = CreateFrame("Button", nil, display)
	close:SetPoint("BOTTOMRIGHT", display, "TOPRIGHT", -2, 2)
	close:SetHeight(16)
	close:SetWidth(16)
	close.tooltipHeader = L["Close"]
	close.tooltipText = L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."]
	close:SetNormalTexture("Interface\\AddOns\\BigWigs\\Textures\\icons\\close")
	display.close = close

	local sound = CreateFrame("Button", nil, display)
	sound:SetPoint("BOTTOMLEFT", display, "TOPLEFT", 2, 2)
	sound:SetHeight(16)
	sound:SetWidth(16)
	sound.tooltipHeader = L["Toggle sound"]
	sound.tooltipText = L["Toggle whether or not the proximity window should beep when you're too close to another player."]
	display.sound = sound

	local header = display:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	header:SetText(L["%d yards"]:format(0))
	header:SetPoint("BOTTOM", display, "TOP", 0, 4)
	display.title = header

	local abilityName = display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	abilityName:SetText(L["|T%s:20:20:-5|tAbility name"]:format("Interface\\Icons\\spell_nature_chainlightning"))
	abilityName:SetPoint("BOTTOM", header, "TOP", 0, 4)
	display.ability = abilityName

	local text = display:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	text:SetText("")
	text:SetAllPoints(display)
	display.text = text
	display:SetScript("OnShow", function()
		if inConfigMode then
			text:SetText("|cffaad372Legolasftw|r\n|cfff48cbaTirionman|r\n|cfffff468Sneakystab|r\n|cffc69b6dIamconanok|r")
		else
			text:SetText("|cff777777:-)|r")
		end
	end)

	local rangeCircle = display:CreateTexture(nil, "ARTWORK")
	rangeCircle:SetPoint("CENTER")
	rangeCircle:SetTexture([[Interface\AddOns\BigWigs\Textures\alert_circle]])
	rangeCircle:SetBlendMode("ADD")
	display.rangeCircle = rangeCircle

	local playerDot = display:CreateTexture(nil, "OVERLAY")
	playerDot:SetSize(32, 32)
	playerDot:SetTexture([[Interface\Minimap\MinimapArrow]])
	playerDot:SetBlendMode("ADD")
	playerDot:SetPoint("CENTER")
	display.playerDot = playerDot

	local drag = CreateFrame("Frame", nil, display)
	drag.frame = display
	drag:SetFrameLevel(display:GetFrameLevel() + 10) -- place this above everything
	drag:SetWidth(16)
	drag:SetHeight(16)
	drag:SetPoint("BOTTOMRIGHT", display, -1, 1)
	drag:EnableMouse(true)
	drag:SetScript("OnMouseDown", OnDragHandleMouseDown)
	drag:SetScript("OnMouseUp", OnDragHandleMouseUp)
	drag:SetAlpha(0.5)
	display.drag = drag

	local tex = drag:CreateTexture(nil, "OVERLAY")
	tex:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\draghandle")
	tex:SetWidth(16)
	tex:SetHeight(16)
	tex:SetBlendMode("ADD")
	tex:SetPoint("CENTER", drag)

	anchor = display

	local x = db.posx
	local y = db.posy
	if x and y then
		local s = display:GetEffectiveScale()
		display:ClearAllPoints()
		display:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	else
		display:ClearAllPoints()
		display:SetPoint("CENTER", UIParent, "CENTER", 400, 0)
	end

	plugin:RestyleWindow()
end

function plugin:RestyleWindow()
	updateSoundButton()
	for k, v in pairs(db.objects) do
		if anchor[k] then
			if v then
				anchor[k]:Show()
			else
				anchor[k]:Hide()
			end
		end
	end
	anchor.text:SetFont(media:Fetch("font", db.font), db.fontSize)
	if db.lock then
		locked = nil
		lockDisplay()
	else
		locked = true
		unlockDisplay()
	end
end

-------------------------------------------------------------------------------
-- Proximity Updater
--

local updater = nil
local graphicalUpdater, textUpdater = nil, nil
do
	local proxDots = {}
	local cacheDots = {}
	local lastplayed = 0 -- When we last played an alarm sound for proximity.

	-- dx and dy are in yards
	-- class is player class
	-- facing is radians with 0 being north, counting up clockwise
	setDot = function(dx, dy, class)
		local width, height = anchor:GetWidth(), anchor:GetHeight()
		local range = activeRange and activeRange or 10
		-- range * 3, so we have 3x radius space
		local pixperyard = min(width, height) / (range * 3)

		-- rotate relative to player facing
		local rotangle = (2 * pi) - GetPlayerFacing()
		local x = (dx * cos(rotangle)) - (-1 * dy * sin(rotangle))
		local y = (dx * sin(rotangle)) + (-1 * dy * cos(rotangle))

		x = x * pixperyard
		y = y * pixperyard

		local dot = nil
		if #cacheDots > 0 then
			dot = tremove(cacheDots)
		else
			dot = anchor:CreateTexture(nil, "OVERLAY")
			dot:SetSize(16, 16)
			dot:SetTexture([[Interface\AddOns\BigWigs\Textures\blip]])
		end
		proxDots[#proxDots + 1] = dot

		dot:ClearAllPoints()
		dot:SetPoint("CENTER", anchor, "CENTER", x, y)
		dot:SetVertexColor(unpack(vertexColors[class]))
		dot:Show()
	end

	hideDots = function()
		-- shuffle existing dots into cacheDots
		-- hide those cacheDots
		while #proxDots > 0 do
			proxDots[1]:Hide()
			cacheDots[#cacheDots + 1] = tremove(proxDots, 1)
		end
	end

	testDots = function()
		hideDots()
		setDot(10, 10, "WARLOCK", 0)
		setDot(5, 0, "HUNTER", 0)
		setDot(3, 10, "MAGE", 0)
		setDot(-9, -7, "PRIEST", 0)
		setDot(0, 10, "WARLOCK", 0)
		local width, height = anchor:GetWidth(), anchor:GetHeight()
		local pixperyard = min(width, height) / 30
		anchor.rangeCircle:SetSize(pixperyard * 20,  pixperyard * 20)
		anchor.rangeCircle:SetVertexColor(1,0,0)
		anchor.rangeCircle:Show()
		anchor.playerDot:Show()
	end

	local tooClose = {} -- List of players who are too close.
	local function updateProximityText()
		local srcX, srcY = GetPlayerMapPosition("player")
		if srcX == 0 and srcY == 0 then
			SetMapToCurrentZone()
			srcX, srcY = GetPlayerMapPosition("player")
		end
		for i = 1, maxPlayers do
			local n = format("raid%d", i)
			if UnitInRange(n) and not UnitIsDead(n) and not UnitIsUnit(n, "player") and activeProximityFunction(n, srcX, srcY) then
				local nextIndex = #tooClose + 1
				tooClose[nextIndex] = coloredNames[UnitName(n)]
				if nextIndex > 4 then break end
			end
		end

		if #tooClose == 0 then
			anchor.text:SetText("|cff777777:-)|r")
			lastplayed = 0
		else
			anchor.text:SetText(table.concat(tooClose, "\n"))
			wipe(tooClose)
			if not db.sound then return end
			local t = GetTime()
			if t > (lastplayed + db.soundDelay) and not UnitIsDead("player") then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", db.soundName)
			end
		end
	end

	local function updateProximityRadar()
		local srcX, srcY = GetPlayerMapPosition("player")
		if srcX == 0 and srcY == 0 then
			SetMapToCurrentZone()
			srcX, srcY = GetPlayerMapPosition("player")
		end

		-- XXX This could probably be checked and set when the proximity
		-- XXX display is opened? We won't change dungeon floors while
		-- XXX it is open, surely.
		local id = nil
		if activeMap then
			local currentFloor = GetCurrentMapDungeonLevel()
			if currentFloor == 0 then currentFloor = 1 end
			id = activeMap[currentFloor]
		end

		-- Fall back to text
		if not id then
			updater:SetScript("OnUpdate", textUpdater)
			anchor.text:Show()
			anchor.rangeCircle:Hide()
			anchor.playerDot:Hide()
			return updateProximityText()
		end

		local anyoneClose = nil

		-- XXX We can't show/hide dots every update, that seems excessive.
		hideDots()
		for i = 1, maxPlayers do
			local n = format("raid%d", i)
			if UnitInRange(n) and not UnitIsDead(n) and not UnitIsUnit(n, "player") then
				local unitX, unitY = GetPlayerMapPosition(n)
				local dx = (unitX - srcX) * id[1]
				local dy = (unitY - srcY) * id[2]
				local range = (dx * dx + dy * dy) ^ 0.5
				if range < (activeRange * 1.5) then
					setDot(dx, dy, classCache[i])
					if range <= activeRange*1.1 then  -- add 10% because of mapData inaccuracies, e.g. 6 yards actually testing for 5.5 on chimaeron = ouch
						anyoneClose = true
					end
				end
			end
		end

		if not anyoneClose then
			lastplayed = 0
			anchor.rangeCircle:SetVertexColor(0, 1, 0)
		else
			anchor.rangeCircle:SetVertexColor(1, 0, 0)
			if not db.sound then return end
			local t = GetTime()
			if t > (lastplayed + db.soundDelay) and not UnitIsDead("player") then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", db.soundName)
			end
		end
	end

	updater = CreateFrame("Frame")
	updater:Hide()
	local total = 0

	-- 20x per second for radar mode
	function graphicalUpdater(self, elapsed)
		total = total + elapsed
		if total >= .05 then
			total = 0
			updateProximityRadar()
		end
	end
	-- 2 times per second for text mode
	function textUpdater(self, elapsed)
		total = total + elapsed
		if total >= .5 then
			total = 0
			updateProximityText()
		end
	end
end

local function updateProfile()
	db = plugin.db.profile

	if not anchor then return end

	anchor:SetWidth(db.width)
	anchor:SetHeight(db.height)

	local x = db.posx
	local y = db.posy
	if x and y then
		local s = anchor:GetEffectiveScale()
		anchor:ClearAllPoints()
		anchor:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	else
		anchor:ClearAllPoints()
		anchor:SetPoint("CENTER", UIParent, "CENTER", 400, 0)
	end
end

local function resetAnchor()
	anchor:ClearAllPoints()
	anchor:SetPoint("CENTER", UIParent, "CENTER", 400, 0)
	anchor:SetWidth(plugin.defaultDB.width)
	anchor:SetHeight(plugin.defaultDB.height)
	db.posx = nil
	db.posy = nil
	db.width = nil
	db.height = nil
end

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnRegister()
	db = self.db.profile

	BigWigs:RegisterBossOption("proximity", L["proximity"], L["proximity_desc"], OnOptionToggled)
	if CUSTOM_CLASS_COLORS then
		local function update()
			wipe(coloredNames)
			for k, v in pairs(CUSTOM_CLASS_COLORS) do
				hexColors[k] = ("|cff%02x%02x%02x"):format(v.r * 255, v.g * 255, v.b * 255)
				vertexColors[k] = { v.r, v.g, v.b }
			end
		end
		CUSTOM_CLASS_COLORS:RegisterCallback(update)
		update()
	end
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)

	local function iterateFloors(map, ...)
		for i = 1, select("#", ...), 2 do
			local w, h = select(i, ...)
			table.insert(mapData[map], { tonumber(w), tonumber(h) })
		end
	end
	local function iterateMaps(addonIndex, ...)
		for i = 1, select("#", ...) do
			local map = select(i, ...)
			local meta = GetAddOnMetadata(addonIndex, "X-BigWigs-MapSize-" .. map)
			if meta then
				if not mapData[map] then mapData[map] = {} end
				iterateFloors(map, strsplit(",", meta))
			end
		end
	end

	for i = 1, GetNumAddOns() do
		local meta = GetAddOnMetadata(i, "X-BigWigs-Maps")
		if meta then
			iterateMaps(i, strsplit(",", meta))
		end
	end

	if not db.font then
		db.font = media:GetDefault("font")
	end
	if not db.fontSize then
		local _, size = GameFontNormalHuge:GetFont()
		db.fontSize = size
	end
end

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_ShowProximity")
	self:RegisterMessage("BigWigs_HideProximity", "Close")
	self:RegisterMessage("BigWigs_OnBossDisable")

	self:RegisterMessage("BigWigs_StartConfigureMode")
	self:RegisterMessage("BigWigs_StopConfigureMode")
	self:RegisterMessage("BigWigs_SetConfigureTarget")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	self:RegisterMessage("BigWigs_ResetPositions", resetAnchor)
end

function plugin:OnPluginDisable()
	self:Close()
end

-------------------------------------------------------------------------------
-- Options
--

function plugin:BigWigs_StartConfigureMode()
	inConfigMode = true
	self:Test()
end

function plugin:BigWigs_StopConfigureMode()
	inConfigMode = nil
	self:Close()
end

function plugin:BigWigs_SetConfigureTarget(event, module)
	ensureDisplay()
	if module == self then
		anchor.background:SetTexture(0.2, 1, 0.2, 0.3)
	else
		anchor.background:SetTexture(0, 0, 0, 0.3)
	end
end

do
	local pluginOptions = nil
	function plugin:GetPluginConfig()
		if not pluginOptions then
			pluginOptions = {
				type = "group",
				get = function(info)
					local key = info[#info]
					if key == "font" then
						for i, v in next, media:List("font") do
							if v == db.font then return i end
						end
					elseif key == "soundName" then
						for i, v in next, media:List("sound") do
							if v == db.soundName then return i end
						end
					else
						return db[key]
					end
				end,
				set = function(info, value)
					local key = info[#info]
					if key == "font" then
						db.font = media:List("font")[value]
					elseif key == "soundName" then
						db.soundName = media:List("sound")[value]
					else
						db[key] = value
					end
					plugin:RestyleWindow()
				end,
				args = {
					disabled = {
						type = "toggle",
						name = L["Disabled"],
						desc = L["Disable the proximity display for all modules that use it."],
						order = 1,
						width = "half",
					},
					lock = {
						type = "toggle",
						name = L["Lock"],
						desc = L["Locks the display in place, preventing moving and resizing."],
						order = 2,
						width = "half",
					},
					graphical = {
						type = "toggle",
						name = L["Graphical display"],
						desc = L["Let the Proximity monitor display a graphical representation of people who might be too close to you instead of just a list of names. This only works for zones where Big Wigs has access to actual size information; for other zones it will fall back to the list of names."],
						order = 3,
						width = "full",
					},
					font = {
						type = "select",
						name = L["Font"],
						order = 4,
						values = media:List("font"),
						width = "full",
						itemControl = "DDI-Font",
					},
					fontSize = {
						type = "range",
						name = L["Font size"],
						order = 5,
						max = 40,
						min = 8,
						step = 1,
						width = "full",
					},
					soundName = {
						type = "select",
						name = L["Sound"],
						order = 6,
						values = media:List("sound"),
						width = "full",
						itemControl = "DDI-Sound"
					},
					soundDelay = {
						type = "range",
						name = L["Sound delay"],
						desc = L["Specify how long Big Wigs should wait between repeating the specified sound when someone is too close to you."],
						order = 7,
						max = 10,
						min = 1,
						step = 1,
						width = "full",
					},
					showHide = {
						type = "group",
						name = L["Show/hide"],
						inline = true,
						order = 10,
						get = function(info)
							local key = info[#info]
							return db.objects[key]
						end,
						set = function(info, value)
							local key = info[#info]
							db.objects[key] = value
							plugin:RestyleWindow()
						end,
						args = {
							title = {
								type = "toggle",
								name = L["Title"],
								desc = L["Shows or hides the title."],
								order = 1,
								width = "half",
							},
							background = {
								type = "toggle",
								name = L["Background"],
								desc = L["Shows or hides the background."],
								order = 2,
								width = "half",
							},
							sound = {
								type = "toggle",
								name = L["Sound button"],
								desc = L["Shows or hides the sound button."],
								order = 3,
								width = "half",
							},
							close = {
								type = "toggle",
								name = L["Close button"],
								desc = L["Shows or hides the close button."],
								order = 4,
								width = "half",
							},
							ability = {
								type = "toggle",
								name = L["Ability name"],
								desc = L["Shows or hides the ability name above the window."],
								order = 5,
								width = "half",
							},
							tooltip = {
								type = "toggle",
								name = L["Tooltip"],
								desc = L["Shows or hides a spell tooltip if the Proximity display is currently tied directly to a boss encounter ability."],
								order = 6,
								width = "half",
							}
						},
					},
				},
			}
		end
		return pluginOptions
	end
end

-------------------------------------------------------------------------------
-- Events
--

do
	local opener = nil
	function plugin:BigWigs_ShowProximity(event, module, range, optionKey)
		if db.disabled or type(range) ~= "number" then return end
		opener = module
		self:Open(range, module, optionKey)
	end

	function plugin:BigWigs_OnBossDisable(event, module, optionKey)
		if module ~= opener then return end
		self:Close()
	end
end

-------------------------------------------------------------------------------
-- API
--

function plugin:Close()
	activeProximityFunction = nil
	activeRange = nil
	activeSpellID = nil
	activeMap = nil
	if classCache then
		wipe(classCache)
		classCache = nil
	end
	if anchor then
		anchor.title:SetText(L["%d yards"]:format(0))
		anchor.ability:SetText(L["|T%s:20:20:-5|tAbility name"]:format("Interface\\Icons\\spell_nature_chainlightning"))
		-- Just in case we were the last target of
		-- configure mode, reset the background color.
		anchor.background:SetTexture(0, 0, 0, 0.3)
		anchor:Hide()
	end
	updater:SetScript("OnUpdate", nil)
	updater:Hide()
end

local abilityNameFormat = "|T%s:20:20:-5|t%s"
function plugin:Open(range, module, key)
	if type(range) ~= "number" then error("Range needs to be a number!") end
	-- Make sure the anchor is there
	ensureDisplay()
	-- Get the best range function for the given range
	local func, actualRange = getClosestRangeFunction(range)
	activeProximityFunction = func
	activeRange = actualRange
	maxPlayers = select(5, GetInstanceInfo())

	if not classCache then classCache = {} end
	for i=1, maxPlayers do
		local _, class = UnitClass(format("raid%d", i))
		classCache[i] = class
	end

	SetMapToCurrentZone()
	activeMap = mapData[(GetMapInfo())]
	hideDots()

	if activeMap and db.graphical then
		local width, height = anchor:GetWidth(), anchor:GetHeight()
		local ppy = min(width, height) / (actualRange * 3)
		anchor.rangeCircle:SetSize(ppy * actualRange * 2, ppy * actualRange * 2)
		anchor.playerDot:Show()
		anchor.rangeCircle:Show()
		anchor.text:Hide()
		updater:SetScript("OnUpdate", graphicalUpdater)
	else
		anchor.rangeCircle:Hide()
		anchor.playerDot:Hide()
		anchor.text:Show()
		updater:SetScript("OnUpdate", textUpdater)
	end

	-- Update the header to reflect the actual range we're checking
	anchor.title:SetText(L["%d yards"]:format(actualRange))
	-- Update the ability name display
	if module and key then
		local dbKey, name, desc, icon = BigWigs:GetBossOptionDetails(module, key)
		if icon then
			anchor.ability:SetText(abilityNameFormat:format(icon, name))
		else
			anchor.ability:SetText(name)
		end
	else
		anchor.ability:SetText(L["Custom range indicator"])
	end
	if type(key) == "number" then
		activeSpellID = key
	else
		activeSpellID = nil
	end
	-- Unbreak the sound+close buttons
	makeThingsWork()
	-- Start the show!
	anchor:Show()
	updater:Show()
end

function plugin:Test()
	-- Make sure the anchor is there
	ensureDisplay()
	-- Close ourselves in case we entered configure mode DURING a boss fight.
	self:Close()
	-- Break the sound+close buttons
	breakThings()
	if db.graphical then
		testDots()
		anchor.text:Hide()
	else
		hideDots()
		anchor.rangeCircle:Hide()
		anchor.playerDot:Hide()
		anchor.text:Show()
	end
	anchor:Show()
end

-------------------------------------------------------------------------------
-- Slash command
--

SlashCmdList.BigWigs_Proximity = function(input)
	if not plugin:IsEnabled() then BigWigs:Enable() end
	local range = tonumber(input)
	if not range then
		print("Usage: /proximity 1-100")
	else
		if range > 0 then
			plugin:Open(range)
		else
			plugin:Close()
		end
	end
end
SLASH_BigWigs_Proximity1 = "/proximity"
SLASH_BigWigs_Proximity2 = "/bwproximity" -- In case some other addon already has /proximity

-- Apparently some users (idiots?) don't read through the interface options before using
-- a complicated addon such as BigWigs. Go figure.
SLASH_BigWigs_Proximity3 = "/range"

