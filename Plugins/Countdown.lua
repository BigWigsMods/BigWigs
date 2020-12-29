-------------------------------------------------------------------------------
-- Module Declaration
--

local oldPlugin = BigWigs:NewPlugin("Super Emphasize") -- XXX temp 9.0.2
oldPlugin.defaultDB = {
	Countdown = {},
}

local plugin = BigWigs:NewPlugin("Countdown")
if not plugin then return end

local voiceMap = {
	deDE = "Deutsch: Heroes of the Storm",
	esES = "Español: Heroes of the Storm",
	esMX = "Español: Heroes of the Storm",
	frFR = "Français: Heroes of the Storm",
	ruRU = "Русский: Heroes of the Storm",
	koKR = "한국어: Heroes of the Storm",
	itIT = "Italiano: Heroes of the Storm",
	ptBR = "Português: Heroes of the Storm",
	zhCN = "简体中文: Heroes of the Storm",
	zhTW = "繁體中文: Heroes of the Storm",
}

plugin.defaultDB = {
	textEnabled = true,
	fontName = plugin:GetDefaultFont(),
	outline = "THICKOUTLINE",
	fontSize = 48,
	monochrome = false,
	fontColor = { r = 1, g = 0, b = 0 },
	voice = voiceMap[GetLocale()] or "English: Amy",
	countdownTime = 5,
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
local PlaySoundFile = PlaySoundFile

local temporaryCountdowns = {}

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
BigWigsAPI:RegisterCountdown("English: Heroes of the Storm", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\enUS\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\enUS\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\enUS\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\enUS\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\enUS\\5.ogg",
})
BigWigsAPI:RegisterCountdown("Deutsch: Heroes of the Storm", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\deDE\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\deDE\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\deDE\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\deDE\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\deDE\\5.ogg",
})
BigWigsAPI:RegisterCountdown("Español: Heroes of the Storm", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\esES\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\esES\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\esES\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\esES\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\esES\\5.ogg",
})
BigWigsAPI:RegisterCountdown("Français: Heroes of the Storm", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\frFR\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\frFR\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\frFR\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\frFR\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\frFR\\5.ogg",
})
BigWigsAPI:RegisterCountdown("Русский: Heroes of the Storm", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\ruRU\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\ruRU\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\ruRU\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\ruRU\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\ruRU\\5.ogg",
})
BigWigsAPI:RegisterCountdown("한국어: Heroes of the Storm", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\koKR\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\koKR\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\koKR\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\koKR\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\koKR\\5.ogg",
})
BigWigsAPI:RegisterCountdown("Italiano: Heroes of the Storm", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\itIT\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\itIT\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\itIT\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\itIT\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\itIT\\5.ogg",
})
BigWigsAPI:RegisterCountdown("Português: Heroes of the Storm", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\ptBR\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\ptBR\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\ptBR\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\ptBR\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\ptBR\\5.ogg",
})
BigWigsAPI:RegisterCountdown("简体中文: Heroes of the Storm", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\zhCN\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\zhCN\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\zhCN\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\zhCN\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\zhCN\\5.ogg",
})
BigWigsAPI:RegisterCountdown("繁體中文: Heroes of the Storm", {
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\zhTW\\1.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\zhTW\\2.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\zhTW\\3.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\zhTW\\4.ogg",
	"Interface\\AddOns\\BigWigs\\Media\\Sounds\\Heroes\\zhTW\\5.ogg",
})

-------------------------------------------------------------------------------
-- Options
--

local function voiceList() -- select values
	return BigWigsAPI:GetCountdownList()
end

do
	local disabled = function() return plugin.db.profile.disabled end
	plugin.pluginOptions = {
		name = L.countdown,
		type = "group",
		get = function(info) return plugin.db.profile[info[#info]] end,
		set = function(info, value)
			plugin.db.profile[info[#info]] = value
		end,
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
				values = voiceList,
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
				end,
				width = 2,
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
			},
			fontColor = {
				type = "color",
				name = L.countdownColor,
				get = function(info)
					return plugin.db.profile[info[#info]].r, plugin.db.profile[info[#info]].g, plugin.db.profile[info[#info]].b
				end,
				set = function(info, r, g, b)
					plugin.db.profile[info[#info]].r, plugin.db.profile[info[#info]].g, plugin.db.profile[info[#info]].b = r, g, b
				end,
				order = 12,
			},
			fontSize = {
				type = "range",
				name = L.fontSize,
				order = 13,
				softMax = 100, max = 200, min = 1, step = 1,
			},
			monochrome = {
				type = "toggle",
				name = L.monochrome,
				desc = L.monochromeDesc,
				order = 14,
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
			values = voiceList,
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

local function updateProfile()
	-- Reset invalid voice selections
	if not BigWigsAPI:HasCountdown(plugin.db.profile.voice) then
		plugin.db.profile.voice = voiceMap[GetLocale()] or "English: Amy"
	end
	for boss, tbl in next, plugin.db.profile.bossCountdowns do
		for ability, chosenVoice in next, tbl do
			if not BigWigsAPI:HasCountdown(chosenVoice) then
				plugin.db.profile.bossCountdowns[boss][ability] = nil
			end
		end
	end
	-- XXX temp 9.0.2
	if next(oldPlugin.db.profile.Countdown) then
		plugin.db.profile.bossCountdowns = oldPlugin.db.profile.Countdown
	end
	oldPlugin.db:ResetProfile(nil, true) -- no callbacks
end

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_StartCountdown")
	self:RegisterMessage("BigWigs_StopCountdown")
	self:RegisterMessage("BigWigs_TemporaryCountdown")
	self:RegisterMessage("BigWigs_PlayCountdownNumber")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	updateProfile()
	createOptions()
end

-------------------------------------------------------------------------------
-- Event Handlers
--

do
	local timers = {}
	local function printEmph(num, name, key, text)
		local voice = plugin.db.profile.bossCountdowns[name] and plugin.db.profile.bossCountdowns[name][key] or plugin.db.profile.voice
		local sound = BigWigsAPI:GetCountdownSound(voice, num)
		if sound then
			PlaySoundFile(sound, "Master")
		end
		if plugin.db.profile.textEnabled then
			plugin:SendMessage("BigWigs_EmphasizedCountdownMessage", num)
		end
		if text and timers[text] then timers[text] = {} end
	end
	function plugin:BigWigs_StartCountdown(_, module, key, text, time)
		if (key and temporaryCountdowns[key]) or (module and module:CheckOption(key, "COUNTDOWN")) then
			self:BigWigs_StopCountdown(nil, module, text)
			if time > 1.3 then
				if not timers[text] then timers[text] = {} end
				timers[text][1] = module:ScheduleTimer(printEmph, time-1.3, 1, module.name, key, text)
				for i = 2, self.db.profile.countdownTime do
					local t = i + 0.3
					if time <= t then break end
					timers[text][i] = module:ScheduleTimer(printEmph, time-t, i, module.name, key)
				end
			end
		end
	end
	function plugin:BigWigs_StopCountdown(_, module, text)
		if text and timers[text] and #timers[text] > 0 then
			for i = 1, #timers[text] do
				module:CancelTimer(timers[text][i])
			end
			timers[text] = {}
		end
	end
	function plugin:TestCountdown()
		local text = "test"
		self:BigWigs_StopCountdown(nil, self, text)
		if not timers[text] then timers[text] = {} end
		local num = self.db.profile.countdownTime
		for i = 1, num do
			timers[text][i] = self:ScheduleTimer(printEmph, num-i, i, nil, nil, i == 1 and text)
		end
	end
end

function plugin:BigWigs_TemporaryCountdown(_, module, key, text, time)
	if not module or not key or text == "" then return end
	temporaryCountdowns[key] = GetTime() + time
	self:BigWigs_StartCountdown(nil, module, key, text, time)
end

function plugin:BigWigs_PlayCountdownNumber(_, _, num, voice)
	local sound = BigWigsAPI:GetCountdownSound(voice or self.db.profile.voice, num)
	if sound then
		PlaySoundFile(sound, "Master")
	end
end
