------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Magmadar")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	-- Chat message triggers
	trigger1 = "goes into a killing frenzy!",
	trigger2 = "by Panic.",

	-- Warnings and bar texts
	["Frenzy alert!"] = true,
	["5 seconds until AoE Fear!"] = true,
	["AoE Fear - 30 seconds until next!"] = true,
	["AoE Fear"] = true,

	-- AceConsole strings
	cmd = "Magmadar",
	fear_cmd = "fear",
	fear_name = "Warn for Fear",
	fear_desc = "Warn when Magmadar casts AoE Fear",
	frenzy_cmd = "frenzy",
	frenzy_name = "Frenzy alert",
	frenzy_desc = "Warn when Magmadar goes into a frenzy",
} end)

L:RegisterTranslations("koKR", function() return {
	trigger1 = "살기를 띤 듯한 광란의 상태에 빠집니다!",
	trigger2 = "공황에 걸렸습니다.",

	["Frenzy alert!"] = "광폭화 경보 - 사냥꾼의 평정 사격을 쏘세요!",
	["5 seconds until AoE Fear!"] = "5초후 광역 공포!",
	["AoE Fear - 30 seconds until next!"] = "광역 공포 경보 - 다음 공포까지 30초!",

	["AoE Fear"] = "광역 공포",

	fear_name = "공포 경고",
	fear_desc = "공포 경고",
	frenzy_desc = "광폭화 경고",
} end)


L:RegisterTranslations("zhCN", function() return {
	trigger1 = "变得极为狂暴！",
	trigger2 = "受到了恐慌",

	["Frenzy alert!"] = "狂暴警报 - 猎人立刻使用宁神射击！",
	["5 seconds until AoE Fear!"] = "5秒后发动群体恐惧！",
	["AoE Fear - 30 seconds until next!"] = "群体恐惧 - 30秒后再次发动",

	["AoE Fear"] = "群体恐惧",
} end)


L:RegisterTranslations("deDE", function() return {
	trigger1 = "ger\195\164t in t\195\182dliche Raserei!",
	trigger2 = "von Panik betroffen.",

	["Frenzy alert!"] = "RASEREI!",
	["5 seconds until AoE Fear!"] = "5 Sekunden bis Fear!",
	["AoE Fear - 30 seconds until next!"] = "Fear! N\195\164chste in 30 Sekunden!",
} end)


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsMagmadar = BigWigs:NewModule(boss)
BigWigsMagmadar.zonename = AceLibrary("Babble-Zone-2.0")("Molten Core")
BigWigsMagmadar.enabletrigger = boss
BigWigsMagmadar.toggleoptions = {"fear", "frenzy", "bosskill"}
BigWigsMagmadar.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsMagmadar:OnEnable()
	self.prior = nil
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Fear")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Fear")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Fear")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsMagmadar:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L"trigger1" and self.db.profile.frenzy then
		self:TriggerEvent("BigWigs_Message", L"Frenzy alert!", "Red", nil, "Alert")
	end
end

function BigWigsMagmadar:Fear(msg)
	if not self.prior and string.find(msg, L"trigger2") and self.db.profile.fear then
		self:TriggerEvent("BigWigs_StartBar", self, L"AoE Fear", 30, 1, "Interface\\Icons\\Spell_Shadow_PsychicScream", "Yellow", "Orange", "Red")
		self:TriggerEvent("BigWigs_Message", L"AoE Fear - 30 seconds until next!", "Red")
		self:ScheduleEvent("BigWigs_Message", 25, L"5 seconds until AoE Fear!", "Orange")
		self.prior = true
	end
end

function BigWigsMagmadar:BigWigs_Message(text)
	if text == L"5 seconds until AoE Fear!" then self.prior = nil end
end
