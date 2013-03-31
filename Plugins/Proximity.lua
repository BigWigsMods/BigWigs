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
local activeRange = nil
local activeSpellID = nil
local activeMap = nil
local proximityPlayer = nil
local proximityPlayerTable = {}
local maxPlayers = 0
local raidList = {}
local blipList = {}
local anchor = nil

--Radial upvalues
local GetPlayerMapPosition = GetPlayerMapPosition
local GetCurrentMapDungeonLevel = GetCurrentMapDungeonLevel
local GetPlayerFacing = GetPlayerFacing
local format = string.format
local GetRaidTargetIndex = GetRaidTargetIndex
local UnitIsDead = UnitIsDead
local UnitIsUnit = UnitIsUnit
local GetTime = GetTime
local min = math.min
local pi = math.pi
local cos = math.cos
local sin = math.sin
local SetMapToCurrentZone = BigWigsLoader.SetMapToCurrentZone

local OnOptionToggled = nil -- Function invoked when the proximity option is toggled on a module.

-------------------------------------------------------------------------------
-- Map Data
--

-- Copied from LibMapData-1.0 (All Rights Reserved) with permission from kagaro
local mapData = {
	--[[ Testing ]]--
	StormwindCity = {
		{ 1737.4999589920044,1158.3330078125 },
	},
	Orgrimmar = {
		{ 1739.375,1159.58349609375 },
	},

	--[[ Classic ]]--
	MoltenCore = {
		{ 1264.800064086914,843.1990661621094 },
	},
	BlackwingLair = {
		{ 499.42803955078125,332.94970703125 },
		{ 649.4270629882812,432.94970703125 },
		{ 649.4270629882812,432.94970703125 },
		{ 649.4270629882812,432.94970703125 },
	},
	RuinsofAhnQiraj = {
		{ 2512.4998779296875,1675.0 },
	},
	AhnQiraj = {
		{ 2777.5441131591797,1851.6962890625 },
		{ 977.5599365234375,651.70654296875 },
		{ 577.56005859375,385.0400390625 },
	},

	--[[ The Burning Crusade ]]--
	GruulsLair = {
		{ 525.0,350.0 },
	},
	Karazhan = {
		{ 550.048828125,366.69921875 },
		{ 257.85986328125,171.90625 },
		{ 345.1494140625,230.099609375 },
		{ 520.048828125,346.69921875 },
		{ 234.14990234375,156.099609375 },
		{ 581.548828125,387.69921875 },
		{ 191.548828125,127.69921875 },
		{ 139.3505859375,92.900390625 },
		{ 760.048828125,506.69921875 },
		{ 450.25,300.166015625 },
		{ 271.050048828125,180.69921875 },
		{ 595.048828125,396.69921875 },
		{ 529.048828125,352.69921875 },
		{ 245.25,163.5 },
		{ 211.14990234375,140.765625 },
		{ 101.25,67.5 },
		{ 341.25,227.5 },
	},
	CoilfangReservoir = {
		{ 1575.0029754638672,1050.0020141601562 },
	},
	TempestKeep = {
		{ 1575.0,1050.0 },
	},
	BlackTemple = {
		{ 1252.2495784759521,834.8330078125 },
		{ 975.0,650.0 },
		{ 1005.0,670.0 },
		{ 440.0009765625,293.333984375 },
		{ 670.0,446.66668701171875 },
		{ 705.0,470.0 },
		{ 355.0,236.6666259765625 },
	},
	CoTMountHyjal = {
		{ 2499.999755859375,1666.66650390625 }
	},
	MagtheridonsLair = {
		{ 556.0,370.6666946411133 }
	},
	SunwellPlateau = {
		{ 906.25,604.1666259765625 },
		{ 465.0,310.0 },
	},

	--[[ Wrath of the Lich King ]]--
	VaultofArchavon = {
		{ 1398.2550048828125,932.1700134277344 },
	},
	TheEyeofEternity = {
		{ 430.070068359375,286.7130126953125 },
	},
	Naxxramas = {
		{ 1093.830078125,729.219970703125 },
		{ 1093.830078125,729.219970703125 },
		{ 1200.0,800.0 },
		{ 1200.330078125,800.219970703125 },
		{ 2069.809814453125,1379.8798828125 },
		{ 655.93994140625,437.2900390625 },
	},
	TheObsidianSanctum = {
		{ 1162.4999179840088,775.0 },
	},
	Ulduar = {
		{ 3287.4998779296875,2191.6666259765625 },
		{ 669.4509887695312,446.300048828125 },
		{ 1328.4609985351562,885.639892578125 },
		{ 910.5,607.0 },
		{ 1569.4599609375,1046.300048828125 },
		{ 619.468994140625,412.97998046875 },
	},
	TheArgentColiseum = {
		{ 369.9861869812012,246.65798950195312 },
		{ 739.9960174560547,493.33001708984375 },
	},
	IcecrownCitadel = {
		{ 1355.4700927734375,903.6470336914062 },
		{ 1067.0,711.3336906433105 },
		{ 195.469970703125,130.31500244140625 },
		{ 773.7100830078125,515.810302734375 },
		{ 1148.739990234375,765.820068359375 },
		{ 373.7099609375,249.1298828125 },
		{ 293.260009765625,195.50701904296875 },
		{ 247.929931640625,165.28799438476562 },
	},
	OnyxiasLair = {
		{ 483.1179885864258,322.0787887573242 },
	},
	TheRubySanctum = {
		{ 752.0833129882812,502.083251953125 },
	},

	--[[ Cataclysm ]]--
	TheBastionofTwilight = {
		{ 1078.3349990844727,718.8899841308594 },
		{ 778.343017578125,518.8949584960938 },
		{ 1042.342025756836,694.8949584960938 },
	},
	BaradinHold = {
		{ 585.0,390.0 },
	},
	BlackwingDescent = {
		{ 849.6940155029297,566.4623410701752 },
		{ 999.6929779052734,666.4620056152344 },
	},
	ThroneoftheFourWinds = {
		{ 1500.0,1000.0 },
	},
	Firelands = {
		{ 1587.4999389648438,1058.3332824707031 },
		{ 375.0,250.0 },
		{ 1440.0,960.0 },
	},
	DragonSoul = {
		{ 3106.70849609375,2063.065185546875 },
		{ 397.5,265.0 },
		{ 427.5,285.0 },
		{ 185.19921875,123.466796875 },
		{ 1.5,1.0 },
		{ 1.5,1.0 },
		{ 1108.3515625,738.900390625 },
	},

	--[[ Mists of Pandaria ]]--
	HeartofFear = {
		{ 700.0,466.666748046875 },
		{ 1440.0043802261353,960.0029296875 },
	},
	MogushanVaults = {
		{ 687.509765625,458.33984375 },
		{ 432.509765625,288.33984375 },
		{ 750.0,500.0 },
	},
	TerraceOfEndlessSpring = {
		{ 702.083984375,468.75 },
	},
	ThunderKingRaid = {
		{ 1285.0,856.6669921875 },
		{ 1550.009765625,1033.33984375 },
		{ 1030.0,686.6669921875 },
		{ 591.280029296875,394.18701171875 },
		{ 1030.0,686.6669921875 },
		{ 910.0,606.6669921875 },
		{ 810.0,540.0 },
		{ 617.5,411.6669921875 },
	},
	IsleoftheThunderKing = {
		{ 4135.2816551249,2756.2332535822 },
		{ 362.0,241.3330078125 },
	},
	IsleOfGiants = {
		{ 1787.5009765625,1191.666015625 },
	},
	KunLaiSummit = {
		{ 6258.3330078125,4172.9169921875 },
	},
}

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

local testDots
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

function plugin:RestyleWindow()
	updateSoundButton()
	for k, v in next, db.objects do
		if anchor[k] then
			if v then
				anchor[k]:Show()
			else
				anchor[k]:Hide()
			end
		end
	end
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

local updater, updaterFrame = nil, nil
local normalProximity, reverseTargetProximity, targetProximity, multiTargetProximity
do
	local lastplayed = 0 -- When we last played an alarm sound for proximity.

	-- dx and dy are in yards
	-- class is player class
	-- facing is radians with 0 being north, counting up clockwise
	local setDot = function(dx, dy, blip)
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

		blip:ClearAllPoints()
		-- Clamp to frame if out-of-bounds, mainly for reverse proximity
		if x < -(width / 2) then
			x = -(width / 2)
		elseif x > (width / 2) then
			x = (width / 2)
		end
		if y < -(height / 2) then
			y = -(height / 2)
		elseif y > (height / 2) then
			y = (height / 2)
		end
		blip:SetPoint("CENTER", anchor, "CENTER", x, y)
		if not blip.isShown then
			blip.isShown = true
			blip:Show()
		end
	end

	testDots = function()
		for i = 1, 40 do
			blipList[raidList[i]].isShown = nil
			blipList[raidList[i]]:Hide()
		end

		setDot(10, 10, blipList["raid1"])
		setDot(5, 0, blipList["raid2"])
		setDot(3, 10, blipList["raid3"])
		setDot(-9, -7, blipList["raid4"])
		setDot(0, 10, blipList["raid5"])
		local width, height = anchor:GetWidth(), anchor:GetHeight()
		local pixperyard = min(width, height) / 30
		anchor.rangeCircle:SetSize(pixperyard * 20, pixperyard * 20)
		anchor.rangeCircle:SetVertexColor(1,0,0)
		anchor.rangeCircle:Show()
		anchor.playerDot:Show()
	end

	function normalProximity()
		local srcX, srcY = GetPlayerMapPosition("player")
		if srcX == 0 and srcY == 0 then
			SetMapToCurrentZone()
			srcX, srcY = GetPlayerMapPosition("player")
		end

		local currentFloor = GetCurrentMapDungeonLevel()
		if currentFloor == 0 then currentFloor = 1 end
		local id = activeMap[currentFloor]

		if not id then
			print("No floor id, closing proximity.")
			plugin:Close()
			return
		end

		local anyoneClose = 0

		for i = 1, maxPlayers do
			local n = raidList[i]
			local unitX, unitY = GetPlayerMapPosition(n)
			local dx = (unitX - srcX) * id[1]
			local dy = (unitY - srcY) * id[2]
			local range = (dx * dx + dy * dy) ^ 0.5
			if range < (activeRange * 1.5) then
				if not UnitIsUnit("player", n) and not UnitIsDead(n) then
					setDot(dx, dy, blipList[n])
					if range <= activeRange*1.1 then -- add 10% because of mapData inaccuracies, e.g. 6 yards actually testing for 5.5 on chimaeron = ouch
						anyoneClose = anyoneClose + 1
					end
				elseif blipList[n].isShown then -- A unit may die next to us
					blipList[n]:Hide()
					blipList[n].isShown = nil
				end
			elseif blipList[n].isShown then
				blipList[n]:Hide()
				blipList[n].isShown = nil
			end
		end

		anchor.title:SetFormattedText(L.proximityTitle, activeRange, anyoneClose)

		if anyoneClose == 0 then
			anchor.rangeCircle:SetVertexColor(0, 1, 0)
		else
			anchor.rangeCircle:SetVertexColor(1, 0, 0)
			if not db.sound then return end
			local t = GetTime()
			if t > (lastplayed + db.soundDelay) and not UnitIsDead("player") and InCombatLockdown() then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", db.soundName, true)
			end
		end
	end

	function targetProximity()
		local srcX, srcY = GetPlayerMapPosition("player")
		if srcX == 0 and srcY == 0 then
			SetMapToCurrentZone()
			srcX, srcY = GetPlayerMapPosition("player")
		end

		local currentFloor = GetCurrentMapDungeonLevel()
		if currentFloor == 0 then currentFloor = 1 end
		local id = activeMap[currentFloor]

		if not id then
			print("No floor id, closing proximity.")
			plugin:Close()
			return
		end

		local unitX, unitY = GetPlayerMapPosition(proximityPlayer)
		local dx = (unitX - srcX) * id[1]
		local dy = (unitY - srcY) * id[2]
		local range = (dx * dx + dy * dy) ^ 0.5
		setDot(dx, dy, blipList[proximityPlayer])
		if range <= activeRange*1.1 then -- add 10% because of mapData inaccuracies, e.g. 6 yards actually testing for 5.5 on chimaeron = ouch
			anchor.rangeCircle:SetVertexColor(1, 0, 0)
			local t = GetTime()
			if t > (lastplayed + 1) then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", db.soundName, true)
			end
			anchor.title:SetFormattedText(L.proximityTitle, activeRange, 1)
		else
			anchor.rangeCircle:SetVertexColor(0, 1, 0)
			anchor.title:SetFormattedText(L.proximityTitle, activeRange, 0)
		end
	end

	function multiTargetProximity()
		local srcX, srcY = GetPlayerMapPosition("player")
		if srcX == 0 and srcY == 0 then
			SetMapToCurrentZone()
			srcX, srcY = GetPlayerMapPosition("player")
		end

		local currentFloor = GetCurrentMapDungeonLevel()
		if currentFloor == 0 then currentFloor = 1 end
		local id = activeMap[currentFloor]

		if not id then
			print("No floor id, closing proximity.")
			plugin:Close()
			return
		end

		local anyoneClose = 0

		for i = 1, #proximityPlayerTable do
			local player = proximityPlayerTable[i]
			local unitX, unitY = GetPlayerMapPosition(player)
			local dx = (unitX - srcX) * id[1]
			local dy = (unitY - srcY) * id[2]
			local range = (dx * dx + dy * dy) ^ 0.5
			setDot(dx, dy, blipList[player])
			if range <= activeRange*1.1 then -- add 10% because of mapData inaccuracies, e.g. 6 yards actually testing for 5.5 on chimaeron = ouch
				anyoneClose = anyoneClose + 1
			end
		end

		anchor.title:SetFormattedText(L.proximityTitle, activeRange, anyoneClose)

		if anyoneClose == 0 then
			anchor.rangeCircle:SetVertexColor(0, 1, 0)
		else
			anchor.rangeCircle:SetVertexColor(1, 0, 0)
			local t = GetTime()
			if t > (lastplayed + 1) then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", db.soundName, true)
			end
		end
	end

	function reverseTargetProximity()
		local srcX, srcY = GetPlayerMapPosition("player")
		if srcX == 0 and srcY == 0 then
			SetMapToCurrentZone()
			srcX, srcY = GetPlayerMapPosition("player")
		end

		local currentFloor = GetCurrentMapDungeonLevel()
		if currentFloor == 0 then currentFloor = 1 end
		local id = activeMap[currentFloor]

		if not id then
			print("No floor id, closing proximity.")
			plugin:Close()
			return
		end

		local unitX, unitY = GetPlayerMapPosition(proximityPlayer)
		local dx = (unitX - srcX) * id[1]
		local dy = (unitY - srcY) * id[2]
		local range = (dx * dx + dy * dy) ^ 0.5
		setDot(dx, dy, blipList[proximityPlayer])
		if range <= activeRange then
			anchor.rangeCircle:SetVertexColor(0, 1, 0)
			anchor.title:SetFormattedText(L.proximityTitle, activeRange, 1)
		else
			anchor.rangeCircle:SetVertexColor(1, 0, 0)
			local t = GetTime()
			if t > (lastplayed + 1) then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", db.soundName, true)
			end
			anchor.title:SetFormattedText(L.proximityTitle, activeRange, 0)
		end
	end

	updaterFrame = CreateFrame("Frame")
	updater = updaterFrame:CreateAnimationGroup()
	updater:SetLooping("REPEAT")
	local anim = updater:CreateAnimation()
	anim:SetDuration(0.05)
end

local function updateBlipIcons()
	for i = 1, maxPlayers do
		local n = raidList[i]
		local blip = blipList[n]
		local icon = GetRaidTargetIndex(n)
		if icon then
			blip:SetTexture(format("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_%d.blp", icon))
			blip:SetDrawLayer("OVERLAY", 1)
			blip.hasIcon = true
		elseif blip.hasIcon then
			blip.hasIcon = nil
			blip:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\blip")
			local _, class = UnitClass(n)
			if class then
				local c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
				blip:SetVertexColor(c.r, c.g, c.b)
			else
				blip:SetVertexColor(0.5, 0.5, 0.5) -- Gray if UnitClass returns nil
			end
			blip:SetDrawLayer("OVERLAY", 0)
		end
	end
end

local function updateBlipColors()
	maxPlayers = GetNumGroupMembers()
	for i = 1, maxPlayers do
		local n = raidList[i]
		if not GetRaidTargetIndex(n) then
			local blip = blipList[n]
			blip:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\blip")
			local _, class = UnitClass(n)
			if class then
				local c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
				blip:SetVertexColor(c.r, c.g, c.b)
			else
				blip:SetVertexColor(0.5, 0.5, 0.5) -- Gray if UnitClass returns nil
			end
			blip:SetDrawLayer("OVERLAY", 0)
		end
	end
end

local function updateProfile()
	db = plugin.db.profile

	if anchor then
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

		plugin:RestyleWindow()
	end

	if not db.font then
		db.font = media:GetDefault("font")
	end
	if not db.fontSize then
		local _, size = GameFontNormalHuge:GetFont()
		db.fontSize = size
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
	BigWigs:RegisterBossOption("proximity", L["proximity"], L["proximity_desc"], OnOptionToggled, "Interface\\Icons\\ability_hunter_pathfinding")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	updateProfile()
end

do
	local createAnchor = function()
		anchor = CreateFrame("Frame", "BigWigsProximityAnchor", UIParent)
		anchor:SetWidth(db.width or plugin.defaultDB.width)
		anchor:SetHeight(db.height or plugin.defaultDB.height)
		anchor:SetMinResize(100, 30)
		anchor:SetClampedToScreen(true)
		anchor:EnableMouse(true)
		anchor:SetScript("OnEnter", onDisplayEnter)
		anchor:SetScript("OnLeave", onControlLeave)
		local bg = anchor:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(anchor)
		bg:SetBlendMode("BLEND")
		bg:SetTexture(0, 0, 0, 0.3)
		anchor.background = bg

		local close = CreateFrame("Button", nil, anchor)
		close:SetPoint("BOTTOMRIGHT", anchor, "TOPRIGHT", -2, 2)
		close:SetHeight(16)
		close:SetWidth(16)
		close.tooltipHeader = L["Close"]
		close.tooltipText = L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."]
		close:SetNormalTexture("Interface\\AddOns\\BigWigs\\Textures\\icons\\close")
		anchor.close = close

		local sound = CreateFrame("Button", nil, anchor)
		sound:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 2, 2)
		sound:SetHeight(16)
		sound:SetWidth(16)
		sound.tooltipHeader = L["Toggle sound"]
		sound.tooltipText = L["Toggle whether or not the proximity window should beep when you're too close to another player."]
		anchor.sound = sound

		local header = anchor:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		header:SetFormattedText(L.proximityTitle, 5, 3)
		header:SetPoint("BOTTOM", anchor, "TOP", 0, 4)
		anchor.title = header

		local abilityName = anchor:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		abilityName:SetFormattedText("|TInterface\\Icons\\spell_nature_chainlightning:20:20:-5:0:64:64:4:60:4:60|t%s", L["Ability name"])
		abilityName:SetPoint("BOTTOM", header, "TOP", 0, 4)
		anchor.ability = abilityName

		local rangeCircle = anchor:CreateTexture(nil, "ARTWORK")
		rangeCircle:SetPoint("CENTER")
		rangeCircle:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\alert_circle")
		rangeCircle:SetBlendMode("ADD")
		anchor.rangeCircle = rangeCircle

		local playerDot = anchor:CreateTexture(nil, "OVERLAY")
		playerDot:SetSize(32, 32)
		playerDot:SetTexture("Interface\\Minimap\\MinimapArrow")
		playerDot:SetBlendMode("ADD")
		playerDot:SetPoint("CENTER")
		anchor.playerDot = playerDot

		local drag = CreateFrame("Frame", nil, anchor)
		drag.frame = anchor
		drag:SetFrameLevel(anchor:GetFrameLevel() + 10) -- place this above everything
		drag:SetWidth(16)
		drag:SetHeight(16)
		drag:SetPoint("BOTTOMRIGHT", anchor, -1, 1)
		drag:EnableMouse(true)
		drag:SetScript("OnMouseDown", OnDragHandleMouseDown)
		drag:SetScript("OnMouseUp", OnDragHandleMouseUp)
		drag:SetAlpha(0.5)
		anchor.drag = drag

		local tex = drag:CreateTexture(nil, "OVERLAY")
		tex:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\draghandle")
		tex:SetWidth(16)
		tex:SetHeight(16)
		tex:SetBlendMode("ADD")
		tex:SetPoint("CENTER", drag)

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

		plugin:RestyleWindow()

		anchor:Hide()

		for i = 1, 40 do
			local n = format("raid%d", i)
			raidList[i] = n
			blipList[n] = anchor:CreateTexture(nil, "OVERLAY")
			blipList[n]:SetSize(16, 16)
			blipList[n]:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\blip")
		end

		updaterFrame:SetScript("OnEvent", function(_, event)
			if event == "GROUP_ROSTER_CHANGED" then
				updateBlipColors()
			else
				updateBlipIcons()
			end
		end)
	end

	function plugin:OnPluginEnable()
		if createAnchor then createAnchor() createAnchor = nil end

		self:RegisterMessage("BigWigs_ShowProximity")
		self:RegisterMessage("BigWigs_HideProximity", "Close")
		self:RegisterMessage("BigWigs_OnBossDisable")

		self:RegisterMessage("BigWigs_StartConfigureMode")
		self:RegisterMessage("BigWigs_StopConfigureMode")
		self:RegisterMessage("BigWigs_SetConfigureTarget")
		self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
		self:RegisterMessage("BigWigs_ResetPositions", resetAnchor)
	end
end

function plugin:OnPluginDisable()
	self:Close()
end

-------------------------------------------------------------------------------
-- Options
--

function plugin:BigWigs_StartConfigureMode()
	if anchor:IsShown() then
		print("Cannot enter configure mode whilst proximity is active.")
		return
	end
	inConfigMode = true
	self:Test()
end

function plugin:BigWigs_StopConfigureMode()
	inConfigMode = nil
	self:Close()
end

function plugin:BigWigs_SetConfigureTarget(event, module)
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
	function plugin:BigWigs_ShowProximity(event, module, range, ...)
		if db.disabled or type(range) ~= "number" then return end
		opener = module
		self:Open(range, module, ...)
	end

	function plugin:BigWigs_OnBossDisable(event, module, optionKey)
		if module ~= opener then return end
		self:Close()
	end
end

-------------------------------------------------------------------------------
-- API
--

function plugin:GetMapData()
	return mapData
end

function plugin:Close()
	updater:Stop()

	updaterFrame:UnregisterEvent("GROUP_ROSTER_CHANGED")
	updaterFrame:UnregisterEvent("RAID_TARGET_UPDATE")

	for i = 1, 40 do
		if blipList[raidList[i]].isShown then
			blipList[raidList[i]].isShown = nil
			blipList[raidList[i]]:Hide()
		end
	end

	activeRange = nil
	activeSpellID = nil
	activeMap = nil
	proximityPlayer = nil
	wipe(proximityPlayerTable)

	anchor.title:SetFormattedText(L.proximityTitle, 5, 3)
	anchor.ability:SetFormattedText("|TInterface\\Icons\\spell_nature_chainlightning:20:20:-5:0:64:64:4:60:4:60|t%s", L["Ability name"])
	-- Just in case we were the last target of
	-- configure mode, reset the background color.
	anchor.background:SetTexture(0, 0, 0, 0.3)
	anchor:Hide()
end

local abilityNameFormat = "|T%s:20:20:-5|t%s"
function plugin:Open(range, module, key, player, isReverse)
	if type(range) ~= "number" then print("Range needs to be a number!") return end
	if not IsInRaid() and not IsInGroup() then return end -- Solo runs of old content?
	self:Close()

	SetMapToCurrentZone()
	local mapName = GetMapInfo()
	activeMap = mapData[mapName]
	if not activeMap then print("No map data!") return end

	if not player and not isReverse then
		updater:SetScript("OnLoop", normalProximity)
		makeThingsWork()
	elseif player then
		breakThings()
		if type(player) == "table" then
			for i = 1, #player do
				for j = 1, GetNumGroupMembers() do
					if UnitIsUnit(player[i], raidList[j]) then
						proximityPlayerTable[#proximityPlayerTable+1] = raidList[j]
						break
					end
				end
			end
			updater:SetScript("OnLoop", multiTargetProximity)
		else
			for i = 1, GetNumGroupMembers() do
				if UnitIsUnit(player, raidList[i]) then
					proximityPlayer = raidList[i]
					break
				end
			end
			if isReverse then
				updater:SetScript("OnLoop", reverseTargetProximity)
			else
				updater:SetScript("OnLoop", targetProximity)
			end
		end
	else
		print("Current range functionality not implemented, aborting.")
		return
	end
	activeRange = range

	updaterFrame:RegisterEvent("GROUP_ROSTER_CHANGED")
	updaterFrame:RegisterEvent("RAID_TARGET_UPDATE")
	updateBlipColors()
	updateBlipIcons()

	local width, height = anchor:GetWidth(), anchor:GetHeight()
	local ppy = min(width, height) / (range * 3)
	anchor.rangeCircle:SetSize(ppy * range * 2, ppy * range * 2)

	-- Update the ability name display
	if module and key then
		local dbKey, name, desc, icon = BigWigs:GetBossOptionDetails(module, key)
		if type(icon) == "string" then
			anchor.ability:SetFormattedText("|T%s:20:20:-5:0:64:64:4:60:4:60|t%s", icon, name)
		else
			anchor.ability:SetText(name)
		end
	else
		anchor.ability:SetText(L["Custom range indicator"])
	end
	if type(key) == "number" and key > 0 then -- GameTooltip doesn't do "journal" hyperlinks
		activeSpellID = key
	else
		activeSpellID = nil
	end

	-- Start the show!
	anchor:Show()
	updater:Play()
end

function plugin:Test()
	-- Close ourselves in case we entered configure mode DURING a boss fight.
	self:Close()
	-- Break the sound+close buttons
	breakThings()
	testDots()
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
SLASH_BigWigs_Proximity2 = "/range"

