------------------------------
--      Are you local?    --
------------------------------

local boss = BB["Supremus"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local started = nil
local pName = UnitName("player")
local db = nil
local previous = nil
local UnitName = UnitName
local fmt = string.format

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Supremus",

	phase = "Phases",
	phase_desc = "Warn about the different phases.",
	normal_phase_message = "Tank'n'spank!",
	normal_phase_trigger = "Supremus punches the ground in anger!",
	kite_phase_message = "%s loose!",
	kite_phase_trigger = "The ground begins to crack open!",
	next_phase_bar = "Next phase",
	next_phase_message = "Phase change in 10sec!",

	punch = "Molten Punch",
	punch_desc = "Alert when he does Molten Punch, and display a countdown bar.",
	punch_message = "Molten Punch!",
	punch_bar = "~Possible Punch!",

	target = "Target",
	target_desc = "Warn who he targets during the kite phase, and put a raid icon on them.",
	target_message = "%s being chased!",
	target_you = "YOU are being chased!",
	target_message_nounit = "New target!",

	icon = "Raid Target Icon",
	icon_desc = "Place a Raid Target Icon on the player being chased(requires promoted or higher).",
} end )

L:RegisterTranslations("esES", function() return {
	phase = "Fases",
	phase_desc = "Avisar sobre cambios de fase.",
	normal_phase_message = "¡Fase de tanqueo!",
	normal_phase_trigger = "¡Supremus golpea el suelo enfadado!",
	kite_phase_message = "¡%s, escápate!",
	kite_phase_trigger = "El suelo comienza a abrirse.",
	next_phase_bar = "~Siguiente fase",
	next_phase_message = "Cambio de fase en 10 seg",

	punch = "Puñetazo de arrabio (Molten Punch)",
	punch_desc = "Avisar cuando lanza Puñetazo de arrabio y mostrar una barra de reutilización.",
	punch_message = "¡Puñetazo de arrabio!",
	punch_bar = "~Puñetazo de arrabio",

	target = "Objetivo",
	target_desc = "Avisar a quién selecciona durante la fase de persecución y poner un icono sobre su cabeza.",
	target_message = "¡Persiguiendo a %s!",
	target_you = "¡Te está persiguiendo a TI!",
	target_message_nounit = "¡Nuevo objetivo!",

	icon = "Icono de banda",
	icon_desc = "Poner un icono sobre el jugador que está siendo perseguido. (Requiere derechos de banda).",
} end )

L:RegisterTranslations("deDE", function() return {
	phase = "Phasen",
	phase_desc = "Warnung wenn Supremus zwischen Tank und Kitephase wechselt.",
	normal_phase_message = "Tank'n'spank!",
	normal_phase_trigger = "Supremus schlägt wütend auf den Boden!",
	kite_phase_message = "%s Kitephase!",
	kite_phase_trigger = "Der Boden beginnt aufzubrechen!",
	next_phase_bar = "Nächste Phase",
	next_phase_message = "Phasenwechsel in 10sek!",

	punch = "Glühender Hieb",
	punch_desc = "Warnt, wenn Supremus Glühender Hieb benutzt und zeigt einen Countdown an.",
	punch_message = "Glühender Hieb!",
	punch_bar = "~Möglicher Glühender Hieb!",

	target = "Verfolgtes Ziel",
	target_desc = "Warnt wer während der Kitephase verfolgt wird.",
	target_message = "%s wird verfolgt!",
	target_you = "DU wirst verfolgt!",
	target_message_nounit = "Neues Ziel!",

	icon = "Schlachtzug Symbol",
	icon_desc = "Plaziert ein Schlachtzug Symbol auf dem Spieler der verfolgt wird (benötigt Assistent oder höher).",
} end )

L:RegisterTranslations("koKR", function() return {
	phase = "단계",
	phase_desc = "다른 단계에 대한 경고입니다.",
	normal_phase_message = "탱킹'n'딜링!",
	normal_phase_trigger =  "궁극의 심연이 분노하여 땅을 내리찍습니다!",
	kite_phase_message = "%s 풀려남!",
	kite_phase_trigger = "땅이 갈라져서 열리기 시작합니다!",
	next_phase_bar = "다음 형상",
	next_phase_message = "10초 이내 형상 변경!",

	punch = "이글거리는 주먹",
	punch_desc = "이글거리는 주먹의 경고와 대기시간 바를 표시합니다.",
	punch_message = "이글거리는 주먹!",
	punch_bar = "~주먹 가능!",

	target = "대상",
	target_desc = "솔개 형상에서 대상을 알리고 전술 표시를 지정합니다.",
	target_message = "%s 추적 중!",
	target_you = "당신을 추적 중!",
	target_message_nounit = "새로운 대상!",

	icon = "전술 표시",
	icon_desc = "추적 중인 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 요구)",
} end )

L:RegisterTranslations("frFR", function() return {
	phase = "Phase",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",
	normal_phase_message = "Phase de tanking !",
	normal_phase_trigger = "De rage, Supremus frappe le sol !",
	kite_phase_message = "Phase de kitting !",
	kite_phase_trigger = "Le sol commence à se fissurer !",
	next_phase_bar = "Prochaine phase",
	next_phase_message = "Changement de phase dans 10 sec. !",

	punch = "Punch de la fournaise",
	punch_desc = "Prévient quand Supremus utilise son Punch de la fournaise, et affiche une barre de cooldown.",
	punch_message = "Punch de la fournaise !",
	punch_bar = "~Punch probable",

	target = "Cible",
	target_desc = "Indique la personne pourchassée pendant la phase de kitting.",
	target_message = "%s est poursuivi(e) !",
	target_you = "Vous êtes poursuivi(e) !",
	target_message_nounit = "Nouvelle cible !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur poursuivi (nécessite d'être promu ou mieux).",
} end )

L:RegisterTranslations("zhTW", function() return {
	phase = "階段",
	phase_desc = "提示階段",
	normal_phase_message = "坦&殺!",
	normal_phase_trigger = "瑟普莫斯憤怒的捶擊地面!",
	kite_phase_message = "%s 釋放!",
	kite_phase_trigger = "地上開始裂開!",
	next_phase_bar = "下一個階段",
	next_phase_message = "10 秒內改變階段!",

	punch = "熔火之擊",
	punch_desc = "警報在施放熔火之擊，顯示冷卻條",
	punch_message = "熔火之擊!",
	punch_bar = "<熔火之擊冷卻>",

	target = "目標",
	target_desc = "警報在風箏階段誰是主要目標，並在他頭上放團隊標記。 (需要權限)",
	target_message = "被盯上: [%s]",
	target_you = "被盯上: [你]",
	target_message_nounit = "新目標!",

	icon = "目標標記",
	icon_desc = "在被盯上的隊友頭上標記 (需要權限)",
} end )

L:RegisterTranslations("zhCN", function() return {
	phase = "阶段",
	phase_desc = "当不同阶段时发出警报。",
	normal_phase_message = "木桩战！",
	normal_phase_trigger = "苏普雷姆斯愤怒地击打着地面！",
	kite_phase_message = "%s 释放！",
	kite_phase_trigger = "地面崩裂了！",
	next_phase_bar = "<下一阶段>",
	next_phase_message = "10秒后，阶段改变！",

	punch = "熔岩打击",
	punch_desc = "当施放熔岩打击时发出警报并显示冷却记时条。",
	punch_message = "熔岩打击！",
	punch_bar = "<可能 熔岩打击>",

	target = "目标",
	target_desc = "当玩家被凝视时发出警报并被打上团队标记。",
	target_message = "凝视：>%s <！",
	target_you = ">你< 被凝视！",
	target_message_nounit = "新目标！",

	icon = "团队标记",
	icon_desc = "给被凝视的玩家打上团队标记。（需要权限）",
} end )

L:RegisterTranslations("ruRU", function() return {
	phase = "Phases",
	phase_desc = "Warn about the different phases.",
	normal_phase_message = "Tank'n'spank!",
	normal_phase_trigger = "Супремус в гневе ударяет по земле!",
	kite_phase_message = "%s loose!",
	kite_phase_trigger = "Земля начинает раскалываться!",
	next_phase_bar = "Next phase",
	next_phase_message = "Phase change in 10sec!",

	punch = "Molten Punch",
	punch_desc = "Alert when he does Molten Punch, and display a countdown bar.",
	punch_message = "Molten Punch!",
	punch_bar = "~Possible Punch!",

	target = "Target",
	target_desc = "Warn who he targets during the kite phase, and put a raid icon on them.",
	target_message = "%s being chased!",
	target_you = "YOU are being chased!",
	target_message_nounit = "New target!",

	icon = "Raid Target Icon",
	icon_desc = "Place a Raid Target Icon on the player being chased(requires promoted or higher).",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Black Temple"]
mod.enabletrigger = boss
mod.guid = 22898
mod.toggleoptions = {"punch", "target", "icon", "phase", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Punch", 40126)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	started = nil
	previous = nil

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("BigWigs_RecvSync")

	db = self.db.profile
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:Punch(_, spellID)
	if db.punch then
		self:IfMessage(L["punch_message"], "Attention", spellID)
		self:Bar(L["punch_bar"], 10, spellID)
	end
end

function mod:TargetCheck()
	local target
	if UnitName("target") == boss then
		target = UnitName("targettarget")
	elseif UnitName("focus") == boss then
		target = UnitName("focustarget")
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			if UnitName(fmt("%s%d%s", "raid", i, "target")) == boss then
				target = UnitName(fmt("%s%d%s", "raid", i, "targettarget"))
				break
			end
		end
	end
	if target ~= previous then
		if target then
			local other = fmt(L["target_message"], target)
			if target == pName then
				self:LocalMessage(L["target_you"], "Personal", nil, "Alarm")
				self:WideMessage(other)
			else
				self:Message(other, "Attention")
			end
			self:Icon(target, "icon")
			previous = target
		else
			previous = nil
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["normal_phase_trigger"] then
		if db.phase then
			self:Message(L["normal_phase_message"], "Positive")
			self:Bar(L["next_phase_bar"], 60, "INV_Helmet_08")
			self:DelayedMessage(50, L["next_phase_message"], "Attention")
		end
		if db.target then
			self:CancelScheduledEvent("BWSupremusToTScan")
			self:TriggerEvent("BigWigs_RemoveRaidIcon")
		end
	elseif msg == L["kite_phase_trigger"] then
		if db.phase then
			self:Message(fmt(L["kite_phase_message"], boss), "Positive")
			self:Bar(L["next_phase_bar"], 60, "Spell_Fire_MoltenBlood")
			self:DelayedMessage(50, L["next_phase_message"], "Attention")
		end
		if db.target then
			self:ScheduleRepeatingEvent("BWSupremusToTScan", self.TargetCheck, 1, self)
		end
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if db.phase then
			self:Bar(L["next_phase_bar"], 60, "Spell_Fire_MoltenBlood")
			self:DelayedMessage(50, L["next_phase_message"], "Attention")
		end
		if db.enrage then
			self:Enrage(900)
		end
	end
end

