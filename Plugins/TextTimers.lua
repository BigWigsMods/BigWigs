if not BigWigsLoader.isRetail then
	return
end -- Retail only module (temporarily)

--------------------------------------------------------------------------------
-- Module Declaration
--

local plugin, L =
	BigWigs:NewPlugin(
	"Text Timers",
	{
		"db"
	}
)
if not plugin then
	return
end

--------------------------------------------------------------------------------
-- Locals
--

plugin.displayName = "Text Timers"

local currentBarStyler = nil
local SetBarStyle

local colors = nil
local candy = LibStub("LibCandyBar-3.0")
local LibSharedMedia = LibStub("LibSharedMedia-3.0")
local FONT = LibSharedMedia.MediaType and LibSharedMedia.MediaType.FONT or "font"
local STATUSBAR = LibSharedMedia.MediaType and LibSharedMedia.MediaType.STATUSBAR or "statusbar"
local next = next
local db = nil
local normalAnchor, emphasizeAnchor = nil, nil
local rearrangeBars, getBar

local minBarWidth, minBarHeight, maxBarWidth, maxBarHeight = 120, 10, 550, 100

--------------------------------------------------------------------------------
-- Profile
--

plugin.defaultDB = {
	-- General
	fontName = plugin:GetDefaultFont(),
	monochrome = false,
	outline = "NONE"
}

local function CopyTable(settingsTable)
	local copy = {}
	for key, value in next, settingsTable do
		if type(value) == "table" then
			copy[key] = CopyTable(value)
		else
			copy[key] = value
		end
	end
	return copy
end

local function updateProfile()
	db = plugin.db.profile

	for k, v in next, db do
		local defaultType = type(plugin.defaultDB[k])
		if defaultType == "nil" then
			db[k] = nil
		elseif type(v) ~= defaultType then
			if defaultType == "table" then
				db[k] = CopyTable(plugin.defaultDB[k])
			else
				db[k] = plugin.defaultDB[k]
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Options
--

do
	local function IsAnchorDisabled(info)
		local key = info[#info]
		local unitType = info[#info - 1]
		local optionDB = db[unitType]

		if optionDB.disabled then
			return true
		end
		if key == "showCooldownText" then
			return not optionDB.showCooldown
		elseif key == "cooldownTextScale" then
			return not optionDB.showCooldown or not optionDB.showCooldownText
		end
	end
	plugin.pluginOptions = {
		type = "group",
		name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Bars:20|t " .. "Text Timers",
		childGroups = "tab",
		get = function(info)
			return plugin.db.profile[info[#info]]
		end,
		set = function(info, value)
			plugin.db.profile[info[#info]] = value
			updateProfile()
		end,
		order = 2.1,
		args = {
			anchorsButton = {
				type = "execute",
				name = function()
					if inConfigureMode then
						return L.toggleAnchorsBtnHide
					else
						return L.toggleAnchorsBtnShow
					end
				end,
				desc = function()
					if inConfigureMode then
						return L.toggleAnchorsBtnHide_desc
					else
						return L.toggleBarsAnchorsBtnShow_desc
					end
				end,
				func = function()
					if inConfigureMode then
						plugin:SendMessage("BigWigs_StopConfigureMode", "Bars")
					else
						plugin:SendMessage("BigWigs_StartConfigureMode", "Bars")
					end
				end,
				width = 1.5,
				order = 0.2
			},
			testButton = {
				type = "execute",
				name = L.testBarsBtn,
				desc = L.testBarsBtn_desc,
				func = function()
					testCount = testCount + 1
					local time = math.random(11, 30)
					plugin:SendMessage(
						"BigWigs_StartBar",
						plugin,
						nil,
						BigWigsAPI:GetLocale("BigWigs: Common").count:format(L.test, testCount),
						time,
						testIcons[(testCount % 3) + 1]
					)
					plugin:SendMessage(
						"BigWigs_Timer",
						plugin,
						nil,
						time,
						time,
						BigWigsAPI:GetLocale("BigWigs: Common").count:format(L.test, testCount),
						0,
						testIcons[(testCount % 3) + 1],
						false,
						true
					)
				end,
				width = 1.5,
				order = 0.4
			}
		}
	}
	--[[
	local prevScale = 1
	local function OnDragStart(self)
		local anchor = self.dragAnchor
		local anchorDB = plugin.db.profile[anchor.unitType]
		prevScale = anchorDB.cooldownTextScale
		anchorDB.cooldownTextScale = 1
		updateProfile()
		anchor:StartMoving()
	end
	local function OnDragStop(self)
		local anchor = self.dragAnchor
		anchor:StopMovingOrSizing()

		local point, _, relPoint, x, y = anchor:GetPoint()
		x = math.floor(x + 0.5)
		y = math.floor(y + 0.5)

		local anchorDB = plugin.db.profile[anchor.unitType]
		anchorDB.anchorPoint = point
		anchorDB.anchorRelPoint = relPoint
		anchorDB.anchorXOffset = x
		anchorDB.anchorYOffset = y
		anchorDB.cooldownTextScale = prevScale
		updateProfile()

		if BigWigsOptions and BigWigsOptions:IsOpen() then
			plugin:UpdateGUI()
		end
	end

	local function createDragAnchor(parent)
		local display = CreateFrame("Frame", nil, UIParent)
		display:SetPoint("TOPLEFT", parent)
		display:SetPoint("BOTTOMRIGHT", parent)
		display:Hide()
		display:SetFrameStrata("HIGH")
		display:SetFixedFrameStrata(true)
		display:SetFrameLevel(25)
		display:SetFixedFrameLevel(true)

		display:EnableMouse(true)
		display:RegisterForDrag("LeftButton")
		display:SetClampedToScreen(true)
		display:SetScript("OnDragStart", OnDragStart)
		display:SetScript("OnDragStop", OnDragStop)

		local bg = display:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(display)
		bg:SetColorTexture(0, 0, 0, parent.hasTestIcon and 0 or 0.3)
		display.bg = bg

		local header = display:CreateFontString(nil, "ARTWORK")
		header:SetFont(plugin:GetDefaultFont(12))
		header:SetShadowOffset(1, -1)
		header:SetTextColor(1, 0.82, 0, 1)
		header:SetPoint("CENTER", display, "CENTER")
		header:SetJustifyH("CENTER")
		header:SetJustifyV("MIDDLE")
		display.text = header

		return display
	end

	function plugin:BigWigs_StartConfigureMode(_, mode)
		if mode and mode ~= self.moduleName then return end
		inConfigureMode = true

		for unitType, unitAnchors in next, anchors do
			for i = 1, #unitAnchors do
				local anchor = unitAnchors[i]
				if not anchor.configModeFrame then
					anchor.configModeFrame = createDragAnchor(anchor)
					anchor.configModeFrame.text:SetText(anchor.hasTestIcon and "" or L.privateAurasTestAnchorText:format(i))
					anchor.configModeFrame.dragAnchor = unitAnchors[1]
				end
				anchor.configModeFrame:Show()
			end
		end
	end

	function plugin:BigWigs_StopConfigureMode(_, mode)
		if mode and mode ~= self.moduleName then return end
		inConfigureMode = false

		for _, unitAnchors in next, anchors do
			for i = 1, #unitAnchors do
				local anchor = unitAnchors[i]
				if anchor.configModeFrame then
					anchor.configModeFrame:Hide()
				end
			end
		end

		self:UpdateAllAnchors()
	end
]]
end

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	--updateProfile()

	--createOptions()

	self:RegisterMessage("BigWigs_StartBar")
	--self:RegisterMessage("BigWigs_PauseBar", "PauseBar")
	--self:RegisterMessage("BigWigs_ResumeBar", "ResumeBar")
	self:RegisterMessage("BigWigs_StopBar", "StopSpecificBar")
	--self:RegisterMessage("BigWigs_StopBars", "StopModuleBars")
	--self:RegisterMessage("BigWigs_OnBossDisable", "StopModuleBars")
	--self:RegisterMessage("BigWigs_OnBossWipe", "StopModuleBars")
	--self:RegisterMessage("BigWigs_OnPluginDisable", "StopModuleBars")
	--self:RegisterMessage("BigWigs_StartConfigureMode", showAnchors)
	--self:RegisterMessage("BigWigs_StopConfigureMode", hideAnchors)
	--self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
end

-------------------------------------------------------------------------------
-- Event Handlers
--

local instanceKeysWidgets = {testing = false, nameList = {}, playerListText = {}}
do
	local main = CreateFrame("Frame", nil, UIParent)
	main:SetSize(200, 40)
	main:SetPoint("CENTER", UIParent, "CENTER")
	main:SetFrameStrata("MEDIUM")
	main:SetFixedFrameStrata(true)
	main:SetFrameLevel(9400)
	main:SetFixedFrameLevel(true)
	main:SetClampedToScreen(true)
	main:EnableMouse(true)
	main:SetMovable(true)
	main:RegisterForDrag("LeftButton")
	main:SetScript(
		"OnDragStart",
		function(self)
			if self:IsMovable() then
				self:StartMoving()
			end
		end
	)
	main:SetScript(
		"OnDragStop",
		function(self)
			self:StopMovingOrSizing()
			--local point, _, relPoint, x, y = self:GetPoint()
			--x = math.floor(x+0.5)
			--y = math.floor(y+0.5)
			--db.profile.instanceKeysPosition[1] = point
			--db.profile.instanceKeysPosition[2] = relPoint
			--db.profile.instanceKeysPosition[3] = x
			--db.profile.instanceKeysPosition[4] = y
		end
	)
	instanceKeysWidgets.main = main

	local bg = main:CreateTexture()
	bg:SetAllPoints(main)
	bg:SetColorTexture(0, 0, 0, 0.3)
	bg:Hide()
	instanceKeysWidgets.bg = bg

	local header = main:CreateFontString()
	header:SetPoint("TOP", 0, 0)
	--header:SetPoint(db.profile.instanceKeysAlign, 0, 0)
	--header:SetJustifyH(db.profile.instanceKeysAlign)

	--local flags = nil
	--if db.profile.instanceKeysMonochrome and db.profile.instanceKeysOutline ~= "NONE" then
	--	flags = "MONOCHROME," .. db.profile.instanceKeysOutline
	--elseif db.profile.instanceKeysMonochrome then
	--	flags = "MONOCHROME"
	--elseif db.profile.instanceKeysOutline ~= "NONE" then
	--	flags = db.profile.instanceKeysOutline
	--end
	--header:SetFont(LibSharedMedia:Fetch("font", db.profile.instanceKeysFontName), db.profile.instanceKeysFontSize, flags)
	header:SetFormattedText("|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|t%s", "Text Timers")
	--header:SetTextColor(db.profile.instanceKeysColor[1], db.profile.instanceKeysColor[2], db.profile.instanceKeysColor[3], db.profile.instanceKeysColor[4])
	--if db.profile.instanceKeysHideTitle then
	--	header:Hide()
	--else
	header:Show()
	--end
	instanceKeysWidgets.header = header

	for i = 1, 5 do
		local playerListText = main:CreateFontString()
		--if db.profile.instanceKeysGrowUpwards then
		--	playerListText:SetJustifyV("BOTTOM")
		--	playerListText:SetPoint(
		--		db.profile.instanceKeysAlign == "LEFT" and "BOTTOMLEFT" or db.profile.instanceKeysAlign == "RIGHT" and "BOTTOMRIGHT" or "BOTTOM", i == 1 and header or instanceKeysWidgets.playerListText[i-1],
		--		db.profile.instanceKeysAlign == "LEFT" and "TOPLEFT" or db.profile.instanceKeysAlign == "RIGHT" and "TOPRIGHT" or "TOP", 0, 6
		--	)
		--else
		playerListText:SetJustifyV("TOP")
		playerListText:SetPoint(
			--db.profile.instanceKeysAlign == "LEFT" and "TOPLEFT" or db.profile.instanceKeysAlign == "RIGHT" and "TOPRIGHT" or "TOP", i == 1 and header or instanceKeysWidgets.playerListText[i-1],
			--db.profile.instanceKeysAlign == "LEFT" and "BOTTOMLEFT" or db.profile.instanceKeysAlign == "RIGHT" and "BOTTOMRIGHT" or "BOTTOM", 0, -6
			"TOP",
			i == 1 and header or instanceKeysWidgets.playerListText[i - 1],
			"BOTTOM",
			0,
			-6
		)
		--end
		--playerListText:SetJustifyH(db.profile.instanceKeysAlign)
		--playerListText:SetTextColor(db.profile.instanceKeysColor[1], db.profile.instanceKeysColor[2], db.profile.instanceKeysColor[3], db.profile.instanceKeysColor[4])
		--playerListText:SetFont(LibSharedMedia:Fetch("font", db.profile.instanceKeysFontName), db.profile.instanceKeysFontSize, flags)
		playerListText:SetFont(plugin:GetDefaultFont())
		playerListText:SetText(" ")
		instanceKeysWidgets.playerListText[i] = playerListText
	end

	main:Hide()
end

do
	local timers = {}
	local GUIDtimers = {}
	do
		--local GetTime = GetTime
		--local function LowestCountdown(tableToMatch, module, text)
		--	local lowestText, lowestCountdownTable
		--	if timers[module] and timers[module][text] and not timers[module][text][2] then
		--		lowestText = timers[module][text][1]
		--		lowestCountdownTable = timers[module][text]
		--	end
		--	return lowestCountdownTable == tableToMatch
		--end

		function plugin:BigWigs_StartBar(_, module, key, text, time, icon, isApprox, maxTime, eventId, spellIndicators)
			--if module and time >= 1 then
			--	local countdownTable = {GetTime()+time}
			--	if timers[module] then
			--		if timers[module][text] then
			--			timers[module][text][2] = true
			--		end
			--	else
			--		timers[module] = {}
			--	end
			--	timers[module][text] = countdownTable
			--
			--	local bossCountdownStart = plugin.db.profile.bossCountdowns[module.name] and plugin.db.profile.bossCountdowns[module.name][key] and plugin.db.profile.bossCountdowns[module.name][key].countdownTime
			--	local textCount = customStart or bossCountdownStart or self.db.profile.countdownTime
			--	if time < textCount then
			--		textCount = math.floor(time)
			--	end
			--
			--	local function announce()
			--		if not countdownTable[2] then
			--			if LowestCountdown(countdownTable, module, text) then
			--				if not audioOnly and plugin.db.profile.textEnabled then
			--					plugin:SetText(textCount, countdownTable)
			--				end
			--				local bossCountdownVoice = plugin.db.profile.bossCountdowns[module.name] and plugin.db.profile.bossCountdowns[module.name][key] and plugin.db.profile.bossCountdowns[module.name][key].voice
			--				local voice = customVoice or bossCountdownVoice or plugin.db.profile.voice
			--				local sound = textCount <= (customAudioStart or textCount) and BigWigsAPI:GetCountdownSound(voice, textCount)
			--				if sound then
			--					self:PlaySoundFile(sound)
			--				end
			--			end
			--			textCount = textCount - 1
			--		end
			--	end
			--	for i = 1, textCount do
			--		self:SimpleTimer(announce, time-i)
			--	end
			--end
		end
	end
	--function plugin:BigWigs_OnBossDisable(_, module)
	--	if timers[module] then
	--		for _, countdownTable in next, timers[module] do
	--			countdownTable[2] = true
	--			if latestCountdown == countdownTable then
	--				self:SetText("") -- Only clear the text if the cancelled countdown was the last to display something
	--			end
	--		end
	--		timers[module] = nil
	--	end
	--	if GUIDtimers[module] then
	--		for _, guidTable in next, GUIDtimers[module] do
	--			for _, countdownTable in next, guidTable do
	--				countdownTable[2] = true
	--				if latestCountdown == countdownTable then
	--					self:SetText("") -- Only clear the text if the cancelled countdown was the last to display something
	--				end
	--			end
	--		end
	--		GUIDtimers[module] = nil
	--	end
	--end
end

function plugin:StopSpecificBar(_, module, text, eventId)
	--if not normalAnchor then return end
	--local bar = getBar(normalAnchor, module, text, eventId)
	--if bar then
	--	bar:Stop()
	--	return
	--end
	--bar = getBar(emphasizeAnchor, module, text, eventId)
	--if bar then
	--	bar:Stop()
	--	return
	--end
end
