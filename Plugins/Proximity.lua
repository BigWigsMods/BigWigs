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
	font = nil,
	fontSize = nil,
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

local mute = "Interface\\AddOns\\BigWigs\\Textures\\icons\\mute"
local unmute = "Interface\\AddOns\\BigWigs\\Textures\\icons\\unmute"

local inConfigMode = nil
local activeRange, activeRangeRadius, activeRangeSquared, activeRangeSquaredTwoFive = 0, 0, 0, 0
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
local proxAnchor, proxTitle, proxCircle, proxPulseOut, proxPulseIn = nil, nil, nil, nil, nil

-- Upvalues
local CTimerAfter = BigWigsLoader.CTimerAfter
local GameTooltip = CreateFrame("GameTooltip", "BigWigsProximityTooltip", UIParent, "GameTooltipTemplate")
local UnitPosition, GetPlayerFacing = UnitPosition, GetPlayerFacing
local GetRaidTargetIndex, GetNumGroupMembers, GetTime = GetRaidTargetIndex, GetNumGroupMembers, GetTime
local IsInRaid, IsInGroup, InCombatLockdown = IsInRaid, IsInGroup, InCombatLockdown
local UnitIsDead, UnitIsUnit, UnitGUID, UnitClass, UnitInPhase = UnitIsDead, UnitIsUnit, UnitGUID, UnitClass, UnitInPhase
local min, cos, sin, format = math.min, math.cos, math.sin, string.format
local tinsert, tconcat = table.insert, table.concat
local next, type, tonumber, wipe = next, type, tonumber, wipe
local piDoubled = 6.2831853071796

local OnOptionToggled = nil -- Function invoked when the proximity option is toggled on a module.

-- GLOBALS: BigWigs CUSTOM_CLASS_COLORS GameTooltip GameFontNormalHuge RAID_CLASS_COLORS SLASH_BigWigs_Proximity1 SLASH_BigWigs_Proximity2 UIParent

--------------------------------------------------------------------------------
-- Range Checking
--

local setRange, isInRange
do
	local ranges = nil

	local function initRanges()
		ranges = {}

		local interactDistances = { [2] = 10, [4] = 30 }
		for index, range in next, interactDistances do
			ranges[range] = function(unit)
				return CheckInteractDistance(unit, index)
			end
		end

		local items	= {
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
		if activeRangeChecker then
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

local testDots, testText
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
	if not db.textMode then
		if inConfigMode then
			testDots()
		else
			local range = activeRange > 0 and activeRange or 10
			local pixperyard = min(width, height) / (range*3)
			local size = range*2*pixperyard
			proxCircle:SetSize(size, size)
			proxAnchor.rangePulse:SetSize(size, size)
		end
	end
end

local locked = nil
local function lockDisplay()
	if locked then return end
	if not inConfigMode then
		proxAnchor:EnableMouse(false) -- Keep enabled during config mode
	end
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
	proxAnchor.text:SetFont(media:Fetch("font", db.font), db.fontSize)
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
		proxAnchor:SetPoint("CENTER", UIParent, "CENTER", 400, 0)
	end
end

-------------------------------------------------------------------------------
-- Proximity Updater
--

local normalProximity, reverseTargetProximity, targetProximity, multiTargetProximity, reverseMultiTargetProximity, reverseProximity
local normalProximityText, reverseTargetProximityText, targetProximityText, multiTargetProximityText, reverseMultiTargetProximityText, reverseProximityText
do
	local lastplayed = 0 -- When we last played an alarm sound for proximity.

	-- dx and dy are in yards
	-- facing is radians with 0 being north, counting up clockwise
	local setDot = function(dx, dy, blip, width, height, playerSine, playerCosine, pixperyard)
		-- rotate relative to player facing
		local x = (-1 * dx * playerCosine) - (dy * playerSine)
		local y = (-1 * dx * playerSine) + (dy * playerCosine)

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
		blip:SetPoint("CENTER", proxAnchor, "CENTER", x, y)
		if not blip.isShown then
			blip.isShown = true
			blip:Show()
		end
	end

	testDots = function()
		local rotangle = piDoubled - GetPlayerFacing()
		local sine = sin(rotangle)
		local cosine = cos(rotangle)

		local width, height = db.width, db.height
		local pixperyard = min(width, height) / 30 -- divide by range * 3, using 10 for testing, 10*3=30
		local size = pixperyard * 20
		proxAnchor.rangePulse:SetSize(size, size)
		proxCircle:SetSize(size, size)
		proxCircle:SetVertexColor(1,0,0)

		setDot(10, 10, blipList["raid1"], width, height, sine, cosine, pixperyard)
		setDot(5, 0, blipList["raid2"], width, height, sine, cosine, pixperyard)
		setDot(3, 10, blipList["raid3"], width, height, sine, cosine, pixperyard)
		setDot(-9, -7, blipList["raid4"], width, height, sine, cosine, pixperyard)
		setDot(0, 10, blipList["raid5"], width, height, sine, cosine, pixperyard)

		proxCircle:Show()
		proxAnchor.playerDot:Show()
		proxAnchor.rangeCircle:Show()
		proxAnchor.text:Hide()
	end

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

	function testText()
		proxAnchor.rangeCircle:Hide()
		proxAnchor.playerDot:Hide()
		proxAnchor.text:SetText("|cffaad372Legolasftw|r\n|cfff48cbaTirionman|r\n|cfffff468Sneakystab|r\n|cffc69b6dIamconanok|r")
		proxAnchor.text:Show()
	end

	--------------------------------------------------------------------------------
	-- Normal Proximity
	--

	function normalProximity()
		if functionToFire then CTimerAfter(0.05, functionToFire) else return end

		local anyoneClose = 0
		local width, height = db.width, db.height
		local pixperyard = min(width, height) / activeRangeRadius
		local rotangle = piDoubled - GetPlayerFacing()
		local sine = sin(rotangle)
		local cosine = cos(rotangle)

		local srcY, srcX, _, mapId = UnitPosition("player")
		for i = 1, maxPlayers do
			local n = unitList[i]
			local unitY, unitX, _, tarMapId = UnitPosition(n)
			local dx = unitX - srcX
			local dy = unitY - srcY
			local range = dx * dx + dy * dy
			if mapId == tarMapId and range < activeRangeSquaredTwoFive and UnitInPhase(n) then
				if myGUID ~= UnitGUID(n) and not UnitIsDead(n) then
					setDot(dx, dy, blipList[n], width, height, sine, cosine, pixperyard)
					if range <= activeRangeSquared then
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

		proxTitle:SetFormattedText(L_proximityTitle, activeRange, anyoneClose)

		if anyoneClose == 0 then
			proxCircle:SetVertexColor(0, 1, 0)
		else
			proxCircle:SetVertexColor(1, 0, 0)
			if not db.sound then return end
			local t = GetTime()
			if t > (lastplayed + db.soundDelay) and not UnitIsDead("player") and InCombatLockdown() then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", plugin, nil, db.soundName)
			end
		end
	end

	function normalProximityText()
		if functionToFire then CTimerAfter(0.05, functionToFire) else return end

		local anyoneClose = 0
		local _, _, _, mapId = UnitPosition("player")
		for i = 1, maxPlayers do
			local n = unitList[i]
			local _, _, _, tarMapId = UnitPosition(n)
			if mapId == tarMapId and isInRange(n) and myGUID ~= UnitGUID(n) and not UnitIsDead(n) and UnitInPhase(n) then
				anyoneClose = anyoneClose + 1
				if anyoneClose < 6 then
					local player = plugin:UnitName(n)
					tinsert(tooClose, coloredNames[player])
				end
			end
		end

		proxTitle:SetFormattedText(L_proximityTitle, activeRange, anyoneClose)

		if anyoneClose == 0 then
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

	function targetProximity()
		if functionToFire then CTimerAfter(0.05, functionToFire) else return end

		local width, height = db.width, db.height
		local pixperyard = min(width, height) / activeRangeRadius
		local rotangle = piDoubled - GetPlayerFacing()
		local sine = sin(rotangle)
		local cosine = cos(rotangle)

		local srcY, srcX = UnitPosition("player")
		local unitY, unitX = UnitPosition(proximityPlayer)

		local dx = unitX - srcX
		local dy = unitY - srcY
		local range = dx * dx + dy * dy
		setDot(dx, dy, blipList[proximityPlayer], width, height, sine, cosine, pixperyard)
		if range <= activeRangeSquared then
			proxCircle:SetVertexColor(1, 0, 0)
			proxTitle:SetFormattedText(L_proximityTitle, activeRange, 1)
			if not proxPulseOut.playing then
				proxPulseOut:Play()
			end
			if not db.sound then return end
			local t = GetTime()
			if t > (lastplayed + 1) and not UnitIsDead("player") and InCombatLockdown() then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", plugin, nil, db.soundName)
			end
		else
			proxCircle:SetVertexColor(0, 1, 0)
			proxTitle:SetFormattedText(L_proximityTitle, activeRange, 0)
			if proxPulseOut.playing then
				proxPulseOut:Stop()
			end
		end
	end

	function targetProximityText()
		if functionToFire then CTimerAfter(0.05, functionToFire) else return end

		if isInRange(proximityPlayer) then
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

	function multiTargetProximity()
		if functionToFire then CTimerAfter(0.05, functionToFire) else return end

		local anyoneClose = 0
		local width, height = db.width, db.height
		local pixperyard = min(width, height) / activeRangeRadius
		local rotangle = piDoubled - GetPlayerFacing()
		local sine = sin(rotangle)
		local cosine = cos(rotangle)

		local srcY, srcX = UnitPosition("player")
		for i = 1, #proximityPlayerTable do
			local player = proximityPlayerTable[i]
			local unitY, unitX = UnitPosition(player)
			local dx = unitX - srcX
			local dy = unitY - srcY
			local range = dx * dx + dy * dy
			setDot(dx, dy, blipList[player], width, height, sine, cosine, pixperyard)
			if range <= activeRangeSquared then
				anyoneClose = anyoneClose + 1
			end
		end

		proxTitle:SetFormattedText(L_proximityTitle, activeRange, anyoneClose)

		if anyoneClose == 0 then
			proxCircle:SetVertexColor(0, 1, 0)
			if proxPulseOut.playing then
				proxPulseOut:Stop()
			end
		else
			proxCircle:SetVertexColor(1, 0, 0)
			if not proxPulseOut.playing then
				proxPulseOut:Play()
			end
			if not db.sound then return end
			local t = GetTime()
			if t > (lastplayed + 1) and not UnitIsDead("player") and InCombatLockdown() then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", plugin, nil, db.soundName)
			end
		end
	end

	function multiTargetProximityText()
		if functionToFire then CTimerAfter(0.05, functionToFire) else return end

		local anyoneClose = 0
		for i = 1, #proximityPlayerTable do
			local unit = proximityPlayerTable[i]
			if isInRange(unit) and myGUID ~= UnitGUID(unit) then
				anyoneClose = anyoneClose + 1
				local player = plugin:UnitName(unit)
				tinsert(tooClose, coloredNames[player])
			end
		end

		proxTitle:SetFormattedText(L_proximityTitle, activeRange, anyoneClose)

		if anyoneClose == 0 then
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

	function reverseProximity()
		if functionToFire then CTimerAfter(0.05, functionToFire) else return end

		local anyoneClose = 0
		local width, height = db.width, db.height
		local pixperyard = min(width, height) / activeRangeRadius
		local rotangle = piDoubled - GetPlayerFacing()
		local sine = sin(rotangle)
		local cosine = cos(rotangle)

		local srcY, srcX, _, mapId = UnitPosition("player")
		for i = 1, maxPlayers do
			local n = unitList[i]
			local unitY, unitX, _, tarMapId = UnitPosition(n)
			local dx = unitX - srcX
			local dy = unitY - srcY
			local range = dx * dx + dy * dy
			if mapId == tarMapId and range < activeRangeSquaredTwoFive and UnitInPhase(n) then
				if myGUID ~= UnitGUID(n) and not UnitIsDead(n) then
					setDot(dx, dy, blipList[n], width, height, sine, cosine, pixperyard)
					if range <= activeRangeSquared then
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

		proxTitle:SetFormattedText(L_proximityTitle, activeRange, anyoneClose)

		if anyoneClose == 0 then
			proxCircle:SetVertexColor(1, 0, 0)
			if not db.sound then return end
			local t = GetTime()
			if t > (lastplayed + db.soundDelay) and not UnitIsDead("player") and InCombatLockdown() then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", plugin, nil, db.soundName)
			end
		else
			proxCircle:SetVertexColor(0, 1, 0)
		end
	end

	function reverseProximityText()
		if functionToFire then CTimerAfter(0.05, functionToFire) else return end

		local anyoneClose = 0

		local _, _, _, mapId = UnitPosition("player")
		for i = 1, maxPlayers do
			local n = unitList[i]
			local _, _, _, tarMapId = UnitPosition(n)
			if mapId == tarMapId and isInRange(n) and myGUID ~= UnitGUID(n) and not UnitIsDead(n) and UnitInPhase(n) then
				anyoneClose = anyoneClose + 1
			end
		end

		proxTitle:SetFormattedText(L_proximityTitle, activeRange, anyoneClose)

		if anyoneClose == 0 then
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

	function reverseTargetProximity()
		if functionToFire then CTimerAfter(0.05, functionToFire) else return end

		local width, height = db.width, db.height
		local pixperyard = min(width, height) / activeRangeRadius
		local rotangle = piDoubled - GetPlayerFacing()
		local sine = sin(rotangle)
		local cosine = cos(rotangle)

		local srcY, srcX = UnitPosition("player")
		local unitY, unitX = UnitPosition(proximityPlayer)
		local dx = unitX - srcX
		local dy = unitY - srcY
		local range = dx * dx + dy * dy
		setDot(dx, dy, blipList[proximityPlayer], width, height, sine, cosine, pixperyard)
		if range <= activeRangeSquared then
			proxCircle:SetVertexColor(0, 1, 0)
			proxTitle:SetFormattedText(L_proximityTitle, activeRange, 1)
			if proxPulseIn.playing then
				proxPulseIn:Stop()
			end
		else
			proxCircle:SetVertexColor(1, 0, 0)
			proxTitle:SetFormattedText(L_proximityTitle, activeRange, 0)
			if not proxPulseIn.playing then
				proxPulseIn:Play()
			end
			if not db.sound then return end
			local t = GetTime()
			if t > (lastplayed + 1) and not UnitIsDead("player") and InCombatLockdown() then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", plugin, nil, db.soundName)
			end
		end
	end

	function reverseTargetProximityText()
		if functionToFire then CTimerAfter(0.05, functionToFire) else return end

		if isInRange(proximityPlayer) then
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

	function reverseMultiTargetProximity()
		if functionToFire then CTimerAfter(0.05, functionToFire) else return end

		local anyoneClose = 0
		local width, height = db.width, db.height
		local pixperyard = min(width, height) / activeRangeRadius
		local rotangle = piDoubled - GetPlayerFacing()
		local sine = sin(rotangle)
		local cosine = cos(rotangle)

		local srcY, srcX = UnitPosition("player")
		for i = 1, #proximityPlayerTable do
			local player = proximityPlayerTable[i]
			local unitY, unitX = UnitPosition(player)
			local dx = unitX - srcX
			local dy = unitY - srcY
			local range = dx * dx + dy * dy
			setDot(dx, dy, blipList[player], width, height, sine, cosine, pixperyard)
			if range <= activeRangeSquared then
				anyoneClose = anyoneClose + 1
			end
		end

		proxTitle:SetFormattedText(L_proximityTitle, activeRange, anyoneClose)

		if anyoneClose == 0 then
			proxCircle:SetVertexColor(1, 0, 0)
			if not proxPulseIn.playing then
				proxPulseIn:Play()
			end
			if not db.sound then return end
			local t = GetTime()
			if t > (lastplayed + db.soundDelay) and not UnitIsDead("player") and InCombatLockdown() then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", plugin, nil, db.soundName)
			end
		else
			proxCircle:SetVertexColor(0, 1, 0)
			if proxPulseIn.playing then
				proxPulseIn:Stop()
			end
		end
	end

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

		if anyoneClose == 0 then
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

local function updateBlipIcons()
	for i = 1, maxPlayers do
		local n = unitList[i]
		local blip = blipList[n]
		local icon = GetRaidTargetIndex(n)
		if icon and not blip.hasIcon then
			-- Texture id list for raid icons 1-8 is 137001-137008. Base texture path is Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_%d
			blip:SetTexture(icon + 137000)
			blip:SetVertexColor(1,1,1) -- Remove color
			blip.hasIcon = true
		elseif not icon and blip.hasIcon then
			blip.hasIcon = nil
			blip:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\blip")
			local _, class = UnitClass(n)
			if class then
				local c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
				blip:SetVertexColor(c.r, c.g, c.b)
			else
				blip:SetVertexColor(0.5, 0.5, 0.5) -- Gray if UnitClass returns nil
			end
		end
	end
end

local function updateBlipColors()
	-- Move onto updating blip colors
	for i = 1, maxPlayers do
		local n = unitList[i]
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
		end
	end
end

local function updateUnits()
	maxPlayers = GetNumGroupMembers()
	unitList = IsInRaid() and plugin:GetRaidList() or plugin:GetPartyList()
end

local function updateProfile()
	db = plugin.db.profile

	if not db.font then
		db.font = media:GetDefault("font")
	end
	if not db.fontSize then
		local _, size = GameFontNormalHuge:GetFont()
		db.fontSize = size
	end

	plugin:RestyleWindow()
end

local function resetAnchor()
	proxAnchor:ClearAllPoints()
	proxAnchor:SetPoint("CENTER", UIParent, "CENTER", 400, 0)
	db.width = plugin.defaultDB.width
	db.height = plugin.defaultDB.height
	proxAnchor:SetWidth(db.width)
	proxAnchor:SetHeight(db.height)
	db.posx = nil
	db.posy = nil
end

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnRegister()
	BigWigs:RegisterBossOption("proximity", L.proximity, L.proximity_desc, OnOptionToggled, 132181) -- 132181 = "Interface\\Icons\\ability_hunter_pathfinding"
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	updateProfile()
end

do
	local createAnchor = function()
		proxAnchor = CreateFrame("Frame", "BigWigsProximityAnchor", UIParent)
		proxAnchor:SetWidth(db.width)
		proxAnchor:SetHeight(db.height)
		proxAnchor:SetMinResize(100, 30)
		proxAnchor:SetClampedToScreen(true)
		proxAnchor:EnableMouse(true)
		proxAnchor:SetScript("OnMouseUp", function(self, button)
			if inConfigMode and button == "LeftButton" then
				plugin:SendMessage("BigWigs_SetConfigureTarget", plugin)
			end
		end)

		local tooltipFrame = CreateFrame("Frame", nil, proxAnchor)
		tooltipFrame:SetWidth(db.width)
		tooltipFrame:SetHeight(40)
		tooltipFrame:SetPoint("BOTTOM", proxAnchor, "TOP")
		tooltipFrame:SetScript("OnEnter", function(self)
			if not activeSpellID and not inConfigMode then return end
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
		close:SetFrameLevel(proxAnchor:GetFrameLevel() + 5) -- place this above everything
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
		close:SetNormalTexture("Interface\\AddOns\\BigWigs\\Textures\\icons\\close")
		proxAnchor.close = close

		local sound = CreateFrame("Button", nil, proxAnchor)
		sound:SetPoint("BOTTOMLEFT", proxAnchor, "TOPLEFT", 2, 2)
		sound:SetFrameLevel(proxAnchor:GetFrameLevel() + 5) -- place this above everything
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

		local header = proxAnchor:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		header:SetFormattedText(L_proximityTitle, 5, 3)
		header:SetPoint("BOTTOM", proxAnchor, "TOP", 0, 4)
		proxAnchor.title = header
		proxTitle = header

		local abilityName = proxAnchor:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		abilityName:SetFormattedText("|T136015:20:20:-5:0:64:64:4:60:4:60|t%s", L.abilityName) -- Interface\\Icons\\spell_nature_chainlightning
		abilityName:SetPoint("BOTTOM", header, "TOP", 0, 4)
		proxAnchor.ability = abilityName

		local text = proxAnchor:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		text:SetText("")
		text:SetAllPoints(proxAnchor)
		proxAnchor.text = text

		local rangeCircle = proxAnchor:CreateTexture(nil, "ARTWORK")
		rangeCircle:SetPoint("CENTER")
		rangeCircle:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\alert_circle")
		rangeCircle:SetBlendMode("ADD")
		proxAnchor.rangeCircle = rangeCircle
		proxCircle = rangeCircle

		local rangePulse = proxAnchor:CreateTexture(nil, "ARTWORK")
		rangePulse:SetPoint("CENTER")
		rangePulse:SetAtlas("GarrLanding-CircleGlow")
		rangePulse:Hide()
		proxAnchor.rangePulse = rangePulse

		local function showAnimParent(frame) frame:GetParent():Show() frame.playing = true end
		local function hideAnimParent(frame) frame:GetParent():Hide() frame.playing = nil end

		-- Push outwards
		local animGroupOutbound = rangePulse:CreateAnimationGroup()
		animGroupOutbound:SetLooping("REPEAT")
		animGroupOutbound:SetScript("OnPlay", showAnimParent)
		animGroupOutbound:SetScript("OnStop", hideAnimParent)
		animGroupOutbound:SetScript("OnFinished", hideAnimParent)
		local alpha1Out = animGroupOutbound:CreateAnimation("Alpha")
		alpha1Out:SetOrder(1)
		alpha1Out:SetDuration(0.5)
		alpha1Out:SetFromAlpha(0)
		alpha1Out:SetToAlpha(1)
		local alpha2Out = animGroupOutbound:CreateAnimation("Alpha")
		alpha2Out:SetOrder(1)
		alpha2Out:SetStartDelay(0.5)
		alpha2Out:SetDuration(1)
		alpha2Out:SetFromAlpha(1)
		alpha2Out:SetToAlpha(0)
		local scaleOut = animGroupOutbound:CreateAnimation("Scale")
		scaleOut:SetOrder(1)
		scaleOut:SetFromScale(0.4,0.4)
		scaleOut:SetToScale(1.3,1.3)
		scaleOut:SetDuration(1)
		proxAnchor.rangePulseAnimOut = animGroupOutbound
		proxPulseOut = animGroupOutbound

		-- Pull inwards
		local animGroupInbound = rangePulse:CreateAnimationGroup()
		animGroupInbound:SetLooping("REPEAT")
		animGroupInbound:SetScript("OnPlay", showAnimParent)
		animGroupInbound:SetScript("OnStop", hideAnimParent)
		animGroupInbound:SetScript("OnFinished", hideAnimParent)
		local alpha1In = animGroupInbound:CreateAnimation("Alpha")
		alpha1In:SetOrder(1)
		alpha1In:SetDuration(0.5)
		alpha1In:SetFromAlpha(0)
		alpha1In:SetToAlpha(1)
		local alpha2In = animGroupInbound:CreateAnimation("Alpha")
		alpha2In:SetOrder(1)
		alpha2In:SetStartDelay(0.5)
		alpha2In:SetDuration(1)
		alpha2In:SetFromAlpha(1)
		alpha2In:SetToAlpha(0)
		local scaleIn = animGroupInbound:CreateAnimation("Scale")
		scaleIn:SetOrder(1)
		scaleIn:SetFromScale(1.5,1.5)
		scaleIn:SetToScale(0.5,0.5)
		scaleIn:SetDuration(1)
		proxAnchor.rangePulseAnimIn = animGroupInbound
		proxPulseIn = animGroupInbound

		local playerDot = proxAnchor:CreateTexture(nil, "OVERLAY")
		playerDot:SetSize(32, 32)
		playerDot:SetTexture(136431) --"Interface\\Minimap\\MinimapArrow"
		playerDot:SetPoint("CENTER")
		proxAnchor.playerDot = playerDot

		local drag = CreateFrame("Frame", nil, proxAnchor)
		drag.frame = proxAnchor
		drag:SetFrameLevel(proxAnchor:GetFrameLevel() + 5) -- place this above everything
		drag:SetWidth(16)
		drag:SetHeight(16)
		drag:SetPoint("BOTTOMRIGHT", proxAnchor, -1, 1)
		drag:EnableMouse(true)
		drag:SetScript("OnMouseDown", OnDragHandleMouseDown)
		drag:SetScript("OnMouseUp", OnDragHandleMouseUp)
		drag:SetAlpha(0.5)
		proxAnchor.drag = drag

		local tex = drag:CreateTexture(nil, "OVERLAY")
		tex:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\draghandle")
		tex:SetWidth(16)
		tex:SetHeight(16)
		tex:SetBlendMode("ADD")
		tex:SetPoint("CENTER", drag)

		plugin:RestyleWindow()

		proxAnchor:Hide()

		local rList = plugin:GetRaidList()
		for i = 1, 40 do
			local blip = proxAnchor:CreateTexture(nil, "OVERLAY")
			blip:SetSize(16, 16)
			blip:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\blip")
			blipList[rList[i]] = blip
		end
		local pList = plugin:GetPartyList()
		for i = 1, 5 do
			local blip = proxAnchor:CreateTexture(nil, "OVERLAY")
			blip:SetSize(16, 16)
			blip:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\blip")
			blipList[pList[i]] = blip
		end

		proxAnchor:SetScript("OnEvent", function(_, event)
			if event == "GROUP_ROSTER_UPDATE" then
				updateUnits()
				if not db.textMode then
					updateBlipColors()
				end
			else
				updateBlipIcons()
			end
		end)

		-- USE THIS CALLBACK TO SKIN THIS WINDOW! NO NEED FOR UGLY HAX! E.g.
		-- local name, addon = ...
		-- if BigWigsLoader then
		-- 	BigWigsLoader.RegisterMessage(addon, "BigWigs_FrameCreated", function(event, frame, name) print(name.." frame created.") end)
		-- end
		plugin:SendMessage("BigWigs_FrameCreated", proxAnchor, "Proximity")
	end

	function plugin:OnPluginEnable()
		if createAnchor then createAnchor() createAnchor = nil end

		self:RegisterMessage("BigWigs_ShowProximity")
		self:RegisterMessage("BigWigs_HideProximity", "BigWigs_OnBossDisable")
		self:RegisterMessage("BigWigs_OnBossReboot", "BigWigs_OnBossDisable")
		self:RegisterMessage("BigWigs_OnBossDisable")

		self:RegisterMessage("BigWigs_StartConfigureMode")
		self:RegisterMessage("BigWigs_StopConfigureMode")
		self:RegisterMessage("BigWigs_SetConfigureTarget")
		self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
		self:RegisterMessage("BigWigs_ResetPositions", resetAnchor)
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

function plugin:BigWigs_StartConfigureMode()
	if activeRange > 0 then
		return -- Pointless trying to start configure mode if proximity has already been opened by a boss encounter.
	end
	inConfigMode = true
	self:Test()
end

function plugin:BigWigs_StopConfigureMode()
	inConfigMode = nil
	if db.lock then
		proxAnchor:EnableMouse(false) -- Mouse disabled whilst locked, but we enable it in test mode. Re-disable it.
	end
	self:Close(true)
end

function plugin:BigWigs_SetConfigureTarget(event, module)
	if module == self then
		proxAnchor.background:SetColorTexture(0.2, 1, 0.2, 0.3)
	else
		proxAnchor.background:SetColorTexture(0, 0, 0, 0.3)
	end
end

do
	local disabled = function() return plugin.db.profile.disabled end
	plugin.pluginOptions = {
		name = L.proximity_name,
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
				name = L.disabled,
				desc = L.disabledDisplayDesc,
				order = 1,
			},
			lock = {
				type = "toggle",
				name = L.lock,
				desc = L.lockDesc,
				order = 2,
				disabled = disabled,
			},
			font = {
				type = "select",
				name = L.font,
				order = 3,
				values = media:List("font"),
				width = "full",
				itemControl = "DDI-Font",
			},
			fontSize = {
				type = "range",
				name = L.fontSize,
				order = 4,
				max = 40,
				min = 8,
				step = 1,
				width = "full",
			},
			soundName = {
				type = "select",
				name = L.sound,
				order = 5,
				values = media:List("sound"),
				width = "full",
				itemControl = "DDI-Sound"
				--disabled = disabled,
			},
			soundDelay = {
				type = "range",
				name = L.soundDelay,
				desc = L.soundDelayDesc,
				order = 6,
				max = 10,
				min = 1,
				step = 1,
				width = "full",
				disabled = disabled,
			},
			showHide = {
				type = "group",
				name = L.showHide,
				inline = true,
				order = 7,
				get = function(info)
					local key = info[#info]
					return db.objects[key]
				end,
				set = function(info, value)
					local key = info[#info]
					db.objects[key] = value
					plugin:RestyleWindow()
				end,
				disabled = disabled,
				args = {
					title = {
						type = "toggle",
						name = L.title,
						desc = L.titleDesc,
						order = 1,
					},
					background = {
						type = "toggle",
						name = L.background,
						desc = L.backgroundDesc,
						order = 2,
					},
					sound = {
						type = "toggle",
						name = L.soundButton,
						desc = L.soundButtonDesc,
						order = 3,
					},
					close = {
						type = "toggle",
						name = L.closeButton,
						desc = L.closeButtonDesc,
						order = 4,
					},
					ability = {
						type = "toggle",
						name = L.abilityName,
						desc = L.abilityNameDesc,
						order = 5,
					},
					tooltip = {
						type = "toggle",
						name = L.tooltip,
						desc = L.tooltipDesc,
						order = 6,
					},
				},
			},
			exactPositioning = {
				type = "group",
				name = L.positionExact,
				order = 8,
				inline = true,
				args = {
					posx = {
						type = "range",
						name = L.positionX,
						desc = L.positionDesc,
						min = 0,
						max = 2048,
						step = 1,
						order = 1,
						width = "full",
					},
					posy = {
						type = "range",
						name = L.positionY,
						desc = L.positionDesc,
						min = 0,
						max = 2048,
						step = 1,
						order = 2,
						width = "full",
					},
				},
			},
		},
	}
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

	activeRange, activeRangeRadius, activeRangeSquared, activeRangeSquaredTwoFive = setRange(0), 0, 0, 0
	activeSpellID = nil
	proximityPlayer = nil
	wipe(proximityPlayerTable)

	proxTitle:SetFormattedText(L_proximityTitle, 5, 3)
	proxAnchor.ability:SetFormattedText("|T136015:20:20:-5:0:64:64:4:60:4:60|t%s", L.abilityName) -- Interface\\Icons\\spell_nature_chainlightning
	-- Just in case we were the last target of configure mode, reset the background color.
	proxAnchor.background:SetColorTexture(0, 0, 0, 0.3)
	proxPulseIn:Stop()
	proxPulseOut:Stop()
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

		myGUID = UnitGUID("player")
		activeRange = setRange(range)
		activeRangeRadius = range * 3 -- activeRange * 3, so we have 3x radius space
		activeRangeSquared = range*range
		activeRangeSquaredTwoFive = activeRangeSquared * 2.5

		proxAnchor:RegisterEvent("GROUP_ROSTER_UPDATE")
		updateUnits()

		if db.textMode then
			proxAnchor.rangeCircle:Hide()
			proxAnchor.playerDot:Hide()
			proxAnchor.text:SetText("")
			proxAnchor.text:Show()

			local size = min(proxAnchor:GetSize())
			proxAnchor.rangePulse:SetSize(size, size)
		else
			proxAnchor.rangeCircle:Show()
			proxAnchor.playerDot:Show()
			proxAnchor.text:Hide()

			proxAnchor:RegisterEvent("RAID_TARGET_UPDATE")
			updateBlipColors()
			updateBlipIcons()

			local ppy = min(db.width, db.height) / (range * 3)
			local size = ppy * range * 2
			proxCircle:SetSize(size, size)
			proxAnchor.rangePulse:SetSize(size, size)
		end

		if not player and not isReverse then
			functionToFire = db.textMode and normalProximityText or normalProximity
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
					functionToFire = db.textMode and reverseMultiTargetProximityText or reverseMultiTargetProximity
				else
					functionToFire = db.textMode and multiTargetProximityText or multiTargetProximity
				end
			else
				for i = 1, GetNumGroupMembers() do
					-- Only set the function if we found the unit
					if UnitIsUnit(player, unitList[i]) then
						proximityPlayer = unitList[i]
						if db.textMode then
							functionToFire = isReverse and reverseTargetProximityText or targetProximityText
						else
							functionToFire = isReverse and reverseTargetProximity or targetProximity
						end
						break
					end
				end
			end
		elseif isReverse then
			functionToFire = db.textMode and reverseProximityText or reverseProximity
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

function plugin:Test()
	self:Close(true)
	if db.lock then
		proxAnchor:EnableMouse(true) -- Mouse disabled whilst locked, enable it in test mode
	end
	if db.textMode then
		testText()
	else
		testDots()
	end
	proxAnchor:Show()
	-- proxPulseOut:Play()
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

SlashCmdList.BigWigs_ProximityTarget = function(input)
	if not plugin:IsEnabled() then BigWigs:Enable() end
	input = input:lower()
	local range, target, reverse = input:match("^(%d+)%s*(%S*)%s*(%S*)$")
	range = tonumber(range)
	if not range or not target or (not UnitInRaid(target) and not UnitInParty(target)) then
		BigWigs:Print("Usage: /proximitytarget 1-100 player [true]") -- XXX translate
	else
		if range > 0 then
			plugin:Close(true)
			customProximityOpen = range
			customProximityTarget = target
			customProximityReverse = reverse == "true"
			plugin:Open(range, nil, nil, customProximityTarget, customProximityReverse)
		else
			customProximityOpen, customProximityTarget, customProximityReverse = nil, nil, nil
			plugin:Close(true)
		end
	end
end

SLASH_BigWigs_Proximity1 = "/proximity"
SLASH_BigWigs_Proximity2 = "/range"
SLASH_BigWigs_ProximityTarget1 = "/proximitytarget"
SLASH_BigWigs_ProximityTarget2 = "/rangetarget"
