------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Gehennas")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

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
} end)


L:RegisterTranslations("koKR", function() return {
	trigger1 = "게헨나스의 저주에 걸렸습니다.",

	warn1 = "5초후 게헨나스의 저주!",
	warn2 = "게헨나스의 저주 - 다음 저주 30초후!",

	bar1text = "게헨나스의 저주",
} end)


L:RegisterTranslations("deDE", function() return {
	trigger1 = "von Gehennas Fluch betroffen",

	warn1 = "5 Sekunden bis Gehennas' Fluch!",
	warn2 = "Gehennas' Fluch! N\195\164chster in 30 Sekunden!",

	bar1text = "Gehennas' Fluch",
} end)


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsGehennas = BigWigs:NewModule(boss)
BigWigsGehennas.zonename = AceLibrary("Babble-Zone-2.0")("Molten Core")
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
	if (not prior and string.find(msg, L"trigger1") and not self.db.profile.notCurse) then
		self:TriggerEvent("BigWigs_Message", L"warn2", "Red")
		self:ScheduleEvent("BigWigs_Message", 25, L"warn1", "Orange")
		self:TriggerEvent("BigWigs_StartBar", self, L"bar1text", 30, 1, "Interface\\Icons\\Spell_Shadow_BlackPlague", "Yellow", "Orange", "Red")
		prior = true
	end
end

function BigWigsGehennas:BigWigs_Message(msg)
	if (msg == L"warn1") then prior = nil end
end