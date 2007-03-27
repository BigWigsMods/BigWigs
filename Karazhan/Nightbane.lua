------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Nightbane"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local blast
local bones

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Nightbane",

	fear = "Fear Alert",
	fear_desc = "Warn for Bellowing Roar",

	charr = "Charred Earth on You",
	charr_desc = "Warn when you are on Charred Earth",

	phase = "Phases",
	phase_desc = ("Warn when %s switches between phases"):format(boss),

	engage = "Engage",
	engage_desc = "Engage alert",

	blast = "Smoking Blast",
	blast_desc = "Warn for Smoking Blast being cast",

	bones = "Raid of Bones",
	bones_desc = "Warn who Rain of Bones is on",

	icon = "Raid Icon",
	icon_desc = "Place a raid icon on the person afflicted by Rain of Bones(requires promoted or higher)",

	whisper = "Whisper Player",
	whisper_desc = "Whisper the person afflicted by Rain of Bones(requires promoted or higher)",

	fear_trigger = "cast Bellowing Roar",
	fear_message = "Fear in 2 sec!",
	fear_warning = "Fear Soon",
	fear_bar = "Fear",

	charr_trigger = "You are afflicted by Charred Earth.",
	charr_message = "Charred Earth on YOU!",

	blast_trigger = "cast Smoking Blast",
	blast_message = "Incoming Smoking Blast!",

	airphase_trigger = "Miserable vermin. I shall exterminate you from the air!",
	landphase_trigger1 = "Enough! I shall land and crush you myself!",
	landphase_trigger2 = "Insects! Let me show you my strength up close!",
	airphase_message = "Flying!",
	landphase_message = "Landing!",

	engage_trigger = "What fools! I shall bring a quick end to your suffering!",
	engage_message = "%s Engaged",

	bones_trigger = "^([^%s]+) ([^%s]+) afflicted by Rain of Bones",
	bones_message = "Rain of Bones on [%s]",
	bones_whisper = "Rain of Bones on you!",

	["Restless Skeleton"] = true,
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

	blast = "Ablenkende Asche",
	blast_desc = "Warnt vor Ablenkende Asche",

	bones = "Knochenregen",
	bones_desc = "Warnt wer den Knochenregen hat",

	icon = "Raid Icon",
	icon_desc = "Platziert ein Raid Icon auf den Spieler der vom Knochenregen betroffen ist(requires promoted or higher)",

	whisper = "Whisper Player",
	whisper_desc = "Fl\195\188stert den Spieler an der vom Knochenregen betroffen ist(requires promoted or higher)",

	fear_trigger = "Schrecken der Nacht beginnt Dr\195\182hnendes Gebr\195\188ll zu wirken.",
	fear_message = "Fear in 2 sek!",
	fear_warning = "Fear Soon",
	fear_bar = "Fear",

	charr_trigger = "Ihr seid von Verbrannte Erde betroffen.",
	charr_message = "Verbrannte Erde auf DIR!",

	blast_trigger = "Schrecken der Nacht beginnt Ablenkende Asche zu wirken.",
	blast_message = "Incoming Ablenkende Asche!",

	airphase_trigger = "Abscheuliches Gew\195\188rm! Ich werde euch aus der Luft vernichten!",
	landphase_trigger1 = "Genug! Ich werde landen und mich h\195\182chst pers\195\182nlich um Euch k\195\188mmern!",
	landphase_trigger2 = "Insekten! Lasst mich Euch meine Kraft aus n\195\164chster N\195\164he demonstrieren!",
	airphase_message = "Flug!",
	landphase_message = "Landung!",

	engage_trigger = "Narren! Ich werde Eurem Leiden ein schnelles Ende setzen!",
	engage_message = "%s Engaged",

	bones_trigger = "^([^%s]+) ([^%s]+) von Knochenregen betroffen",
	bones_message = "Knochenregen auf [%s]",
	bones_whisper = "Knochenregen auf DIR!",
} end )

L:RegisterTranslations("frFR", function() return {
	fear = "Alerte Fear",
	fear_desc = "Pr\195\169viens du Rugissement puissant.",

	charr = "Terre calcin\195\169e",
	charr_desc = "Pr\195\169viens lorsque vous vous trouvez sur une Terre calcin\195\169e.",

	phase = "Alertes Phases",
	phase_desc = ("Pr\195\169viens quand %s change de phase."):format(boss),

	engage = "Alerte Engagement",
	engage_desc = "Pr\195\169viens quand Plaie-de-Nuit est engag\195\169.",

	blast = "Explosion de fum\195\169e",
	blast_desc = "Pr\195\169viens lorsque Plaie-de-Nuit lance Explosion de fum\195\169e.",

	bones = "Pluie d'os",
	bones_desc = "Pr\195\169viens du joueur qui se prend la Pluie d'os de Plaie-de-Nuit.",

	icon = "Placer une ic\195\180ne",
	icon_desc = "Place une ic\195\180ne de raid sur le joueur affect\195\169 par la Pluie d'os(requiert d'\195\170tre promus ou plus).",

	whisper = "Message",
	whisper_desc = "Envoyer un message \195\160 la personne affect\195\169e par la Pluie d'os(requires promoted or higher)",

	fear_trigger = "lance Rugissement puissant",
	fear_message = "Fear dans 2 sec!",
	fear_warning = "Fear proche !",
	fear_bar = "Fear",

	charr_trigger = "Vous subissez les effets de Terre calcin\195\169e.",
	charr_message = "Terre calcin\195\169e sur VOUS !",

	blast_trigger = "lance Explosion de fum\195\169e",
	blast_message = "Explosion de fum\195\169e proche !",

	airphase_trigger = "Mis\195\169rable vermine. Je vais vous exterminer des airs !",
	landphase_trigger1 = "Enough! I shall land and crush you myself!",
	landphase_trigger2 = "Insectes ! Je vais vous montrer de quel bois je me chauffe !",
	airphase_message = "D\195\169ccolage !",
	landphase_message = "Aterrissage !",

	engage_trigger = "Fous ! Je vais mettre un terme \195\160 vos souffrances !",
	engage_message = "Plaie-de-Nuit engag195\169",

	bones_trigger = "^([^%s]+) ([^%s]+) subit les effets de Pluis d'os",
	bones_message = "Pluie d'os sur [%s]",
	bones_whisper = "Pluie d'os sur VOUS !",
} end )

L:RegisterTranslations("koKR", function() return {
	fear = "공포 경고",
	fear_desc = "우레와 같은 울부짖음에 대한 경고",

	charr = "당신에 불타버린 대지",
	charr_desc = "당신이 불타버린 대지에 걸렸을 때 알림",

	phase = "단계",
	phase_desc = ("%s의 단계 변경 시 알림"):format(boss),

	engage = "전투 개시",
	engage_desc = "전투 개시 알림",

	blast = "불타는 돌풍",
	blast_desc = "불타는 돌풍 시전에 대한 경고",

	bones = "뼈의 비",
	bones_desc = "뼈의 비에 걸린 사람 경고",

	icon = "공격대 아이콘",
	icon_desc = "뼈의 비에 걸린 사람에게 공격대 아이콘 지정(승급자 이상 권한 요구)",

	whisper = "귓속말 경고",
	whisper_desc = "뼈의 비에 걸린 사람에게 귓속말 경고(승급자 이상 권한 요구)",

	fear_trigger = "우레와 같은 울부짖음 시전을 시작합니다.",
	fear_message = "2초 후 공포!",
	fear_warning = "잠시 후 공포",
	fear_bar = "공포",

	charr_trigger = "당신은 불타버린 대지에 걸렸습니다.",
	charr_message = "당신에 불타버린 대지!",

	blast_trigger = "불타는 돌풍 시전을 시작합니다.",
	blast_message = "잠시 후 불타는 돌풍!",

	airphase_trigger = "이 더러운 기생충들, 내가 하늘에서 너희의 씨를 말리리라!",
	landphase_trigger1 = "그만! 내 친히 내려가서 너희를 짓이겨주마!",
	landphase_trigger2 = "하루살이 같은 놈들! 나의 힘을 똑똑히 보여주겠다!",
	airphase_message = "비행!",
	landphase_message = "착지!",

	engage_trigger = "정말 멍청하군! 고통 없이 빨리 끝내주마!",
	engage_message = "%s 전투 개시",

	bones_trigger = "^([^|;%s]*)(.*)뼈의 비에 걸렸습니다%.$",
	bones_message = "[%s] 뼈의 비",
	bones_whisper = "당신은 뼈의 비!",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
mod.enabletrigger = boss
mod.wipemobs = {L["Restless Skeleton"]}
mod.toggleoptions = {"engage", "phase", "fear", "blast", "charr", -1, "bones", "icon", "whisper", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "NightbaneFear", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "Bones", 5)

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	blast = nil
	bones = nil
end

------------------------------
--     Event Handlers    --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "NightbaneFear" and self.db.profile.fear then
		self:CancelScheduledEvent("fear")
		self:Bar(L["fear_bar"], 2, "Spell_Shadow_PsychicScream")
		self:Message(L["fear_message"], "Positive")
		self:Bar(L["fear_warning"], 37, "Spell_Shadow_PsychicScream")
		self:ScheduleEvent("fear", "BigWigs_Message", 35, L["fear_warning"], "Positive")
	elseif sync == "NightbaneBlast" and self.db.profile.blast then
		self:Message(L["blast_message"], "Urgent", nil, "Alert")
	elseif sync == "Bones" and rest and self.db.profile.bones then
		self:Message(L["bones_message"]:format(rest), "Attention")
		if self.db.profile.icon then
			self:Icon(rest)
		end
		if self.db.profile.whisper then
			self:Whisper(rest, L["bones_whisper"])
		end
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["fear_trigger"]) then
		self:Sync("NightbaneFear")
	elseif not blast and msg:find(L["blast_trigger"]) then
		self:Sync("NightbaneBlast")
		blast = true
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.engage and msg == L["engage_trigger"] then
		self:Message(L["engage_message"]:format(boss), "Positive")
	elseif self.db.profile.phase and msg == L["airphase_trigger"] then
		self:Message(L["airphase_message"], "Attention", nil, "Info")
		bones = nil
		self:CancelScheduledEvent("fear")
		self:TriggerEvent("BigWigs_StopBar", self, L["fear_warning"])
	elseif self.db.profile.phase and (msg == L["landphase_trigger1"] or msg == L["landphase_trigger2"]) then
		self:Message(L["landphase_message"], "Important", nil, "Long")
		blast = nil
	end
end

function mod:Event(msg)
	if self.db.profile.charr and msg == L["charr_trigger"] then
		self:Message(L["charr_message"], "Urgent", true, "Alarm")
	end
	if not bones then
		local bplayer, btype = select(3, msg:find(L["bones_trigger"]))
		if bplayer and btype then
			if bplayer == L2["you"] and btype == L2["are"] then
				bplayer = UnitName("player")
			end
			self:Sync("Bones "..bplayer)
			bones = true
		end
	end
end
