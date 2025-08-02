-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin, L = BigWigs:NewPlugin("Countdown")
if not plugin then return end

local defaultVoice = "English: Amy"
do
	local locale = GetLocale()
	local voiceMap = {
		enUS = {"English: Default (%s)", "Male", "Female"},
		deDE = {"Deutsch: Standard (%s)", "Männlich", "Weiblich"},
		esES = {"Español (es): Predeterminado (%s)", "Masculino", "Femenino"},
		esMX = {"Español (mx): Predeterminado (%s)", "Masculino", "Femenino"},
		frFR = {"Français : Défaut (%s)", "Homme", "Femme"},
		itIT = {"Italiano: Predefinito (%s)", "Maschio", "Femmina"},
		koKR = {"한국어 : 기본 (%s)", "남성", "여성"},
		ptBR = {"Português: Padrão (%s)", "Masculino", "Feminino"},
		ruRU = {"Русский: По умолчанию (%s)", "Мужской", "Женский"},
		zhCN = {"简体中文:默认(%s)", "男性", "女性"},
		zhTW = {"繁體中文:預設值(%s)", "男性", "女性"},
	}
	if locale ~= "enUS" and voiceMap[locale] then
		defaultVoice = ("%s: Default (Female)"):format(locale)
	end
end

-------------------------------------------------------------------------------
-- Locals
--

local media = LibStub("LibSharedMedia-3.0")
local FONT = media.MediaType and media.MediaType.FONT or "font"
local BigWigsAPI = BigWigsAPI
plugin.displayName = L.countdown

local countdownAnchor = nil
local countdownFrame = nil
local countdownText = nil
local inConfigMode = false

local validFramePoints = {
	["TOPLEFT"] = L.TOPLEFT, ["TOPRIGHT"] = L.TOPRIGHT, ["BOTTOMLEFT"] = L.BOTTOMLEFT, ["BOTTOMRIGHT"] = L.BOTTOMRIGHT,
	["TOP"] = L.TOP, ["BOTTOM"] = L.BOTTOM, ["LEFT"] = L.LEFT, ["RIGHT"] = L.RIGHT, ["CENTER"] = L.CENTER,
}

--------------------------------------------------------------------------------
-- Profile
--

plugin.defaultDB = {
	textEnabled = true,
	fontName = plugin:GetDefaultFont(),
	outline = "THICKOUTLINE",
	fontSize = 48,
	monochrome = false,
	fontColor = { r = 1, g = 0, b = 0 },
	voice = defaultVoice,
	countdownTime = 5,
	position = {"TOP", "TOP", 0, -300},
	bossCountdowns = {},
}

local function UpdateFont()
	local flags = nil
	if plugin.db.profile.monochrome and plugin.db.profile.outline ~= "NONE" then
		flags = "MONOCHROME," .. plugin.db.profile.outline
	elseif plugin.db.profile.monochrome then
		flags = "MONOCHROME"
	elseif plugin.db.profile.outline ~= "NONE" then
		flags = plugin.db.profile.outline
	end
	countdownText:SetFont(media:Fetch(FONT, plugin.db.profile.fontName), plugin.db.profile.fontSize, flags)
	countdownText:SetTextColor(plugin.db.profile.fontColor.r, plugin.db.profile.fontColor.g, plugin.db.profile.fontColor.b)
end

local function updateProfile()
	local db = plugin.db.profile

	for k, v in next, db do
		local defaultType = type(plugin.defaultDB[k])
		if defaultType == "nil" then
			db[k] = nil
		elseif type(v) ~= defaultType then
			db[k] = plugin.defaultDB[k]
		end
	end

	if not media:IsValid(FONT, db.fontName) then
		db.fontName = plugin:GetDefaultFont()
	end
	if db.outline ~= "NONE" and db.outline ~= "OUTLINE" and db.outline ~= "THICKOUTLINE" then
		db.outline = plugin.defaultDB.outline
	end
	if db.fontSize < 20 or db.fontSize > 200 then
		db.fontSize = plugin.defaultDB.fontSize
	end
	if type(db.fontColor.r) ~= "number" or db.fontColor.r < 0 or db.fontColor.r > 1
	or type(db.fontColor.g) ~= "number" or db.fontColor.g < 0 or db.fontColor.g > 1
	or type(db.fontColor.b) ~= "number" or db.fontColor.b < 0 or db.fontColor.b > 1 then
		db.fontColor = plugin.defaultDB.fontColor
	end
	if db.countdownTime < 3 or db.countdownTime > 10 then
		db.countdownTime = plugin.defaultDB.countdownTime
	end
	local checkCount = math.floor(db.countdownTime+0.5)
	if checkCount ~= db.countdownTime then
		db.countdownTime = checkCount
	end
	if type(db.position[1]) ~= "string" or type(db.position[2]) ~= "string"
	or type(db.position[3]) ~= "number" or type(db.position[4]) ~= "number"
	or not validFramePoints[db.position[1]] or not validFramePoints[db.position[2]] then
		db.position = plugin.defaultDB.position
	else
		local x = math.floor(db.position[3]+0.5)
		if x ~= db.position[3] then
			db.position[3] = x
		end
		local y = math.floor(db.position[4]+0.5)
		if y ~= db.position[4] then
			db.position[4] = y
		end
	end

	UpdateFont()
	countdownAnchor:RefixPosition()

	-- Reset invalid voice selections
	if not BigWigsAPI:HasCountdown(db.voice) then
		db.voice = defaultVoice
	end
	for boss, tbl in next, db.bossCountdowns do
		for ability, chosenVoice in next, tbl do
			if not BigWigsAPI:HasCountdown(chosenVoice) then
				db.bossCountdowns[boss][ability] = nil
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Anchors & Frames
--

local function showAnchors(_, mode)
	if not mode or mode == "Messages" then
		inConfigMode = true
		countdownAnchor:Show()
		countdownFrame:Show()
		countdownText:SetText("5")
	end
end

local function hideAnchors(_, mode)
	if not mode or mode == "Messages" then
		inConfigMode = false
		countdownAnchor:Hide()
		countdownFrame:Hide()
	end
end

do
	local function OnDragStart(self)
		self:StartMoving()
	end
	local function OnDragStop(self)
		self:StopMovingOrSizing()
		local point, _, relPoint, x, y = self:GetPoint()
		x = math.floor(x+0.5)
		y = math.floor(y+0.5)
		plugin.db.profile.position = {point, relPoint, x, y}
		self:RefixPosition()
		if BigWigsOptions and BigWigsOptions:IsOpen() then
			plugin:UpdateGUI() -- Update X/Y if GUI is open
		end
	end
	local function RefixPosition(self)
		self:ClearAllPoints()
		local point, relPoint = plugin.db.profile.position[1], plugin.db.profile.position[2]
		local x, y = plugin.db.profile.position[3], plugin.db.profile.position[4]
		self:SetPoint(point, UIParent, relPoint, x, y)
	end

	countdownAnchor = CreateFrame("Frame", nil, UIParent)
	countdownAnchor:EnableMouse(true)
	countdownAnchor:SetClampedToScreen(true)
	countdownAnchor:SetMovable(true)
	countdownAnchor:RegisterForDrag("LeftButton")
	countdownAnchor:SetWidth(80)
	countdownAnchor:SetHeight(80)
	countdownAnchor:SetFrameStrata("HIGH")
	countdownAnchor:SetFixedFrameStrata(true)
	countdownAnchor:SetFrameLevel(20)
	countdownAnchor:SetFixedFrameLevel(true)
	countdownAnchor:SetScript("OnDragStart", OnDragStart)
	countdownAnchor:SetScript("OnDragStop", OnDragStop)
	countdownAnchor.RefixPosition = RefixPosition
	local point, relPoint = plugin.defaultDB.position[1], plugin.defaultDB.position[2]
	local x, y = plugin.defaultDB.position[3], plugin.defaultDB.position[4]
	countdownAnchor:SetPoint(point, UIParent, relPoint, x, y)
	countdownAnchor:Hide()
	local bg = countdownAnchor:CreateTexture()
	bg:SetAllPoints(countdownAnchor)
	bg:SetColorTexture(0, 0, 0, 0.3)
	local header = countdownAnchor:CreateFontString()
	header:SetFont(plugin:GetDefaultFont(12))
	header:SetShadowOffset(1, -1)
	header:SetTextColor(1,0.82,0,1)
	header:SetText(L.textCountdown)
	header:SetPoint("BOTTOM", countdownAnchor, "TOP", 0, 5)
	header:SetJustifyV("MIDDLE")
	header:SetJustifyH("CENTER")
end

-------------------------------------------------------------------------------
-- Options
--

local function voiceSorting()
	local list = BigWigsAPI:GetCountdownList()
	local sorted = {}
	for k in next, list do
		if k ~= "none" and k ~= "simple" then
			sorted[#sorted + 1] = k
		end
	end
	table.sort(sorted, function(a, b) return list[a] < list[b] end)
	table.insert(sorted, 1, "none")
	table.insert(sorted, 2, "simple")
	return sorted
end

do
	local checkTextDisabled = function() return not plugin.db.profile.textEnabled end
	plugin.pluginOptions = {
		name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Countdown:20|t ".. L.countdown,
		type = "group",
		childGroups = "tab",
		get = function(info) return plugin.db.profile[info[#info]] end,
		set = function(info, value)
			plugin.db.profile[info[#info]] = value
			UpdateFont()
		end,
		order = 5,
		args = {
			general = {
				type = "group",
				name = L.general,
				order = 1,
				args = {
					heading = {
						type = "description",
						name = L.countdownDesc.. "\n\n",
						order = 1,
						width = "full",
						fontSize = "medium",
					},
					countdownTime = {
						name = L.countdownAt,
						desc = L.countdownAt_desc,
						type = "range", min = 3, max = 10, step = 1,
						order = 2,
						width = 2,
					},
					countdownTest = {
						name = L.countdownTest,
						type = "execute",
						handler = plugin,
						func = "TestCountdown",
						order = 3,
						width = 1.2,
					},
					audioSpacer = {
						type = "description",
						name = "\n\n",
						order = 4,
						width = "full",
						fontSize = "medium",
					},
					audioHeader = {
						type = "header",
						name = L.countdownAudioHeader,
						order = 5,
					},
					voice = {
						name = L.countdownVoice,
						type = "select",
						values = BigWigsAPI.GetCountdownList,
						sorting = voiceSorting,
						order = 6,
						width = "full",
					},
					textSpacer = {
						type = "description",
						name = "\n\n",
						order = 7,
						width = "full",
						fontSize = "medium",
					},
					textHeader = {
						type = "header",
						name = L.countdownTextHeader,
						order = 8,
					},
					textEnabled = {
						type = "toggle",
						name = L.textCountdown,
						desc = L.textCountdownDesc,
						order = 9,
						width = "full",
					},
					fontName = {
						type = "select",
						name = L.font,
						order = 10,
						values = media:List(FONT),
						itemControl = "DDI-Font",
						get = function()
							for i, v in next, media:List(FONT) do
								if v == plugin.db.profile.fontName then return i end
							end
						end,
						set = function(_, value)
							local list = media:List(FONT)
							plugin.db.profile.fontName = list[value]
							UpdateFont()
						end,
						width = 2,
						disabled = checkTextDisabled,
					},
					outline = {
						type = "select",
						name = L.outline,
						order = 11,
						values = {
							NONE = L.none,
							OUTLINE = L.thin,
							THICKOUTLINE = L.thick,
						},
						disabled = checkTextDisabled,
					},
					fontColor = {
						type = "color",
						name = L.countdownColor,
						get = function(info)
							return plugin.db.profile.fontColor.r, plugin.db.profile.fontColor.g, plugin.db.profile.fontColor.b
						end,
						set = function(info, r, g, b)
							plugin.db.profile.fontColor.r, plugin.db.profile.fontColor.g, plugin.db.profile.fontColor.b = r, g, b
							UpdateFont()
						end,
						order = 12,
						disabled = checkTextDisabled,
					},
					fontSize = {
						type = "range",
						name = L.fontSize,
						desc = L.fontSizeDesc,
						order = 13,
						softMax = 100, max = 200, min = 20, step = 1,
						disabled = checkTextDisabled,
					},
					monochrome = {
						type = "toggle",
						name = L.monochrome,
						desc = L.monochromeDesc,
						order = 14,
						disabled = checkTextDisabled,
					},
					resetHeader = {
						type = "header",
						name = "",
						order = 15,
					},
					reset = {
						type = "execute",
						name = L.reset,
						desc = L.resetCountdownDesc,
						func = function()
							local restoreCountdowns = plugin.db.profile.bossCountdowns
							plugin.db:ResetProfile()
							plugin.db.profile.bossCountdowns = restoreCountdowns
							updateProfile()
						end,
						order = 16,
					},
					resetAll = {
						type = "execute",
						name = L.resetAll,
						desc = L.resetAllCountdownDesc,
						func = function() plugin.db:ResetProfile() updateProfile() end,
						order = 17,
					},
				},
			},
			exactPositioning = {
				type = "group",
				name = L.positionExact,
				order = 2,
				disabled = checkTextDisabled,
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
							countdownAnchor:RefixPosition()
						end,
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
							countdownAnchor:RefixPosition()
						end,
					},
				},
			},
		},
	}
end

local function createOptions()
	local sModule = BigWigs:GetPlugin("Sounds", true)
	if sModule then
		-- ability options
		sModule.soundOptions.args.separator1 = {
			name = "",
			type = "description",
			order = 3,
		}
		sModule.soundOptions.args.countdown = {
			name = "Countdown",
			type = "select",
			values = BigWigsAPI.GetCountdownList,
			sorting = voiceSorting,
			get = function(info)
				local name, key = unpack(info.arg)
				return plugin.db.profile.bossCountdowns[name] and plugin.db.profile.bossCountdowns[name][key] or plugin.db.profile.voice
			end,
			set = function(info, value)
				local name, key = unpack(info.arg)
				if value ~= plugin.db.profile.voice then
					if not plugin.db.profile.bossCountdowns[name] then plugin.db.profile.bossCountdowns[name] = {} end
					plugin.db.profile.bossCountdowns[name][key] = value
				else -- clean up
					if plugin.db.profile.bossCountdowns[name] then
						plugin.db.profile.bossCountdowns[name][key] = nil
					end
					if not next(plugin.db.profile.bossCountdowns[name]) then
						plugin.db.profile.bossCountdowns[name] = nil
					end
				end
			end,
			order = 4,
			width = "full",
		}
	end
end

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	updateProfile()
	createOptions()

	self:RegisterMessage("BigWigs_StartCountdown")
	self:RegisterMessage("BigWigs_StopCountdown")
	self:RegisterMessage("BigWigs_OnBossDisable")
	self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_OnBossDisable")
	self:RegisterMessage("BigWigs_ClearNameplate")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	self:RegisterMessage("BigWigs_StartConfigureMode", showAnchors)
	self:RegisterMessage("BigWigs_StopConfigureMode", hideAnchors)
end

-------------------------------------------------------------------------------
-- Event Handlers
--

local latestCountdown = nil
do
	countdownFrame = CreateFrame("Frame", nil, UIParent)
	countdownFrame:SetFrameStrata("FULLSCREEN_DIALOG")
	countdownFrame:SetFixedFrameStrata(true)
	countdownFrame:SetFrameLevel(20) -- Behind GUI (level 100)
	countdownFrame:SetFixedFrameLevel(true)
	countdownFrame:SetPoint("CENTER", countdownAnchor, "CENTER")
	countdownFrame:SetWidth(80)
	countdownFrame:SetHeight(80)
	countdownFrame:Hide()

	countdownText = countdownFrame:CreateFontString()
	countdownText:SetPoint("CENTER", countdownFrame, "CENTER")

	local updater = countdownFrame:CreateAnimationGroup()
	updater:SetScript("OnFinished", function()
		if inConfigMode then
			countdownText:SetText("5")
		else
			countdownFrame:Hide()
		end
	end)
	local anim = updater:CreateAnimation("Alpha")
	anim:SetFromAlpha(1)
	anim:SetToAlpha(0)
	anim:SetDuration(1)
	anim:SetStartDelay(1.1)

	function plugin:SetText(text, timer)
		latestCountdown = timer
		countdownText:SetText(text)
		updater:Stop()
		countdownFrame:Show()
		updater:Play()
	end
end

do
	local timers = {}
	local GUIDtimers = {}
	do
		local GetTime = GetTime
		local function LowestCountdown(tableToMatch, module, text)
			local lowestText, lowestCountdownTable
			if timers[module] and timers[module][text] and not timers[module][text][2] then
				lowestText = timers[module][text][1]
				lowestCountdownTable = timers[module][text]
			end

			if GUIDtimers[module] and GUIDtimers[module][text] then
				local currentTime = GetTime()
				for _, countdownTable in next, GUIDtimers[module][text] do
					local timeInTable = countdownTable[1]
					if not countdownTable[2] and (not lowestText or timeInTable < lowestText) and timeInTable > currentTime then
						lowestText = timeInTable
						lowestCountdownTable = countdownTable
					end
				end
			end
			return lowestCountdownTable == tableToMatch
		end

		function plugin:BigWigs_StartCountdown(_, module, key, text, time, guid, customVoice, customStart, audioOnly, customAudioStart)
			if module and time >= 1 then
				local countdownTable = {GetTime()+time}
				if guid then
					if GUIDtimers[module] then
						if GUIDtimers[module][text] then
							if GUIDtimers[module][text][guid] then
								GUIDtimers[module][text][guid][2] = true
							end
						else
							GUIDtimers[module][text] = {}
						end
					else
						GUIDtimers[module] = {}
						GUIDtimers[module][text] = {}
					end
					GUIDtimers[module][text][guid] = countdownTable
				else
					if timers[module] then
						if timers[module][text] then
							timers[module][text][2] = true
						end
					else
						timers[module] = {}
					end
					timers[module][text] = countdownTable
				end

				local textCount = customStart or self.db.profile.countdownTime
				if time < textCount then
					textCount = math.floor(time)
				end

				local function announce()
					if not countdownTable[2] then
						if LowestCountdown(countdownTable, module, text) then
							if not audioOnly and plugin.db.profile.textEnabled then
								plugin:SetText(textCount, countdownTable)
							end
							local voice = customVoice or plugin.db.profile.bossCountdowns[module.name] and plugin.db.profile.bossCountdowns[module.name][key] or plugin.db.profile.voice
							local sound = textCount <= (customAudioStart or textCount) and BigWigsAPI:GetCountdownSound(voice, textCount)
							if sound then
								self:PlaySoundFile(sound)
							end
						end
						textCount = textCount - 1
					end
				end
				for i = 1, textCount do
					self:SimpleTimer(announce, time-i)
				end
			end
		end
	end
	function plugin:BigWigs_StopCountdown(_, module, text, guid)
		local countdownTable
		if guid then
			countdownTable = GUIDtimers[module] and GUIDtimers[module][text] and GUIDtimers[module][text][guid]
		else
			countdownTable = timers[module] and timers[module][text]
		end
		if countdownTable then
			countdownTable[2] = true
			if latestCountdown == countdownTable then
				self:SetText("") -- Only clear the text if the cancelled countdown was the last to display something
			end
		end
	end
	function plugin:BigWigs_OnBossDisable(_, module)
		if timers[module] then
			for _, countdownTable in next, timers[module] do
				countdownTable[2] = true
				if latestCountdown == countdownTable then
					self:SetText("") -- Only clear the text if the cancelled countdown was the last to display something
				end
			end
			timers[module] = nil
		end
		if GUIDtimers[module] then
			for _, guidTable in next, GUIDtimers[module] do
				for _, countdownTable in next, guidTable do
					countdownTable[2] = true
					if latestCountdown == countdownTable then
						self:SetText("") -- Only clear the text if the cancelled countdown was the last to display something
					end
				end
			end
			GUIDtimers[module] = nil
		end
	end
	function plugin:BigWigs_ClearNameplate(_, module, guid)
		if GUIDtimers[module] then
			for _, guidTable in next, GUIDtimers[module] do
				local countdownTable = guidTable[guid]
				if countdownTable then
					countdownTable[2] = true
					if latestCountdown == countdownTable then
						self:SetText("") -- Only clear the text if the cancelled countdown was the last to display something
					end
				end
			end
		end
	end
end

function plugin:TestCountdown()
	self:SendMessage("BigWigs_StartCountdown", self, nil, "test countdown", self.db.profile.countdownTime + 0.5)
end
