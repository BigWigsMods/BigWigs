assert(BigWigs, "BigWigs not found!")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsCustomBar")

local times = nil

L:RegisterTranslations("enUS", function() return {
	["bwcb"] = true,
	["bwlcb"] = true,
	["custombar"] = true,
	["Custom Bars"] = true,
	["Start a custom bar, either local or global."] = true,
	["Local"] = true,
	["Global"] = true,
	["<seconds> <bar text>"] = true,
	["Starts a custom bar with the given parameters."] = true,
	["%s: %s"] = true,
	["%s: Timer [%s] finished."] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Custom Bars"] = "사용자 바",
	["Start a custom bar, either local or global."] = "사용자 바 시작, 전체 혹은 지역",
	["Local"] = "지역",
	["Global"] = "전체",
	["<seconds> <bar text>"] = "<초> <바 텍스트>",
	["Starts a custom bar with the given parameters."] = "입력한 매개변수로 사용자 바 시작",
	["%s: %s"] = "%s: %s",
	["%s: Timer [%s] finished."] = "%s: 타이머 [%s] 종료되었습니다.",
} end)

L:RegisterTranslations("zhCN", function() return {
	["bwcb"] = "bwcb",
	["bwlcb"] = "bwlcb",
	["custombar"] = "自制时间条",
	["Custom Bars"] = "自制时间条",
	["Start a custom bar, either local or global."] = "激活一条自制时间条，本地或者全局",
	["Local"] = "本地",
	["Global"] = "全局",
	["<seconds> <bar text>"] = "<seconds> <bar text>",
	["Starts a custom bar with the given parameters."] = "激活一条带参数的自制时间条",
	["%s: %s"] = "%s: %s",
	["%s: Timer [%s] finished."] = "%s: 计时器 [%s] 到时间",
} end)

L:RegisterTranslations("zhTW", function() return {
	["bwcb"] = "bwcb",
	["bwlcb"] = "bwlcb",
	["custombar"] = "自定時間條",
	["Custom Bars"] = "自定時間條",
	["Start a custom bar, either local or global."] = "開始一個自定時間條，區域或者全域",
	["Local"] = "區域",
	["Global"] = "全域",
	["<seconds> <bar text>"] = "<秒> <列文字>",
	["Starts a custom bar with the given parameters."] = "開始一個包含參數的自定時間條",
	["%s: %s"] = "%s: %s",
	["%s: Timer [%s] finished."] = "%s: 計時器 [%s] 終了。",
} end)

L:RegisterTranslations("deDE", function() return {
	-- ["bwcb"] = true,
	-- ["bwlcb"] = true,
	-- ["custombar"] = true,
	["Custom Bars"] = "Individuelle Anzeigebalken",
	["Start a custom bar, either local or global."] = "Einen individuellen Anzeigebalken starten (entweder lokal oder global).",
	["Local"] = "Lokal",
	["Global"] = "Global",
	["<seconds> <bar text>"] = "<Sekunden> <Balkentext>",
	["Starts a custom bar with the given parameters."] = "Einen individuellen Anzeigebalken mit den gegebenen Parametern starten. \n<Sekunden> <Balkentext>",
	-- ["%s: %s"] = true,
	["%s: Timer [%s] finished."] = "%s: Timer [%s] beendet.",
} end)

L:RegisterTranslations("frFR", function() return {
	["Custom Bars"] = "Barres personnalis\195\169es",
	["Start a custom bar, either local or global."] = "D\195\169marre une barre personnalis\195\169e, soit personnelle, soit globale.",
	["Local"] = "Personnelle",
	["Global"] = "Globale",
	["<seconds> <bar text>"] = "<secondes> <texte de la barre>",
	["Starts a custom bar with the given parameters."] = "D\195\169marre une barre personnalis\195\169e avec les param\195\168tres indiqu\195\169s",
	["%s: Timer [%s] finished."] = "%s: Compteur [%s] termin\195\169.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsCustomBar = BigWigs:NewModule(L["Custom Bars"])
BigWigsCustomBar.revision = tonumber(string.sub("$Revision$", 12, -3))
BigWigsCustomBar.external = true
BigWigsCustomBar.consoleCmd = L["custombar"]
BigWigsCustomBar.consoleOptions = {
	type = "group",
	name = L["Custom Bars"],
	desc = L["Start a custom bar, either local or global."],
	args = {
		[L["Global"]] = {
			type = "text",
			name = L["Global"],
			desc = L["Starts a custom bar with the given parameters."],
			get = false,
			set = function(v) BigWigsCustomBar:TriggerEvent("BigWigs_SendSync", "BWCustomBar "..v) end,
			usage = L["<seconds> <bar text>"],
			disabled = function() return (not IsRaidLeader() and not IsRaidOfficer()) and UnitInRaid("player") end,
		},
		[L["Local"]] = {
			type = "text",
			name = L["Local"],
			desc = L["Starts a custom bar with the given parameters."],
			get = false,
			set = function(v) BigWigsCustomBar:StartBar(v, nil, true) end,
			usage = L["<seconds> <bar text>"],
		},
	},
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsCustomBar:OnEnable()
	self.enabled = true
	times = {}

	self:RegisterShortHand()

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCustomBar", 0)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsCustomBar:BigWigs_RecvSync(sync, rest, nick)
	if sync ~= "BWCustomBar" or not rest or not nick or not self.enabled then return end

	if UnitInRaid("player") then
		for i = 1, GetNumRaidMembers() do
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

function BigWigsCustomBar:StartBar(bar, nick, localOnly)
	local _, _, seconds, barText = string.find(bar, "(%d+) (.*)")
	if not seconds or not barText then return end
	seconds = tonumber(seconds)
	if seconds == nil then return end

	if not nick then nick = L["Local"] end
	self:ScheduleEvent("bwcb"..nick..barText, "BigWigs_Message", seconds, string.format(L["%s: Timer [%s] finished."], nick, barText), "Attention", localOnly)
	self:TriggerEvent("BigWigs_StartBar", self, string.format(L["%s: %s"], nick, barText), seconds, "Interface\\Icons\\INV_Misc_PocketWatch_01")
end

-- For easy use in macros.
function BWCB(seconds, message)
	if message then seconds = tostring(seconds) .. " " .. message end
	local t = GetTime()
	if ( not times[seconds] ) or ( times[seconds] and ( times[seconds] + 2 ) < t) then
		times[seconds] = t
		BigWigsCustomBar:TriggerEvent("BigWigs_SendSync", "BWCustomBar "..seconds)
	end
end

function BWLCB(seconds, message)
	if message then seconds = tostring(seconds) .. " " .. message end
	BigWigsCustomBar:StartBar(seconds, nil, true)
end

-- Shorthand slashcommand
function BigWigsCustomBar:RegisterShortHand()
	if SlashCmdList then
		SlashCmdList["BWCB_SHORTHAND"] = BWCB
		setglobal("SLASH_BWCB_SHORTHAND1", "/"..L["bwcb"])
		SlashCmdList["BWLCB_SHORTHAND"] = BWLCB
		setglobal("SLASH_BWLCB_SHORTHAND1", "/"..L["bwlcb"])
	end
end
