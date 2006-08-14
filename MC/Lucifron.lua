------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Lucifron")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

local prior1
local prior2

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	trigger1 = "afflicted by Lucifron",
	trigger2 = "afflicted by Impending Doom",

	warn1 = "5 seconds until Lucifron's Curse!",
	warn2 = "Lucifron's Curse - 20 seconds until next!",
	warn3 = "5 seconds until Impending Doom!",
	warn4 = "Impending Doom - 20 seconds until next!",

	bar1text = "Lucifron's Curse",
	bar2text = "Impending Doom",

	cmd = "Lucifron",
	
	curse_cmd = "curse",
	curse_name = "Lucifron's Curse alert",
	curse_desc = "Warn for Lucifron's Curse",
	
	doom_cmd = "dmg",
	doom_name = "Impending Doom alert",
	doom_desc = "Warn for Impending Doom",
} end)

L:RegisterTranslations("zhCN", function() return {
	trigger1 = "受到了鲁西弗隆的诅咒",
	trigger2 = "受到了末日降临",

	warn1 = "5秒后发动鲁西弗隆的诅咒！",
	warn2 = "鲁西弗隆的诅咒 - 20秒后再次发动",
	warn3 = "5秒后发动末日降临！",
	warn4 = "末日降临 - 20秒后再次发动",

	bar1text = "鲁西弗隆的诅咒",
	bar2text = "末日降临",
	
	curse_name = "诅咒警报",
	curse_desc = "诅咒警报",
	
	doom_name = "末日降临警报",
	doom_desc = "末日降临警报",
} end)

L:RegisterTranslations("koKR", function() return {
	trigger1 = "루시프론의 저주에 걸렸습니다.",
	trigger2 = "파멸의 예언에 걸렸습니다.",

	warn1 = "5초후 루시프론의 저주!",
	warn2 = "루시프론의 저주 - 다음 저주는 20초후!",
	warn3 = "5초후 파멸의 예언!",
	warn4 = "파멸의 예언 - 다음 예언은 20초후!",

	bar1text = "루시프론의 저주",
	bar2text = "파멸의 예언",
} end)


L:RegisterTranslations("deDE", function() return {
	trigger1 = "von Lucifrons Fluch betroffen",
	trigger2 = "von Drohende Verdammnis betroffen",

	warn1 = "5 Sekunden bis Lucifrons Fluch!",
	warn2 = "Lucifrons Fluch - N\195\164chster in 20 Sekunden!",
	warn3 = "5 Sekunden bis Drohende Verdammnis!",
	warn4 = "Drohende Verdammnis - N\195\164chste in 20 Sekunden!",

	bar1text = "Lucifrons Fluch",
	bar2text = "Drohende Verdammnis",

	cmd = "Lucifron",
	
	curse_cmd = "curse",
	curse_name = "Lucifrons Fluch",
	curse_desc = "Warnung vor Lucifrons Fluch.",
	
	doom_cmd = "dmg",
	doom_name = "Drohende Verdammnis",
	doom_desc = "Warnung vor Drohender Verdammnis.",
} end)

L:RegisterTranslations("frFR", function() return {
	trigger1 = "subit les effets de Mal\195\169diction de Lucifron",
	trigger2 = "subit les effets de Mal\195\169diction imminente.",

	warn1 = "5 secondes avant Mal\195\169diction de Lucifron!",
	warn2 = "Mal\195\169diction de Lucifron - 20 sec avant prochaine!",
	warn3 = "5 secondes avant Mal\195\169diction imminente!",
	warn4 = "Mal\195\169diction imminente - 20 sec avant prochaine!",

	bar1text = "Mal\195\169diction de Lucifron",
	bar2text = "Mal\195\169diction imminente",
} end)


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsLucifron = BigWigs:NewModule(boss)
BigWigsLucifron.zonename = AceLibrary("Babble-Zone-2.0")("Molten Core")
BigWigsLucifron.enabletrigger = boss
BigWigsLucifron.toggleoptions = {"curse", "doom", "bosskill"}
BigWigsLucifron.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsLucifron:OnEnable()
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	prior1 = nil
	prior2 = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsLucifron:Event(msg)
	if (not prior1 and string.find(msg, L"trigger1") and self.db.profile.curse) then
		self:TriggerEvent("BigWigs_Message", L"warn2", "Red")
		self:ScheduleEvent("BigWigs_Message", 15, L"warn1", "Orange")
		self:TriggerEvent("BigWigs_StartBar", self, L"bar1text", 20, "Interface\\Icons\\Spell_Shadow_BlackPlague", "yellow", "orange", "red")
		prior1 = true
	elseif (not prior2 and string.find(msg, L"trigger2") and self.db.profile.doom) then
		self:TriggerEvent("BigWigs_Message", L"warn4", "Red")
		self:ScheduleEvent("BigWigs_Message", 15, L"warn3", "Orange")
		self:TriggerEvent("BigWigs_StartBar", self, L"bar2text", 20, "Interface\\Icons\\Spell_Shadow_NightOfTheDead", "yellow", "orange", "red")
		prior2 = true
	end
end

function BigWigsLucifron:BigWigs_Message(msg)
	if (msg == L"warn1") then prior1 = nil
	elseif (msg == L"warn3") then prior2 = nil end
end
