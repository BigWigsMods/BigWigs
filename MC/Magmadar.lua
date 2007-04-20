------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Magmadar"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Magmadar",

	fear = "Warn for Fear",
	fear_desc = "Warn when Magmadar casts AoE Fear",

	frenzy = "Frenzy alert",
	frenzy_desc = "Warn when Magmadar goes into a frenzy",

	trigger1 = "%s goes into a killing frenzy!",
	trigger2 = "by Panic.",

	frenzywarn = "Frenzy alert!",
	fearalert = "5 seconds until AoE Fear!",
	fearwarn = "AoE Fear - 30 seconds until next!",
	fearbar = "AoE Fear",
} end)

L:RegisterTranslations("koKR", function() return {
	fear = "공포 경고",
	fear_desc = "마그마다르 공포 시전 시 경고",

	frenzy = "광폭화 경고",
	frenzy_desc = "마그마다르 광폭화 시 경고",

	trigger1 = "%s|1이;가; 살기를 띤 듯한 광란의 상태에 빠집니다!",
	trigger2 = "공황에 걸렸습니다.",

	frenzywarn = "광폭화 경보 - 사냥꾼의 평정 사격을 쏘세요!",
	fearalert = "5초후 광역 공포!",
	fearwarn = "광역 공포 경보 - 다음 공포까지 30초!",
	fearbar = "광역 공포",
} end)

L:RegisterTranslations("zhCN", function() return {
	fear = "恐惧警报",
	fear_desc = "恐惧警报",

	frenzy = "狂暴警报",
	frenzy_desc = "狂暴警报",

	trigger1 = "变得狂怒无比！",
	trigger2 = "受到了恐慌",

	frenzywarn = "狂暴警报 - 猎人立刻使用宁神射击！",
	fearalert = "5秒后发动群体恐惧！",
	fearwarn = "群体恐惧 - 30秒后再次发动",
	fearbar = "群体恐惧",
} end)

L:RegisterTranslations("zhTW", function() return {
	fear = "群體恐懼警報",
	fear_desc = "當瑪格曼達發動群體恐懼效果時發出警報",

	frenzy = "狂暴警報",
	frenzy_desc = "當瑪格曼達狂暴時發出警報",

	trigger1 = "變得極為狂暴！",
	trigger2 = "受到恐慌的傷害",

	frenzywarn = "狂暴狀態！ 獵人立刻使用寧神射擊！",
	fearalert = "5 秒後發動群體恐懼",
	fearwarn = "群體恐懼 - 30 秒後再次發動",
	fearbar = "群體恐懼",
} end)

L:RegisterTranslations("deDE", function() return {
	fear = "Furcht",
	fear_desc = "Warnung, wenn Magmadar AoE Furcht wirkt.",

	frenzy = "Raserei",
	frenzy_desc = "Warnung, wenn Magmadar in Raserei ger\195\164t.",

	trigger1 = "%s ger\195\164t in t\195\182dliche Raserei!",
	trigger2 = "von Panik betroffen",

	frenzywarn = "Raserei! - Einlullender Schuss!",
	fearalert = "AoE Furcht in 5 Sekunden!",
	fearwarn = "AoE Furcht! N\195\164chste in 30 Sekunden!",
	fearbar = "AoE Furcht",
} end)

L:RegisterTranslations("frFR", function() return {
	fear = "Alerte Peur",
	fear_desc = "Pr\195\169viens quand Magmadar lance sa peur de zone.",

	frenzy = "Alerte Fr\195\169n\195\169sie",
	frenzy_desc = "Pr\195\169viens quand Magmadar passe en fr\195\169n\195\169sie.",

	trigger1 = "%s entre dans une fr\195\169n\195\169sie sanglante !",
	trigger2 = " subit les effets de Panique.",

	frenzywarn = "Alerte fr\195\169n\195\169sie - Tir tranquillisant !",
	fearalert = "Peur de zone dans 5 secondes !",
	fearwarn = "Peur de zone ! - 30 secondes avant la prochaine",
	fearbar = "Peur de zone",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
mod.enabletrigger = boss
mod.toggleoptions = {"fear", "frenzy", "bosskill"}
mod.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self.prior = nil
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Fear")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Fear")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Fear")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MagmadarFear", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L["trigger1"] and self.db.profile.frenzy then
		self:Message(L["frenzywarn"], "Important", nil, "Alert")
	end
end

function mod:BigWigs_RecvSync( sync ) 
	if sync ~= "MagmadarFear" then return end
	if self.db.profile.fear then
		self:Bar(L["fearbar"], 30, "Spell_Shadow_PsychicScream")
		self:Message(L["fearwarn"], "Important")
		self:ScheduleEvent("BigWigs_Message", 25, L["fearalert"], "Urgent")
	end
end

function mod:Fear(msg)
	if not self.prior and msg:find(L["trigger2"]) then
		self:Sync("MagmadarFear")
		self.prior = true
	end
end

function mod:BigWigs_Message(text)
	if text == L["fearalert"] then self.prior = nil end
end
