assert(BigWigs, "BigWigs not found!")

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:New("Custom Bars", "$Revision$")
if not mod then return end
mod.external = true

----------------------------
--   Are you local?       --
----------------------------

local times = nil
local fmt = string.format
local _G = _G

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsCustomBar")

L:RegisterTranslations("enUS", function() return {
	["CustomBars"] = true,
	["Custom Bars"] = true,
	["Start a custom bar, either local or global."] = true,
	["Local"] = true,
	["Global"] = true,
	["<time> <bar text>"] = true,
	["Starts a custom bar with the given parameters."] = true,
	["%s: Timer [%s] finished."] = true,
	["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Custom Bars"] = "사용자 바",
	["Start a custom bar, either local or global."] = "글로벌 혹은 로컬 사용자 바를 시작합니다.",
	["Local"] = "로컬",
	["Global"] = "글로벌",
	["<time> <bar text>"] = "<초> <바 텍스트>",
	["Starts a custom bar with the given parameters."] = "입력한 매개변수로 사용자 바를 시작합니다.",
	["%s: Timer [%s] finished."] = "%s: [%s] 타이머가 종료되었습니다.",
} end)

L:RegisterTranslations("zhCN", function() return {
	["CustomBars"] = "自定义计时条",
	["Custom Bars"] = "自定义计时条",
	["Start a custom bar, either local or global."] = "启动自定义时间条，本地或全局。",
	["Local"] = "本地",
	["Global"] = "全局",
	["<time> <bar text>"] = "<时间> <计时条名字>",
	["Starts a custom bar with the given parameters."] = "启动自定义时间条。",
	["%s: Timer [%s] finished."] = "%s：计时条[%s]到时间。",
	["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "无效记时条（|cffff0000%q|r）或 |cffd9d919%s|r 上的记时条文字错误，<time> 输入一个数字单位默认为秒，可以为 M:S 或者 Mm. 例如 5, 1:20 or 2m.",
} end)

L:RegisterTranslations("zhTW", function() return {
	["CustomBars"] = "自定時間條",
	["Custom Bars"] = "自定時間條",
	["Start a custom bar, either local or global."] = "開始一個自定時間條，區域或者全域",
	["Local"] = "區域",
	["Global"] = "全域",
	["<time> <bar text>"] = "<秒> <列文字>",
	["Starts a custom bar with the given parameters."] = "開始一個包含參數的自定時間條",
	["%s: Timer [%s] finished."] = "%s: 計時器 [%s] 終了。",
} end)

L:RegisterTranslations("deDE", function() return {
	["CustomBars"] = "Balken",
	["Custom Bars"] = "Individuelle Anzeigebalken",
	["Start a custom bar, either local or global."] = "Einen individuellen Anzeigebalken starten (entweder lokal oder global).",
	["Local"] = "Lokal",
	["Global"] = "Global",
	["<time> <bar text>"] = "<Sekunden> <Balkentext>",
	["Starts a custom bar with the given parameters."] = "Einen individuellen Anzeigebalken mit den gegebenen Parametern starten.",
	["%s: Timer [%s] finished."] = "%s: Timer [%s] beendet.",
} end)

L:RegisterTranslations("frFR", function() return {
	["Custom Bars"] = "Barres personnalisées",
	["Start a custom bar, either local or global."] = "Démarre une barre personnalisée, soit locale, soit globale.",
	["Local"] = "Local",
	["Global"] = "Global",
	["<time> <bar text>"] = "<durée> <texte de la barre>",
	["Starts a custom bar with the given parameters."] = "Démarre une barre personnalisée avec les paramètres indiqués.",
	["%s: Timer [%s] finished."] = "%s : Délai [%s] terminé.",
	["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Durée invalide (|cffff0000%q|r) ou texte de barre manquant dans une barre personnalisée lancée par |cffd9d919%s|r. <durée> peut être soit un nombre en secondes, soit au format M:S, ou encore au format Mm. Par exemple : 5, 1:20 ou 2m.",
} end)

L:RegisterTranslations("esES", function() return {
	["CustomBars"] = "BarrasPersonales",
	["Custom Bars"] = "Barras Personales",
	["Start a custom bar, either local or global."] = "Iniciar una barra personal, ya sea local o global",
	["Local"] = "Local",
	["Global"] = "Global",
	["<time> <bar text>"] = "<tiempo> <Texto de barra>",
	["Starts a custom bar with the given parameters."] = "Iniciar una barra personal con los parametros dados",
	["%s: Timer [%s] finished."] = "%s: Temporizador [%s] finalizado",
	["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Tiempo inv\195\161lido (|cffff0000%q|r) o texto de barra ausente en una barra personal iniciada por |cffd9d919%s|r. <tiempo> puede ser un n\195\186mero en segundos, una pareja M:S, o Mm. Por ejemplo 5, 1:20 or 2m.",
} end)

-- Translated by wow.playhard.ru translators
L:RegisterTranslations("ruRU", function() return {
	["CustomBars"] = "Польз-киеПолосы",
	["Custom Bars"] = "Пользовательские полосы",
	["Start a custom bar, either local or global."] = "Запуск пользовательской полоски, Локальной или Глобальной.",
	["Local"] = "Локальный",
	["Global"] = "Глобальный",
	["<time> <bar text>"] = "<время> <текст полосы>",
	["Starts a custom bar with the given parameters."] = "Запуск пользовательской полоски с заданными параметрами.",
	["%s: Timer [%s] finished."] = "%s: Таймер [%s] готовый.",
	["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Неверное время (|cffff0000%q|r) или отсутствие текста в пользовательской полосе запущенной |cffd9d919%s|r. <время> может вводится цифрами в секундах, М:С парный, или Мм. К примеру 5, 1:20 или 2м.",
} end)

--------------------------------------------------------------------------------
-- Options
--

mod.consoleCmd = L["CustomBars"]
mod.defaultDB = {
	otherAddons = false,
}
mod.consoleOptions = {
	type = "group",
	name = L["Custom Bars"],
	desc = L["Start a custom bar, either local or global."],
	args = {
		[L["Global"]] = {
			type = "text",
			name = L["Global"],
			desc = L["Starts a custom bar with the given parameters."],
			get = false,
			set = function(v) mod:TriggerEvent("BigWigs_SendSync", "BWCustomBar "..v) end,
			usage = L["<time> <bar text>"],
			disabled = function() return (not IsRaidLeader() and not IsRaidOfficer()) and UnitInRaid("player") end,
			order = 1,
		},
		[L["Local"]] = {
			type = "text",
			name = L["Local"],
			desc = L["Starts a custom bar with the given parameters."],
			get = false,
			set = function(v) mod:StartBar(v, nil, true) end,
			usage = L["<time> <bar text>"],
			order = 2,
		},
	},
}

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self.enabled = true
	times = {}

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCustomBar", 0)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync ~= "BWCustomBar" or not rest or not nick or not self.enabled then return end

	if UnitInRaid("player") then
		local num = GetNumRaidMembers()
		for i = 1, num do
			local name, rank = GetRaidRosterInfo(i)
			if name == nick then
				if rank == 0 then
					return
				else
					break
				end
			end
		end
	end

	self:StartBar(rest, nick, false)
end

------------------------------
--      Utility             --
------------------------------

local function parseTime(input)
	if type(input) == "nil" then return end
	if tonumber(input) then return tonumber(input) end
	if type(input) == "string" then
		input = input:trim()
		if input:find(":") then
			local m, s = select(3, input:find("^(%d+):(%d+)$"))
			if not tonumber(m) or not tonumber(s) then return end
			return (tonumber(m) * 60) + tonumber(s)
		elseif input:find("^%d+m$") then
			return tonumber(select(3, input:find("^(%d+)m$"))) * 60
		end
	end
end

function mod:StartBar(bar, nick, localOnly)
	local time, barText = select(3, bar:find("(%S+) (.*)"))
	local seconds = parseTime(time)
	if type(seconds) ~= "number" or type(barText) ~= "string" then
		BigWigs:Print(L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."]:format(tostring(time), nick or UnitName("player")))
		return
	end

	if not nick then nick = L["Local"] end
	if seconds == 0 then
		self:CancelScheduledEvent("bwcb"..nick..barText)
		self:TriggerEvent("BigWigs_StopBar", self, nick..": "..barText)
	else
		self:ScheduleEvent("bwcb"..nick..barText, "BigWigs_Message", seconds, fmt(L["%s: Timer [%s] finished."], nick, barText), "Attention", localOnly)
		self:TriggerEvent("BigWigs_StartBar", self, nick..": "..barText, seconds, "Interface\\Icons\\INV_Misc_PocketWatch_01")
	end
end

-- For easy use in macros.
local function BWCB(input)
	local t = GetTime()
	if not times[input] or (times[input] and (times[input] + 2) < t) then
		times[input] = t
		mod:TriggerEvent("BigWigs_SendSync", "BWCustomBar "..input)
	end
end

local function BWLCB(input)
	mod:StartBar(input, nil, true)
end

-- Shorthand slashcommand
_G["SlashCmdList"]["BWCB_SHORTHAND"] = BWCB
_G["SLASH_BWCB_SHORTHAND1"] = "/bwcb"
_G["SlashCmdList"]["BWLCB_SHORTHAND"] = BWLCB
_G["SLASH_BWLCB_SHORTHAND1"] = "/bwlcb"

