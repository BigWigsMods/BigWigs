local L, BigWigsLoader, BigWigsAPI
do
	local _, tbl = ...
	BigWigsAPI = tbl.API
	L = BigWigsAPI:GetLocale("BigWigs")
	BigWigsLoader = tbl.loaderPublic
end

--------------------------------------------------------------------------------
-- Saved Settings
--

local ProfileUtils, db = {}
do
	local defaults
	do
		local loc = GetLocale()
		local isWest = loc ~= "koKR" and loc ~= "zhCN" and loc ~= "zhTW" and true
		local fontName = isWest and "Noto Sans Medium" or LibStub("LibSharedMedia-3.0"):GetDefault("font")

		defaults = {
			disabled = true,
			mode = 1,
			lock = false,
			size = 50,
			position = {"CENTER", "CENTER", 500, -50},
			textXPositionDuration = 0,
			textYPositionDuration = 0,
			textXPositionCharges = 0,
			textYPositionCharges = 0,
			fontName = fontName,
			durationFontSize = 14,
			durationEmphasizeFontSize = 14,
			chargesNoneFontSize = 14,
			chargesAvailableFontSize = 14,
			durationAlign = "LEFT",
			chargesAlign = "RIGHT",
			monochrome = false,
			outline = "OUTLINE",
			borderName = "Solid",
			borderColor = {0, 0, 0, 1},
			borderOffset = 0,
			borderSize = 2,
			durationColor = {1, 1, 1, 1},
			durationEmphasizeColor = {1, 1, 1, 1},
			chargesNoneColor = {1, 1, 1, 1},
			chargesAvailableColor = {1, 1, 1, 1},
			newResAvailableSound = "None",
			durationEmphasizeTime = 0,
			iconColor = {1, 1, 1, 1},
			iconTextureFromSpellID = 20484, -- Rebirth icon
			iconDesaturate = 3,
			cooldownEdge = true,
			cooldownSwipe = true,
			cooldownInverse = false,
		}
	end
	db = BigWigsLoader.db:RegisterNamespace("BattleRes", {profile = defaults})

	do
		local validFramePoints = {
			["TOPLEFT"] = true, ["TOPRIGHT"] = true, ["BOTTOMLEFT"] = true, ["BOTTOMRIGHT"] = true,
			["TOP"] = true, ["BOTTOM"] = true, ["LEFT"] = true, ["RIGHT"] = true, ["CENTER"] = true,
		}
		ProfileUtils.ValidateMainSettings = function()
			for k, v in next, db.profile do
				local defaultType = type(defaults[k])
				if defaultType == "nil" then
					db.profile[k] = nil
				elseif type(v) ~= defaultType then
					db.profile[k] = defaults[k]
				end
			end

			if db.profile.mode < 1 or db.profile.mode > 2 then
				db.profile.mode = defaults.mode
			end
			if db.profile.size < 20 or db.profile.size > 150 then
				db.profile.size = defaults.size
			end
			if type(db.profile.position[1]) ~= "string" or type(db.profile.position[2]) ~= "string"
			or type(db.profile.position[3]) ~= "number" or type(db.profile.position[4]) ~= "number"
			or not validFramePoints[db.profile.position[1]] or not validFramePoints[db.profile.position[2]] then
				db.profile.position = defaults.position
			else
				local x = math.floor(db.profile.position[3]+0.5)
				if x ~= db.profile.position[3] then
					db.profile.position[3] = x
				end
				local y = math.floor(db.profile.position[4]+0.5)
				if y ~= db.profile.position[4] then
					db.profile.position[4] = y
				end
			end
			if db.profile.textXPositionDuration < -100 or db.profile.textXPositionDuration > 100 then
				db.profile.textXPositionDuration = defaults.textXPositionDuration
			else
				local x = math.floor(db.profile.textXPositionDuration+0.5)
				if x ~= db.profile.textXPositionDuration then
					db.profile.textXPositionDuration = x
				end
			end
			if db.profile.textYPositionDuration < -100 or db.profile.textYPositionDuration > 100 then
				db.profile.textYPositionDuration = defaults.textYPositionDuration
			else
				local y = math.floor(db.profile.textYPositionDuration+0.5)
				if y ~= db.profile.textYPositionDuration then
					db.profile.textYPositionDuration = y
				end
			end
			if db.profile.textXPositionCharges < -100 or db.profile.textXPositionCharges > 100 then
				db.profile.textXPositionCharges = defaults.textXPositionCharges
			else
				local x = math.floor(db.profile.textXPositionCharges+0.5)
				if x ~= db.profile.textXPositionCharges then
					db.profile.textXPositionCharges = x
				end
			end
			if db.profile.textYPositionCharges < -100 or db.profile.textYPositionCharges > 100 then
				db.profile.textYPositionCharges = defaults.textYPositionCharges
			else
				local y = math.floor(db.profile.textYPositionCharges+0.5)
				if y ~= db.profile.textYPositionCharges then
					db.profile.textYPositionCharges = y
				end
			end
			if db.profile.durationFontSize < 12 or db.profile.durationFontSize > 200 then
				db.profile.durationFontSize = defaults.durationFontSize
			end
			if db.profile.durationEmphasizeFontSize < 12 or db.profile.durationEmphasizeFontSize > 200 then
				db.profile.durationEmphasizeFontSize = defaults.durationEmphasizeFontSize
			end
			if db.profile.chargesNoneFontSize < 12 or db.profile.chargesNoneFontSize > 200 then
				db.profile.chargesNoneFontSize = defaults.chargesNoneFontSize
			end
			if db.profile.chargesAvailableFontSize < 12 or db.profile.chargesAvailableFontSize > 200 then
				db.profile.chargesAvailableFontSize = defaults.chargesAvailableFontSize
			end
			if db.profile.outline ~= "NONE" and db.profile.outline ~= "OUTLINE" and db.profile.outline ~= "THICKOUTLINE" then
				db.profile.outline = defaults.outline
			end
			for i = 1, 4 do
				local n = db.profile.borderColor[i]
				if type(n) ~= "number" or n < 0 or n > 1 then
					db.profile.borderColor = defaults.borderColor
					break -- If 1 entry is bad, reset the whole table
				end
			end
			if db.profile.borderOffset < 0 or db.profile.borderOffset > 32 then
				db.profile.borderOffset = defaults.db.profile.borderOffset
			end
			if db.profile.borderSize < 1 or db.profile.borderSize > 32 then
				db.profile.borderSize = defaults.borderSize
			end
			if db.profile.durationAlign ~= "LEFT" and db.profile.durationAlign ~= "CENTER" and db.profile.durationAlign ~= "RIGHT" then
				db.profile.durationAlign = defaults.durationAlign
			end
			if db.profile.chargesAlign ~= "LEFT" and db.profile.chargesAlign ~= "CENTER" and db.profile.chargesAlign ~= "RIGHT" then
				db.profile.chargesAlign = defaults.chargesAlign
			end
			for i = 1, 4 do
				local n = db.profile.durationColor[i]
				if type(n) ~= "number" or n < 0 or n > 1 then
					db.profile.durationColor = defaults.durationColor
					break -- If 1 entry is bad, reset the whole table
				end
			end
			for i = 1, 4 do
				local n = db.profile.durationEmphasizeColor[i]
				if type(n) ~= "number" or n < 0 or n > 1 then
					db.profile.durationEmphasizeColor = defaults.durationEmphasizeColor
					break -- If 1 entry is bad, reset the whole table
				end
			end
			for i = 1, 4 do
				local n = db.profile.chargesNoneColor[i]
				if type(n) ~= "number" or n < 0 or n > 1 then
					db.profile.chargesNoneColor = defaults.chargesNoneColor
					break -- If 1 entry is bad, reset the whole table
				end
			end
			for i = 1, 4 do
				local n = db.profile.chargesAvailableColor[i]
				if type(n) ~= "number" or n < 0 or n > 1 then
					db.profile.chargesAvailableColor = defaults.chargesAvailableColor
					break -- If 1 entry is bad, reset the whole table
				end
			end
			if db.profile.durationEmphasizeTime < 0 or db.profile.durationEmphasizeTime > 30 then
				db.profile.durationEmphasizeTime = defaults.durationEmphasizeTime
			end
			for i = 1, 4 do
				local n = db.profile.iconColor[i]
				if type(n) ~= "number" or n < 0 or n > 1 then
					db.profile.iconColor = defaults.iconColor
					break -- If 1 entry is bad, reset the whole table
				end
			end
			if not BigWigsLoader.GetSpellTexture(db.profile.iconTextureFromSpellID) then
				db.profile.iconTextureFromSpellID = defaults.iconTextureFromSpellID
			end
			if db.profile.iconDesaturate < 1 or db.profile.iconDesaturate > 3 then
				db.profile.iconDesaturate = defaults.iconDesaturate
			end
		end
	end
	ProfileUtils.ValidateMediaSettings = function()
		if not LibStub("LibSharedMedia-3.0"):IsValid("font", db.profile.fontName) then
			db.profile.fontName = defaults.fontName
		end
		if not LibStub("LibSharedMedia-3.0"):IsValid("border", db.profile.borderName) then
			db.profile.borderName = defaults.borderName -- If the border is suddenly invalid then reset the size and offset also
			db.profile.borderSize = defaults.borderSize
			db.profile.borderOffset = defaults.borderOffset
		end
		if not LibStub("LibSharedMedia-3.0"):IsValid("sound", db.profile.newResAvailableSound) then
			db.profile.newResAvailableSound = defaults.newResAvailableSound
		end
	end
	ProfileUtils.SetPreset = function(mode)
		if mode == "icon" then
			local position = db.profile.position
			ProfileUtils.ResetSettings()
			db.profile.position = position
			db.profile.mode = 1
		elseif mode == "text" then
			local position = db.profile.position
			ProfileUtils.ResetSettings()
			db.profile.position = position
			db.profile.mode = 2
			db.profile.borderName = "None"
			db.profile.durationAlign = "CENTER"
			db.profile.chargesAlign = "CENTER"
			db.profile.iconDesaturate = 1
			db.profile.cooldownEdge = false
			db.profile.cooldownSwipe = false
		end
	end
	ProfileUtils.ResetSettings = function()
		for k, v in next, defaults do
			db.profile[k] = v
		end
		db.profile.disabled = false
	end
	ProfileUtils.ResetGeneralSettings = function()
		db.profile.lock = defaults.lock
		db.profile.size = defaults.size
		db.profile.fontName = defaults.fontName
		db.profile.outline = defaults.outline
		db.profile.monochrome = defaults.monochrome
		db.profile.borderColor = defaults.borderColor
		db.profile.borderName = defaults.borderName
		db.profile.borderOffset = defaults.borderOffset
		db.profile.borderSize = defaults.borderSize
		db.profile.newResAvailableSound = defaults.newResAvailableSound
	end
	ProfileUtils.ResetDurationSettings = function()
		db.profile.textXPositionDuration = defaults.textXPositionDuration
		db.profile.textYPositionDuration = defaults.textYPositionDuration
		db.profile.durationFontSize = defaults.durationFontSize
		db.profile.durationAlign = defaults.durationAlign
		db.profile.durationColor = defaults.durationColor
		db.profile.durationEmphasizeTime = defaults.durationEmphasizeTime
		db.profile.durationEmphasizeColor = defaults.durationEmphasizeColor
		db.profile.durationEmphasizeFontSize = defaults.durationEmphasizeFontSize
	end
	ProfileUtils.ResetChargesSettings = function()
		db.profile.textXPositionCharges = defaults.textXPositionCharges
		db.profile.textYPositionCharges = defaults.textYPositionCharges
		db.profile.chargesNoneFontSize = defaults.chargesNoneFontSize
		db.profile.chargesAvailableFontSize = defaults.chargesAvailableFontSize
		db.profile.chargesAlign = defaults.chargesAlign
		db.profile.chargesNoneColor = defaults.chargesNoneColor
		db.profile.chargesAvailableColor = defaults.chargesAvailableColor
	end
	ProfileUtils.ResetIconSettings = function()
		db.profile.iconTextureFromSpellID = defaults.iconTextureFromSpellID
		db.profile.iconColor = defaults.iconColor
		db.profile.iconDesaturate = defaults.iconDesaturate
		db.profile.cooldownEdge = defaults.cooldownEdge
		db.profile.cooldownSwipe = defaults.cooldownSwipe
		db.profile.cooldownInverse = defaults.cooldownInverse
	end

	ProfileUtils.ValidateMainSettings()
	BigWigsLoader.CTimerAfter(0, ProfileUtils.ValidateMediaSettings) -- Delay to allow time for other addons to register media into LSM
end

--------------------------------------------------------------------------------
-- Locals
--

local isTesting, isShowing = false, false
local previousCharges = -1
local resCollector = {}
local fightStartTime = 0
local LibSharedMedia = LibStub("LibSharedMedia-3.0")
local GetTime = GetTime
local resSpells = {
	[20484] = true, -- Rebirth
	[61999] = true, -- Raise Ally
	[95750] = true, -- Soulstone Resurrection
	[391054] = true, -- Intercession
	[345130] = true, -- Disposable Spectrophasic Reanimator
	[385403] = true, -- Tinker: Arclight Vital Correctors
	[384893] = true, -- Convincingly Realistic Jumper Cables
}

--------------------------------------------------------------------------------
-- GUI Widgets
--

local mainPanel = CreateFrame("Button", nil, UIParent)
mainPanel:Hide()
mainPanel:SetSize(db.profile.size, db.profile.size)
do
	local point, relPoint = db.profile.position[1], db.profile.position[2]
	local x, y = db.profile.position[3], db.profile.position[4]
	mainPanel:SetPoint(point, UIParent, relPoint, x, y)

	local icon = mainPanel:CreateTexture()
	icon:SetAllPoints(mainPanel)
	if db.profile.mode == 2 then
		icon:SetTexture(nil)
	else
		local texture = BigWigsLoader.GetSpellTexture(db.profile.iconTextureFromSpellID)
		icon:SetTexture(texture)
	end
	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	icon:SetVertexColor(db.profile.iconColor[1], db.profile.iconColor[2], db.profile.iconColor[3], db.profile.iconColor[4])
	if db.profile.iconDesaturate == 2 then
		icon:SetDesaturated(true)
	end
	mainPanel.icon = icon

	local border = CreateFrame("Frame", nil, mainPanel, "BackdropTemplate")
	border:SetFrameLevel(border:GetFrameLevel()+1) -- Show the border above the cooldown swipe
	border:SetPoint("TOPLEFT", mainPanel, "TOPLEFT", -db.profile.borderOffset, db.profile.borderOffset)
	border:SetPoint("BOTTOMRIGHT", mainPanel, "BOTTOMRIGHT", db.profile.borderOffset, -db.profile.borderOffset)
	mainPanel.border = border
end
do
	local cdText = mainPanel.border:CreateFontString(nil, "OVERLAY")
	cdText:SetJustifyH(db.profile.durationAlign)
	if db.profile.mode == 2 then
		cdText:SetPoint(db.profile.durationAlign, mainPanel, "LEFT", db.profile.textXPositionDuration, db.profile.textYPositionDuration)
	else
		if db.profile.durationAlign == "LEFT" then
			cdText:SetPoint("TOPLEFT", mainPanel, "TOPLEFT", db.profile.textXPositionDuration, db.profile.textYPositionDuration)
		elseif db.profile.durationAlign == "RIGHT" then
			cdText:SetPoint("TOPRIGHT", mainPanel, "TOPRIGHT", db.profile.textXPositionDuration, db.profile.textYPositionDuration)
		else
			cdText:SetPoint("TOP", mainPanel, "TOP", db.profile.textXPositionDuration, db.profile.textYPositionDuration)
		end
	end
	cdText:SetSize(300, 20)
	cdText:SetTextColor(db.profile.durationColor[1], db.profile.durationColor[2], db.profile.durationColor[3], db.profile.durationColor[4])
	mainPanel.cdText = cdText

	local chargesText = mainPanel.border:CreateFontString(nil, "OVERLAY")
	chargesText:SetJustifyH(db.profile.chargesAlign)
	if db.profile.mode == 2 then
		chargesText:SetPoint(db.profile.chargesAlign, mainPanel, "RIGHT", db.profile.textXPositionCharges, db.profile.textYPositionCharges)
	else
		if db.profile.chargesAlign == "LEFT" then
			chargesText:SetPoint("BOTTOMLEFT", mainPanel, "BOTTOMLEFT", db.profile.textXPositionCharges, db.profile.textYPositionCharges)
		elseif db.profile.chargesAlign == "RIGHT" then
			chargesText:SetPoint("BOTTOMRIGHT", mainPanel, "BOTTOMRIGHT", db.profile.textXPositionCharges, db.profile.textYPositionCharges)
		else
			chargesText:SetPoint("BOTTOM", mainPanel, "BOTTOM", db.profile.textXPositionCharges, db.profile.textYPositionCharges)
		end
	end
	chargesText:SetSize(300, 20)
	chargesText:SetTextColor(db.profile.chargesNoneColor[1], db.profile.chargesNoneColor[2], db.profile.chargesNoneColor[3], db.profile.chargesNoneColor[4])
	mainPanel.chargesText = chargesText

	do
		local flags = nil
		if db.profile.monochrome and db.profile.outline ~= "NONE" then
			flags = "MONOCHROME," .. db.profile.outline
		elseif db.profile.monochrome then
			flags = "MONOCHROME"
		elseif db.profile.outline ~= "NONE" then
			flags = db.profile.outline
		end

		local function SetMedia()
			cdText:SetFont(LibSharedMedia:Fetch("font", db.profile.fontName), db.profile.durationFontSize, flags)
			cdText:SetText("")
			cdText:SetText("0:00")
			chargesText:SetFont(LibSharedMedia:Fetch("font", db.profile.fontName), db.profile.chargesNoneFontSize, flags)
			chargesText:SetText("")
			chargesText:SetText(0)
			mainPanel.border:SetBackdrop({
				edgeFile = LibSharedMedia:Fetch("border", db.profile.borderName),
				edgeSize = db.profile.borderSize,
			})
			mainPanel.border:SetBackdropBorderColor(db.profile.borderColor[1], db.profile.borderColor[2], db.profile.borderColor[3], db.profile.borderColor[4])
		end
		SetMedia()
		BigWigsLoader.CTimerAfter(0, SetMedia) -- Delay to allow time for other addons to register media into LSM
	end

	local cooldown = CreateFrame("Cooldown", nil, mainPanel, "CooldownFrameTemplate")
	cooldown:SetAllPoints(mainPanel)
	cooldown:SetDrawBling(false)
	cooldown:SetDrawEdge(db.profile.cooldownEdge)
	cooldown:SetDrawSwipe(db.profile.cooldownSwipe)
	cooldown:SetReverse(db.profile.cooldownInverse)
	cooldown:SetHideCountdownNumbers(true) -- Blizzard
	cooldown.noCooldownCount = true -- OmniCC
	mainPanel.cooldown = cooldown

	local updater = mainPanel:CreateAnimationGroup()
	updater:SetLooping("REPEAT")
	mainPanel.updater = updater

	local GetSpellCharges, floor, prevStartTime = C_Spell.GetSpellCharges, math.floor, 0
	updater:SetScript("OnLoop", function()
		local chargesInfoTable = GetSpellCharges(20484) -- Rebirth
		if chargesInfoTable then
			local startTime = chargesInfoTable.cooldownStartTime
			local fullDuration = chargesInfoTable.cooldownDuration
			if startTime ~= prevStartTime then
				prevStartTime = startTime
				if db.profile.mode == 1 then
					cooldown:Clear()
					cooldown:SetCooldown(startTime, fullDuration)
				end
			end
			local remainingSeconds = fullDuration - (GetTime() - startTime)
			local minutes = floor(remainingSeconds / 60)
			local seconds = floor(remainingSeconds - (minutes*60))
			if db.profile.durationEmphasizeTime ~= 0 then
				if remainingSeconds > db.profile.durationEmphasizeTime then
					cdText:SetFontHeight(db.profile.durationFontSize)
					cdText:SetTextColor(db.profile.durationColor[1], db.profile.durationColor[2], db.profile.durationColor[3], db.profile.durationColor[4])
				else
					cdText:SetFontHeight(db.profile.durationEmphasizeFontSize)
					cdText:SetTextColor(db.profile.durationEmphasizeColor[1], db.profile.durationEmphasizeColor[2], db.profile.durationEmphasizeColor[3], db.profile.durationEmphasizeColor[4])
				end
			end
			if minutes == 0 then
				cdText:SetText(seconds)
			else
				cdText:SetFormattedText("%d:%02d", minutes, seconds)
			end
			local currentCharges = chargesInfoTable.currentCharges
			if currentCharges == 0 then
				chargesText:SetFontHeight(db.profile.chargesNoneFontSize)
				chargesText:SetTextColor(db.profile.chargesNoneColor[1], db.profile.chargesNoneColor[2], db.profile.chargesNoneColor[3], db.profile.chargesNoneColor[4])
				if db.profile.iconDesaturate == 3 then
					mainPanel.icon:SetDesaturated(true)
				end
			else
				chargesText:SetFontHeight(db.profile.chargesAvailableFontSize)
				chargesText:SetTextColor(db.profile.chargesAvailableColor[1], db.profile.chargesAvailableColor[2], db.profile.chargesAvailableColor[3], db.profile.chargesAvailableColor[4])
				if db.profile.iconDesaturate == 3 then
					mainPanel.icon:SetDesaturated(false)
				end
			end
			chargesText:SetText(currentCharges)
			if currentCharges > previousCharges and previousCharges >= 0 then
				local soundName = db.profile.newResAvailableSound
				if soundName ~= "None" then
					local sound = LibSharedMedia:Fetch("sound", soundName, true)
					if sound then
						BigWigsLoader.PlaySoundFile(sound, "Master")
					end
				end
			end
			previousCharges = currentCharges
		else
			cdText:SetText("0:00")
			chargesText:SetText(0)
		end
	end)

	local anim = updater:CreateAnimation()
	anim:SetDuration(1)
end
mainPanel:SetFrameStrata("MEDIUM")
mainPanel:SetFixedFrameStrata(true)
mainPanel:SetFrameLevel(8500)
mainPanel:SetFixedFrameLevel(true)
mainPanel:SetClampedToScreen(true)
mainPanel:SetMovable(true)
mainPanel:RegisterForDrag("LeftButton")
mainPanel:EnableMouse(true)
mainPanel:SetScript("OnDragStart", function(self)
	if not db.profile.lock then
		self:StartMoving()
	end
end)
mainPanel:SetScript("OnDragStop", function(self)
	if not db.profile.lock then
		self:StopMovingOrSizing()
		local point, _, relPoint, x, y = self:GetPoint()
		x = math.floor(x+0.5)
		y = math.floor(y+0.5)
		db.profile.position = {point, relPoint, x, y}
		local acr = LibStub("AceConfigRegistry-3.0", true)
		if acr then
			acr:NotifyChange("BigWigsTools")
		end
	end
end)
mainPanel:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|t".. L.battleResHistory)
	for i = 1, #resCollector do
		local time, sourceName, targetName = resCollector[i][1], resCollector[i][2], resCollector[i][3]
		local secondsSinceFightBegan = time - fightStartTime
		local minutes = math.floor(secondsSinceFightBegan / 60)
		local seconds = math.floor(secondsSinceFightBegan - (minutes*60))
		local timeToShow = ("[%d:%02d]"):format(minutes, seconds)
		GameTooltip:AddDoubleLine(timeToShow, targetName and (sourceName .." >> ".. targetName) or sourceName, 1, 1, 1, 1, 1, 1)
	end
	if isTesting and db.profile.mode == 2 then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L.battleResModeTextTooltip, 1, 1, 1)
	end
	GameTooltip:Show()
end)
mainPanel:SetScript("OnLeave", GameTooltip_Hide)

do
	local DelayStartOfInstance
	do
		local difficultiesWithBattleRes = {
			[14] = true, -- Normal
			[15] = true, -- Heroic
			[16] = true, -- Mythic
			[17] = true, -- LFR
			[33] = true, -- Timewalking (Raid)
		}
		function DelayStartOfInstance() -- Difficulty info isn't accurate until 1 frame after PEW
			local _, _, diffID = BigWigsLoader.GetInstanceInfo()
			if difficultiesWithBattleRes[diffID] then
				isShowing = true
				isTesting = false
				mainPanel:Show()
				mainPanel.cdText:SetText("0:00")
				mainPanel.chargesText:SetText(0)
				mainPanel:RegisterEvent("ENCOUNTER_START")
				mainPanel:RegisterEvent("ENCOUNTER_END")
				mainPanel:RegisterEvent("PLAYER_REGEN_DISABLED")
				mainPanel:RegisterEvent("PLAYER_REGEN_ENABLED")
				if IsEncounterInProgress() then
					previousCharges = -1
					resCollector = {}
					fightStartTime = GetTime()
					mainPanel.updater:Play()
					mainPanel.border:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
				end
			elseif diffID == 23 then -- Mythic
				mainPanel:RegisterEvent("CHALLENGE_MODE_START")
			elseif diffID == 8 then -- Mythic+
				isShowing = true
				isTesting = false
				mainPanel:Show()
				mainPanel.cdText:SetText("0:00")
				mainPanel.chargesText:SetText(0)
				previousCharges = -1
				resCollector = {}
				fightStartTime = GetTime()
				mainPanel.updater:Play()
				mainPanel.border:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
				mainPanel:RegisterEvent("PLAYER_REGEN_DISABLED")
				mainPanel:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
		end
	end
	mainPanel:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_ENTERING_WORLD" then
			BigWigsLoader.CTimerAfter(0, DelayStartOfInstance)
		elseif event == "ENCOUNTER_START" then
			previousCharges = -1
			resCollector = {}
			fightStartTime = GetTime()
			self.cdText:SetText("0:00")
			self.chargesText:SetText(0)
			self.updater:Play()
			self.border:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		elseif event == "ENCOUNTER_END" or event == "CHALLENGE_MODE_COMPLETED" then
			self.updater:Stop()
			self.cooldown:Clear()
			self.cdText:SetText("0:00")
			self.chargesText:SetText(0)
			if db.profile.iconDesaturate == 3 then
				self.icon:SetDesaturated(false)
			end
			self.border:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		elseif event == "CHALLENGE_MODE_START" then
			previousCharges = -1
			resCollector = {}
			isShowing = true
			isTesting = false
			fightStartTime = GetTime()+9
			self:Show()
			self.cdText:SetText("0:00")
			self.chargesText:SetText(0)
			self.updater:Play()
			self:RegisterEvent("CHALLENGE_MODE_COMPLETED")
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
			self.border:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		elseif event == "PLAYER_REGEN_DISABLED" then
			self:EnableMouse(false)
		elseif event == "PLAYER_REGEN_ENABLED" then
			self:EnableMouse(true)
		elseif event == "PLAYER_LEAVING_WORLD" then
			isShowing = false
			self:EnableMouse(true)
			self:Hide()
			self.updater:Stop()
			self.cooldown:Clear()
			if db.profile.iconDesaturate == 3 then
				self.icon:SetDesaturated(false)
			end
			self:UnregisterEvent("ENCOUNTER_START")
			self:UnregisterEvent("ENCOUNTER_END")
			self:UnregisterEvent("CHALLENGE_MODE_START")
			self:UnregisterEvent("CHALLENGE_MODE_COMPLETED")
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			self.border:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end
	end)
end
if not db.profile.disabled then
	mainPanel:RegisterEvent("PLAYER_ENTERING_WORLD")
	mainPanel:RegisterEvent("PLAYER_LEAVING_WORLD")
end

--------------------------------------------------------------------------------
-- Res history
--

do
	local CombatLogGetCurrentEventInfo, UnitClass, GetClassColor = CombatLogGetCurrentEventInfo, UnitClass, C_ClassColor.GetClassColor
	mainPanel.border:SetScript("OnEvent", function()
		local _, event, _, _, sourceName, _, _, _, targetName, _, _, spellId = CombatLogGetCurrentEventInfo()
		if event == "SPELL_RESURRECT" then
			if resSpells[spellId] then
				local _, classFileSource = UnitClass(sourceName)
				local _, classFileTarget = UnitClass(targetName)
				if classFileSource and classFileTarget then
					local sourceColor = GetClassColor(classFileSource):GenerateHexColor()
					local targetColor = GetClassColor(classFileTarget):GenerateHexColor()
					resCollector[#resCollector+1] = {GetTime(), "|c".. sourceColor .. sourceName .."|r", "|c".. targetColor .. targetName .."|r"}
				else
					resCollector[#resCollector+1] = {GetTime(), sourceName, targetName}
				end
			end
		elseif event == "SPELL_CAST_SUCCESS" and spellId == 21169 then -- Reincarnation
			local _, classFile = UnitClass(sourceName)
			if classFile then
				local color = GetClassColor(classFile):GenerateHexColor()
				resCollector[#resCollector+1] = {GetTime(), "|c".. color .. sourceName .."|r"}
			else
				resCollector[#resCollector+1] = {GetTime(), sourceName}
			end
		end
	end)
end

--------------------------------------------------------------------------------
-- Options Table
--

do
	local function UpdateWidgets()
		if db.profile.mode == 2 then
			mainPanel.icon:SetTexture(nil)
			if isTesting then
				mainPanel.icon:SetColorTexture(0, 0, 0, 0.6)
			end
		else
			local texture = BigWigsLoader.GetSpellTexture(db.profile.iconTextureFromSpellID)
			mainPanel.icon:SetTexture(texture)
		end
		mainPanel.icon:SetVertexColor(db.profile.iconColor[1], db.profile.iconColor[2], db.profile.iconColor[3], db.profile.iconColor[4])
		if db.profile.iconDesaturate == 2 then
			mainPanel.icon:SetDesaturated(true)
		else
			mainPanel.icon:SetDesaturated(false)
		end

		mainPanel:ClearAllPoints()
		do
			local point, relPoint = db.profile.position[1], db.profile.position[2]
			local x, y = db.profile.position[3], db.profile.position[4]
			mainPanel:SetPoint(point, UIParent, relPoint, x, y)
		end
		mainPanel:SetSize(db.profile.size, db.profile.size)

		local fontFlags = nil
		if db.profile.monochrome and db.profile.outline ~= "NONE" then
			fontFlags = "MONOCHROME," .. db.profile.outline
		elseif db.profile.monochrome then
			fontFlags = "MONOCHROME"
		elseif db.profile.outline ~= "NONE" then
			fontFlags = db.profile.outline
		end

		mainPanel.cdText:SetJustifyH(db.profile.durationAlign)
		mainPanel.cdText:ClearAllPoints()
		if db.profile.mode == 2 then
			mainPanel.cdText:SetPoint(db.profile.durationAlign, mainPanel, "LEFT", db.profile.textXPositionDuration, db.profile.textYPositionDuration)
		else
			if db.profile.durationAlign == "LEFT" then
				mainPanel.cdText:SetPoint("TOPLEFT", mainPanel, "TOPLEFT", db.profile.textXPositionDuration, db.profile.textYPositionDuration)
			elseif db.profile.durationAlign == "RIGHT" then
				mainPanel.cdText:SetPoint("TOPRIGHT", mainPanel, "TOPRIGHT", db.profile.textXPositionDuration, db.profile.textYPositionDuration)
			else
				mainPanel.cdText:SetPoint("TOP", mainPanel, "TOP", db.profile.textXPositionDuration, db.profile.textYPositionDuration)
			end
		end
		local currentCDText = mainPanel.cdText:GetText()
		local currentCDTextNumber = tonumber(currentCDText)
		if currentCDTextNumber and db.profile.durationEmphasizeTime > 0 and currentCDTextNumber <= db.profile.durationEmphasizeTime then
			mainPanel.cdText:SetFont(LibSharedMedia:Fetch("font", db.profile.fontName), db.profile.durationEmphasizeFontSize, fontFlags)
			mainPanel.cdText:SetTextColor(db.profile.durationEmphasizeColor[1], db.profile.durationEmphasizeColor[2], db.profile.durationEmphasizeColor[3], db.profile.durationEmphasizeColor[4])
		else
			mainPanel.cdText:SetFont(LibSharedMedia:Fetch("font", db.profile.fontName), db.profile.durationFontSize, fontFlags)
			mainPanel.cdText:SetTextColor(db.profile.durationColor[1], db.profile.durationColor[2], db.profile.durationColor[3], db.profile.durationColor[4])
		end
		mainPanel.cdText:SetText("")
		mainPanel.cdText:SetText(currentCDText)

		mainPanel.chargesText:SetJustifyH(db.profile.chargesAlign)
		mainPanel.chargesText:ClearAllPoints()
		if db.profile.mode == 2 then
			mainPanel.chargesText:SetPoint(db.profile.chargesAlign, mainPanel, "RIGHT", db.profile.textXPositionCharges, db.profile.textYPositionCharges)
		else
			if db.profile.chargesAlign == "LEFT" then
				mainPanel.chargesText:SetPoint("BOTTOMLEFT", mainPanel, "BOTTOMLEFT", db.profile.textXPositionCharges, db.profile.textYPositionCharges)
			elseif db.profile.chargesAlign == "RIGHT" then
				mainPanel.chargesText:SetPoint("BOTTOMRIGHT", mainPanel, "BOTTOMRIGHT", db.profile.textXPositionCharges, db.profile.textYPositionCharges)
			else
				mainPanel.chargesText:SetPoint("BOTTOM", mainPanel, "BOTTOM", db.profile.textXPositionCharges, db.profile.textYPositionCharges)
			end
		end
		local currentChargesText = tonumber(mainPanel.chargesText:GetText()) or 0
		if currentChargesText == 0 then
			mainPanel.chargesText:SetFont(LibSharedMedia:Fetch("font", db.profile.fontName), db.profile.chargesNoneFontSize, fontFlags)
			mainPanel.chargesText:SetTextColor(db.profile.chargesNoneColor[1], db.profile.chargesNoneColor[2], db.profile.chargesNoneColor[3], db.profile.chargesNoneColor[4])
		else
			mainPanel.chargesText:SetFont(LibSharedMedia:Fetch("font", db.profile.fontName), db.profile.chargesAvailableFontSize, fontFlags)
			mainPanel.chargesText:SetTextColor(db.profile.chargesAvailableColor[1], db.profile.chargesAvailableColor[2], db.profile.chargesAvailableColor[3], db.profile.chargesAvailableColor[4])
		end
		mainPanel.chargesText:SetText("")
		mainPanel.chargesText:SetText(currentChargesText)

		mainPanel.cooldown:SetDrawEdge(db.profile.cooldownEdge)
		mainPanel.cooldown:SetDrawSwipe(db.profile.cooldownSwipe)
		mainPanel.cooldown:SetReverse(db.profile.cooldownInverse)

		mainPanel.border:SetBackdrop({
			edgeFile = LibSharedMedia:Fetch("border", db.profile.borderName),
			edgeSize = db.profile.borderSize,
		})
		mainPanel.border:ClearAllPoints()
		mainPanel.border:SetPoint("TOPLEFT", mainPanel, "TOPLEFT", -db.profile.borderOffset, db.profile.borderOffset)
		mainPanel.border:SetPoint("BOTTOMRIGHT", mainPanel, "BOTTOMRIGHT", db.profile.borderOffset, -db.profile.borderOffset)
		mainPanel.border:SetBackdropBorderColor(db.profile.borderColor[1], db.profile.borderColor[2], db.profile.borderColor[3], db.profile.borderColor[4])
	end

	local function soundGet(info)
		for i, v in next, LibSharedMedia:List("sound") do
			if v == db.profile[info[#info]] then
				return i
			end
		end
	end
	local function soundSet(info, value)
		db.profile[info[#info]] = LibSharedMedia:List("sound")[value]
	end

	BigWigsLoader.RegisterMessage({}, "BigWigs_ProfileUpdate", function()
		ProfileUtils.ValidateMainSettings()
		ProfileUtils.ValidateMediaSettings()
		UpdateWidgets()
		isTesting = false
		local func = mainPanel:GetScript("OnEvent")
		func(mainPanel, "PLAYER_LEAVING_WORLD")
		mainPanel:UnregisterAllEvents()
		if not db.profile.disabled then -- Enable
			mainPanel:RegisterEvent("PLAYER_ENTERING_WORLD")
			mainPanel:RegisterEvent("PLAYER_LEAVING_WORLD")
			func(mainPanel, "PLAYER_ENTERING_WORLD")
		end
	end)

	local function GetSettings(info)
		return db.profile[info[#info]]
	end
	local function UpdateSettingsAndWidgets(info, value)
		local key = info[#info]
		db.profile[key] = value
		UpdateWidgets()
	end
	local function GetColor(info)
		local colorTable = db.profile[info[#info]]
		return colorTable[1], colorTable[2], colorTable[3], colorTable[4]
	end
	local function UpdateColorAndWidgets(info, r, g, b, a)
		local key = info[#info]
		db.profile[key] = {r, g, b, a}
		UpdateWidgets()
	end
	local function IsDisabled()
		return db.profile.disabled
	end
	local function IsDisabledOrTextMode()
		return db.profile.disabled or db.profile.mode == 2
	end
	BigWigsAPI.RegisterToolOptions("BattleRes", {
		type = "group",
		childGroups = "tab",
		name = L.battleResTitle,
		get = GetSettings,
		set = UpdateSettingsAndWidgets,
		args = {
			explainer1 = {
				type = "description",
				name = L.battleResDesc,
				order = 1,
				width = "full",
				fontSize = "medium",
			},
			explainer2 = {
				type = "description",
				name = L.battleResDesc2,
				order = 2,
				width = "full",
				fontSize = "medium",
			},
			disabled = {
				type = "toggle",
				name = L.disabled,
				order = 3,
				set = function(_, value)
					db.profile.disabled = value
					isTesting = false
					local func = mainPanel:GetScript("OnEvent")
					if value then -- Disable
						func(mainPanel, "PLAYER_LEAVING_WORLD")
						mainPanel:UnregisterAllEvents()
					else -- Enable
						mainPanel:RegisterEvent("PLAYER_ENTERING_WORLD")
						mainPanel:RegisterEvent("PLAYER_LEAVING_WORLD")
						func(mainPanel, "PLAYER_ENTERING_WORLD")
					end
				end,
			},
			modeIcon = {
				type = "toggle",
				name = L.battleResModeIcon,
				order = 4,
				get = function() return db.profile.mode == 1 end,
				set = function(_, value)
					if value then
						ProfileUtils.SetPreset("icon")
						UpdateWidgets()
					end
				end,
				disabled = IsDisabled,
			},
			modeText = {
				type = "toggle",
				name = L.battleResModeText,
				order = 5,
				get = function() return db.profile.mode == 2 end,
				set = function(_, value)
					if value then
						ProfileUtils.SetPreset("text")
						if isTesting then
							BigWigsLoader.Print(L.battleResModeTextTooltip)
						end
						UpdateWidgets()
					end
				end,
				disabled = IsDisabled,
			},
			general = {
				type = "group",
				name = L.general,
				order = 6,
				args = {
					test = {
						type = "execute",
						name = function()
							if isTesting then
								return L.stopTest
							else
								return L.startTest
							end
						end,
						func = function()
							if not isShowing then
								if not isTesting then
									isTesting = true
									mainPanel:Show()
									UpdateWidgets()
									local testTable = {[0] = "6", [1]="24", [2] = "1:15", [3] = "2:30", [4] = "3:37"}
									local i = 4
									local function TestLoop()
										if isTesting then
											mainPanel.cdText:SetText(testTable[i])
											mainPanel.chargesText:SetText(i)
											if db.profile.durationEmphasizeTime ~= 0 then
												local remainingSeconds = i < 3 and tonumber(testTable[i]) or 60
												if remainingSeconds > db.profile.durationEmphasizeTime then
													mainPanel.cdText:SetFontHeight(db.profile.durationFontSize)
													mainPanel.cdText:SetTextColor(db.profile.durationColor[1], db.profile.durationColor[2], db.profile.durationColor[3], db.profile.durationColor[4])
												else
													mainPanel.cdText:SetFontHeight(db.profile.durationEmphasizeFontSize)
													mainPanel.cdText:SetTextColor(db.profile.durationEmphasizeColor[1], db.profile.durationEmphasizeColor[2], db.profile.durationEmphasizeColor[3], db.profile.durationEmphasizeColor[4])
												end
											end
											mainPanel.cooldown:SetCooldown(GetTime(), 2)
											if i == 0 then
												mainPanel.chargesText:SetFontHeight(db.profile.chargesNoneFontSize)
												mainPanel.chargesText:SetTextColor(db.profile.chargesNoneColor[1], db.profile.chargesNoneColor[2], db.profile.chargesNoneColor[3], db.profile.chargesNoneColor[4])
												if db.profile.iconDesaturate == 3 then
													mainPanel.icon:SetDesaturated(true)
												end
											else
												mainPanel.chargesText:SetFontHeight(db.profile.chargesAvailableFontSize)
												mainPanel.chargesText:SetTextColor(db.profile.chargesAvailableColor[1], db.profile.chargesAvailableColor[2], db.profile.chargesAvailableColor[3], db.profile.chargesAvailableColor[4])
												if db.profile.iconDesaturate == 3 then
													mainPanel.icon:SetDesaturated(false)
												end
											end
											i = i - 1
											if i == -1 then i = 4 end
											BigWigsLoader.CTimerAfter(2, TestLoop)
										end
									end
									TestLoop()
									if db.profile.mode == 2 then
										BigWigsLoader.Print(L.battleResModeTextTooltip)
									end
								else
									isTesting = false
									mainPanel:Hide()
									mainPanel.cooldown:Clear()
									UpdateWidgets()
								end
							end
						end,
						width = 1.5,
						order = 1,
						disabled = function() return db.profile.disabled or isShowing end,
					},
					lock = {
						type = "toggle",
						name = L.lock,
						desc = L.lockDesc,
						order = 2,
						disabled = IsDisabled,
					},
					size = {
						type = "range",
						name = L.size,
						order = 3,
						min = 20,
						max = 150,
						step = 1,
						width = 1.5,
						disabled = IsDisabled,
					},
					fontName = {
						type = "select",
						name = L.font,
						order = 4,
						values = LibSharedMedia:List("font"),
						itemControl = "DDI-Font",
						get = function()
							for i, v in next, LibSharedMedia:List("font") do
								if v == db.profile.fontName then return i end
							end
						end,
						set = function(_, value)
							local list = LibSharedMedia:List("font")
							db.profile.fontName = list[value]
							UpdateWidgets()
						end,
						width = 1.5,
						disabled = IsDisabled,
					},
					outline = {
						type = "select",
						name = L.outline,
						order = 5,
						values = {
							NONE = L.none,
							OUTLINE = L.thin,
							THICKOUTLINE = L.thick,
						},
						width = 1,
						disabled = IsDisabled,
					},
					monochrome = {
						type = "toggle",
						name = L.monochrome,
						desc = L.monochromeDesc,
						order = 6,
						width = 2,
						disabled = IsDisabled,
					},
					borderColor = {
						type = "color",
						name = L.borderColor,
						order = 7,
						hasAlpha = true,
						width = 1,
						get = function()
							return db.profile.borderColor[1], db.profile.borderColor[2], db.profile.borderColor[3], db.profile.borderColor[4]
						end,
						set = UpdateColorAndWidgets,
						disabled = IsDisabledOrTextMode,
					},
					borderSize = {
						type = "range",
						name = L.borderSize,
						order = 8,
						min = 1,
						max = 32,
						step = 1,
						width = 1,
						disabled = IsDisabledOrTextMode,
					},
					borderOffset = {
						type = "range",
						name = L.borderOffset,
						order = 9,
						min = 0,
						max = 32,
						step = 1,
						width = 1,
						disabled = IsDisabledOrTextMode,
					},
					borderName = {
						type = "select",
						name = L.borderName,
						order = 10,
						values = LibSharedMedia:List("border"),
						get = function()
							for i, v in next, LibSharedMedia:List("border") do
								if v == db.profile.borderName then return i end
							end
						end,
						set = function(_, value)
							local list = LibSharedMedia:List("border")
							db.profile.borderName = list[value]
							UpdateWidgets()
						end,
						width = 1,
						disabled = IsDisabledOrTextMode,
					},
					soundHeader = {
						type = "header",
						name = L.battleResPlaySound,
						order = 11,
					},
					newResAvailableSound = {
						type = "select",
						name = L.sound,
						order = 12,
						get = soundGet,
						set = soundSet,
						values = LibSharedMedia:List("sound"),
						width = 2.5,
						itemControl = "DDI-Sound",
						disabled = IsDisabled,
					},
					resetHeader = {
						type = "header",
						name = "",
						order = 13,
					},
					reset = {
						type = "execute",
						name = L.reset,
						desc = L.resetDesc,
						func = function()
							ProfileUtils.ResetSettings()
							UpdateWidgets()
						end,
						order = 14,
						disabled = IsDisabled,
					},
					resetAll = {
						type = "execute",
						name = L.resetAll,
						desc = L.battleResResetAll,
						func = function()
							ProfileUtils.ResetSettings()
							UpdateWidgets()
						end,
						order = 15,
						disabled = IsDisabled,
					},
				},
			},
			duration = {
				type = "group",
				name = L.battleResDurationText,
				order = 7,
				args = {
					durationFontSize = {
						type = "range",
						name = L.fontSize,
						desc = L.fontSizeDesc,
						order = 1,
						width = 2,
						softMax = 100, max = 200, min = 12, step = 1,
						disabled = IsDisabled,
					},
					durationColor = {
						type = "color",
						name = L.fontColor,
						get = GetColor,
						set = UpdateColorAndWidgets,
						hasAlpha = true,
						order = 2,
						disabled = IsDisabled,
					},
					textXPositionDuration = {
						type = "range",
						name = L.positionX,
						desc = L.positionDesc,
						order = 3,
						max = 100,
						min = -100,
						step = 1,
						width = 1,
						disabled = IsDisabled,
					},
					textYPositionDuration = {
						type = "range",
						name = L.positionY,
						desc = L.positionDesc,
						order = 4,
						max = 100,
						min = -100,
						step = 1,
						width = 1,
						disabled = IsDisabled,
					},
					durationAlign = {
						type = "select",
						name = L.align,
						values = {
							L.LEFT,
							L.CENTER,
							L.RIGHT,
						},
						style = "radio",
						order = 5,
						get = function() return db.profile.durationAlign == "LEFT" and 1 or db.profile.durationAlign == "RIGHT" and 3 or 2 end,
						set = function(_, value)
							db.profile.durationAlign = value == 1 and "LEFT" or value == 3 and "RIGHT" or "CENTER"
							db.profile.textXPositionDuration = 0
							db.profile.textYPositionDuration = 0
							UpdateWidgets()
						end,
						disabled = IsDisabled,
					},
					durationEmphasizeHeader = {
						type = "header",
						name = L.emphasize,
						order = 6,
					},
					durationEmphasizeHeading = {
						type = "description",
						name = L.cooldownEmphasizeHeader,
						order = 7,
						width = "full",
						fontSize = "medium",
					},
					durationEmphasizeTime = {
						type = "range",
						name = L.emphasizeAt,
						order = 8,
						min = 0,
						max = 30,
						step = 1,
						width = "full",
						disabled = IsDisabled,
					},
					durationEmphasizeColor = {
						type = "color",
						name = L.fontColor,
						hasAlpha = true,
						get = GetColor,
						set = UpdateColorAndWidgets,
						order = 9,
						disabled = function() return db.profile.durationEmphasizeTime == 0 or db.profile.disabled end,
					},
					durationEmphasizeFontSize = {
						type = "range",
						name = L.fontSize,
						desc = L.fontSizeDesc,
						order = 10,
						softMax = 100, max = 200, min = 12, step = 1,
						disabled = function() return db.profile.durationEmphasizeTime == 0 or db.profile.disabled end,
					},
					resetHeader = {
						type = "header",
						name = "",
						order = 11,
					},
					reset = {
						type = "execute",
						name = L.reset,
						desc = L.resetDesc,
						func = function()
							ProfileUtils.ResetDurationSettings()
							UpdateWidgets()
						end,
						order = 12,
						disabled = IsDisabled,
					},
				},
			},
			charges = {
				type = "group",
				name = L.battleResChargesText,
				order = 8,
				args = {
					textXPositionCharges = {
						type = "range",
						name = L.positionX,
						desc = L.positionDesc,
						order = 1,
						max = 100,
						min = -100,
						step = 1,
						width = 1,
						disabled = IsDisabled,
					},
					textYPositionCharges = {
						type = "range",
						name = L.positionY,
						desc = L.positionDesc,
						order = 2,
						max = 100,
						min = -100,
						step = 1,
						width = 1,
						disabled = IsDisabled,
					},
					chargesAlign = {
						type = "select",
						name = L.align,
						values = {
							L.LEFT,
							L.CENTER,
							L.RIGHT,
						},
						style = "radio",
						order = 3,
						get = function() return db.profile.chargesAlign == "LEFT" and 1 or db.profile.chargesAlign == "RIGHT" and 3 or 2 end,
						set = function(_, value)
							db.profile.chargesAlign = value == 1 and "LEFT" or value == 3 and "RIGHT" or "CENTER"
							db.profile.textXPositionCharges = 0
							db.profile.textYPositionCharges = 0
							UpdateWidgets()
						end,
						disabled = IsDisabled,
					},
					chargesNoneHeader = {
						type = "header",
						name = L.battleResNoCharges,
						order = 4,
					},
					chargesNoneFontSize = {
						type = "range",
						name = L.fontSize,
						desc = L.fontSizeDesc,
						order = 5,
						width = 2,
						softMax = 100, max = 200, min = 12, step = 1,
						disabled = IsDisabled,
					},
					chargesNoneColor = {
						type = "color",
						name = L.fontColor,
						get = GetColor,
						set = UpdateColorAndWidgets,
						hasAlpha = true,
						order = 6,
						disabled = IsDisabled,
					},
					chargesAvailableHeader = {
						type = "header",
						name = L.battleResHasCharges,
						order = 7,
					},
					chargesAvailableFontSize = {
						type = "range",
						name = L.fontSize,
						desc = L.fontSizeDesc,
						order = 8,
						width = 2,
						softMax = 100, max = 200, min = 12, step = 1,
						disabled = IsDisabled,
					},
					chargesAvailableColor = {
						type = "color",
						name = L.fontColor,
						get = GetColor,
						set = UpdateColorAndWidgets,
						hasAlpha = true,
						order = 9,
						disabled = IsDisabled,
					},
					resetHeader = {
						type = "header",
						name = "",
						order = 10,
					},
					reset = {
						type = "execute",
						name = L.reset,
						desc = L.resetDesc,
						func = function()
							ProfileUtils.ResetChargesSettings()
							UpdateWidgets()
						end,
						order = 11,
						disabled = IsDisabled,
					},
				},
			},
			icon = {
				type = "group",
				name = L.icon,
				order = 9,
				args = {
					iconColor = {
						type = "color",
						name = L.iconColor,
						desc = L.iconColorDesc,
						get = GetColor,
						set = UpdateColorAndWidgets,
						hasAlpha = true,
						order = 1,
						disabled = IsDisabledOrTextMode,
					},
					iconTextureFromSpellID = {
						type = "input",
						get = function() return tostring(db.profile.iconTextureFromSpellID) end,
						set = function(_, spellIDAsString)
							local spellID = tonumber(spellIDAsString)
							db.profile.iconTextureFromSpellID = spellID
							UpdateWidgets()
						end,
						name = function()
							local texture = BigWigsLoader.GetSpellTexture(db.profile.iconTextureFromSpellID)
							return L.iconTextureSpellID:format(texture)
						end,
						order = 2,
						usage = L.iconTextureSpellIDError,
						validate = function(_, spellIDAsString)
							local spellID = tonumber(spellIDAsString)
							if spellID then
								local texture = BigWigsLoader.GetSpellTexture(spellID)
								if texture then
									return true
								end
							end
						end,
						disabled = IsDisabledOrTextMode,
					},
					iconDesaturate = {
						type = "select",
						name = L.desaturate,
						desc = L.desaturateDesc,
						values = {
							L.never,
							L.always,
							L.battleResNoCharges,
						},
						style = "radio",
						order = 5,
						disabled = IsDisabledOrTextMode,
					},
					cooldownHeader = {
						type = "header",
						name = L.cooldown,
						order = 6,
					},
					cooldownSwipe = {
						type = "toggle",
						name = L.showCooldownSwipe,
						desc = L.showCooldownSwipeDesc,
						order = 7,
						disabled = IsDisabledOrTextMode,
					},
					cooldownEdge =	{
						type = "toggle",
						name = L.showCooldownEdge,
						desc = L.showCooldownEdgeDesc,
						order = 8,
						disabled = IsDisabledOrTextMode,
					},
					cooldownInverse = {
						type = "toggle",
						name = L.inverse,
						desc = L.inverseSwipeDesc,
						order = 9,
						disabled = function() return not db.profile.cooldownSwipe or IsDisabledOrTextMode() end,
					},
					resetHeader = {
						type = "header",
						name = "",
						order = 16,
					},
					reset = {
						type = "execute",
						name = L.reset,
						desc = L.resetDesc,
						func = function()
							ProfileUtils.ResetIconSettings()
							UpdateWidgets()
						end,
						order = 17,
						disabled = IsDisabledOrTextMode,
					},
				},
			},
			exactPositioning = {
				type = "group",
				name = L.positionExact,
				order = 10,
				args = {
					posx = {
						type = "range",
						name = L.positionX,
						desc = L.positionDesc,
						min = -2048,
						max = 2048,
						step = 1,
						order = 1,
						width = "full",
						get = function()
							return db.profile.position[3]
						end,
						set = function(_, value)
							db.profile.position[3] = value
							UpdateWidgets()
						end,
						disabled = IsDisabled,
					},
					posy = {
						type = "range",
						name = L.positionY,
						desc = L.positionDesc,
						min = -2048,
						max = 2048,
						step = 1,
						order = 2,
						width = "full",
						get = function()
							return db.profile.position[4]
						end,
						set = function(_, value)
							db.profile.position[4] = value
							UpdateWidgets()
						end,
						disabled = IsDisabled,
					},
				},
			},
		},
	})
end
