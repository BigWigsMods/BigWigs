------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Prince Malchezaar"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local nova = true
local count = 1

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Malchezaar",

	phase = "Engage",
	phase_desc = "Alert when changing phases.",
	phase1_trigger = "Madness has brought you here to me. I shall be your undoing!",
	phase2_trigger = "Simple fools! Time is the fire in which you'll burn!",
	phase3_trigger = "How can you hope to stand against such overwhelming power?",
	phase1_message = "Phase 1 - Infernal in ~40sec!",
	phase2_message = "60% - Phase 2",
	phase3_message = "30% - Phase 3 ",

	enfeeble = "Enfeeble",
	enfeeble_desc = "Show cooldown timer for enfeeble.",
	enfeeble_trigger = "afflicted by Enfeeble%.$",
	enfeeble_message = "Enfeeble! next in 30sec",
	enfeeble_warning1 = "Enfeeble in 5sec!",
	enfeeble_warning2 = "Enfeeble in 10sec!",
	enfeeble_bar = "Enfeeble",
	enfeeble_nextbar = "Next Enfeeble",
	enfeeble_you = "You are afflicted by Enfeeble.",
	enfeeble_warnyou = "Enfeeble on YOU!",

	infernals = "Infernals",
	infernals_desc = "Show cooldown timer for Infernal summons.",
	infernal_trigger1 = "You face not Malchezaar alone, but the legions I command!",
	infernal_trigger2 = "All realities, all dimensions are open to me!",
	infernal_bar = "Incoming Infernal",
	infernal_warning = "Infernal incoming in 20sec!",
	infernal_message = "Infernal Landed! Hellfire in 5sec!",

	nova = "Shadow Nova",
	nova_desc = "Estimated Shadow Nova timers.",
	nova_message = "Shadow Nova!",
	nova_bar = "~Nova Cooldown",
	nova_soon = "Shadow Nova Soon",

	despawn = "Disable Infernal Despawn Timers",
	despawn_desc = "Timers for infernal despawn.",
	despawn_bar = "Infernal (%d) Despawns",
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
	enfeeble_message = "Entkr\195\164ften! N\195\164chste in 30 Sek",
	enfeeble_warning1 = "Entkr\195\164ften in 5 Sek!",
	enfeeble_warning2 = "Entkr\195\164ften in 10 Sek!",
	enfeeble_bar = "Entkr\195\164ften",
	enfeeble_nextbar = "N\195\164chste Entkr\195\164ften",
	--enfeeble_you = "You are afflicted by Enfeeble.",
	--enfeeble_warnyou = "Enfeeble on YOU!",

	infernal_trigger1 = "Ihr steht nicht nur vor Malchezzar allein, sondern vor den Legionen, die ich befehlige!",
	infernal_trigger2 = "Alle Realit\195\164ten, alle Dimensionen stehen mir offen!",
	infernal_bar = "Infernos",
	infernal_warning = "Infernos in 20 Sek!",
	infernal_message = "Infernos in 5 Sek!",

	nova_message = "Schattennova!",
	nova_bar = "~Schattennova",
} end )

L:RegisterTranslations("frFR", function() return {
	phase = "Engagement",
	phase_desc = "Préviens quand la rencontre entre dans une nouvelle phase.",
	phase1_trigger = "La folie vous a fait venir ici, devant moi. Et je serai votre perte !",
	phase2_trigger = "Imbéciles heureux ! Le temps est le brasier dans lequel vous brûlerez !",
	phase3_trigger = "Comment pouvez-vous espérer résister devant un tel pouvoir ?",
	phase1_message = "Phase 1 - Infernal dans ~40 sec. !",
	phase2_message = "60% - Phase 2",
	phase3_message = "30% - Phase 3 ",

	enfeeble = "Affaiblir",
	enfeeble_desc = "Affiche le temps de recharge de Affaiblir.",
	enfeeble_trigger = "subit les effets .* Affaiblir.$",
	enfeeble_message = "Affaiblir ! Prochain dans 30 sec.",
	enfeeble_warning1 = "Affaiblir dans 5 sec. !",
	enfeeble_warning2 = "Affaiblir dans 10 sec. !",
	enfeeble_bar = "Affaiblir",
	enfeeble_nextbar = "Prochain Affaiblir",
	--enfeeble_you = "You are afflicted by Enfeeble.",
	--enfeeble_warnyou = "Enfeeble on YOU!",

	infernals = "Infernaux",
	infernals_desc = "Affiche le temps de recharge des invocations d'infernaux.",
	infernal_trigger1 = "Vous n'affrontez pas seulement Malchezzar, mais aussi les légions que je commande !",
	infernal_trigger2 = "Toutes les réalités, toutes les dimensions me sont ouvertes !",
	infernal_bar = "Arrivée d'un infernal",
	infernal_warning = "Arrivée d'un infernal dans 20 sec. !",
	infernal_message = "Infernal ! Flammes infernales dans 5 sec. !",

	nova = "Nova de l'ombre",
	nova_desc = "Préviens quand Malchezaar est suceptible d'utiliser sa Nova de l'ombre.",
	nova_message = "Nova de l'ombre !",
	nova_bar = "~Cooldown Nova",
	nova_soon = "Nova de l'ombre imminente",

	despawn = "Désactiver les délais de disparition des infernaux",
	despawn_desc = "Délais pour la disparition des infernaux.",
	despawn_bar = "Disparition infernal (%d)",
} end )

L:RegisterTranslations("koKR", function() return {
	phase = "단계",
	phase_desc = "단계 변화 시 알립니다.",
	phase1_trigger = "여기까지 오다니 정신이 나간 놈들이 분명하구나. 소원이라면 파멸을 시켜주마!",
	phase2_trigger = "바보 같으니! 시간은 너의 몸을 태우는 불길이 되리라!",
	phase3_trigger = "어찌 감히 이렇게 압도적인 힘에 맞서기를 꿈꾸느냐?",
	phase1_message = "1 단계 - 약 40초 후 불지옥!",
	phase2_message = "60% - 2 단계",
	phase3_message = "30% - 3 단계",

	enfeeble = "쇠약",
	enfeeble_desc = "쇠약에 대한 재사용 대기시간을 표시합니다.",
	enfeeble_trigger = "쇠약에 걸렸습니다%.$",
	enfeeble_message = "쇠약! 다음은 30초 후",
	enfeeble_warning1 = "5초 후 쇠약!",
	enfeeble_warning2 = "10초 후 쇠약!",
	enfeeble_bar = "쇠약",
	enfeeble_nextbar = "다음 쇠약",
	--enfeeble_you = "You are afflicted by Enfeeble.",
	--enfeeble_warnyou = "Enfeeble on YOU!",

	infernals = "불지옥",
	infernals_desc = "불지옥 소환에 대한 재사용 대기시간을 표시합니다.",
	infernal_trigger1 = "이 말체자르님은 혼자가 아니시다. 너희는 나의 군대와 맞서야 한다!",
	infernal_trigger2 = "모든 차원과 실체가 나를 향해 열려 있노라!",
	infernal_bar = "불지옥 등장",
	infernal_warning = "20초 이내 불지옥 등장!",
	infernal_message = "불지옥 등장! 5초 이내 지옥불!",

	nova = "암흑 회오리",
	nova_desc = "암흑 회오리 예상 타이머입니다.",
	nova_message = "암흑 회오리!",
	nova_bar = "~회오리 대기시간",
	nova_soon = "잠시 후 암흑 회오리",

	despawn = "불지옥 사라짐 타이머 비활성화",
	despawn_desc = "불지옥 사라짐에 대한 타이머입니다.",
	despawn_bar = "지옥불 (%d) 사라짐",
} end )

L:RegisterTranslations("zhCN", function() return {
	phase = "阶段提示",
	phase_desc = "进入战斗及每阶段的提示",
	phase1_trigger = "疯狂将你们带到我的面前，而我将以死亡终结你们！",
	phase2_trigger = "愚蠢的家伙！时间就是吞噬你躯体的烈焰！",
	phase3_trigger = "你如何抵挡这无坚不摧的力量？",
	phase1_message = "第一阶段 - 地狱火将在~40秒后发动!",
	phase2_message = "60% - 第二阶段",
	phase3_message = "30% - 第三阶段",

	enfeeble = "能量衰弱警报",
	enfeeble_desc = "显示能量衰弱冷却计时条",
	enfeeble_trigger = "受到能量衰弱效果的影响。$",
	enfeeble_message = "能量衰弱! 30后再次发动！",
	enfeeble_warning1 = "能量衰弱！ 5秒后发动",
	enfeeble_warning2 = "能量衰弱！ 10秒后发动",
	enfeeble_bar = "能量衰弱",
	enfeeble_nextbar = "下次→能量衰弱",
	--enfeeble_you = "You are afflicted by Enfeeble.",
	--enfeeble_warnyou = "Enfeeble on YOU!",

	infernals = "地狱火警报",
	infernals_desc = "显示召唤地狱火冷却时间计时条",
	infernal_trigger1 = "你面对的不仅仅是我玛克扎尔自己，还有我所号令的军团！",
	infernal_trigger2 = "所有的世界都向我敞开大门！",
	infernal_bar = "即将 地狱火",
	infernal_warning = "地狱火在 20 秒后出现！",
	infernal_message = "地狱火 出现！! 5秒后发动 地狱烈焰！",

	nova = "暗影新星",
	nova_desc = "暗影新星预计冷却计时条",
	nova_message = "暗影新星！",
	nova_bar = "~暗影新星 冷却",
	nova_soon = "即将发动 暗影新星",

	despawn = "禁用地狱火重生",
	despawn_desc = "地狱火重生计时条",
	despawn_bar = "地狱火(%d) 重生！",
} end )


L:RegisterTranslations("zhTW", function() return {
	phase = "階段提示",
	phase_desc = "進入戰鬥及每一階段時發送警告",
	phase1_trigger = "瘋狂把你帶到我的面前。我會成為你失敗的原因!",
	phase2_trigger = "頭腦簡單的笨蛋!你在燃燒的是時間的火焰!",
	phase3_trigger = "你怎能期望抵抗這樣勢不可擋的力量?",
	phase1_message = "第一階段 - 地獄火將在 40 秒後召喚",
	phase2_message = "60% - 第二階段",
	phase3_message = "30% - 第三階段",

	enfeeble = "削弱警告",
	enfeeble_desc = "顯示削弱計時條",
	enfeeble_trigger = "^(.+)受(到[了]*)削弱效果的影響。",
	enfeeble_message = "30 秒後下一次削弱",
	enfeeble_warning1 = "5 秒後削弱",
	enfeeble_warning2 = "10 秒後削弱",
	enfeeble_bar = "削弱",
	enfeeble_nextbar = "削弱倒數",
	--enfeeble_you = "You are afflicted by Enfeeble.",
	--enfeeble_warnyou = "Enfeeble on YOU!",

	infernals = "地獄火警告",
	infernals_desc = "顯示召喚地獄火計時條",
	infernal_trigger1 = "你挑戰的不只是莫克札，而是我所率領的整個軍隊!",
	infernal_trigger2 = "所有的實體，所有的空間對我來說都是開放的!",
	infernal_bar = "地獄火",
	infernal_warning = "20 秒後召喚地獄火",
	infernal_message = "5 秒後召喚地獄火",

	nova = "暗影新星警告",
	nova_desc = "顯示暗影新星計時條",
	nova_message = "暗影新星",
	nova_bar = "暗影新星倒數",
	nova_soon = "即將施放暗影新星",

	despawn = "取消地獄火消失計時條",
	despawn_desc = "地獄火消失計時條",
	despawn_bar = "地獄火 (%d) 消失！",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
mod.enabletrigger = boss
mod.toggleoptions = {"phase", "enfeeble", "nova", -1, "infernals", "despawn", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_SPELLCAST_START")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "EnfeebleEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "EnfeebleEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "EnfeebleEvent")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MalchezaarEnfeeble", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "MalchezaarNova", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["infernal_trigger1"] or msg == L["infernal_trigger2"] then
		if self.db.profile.infernals then
			self:Message(L["infernal_warning"], "Positive")
			self:NextInfernal()
		end
		if not self.db.profile.despawn then
			self:ScheduleEvent("BWInfernalDespawn", self.DespawnTimer, 20, self)
		end
	elseif msg == L["phase1_trigger"] then
		nova = true
		count = 1

		if self.db.profile.phase then
			self:Message(L["phase1_message"], "Positive")
		end
		if self.db.profile.enfeeble then
			self:ScheduleEvent("enf1", "BigWigs_Message", 25, L["enfeeble_warning1"], "Attention")
			self:ScheduleEvent("enf2", "BigWigs_Message", 20, L["enfeeble_warning2"], "Attention")
			self:Bar(L["enfeeble_nextbar"], 30, "Spell_Shadow_LifeDrain02")
		end
	elseif self.db.profile.phase and msg == L["phase2_trigger"] then
		self:Message(L["phase2_message"], "Positive")
	elseif self.db.profile.phase and msg == L["phase3_trigger"] then
		self:Message(L["phase3_message"], "Positive")
		self:CancelScheduledEvent("enf1")
		self:CancelScheduledEvent("enf2")
		self:TriggerEvent("BigWigs_StopBar", self, L["enfeeble_bar"])
		self:TriggerEvent("BigWigs_StopBar", self, L["enfeeble_nextbar"])
		nova = nil
	end
end

function mod:NextInfernal()
	self:DelayedMessage(15, L["infernal_message"], "Urgent", nil, "Alert")
	self:Bar(L["infernal_bar"], 20, "INV_Stone_05")
end

function mod:DespawnTimer()
	self:Bar(L["despawn_bar"]:format(count), 180, "INV_SummerFest_Symbol_Medium")
	count = count + 1
end

function mod:EnfeebleEvent(msg)
	if msg == L["enfeeble_you"] then
		self:Message(L["enfeeble_warnyou"], "Personal", true)
	end
	if msg:find(L["enfeeble_trigger"]) then
		self:Sync("MalchezaarEnfeeble")
	end
end

function mod:UNIT_SPELLCAST_START(msg)
	if UnitName(msg) == boss and (UnitCastingInfo(msg)) == L["nova"] then
		self:Sync("MalchezaarNova")
	end
end

function mod:BigWigs_RecvSync(sync)
	if sync == "MalchezaarEnfeeble" then
		if self.db.profile.enfeeble then
			self:Message(L["enfeeble_message"], "Important", nil, "Alarm")
			self:ScheduleEvent("enf1", "BigWigs_Message", 25, L["enfeeble_warning1"], "Attention")
			self:ScheduleEvent("enf2", "BigWigs_Message", 20, L["enfeeble_warning2"], "Attention")
			self:Bar(L["enfeeble_bar"], 7, "Spell_Shadow_LifeDrain02")
			self:Bar(L["enfeeble_nextbar"], 30, "Spell_Shadow_LifeDrain02")
		end
		if self.db.profile.nova then
			self:Bar(L["nova_bar"], 5, "Spell_Shadow_Shadowfury")
		end
	elseif sync == "MalchezaarNova" and self.db.profile.nova then
		self:Message(L["nova_message"], "Attention", nil, "Info")
		self:Bar(L["nova_message"], 2, "Spell_Shadow_Shadowfury")
		if not nova then
			self:CancelScheduledEvent("nova1")
			self:Bar(L["nova_bar"], 20, "Spell_Shadow_Shadowfury")
			self:ScheduleEvent("nova1", "BigWigs_Message", 15, L["nova_soon"], "Positive")
		end
	end
end
