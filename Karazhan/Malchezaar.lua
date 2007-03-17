------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Prince Malchezaar"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local afflict

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Malchezaar",

	phase = "Engage",
	phase_desc = "Alert when changing phases",

	enfeeble = "Enfeeble",
	enfeeble_desc = "Show cooldown timer for enfeeble",

	infernals = "Infernals",
	infernals_desc = "Show cooldown timer for Infernal summons.",

	nova = "Shadow Nova",
	nova_desc = "Estimated Shadow Nova timers",

	phase1_trigger = "Madness has brought you here to me. I shall be your undoing!",
	phase2_trigger = "Simple fools! Time is the fire in which you'll burn!",
	phase3_trigger = "How can you hope to stand against such overwhelming power?",
	phase1_message = "Phase 1 - Infernal in ~40sec!",
	phase2_message = "60% - Phase 2",
	phase3_message = "30% - Phase 3 ",

	enfeeble_trigger = "afflicted by Enfeeble",
	enfeeble_message = "Enfeeble! next in ~30sec",
	enfeeble_warning = "Enfeeble in ~5sec!",
	enfeeble_bar = "Enfeeble",
	enfeeble_nextbar = "Next Enfeeble",

	infernal_trigger1 = "You face not Malchezzar alone, but the legions I command!",
	infernal_trigger2 = "All realities, all dimensions are open to me!",
	infernal_bar = "Incoming Infernal",
	infernal_warning = "Infernal incoming in ~20sec!",
	infernal_message = "Infernal in ~5sec!",

	nova_trigger = "Prince Malchezaar begins to cast Shadow Nova",
	nova_message = "Shadow Nova!",
	nova_bar = "~Incoming Nova",
} end )

L:RegisterTranslations("deDE", function() return {
	phase = "Engage",
	phase_desc = "Warnt wenn eine neue Phase beginnt",

	enfeeble = "Entkr\195\164ften",
	enfeeble_desc = "Zeige Timerbalken f\195\188r Entkr\195\164ften",

	infernals = "Infernos",
	infernals_desc = "Zeige Timerbalken f\195\188r Infernos",

	nova = "Schattennova",
	nova_desc = "Ungef\195\164re Zeitangabe f\195\188r Schattennova",

	phase1_trigger = "Der Wahnsinn f\195\188hrte Euch zu mir. Ich werde Euch das Genick brechen!",
	phase2_trigger = "Dummk\195\182pfe! Zeit ist das Feuer, in dem Ihr brennen werdet!",
	phase3_trigger = "Wie k\195\182nnt Ihr hoffen, einer so \195\188berw\195\164ltigenden Macht gewachsen zu sein?",
	phase1_message = "Phase 1 - Infernos in ~40 Sek!",
	phase2_message = "60% - Phase 2",
	phase3_message = "30% - Phase 3 ",

	enfeeble_trigger = "von Entkr\195\164ften betroffen",
	enfeeble_message = "Entkr\195\164ften! N\195\164chste in ~30 Sek",
	enfeeble_warning = "Entkr\195\164ften in ~5 Sek!",
	enfeeble_bar = "Entkr\195\164ften",
	enfeeble_nextbar = "N\195\164chste Entkr\195\164ften",

	infernal_trigger1 = "Ihr steht nicht nur vor Malchezzar allein, sondern vor den Legionen, die ich befehlige!",
	infernal_trigger2 = "Alle Realit\195\164ten, alle Dimensionen stehen mir offen!",
	infernal_bar = "Infernos",
	infernal_warning = "Infernos in ~20 Sek!",
	infernal_message = "Infernos in ~5 Sek!",

	nova_trigger = "Prinz Malchezaar beginnt Schattennova zu wirken",
	nova_message = "Schattennova!",
	nova_bar = "~Schattennova",
} end )

L:RegisterTranslations("frFR", function() return {
	phase = "Alerte Engagement",
	phase_desc = "Pr\195\169viens des changements de phase",

	enfeeble = "Affaiblir",
	enfeeble_desc = "Voir le d\195\169compte pour affaiblir",

	infernals = "Infernaux",
	infernals_desc = "Voir le d\195\169compte pour l'invocation des Infernaux.",

	nova = "Nova de l'ombre",
	nova_desc = "Temps \195\169stim\195\169 pour la Nova de l'ombre",

	phase1_trigger = "La folie vous a fait venir ici, devant moi. Et je serai votre perte !",
	phase2_trigger = "Imb\195\169ciles heureux ! Le temps est le brasier dans lequel vous br\195\187lerez !",
	phase3_trigger = "Comment pouvez-vous esp\195\169rer r\195\169sister devant un tel pouvoir ?",
	phase1_message = "Phase 1 - Infernal dans ~40sec!",
	phase2_message = "60% - Phase 2",
	phase3_message = "30% - Phase 3 ",

	enfeeble_trigger = "subit les effets DE Affaiblir",
	enfeeble_message = "Affaiblir! prochain dans ~30sec",
	enfeeble_warning = "Affaiblir dans ~5sec!",
	enfeeble_bar = "Affaiblir",
	enfeeble_nextbar = "Prochain Affaiblir",

	infernal_trigger1 = "Vous n'affrontez pas seulement Malchezzar, mais les l\195\169gions que je commande !",
	infernal_trigger2 = "Toutes les r\195\169alit\195\169s, toutes les dimensions me sont ouvertes !",
	infernal_bar = "Arriv\195\169 d'infernal",
	infernal_warning = "Arriv\195\169 d'infernal dans ~20sec!",
	infernal_message = "Infernal dans ~5sec!",

	nova_trigger = "Prince Malchezaar commence \195\160 lancer Nova de l'ombre.",
	nova_message = "Nova de l'ombre !",
	nova_bar = "~Arriv\195\169 de la Nova",
} end )

L:RegisterTranslations("koKR", function() return {
	phase = "단계",
	phase_desc = "단계 변화 시 알림",

	enfeeble = "쇠약",
	enfeeble_desc = "쇠약에 대한 재사용 대기시간 표시",

	infernals = "불지옥",
	infernals_desc = "불지옥 소환에 대한 재사용 대기시간 표시",

	nova = "암흑 회오리",
	nova_desc = "암흑 회오리 예상 타이머",

	phase1_trigger = "여기까지 오다니 정신이 나간 놈들이 분명하구나. 소원이라면 파멸을 시켜주마!",
	phase2_trigger = "바보 같으니! 시간은 너의 몸을 태우는 불길이 되리라!",
	phase3_trigger = "어찌 감히 이렇게 압도적인 힘에 맞서기를 꿈꾸느냐?",
	phase1_message = "1 단계 - 약 40초 후 불지옥!",
	phase2_message = "60% - 2 단계",
	phase3_message = "30% - 3 단계",

	enfeeble_trigger = "쇠약에 걸렸습니다%.$",
	enfeeble_message = "쇠약! 다음은 약 30초 후",
	enfeeble_warning = "약 5초 후 쇠약!",
	enfeeble_bar = "쇠약",
	enfeeble_nextbar = "다음 쇠약",

	infernal_trigger1 = "이 말체자르님은 혼자가 아니시다. 너희는 나의 군대와 맞서야 한다!",
	infernal_trigger2 = "모든 차원과 실체가 나를 향해 열려 있노라!",
	infernal_bar = "불지옥 등장",
	infernal_warning = "약 20초 후 불지옥 등장!",
	infernal_message = "약 5초 후 불지옥 등장!",

	nova_trigger = "공작 말체자르|1이;가; 암흑 회오리 시전을 시작합니다.",
	nova_message = "암흑 회오리!",
	nova_bar = "~암흑 회오리",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
mod.enabletrigger = boss
mod.toggleoptions = {"phase", "enfeeble", "nova", "infernals", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	afflict = nil
	self:RegisterEvent("BigWigs_Message")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "EnfeebleEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "EnfeebleEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "EnfeebleEvent")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MalchezaarEnfeeble", 20)
	self:TriggerEvent("BigWigs_ThrottleSync", "MalchezaarNova", 20)
end

------------------------------
--     Event Handlers    --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.infernals and (msg == L["infernal_trigger1"] or msg == L["infernal_trigger2"]) then
		self:Message(L["infernal_warning"], "Positive")
		self:NextInfernal()
	elseif self.db.profile.phase and msg == L["phase1_trigger"] then
		self:Message(L["phase1_message"], "Positive")
	elseif self.db.profile.phase and msg == L["phase2_trigger"] then
		self:Message(L["phase2_message"], "Positive")
	elseif self.db.profile.phase and msg == L["phase3_trigger"] then
		self:Message(L["phase3_message"], "Positive")
	end
end

function mod:NextInfernal()
	self:DelayedMessage(15, L["infernal_message"], "Urgent", nil, "Alert")
	self:Bar(L["infernal_bar"], 20, "INV_Stone_05")
end

function mod:EnfeebleEvent(msg)
	if not afflict and msg:find(L["enfeeble_trigger"]) then
		self:Sync("MalchezaarEnfeeble")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["nova_trigger"]) then
		self:Sync("MalchezaarNova")
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "MalchezaarEnfeeble" then
		if self.db.profile.enfeeble then
			afflict = true
			self:Message(L["enfeeble_message"], "Important", nil, "Alarm")
			self:DelayedMessage(25, L["enfeeble_warning"], "Attention")
			self:Bar(L["enfeeble_bar"], 7, "Spell_Shadow_LifeDrain02")
			self:Bar(L["enfeeble_nextbar"], 30, "Spell_Shadow_LifeDrain02")
		end
		if self.db.profile.nova then
			self:Bar(L["nova_bar"], 5, "Spell_Shadow_Shadowfury")
		end
	elseif sync == "MalchezaarNova" and self.db.profile.nova then
		self:Message(L["nova_message"], "Attention", nil, "Info")
		self:Bar(L["nova_message"], 2, "Spell_Shadow_Shadowfury")
	end
end

function mod:BigWigs_Message(text)
	if text == L["enfeeble_warning"] then
		afflict = nil
	end
end
