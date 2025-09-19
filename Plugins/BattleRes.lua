--------------------------------------------------------------------------------
-- Module Declaration
--

if BigWigsLoader.isVanilla then return end

local plugin, L = BigWigs:NewPlugin("BattleRes")
if not plugin then return end

--------------------------------------------------------------------------------
-- Locals
--

local difficultiesWithBattleRes = {
	[14] = true, -- Normal
	[15] = true, -- Heroic
	[16] = true, -- Mythic
	[17] = true, -- LFR
	[33] = true, -- Timewalking (Raid)
}
local castableBattleResSpells = {
	[20484] = true, -- Rebirth
	[61999] = true, -- Raise Ally
	[95750] = true, -- Soulstone Resurrection
	[391054] = true, -- Intercession
	[345130] = true, -- Disposable Spectrophasic Reanimator
	[385403] = true, -- Tinker: Arclight Vital Correctors
	[384893] = true, -- Convincingly Realistic Jumper Cables
}


local LibSharedMedia = LibStub("LibSharedMedia-3.0")
local FONT = LibSharedMedia.MediaType and LibSharedMedia.MediaType.FONT or "font"
plugin.displayName = L.battleResTitle

local ProfileUtils = {}
local BigWigsLoader = BigWigsLoader
local battleResFrame

local isTesting, isShowing = false, false
local previousCharges = -1
local resCollector = {}
local fightStartTime = 0
local GetTime = GetTime

--------------------------------------------------------------------------------
-- Database
--

do
	local fontName = plugin:GetDefaultFont()
	local defaultDB = {
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
	plugin.defaultDB = defaultDB

	local validFramePoints = {
		["TOPLEFT"] = true, ["TOPRIGHT"] = true, ["BOTTOMLEFT"] = true, ["BOTTOMRIGHT"] = true,
		["TOP"] = true, ["BOTTOM"] = true, ["LEFT"] = true, ["RIGHT"] = true, ["CENTER"] = true,
	}
	ProfileUtils.ValidateMainSettings = function()
		for k, v in next, plugin.db.profile do
			local defaultType = type(defaultDB[k])
			if defaultType == "nil" then
				plugin.db.profile[k] = nil
			elseif type(v) ~= defaultType then
				plugin.db.profile[k] = defaultDB[k]
			end
		end

		if plugin.db.profile.mode < 1 or plugin.db.profile.mode > 2 then
			plugin.db.profile.mode = defaultDB.mode
		end
		if plugin.db.profile.size < 20 or plugin.db.profile.size > 150 then
			plugin.db.profile.size = defaultDB.size
		end
		if type(plugin.db.profile.position[1]) ~= "string" or type(plugin.db.profile.position[2]) ~= "string"
		or type(plugin.db.profile.position[3]) ~= "number" or type(plugin.db.profile.position[4]) ~= "number"
		or not validFramePoints[plugin.db.profile.position[1]] or not validFramePoints[plugin.db.profile.position[2]] then
			plugin.db.profile.position = defaultDB.position
		else
			local x = math.floor(plugin.db.profile.position[3]+0.5)
			if x ~= plugin.db.profile.position[3] then
				plugin.db.profile.position[3] = x
			end
			local y = math.floor(plugin.db.profile.position[4]+0.5)
			if y ~= plugin.db.profile.position[4] then
				plugin.db.profile.position[4] = y
			end
		end
		if plugin.db.profile.textXPositionDuration < -100 or plugin.db.profile.textXPositionDuration > 100 then
			plugin.db.profile.textXPositionDuration = defaultDB.textXPositionDuration
		else
			local x = math.floor(plugin.db.profile.textXPositionDuration+0.5)
			if x ~= plugin.db.profile.textXPositionDuration then
				plugin.db.profile.textXPositionDuration = x
			end
		end
		if plugin.db.profile.textYPositionDuration < -100 or plugin.db.profile.textYPositionDuration > 100 then
			plugin.db.profile.textYPositionDuration = defaultDB.textYPositionDuration
		else
			local y = math.floor(plugin.db.profile.textYPositionDuration+0.5)
			if y ~= plugin.db.profile.textYPositionDuration then
				plugin.db.profile.textYPositionDuration = y
			end
		end
		if plugin.db.profile.textXPositionCharges < -100 or plugin.db.profile.textXPositionCharges > 100 then
			plugin.db.profile.textXPositionCharges = defaultDB.textXPositionCharges
		else
			local x = math.floor(plugin.db.profile.textXPositionCharges+0.5)
			if x ~= plugin.db.profile.textXPositionCharges then
				plugin.db.profile.textXPositionCharges = x
			end
		end
		if plugin.db.profile.textYPositionCharges < -100 or plugin.db.profile.textYPositionCharges > 100 then
			plugin.db.profile.textYPositionCharges = defaultDB.textYPositionCharges
		else
			local y = math.floor(plugin.db.profile.textYPositionCharges+0.5)
			if y ~= plugin.db.profile.textYPositionCharges then
				plugin.db.profile.textYPositionCharges = y
			end
		end
		if plugin.db.profile.durationFontSize < 12 or plugin.db.profile.durationFontSize > 200 then
			plugin.db.profile.durationFontSize = defaultDB.durationFontSize
		end
		if plugin.db.profile.durationEmphasizeFontSize < 12 or plugin.db.profile.durationEmphasizeFontSize > 200 then
			plugin.db.profile.durationEmphasizeFontSize = defaultDB.durationEmphasizeFontSize
		end
		if plugin.db.profile.chargesNoneFontSize < 12 or plugin.db.profile.chargesNoneFontSize > 200 then
			plugin.db.profile.chargesNoneFontSize = defaultDB.chargesNoneFontSize
		end
		if plugin.db.profile.chargesAvailableFontSize < 12 or plugin.db.profile.chargesAvailableFontSize > 200 then
			plugin.db.profile.chargesAvailableFontSize = defaultDB.chargesAvailableFontSize
		end
		if plugin.db.profile.outline ~= "NONE" and plugin.db.profile.outline ~= "OUTLINE" and plugin.db.profile.outline ~= "THICKOUTLINE" then
			plugin.db.profile.outline = defaultDB.outline
		end
		for i = 1, 4 do
			local n = plugin.db.profile.borderColor[i]
			if type(n) ~= "number" or n < 0 or n > 1 then
				plugin.db.profile.borderColor = defaultDB.borderColor
				break -- If 1 entry is bad, reset the whole table
			end
		end
		if plugin.db.profile.borderOffset < 0 or plugin.db.profile.borderOffset > 32 then
			plugin.db.profile.borderOffset = defaultDB.borderOffset
		end
		if plugin.db.profile.borderSize < 1 or plugin.db.profile.borderSize > 32 then
			plugin.db.profile.borderSize = defaultDB.borderSize
		end
		if plugin.db.profile.durationAlign ~= "LEFT" and plugin.db.profile.durationAlign ~= "CENTER" and plugin.db.profile.durationAlign ~= "RIGHT" then
			plugin.db.profile.durationAlign = defaultDB.durationAlign
		end
		if plugin.db.profile.chargesAlign ~= "LEFT" and plugin.db.profile.chargesAlign ~= "CENTER" and plugin.db.profile.chargesAlign ~= "RIGHT" then
			plugin.db.profile.chargesAlign = defaultDB.chargesAlign
		end
		for i = 1, 4 do
			local n = plugin.db.profile.durationColor[i]
			if type(n) ~= "number" or n < 0 or n > 1 then
				plugin.db.profile.durationColor = defaultDB.durationColor
				break -- If 1 entry is bad, reset the whole table
			end
		end
		for i = 1, 4 do
			local n = plugin.db.profile.durationEmphasizeColor[i]
			if type(n) ~= "number" or n < 0 or n > 1 then
				plugin.db.profile.durationEmphasizeColor = defaultDB.durationEmphasizeColor
				break -- If 1 entry is bad, reset the whole table
			end
		end
		for i = 1, 4 do
			local n = plugin.db.profile.chargesNoneColor[i]
			if type(n) ~= "number" or n < 0 or n > 1 then
				plugin.db.profile.chargesNoneColor = defaultDB.chargesNoneColor
				break -- If 1 entry is bad, reset the whole table
			end
		end
		for i = 1, 4 do
			local n = plugin.db.profile.chargesAvailableColor[i]
			if type(n) ~= "number" or n < 0 or n > 1 then
				plugin.db.profile.chargesAvailableColor = defaultDB.chargesAvailableColor
				break -- If 1 entry is bad, reset the whole table
			end
		end
		if plugin.db.profile.durationEmphasizeTime < 0 or plugin.db.profile.durationEmphasizeTime > 30 then
			plugin.db.profile.durationEmphasizeTime = defaultDB.durationEmphasizeTime
		end
		for i = 1, 4 do
			local n = plugin.db.profile.iconColor[i]
			if type(n) ~= "number" or n < 0 or n > 1 then
				plugin.db.profile.iconColor = defaultDB.iconColor
				break -- If 1 entry is bad, reset the whole table
			end
		end
		if not BigWigsLoader.GetSpellTexture(plugin.db.profile.iconTextureFromSpellID) then
			plugin.db.profile.iconTextureFromSpellID = defaultDB.iconTextureFromSpellID
		end
		if plugin.db.profile.iconDesaturate < 1 or plugin.db.profile.iconDesaturate > 3 then
			plugin.db.profile.iconDesaturate = defaultDB.iconDesaturate
		end
		if not LibStub("LibSharedMedia-3.0"):IsValid("font", plugin.db.profile.fontName) then
			plugin.db.profile.fontName = defaultDB.fontName
		end
		if not LibStub("LibSharedMedia-3.0"):IsValid("border", plugin.db.profile.borderName) then
			plugin.db.profile.borderName = defaultDB.borderName -- If the border is suddenly invalid then reset the size and offset also
			plugin.db.profile.borderSize = defaultDB.borderSize
			plugin.db.profile.borderOffset = defaultDB.borderOffset
		end
		if not LibStub("LibSharedMedia-3.0"):IsValid("sound", plugin.db.profile.newResAvailableSound) then
			plugin.db.profile.newResAvailableSound = defaultDB.newResAvailableSound
		end
	end
	ProfileUtils.SetPreset = function(mode)
		if mode == "icon" then
			local position = plugin.db.profile.position
			ProfileUtils.ResetSettings()
			plugin.db.profile.position = position
			plugin.db.profile.mode = 1
		elseif mode == "text" then
			local position = plugin.db.profile.position
			ProfileUtils.ResetSettings()
			plugin.db.profile.position = position
			plugin.db.profile.mode = 2
			plugin.db.profile.borderName = "None"
			plugin.db.profile.durationAlign = "CENTER"
			plugin.db.profile.chargesAlign = "CENTER"
			plugin.db.profile.iconDesaturate = 1
			plugin.db.profile.cooldownEdge = false
			plugin.db.profile.cooldownSwipe = false
		end
	end
	ProfileUtils.ResetSettings = function()
		for k, v in next, defaultDB do
			plugin.db.profile[k] = v
		end
		plugin.db.profile.disabled = false
	end
	ProfileUtils.ResetGeneralSettings = function()
		plugin.db.profile.lock = defaultDB.lock
		plugin.db.profile.size = defaultDB.size
		plugin.db.profile.fontName = defaultDB.fontName
		plugin.db.profile.outline = defaultDB.outline
		plugin.db.profile.monochrome = defaultDB.monochrome
		plugin.db.profile.borderColor = defaultDB.borderColor
		plugin.db.profile.borderName = defaultDB.borderName
		plugin.db.profile.borderOffset = defaultDB.borderOffset
		plugin.db.profile.borderSize = defaultDB.borderSize
		plugin.db.profile.newResAvailableSound = defaultDB.newResAvailableSound
	end
	ProfileUtils.ResetDurationSettings = function()
		plugin.db.profile.textXPositionDuration = defaultDB.textXPositionDuration
		plugin.db.profile.textYPositionDuration = defaultDB.textYPositionDuration
		plugin.db.profile.durationFontSize = defaultDB.durationFontSize
		plugin.db.profile.durationAlign = defaultDB.durationAlign
		plugin.db.profile.durationColor = defaultDB.durationColor
		plugin.db.profile.durationEmphasizeTime = defaultDB.durationEmphasizeTime
		plugin.db.profile.durationEmphasizeColor = defaultDB.durationEmphasizeColor
		plugin.db.profile.durationEmphasizeFontSize = defaultDB.durationEmphasizeFontSize
	end
	ProfileUtils.ResetChargesSettings = function()
		plugin.db.profile.textXPositionCharges = defaultDB.textXPositionCharges
		plugin.db.profile.textYPositionCharges = defaultDB.textYPositionCharges
		plugin.db.profile.chargesNoneFontSize = defaultDB.chargesNoneFontSize
		plugin.db.profile.chargesAvailableFontSize = defaultDB.chargesAvailableFontSize
		plugin.db.profile.chargesAlign = defaultDB.chargesAlign
		plugin.db.profile.chargesNoneColor = defaultDB.chargesNoneColor
		plugin.db.profile.chargesAvailableColor = defaultDB.chargesAvailableColor
	end
	ProfileUtils.ResetIconSettings = function()
		plugin.db.profile.iconTextureFromSpellID = defaultDB.iconTextureFromSpellID
		plugin.db.profile.iconColor = defaultDB.iconColor
		plugin.db.profile.iconDesaturate = defaultDB.iconDesaturate
		plugin.db.profile.cooldownEdge = defaultDB.cooldownEdge
		plugin.db.profile.cooldownSwipe = defaultDB.cooldownSwipe
		plugin.db.profile.cooldownInverse = defaultDB.cooldownInverse
	end
end

-------------------------------------------------------------------------------
-- Options
--

do
	local function UpdateWidgets()
		if plugin.db.profile.mode == 2 then
			battleResFrame.icon:SetTexture(nil)
			if isTesting then
				battleResFrame.icon:SetColorTexture(0, 0, 0, 0.6)
			end
		else
			local texture = BigWigsLoader.GetSpellTexture(plugin.db.profile.iconTextureFromSpellID)
			battleResFrame.icon:SetTexture(texture)
		end
		battleResFrame.icon:SetVertexColor(plugin.db.profile.iconColor[1], plugin.db.profile.iconColor[2], plugin.db.profile.iconColor[3], plugin.db.profile.iconColor[4])
		if plugin.db.profile.iconDesaturate == 2 then
			battleResFrame.icon:SetDesaturated(true)
		else
			battleResFrame.icon:SetDesaturated(false)
		end

		battleResFrame:ClearAllPoints()
		do
			local point, relPoint = plugin.db.profile.position[1], plugin.db.profile.position[2]
			local x, y = plugin.db.profile.position[3], plugin.db.profile.position[4]
			battleResFrame:SetPoint(point, UIParent, relPoint, x, y)
		end
		battleResFrame:SetSize(plugin.db.profile.size, plugin.db.profile.size)

		local fontFlags = nil
		if plugin.db.profile.monochrome and plugin.db.profile.outline ~= "NONE" then
			fontFlags = "MONOCHROME," .. plugin.db.profile.outline
		elseif plugin.db.profile.monochrome then
			fontFlags = "MONOCHROME"
		elseif plugin.db.profile.outline ~= "NONE" then
			fontFlags = plugin.db.profile.outline
		end

		battleResFrame.cdText:SetJustifyH(plugin.db.profile.durationAlign)
		battleResFrame.cdText:ClearAllPoints()
		if plugin.db.profile.mode == 2 then
			battleResFrame.cdText:SetPoint(plugin.db.profile.durationAlign, battleResFrame, "LEFT", plugin.db.profile.textXPositionDuration, plugin.db.profile.textYPositionDuration)
		else
			if plugin.db.profile.durationAlign == "LEFT" then
				battleResFrame.cdText:SetPoint("TOPLEFT", battleResFrame, "TOPLEFT", plugin.db.profile.textXPositionDuration, plugin.db.profile.textYPositionDuration)
			elseif plugin.db.profile.durationAlign == "RIGHT" then
				battleResFrame.cdText:SetPoint("TOPRIGHT", battleResFrame, "TOPRIGHT", plugin.db.profile.textXPositionDuration, plugin.db.profile.textYPositionDuration)
			else
				battleResFrame.cdText:SetPoint("TOP", battleResFrame, "TOP", plugin.db.profile.textXPositionDuration, plugin.db.profile.textYPositionDuration)
			end
		end
		local currentCDText = battleResFrame.cdText:GetText()
		local currentCDTextNumber = tonumber(currentCDText)
		if currentCDTextNumber and plugin.db.profile.durationEmphasizeTime > 0 and currentCDTextNumber <= plugin.db.profile.durationEmphasizeTime then
			battleResFrame.cdText:SetFont(LibSharedMedia:Fetch("font", plugin.db.profile.fontName), plugin.db.profile.durationEmphasizeFontSize, fontFlags)
			battleResFrame.cdText:SetTextColor(plugin.db.profile.durationEmphasizeColor[1], plugin.db.profile.durationEmphasizeColor[2], plugin.db.profile.durationEmphasizeColor[3], plugin.db.profile.durationEmphasizeColor[4])
		else
			battleResFrame.cdText:SetFont(LibSharedMedia:Fetch("font", plugin.db.profile.fontName), plugin.db.profile.durationFontSize, fontFlags)
			battleResFrame.cdText:SetTextColor(plugin.db.profile.durationColor[1], plugin.db.profile.durationColor[2], plugin.db.profile.durationColor[3], plugin.db.profile.durationColor[4])
		end
		battleResFrame.cdText:SetText("")
		battleResFrame.cdText:SetText(currentCDText)

		battleResFrame.chargesText:SetJustifyH(plugin.db.profile.chargesAlign)
		battleResFrame.chargesText:ClearAllPoints()
		if plugin.db.profile.mode == 2 then
			battleResFrame.chargesText:SetPoint(plugin.db.profile.chargesAlign, battleResFrame, "RIGHT", plugin.db.profile.textXPositionCharges, plugin.db.profile.textYPositionCharges)
		else
			if plugin.db.profile.chargesAlign == "LEFT" then
				battleResFrame.chargesText:SetPoint("BOTTOMLEFT", battleResFrame, "BOTTOMLEFT", plugin.db.profile.textXPositionCharges, plugin.db.profile.textYPositionCharges)
			elseif plugin.db.profile.chargesAlign == "RIGHT" then
				battleResFrame.chargesText:SetPoint("BOTTOMRIGHT", battleResFrame, "BOTTOMRIGHT", plugin.db.profile.textXPositionCharges, plugin.db.profile.textYPositionCharges)
			else
				battleResFrame.chargesText:SetPoint("BOTTOM", battleResFrame, "BOTTOM", plugin.db.profile.textXPositionCharges, plugin.db.profile.textYPositionCharges)
			end
		end
		local currentChargesText = tonumber(battleResFrame.chargesText:GetText()) or 0
		if currentChargesText == 0 then
			battleResFrame.chargesText:SetFont(LibSharedMedia:Fetch("font", plugin.db.profile.fontName), plugin.db.profile.chargesNoneFontSize, fontFlags)
			battleResFrame.chargesText:SetTextColor(plugin.db.profile.chargesNoneColor[1], plugin.db.profile.chargesNoneColor[2], plugin.db.profile.chargesNoneColor[3], plugin.db.profile.chargesNoneColor[4])
		else
			battleResFrame.chargesText:SetFont(LibSharedMedia:Fetch("font", plugin.db.profile.fontName), plugin.db.profile.chargesAvailableFontSize, fontFlags)
			battleResFrame.chargesText:SetTextColor(plugin.db.profile.chargesAvailableColor[1], plugin.db.profile.chargesAvailableColor[2], plugin.db.profile.chargesAvailableColor[3], plugin.db.profile.chargesAvailableColor[4])
		end
		battleResFrame.chargesText:SetText("")
		battleResFrame.chargesText:SetText(currentChargesText)

		battleResFrame.cooldown:SetDrawEdge(plugin.db.profile.cooldownEdge)
		battleResFrame.cooldown:SetDrawSwipe(plugin.db.profile.cooldownSwipe)
		battleResFrame.cooldown:SetReverse(plugin.db.profile.cooldownInverse)

		battleResFrame.border:SetBackdrop({
			edgeFile = LibSharedMedia:Fetch("border", plugin.db.profile.borderName),
			edgeSize = plugin.db.profile.borderSize,
		})
		battleResFrame.border:ClearAllPoints()
		battleResFrame.border:SetPoint("TOPLEFT", battleResFrame, "TOPLEFT", -plugin.db.profile.borderOffset, plugin.db.profile.borderOffset)
		battleResFrame.border:SetPoint("BOTTOMRIGHT", battleResFrame, "BOTTOMRIGHT", plugin.db.profile.borderOffset, -plugin.db.profile.borderOffset)
		battleResFrame.border:SetBackdropBorderColor(plugin.db.profile.borderColor[1], plugin.db.profile.borderColor[2], plugin.db.profile.borderColor[3], plugin.db.profile.borderColor[4])
	end
	ProfileUtils.UpdateWidgets = UpdateWidgets

	local function soundGet(info)
		for i, v in next, LibSharedMedia:List("sound") do
			if v == plugin.db.profile[info[#info]] then
				return i
			end
		end
	end
	local function soundSet(info, value)
		plugin.db.profile[info[#info]] = LibSharedMedia:List("sound")[value]
	end

	local function GetSettings(info)
		return plugin.db.profile[info[#info]]
	end
	local function UpdateSettingsAndWidgets(info, value)
		local key = info[#info]
		plugin.db.profile[key] = value
		UpdateWidgets()
	end
	local function GetColor(info)
		local colorTable = plugin.db.profile[info[#info]]
		return colorTable[1], colorTable[2], colorTable[3], colorTable[4]
	end
	local function UpdateColorAndWidgets(info, r, g, b, a)
		local key = info[#info]
		plugin.db.profile[key] = {r, g, b, a}
		UpdateWidgets()
	end
	local function IsDisabled()
		return plugin.db.profile.disabled
	end
	local function IsDisabledOrTextMode()
		return plugin.db.profile.disabled or plugin.db.profile.mode == 2
	end

	plugin.pluginOptions = {
		type = "group",
		childGroups = "tab",
		order = 7,
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
					plugin.db.profile.disabled = value
					isTesting = false
					if value then -- Disable
						plugin:OnPluginDisable()
					else -- Enable
						plugin:OnPluginEnable()
					end
				end,
			},
			modeIcon = {
				type = "toggle",
				name = L.battleResModeIcon,
				order = 4,
				get = function() return plugin.db.profile.mode == 1 end,
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
				get = function() return plugin.db.profile.mode == 2 end,
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
									battleResFrame:Show()
									UpdateWidgets()
									local testTable = {[0] = "6", [1]="24", [2] = "1:15", [3] = "2:30", [4] = "3:37"}
									local i = 4
									local function TestLoop()
										if isTesting then
											battleResFrame.cdText:SetText(testTable[i])
											battleResFrame.chargesText:SetText(i)
											if plugin.db.profile.durationEmphasizeTime ~= 0 then
												local remainingSeconds = i < 3 and tonumber(testTable[i]) or 60
												if remainingSeconds > plugin.db.profile.durationEmphasizeTime then
													battleResFrame.cdText:SetFontHeight(plugin.db.profile.durationFontSize)
													battleResFrame.cdText:SetTextColor(plugin.db.profile.durationColor[1], plugin.db.profile.durationColor[2], plugin.db.profile.durationColor[3], plugin.db.profile.durationColor[4])
												else
													battleResFrame.cdText:SetFontHeight(plugin.db.profile.durationEmphasizeFontSize)
													battleResFrame.cdText:SetTextColor(plugin.db.profile.durationEmphasizeColor[1], plugin.db.profile.durationEmphasizeColor[2], plugin.db.profile.durationEmphasizeColor[3], plugin.db.profile.durationEmphasizeColor[4])
												end
											end
											battleResFrame.cooldown:SetCooldown(GetTime(), 2)
											if i == 0 then
												battleResFrame.chargesText:SetFontHeight(plugin.db.profile.chargesNoneFontSize)
												battleResFrame.chargesText:SetTextColor(plugin.db.profile.chargesNoneColor[1], plugin.db.profile.chargesNoneColor[2], plugin.db.profile.chargesNoneColor[3], plugin.db.profile.chargesNoneColor[4])
												if plugin.db.profile.iconDesaturate == 3 then
													battleResFrame.icon:SetDesaturated(true)
												end
											else
												battleResFrame.chargesText:SetFontHeight(plugin.db.profile.chargesAvailableFontSize)
												battleResFrame.chargesText:SetTextColor(plugin.db.profile.chargesAvailableColor[1], plugin.db.profile.chargesAvailableColor[2], plugin.db.profile.chargesAvailableColor[3], plugin.db.profile.chargesAvailableColor[4])
												if plugin.db.profile.iconDesaturate == 3 then
													battleResFrame.icon:SetDesaturated(false)
												end
											end
											i = i - 1
											if i == -1 then i = 4 end
											BigWigsLoader.CTimerAfter(2, TestLoop)
										end
									end
									TestLoop()
									if plugin.db.profile.mode == 2 then
										BigWigsLoader.Print(L.battleResModeTextTooltip)
									end
								else
									isTesting = false
									battleResFrame:Hide()
									battleResFrame.cooldown:Clear()
									UpdateWidgets()
								end
							end
						end,
						width = 1.5,
						order = 1,
						disabled = function() return plugin.db.profile.disabled or isShowing end,
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
								if v == plugin.db.profile.fontName then return i end
							end
						end,
						set = function(_, value)
							local list = LibSharedMedia:List("font")
							plugin.db.profile.fontName = list[value]
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
							return plugin.db.profile.borderColor[1], plugin.db.profile.borderColor[2], plugin.db.profile.borderColor[3], plugin.db.profile.borderColor[4]
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
								if v == plugin.db.profile.borderName then return i end
							end
						end,
						set = function(_, value)
							local list = LibSharedMedia:List("border")
							plugin.db.profile.borderName = list[value]
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
						get = function() return plugin.db.profile.durationAlign == "LEFT" and 1 or plugin.db.profile.durationAlign == "RIGHT" and 3 or 2 end,
						set = function(_, value)
							plugin.db.profile.durationAlign = value == 1 and "LEFT" or value == 3 and "RIGHT" or "CENTER"
							plugin.db.profile.textXPositionDuration = 0
							plugin.db.profile.textYPositionDuration = 0
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
						disabled = function() return plugin.db.profile.durationEmphasizeTime == 0 or plugin.db.profile.disabled end,
					},
					durationEmphasizeFontSize = {
						type = "range",
						name = L.fontSize,
						desc = L.fontSizeDesc,
						order = 10,
						softMax = 100, max = 200, min = 12, step = 1,
						disabled = function() return plugin.db.profile.durationEmphasizeTime == 0 or plugin.db.profile.disabled end,
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
						get = function() return plugin.db.profile.chargesAlign == "LEFT" and 1 or plugin.db.profile.chargesAlign == "RIGHT" and 3 or 2 end,
						set = function(_, value)
							plugin.db.profile.chargesAlign = value == 1 and "LEFT" or value == 3 and "RIGHT" or "CENTER"
							plugin.db.profile.textXPositionCharges = 0
							plugin.db.profile.textYPositionCharges = 0
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
						get = function() return tostring(plugin.db.profile.iconTextureFromSpellID) end,
						set = function(_, spellIDAsString)
							local spellID = tonumber(spellIDAsString)
							plugin.db.profile.iconTextureFromSpellID = spellID
							UpdateWidgets()
						end,
						name = function()
							local texture = BigWigsLoader.GetSpellTexture(plugin.db.profile.iconTextureFromSpellID)
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
						disabled = function() return not plugin.db.profile.cooldownSwipe or IsDisabledOrTextMode() end,
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
							return plugin.db.profile.position[3]
						end,
						set = function(_, value)
							plugin.db.profile.position[3] = value
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
							return plugin.db.profile.position[4]
						end,
						set = function(_, value)
							plugin.db.profile.position[4] = value
							UpdateWidgets()
						end,
						disabled = IsDisabled,
					},
				},
			},
		},
	}
end

--------------------------------------------------------------------------------
-- GUI Widgets
--

battleResFrame = CreateFrame("Button", nil, UIParent)
battleResFrame:Hide()
battleResFrame:SetSize(plugin.defaultDB.size, plugin.defaultDB.size)
do
	local point, relPoint = plugin.defaultDB.position[1], plugin.defaultDB.position[2]
	local x, y = plugin.defaultDB.position[3], plugin.defaultDB.position[4]
	battleResFrame:SetPoint(point, UIParent, relPoint, x, y)

	local icon = battleResFrame:CreateTexture()
	icon:SetAllPoints(battleResFrame)
	if plugin.defaultDB.mode == 2 then
		icon:SetTexture(nil)
	else
		local texture = BigWigsLoader.GetSpellTexture(plugin.defaultDB.iconTextureFromSpellID)
		icon:SetTexture(texture)
	end
	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	icon:SetVertexColor(plugin.defaultDB.iconColor[1], plugin.defaultDB.iconColor[2], plugin.defaultDB.iconColor[3], plugin.defaultDB.iconColor[4])
	if plugin.defaultDB.iconDesaturate == 2 then
		icon:SetDesaturated(true)
	end
	battleResFrame.icon = icon

	local border = CreateFrame("Frame", nil, battleResFrame, "BackdropTemplate")
	border:SetFrameLevel(border:GetFrameLevel()+1) -- Show the border above the cooldown swipe
	border:SetPoint("TOPLEFT", battleResFrame, "TOPLEFT", -plugin.defaultDB.borderOffset, plugin.defaultDB.borderOffset)
	border:SetPoint("BOTTOMRIGHT", battleResFrame, "BOTTOMRIGHT", plugin.defaultDB.borderOffset, -plugin.defaultDB.borderOffset)
	border:SetBackdrop({
		edgeFile = LibSharedMedia:Fetch("border", plugin.defaultDB.borderName),
		edgeSize = plugin.defaultDB.borderSize,
	})
	border:SetBackdropBorderColor(plugin.defaultDB.borderColor[1], plugin.defaultDB.borderColor[2], plugin.defaultDB.borderColor[3], plugin.defaultDB.borderColor[4])
	battleResFrame.border = border
end
do
	local cdText = battleResFrame.border:CreateFontString(nil, "OVERLAY")
	cdText:SetJustifyH(plugin.defaultDB.durationAlign)
	if plugin.defaultDB.mode == 2 then
		cdText:SetPoint(plugin.defaultDB.durationAlign, battleResFrame, "LEFT", plugin.defaultDB.textXPositionDuration, plugin.defaultDB.textYPositionDuration)
	else
		if plugin.defaultDB.durationAlign == "LEFT" then
			cdText:SetPoint("TOPLEFT", battleResFrame, "TOPLEFT", plugin.defaultDB.textXPositionDuration, plugin.defaultDB.textYPositionDuration)
		elseif plugin.defaultDB.durationAlign == "RIGHT" then
			cdText:SetPoint("TOPRIGHT", battleResFrame, "TOPRIGHT", plugin.defaultDB.textXPositionDuration, plugin.defaultDB.textYPositionDuration)
		else
			cdText:SetPoint("TOP", battleResFrame, "TOP", plugin.defaultDB.textXPositionDuration, plugin.defaultDB.textYPositionDuration)
		end
	end
	cdText:SetSize(300, 20)
	cdText:SetTextColor(plugin.defaultDB.durationColor[1], plugin.defaultDB.durationColor[2], plugin.defaultDB.durationColor[3], plugin.defaultDB.durationColor[4])
	if not cdText.SetFontHeight then -- XXX [Mainline:✓ MoP:✓ Wrath:✗ Vanilla:✗]
		cdText.SetFontHeight = function(self, num)
			local flags = nil
			if plugin.defaultDB.monochrome and plugin.defaultDB.outline ~= "NONE" then
				flags = "MONOCHROME," .. plugin.defaultDB.outline
			elseif plugin.defaultDB.monochrome then
				flags = "MONOCHROME"
			elseif plugin.defaultDB.outline ~= "NONE" then
				flags = plugin.defaultDB.outline
			end
			self:SetFont(LibSharedMedia:Fetch("font", plugin.defaultDB.fontName), num, flags)
		end
	end
	battleResFrame.cdText = cdText

	local chargesText = battleResFrame.border:CreateFontString(nil, "OVERLAY")
	chargesText:SetJustifyH(plugin.defaultDB.chargesAlign)
	if plugin.defaultDB.mode == 2 then
		chargesText:SetPoint(plugin.defaultDB.chargesAlign, battleResFrame, "RIGHT", plugin.defaultDB.textXPositionCharges, plugin.defaultDB.textYPositionCharges)
	else
		if plugin.defaultDB.chargesAlign == "LEFT" then
			chargesText:SetPoint("BOTTOMLEFT", battleResFrame, "BOTTOMLEFT", plugin.defaultDB.textXPositionCharges, plugin.defaultDB.textYPositionCharges)
		elseif plugin.defaultDB.chargesAlign == "RIGHT" then
			chargesText:SetPoint("BOTTOMRIGHT", battleResFrame, "BOTTOMRIGHT", plugin.defaultDB.textXPositionCharges, plugin.defaultDB.textYPositionCharges)
		else
			chargesText:SetPoint("BOTTOM", battleResFrame, "BOTTOM", plugin.defaultDB.textXPositionCharges, plugin.defaultDB.textYPositionCharges)
		end
	end
	chargesText:SetSize(300, 20)
	chargesText:SetTextColor(plugin.defaultDB.chargesNoneColor[1], plugin.defaultDB.chargesNoneColor[2], plugin.defaultDB.chargesNoneColor[3], plugin.defaultDB.chargesNoneColor[4])
	if not chargesText.SetFontHeight then -- XXX [Mainline:✓ MoP:✓ Wrath:✗ Vanilla:✗]
		chargesText.SetFontHeight = function(self, num)
			local flags = nil
			if plugin.defaultDB.monochrome and plugin.defaultDB.outline ~= "NONE" then
				flags = "MONOCHROME," .. plugin.defaultDB.outline
			elseif plugin.defaultDB.monochrome then
				flags = "MONOCHROME"
			elseif plugin.defaultDB.outline ~= "NONE" then
				flags = plugin.defaultDB.outline
			end
			self:SetFont(LibSharedMedia:Fetch("font", plugin.defaultDB.fontName), num, flags)
		end
	end
	battleResFrame.chargesText = chargesText

	do
		local flags = nil
		if plugin.defaultDB.monochrome and plugin.defaultDB.outline ~= "NONE" then
			flags = "MONOCHROME," .. plugin.defaultDB.outline
		elseif plugin.defaultDB.monochrome then
			flags = "MONOCHROME"
		elseif plugin.defaultDB.outline ~= "NONE" then
			flags = plugin.defaultDB.outline
		end

		cdText:SetFont(LibSharedMedia:Fetch("font", plugin.defaultDB.fontName), plugin.defaultDB.durationFontSize, flags)
		cdText:SetText("")
		cdText:SetText("0:00")
		chargesText:SetFont(LibSharedMedia:Fetch("font", plugin.defaultDB.fontName), plugin.defaultDB.chargesNoneFontSize, flags)
		chargesText:SetText("")
		chargesText:SetText(0)
	end

	local cooldown = CreateFrame("Cooldown", nil, battleResFrame, "CooldownFrameTemplate")
	cooldown:SetAllPoints(battleResFrame)
	cooldown:SetDrawBling(false)
	cooldown:SetDrawEdge(plugin.defaultDB.cooldownEdge)
	cooldown:SetDrawSwipe(plugin.defaultDB.cooldownSwipe)
	cooldown:SetReverse(plugin.defaultDB.cooldownInverse)
	cooldown:SetHideCountdownNumbers(true) -- Blizzard
	cooldown.noCooldownCount = true -- OmniCC
	battleResFrame.cooldown = cooldown

	local updater = battleResFrame:CreateAnimationGroup()
	updater:SetLooping("REPEAT")
	battleResFrame.updater = updater

	local GetSpellCharges, floor, prevStartTime = C_Spell.GetSpellCharges, math.floor, 0
	updater:SetScript("OnLoop", function()
		local chargesInfoTable = GetSpellCharges(20484) -- Rebirth
		if chargesInfoTable then
			local startTime = chargesInfoTable.cooldownStartTime
			local fullDuration = chargesInfoTable.cooldownDuration
			if startTime ~= prevStartTime then
				prevStartTime = startTime
				if plugin.db.profile.mode == 1 then
					cooldown:Clear()
					cooldown:SetCooldown(startTime, fullDuration)
				end
			end
			local remainingSeconds = fullDuration - (GetTime() - startTime)
			local minutes = floor(remainingSeconds / 60)
			local seconds = floor(remainingSeconds - (minutes*60))
			if plugin.db.profile.durationEmphasizeTime ~= 0 then
				if remainingSeconds > plugin.db.profile.durationEmphasizeTime then
					cdText:SetFontHeight(plugin.db.profile.durationFontSize)
					cdText:SetTextColor(plugin.db.profile.durationColor[1], plugin.db.profile.durationColor[2], plugin.db.profile.durationColor[3], plugin.db.profile.durationColor[4])
				else
					cdText:SetFontHeight(plugin.db.profile.durationEmphasizeFontSize)
					cdText:SetTextColor(plugin.db.profile.durationEmphasizeColor[1], plugin.db.profile.durationEmphasizeColor[2], plugin.db.profile.durationEmphasizeColor[3], plugin.db.profile.durationEmphasizeColor[4])
				end
			end
			if minutes == 0 then
				cdText:SetText(seconds)
			else
				cdText:SetFormattedText("%d:%02d", minutes, seconds)
			end
			local currentCharges = chargesInfoTable.currentCharges
			if currentCharges == 0 then
				chargesText:SetFontHeight(plugin.db.profile.chargesNoneFontSize)
				chargesText:SetTextColor(plugin.db.profile.chargesNoneColor[1], plugin.db.profile.chargesNoneColor[2], plugin.db.profile.chargesNoneColor[3], plugin.db.profile.chargesNoneColor[4])
				if plugin.db.profile.iconDesaturate == 3 then
					battleResFrame.icon:SetDesaturated(true)
				end
			else
				chargesText:SetFontHeight(plugin.db.profile.chargesAvailableFontSize)
				chargesText:SetTextColor(plugin.db.profile.chargesAvailableColor[1], plugin.db.profile.chargesAvailableColor[2], plugin.db.profile.chargesAvailableColor[3], plugin.db.profile.chargesAvailableColor[4])
				if plugin.db.profile.iconDesaturate == 3 then
					battleResFrame.icon:SetDesaturated(false)
				end
			end
			chargesText:SetText(currentCharges)
			if currentCharges > previousCharges and previousCharges >= 0 then
				local soundName = plugin.db.profile.newResAvailableSound
				if soundName ~= "None" then
					local sound = LibSharedMedia:Fetch("sound", soundName, true)
					if sound then
						plugin:PlaySoundFile(sound)
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
battleResFrame:SetFrameStrata("MEDIUM")
battleResFrame:SetFixedFrameStrata(true)
battleResFrame:SetFrameLevel(8500)
battleResFrame:SetFixedFrameLevel(true)
battleResFrame:SetClampedToScreen(true)
battleResFrame:SetMovable(true)
battleResFrame:RegisterForDrag("LeftButton")
battleResFrame:EnableMouse(true)
battleResFrame:SetScript("OnDragStart", function(self)
	if not plugin.db.profile.lock then
		self:StartMoving()
	end
end)
battleResFrame:SetScript("OnDragStop", function(self)
	if not plugin.db.profile.lock then
		self:StopMovingOrSizing()
		local point, _, relPoint, x, y = self:GetPoint()
		x = math.floor(x+0.5)
		y = math.floor(y+0.5)
		plugin.db.profile.position = {point, relPoint, x, y}
		if BigWigsOptions and BigWigsOptions:IsOpen() then
			plugin:UpdateGUI() -- Update X/Y if GUI is open
		end
	end
end)
battleResFrame:SetScript("OnEnter", function(self)
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
	if isTesting and plugin.db.profile.mode == 2 then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L.battleResModeTextTooltip, 1, 1, 1)
	end
	GameTooltip:Show()
end)
battleResFrame:SetScript("OnLeave", GameTooltip_Hide)

--------------------------------------------------------------------------------
-- Res history
--

do
	local GetClassColor = C_ClassColor and C_ClassColor.GetClassColor or function(class) -- XXX [Mainline:✓ MoP:✗ Wrath:✗ Vanilla:✗]
		return {GenerateHexColor = function()
			local tbl = RAID_CLASS_COLORS[class]
			return format("ff%02x%02x%02x", tbl.r * 255, tbl.g * 255, tbl.b * 255)
		end}
	end
	local CombatLogGetCurrentEventInfo, UnitClass = CombatLogGetCurrentEventInfo, UnitClass
	battleResFrame:SetScript("OnEvent", function()
		local _, event, _, _, sourceName, _, _, _, targetName, _, _, spellId = CombatLogGetCurrentEventInfo()
		if event == "SPELL_RESURRECT" then
			if castableBattleResSpells[spellId] then
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

-------------------------------------------------------------------------------
-- Initialization
--

do
	local function DelayStartOfInstance() -- Difficulty info isn't accurate until 1 frame after PEW
		local _, _, diffID = BigWigsLoader.GetInstanceInfo()
		if difficultiesWithBattleRes[diffID] then
			isShowing = true
			isTesting = false
			battleResFrame:Show()
			battleResFrame.cdText:SetText("0:00")
			battleResFrame.chargesText:SetText(0)
			plugin:RegisterEvent("ENCOUNTER_START")
			plugin:RegisterEvent("ENCOUNTER_END")
			plugin:RegisterEvent("PLAYER_REGEN_DISABLED")
			plugin:RegisterEvent("PLAYER_REGEN_ENABLED")
			if IsEncounterInProgress() then
				previousCharges = -1
				resCollector = {}
				fightStartTime = GetTime()
				battleResFrame.updater:Play()
				battleResFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			end
		elseif diffID == 23 then -- Mythic
			plugin:RegisterEvent("CHALLENGE_MODE_START")
		elseif diffID == 8 then -- Mythic+
			isShowing = true
			isTesting = false
			battleResFrame:Show()
			battleResFrame.cdText:SetText("0:00")
			battleResFrame.chargesText:SetText(0)
			previousCharges = -1
			resCollector = {}
			fightStartTime = GetTime()
			battleResFrame.updater:Play()
			battleResFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			plugin:RegisterEvent("PLAYER_REGEN_DISABLED")
			plugin:RegisterEvent("PLAYER_REGEN_ENABLED")
		end
	end
	local isEnabled = false
	local function SwapProfile()
		ProfileUtils.ValidateMainSettings()
		ProfileUtils.UpdateWidgets()
		if plugin.db.profile.disabled then
			isEnabled = false
			plugin:OnPluginDisable()
		elseif not isEnabled then
			isEnabled = true
			DelayStartOfInstance()
		end
	end
	function plugin:OnPluginEnable()
		local oldDB = BigWigsLoader.db:GetNamespace("BattleRes", true)
		if oldDB and not oldDB.profile.imported then
			for k, v in next, oldDB.profile do
				plugin.db.profile[k] = v
			end
			oldDB.profile.imported = true
		end
		self:RegisterMessage("BigWigs_ProfileUpdate", SwapProfile)
		ProfileUtils.ValidateMainSettings()
		ProfileUtils.UpdateWidgets()
		if not self.db.profile.disabled then
			isEnabled = false
			BigWigsLoader.CTimerAfter(0, DelayStartOfInstance)
		else
			isEnabled = false
		end
	end
end

function plugin:OnPluginDisable()
	isShowing = false
	battleResFrame:EnableMouse(true)
	battleResFrame:Hide()
	battleResFrame.updater:Stop()
	battleResFrame.cooldown:Clear()
	if plugin.db.profile.iconDesaturate == 3 then
		battleResFrame.icon:SetDesaturated(false)
	end
	battleResFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:ENCOUNTER_START()
	previousCharges = -1
	resCollector = {}
	fightStartTime = GetTime()
	battleResFrame.cdText:SetText("0:00")
	battleResFrame.chargesText:SetText(0)
	battleResFrame.updater:Play()
	battleResFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function plugin:ENCOUNTER_END()
	battleResFrame.updater:Stop()
	battleResFrame.cooldown:Clear()
	battleResFrame.cdText:SetText("0:00")
	battleResFrame.chargesText:SetText(0)
	if self.db.profile.iconDesaturate == 3 then
		battleResFrame.icon:SetDesaturated(false)
	end
	battleResFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end
plugin.CHALLENGE_MODE_COMPLETED = plugin.ENCOUNTER_END

function plugin:CHALLENGE_MODE_START()
	previousCharges = -1
	resCollector = {}
	isShowing = true
	isTesting = false
	fightStartTime = GetTime()+9
	battleResFrame:Show()
	battleResFrame.cdText:SetText("0:00")
	battleResFrame.chargesText:SetText(0)
	battleResFrame.updater:Play()
	self:RegisterEvent("CHALLENGE_MODE_COMPLETED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	battleResFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function plugin:PLAYER_REGEN_DISABLED()
	battleResFrame:EnableMouse(false)
end

function plugin:PLAYER_REGEN_ENABLED()
	battleResFrame:EnableMouse(true)
end
