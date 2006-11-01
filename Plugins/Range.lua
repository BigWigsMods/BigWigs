
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
	["range"] = true,
	["Options for the combat log's range."] = true,

--~~ 	["party"] = true,
--~~ 	["Party"] = true,
--~~ 	["Party combat log range."] = true,

--~~ 	["friend"] = true,
--~~ 	["Friendlies"] = true,
--~~ 	["Friendly players combat log range."] = true,

	["mob"] = true,
	["Creatures"] = true,
	["Creature combat log range."] = true,

	["death"] = true,
	["Deaths"] = true,
	["Death message range."] = true,

	["reset"] = true,
	["Reset to defaults"] = true,
	["Resets all ranges to defaults."] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Range"] = "범위",
	["Options for the combat log's range."] = "전투 로그의 범위에 대한 설정",

--~~ 	["Party"] = true,
--~~ 	["Party combat log range."] = true,

--~~ 	["Friendlies"] = true,
--~~ 	["Friendly players combat log range."] = true,

	["Creatures"] = "NPC",
	["Creature combat log range."] = "NPC 전투 로그 범위",

	["Deaths"] = "죽음",
	["Death message range."] = "죽음 메세지 범위",

	["Reset to defaults"] = "기본 설정 초기화",
	["Resets all ranges to defaults."] = "모든 범위를 기본 설정으로 초기화",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Range"] = "范围",
	["Options for the combat log's range."] = "设置战斗记录范围。",

--~~ 	["party"] = "",
--~~ 	["Party"] = "",
--~~ 	["Party combat log range."] = "",

--~~ 	["friend"] = "",
--~~ 	["Friendlies"] = "",
--~~ 	["Friendly players combat log range."] = "",

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

--~~ 	["party"] = "",
--~~ 	["Party"] = "",
--~~ 	["Party combat log range."] = "",

--~~ 	["friend"] = "",
--~~ 	["Friendlies"] = "",
--~~ 	["Friendly players combat log range."] = "",

	["Creatures"] = "生物",
	["Creature combat log range."] = "生物戰鬥記錄範圍。",

	["Deaths"] = "死亡",
	["Death message range."] = "死亡訊息範圍。",

	["Reset to defaults"] = "重設",
	["Resets all ranges to defaults."] = "重置為預設值。",
} end)

L:RegisterTranslations("deDE", function() return {
	["Range"] = "Reichweite",
	-- ["range"] = true,
	["Options for the combat log's range."] = "Optionen f\195\188r die Reichweite des Kampflogs.",

--~~ 	["party"] = true,
--~~ 	["Party"] = true,
--~~ 	["Party combat log range."] = true,

--~~ 	["friend"] = true,
--~~ 	["Friendlies"] = true,
--~~ 	["Friendly players combat log range."] = true,

	-- ["mob"] = true,
	["Creatures"] = "Kreaturen",
	["Creature combat log range."] = "Reichweite von Kreaturen-Nachrichten im Kampflog.",

	-- ["death"] = true,
	["Deaths"] = "Tode",
	["Death message range."] = "Reichweite von Todes-Nachrichten im Kampflog.",

	-- ["reset"] = true,
	["Reset to defaults"] = "Zur\195\188cksetzen",
	["Resets all ranges to defaults."] = "Auf Standard zur\195\188cksetzen.",
} end)

L:RegisterTranslations("frFR", function() return {
	["Range"] = "Portée",
	["Options for the combat log's range."] = "Options concernant la portée du journal de combat.",

--~~  	["Party"] = "Groupe",
--~~  	["Party combat log range."] = "Portée du journal de combat du groupe.",

--~~  	["Friendlies"] = "Alliés",
--~~  	["Friendly players combat log range."] = "Portée du journal de combat des alliés.",

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

BigWigsRange = BigWigs:NewModule(L["Range"])
BigWigsRange.consoleCmd = L["range"]
BigWigsRange.consoleOptions = {
	type = "group",
	name = L["Range"],
	desc = L["Options for the combat log's range."],
	args   = {
--~~ 		[L["party"]] = {
--~~ 			type = "range",
--~~ 			name = L["Party"],
--~~ 			desc = L["Party combat log range."],
--~~ 			order = 1,
--~~ 			min = 5,
--~~ 			max = 200,
--~~ 			step = 5,
--~~ 			get = function() return GetCVar("CombatLogRangeParty") end,
--~~ 			set = function(v)
--~~ 				SetCVar("CombatLogRangeParty", v)
--~~ 				SetCVar("CombatLogRangePartyPet", v)
--~~ 			end,
--~~ 		},
--~~ 		[L["friend"]] = {
--~~ 			type = "range",
--~~ 			name = L["Friendlies"],
--~~ 			desc = L["Friendly players combat log range."],
--~~ 			order = 2,
--~~ 			min = 5,
--~~ 			max = 200,
--~~ 			step = 5,
--~~ 			get = function() return GetCVar("CombatLogRangeFriendlyPlayers") end,
--~~ 			set = function(v)
--~~ 				SetCVar("CombatLogRangeFriendlyPlayers", v)
--~~ 				SetCVar("CombatLogRangeFriendlyPlayersPets", v)
--~~ 			end,
--~~ 		},
		[L["mob"]] = {
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
		[L["death"]] = {
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
		[L["reset"]] = {
			type = "execute",
			name = L["Reset to defaults"],
			order = -1,
			desc = L["Resets all ranges to defaults."],
			func = function()
--~~ 				SetCVar("CombatLogRangeParty", 50)
--~~ 				SetCVar("CombatLogRangePartyPet", 50)
--~~ 				SetCVar("CombatLogRangeFriendlyPlayers", 50)
--~~ 				SetCVar("CombatLogRangeFriendlyPlayersPets", 50)
				SetCVar("CombatLogRangeCreature", 30)
				SetCVar("CombatDeathLogRange", 60)
			end,
		},
	},
}
