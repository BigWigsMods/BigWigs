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
	sound = false,
	soundDelay = 1,
	soundName = "BigWigs: Alarm",
	disabled = false,
	proximity = true,
	fontName = plugin:GetDefaultFont(),
	fontSize = 20,
	textMode = true,
}

-------------------------------------------------------------------------------
-- Locals
--

local db = nil

local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
plugin.displayName = L.proximity_name
local L_proximityTitle = L.proximityTitle

local media = LibStub("LibSharedMedia-3.0")
local FONT = media.MediaType and media.MediaType.FONT or "font"
local SOUND = media.MediaType and media.MediaType.SOUND or "sound"

local mute = "Interface\\AddOns\\BigWigs\\Media\\Icons\\mute"
local unmute = "Interface\\AddOns\\BigWigs\\Media\\Icons\\unmute"

local activeRange = 0
local activeRangeChecker = nil
local activeSpellID = nil
local proximityPlayer = nil
local proximityPlayerTable = {}
local maxPlayers = 0
local myGUID = nil
local unitList = nil
local blipList = {}
local updateTimer = nil
local functionToFire = nil
local customProximityOpen, customProximityTarget, customProximityReverse = nil, nil, nil
local proxAnchor, proxTitle = nil, nil

-- Upvalues
local CTimerAfter = BigWigsLoader.CTimerAfter
local GameTooltip = CreateFrame("GameTooltip", "BigWigsProximityTooltip", UIParent, "GameTooltipTemplate")
local UnitPosition = UnitPosition
local IsItemInRange = BigWigsLoader.IsItemInRange
local GetRaidTargetIndex, GetNumGroupMembers, GetTime = GetRaidTargetIndex, GetNumGroupMembers, GetTime
local IsInRaid, IsInGroup, InCombatLockdown = IsInRaid, IsInGroup, InCombatLockdown
local UnitIsDead, UnitIsUnit, UnitClass, UnitPhaseReason = UnitIsDead, UnitIsUnit, UnitClass, UnitPhaseReason
local format = string.format
local tinsert, tconcat, wipe = table.insert, table.concat, table.wipe
local next, type, tonumber = next, type, tonumber

local combatText = GARRISON_LANDING_STATUS_MISSION_COMBAT or "In Combat"

local OnOptionToggled = nil -- Function invoked when the proximity option is toggled on a module.

local UnitInPhase = UnitInPhase or function(unit) return not UnitPhaseReason(unit) end -- UnitPhaseReason doesn't exist on classic

--------------------------------------------------------------------------------
-- Range Checking
--

local setRange, isInRange
do
	local ranges = nil

	local function initRanges()
		ranges = {}

		local interactDistances = BigWigsLoader.isClassic and { [2] = 10, [3] = 9, [4] = 30 } or { [2] = 10, [4] = 30 }
		for index, range in next, interactDistances do
			ranges[range] = function(unit)
				return CheckInteractDistance(unit, index)
			end
		end

		local expansion = GetServerExpansionLevel()
		local items = BigWigsLoader.isClassic and {
			[1] = expansion > 3 and 90175, -- Gin-Ji Knife Set (5.0)
			[3] = expansion > 1 and 42732, -- Everfrost Razor (3.0)
			[5] = expansion > 1 and 37727, -- Ruby Acorn (3.0)
			[8] = 8149, -- Voodoo Charm
			-- [9]  = CheckInteractDistance 3
			-- [10] = CheckInteractDistance 2
			[13] = expansion > 0 and 32321, -- Sparrowhawk Net (2.1)
			[18] = 14530, -- Heavy Runecloth Bandage
			[23] = 21519, -- Mistletoe
			[28] = 13289, -- Egan's Blaster
			-- [30] = CheckInteractDistance 4
			[33] = 955, -- Scroll of Intellect
			[38] = 18904, -- Zorbin's Ultra-Shrinker
			[43] = expansion > 0 and 34471, -- Vial of the Sunwell (2.4)
			[48] = expansion > 0 and 32698, -- Wrangling Rope (2.1)
			[53] = expansion > 4 and 116139, -- Haunting Memento (6.0)
			[63] = expansion > 0 and 32825, -- Soul Cannon (2.1)
		} or {
			[1] = 90175, -- Gin-Ji Knife Set
			[3] = 42732, -- Everfrost Razor
			[5] = 37727, -- Ruby Acorn
			[8] = 63427, -- Worgsaw
			[11] = 33278, -- Burning Torch
			[13] = 32321, -- Sparrowhawk Net
			[18] = 133940, -- Silkweave Bandage
			[23] = 21519, -- Mistletoe
			[28] = 31463, -- Zezzak's Shard
			[33] = 34191, -- Handful of Snowflakes
			[38] = 18904, -- Zorbin's Ultra-Shrinker
			[43] = 34471, -- Vial of the Sunwell
			[48] = 32698, -- Wrangling Rope
			[53] = 116139, -- Haunting Memento
			[63] = 32825, -- Soul Cannon
			[73] = 41265, -- Eyesore Blaster
			[83] = 35278, -- Reinforced Net
		}
		for range, item in next, items do
			ranges[range] = function(unit)
				return IsItemInRange(item, unit)
			end
		end
	end

	function setRange(range)
		if range == 0 then
			activeRangeChecker = nil
			return 0
		end

		if not ranges then
			initRanges()
			initRanges = nil
		end

		if ranges[range] then
			activeRangeChecker = ranges[range]
			return range
		else
			local closestRange = 80
			for r in next, ranges do
				if r > range and r < closestRange then
					closestRange = r
				end
			end
			activeRangeChecker = ranges[closestRange]
			return closestRange
		end
	end

	function isInRange(unit)
		if activeRangeChecker and not InCombatLockdown() then
			return activeRangeChecker(unit)
		end
	end
end

--------------------------------------------------------------------------------
-- Options
--

local function updateSoundButton()
	proxAnchor.sound:SetNormalTexture(db.sound and unmute or mute)
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
	plugin:UpdateGUI() -- Update X/Y if GUI is open.
end
local function OnDragHandleMouseDown(self) self.frame:StartSizing("BOTTOMRIGHT") end
local function OnDragHandleMouseUp(self) self.frame:StopMovingOrSizing() end
local function onResize(self, width, height)
	db.width = width
	db.height = height
	proxAnchor.tooltip:SetWidth(width)
end

local locked = nil
local function lockDisplay()
	if locked then return end
	proxAnchor:EnableMouse(false)
	proxAnchor:SetMovable(false)
	proxAnchor:SetResizable(false)
	proxAnchor:RegisterForDrag()
	proxAnchor:SetScript("OnSizeChanged", nil)
	proxAnchor:SetScript("OnDragStart", nil)
	proxAnchor:SetScript("OnDragStop", nil)
	proxAnchor.drag:Hide()
	locked = true
end
local function unlockDisplay()
	if not locked then return end
	proxAnchor:EnableMouse(true)
	proxAnchor:SetMovable(true)
	proxAnchor:SetResizable(true)
	proxAnchor:RegisterForDrag("LeftButton")
	proxAnchor:SetScript("OnSizeChanged", onResize)
	proxAnchor:SetScript("OnDragStart", onDragStart)
	proxAnchor:SetScript("OnDragStop", onDragStop)
	proxAnchor.drag:Show()
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

function plugin:RestyleWindow()
	if not proxAnchor then return end

	updateSoundButton()
	for k, v in next, db.objects do
		if proxAnchor[k] then
			if v then
				proxAnchor[k]:Show()
			else
				proxAnchor[k]:Hide()
			end
		end
	end
	proxAnchor.text:SetFont(media:Fetch(FONT, db.fontName), db.fontSize)
	if db.lock then
		locked = nil
		lockDisplay()
	else
		locked = true
		unlockDisplay()
	end

	local x = db.posx
	local y = db.posy
	if x and y then
		local s = proxAnchor:GetEffectiveScale()
		proxAnchor:ClearAllPoints()
		proxAnchor:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	else
		proxAnchor:ClearAllPoints()
		proxAnchor:SetPoint("CENTER", UIParent, "CENTER", 450, -20)
	end
end

-------------------------------------------------------------------------------
-- Proximity Updater
--

local normalProximityText, reverseTargetProximityText, targetProximityText, multiTargetProximityText, reverseMultiTargetProximityText, reverseProximityText
do
	local lastplayed = 0 -- When we last played an alarm sound for proximity.

	local tooClose = {}
	local coloredNames = plugin:GetColoredNameTable()

	local function setText(players)
		if type(players) == "table" then
			proxAnchor.text:SetText(tconcat(players, "\n"))
			wipe(players)
		else
			proxAnchor.text:SetText(players)
		end
	end

	--------------------------------------------------------------------------------
	-- Normal Proximity
	--

	function normalProximityText()
		if functionToFire then CTimerAfter(0.05, functionToFire) else return end

		local anyoneClose = 0
		local _, _, _, mapId = UnitPosition("player")
		for i = 1, maxPlayers do
			local n = unitList[i]
			local _, _, _, tarMapId = UnitPosition(n)
			if mapId == tarMapId and isInRange(n) and myGUID ~= plugin:UnitGUID(n) and not UnitIsDead(n) and UnitInPhase(n) then
				anyoneClose = anyoneClose + 1
				if anyoneClose < 6 then
					local player = plugin:UnitName(n)
					tinsert(tooClose, coloredNames[player])
				end
			end
		end

		proxTitle:SetFormattedText(L_proximityTitle, activeRange, anyoneClose)

		if InCombatLockdown() then
			proxAnchor.text:SetFormattedText("|cff777777%s\n:-(|r", combatText)
		elseif anyoneClose == 0 then
			proxAnchor.text:SetText("|cff777777:-)|r")
		else
			setText(tooClose)
			if not db.sound then return end
			local t = GetTime()
			if t > (lastplayed + db.soundDelay) and not UnitIsDead("player") and InCombatLockdown() then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", plugin, nil, db.soundName)
			end
		end
	end


	--------------------------------------------------------------------------------
	-- Target Proximity
	--

	function targetProximityText()
		if functionToFire then CTimerAfter(0.05, functionToFire) else return end

		if InCombatLockdown() then
			proxAnchor.text:SetFormattedText("|cff777777%s\n:-(|r", combatText)
		elseif isInRange(proximityPlayer) then
			proxTitle:SetFormattedText(L_proximityTitle, activeRange, 1)
			local player = plugin:UnitName(proximityPlayer)
			proxAnchor.text:SetText(coloredNames[player])
			if not db.sound then return end
			local t = GetTime()
			if t > (lastplayed + 1) and not UnitIsDead("player") and InCombatLockdown() then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", plugin, nil, db.soundName)
			end
		else
			proxTitle:SetFormattedText(L_proximityTitle, activeRange, 0)
			proxAnchor.text:SetText("|cff777777:-)|r")
		end
	end

	--------------------------------------------------------------------------------
	-- Multi Target Proximity
	--

	function multiTargetProximityText()
		if functionToFire then CTimerAfter(0.05, functionToFire) else return end

		local anyoneClose = 0
		for i = 1, #proximityPlayerTable do
			local unit = proximityPlayerTable[i]
			if isInRange(unit) and myGUID ~= plugin:UnitGUID(unit) then
				anyoneClose = anyoneClose + 1
				local player = plugin:UnitName(unit)
				tinsert(tooClose, coloredNames[player])
			end
		end

		proxTitle:SetFormattedText(L_proximityTitle, activeRange, anyoneClose)

		if InCombatLockdown() then
			proxAnchor.text:SetFormattedText("|cff777777%s\n:-(|r", combatText)
		elseif anyoneClose == 0 then
			proxAnchor.text:SetText("|cff777777:-)|r")
		else
			setText(tooClose)
			if not db.sound then return end
			local t = GetTime()
			if t > (lastplayed + 1) and not UnitIsDead("player") and InCombatLockdown() then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", plugin, nil, db.soundName)
			end
		end
	end

	--------------------------------------------------------------------------------
	-- Reverse Proximity
	--

	function reverseProximityText()
		if functionToFire then CTimerAfter(0.05, functionToFire) else return end

		local anyoneClose = 0

		local _, _, _, mapId = UnitPosition("player")
		for i = 1, maxPlayers do
			local n = unitList[i]
			local _, _, _, tarMapId = UnitPosition(n)
			if mapId == tarMapId and isInRange(n) and myGUID ~= plugin:UnitGUID(n) and not UnitIsDead(n) and UnitInPhase(n) then
				anyoneClose = anyoneClose + 1
			end
		end

		proxTitle:SetFormattedText(L_proximityTitle, activeRange, anyoneClose)

		if InCombatLockdown() then
			proxAnchor.text:SetFormattedText("|cff777777%s\n:-(|r", combatText)
		elseif anyoneClose == 0 then
			proxAnchor.text:SetText("|cffff0202> STACK <|r") -- XXX localize or remove?
			if not db.sound then return end
			local t = GetTime()
			if t > (lastplayed + db.soundDelay) and not UnitIsDead("player") and InCombatLockdown() then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", plugin, nil, db.soundName)
			end
		else
			proxAnchor.text:SetText("|cff777777:-)|r")
		end
	end

	--------------------------------------------------------------------------------
	-- Reverse Target Proximity
	--

	function reverseTargetProximityText()
		if functionToFire then CTimerAfter(0.05, functionToFire) else return end

		if InCombatLockdown() then
			proxAnchor.text:SetFormattedText("|cff777777%s\n:-(|r", combatText)
		elseif isInRange(proximityPlayer) then
			proxTitle:SetFormattedText(L_proximityTitle, activeRange, 1)
			proxAnchor.text:SetText("|cff777777:-)|r")
		else
			proxTitle:SetFormattedText(L_proximityTitle, activeRange, 0)
			local player = plugin:UnitName(proximityPlayer)
			tinsert(tooClose, "|cffff0202> STACK <|r")
			tinsert(tooClose, coloredNames[player])
			setText(tooClose)
		end
	end

	--------------------------------------------------------------------------------
	-- Reverse Multi Target Proximity
	--

	function reverseMultiTargetProximityText()
		if functionToFire then CTimerAfter(0.05, functionToFire) else return end

		local anyoneClose = 0

		for i = 1, #proximityPlayerTable do
			local unit = proximityPlayerTable[i]
			if isInRange(unit) then
				anyoneClose = anyoneClose + 1
			else
				local player = plugin:UnitName(unit)
				tinsert(tooClose, coloredNames[player])
			end
		end

		proxTitle:SetFormattedText(L_proximityTitle, activeRange, anyoneClose)

		if InCombatLockdown() then
			proxAnchor.text:SetFormattedText("|cff777777%s\n:-(|r", combatText)
		elseif anyoneClose == 0 then
			tinsert(tooClose, 1, "|cffff0202> STACK <|r") -- XXX localize or remove?
			setText(tooClose)
			if not db.sound then return end
			local t = GetTime()
			if t > (lastplayed + db.soundDelay) and not UnitIsDead("player") and InCombatLockdown() then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", plugin, nil, db.soundName)
			end
		else
			proxAnchor.text:SetText("|cff777777:-)|r")
		end
	end
end

local function updateUnits()
	maxPlayers = GetNumGroupMembers()
	unitList = IsInRaid() and plugin:GetRaidList() or plugin:GetPartyList()
end

local function updateProfile()
	db = plugin.db.profile

	plugin:RestyleWindow()
end

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnRegister()
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	updateProfile()
end

do
	local createAnchor = function()
		-- USE THIS CALLBACK TO SKIN THIS WINDOW! NO NEED FOR UGLY HAX! E.g.
		-- local addonName, addonTable = ...
		-- if BigWigsLoader then
		-- 	BigWigsLoader.RegisterMessage(addonTable, "BigWigs_FrameCreated", function(event, frame, name) print(name.." frame created.") end)
		-- end
		proxAnchor = CreateFrame("Frame", "BigWigsProximityAnchor", UIParent)
		proxAnchor:SetFrameStrata("MEDIUM")
		proxAnchor:SetFixedFrameStrata(true)
		proxAnchor:SetFrameLevel(120)
		proxAnchor:SetFixedFrameLevel(true)
		proxAnchor:SetWidth(db.width)
		proxAnchor:SetHeight(db.height)
		proxAnchor:SetResizeBounds(80, 8)
		proxAnchor:SetClampedToScreen(true)
		proxAnchor:EnableMouse(true)

		local tooltipFrame = CreateFrame("Frame", nil, proxAnchor)
		tooltipFrame:SetWidth(db.width)
		tooltipFrame:SetHeight(40)
		tooltipFrame:SetPoint("BOTTOM", proxAnchor, "TOP")
		tooltipFrame:SetScript("OnEnter", function(self)
			if not activeSpellID then return end
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetHyperlink(format("spell:%d", activeSpellID or 44318))
			GameTooltip:Show()
		end)
		tooltipFrame:SetScript("OnLeave", onControlLeave)
		proxAnchor.tooltip = tooltipFrame

		local bg = proxAnchor:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(proxAnchor)
		bg:SetColorTexture(0, 0, 0, 0.3)
		proxAnchor.background = bg

		local close = CreateFrame("Button", nil, proxAnchor)
		close:SetPoint("BOTTOMRIGHT", proxAnchor, "TOPRIGHT", -2, 2)
		close:SetHeight(16)
		close:SetWidth(16)
		close.tooltipHeader = L.close
		close.tooltipText = L.closeProximityDesc
		close:SetScript("OnEnter", onControlEnter)
		close:SetScript("OnLeave", onControlLeave)
		close:SetScript("OnClick", function()
			BigWigs:Print(L.toggleDisplayPrint)
			customProximityOpen, customProximityTarget, customProximityReverse = nil, nil, nil
			plugin:Close(true)
		end)
		close:SetNormalTexture("Interface\\AddOns\\BigWigs\\Media\\Icons\\close")
		proxAnchor.close = close

		local sound = CreateFrame("Button", nil, proxAnchor)
		sound:SetPoint("BOTTOMLEFT", proxAnchor, "TOPLEFT", 2, 2)
		sound:SetHeight(16)
		sound:SetWidth(16)
		sound.tooltipHeader = L.toggleSound
		sound.tooltipText = L.toggleSoundDesc
		sound:SetScript("OnEnter", onControlEnter)
		sound:SetScript("OnLeave", onControlLeave)
		sound:SetScript("OnClick", function()
			db.sound = not db.sound
			updateSoundButton()
		end)
		proxAnchor.sound = sound

		local header = proxAnchor:CreateFontString(nil, "OVERLAY")
		header:SetFont(plugin:GetDefaultFont(10))
		header:SetShadowOffset(1, -1)
		header:SetTextColor(1,1,1,1)
		header:SetFormattedText(L_proximityTitle, 5, 3)
		header:SetPoint("BOTTOM", proxAnchor, "TOP", 0, 4)
		proxAnchor.title = header
		proxTitle = header

		local abilityName = proxAnchor:CreateFontString(nil, "OVERLAY")
		abilityName:SetFont(plugin:GetDefaultFont(12))
		abilityName:SetShadowOffset(1, -1)
		abilityName:SetTextColor(1,0.82,0,1)
		abilityName:SetFormattedText("|T136015:20:20:-5:0:64:64:4:60:4:60|t%s", L.proximity_name) -- Interface\\Icons\\spell_nature_chainlightning
		abilityName:SetPoint("BOTTOM", header, "TOP", 0, 4)
		proxAnchor.ability = abilityName

		local text = proxAnchor:CreateFontString(nil, "OVERLAY")
		text:SetShadowOffset(1, -1)
		text:SetPoint("CENTER", proxAnchor, "CENTER")
		proxAnchor.text = text

		local drag = CreateFrame("Frame", nil, proxAnchor)
		drag.frame = proxAnchor
		drag:SetWidth(16)
		drag:SetHeight(16)
		drag:SetPoint("BOTTOMRIGHT", proxAnchor, -1, 1)
		drag:EnableMouse(true)
		drag:SetScript("OnMouseDown", OnDragHandleMouseDown)
		drag:SetScript("OnMouseUp", OnDragHandleMouseUp)
		proxAnchor.drag = drag

		local tex = drag:CreateTexture(nil, "OVERLAY")
		tex:SetTexture("Interface\\AddOns\\BigWigs\\Media\\Icons\\draghandle")
		tex:SetWidth(16)
		tex:SetHeight(16)
		tex:SetBlendMode("ADD")
		tex:SetPoint("CENTER", drag)

		plugin:RestyleWindow()

		proxAnchor:Hide()

		proxAnchor:SetScript("OnEvent", function(_, event)
			if event == "GROUP_ROSTER_UPDATE" then
				updateUnits()
				--if not db.textMode then
					--updateBlipColors()
				--end
			--else
				--updateBlipIcons()
			end
		end)

		plugin:SendMessage("BigWigs_FrameCreated", proxAnchor, "Proximity")
	end

	function plugin:OnPluginEnable()
		if createAnchor then createAnchor() createAnchor = nil end

		self:RegisterMessage("BigWigs_ShowProximity")
		self:RegisterMessage("BigWigs_HideProximity", "BigWigs_OnBossDisable")
		self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_OnBossDisable")
		self:RegisterMessage("BigWigs_OnBossDisable")

		self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
		updateProfile()
	end
end

function plugin:OnPluginDisable()
	customProximityOpen, customProximityTarget, customProximityReverse = nil, nil, nil
	self:Close(true)
end

-------------------------------------------------------------------------------
-- Options
--

--do
--	local disabled = function() return plugin.db.profile.disabled end
--	plugin.pluginOptions = {
--		name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Proximity:20|t ".. L.proximity_name,
--		type = "group",
--		order = 13,
--		get = function(info)
--			local key = info[#info]
--			if key == "font" then
--				for i, v in next, media:List(FONT) do
--					if v == db.fontName then return i end
--				end
--			elseif key == "soundName" then
--				for i, v in next, media:List(SOUND) do
--					if v == db.soundName then return i end
--				end
--			else
--				return db[key]
--			end
--		end,
--		set = function(info, value)
--			local key = info[#info]
--			if key == "font" then
--				db.fontName = media:List(FONT)[value]
--			elseif key == "soundName" then
--				db.soundName = media:List(SOUND)[value]
--			else
--				db[key] = value
--			end
--			plugin:RestyleWindow()
--		end,
--		args = {
--			disabled = {
--				type = "toggle",
--				name = L.disabled,
--				desc = L.disabledDisplayDesc,
--				order = 1,
--			},
--			lock = {
--				type = "toggle",
--				name = L.lock,
--				desc = L.lockDesc,
--				order = 2,
--				disabled = disabled,
--			},
--			font = {
--				type = "select",
--				name = L.font,
--				order = 3,
--				values = media:List(FONT),
--				width = "full",
--				itemControl = "DDI-Font",
--			},
--			fontSize = {
--				type = "range",
--				name = L.fontSize,
--				desc = L.fontSizeDesc,
--				order = 4,
--				max = 200,
--				min = 8,
--				softMax = 40,
--				step = 1,
--				width = "full",
--			},
--			soundName = {
--				type = "select",
--				name = L.sound,
--				order = 5,
--				values = media:List(SOUND),
--				width = "full",
--				itemControl = "DDI-Sound"
--				--disabled = disabled,
--			},
--			soundDelay = {
--				type = "range",
--				name = L.soundDelay,
--				desc = L.soundDelayDesc,
--				order = 6,
--				max = 10,
--				min = 1,
--				step = 1,
--				width = "full",
--				disabled = disabled,
--			},
--			showHide = {
--				type = "group",
--				name = L.showHide,
--				inline = true,
--				order = 7,
--				get = function(info)
--					local key = info[#info]
--					return db.objects[key]
--				end,
--				set = function(info, value)
--					local key = info[#info]
--					db.objects[key] = value
--					plugin:RestyleWindow()
--				end,
--				disabled = disabled,
--				args = {
--					title = {
--						type = "toggle",
--						name = L.title,
--						desc = L.titleDesc,
--						order = 1,
--					},
--					background = {
--						type = "toggle",
--						name = L.background,
--						desc = L.backgroundDesc,
--						order = 2,
--					},
--					sound = {
--						type = "toggle",
--						name = L.soundButton,
--						desc = L.soundButtonDesc,
--						order = 3,
--					},
--					close = {
--						type = "toggle",
--						name = L.closeButton,
--						desc = L.closeButtonDesc,
--						order = 4,
--					},
--					ability = {
--						type = "toggle",
--						name = L.abilityName,
--						desc = L.abilityNameDesc,
--						order = 5,
--					},
--					tooltip = {
--						type = "toggle",
--						name = L.tooltip,
--						desc = L.tooltipDesc,
--						order = 6,
--					},
--				},
--			},
--			exactPositioning = {
--				type = "group",
--				name = L.positionExact,
--				order = 8,
--				inline = true,
--				args = {
--					posx = {
--						type = "range",
--						name = L.positionX,
--						desc = L.positionDesc,
--						min = -2048,
--						max = 2048,
--						step = 1,
--						order = 1,
--						width = "full",
--					},
--					posy = {
--						type = "range",
--						name = L.positionY,
--						desc = L.positionDesc,
--						min = -2048,
--						max = 2048,
--						step = 1,
--						order = 2,
--						width = "full",
--					},
--				},
--			},
--			reset = {
--				type = "execute",
--				name = L.resetAll,
--				desc = L.resetProximityDesc,
--				func = function()
--					plugin.db:ResetProfile()
--				end,
--				order = 9,
--			},
--		},
--	}
--end

-------------------------------------------------------------------------------
-- Events
--

do
	local opener = nil
	function plugin:BigWigs_ShowProximity(event, module, range, ...)
		if db.disabled or type(range) ~= "number" then return end
		opener = module
		self:Open(range, module, ...)
	end

	function plugin:BigWigs_OnBossDisable(event, module)
		if module ~= opener then return end
		if event == "BigWigs_OnBossDisable" then -- Fully close on a boss win/disable
			customProximityOpen, customProximityTarget, customProximityReverse = nil, nil, nil
			self:Close(true)
		else -- Reopen custom proximity when a spell ends or on a boss wipe
			self:Close()
		end
	end
end

-------------------------------------------------------------------------------
-- API
--

function plugin:Close(noReopen)
	functionToFire = nil
	self:CancelTimer(updateTimer)
	updateTimer = nil

	proxAnchor:UnregisterEvent("GROUP_ROSTER_UPDATE")
	proxAnchor:UnregisterEvent("RAID_TARGET_UPDATE")

	for k,v in next, blipList do
		if v.isShown then
			v.isShown = nil
			v:Hide()
		end
	end

	activeRange = setRange(0)
	activeSpellID = nil
	proximityPlayer = nil
	proximityPlayerTable = {}

	proxTitle:SetFormattedText(L_proximityTitle, 5, 3)
	proxAnchor.ability:SetFormattedText("|T136015:20:20:-5:0:64:64:4:60:4:60|t%s", L.proximity_name) -- Interface\\Icons\\spell_nature_chainlightning
	-- Just in case we were the last target of configure mode, reset the background color.
	proxAnchor.background:SetColorTexture(0, 0, 0, 0.3)
	proxAnchor:Hide()
	if not noReopen and customProximityOpen then
		self:Open(customProximityOpen, nil, nil, customProximityTarget, customProximityReverse)
	end
end

do
	local function openProx(self, range, module, key, player, isReverse, spellName, spellIcon)
		-- Update the ability name display
		if module and key then
			self:Close(true) -- Not a custom range, close

			if spellName then
				proxAnchor.ability:SetFormattedText("|T%s:20:20:-5:0:64:64:4:60:4:60|t%s", spellIcon, spellName)
			else
				local _, name, _, icon = BigWigs:GetBossOptionDetails(module, key)
				if type(icon) == "string" then
					proxAnchor.ability:SetFormattedText("|T%s:20:20:-5:0:64:64:4:60:4:60|t%s", icon, name)
				else
					proxAnchor.ability:SetText(name)
				end
			end
		else
			proxAnchor.ability:SetText(L.customRange)
		end

		myGUID = plugin:UnitGUID("player")
		activeRange = setRange(range)

		proxAnchor:RegisterEvent("GROUP_ROSTER_UPDATE")
		updateUnits()

		proxAnchor.text:SetText("")
		proxAnchor.text:Show()

		if not player and not isReverse then
			functionToFire = normalProximityText
		elseif player then
			if type(player) == "table" then
				for i = 1, #player do
					for j = 1, GetNumGroupMembers() do
						if UnitIsUnit(player[i], unitList[j]) then
							proximityPlayerTable[#proximityPlayerTable+1] = unitList[j]
							break
						end
					end
				end
				if isReverse then
					functionToFire = reverseMultiTargetProximityText
				else
					functionToFire = multiTargetProximityText
				end
			else
				for i = 1, GetNumGroupMembers() do
					-- Only set the function if we found the unit
					if UnitIsUnit(player, unitList[i]) then
						proximityPlayer = unitList[i]
						functionToFire = isReverse and reverseTargetProximityText or targetProximityText
						break
					end
				end
			end
		elseif isReverse then
			functionToFire = reverseProximityText
		end

		if not functionToFire then
			self:Close()
			return
		end

		if spellName and key > 0 then -- GameTooltip doesn't do "journal" hyperlinks
			activeSpellID = key
		else
			activeSpellID = nil
		end

		-- Start the show!
		proxAnchor:Show()
		functionToFire()
	end

	function plugin:Open(range, module, key, player, isReverse, spellName, spellIcon)
		if type(range) ~= "number" then BigWigs:Print("Proximity range needs to be a number!") return end
		if not IsInGroup() then return end -- Solo runs of old content

		functionToFire = nil -- Kill previous updater
		self:CancelTimer(updateTimer)
		updateTimer = self:ScheduleTimer(openProx, 0.1, self, range, module, key, player, isReverse, spellName, spellIcon)
	end
end

-------------------------------------------------------------------------------
-- Slash command
--

SlashCmdList.BigWigs_Proximity = function(input)
	if not plugin:IsEnabled() then BigWigs:Enable() end
	input = input:lower()
	local range, reverse = input:match("^(%d+)%s*(%S*)$")
	range = tonumber(range)
	if not range then
		BigWigs:Print("Usage: /proximity 1-100 [true]") -- XXX translate
	else
		if range > 0 then
			plugin:Close(true)
			customProximityOpen = range
			customProximityTarget = nil
			customProximityReverse = reverse == "true"
			plugin:Open(range, nil, nil, nil, customProximityReverse)
		else
			customProximityOpen, customProximityTarget, customProximityReverse = nil, nil, nil
			plugin:Close(true)
		end
	end
end

SLASH_BigWigs_Proximity1 = "/proximity"
SLASH_BigWigs_Proximity2 = "/range"
