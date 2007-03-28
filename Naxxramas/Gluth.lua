------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Gluth"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local started = nil
local prior = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Gluth",

	fear = "Fear Alert",
	fear_desc = "Warn for fear",

	frenzy = "Frenzy Alert",
	frenzy_desc = "Warn for frenzy",

	decimate = "Decimate Alert",
	decimate_desc = "Warn for Decimate",

	enrage = "Enrage",
	enrage_desc = "Timer for when he becomes enraged.",

	frenzy_trigger = "%s goes into a frenzy!",
	fear_trigger = "by Terrifying Roar.",

	frenzy_message = "Frenzy Alert!",
	fear_warning = "5 second until AoE Fear!",
	fear_message = "AoE Fear alert - 20 seconds till next!",

	startwarn = "Gluth Engaged! ~105 seconds till Zombies!",
	decimatesoonwarn = "Decimate Soon!",
	decimatewarn = "Decimate!",
	decimatetrigger = "Decimate",

	enrage_warning = "Enrage in %d sec!",
	enrage_bar = "Enrage",

	fear_bar = "AoE Fear",
	decimatebartext = "Decimate Zombies",
} end )

L:RegisterTranslations("koKR", function() return {
	fear = "공포 경고",
	fear_desc = "공포에 대한 경고",

	frenzy = "광폭화 경고",
	frenzy_desc = "광폭화에 대한 경고",

	decimate = "척살 경보",
	decimate_desc = "척살에 대한 경고",

	enrage = "격노",
	enrage_desc = "격노에 대한 타이머",

	frenzy_trigger = "%s|1이;가; 광란의 상태에 빠집니다!", -- CHECK
	fear_trigger = "공포의 포효에",

	frenzy_message = "광폭화 경고!",
	fear_warning = "광역 공포 5초 전!",
	fear_message = "광역 공포 경고 - 20초 후",

	startwarn = "글루스 전투 시작! 약 105초 후 좀비!",
	decimatesoonwarn = "곧 척살!",
	decimatewarn = "척살!",
	decimatetrigger = "척살",

	enrage_warning = "격노까지 %d 초!",
	enrage_bar = "격노",

	fear_bar = "광역 공포",
	decimatebartext = "척살 좀비",
} end )

L:RegisterTranslations("deDE", function() return {
	fear = "Furcht",
	fear_desc = "Warnung vor AoE Furcht.",

	frenzy = "Raserei",
	frenzy_desc = "Warnung, wenn Gluth in Raserei ger\195\164t.",

	decimate = "Dezimieren",
	decimate_desc = "Warnung vor Dezimieren.",

	frenzy_trigger = "%s ger\195\164t in Raserei!",
	fear_trigger = "von Erschreckendes Gebr\195\188ll betroffen.",

	frenzy_message = "Raserei!",
	fear_warning = "AoE Furcht in 5 Sekunden!",
	fear_message = "AoE Furcht! N\195\164chste in 20 Sekunden!",

	startwarn = "Gluth angegriffen! Zombies in ~105 Sekunden!",
	decimatesoonwarn = "Dezimieren kurz bevor",
	decimatewarn = "Dezimieren!",
	decimatetrigger = "Dezimieren",

	fear_bar = "Furcht",
	decimatebartext = "Dezimieren",
} end )

L:RegisterTranslations("zhCN", function() return {
	fear = "恐惧警报",
	fear_desc = "恐惧警报",

	frenzy = "狂暴警报",
	frenzy_desc = "狂暴警报",

	decimate = "残杀警报",
	decimate_desc = "残杀警报",

	frenzy_trigger = "%s变得狂怒无比！",
	fear_trigger = "恐惧怒吼",

	frenzy_message = "狂暴警报 - 猎人立刻使用宁神射击！",
	fear_warning = "5秒后发动群体恐惧！",
	fear_message = "群体恐惧 - 20秒后再次发动",

	startwarn = "格拉斯已激活，~105秒后僵尸出现！",
	decimatesoonwarn = "残杀来临！",
	decimatewarn = "残杀 - AoE僵尸！",
	decimatetrigger = "残杀",

	fear_bar = "群体恐惧",
	decimatebartext = "残杀",
} end )

L:RegisterTranslations("zhTW", function() return {
	fear = "恐嚇咆哮警報",
	fear_desc = "當古魯斯施放恐嚇咆哮時發出警報",

	frenzy = "狂暴警報",
	frenzy_desc = "當古魯斯狂暴時發出警報",

	decimate = "殘殺警報",
	decimate_desc = "當古魯斯發動殘殺時發出警報",

	frenzy_trigger = "%s變得狂暴起來！",
	fear_trigger = "恐嚇咆哮",

	frenzy_message = "狂暴警報 - 獵人立刻使用寧神射擊！",
	fear_warning = "5 秒後發動恐嚇咆哮！",
	fear_message = "恐嚇咆哮 - 20 秒後再次發動",

	startwarn = "古魯斯已進入戰鬥 - 105 秒後殭屍出現！",
	decimatesoonwarn = "殘殺來臨！",
	decimatewarn = "殘殺 - AE殭屍！",
	decimatetrigger = "殘殺",

	fear_bar = "恐嚇咆哮",
	decimatebartext = "殘殺",
} end )

L:RegisterTranslations("frFR", function() return {
	frenzy_trigger = "%s gagne Fr\195\169n\195\169sie.",
	fear_trigger = "de Rugissement terrifiant.",
	decimatetrigger = "D\195\169cimer",
} end )


----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Naxxramas"]
mod.enabletrigger = boss
mod.toggleoptions = {"enrage", "frenzy", "fear", "decimate", "bosskill"}
mod.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	prior = nil
	started = nil

	self:RegisterEvent("BigWigs_Message")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "Frenzy")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE", "Frenzy")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Fear")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Fear")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Fear")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Decimate")

	self:RegisterEvent("BigWigs_RecvSync")
end

function mod:Frenzy( msg )
	if self.db.profile.frenzy and msg == L["frenzy_trigger"] then
		self:TriggerEvent("BigWigs_Message", L["frenzy_message"], "Important")
	end
end

function mod:Fear( msg )
	if self.db.profile.fear and not prior and msg:find(L["fear_trigger"]) then
		self:TriggerEvent("BigWigs_Message", L["fear_message"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["fear_bar"], 20, "Interface\\Icons\\Spell_Shadow_PsychicScream")
		self:ScheduleEvent("BigWigs_Message", 15, L["fear_warning"], "Urgent")
		prior = true
	end
end

function mod:Decimate( msg )
	if msg:find(L["decimatetrigger"]) and self.db.profile.decimate then
		self:TriggerEvent("BigWigs_Message", L["decimatewarn"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["decimatebartext"], 105, "Interface\\Icons\\INV_Shield_01")
		self:ScheduleEvent("BigWigs_Message", 100, L["decimatesoonwarn"], "Urgent")
	end
end

function mod:BigWigs_RecvSync( sync, rest, nick )
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then self:UnregisterEvent("PLAYER_REGEN_DISABLED") end
		if self.db.profile.decimate then
			self:TriggerEvent("BigWigs_Message", L["startwarn"], "Attention")
			self:TriggerEvent("BigWigs_StartBar", self, L["decimatebartext"], 105, "Interface\\Icons\\INV_Shield_01")
			self:ScheduleEvent("BigWigs_Message", 100, L["decimatesoonwarn"], "Urgent")
		end
		if self.db.profile.enrage then
			self:ScheduleEvent("BigWigs_Message", 240, string.format(L["enrage_warning"], 120), "Attention")
			self:ScheduleEvent("BigWigs_Message", 300, string.format(L["enrage_warning"], 60), "Attention")
			self:ScheduleEvent("BigWigs_Message", 330, string.format(L["enrage_warning"], 30), "Urgent")
			self:ScheduleEvent("BigWigs_Message", 350, string.format(L["enrage_warning"], 10), "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["enrage_bar"], 360, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
		end
	end
end

function mod:BigWigs_Message(text)
	if text == L["fear_warning"] then prior = nil end
end

