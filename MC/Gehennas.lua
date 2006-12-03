------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Gehennas"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local prior

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	trigger1 = "afflicted by Gehennas",

	warn1 = "5 seconds until Gehennas' Curse!",
	warn2 = "Gehennas' Curse - 30 seconds until next!",

	bar1text = "Gehennas' Curse",

	cmd = "Gehennas",

	curse_cmd = "curse",
	curse_name = "Gehennas' Curse alert",
	curse_desc = "Warn for Gehennas' Curse",
} end)

L:RegisterTranslations("zhCN", function() return {
	trigger1 = "受到了基赫纳斯的诅咒",

	warn1 = "5秒后发动基赫纳斯的诅咒！",
	warn2 = "基赫纳斯的诅咒 - 30秒后再次发动",

	bar1text = "基赫纳斯的诅咒",

	curse_name = "诅咒警报",
	curse_desc = "诅咒警报",
} end)

L:RegisterTranslations("zhTW", function() return {
	trigger1 = "受到基赫納斯的詛咒",

	warn1 = "群體詛咒 5 秒後發動！",
	warn2 = "群體詛咒 - 30 秒後再次發動",

	bar1text = "基赫納斯的詛咒",

	curse_name = "詛咒警報",
	curse_desc = "當基赫納斯使用反治療群體詛咒時發出警報",
} end)

L:RegisterTranslations("koKR", function() return {
	trigger1 = "게헨나스의 저주에 걸렸습니다.",

	warn1 = "5초후 게헨나스의 저주!",
	warn2 = "게헨나스의 저주 - 다음 저주 30초후!",

	bar1text = "게헨나스의 저주",

	curse_name = "게헨나스의 저주 경고",
	curse_desc = "게헨나스의 저주에 대한 경고",
} end)

L:RegisterTranslations("deDE", function() return {
	trigger1 = "von Gehennas Fluch betroffen",

	warn1 = "Gehennas Fluch in 5 Sekunden!",
	warn2 = "Gehennas Fluch! N\195\164chster in 30 Sekunden!",

	bar1text = "Gehennas Fluch",

	curse_name = "Gehennas Fluch",
	curse_desc = "Warnung, wenn Gehennas AoE Fluch wirkt.",
} end)

L:RegisterTranslations("frFR", function() return {
	trigger1 = "subit les effets de Mal\195\169diction de Gehennas.",

	warn1 = "5 secondes avant Mal\195\169diction !",
	warn2 = "Mal\195\169diction ! - 30 secondes avant la prochaine",

	bar1text = "Mal\195\169diction de Gehennas",

	curse_name = "Alerte Mal\195\169diction de Gehennas",
	curse_desc = "Pr\195\169viens des mal\195\169dictions de Gehennas.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsGehennas = BigWigs:NewModule(boss)
BigWigsGehennas.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
BigWigsGehennas.enabletrigger = boss
BigWigsGehennas.toggleoptions = {"curse", "bosskill"}
BigWigsGehennas.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsGehennas:OnEnable()
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	prior = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsGehennas:Event(msg)
	if (not prior and string.find(msg, L["trigger1"]) and not self.db.profile.notCurse) then
		self:TriggerEvent("BigWigs_Message", L["warn2"], "Important")
		self:ScheduleEvent("BigWigs_Message", 25, L["warn1"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, L["bar1text"], 30, "Interface\\Icons\\Spell_Shadow_BlackPlague")
		prior = true
	end
end

function BigWigsGehennas:BigWigs_Message(msg)
	if (msg == L["warn1"]) then prior = nil end
end
