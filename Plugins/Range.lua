assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsRange")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Range"] = true,
	["Options for the combat log's range."] = true,

	["Creatures"] = true,
	["Creature combat log range."] = true,

	["Deaths"] = true,
	["Death message range."] = true,

	["Reset to defaults"] = true,
	["Resets all ranges to defaults."] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Range"] = "범위",
	["Options for the combat log's range."] = "전투 로그의 범위에 대한 설정입니다.",

	["Creatures"] = "NPC",
	["Creature combat log range."] = "NPC 전투 로그의 범위를 설정합니다.",

	["Deaths"] = "죽음",
	["Death message range."] = "죽음 메세지의 범위를 설정합니다.",

	["Reset to defaults"] = "기본 설정 초기화",
	["Resets all ranges to defaults."] = "모든 범위를 기본 설정으로 초기화합니다.",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Range"] = "范围",
	["Options for the combat log's range."] = "设置战斗记录范围。",

	["Creatures"] = "生物",
	["Creature combat log range."] = "生物战斗记录范围。",

	["Deaths"] = "死亡",
	["Death message range."] = "死亡信息范围。",

	["Reset to defaults"] = "重置",
	["Resets all ranges to defaults."] = "重置为默认设置。",
} end)

L:RegisterTranslations("zhTW", function() return {
	["Range"] = "範圍",
	["Options for the combat log's range."] = "戰鬥記錄範圍的選項。",

	["Creatures"] = "生物",
	["Creature combat log range."] = "生物戰鬥記錄範圍。",

	["Deaths"] = "死亡",
	["Death message range."] = "死亡訊息範圍。",

	["Reset to defaults"] = "重設",
	["Resets all ranges to defaults."] = "重置為預設值。",
} end)

L:RegisterTranslations("deDE", function() return {
	["Range"] = "Reichweite",
	["Options for the combat log's range."] = "Optionen f\195\188r die Reichweite des Kampflogs.",

	["Creatures"] = "Kreaturen",
	["Creature combat log range."] = "Reichweite von Kreaturen-Nachrichten im Kampflog.",

	["Deaths"] = "Tode",
	["Death message range."] = "Reichweite von Todes-Nachrichten im Kampflog.",

	["Reset to defaults"] = "Zur\195\188cksetzen",
	["Resets all ranges to defaults."] = "Auf Standard zur\195\188cksetzen.",
} end)

L:RegisterTranslations("frFR", function() return {
	["Range"] = "Portée",
	["Options for the combat log's range."] = "Options concernant la portée du journal de combat.",

	["Creatures"] = "Créatures",
	["Creature combat log range."] = "Portée du journal de combat des créatures.",

	["Deaths"] = "Morts",
	["Death message range."] = "Portée du journal de combat des décès.",

	["Reset to defaults"] = "RÀZ",
	["Resets all ranges to defaults."] = "Réinitialise tous les paramètres à leurs valeurs par défaut.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewModule("Range")

plugin.revision = tonumber(string.sub("$Revision$", 12, -3))
plugin.consoleCmd = L["Range"]
plugin.consoleOptions = {
	type = "group",
	name = L["Range"],
	desc = L["Options for the combat log's range."],
	args = {
		mob = {
			type = "range",
			name = L["Creatures"],
			desc = L["Creature combat log range."],
			order = 3,
			min = 5,
			max = 200,
			step = 5,
			get = function() return GetCVar("CombatLogRangeCreature") end,
			set = function(v) SetCVar("CombatLogRangeCreature", v) end,
		},
		death = {
			type = "range",
			name = L["Deaths"],
			desc = L["Death message range."],
			order = 4,
			min = 5,
			max = 200,
			step = 5,
			get = function() return GetCVar("CombatDeathLogRange") end,
			set = function(v) SetCVar("CombatDeathLogRange", v) end,
		},
		reset = {
			type = "execute",
			name = L["Reset to defaults"],
			order = -1,
			desc = L["Resets all ranges to defaults."],
			func = function()
				SetCVar("CombatLogRangeCreature", 30)
				SetCVar("CombatDeathLogRange", 60)
			end,
		},
	},
}
