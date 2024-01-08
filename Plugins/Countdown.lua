-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Countdown")
if not plugin then return end

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
local defaultVoice = "English: Amy"
do
	local locale = GetLocale()
	if locale ~= "enUS" and voiceMap[locale] then
		defaultVoice = ("%s: Default (Female)"):format(locale)
	end
end

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

-------------------------------------------------------------------------------
-- Locals
--

local media = LibStub("LibSharedMedia-3.0")
local FONT = media.MediaType and media.MediaType.FONT or "font"
local BigWigsAPI = BigWigsAPI
local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
plugin.displayName = L.countdown

local countdownAnchor = nil
local countdownFrame = nil
local countdownText = nil
local inConfigMode = false

-------------------------------------------------------------------------------
-- Countdown Registration
--

BigWigsAPI:RegisterCountdown(L.none, { false, false, false, false, false })
BigWigsAPI:RegisterCountdown("English: Amy", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\5.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\6.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\7.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\8.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\9.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy\\10.ogg",
})
BigWigsAPI:RegisterCountdown("English: David", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\5.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\6.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\7.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\8.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\9.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\David\\10.ogg",
})
BigWigsAPI:RegisterCountdown("English: Jim", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\5.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\6.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\7.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\8.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\9.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Jim\\10.ogg",
})

for locale, info in next, voiceMap do
	local name, male, female = unpack(info)

	BigWigsAPI:RegisterCountdown(("%s: Default (Male)"):format(locale), name:format(male), {
		"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\"..locale.."\\male\\1.ogg",
		"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\"..locale.."\\male\\2.ogg",
		"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\"..locale.."\\male\\3.ogg",
		"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\"..locale.."\\male\\4.ogg",
		"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\"..locale.."\\male\\5.ogg",
	})

	local id = ("%s: Default (Female)"):format(locale)
	if locale == "esMX" then
		-- never extracted the esMX female announcer and it's gone now, so just use esES
		locale = "esES"
	end
	BigWigsAPI:RegisterCountdown(id, name:format(female), {
		"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\"..locale.."\\female\\1.ogg",
		"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\"..locale.."\\female\\2.ogg",
		"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\"..locale.."\\female\\3.ogg",
		"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\"..locale.."\\female\\4.ogg",
		"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\"..locale.."\\female\\5.ogg",
	})
end

--------------------------------------------------------------------------------
-- Anchors & Frames
--

local function showAnchors()
	inConfigMode = true
	countdownAnchor:Show()
	countdownFrame:Show()
	countdownText:SetText("5")
end

local function hideAnchors()
	inConfigMode = false
	countdownAnchor:Hide()
	countdownFrame:Hide()
end

do
	local function OnDragStart(self)
		self:StartMoving()
	end
	local function OnDragStop(self)
		self:StopMovingOrSizing()
		local point, _, relPoint, x, y = self:GetPoint()
		plugin.db.profile.position = {point, relPoint, x, y}
		plugin:UpdateGUI() -- Update X/Y if GUI is open.
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
		if k ~= L.none then
			sorted[#sorted + 1] = k
		end
	end
	sort(sorted, function(a, b) return list[a] < list[b] end)
	tinsert(sorted, 1, L.none)
	return sorted
end

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
						end,
						order = 16,
					},
					resetAll = {
						type = "execute",
						name = L.resetAll,
						desc = L.resetAllCountdownDesc,
						func = function() plugin.db:ResetProfile() end,
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

do
	local LOCALE = GetLocale()
	local KEY = "%s: Default (Female)"
	local function check(voice)
		local lang = voice and voice:match("^(.+): Heroes of the Storm$")
		if not lang then return end

		if lang == "Español" then
			-- Try to pick the correct Spanish locale
			if LOCALE == "esMX" or LOCALE == "esES" then
				return KEY:format(LOCALE)
			end
			return KEY:format(GetCurrentRegion() == 1 and "esMX" or "esES") -- NA or EU
		end

		for locale, info in next, voiceMap do
			if info[1]:sub(1, #lang) == lang then
				return KEY:format(locale)
			end
		end
	end

	local function upgradeDB(sv)
		if not sv or not sv.profiles then return end
		for profile, db in next, sv.profiles do
			local voice = check(db.voice)
			if voice then
				db.voice = voice
			end
			if db.bossCountdowns then
				for moduleName, abilities in next, db.bossCountdowns do
					for k, v in next, abilities do
						local voice = check(v)
						if voice then
							abilities[k] = voice
						end
					end
				end
			end
		end
	end

	function plugin:OnRegister()
		-- XXX temp 9.0.5
		upgradeDB(self.db)
		upgradeDB(BigWigs3DB.namespaces["BigWigs_Plugins_Pull"])
	end
end

do
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

	function plugin:OnPluginEnable()
		self:RegisterMessage("BigWigs_StartCountdown")
		self:RegisterMessage("BigWigs_StopCountdown")
		self:RegisterMessage("BigWigs_OnBossDisable")
		self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_OnBossDisable")
		self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
		self:RegisterMessage("BigWigs_StartConfigureMode", showAnchors)
		self:RegisterMessage("BigWigs_StopConfigureMode", hideAnchors)
		updateProfile()
		createOptions()
	end
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
	function plugin:BigWigs_StartCountdown(_, module, key, text, time, customVoice, customStart, audioOnly)
		if module and time > 1.3 then
			self:BigWigs_StopCountdown(nil, module, text)
			if not timers[module] then
				timers[module] = {}
			end
			local count = customStart or self.db.profile.countdownTime
			while count >= time do
				count = count - 1
			end
			local cancelTimer = {false}
			timers[module][text] = cancelTimer

			local voice = customVoice or plugin.db.profile.bossCountdowns[module.name] and plugin.db.profile.bossCountdowns[module.name][key] or plugin.db.profile.voice
			local function printTime()
				if not cancelTimer[1] then
					if not audioOnly and plugin.db.profile.textEnabled then
						plugin:SetText(count, cancelTimer)
					end
					local sound = BigWigsAPI:GetCountdownSound(voice, count)
					if sound then
						self:PlaySoundFile(sound)
					end
					count = count - 1
				end
			end
			local startOffset = count + 0.3
			for i = 1.3, startOffset do
				self:SimpleTimer(printTime, time-i)
			end
		end
	end
	function plugin:BigWigs_StopCountdown(_, module, text)
		local moduleTimers = timers[module]
		if moduleTimers and moduleTimers[text] then
			moduleTimers[text][1] = true
			if latestCountdown == moduleTimers[text] then
				self:SetText("") -- Only clear the text if the cancelled countdown was the last to display something
			end
		end
	end
	function plugin:BigWigs_OnBossDisable(_, module)
		if timers[module] then
			for _, timer in next, timers[module] do
				timer[1] = true
				if latestCountdown == timer then
					self:SetText("") -- Only clear the text if the cancelled countdown was the last to display something
				end
			end
			timers[module] = nil
		end
	end
end

function plugin:TestCountdown()
	self:SendMessage("BigWigs_StartCountdown", self, nil, "test countdown", self.db.profile.countdownTime + 0.5)
end
