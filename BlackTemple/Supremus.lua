------------------------------
--      Are you local?    --
------------------------------

local boss = BB["Supremus"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local started = nil
local pName = nil
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
	punch_trigger = "Supremus casts Molten Punch.",

	target = "Target",
	target_desc = "Warn who he targets during the kite phase, and put a raid icon on them.",
	target_message = "%s being chased!",
	target_you = "YOU are being chased!",
	target_message_nounit = "New target!",

	icon = "Raid Target Icon",
	icon_desc = "Place a Raid Target Icon on the player being chased(requires promoted or higher).",
} end )

L:RegisterTranslations("deDE", function() return {
	phase = "Phasen",
	phase_desc = "Warnung wenn Supremus zwischen Tank und Kitephase wechselt.",
	normal_phase_message = "Tank'n'spank!",
	normal_phase_trigger = "Supremus schlägt wütend auf den Boden!",
	kite_phase_message = "%s Kitephase!",
	kite_phase_trigger = "Der Boden beginnt aufzubrechen!",
	next_phase_bar = "Nächste Phase",
	next_phase_message = "Phasenwechsel in 10sec!",

	punch = "Glühender Hieb",
	punch_desc = "Warnt, wenn Supremus Glühender Hieb benutzt und zeigt einen Countdown an.",
	punch_message = "Glühender Hieb!",
	punch_bar = "~Möglicher Hieb!",
	punch_trigger = "Supremus wirkt Glühender Hieb.",

	target = "Verfolgtes Ziel",
	target_desc = "Warnt wer wärend der Kitephase verfolgt wird.",
	target_message = "%s wird verfolgt!",
	target_you = "DU wirst verfolgt!",
	target_message_nounit = "Neues Ziel!",

	icon = "Schlachtzug Symbol",
	icon_desc = "Plaziert ein Schlachtzug Symbol auf dem Spieler der verfolgt wird (benötigt Assistent oder höher).",
} end )

L:RegisterTranslations("koKR", function() return {
	phase = "형상",
	phase_desc = "다른 형상에 대한 경고입니다.",
	normal_phase_message = "탱킹'n'딜링!",
	normal_phase_trigger =  "궁극의 심연이 분노하여 땅을 내리찍습니다!",
	kite_phase_message = "%s 풀려남!",
	kite_phase_trigger = "땅이 갈라져서 열리기 시작합니다!",
	next_phase_bar = "다음 형상",
	next_phase_message = "10초 이내 형상 변경!",

	punch = "화산 폭발",
	punch_desc = "화산 폭발 시 경고와 쿨다운 타이머바를 표시합니다.",
	punch_message = "화산 폭발!",
	punch_bar = "~폭발 가능!",
	punch_trigger = "궁극의 심연|1이;가; 화산 폭발|1을;를; 시전합니다.",

	target = "대상",
	target_desc = "솔개 형상에서 대상을 알리고 전술 표시를 지정합니다.",
	target_message = "%s 추적 중!",
	target_you = "당신은 추적 중!",
	target_message_nounit = "새로운 대상!",

	icon = "전술 표시",
	icon_desc = "추적 중인 플레이어에 전술 표시를 지정합니다 (승급자 이상 권한 요구).",
} end )

L:RegisterTranslations("frFR", function() return {
	phase = "Phase",
	phase_desc = "Préviens quand la rencontre entre dans une nouvelle phase.",
	normal_phase_message = "Phase de tanking !",
	normal_phase_trigger = "De rage, Supremus frappe le sol !",
	kite_phase_message = "Phase de kitting !",
	kite_phase_trigger = "Le sol commence à se fissurer !",
	next_phase_bar = "Prochaine phase",
	next_phase_message = "Changement de phase dans 10 sec. !",

	punch = "Punch de la fournaise",
	punch_desc = "Préviens quand Supremus utilise son Punch de la fournaise, et affiche une barre de cooldown.",
	punch_message = "Punch de la fournaise !",
	punch_bar = "~Punch probable",
	punch_trigger = "Supremus lance Punch de la fournaise.",

	target = "Cible",
	target_desc = "Indique la personne pourchassée pendant la phase de kitting.",
	target_message = "%s est poursuivi(e) !",
	target_you = "Vous êtes poursuivi(e) !",
	target_message_nounit = "Nouvelle cible !",

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
	punch_bar = "~可能施放熔火之擊!",
	punch_trigger = "瑟普莫斯施放了熔火之擊。",

	target = "目標",
	target_desc = "警報在風箏階段誰是主要目標，並在他頭上放團隊標記。",
	target_message = "被盯上：[%s]",
	target_you = "被盯上：[你]",
	target_message_nounit = "新目標!",

	icon = "目標標記",
	icon_desc = "在被盯上的隊友頭上標記 (需要權限)",
} end )

L:RegisterTranslations("zhCN", function() return {
	phase = "阶段",
	phase_desc = "不同阶段警报。",
	normal_phase_message = "木桩战！",
	normal_phase_trigger = "苏普雷姆斯愤怒地击打着地面！",
	kite_phase_message = "%s 释放！",
	kite_phase_trigger = "地面崩裂了！",
	next_phase_bar = "<下一阶段>",
	next_phase_message = "10秒后 阶段改变！",

	punch = "熔岩打击",
	punch_desc = "当施放熔岩打击时发出警报并显示冷却记时条。",
	punch_message = "熔岩打击！",
	punch_bar = "<可能 熔岩打击>",
	punch_trigger = "苏普雷姆斯施放了熔岩打击。",

	target = "目标",
	target_desc = "当谁能被凝视发出警报并被打上团队标记。",
	target_message = "凝视：>%s <！",
	target_you = ">你< 被凝视！",
	target_message_nounit = "新目标！",

	icon = "团队标记",
	icon_desc = "给被凝视的玩家打上团队标记。(需要权限)",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = { "punch", "target", "icon", "phase", "enrage", "bosskill" }
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	started = nil
	previous = nil

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "SupPunch", 5)

	db = self.db.profile
	pName = UnitName("player")
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["punch_trigger"] then
		self:Sync("SupPunch")
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
				self:Message(L["target_you"], "Personal", true, "Alarm")
				self:Message(other, "Attention", nil, nil, true)
			else
				self:Message(other, "Attention")
			end
			if db.icon then
				self:Icon(target)
			end
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
	if sync == "SupPunch" then
		if not db.punch then return end
		self:Message(L["punch_message"], "Attention")
		self:Bar(L["punch_bar"], 10, "Spell_Frost_FreezingBreath")
	elseif self:ValidateEngageSync(sync, rest) and not started then
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

