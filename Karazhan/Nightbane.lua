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
	summon_trigger = "An ancient being awakens in the distance...",

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
	fear = "Alerte Rugissement",
	fear_desc = "Pr\195\169viens quand Plaie-de-nuit lance son Rugissement puissant.",

	charr = "Terre calcin\195\169e sur vous",
	charr_desc = "Pr\195\169viens quand vous \195\170tes dans la Terre calcin\195\169e.",

	phase = "Phases",
	phase_desc = ("Pr\195\169viens quand %s change de phase."):format(boss),

	engage = "Engagement",
	engage_desc = "Pr\195\169viens quand Plaie-de-nuit est engag\195\169.",

	blast = "Explosion de fum\195\169e",
	blast_desc = "Pr\195\169viens quand Explosion de fum\195\169e est incan\195\169.",

	bones = "Pluie d'os",
	bones_desc = "Pr\195\169viens quand quelqu'un est touch\195\169 par la Pluie d'os.",

	icon = "Ic\195\180ne de raid",
	icon_desc = "Place une ic\195\180ne de raid sur la personne affect\195\169e par Pluie d'os (n\195\169cessite d'\195\170tre promu ou mieux).",

	whisper = "Avertir joueur",
	whisper_desc = "Pr\195\169viens en priv\195\169 la personne affect\195\169e par la Pluie d'os (n\195\169cessite d'\195\170tre promu ou mieux).",

	fear_trigger = "lancer Rugissement puissant",
	fear_message = "Rugissement dans 2 sec. !",
	fear_warning = "Rugissement imminent !",
	fear_bar = "Prochain rugissement",

	charr_trigger = "Vous subissez les effets .* Terre calcin\195\169e.",
	charr_message = "Terre calcin\195\169e sur VOUS !",

	blast_trigger = "lancer Explosion de fum\195\169e.",
	blast_message = "Explosion de fum\195\169e imminente !",

	airphase_trigger = "Mis\195\169rable vermine. Je vais vous exterminer des airs\194\160!",
	landphase_trigger1 = "Assez\194\160! Je vais atterrir et vous \195\169craser moi-m\195\170me\194\160!",
	landphase_trigger2 = "Insectes\194\160! Je vais vous montrer de quel bois je me chauffe\194\160!",
	airphase_message = "D\195\169collage !",
	landphase_message = "Atterrissage !",
	summon_trigger = "Dans le lointain, un \195\170tre ancien s'\195\169veille…",

	engage_trigger = "Fous\194\160! Je vais mettre un terme rapide \195\160 vos souffrances\194\160!",
	engage_message = "Plaie-de-nuit engag\195\169",

	bones_trigger = "^([^%s]+) ([^%s]+) les effets .* Pluie d'os",
	bones_message = "Pluie d'os sur [%s]",
	bones_whisper = "Pluie d'os sur VOUS !",

	["Restless Skeleton"] = "Squelette sans repos",
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
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

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

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if self.db.profile.phase and msg == L["summon_trigger"] then
		self:Bar(L["landphase_message"], 34, "INV_Misc_Head_Dragon_01")
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
		self:Bar(L["landphase_message"], 57, "INV_Misc_Head_Dragon_01")
	elseif self.db.profile.phase and (msg == L["landphase_trigger1"] or msg == L["landphase_trigger2"]) then
		self:Message(L["landphase_message"], "Important", nil, "Long")
		self:Bar(L["landphase_message"], 17, "INV_Misc_Head_Dragon_01")
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
