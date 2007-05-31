------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Nightbane"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local blast

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Nightbane",

	fear = "Fear Alert",
	fear_desc = "Warn for Bellowing Roar.",
	fear_trigger = "cast Bellowing Roar",
	fear_message = "Fear in 2 sec!",
	fear_warning = "Fear Soon",
	fear_bar = "Fear!",
	fear_nextbar = "~Fear Cooldown",

	charr = "Charred Earth on You",
	charr_desc = "Warn when you are on Charred Earth.",
	charr_trigger = "You are afflicted by Charred Earth.",
	charr_message = "Charred Earth on YOU!",

	phase = "Phases",
	phase_desc = ("Warn when %s switches between phases."):format(boss),
	airphase_trigger = "Miserable vermin. I shall exterminate you from the air!",
	landphase_trigger1 = "Enough! I shall land and crush you myself!",
	landphase_trigger2 = "Insects! Let me show you my strength up close!",
	airphase_message = "Flying!",
	landphase_message = "Landing!",
	summon_trigger = "An ancient being awakens in the distance...",

	engage = "Engage",
	engage_desc = "Engage alert.",
	engage_trigger = "What fools! I shall bring a quick end to your suffering!",
	engage_message = "%s Engaged",

	blast = "Smoking Blast",
	blast_desc = "Warn for Smoking Blast being cast.",
	blast_trigger = "cast Smoking Blast",
	blast_message = "Incoming Smoking Blast!",

	bones = "Rain of Bones",
	bones_desc = "Warn when Rain of Bones is being channeled.",
	bones_message = "AoE Rain of Bones!",
} end )

L:RegisterTranslations("deDE", function() return {
	fear = "Furcht Alarm",
	fear_desc = "Warnt vor Dr\195\182hnendem Gebr\195\188ll",

	charr = "Verbrannte Erde auf Dir",
	charr_desc = "Warnt wenn du in der Verbrannten Erde stehst",

	phase = "Phasen",
	phase_desc = ("Warnt wenn %s die Phasen wechelt"):format(boss),

	engage = "Engage",
	engage_desc = "Engage alert",

	blast = "Rauchende Explosion",
	blast_desc = "Warnt vor Rauchende Explosion",

	bones = "Knochenregen",
	--bones_desc = "Warnt wer den Knochenregen hat", --enUS changed

	fear_trigger = "Schrecken der Nacht beginnt Dr\195\182hnendes Gebr\195\188ll zu wirken.",
	fear_message = "Furcht in 2sek!",
	fear_warning = "Furcht bald",
	fear_bar = "Furcht",

	charr_trigger = "Ihr seid von Verbrannte Erde betroffen.",
	charr_message = "Verbrannte Erde auf DIR!",

	blast_trigger = "Schrecken der Nacht beginnt Rauchende Explosion zu wirken.",
	blast_message = "Rauchende Explosion kommt!",

	airphase_trigger = "Abscheuliches Gew\195\188rm! Ich werde euch aus der Luft vernichten!",
	landphase_trigger1 = "Genug! Ich werde landen und mich h\195\182chst pers\195\182nlich um Euch k\195\188mmern!",
	landphase_trigger2 = "Insekten! Lasst mich Euch meine Kraft aus n\195\164chster N\195\164he demonstrieren!",
	airphase_message = "Flug!",
	landphase_message = "Landung!",

	engage_trigger = "Narren! Ich werde Eurem Leiden ein schnelles Ende setzen!",
	engage_message = "%s angegriffen",
} end )

L:RegisterTranslations("frFR", function() return {
	fear = "Rugissement",
	fear_desc = "Préviens quand Plaie-de-nuit lance son Rugissement puissant.",
	fear_trigger = "lancer Rugissement puissant",
	fear_message = "Rugissement dans 2 sec. !",
	fear_warning = "Rugissement imminent",
	fear_bar = "Rugissement !",
	fear_nextbar = "~Cooldown Rugissement",

	charr = "Terre calcinée sur vous",
	charr_desc = "Préviens quand vous êtes dans la Terre calcinée.",
	charr_trigger = "Vous subissez les effets de Terre calcinée.",
	charr_message = "Terre calcinée sur VOUS !",

	phase = "Phases",
	phase_desc = ("Préviens quand %s passe d'une phase à l'autre."):format(boss),
	airphase_trigger = "Misérable vermine. Je vais vous exterminer des airs !",
	landphase_trigger1 = "Assez ! Je vais atterrir et vous écraser moi-même !",
	landphase_trigger2 = "Insectes ! Je vais vous montrer de quel bois je me chauffe !",
	airphase_message = "Décollage !",
	landphase_message = "Atterrissage !",
	summon_trigger = "Dans le lointain, un être ancien s'éveille…",

	engage = "Engagement",
	engage_desc = "Préviens quand Plaie-de-nuit est engagé.",
	engage_trigger = "Fous ! Je vais mettre un terme rapide à vos souffrances !",
	engage_message = "%s engagé",

	blast = "Explosion de fumée",
	blast_desc = "Préviens quand Explosion de fumée est incanté.",
	blast_trigger = "lancer Explosion de fumée.",
	blast_message = "Explosion de fumée imminente !",

	bones = "Pluie d'os",
	bones_desc = "Préviens quand la Pluie d'os est canalisée.",
	bones_message = "Pluie d'os de zone !",
} end )

L:RegisterTranslations("koKR", function() return {
	fear = "공포 경고",
	fear_desc = "우레와 같은 울부짖음에 대한 경고.",
	fear_trigger = "우레와 같은 울부짖음 시전을 시작합니다.",
	fear_message = "2초 후 공포!",
	fear_warning = "잠시 후 공포",
	fear_bar = "공포!",
	fear_nextbar = "~공포 대기시간",

	charr = "당신에 불타버린 대지",
	charr_desc = "당신이 불타버린 대지에 걸렸을 때 알림.",
	charr_trigger = "당신은 불타버린 대지에 걸렸습니다.",
	charr_message = "당신에 불타버린 대지!",

	phase = "단계",
	phase_desc = ("%s의 단계 변경 시 알림."):format(boss),
	airphase_trigger = "이 더러운 기생충들, 내가 하늘에서 너희의 씨를 말리리라!",
	landphase_trigger1 = "그만! 내 친히 내려가서 너희를 짓이겨주마!",
	landphase_trigger2 = "하루살이 같은 놈들! 나의 힘을 똑똑히 보여주겠다!",
	airphase_message = "비행!",
	landphase_message = "착지!",
	summon_trigger = "멀리에서 고대의 존재가 깨어나고 있다...",

	engage = "전투 개시",
	engage_desc = "전투 개시 알림.",
	engage_trigger = "정말 멍청하군! 고통 없이 빨리 끝내주마!",
	engage_message = "%s 전투 개시",

	blast = "불타는 돌풍",
	blast_desc = "불타는 돌풍 시전에 대한 경고.",
	blast_trigger = "불타는 돌풍 시전을 시작합니다.",
	blast_message = "잠시 후 불타는 돌풍!",

	bones = "뼈의 비",
	bones_desc = "뼈의 비 시전 시작 시 알림.",
	bones_message = "광역 뼈의 비!",
} end )

L:RegisterTranslations("zhTW", function() return {
	fear = "恐懼警告",
	fear_desc = "低沉咆哮警告",

	charr = "灼燒大地警告",
	charr_desc = "當你受到灼燒大地時警告",

	phase = "階段警告",
	phase_desc = ("當 %s 切換狀態時警告"):format(boss),

	engage = "開戰警告",
	engage_desc = "開戰警告",

	blast = "爆裂濃煙警告",
	blast_desc = "當爆裂濃煙施放時警告",

	bones = "碎骨之雨警告",
	--bones_desc = "當碎骨之雨施放時警告", --enUS changed

	fear_trigger = "施放低沉咆哮",
	fear_message = "兩秒鐘內恐懼！",
	fear_warning = "恐懼即將來臨！",
	fear_bar = "恐懼計時",

	charr_trigger = "你獲得了灼燒大地",
	charr_message = "灼燒大地在你腳下！",

	blast_trigger = "夜禍開始施放爆裂濃煙",
	blast_message = "施放爆裂濃煙中！",

	airphase_trigger = "悲慘的害蟲。我將讓你消失在空氣中!",
	landphase_trigger1 = "夠了!我要親自挑戰你!",
	landphase_trigger2 = "昆蟲!給你們近距離嚐嚐我的厲害!",
	airphase_message = "升空準備！",
	landphase_message = "落地準備！",
	summon_trigger = "一個古老的生物在遠處甦醒過來……",

	engage_trigger = "真是蠢蛋!我會快點結束你的痛苦!",
	engage_message = "%s 開戰！",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
mod.enabletrigger = boss
mod.toggleoptions = {"engage", "phase", "fear", "blast", "charr", "bones", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "NBFear", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "NBBlast", 15)
	self:TriggerEvent("BigWigs_ThrottleSync", "NBBones", 15)

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "NBFear" and self.db.profile.fear then
		self:CancelScheduledEvent("fear")
		self:Bar(L["fear_bar"], 2.5, "Spell_Shadow_PsychicScream")
		self:Message(L["fear_message"], "Positive")
		self:Bar(L["fear_nextbar"], 37, "Spell_Shadow_PsychicScream")
		self:ScheduleEvent("fear", "BigWigs_Message", 35, L["fear_warning"], "Positive")
	elseif sync == "NBBlast" and not blast and self.db.profile.blast then
		self:Message(L["blast_message"], "Urgent", nil, "Alert")
		blast = true
	elseif sync == "NBBones" and self.db.profile.bones then
		self:Message(L["bones_message"], "Urgent")
		self:Bar(L["bones"], 11, "INV_Misc_Bone_10")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["fear_trigger"]) then
		self:Sync("NBFear")
	elseif not blast and msg:find(L["blast_trigger"]) then
		self:Sync("NBBlast")
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if self.db.profile.phase and msg == L["summon_trigger"] then
		self:Bar(L["landphase_message"], 34, "INV_Misc_Head_Dragon_01")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		blast = nil
		if self.db.profile.engage then
			self:Message(L["engage_message"]:format(boss), "Positive")
		end
		if self.db.profile.fear then
			self:Bar(L["fear_nextbar"], 35, "Spell_Shadow_PsychicScream")
			self:ScheduleEvent("fear", "BigWigs_Message", 33, L["fear_warning"], "Positive")
		end
	elseif self.db.profile.phase and msg == L["airphase_trigger"] then
		self:Message(L["airphase_message"], "Attention", nil, "Info")
		self:CancelScheduledEvent("fear")
		self:TriggerEvent("BigWigs_StopBar", self, L["fear_warning"])
		self:Bar(L["landphase_message"], 57, "INV_Misc_Head_Dragon_01")
	elseif self.db.profile.phase and (msg == L["landphase_trigger1"] or msg == L["landphase_trigger2"]) then
		self:Message(L["landphase_message"], "Important", nil, "Long")
		self:Bar(L["landphase_message"], 17, "INV_Misc_Head_Dragon_01")
		blast = nil
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE(msg)
	if self.db.profile.charr and msg == L["charr_trigger"] then
		self:Message(L["charr_message"], "Urgent", true, "Alarm")
	end
end

function mod:UNIT_SPELLCAST_CHANNEL_START(msg)
	if UnitName(msg) == boss and (UnitChannelInfo(msg)) == L["bones"] then
		self:Sync("NBBones")
	end
end
