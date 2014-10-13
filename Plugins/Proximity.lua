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
}

-------------------------------------------------------------------------------
-- Locals
--

local db = nil

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")
plugin.displayName = L.proximity_name
local L_proximityTitle = L.proximityTitle

local media = LibStub("LibSharedMedia-3.0")

local mute = "Interface\\AddOns\\BigWigs\\Textures\\icons\\mute"
local unmute = "Interface\\AddOns\\BigWigs\\Textures\\icons\\unmute"

local inConfigMode = nil
local activeRange, activeRangeSquared = 0, 0
local activeSpellID = nil
local activeMap = nil
local proximityPlayer = nil
local proximityPlayerTable = {}
local maxPlayers = 0
local unitList = nil
local blipList = {}
local updater = nil
local proxAnchor, proxTitle, proxCircle = nil, nil, nil

-- Upvalues
local SetMapToCurrentZone = BigWigsLoader.SetMapToCurrentZone
local GetPlayerMapPosition, GetCurrentMapDungeonLevel, GetPlayerFacing = GetPlayerMapPosition, GetCurrentMapDungeonLevel, GetPlayerFacing
local UnitPosition = UnitPosition
local GetRaidTargetIndex, GetNumGroupMembers, GetTime = GetRaidTargetIndex, GetNumGroupMembers, GetTime
local IsInRaid, InCombatLockdown = IsInRaid, InCombatLockdown
local UnitIsDead, UnitIsUnit, UnitClass = UnitIsDead, UnitIsUnit, UnitClass
local min, pi, cos, sin = math.min, math.pi, math.cos, math.sin
local format = string.format

local OnOptionToggled = nil -- Function invoked when the proximity option is toggled on a module.

-- GLOBALS: BigWigs CUSTOM_CLASS_COLORS GameTooltip GameFontNormalHuge RAID_CLASS_COLORS SLASH_BigWigs_Proximity1 SLASH_BigWigs_Proximity2 UIParent

-------------------------------------------------------------------------------
-- Map Data
--

local mapData = {}
local mapWidth, mapHeight = 0, 0

--------------------------------------------------------------------------------
-- Options
--

local function updateSoundButton()
	if not proxAnchor then return end
	proxAnchor.sound:SetNormalTexture(db.sound and unmute or mute)
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
	proxAnchor.tooltip:SetWidth(width)
	if inConfigMode then
		testDots()
	else
		local width, height = proxAnchor:GetWidth(), proxAnchor:GetHeight()
		local range = activeRange > 0 and activeRange or 10
		local pixperyard = min(width, height) / (range*3)
		proxCircle:SetSize(range*2*pixperyard, range*2*pixperyard)
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

local normalProximity, reverseTargetProximity, targetProximity, multiTargetProximity, reverseMultiTargetProximity, reverseProximity
local normalProximityWOD, reverseTargetProximityWOD, targetProximityWOD, multiTargetProximityWOD, reverseMultiTargetProximityWOD, reverseProximityWOD
do
	local lastplayed = 0 -- When we last played an alarm sound for proximity.

	-- dx and dy are in yards
	-- class is player class
	-- facing is radians with 0 being north, counting up clockwise
	local setDot = function(dx, dy, blip)
		local width, height = proxAnchor:GetWidth(), proxAnchor:GetHeight()
		local range = activeRange > 0 and activeRange or 10
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
		blip:SetPoint("CENTER", proxAnchor, "CENTER", x, y)
		if not blip.isShown then
			blip.isShown = true
			blip:Show()
		end
	end

	testDots = function()
		for i = 1, 40 do
			blipList[i].isShown = nil
			blipList[i]:Hide()
		end

		setDot(10, 10, blipList[1])
		setDot(5, 0, blipList[2])
		setDot(3, 10, blipList[3])
		setDot(-9, -7, blipList[4])
		setDot(0, 10, blipList[5])
		local width, height = proxAnchor:GetWidth(), proxAnchor:GetHeight()
		local pixperyard = min(width, height) / 30
		proxCircle:SetSize(pixperyard * 20, pixperyard * 20)
		proxCircle:SetVertexColor(1,0,0)
		proxCircle:Show()
		proxAnchor.playerDot:Show()
	end

	--------------------------------------------------------------------------------
	-- Normal Proximity
	--

	function normalProximity()
		local srcX, srcY = GetPlayerMapPosition("player")
		if srcX == 0 and srcY == 0 then
			SetMapToCurrentZone()
			srcX, srcY = GetPlayerMapPosition("player")
		end

		local anyoneClose = 0

		for i = 1, maxPlayers do
			local n = unitList[i]
			local unitX, unitY = GetPlayerMapPosition(n)
			local dx = (unitX - srcX) * mapWidth
			local dy = (unitY - srcY) * mapHeight
			local range = dx * dx + dy * dy
			if range < activeRangeSquared*2.5 then
				if not UnitIsUnit("player", n) and not UnitIsDead(n) then
					setDot(dx, dy, blipList[i])
					if range <= activeRangeSquared then
						anyoneClose = anyoneClose + 1
					end
				elseif blipList[i].isShown then -- A unit may die next to us
					blipList[i]:Hide()
					blipList[i].isShown = nil
				end
			elseif blipList[i].isShown then
				blipList[i]:Hide()
				blipList[i].isShown = nil
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
				plugin:SendMessage("BigWigs_Sound", db.soundName, true)
			end
		end
	end

	function normalProximityWOD() -- XXX compat
		local anyoneClose = 0

		local srcY, srcX = UnitPosition("player")
		for i = 1, maxPlayers do
			local n = unitList[i]
			local unitY, unitX = UnitPosition(n)
			local dx = unitX - srcX
			local dy = unitY - srcY
			local range = dx * dx + dy * dy
			if range < activeRangeSquared*2.5 then
				if not UnitIsUnit("player", n) and not UnitIsDead(n) then
					setDot(-dx, -dy, blipList[i])
					if range <= activeRangeSquared then
						anyoneClose = anyoneClose + 1
					end
				elseif blipList[i].isShown then -- A unit may die next to us
					blipList[i]:Hide()
					blipList[i].isShown = nil
				end
			elseif blipList[i].isShown then
				blipList[i]:Hide()
				blipList[i].isShown = nil
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
				plugin:SendMessage("BigWigs_Sound", db.soundName, true)
			end
		end
	end

	--------------------------------------------------------------------------------
	-- Target Proximity
	--

	function targetProximity()
		local srcX, srcY = GetPlayerMapPosition("player")
		if srcX == 0 and srcY == 0 then
			SetMapToCurrentZone()
			srcX, srcY = GetPlayerMapPosition("player")
		end

		local unitX, unitY = GetPlayerMapPosition(proximityPlayer)
		local dx = (unitX - srcX) * mapWidth
		local dy = (unitY - srcY) * mapHeight
		local range = dx * dx + dy * dy
		setDot(dx, dy, blipList[1])
		if range <= activeRangeSquared then
			proxCircle:SetVertexColor(1, 0, 0)
			local t = GetTime()
			if t > (lastplayed + 1) and not UnitIsDead("player") and InCombatLockdown() then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", db.soundName, true)
			end
			proxTitle:SetFormattedText(L_proximityTitle, activeRange, 1)
		else
			proxCircle:SetVertexColor(0, 1, 0)
			proxTitle:SetFormattedText(L_proximityTitle, activeRange, 0)
		end
	end

	function targetProximityWOD() -- XXX compat
		local srcY, srcX = UnitPosition("player")
		local unitY, unitX = UnitPosition(proximityPlayer)

		local dx = unitX - srcX
		local dy = unitY - srcY
		local range = dx * dx + dy * dy
		setDot(-dx, -dy, blipList[1])
		if range <= activeRangeSquared then
			proxCircle:SetVertexColor(1, 0, 0)
			local t = GetTime()
			if t > (lastplayed + 1) and not UnitIsDead("player") and InCombatLockdown() then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", db.soundName, true)
			end
			proxTitle:SetFormattedText(L_proximityTitle, activeRange, 1)
		else
			proxCircle:SetVertexColor(0, 1, 0)
			proxTitle:SetFormattedText(L_proximityTitle, activeRange, 0)
		end
	end

	--------------------------------------------------------------------------------
	-- Multi Target Proximity
	--

	function multiTargetProximity()
		local srcX, srcY = GetPlayerMapPosition("player")
		if srcX == 0 and srcY == 0 then
			SetMapToCurrentZone()
			srcX, srcY = GetPlayerMapPosition("player")
		end

		local anyoneClose = 0

		for i = 1, #proximityPlayerTable do
			local player = proximityPlayerTable[i]
			local unitX, unitY = GetPlayerMapPosition(player)
			local dx = (unitX - srcX) * mapWidth
			local dy = (unitY - srcY) * mapHeight
			local range = dx * dx + dy * dy
			setDot(dx, dy, blipList[i])
			if range <= activeRangeSquared then
				anyoneClose = anyoneClose + 1
			end
		end

		proxTitle:SetFormattedText(L_proximityTitle, activeRange, anyoneClose)

		if anyoneClose == 0 then
			proxCircle:SetVertexColor(0, 1, 0)
		else
			proxCircle:SetVertexColor(1, 0, 0)
			local t = GetTime()
			if t > (lastplayed + 1) and not UnitIsDead("player") and InCombatLockdown() then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", db.soundName, true)
			end
		end
	end

	function multiTargetProximityWOD() -- XXX compat
		local anyoneClose = 0

		local srcY, srcX = UnitPosition("player")
		for i = 1, #proximityPlayerTable do
			local player = proximityPlayerTable[i]
			local unitY, unitX = UnitPosition(player)
			local dx = unitX - srcX
			local dy = unitY - srcY
			local range = dx * dx + dy * dy
			setDot(-dx, -dy, blipList[i])
			if range <= activeRangeSquared then
				anyoneClose = anyoneClose + 1
			end
		end

		proxTitle:SetFormattedText(L_proximityTitle, activeRange, anyoneClose)

		if anyoneClose == 0 then
			proxCircle:SetVertexColor(0, 1, 0)
		else
			proxCircle:SetVertexColor(1, 0, 0)
			local t = GetTime()
			if t > (lastplayed + 1) and not UnitIsDead("player") and InCombatLockdown() then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", db.soundName, true)
			end
		end
	end

	--------------------------------------------------------------------------------
	-- Reverse Proximity
	--

	function reverseProximity()
		local srcX, srcY = GetPlayerMapPosition("player")
		if srcX == 0 and srcY == 0 then
			SetMapToCurrentZone()
			srcX, srcY = GetPlayerMapPosition("player")
		end

		local anyoneClose = 0

		for i = 1, maxPlayers do
			local n = unitList[i]
			local unitX, unitY = GetPlayerMapPosition(n)
			local dx = (unitX - srcX) * mapWidth
			local dy = (unitY - srcY) * mapHeight
			local range = dx * dx + dy * dy
			if range < activeRangeSquared*2.5 then
				if not UnitIsUnit("player", n) and not UnitIsDead(n) then
					setDot(dx, dy, blipList[i])
					if range <= activeRangeSquared then
						anyoneClose = anyoneClose + 1
					end
				elseif blipList[i].isShown then -- A unit may die next to us
					blipList[i]:Hide()
					blipList[i].isShown = nil
				end
			elseif blipList[i].isShown then
				blipList[i]:Hide()
				blipList[i].isShown = nil
			end
		end

		proxTitle:SetFormattedText(L_proximityTitle, activeRange, anyoneClose)

		if anyoneClose == 0 then
			proxCircle:SetVertexColor(1, 0, 0)
			if not db.sound then return end
			local t = GetTime()
			if t > (lastplayed + db.soundDelay) and not UnitIsDead("player") and InCombatLockdown() then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", db.soundName, true)
			end
		else
			proxCircle:SetVertexColor(0, 1, 0)
		end
	end

	function reverseProximityWOD() -- XXX compat
		local anyoneClose = 0

		local srcY, srcX = UnitPosition("player")
		for i = 1, maxPlayers do
			local n = unitList[i]
			local unitY, unitX = UnitPosition(n)
			local dx = unitX - srcX
			local dy = unitY - srcY
			local range = dx * dx + dy * dy
			if range < activeRangeSquared*2.5 then
				if not UnitIsUnit("player", n) and not UnitIsDead(n) then
					setDot(-dx, -dy, blipList[i])
					if range <= activeRangeSquared then
						anyoneClose = anyoneClose + 1
					end
				elseif blipList[i].isShown then -- A unit may die next to us
					blipList[i]:Hide()
					blipList[i].isShown = nil
				end
			elseif blipList[i].isShown then
				blipList[i]:Hide()
				blipList[i].isShown = nil
			end
		end

		proxTitle:SetFormattedText(L_proximityTitle, activeRange, anyoneClose)

		if anyoneClose == 0 then
			proxCircle:SetVertexColor(1, 0, 0)
			if not db.sound then return end
			local t = GetTime()
			if t > (lastplayed + db.soundDelay) and not UnitIsDead("player") and InCombatLockdown() then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", db.soundName, true)
			end
		else
			proxCircle:SetVertexColor(0, 1, 0)
		end
	end

	--------------------------------------------------------------------------------
	-- Reverse Target Proximity
	--

	function reverseTargetProximity()
		local srcX, srcY = GetPlayerMapPosition("player")
		if srcX == 0 and srcY == 0 then
			SetMapToCurrentZone()
			srcX, srcY = GetPlayerMapPosition("player")
		end

		local unitX, unitY = GetPlayerMapPosition(proximityPlayer)
		local dx = (unitX - srcX) * mapWidth
		local dy = (unitY - srcY) * mapHeight
		local range = dx * dx + dy * dy
		setDot(dx, dy, blipList[1])
		if range <= activeRangeSquared then
			proxCircle:SetVertexColor(0, 1, 0)
			proxTitle:SetFormattedText(L_proximityTitle, activeRange, 1)
		else
			proxCircle:SetVertexColor(1, 0, 0)
			local t = GetTime()
			if t > (lastplayed + 1) and not UnitIsDead("player") and InCombatLockdown() then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", db.soundName, true)
			end
			proxTitle:SetFormattedText(L_proximityTitle, activeRange, 0)
		end
	end

	function reverseTargetProximityWOD() -- XXX compat
		local srcY, srcX = UnitPosition("player")
		local unitY, unitX = UnitPosition(proximityPlayer)
		local dx = unitX - srcX
		local dy = unitY - srcY
		local range = dx * dx + dy * dy
		setDot(-dx, -dy, blipList[1])
		if range <= activeRangeSquared then
			proxCircle:SetVertexColor(0, 1, 0)
			proxTitle:SetFormattedText(L_proximityTitle, activeRange, 1)
		else
			proxCircle:SetVertexColor(1, 0, 0)
			local t = GetTime()
			if t > (lastplayed + 1) and not UnitIsDead("player") and InCombatLockdown() then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", db.soundName, true)
			end
			proxTitle:SetFormattedText(L_proximityTitle, activeRange, 0)
		end
	end

	--------------------------------------------------------------------------------
	-- Reverse Multi Target Proximity
	--

	function reverseMultiTargetProximity()
		local srcX, srcY = GetPlayerMapPosition("player")
		if srcX == 0 and srcY == 0 then
			SetMapToCurrentZone()
			srcX, srcY = GetPlayerMapPosition("player")
		end

		local anyoneClose = 0

		for i = 1, #proximityPlayerTable do
			local player = proximityPlayerTable[i]
			local unitX, unitY = GetPlayerMapPosition(player)
			local dx = (unitX - srcX) * mapWidth
			local dy = (unitY - srcY) * mapHeight
			local range = dx * dx + dy * dy
			setDot(dx, dy, blipList[i])
			if range <= activeRangeSquared then
				anyoneClose = anyoneClose + 1
			end
		end

		proxTitle:SetFormattedText(L_proximityTitle, activeRange, anyoneClose)

		if anyoneClose == 0 then
			proxCircle:SetVertexColor(1, 0, 0)
		else
			proxCircle:SetVertexColor(0, 1, 0)
		end
	end

	function reverseMultiTargetProximityWOD() -- XXX compat
		local anyoneClose = 0

		local srcY, srcX = UnitPosition("player")
		for i = 1, #proximityPlayerTable do
			local player = proximityPlayerTable[i]
			local unitY, unitX = UnitPosition(player)
			local dx = unitX - srcX
			local dy = unitY - srcY
			local range = dx * dx + dy * dy
			setDot(-dx, -dy, blipList[i])
			if range <= activeRangeSquared then
				anyoneClose = anyoneClose + 1
			end
		end

		proxTitle:SetFormattedText(L_proximityTitle, activeRange, anyoneClose)

		if anyoneClose == 0 then
			proxCircle:SetVertexColor(1, 0, 0)
		else
			proxCircle:SetVertexColor(0, 1, 0)
		end
	end
end

local function updateBlipIcons()
	for i = 1, maxPlayers do
		local n = unitList[i]
		local blip = blipList[i]
		local icon = GetRaidTargetIndex(n)
		if icon and not blip.hasIcon then
			blip:SetTexture(format("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_%d.blp", icon))
			blip:SetDrawLayer("OVERLAY", 1)
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
			blip:SetDrawLayer("OVERLAY", 0)
		end
	end
end

local function updateBlipColors()
	-- Firstly lets update some things from the GROUP_ROSTER_UPDATE event, or the proximity window opening
	maxPlayers = GetNumGroupMembers()
	unitList = IsInRaid() and plugin:GetRaidList() or plugin:GetPartyList()

	-- Move onto updating blip colors
	for i = 1, maxPlayers do
		local n = unitList[i]
		if not GetRaidTargetIndex(n) then
			local blip = blipList[i]
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

	if not db.font then
		db.font = media:GetDefault("font")
	end
	if not db.fontSize then
		local _, size = GameFontNormalHuge:GetFont()
		db.fontSize = size
	end

	if proxAnchor then
		proxAnchor:SetWidth(db.width)
		proxAnchor:SetHeight(db.height)

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

		plugin:RestyleWindow()
	end
end

local function resetAnchor()
	proxAnchor:ClearAllPoints()
	proxAnchor:SetPoint("CENTER", UIParent, "CENTER", 400, 0)
	proxAnchor:SetWidth(plugin.defaultDB.width)
	proxAnchor:SetHeight(plugin.defaultDB.height)
	db.posx = nil
	db.posy = nil
	db.width = nil
	db.height = nil
end

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnRegister()
	BigWigs:RegisterBossOption("proximity", L.proximity, L.proximity_desc, OnOptionToggled, "Interface\\Icons\\ability_hunter_pathfinding")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	updateProfile()
end

do
	local createAnchor = function()
		proxAnchor = CreateFrame("Frame", "BigWigsProximityAnchor", UIParent)
		proxAnchor:SetWidth(db.width or plugin.defaultDB.width)
		proxAnchor:SetHeight(db.height or plugin.defaultDB.height)
		proxAnchor:SetMinResize(100, 30)
		proxAnchor:SetClampedToScreen(true)
		proxAnchor:EnableMouse(true)
		proxAnchor:SetScript("OnMouseUp", function(self, button)
			if inConfigMode and button == "LeftButton" then
				plugin:SendMessage("BigWigs_SetConfigureTarget", plugin)
			end
		end)

		local tooltipFrame = CreateFrame("Frame", nil, proxAnchor)
		tooltipFrame:SetWidth(db.width or plugin.defaultDB.width)
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

		updater = proxAnchor:CreateAnimationGroup()
		updater:SetLooping("REPEAT")
		local anim = updater:CreateAnimation()
		anim:SetDuration(0.05)

		local bg = proxAnchor:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(proxAnchor)
		bg:SetBlendMode("BLEND")
		bg:SetTexture(0, 0, 0, 0.3)
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
			plugin:Close()
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
		abilityName:SetFormattedText("|TInterface\\Icons\\spell_nature_chainlightning:20:20:-5:0:64:64:4:60:4:60|t%s", L.abilityName)
		abilityName:SetPoint("BOTTOM", header, "TOP", 0, 4)
		proxAnchor.ability = abilityName

		local rangeCircle = proxAnchor:CreateTexture(nil, "ARTWORK")
		rangeCircle:SetPoint("CENTER")
		rangeCircle:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\alert_circle")
		rangeCircle:SetBlendMode("ADD")
		proxAnchor.rangeCircle = rangeCircle
		proxCircle = rangeCircle

		local playerDot = proxAnchor:CreateTexture(nil, "OVERLAY")
		playerDot:SetSize(32, 32)
		playerDot:SetTexture("Interface\\Minimap\\MinimapArrow")
		playerDot:SetBlendMode("ADD")
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

		plugin:RestyleWindow()

		proxAnchor:Hide()

		for i = 1, 40 do
			local blip = proxAnchor:CreateTexture(nil, "OVERLAY")
			blip:SetSize(16, 16)
			blip:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\blip")
			blipList[i] = blip
		end

		proxAnchor:SetScript("OnEvent", function(_, event)
			if event == "GROUP_ROSTER_UPDATE" then
				updateBlipColors()
			else
				updateBlipIcons()
			end
		end)

		-- USE THIS CALLBACK TO SKIN THIS WINDOW! NO NEED FOR UGLY HAX! E.g.
		-- local name, addon = ...
		-- if BigWigsLoader then
		--  BigWigsLoader.RegisterMessage(addon, "BigWigs_FrameCreated", function(event, frame, name) print(name.." frame created.") end)
		-- end
		plugin:SendMessage("BigWigs_FrameCreated", proxAnchor, "Proximity")
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
	self:Close()
end

function plugin:BigWigs_SetConfigureTarget(event, module)
	if module == self then
		proxAnchor.background:SetTexture(0.2, 1, 0.2, 0.3)
	else
		proxAnchor.background:SetTexture(0, 0, 0, 0.3)
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
				disabled = function() return plugin.db.profile.disabled end,
				args = {
					disabled = {
						type = "toggle",
						name = L.disabled,
						desc = L.disabledDisplayDesc,
						order = 1,
						disabled = false,
					},
					lock = {
						type = "toggle",
						name = L.lock,
						desc = L.lockDesc,
						order = 2,
					},
					font = {
						type = "select",
						name = L.font,
						order = 4,
						values = media:List("font"),
						width = "full",
						itemControl = "DDI-Font",
					},
					fontSize = {
						type = "range",
						name = L.fontSize,
						order = 5,
						max = 40,
						min = 8,
						step = 1,
						width = "full",
					},
					soundName = {
						type = "select",
						name = L.sound,
						order = 6,
						values = media:List("sound"),
						width = "full",
						itemControl = "DDI-Sound"
					},
					soundDelay = {
						type = "range",
						name = L.soundDelay,
						desc = L.soundDelayDesc,
						order = 7,
						max = 10,
						min = 1,
						step = 1,
						width = "full",
					},
					showHide = {
						type = "group",
						name = L.showHide,
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
	self:SetMapData()
	return mapData
end

function plugin:SetMapData()
	SetMapToCurrentZone()
	local map = format("%d.%d", GetCurrentMapAreaID(), GetCurrentMapDungeonLevel())
	if activeMap ~= map then
		activeMap, mapWidth, mapHeight = nil, 0, 0
		local _, left, top, right, bottom = GetCurrentMapZone()
		local floorNum, dright, dbottom, dleft, dtop = GetCurrentMapDungeonLevel()
		if DungeonUsesTerrainMap() then floorNum = floorNum - 1 end
		if floorNum > 0 then left, top, right, bottom = dleft, dtop, dright, dbottom end
		if left ~= 0 and right ~= 0 then
			mapWidth, mapHeight = -right + left, -bottom + top
			activeMap = map
			-- silly compat for no reason, some on-demand mapData
			local mapName = GetMapInfo()
			local currentFloor = GetCurrentMapDungeonLevel()
			if not mapData[mapName] then
				mapData[mapName] = {}
			end
			if not mapData[mapName][currentFloor] then
				mapData[mapName][currentFloor] = { mapWidth, mapHeight }
			end
		end
	end
end

function plugin:Close()
	updater:Stop()

	proxAnchor:UnregisterEvent("GROUP_ROSTER_UPDATE")
	proxAnchor:UnregisterEvent("RAID_TARGET_UPDATE")

	for i = 1, 40 do
		if blipList[i].isShown then
			blipList[i].isShown = nil
			blipList[i]:Hide()
		end
	end

	activeRange, activeRangeSquared = 0, 0
	activeSpellID = nil
	proximityPlayer = nil
	wipe(proximityPlayerTable)

	proxTitle:SetFormattedText(L_proximityTitle, 5, 3)
	proxAnchor.ability:SetFormattedText("|TInterface\\Icons\\spell_nature_chainlightning:20:20:-5:0:64:64:4:60:4:60|t%s", L.abilityName)
	-- Just in case we were the last target of configure mode, reset the background color.
	proxAnchor.background:SetTexture(0, 0, 0, 0.3)
	proxAnchor:Hide()
end

local abilityNameFormat = "|T%s:20:20:-5|t%s"
function plugin:Open(range, module, key, player, isReverse)
	if type(range) ~= "number" then print("Range needs to be a number!") return end
	if not IsInGroup() then return end -- Solo runs of old content
	self:Close()

	self:SetMapData()
	if not activeMap then print("No map data!") end

	activeRange = range
	activeRangeSquared = range*range
	proxAnchor:RegisterEvent("GROUP_ROSTER_UPDATE")
	proxAnchor:RegisterEvent("RAID_TARGET_UPDATE")
	updateBlipColors()
	updateBlipIcons()

	if not player and not isReverse then
		updater:SetScript("OnLoop", BigWigs.isWOD and normalProximityWOD or normalProximity) -- XXX compat
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
				updater:SetScript("OnLoop", BigWigs.isWOD and reverseMultiTargetProximityWOD or reverseMultiTargetProximity) -- XXX compat
			else
				updater:SetScript("OnLoop", BigWigs.isWOD and multiTargetProximityWOD or multiTargetProximity) -- XXX compat
			end
		else
			for i = 1, GetNumGroupMembers() do
				if UnitIsUnit(player, unitList[i]) then
					proximityPlayer = unitList[i]
					break
				end
			end
			if not proximityPlayer then self:Close() end -- Not found e.g. Mirror Image
			if isReverse then
				updater:SetScript("OnLoop", BigWigs.isWOD and reverseTargetProximityWOD or reverseTargetProximity) -- XXX compat
			else
				updater:SetScript("OnLoop", BigWigs.isWOD and targetProximityWOD or targetProximity) -- XXX compat
			end
		end
	elseif isReverse then
		updater:SetScript("OnLoop", BigWigs.isWOD and reverseProximityWOD or reverseProximity) -- XXX compat
	end

	local width, height = proxAnchor:GetWidth(), proxAnchor:GetHeight()
	local ppy = min(width, height) / (range * 3)
	proxCircle:SetSize(ppy * range * 2, ppy * range * 2)

	-- Update the ability name display
	if module and key then
		local dbKey, name, desc, icon = BigWigs:GetBossOptionDetails(module, key)
		if type(icon) == "string" then
			proxAnchor.ability:SetFormattedText("|T%s:20:20:-5:0:64:64:4:60:4:60|t%s", icon, name)
		else
			proxAnchor.ability:SetText(name)
		end
	else
		proxAnchor.ability:SetText(L.customRange)
	end
	if type(key) == "number" and key > 0 then -- GameTooltip doesn't do "journal" hyperlinks
		activeSpellID = key
	else
		activeSpellID = nil
	end

	-- Start the show!
	proxAnchor:Show()
	updater:Play()
end

function plugin:Test()
	self:Close()
	if db.lock then
		proxAnchor:EnableMouse(true) -- Mouse disabled whilst locked, enable it in test mode
	end
	testDots()
	proxAnchor:Show()
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

