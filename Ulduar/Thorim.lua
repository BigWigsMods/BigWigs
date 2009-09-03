----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Thorim"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
local CL = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Common")
local behemoth = BB["Jormungar Behemoth"]
mod.zonename = BZ["Ulduar"]
mod.guid = 32865	--Sif(33196)
mod.toggleOptions = {62042, 62331, 62017, 62338, 62526, "icon", 62279, 62130, "proximity", "hardmode", "phase", "berserk", "bosskill"}
mod.optionHeaders = {
	[62042] = CL.phase:format(2),
	[62279] = CL.phase:format(3),
	hardmode = CL.hard,
	phase = CL.general,
}
mod.proximityCheck = function(unit) return CheckInteractDistance(unit, 3) end
mod.proximitySilent = true
mod.consoleCmd = "Thorim"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local started = nil
local chargeCount = 1
local fmt = string.format
local pName = UnitName("player")

local hardModeMessageID = "" -- AceEvent flips out if not passed a string for :CancelScheduledEvent

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	["Runic Colossus"] = true, -- For the runic barrier emote.

	phase = "Phases",
	phase_desc = "Warn for phase changes.",
	phase1_message = "Entering Phase 1",
	phase2_trigger = "Interlopers! You mortals who dare to interfere with my sport will pay.... Wait--you...",
	phase2_message = "Phase 2 - Berserk in 5min!",
	phase3_trigger = "Impertinent whelps, you dare challenge me atop my pedestal? I will crush you myself!",
	phase3_message = "Phase 3 - %s engaged!",

	hardmode = "Hard mode timer",
	hardmode_desc = "Show timer for when you have to reach Thorim in order to enter hard mode in phase 3.",
	hardmode_warning = "Hard mode expires",

	shock_message = "You're getting shocked!",
	barrier_message = "Barrier up!",

	detonation_say = "I'm a bomb!",

	charge_message = "Charged x%d!",
	charge_bar = "Charge %d",

	strike_bar = "Unbalancing Strike CD",

	end_trigger = "Stay your arms! I yield!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player with Runic Detonation or Stormhammer. (requires promoted or higher)",
} end )

L:RegisterTranslations("koKR", function() return {
	phase = "단계",
	phase_desc = "단계 변화를 알립니다.",
	phase1_message = "1 단계 시작",
	phase2_trigger = "침입자라니! 감히 내 취미 생활을 방해하는 놈들은 쓴맛을 단단히... 잠깐... 너는...",
	--phase2_message = "2 단계 - 6분 15초 후 광폭화!",
	phase3_trigger = "건방진 젖먹이 같으니... 감히 여기까지 기어올라와 내게 도전해? 내 손으로 쓸어버리겠다!",
	phase3_message = "3 단계 - %s 전투시작!",

	hardmode = "도전 모드 시간",
	hardmode_desc = "도전 모드의 시간을 표시합니다.",
	hardmode_warning = "도전 모드 종료",

	shock_message = "당신은 번개 충격! 이동!",
	barrier_message = "거인 - 룬문자 방벽!",

	detonation_say = "저 푹탄이에요! 피하세요!",

	charge_message = "충전 (%d)!",
	charge_bar = "충전 (%d)",

	strike_bar = "혼란의 일격 대기시간",

	end_trigger = "무기를 거둬라! 내가 졌다!",

	icon = "전술 표시",
	icon_desc = "룬 폭발 또는 폭풍망치에 걸린 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("frFR", function() return {
	["Runic Colossus"] = "Colosse runique", -- For the runic barrier emote.

	phase = "Phases",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",
	phase1_message = "Début de la phase 1",
	phase2_trigger = "Des intrus ! Mortels, vous qui osez me déranger en plein divertissement allez pay -  Attendez, vous -",
	phase2_message = "Phase 2 - Berserk dans 5 min. !",
	phase3_trigger = "Avortons impertinents, vous osez me défier sur mon piédestal ? Je vais vous écraser moi-même !",
	phase3_message = "Phase 3 - %s engagé !",

	hardmode = "Délai du mode difficile",
	hardmode_desc = "Affiche une barre de 3 minutes pour le mode difficile (délai avant que Sif ne disparaisse).",
	hardmode_warning = "Délai du mode difficile dépassé",

	shock_message = "Horion de foudre sur VOUS !",
	barrier_message = "Barrière runique actif !",

	detonation_say = "Je suis une bombe !",

	charge_message = "Charge de foudre x%d !",
	charge_bar = "Charge %d",

	strike_bar = "Recharge Frappe",

	end_trigger = "Retenez vos coups ! Je me rends !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par une Détonation runique (nécessite d'être assistant ou mieux).",
} end )

L:RegisterTranslations("deDE", function() return {
	phase = "Phasen",
	phase_desc = "Warnt bei Phasenwechsel.",
	phase1_message = "Phase 1",
	phase2_trigger = " Eindringlinge! Ihr Sterblichen, die Ihr es wagt, Euch in mein Vergnügen einzumischen, werdet... Wartet... Ihr...", -- space in the beginning!
	phase2_message = "Phase 2 - Berserker in 5 min!",
	phase3_trigger = "Ihr unverschämtes Geschmeiß! Ihr wagt es, mich in meinem Refugium herauszufordern? Ich werde Euch eigenhändig zerschmettern!",
	phase3_message = "Phase 3 - %s angegriffen!",

	hardmode = "Hard Mode",
	hardmode_desc = "Timer für den Hard Mode.",
	hardmode_warning = "Hard Mode beendet!",

	shock_message = "DU wirst geschockt!",
	barrier_message = "Runenbarriere oben!",

	detonation_say = "Ich bin die Bombe!",

	charge_message = "Blitzladung x%d!",
	charge_bar = "Blitzladung %d",

	strike_bar = "~Schlag",

	end_trigger = "Senkt Eure Waffen! Ich ergebe mich!",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, die von Runendetonation und Sturmhammer betroffen sind (benötigt Assistent oder höher).",
} end )

L:RegisterTranslations("zhCN", function() return {
	phase = "阶段",
	phase_desc = "当进入不同阶段发出警报。",
	phase1_message = "第一阶段！",
--	phase2_trigger = "Interlopers! You mortals who dare to interfere with my sport will pay.... Wait--you...",
	phase2_message = "第二阶段 - 5分钟后，狂暴！",
--	phase3_trigger = "Impertinent whelps, you dare challenge me atop my pedestal? I will crush you myself!",
	phase3_message = "第三阶段 - %s已激怒！",

	hardmode = "困难模式",
	hardmode_desc = "显示困难模式计时器。",
	hardmode_warning = "困难模式结束！",

	shock_message = ">你< 闪电震击！移动！",
	barrier_message = "符文巨像 - 符文屏障！",

	detonation_say = "我是炸弹！",

	charge_message = "闪电充能：>%d<！",
	charge_bar = "<闪电充能：%d>",

	strike_bar = "<重压打击 冷却>",

--	end_trigger = "Stay your arms! I yield!",

	icon = "团队标记",
	icon_desc = "为中了符文爆炸的队员打上团队标记。（需要权限）",
} end )

L:RegisterTranslations("zhTW", function() return {
	phase = "階段",
	phase_desc = "當進入不同階段發出警報。",
	phase1_message = "第一階段！",
	phase2_trigger = "擅闖者!像你們這種膽敢干涉我好事的凡人將付出…等等--你……",
	phase2_message = "第二階段 - 5分鐘後，狂暴！",
	phase3_trigger = "無禮的小輩，你竟敢在我的王座之上挑戰我?我會親手碾碎你們!",
	phase3_message = "第三階段 - %s已狂怒！",

	hardmode = "困難模式",
	hardmode_desc = "顯示困難模式計時器。",
	hardmode_warning = "困難模式結束！",

	shock_message = ">你< 閃電震擊！移動！",
	barrier_message = "符文巨像 - 符刻屏障！",

	detonation_say = "我是炸彈！",

	charge_message = "閃電能量：>%d<！",
	charge_bar = "<閃電能量：%d>",

	strike_bar = "<失衡打擊 冷卻>",

	end_trigger = "住手!我認輸了!",

	icon = "團隊標記",
	icon_desc = "為中了引爆符文的隊員打上團隊標記。（需要權限）",
} end )

L:RegisterTranslations("ruRU", function() return {
	phase = "Фазы",
	phase_desc = "Сообщать о смене фаз.",
	phase1_message = "Начало 1-ой фазы",
	phase2_trigger = "Незваные гости! Вы заплатите за то, что посмели вмешаться... Погодите, вы...",
	--phase2_message = "2ая фаза - Исступление через 6мин 15сек!",
	phase3_trigger = "Бесстыжие выскочки, вы решили бросить вызов мне лично? Я сокрушу вас всех!",
	phase3_message = "3-яя фаза - %s вступает в бой!",

	hardmode = "Таймеры сложного режима",
	hardmode_desc = "Отображения таймера для сложного режима.",
	hardmode_warning = "Завершение сложного режима",

	shock_message = "На вас Поражение громом! Шевелитесь!",
	barrier_message = "Колосс под Рунической преградой!",

	detonation_say = "Я БОМБА!",

	charge_message = "Разряд: x%d",
	charge_bar = "Разряд %d",

	end_trigger = "Придержите мечи! Я сдаюсь.",

	icon = "Помечать иконкой",
	icon_desc = "Помечать рейдовой иконкой игрока, который попал под воздействие Взрыва рун. (необходимо быть лидером группы или рейда)",
} end )

mod.enabletrigger = {behemoth, boss, L["Runic Colossus"]}

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Hammer", 62042)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Charge", 62279)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "StrikeCooldown", 62130)
	self:AddCombatListener("SPELL_MISSED", "StrikeCooldown", 62130)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Strike", 62130)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Detonation", 62526)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Orb", 62016)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Impale", 62331, 62418)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Barrier", 62338)
	self:AddCombatListener("SPELL_DAMAGE", "Shock", 62017)
	self:AddCombatListener("SPELL_MISSED", "Shock", 62017)
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
	db = self.db.profile
	started = nil
end

function mod:VerifyEnable(unit)
	return (UnitIsEnemy(unit, "player") and UnitCanAttack(unit, "player")) and true or false
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Barrier(_, spellId, _, _, spellName)
	self:IfMessage(L["barrier_message"], "Urgent", spellId, "Alarm")
	self:Bar(spellName, 20, spellId)
end

function mod:Charge(_, spellId)
	self:IfMessage(L["charge_message"]:format(chargeCount), "Attention", spellId)
	chargeCount = chargeCount + 1
	self:Bar(L["charge_bar"]:format(chargeCount), 15, spellId)
end

function mod:Hammer(player, spellId, _, _, spellName)
	self:TargetMessage(spellName, player, "Urgent", spellId)
	self:Bar(spellName, 16, spellId)
	self:Icon(player, "icon")
end

function mod:Strike(player, spellId, _, _, spellName)
	self:TargetMessage(spellName, player, "Attention", spellId)
	self:Bar(spellName..": "..player, 15, spellId)
end

function mod:StrikeCooldown(player, spellId)
	self:Bar(L["strike_bar"], 25, spellId)
end

function mod:Orb(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Urgent", spellId)
	self:Bar(spellName, 15, spellId)
end

local last = 0
function mod:Shock(player, spellId)
	local time = GetTime()
	if (time - last) > 5 then
		last = time
		if player == pName then
			self:LocalMessage(L["shock_message"], "Personal", spellId, "Info")
		end
	end
end

function mod:Impale(player, spellId, _, _, spellName)
	self:TargetMessage(spellName, player, "Important", spellId)
end

function mod:Detonation(player, spellId, _, _, spellName)
	if player == pName then
		SendChatMessage(L["detonation_say"], "SAY")
	else
		self:TargetMessage(spellName, player, "Important", spellId)
	end
	self:Bar(spellName..": "..player, 4, spellId)
	self:Icon(player, "icon")
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["phase2_trigger"] then
		if db.phase then
			self:IfMessage(L["phase2_message"], "Attention")
		end
		if db.berserk then
			self:Bar(CL["berserk"], 375, 20484)
		end
		if db.hardmode then
			self:Bar(L["hardmode"], 173, "Ability_Warrior_Innerrage")
			hardModeMessageID = self:DelayedMessage(173, L["hardmode_warning"], "Attention")
		end
	elseif msg == L["phase3_trigger"] then
		self:CancelScheduledEvent(hardModeMessageID)
		self:TriggerEvent("BigWigs_StopBar", L["hardmode"])
		self:TriggerEvent("BigWigs_StopBar", CL["berserk"])
		if db.phase then
			self:IfMessage(L["phase3_message"]:format(boss), "Attention")
		end
		if db.berserk then
			self:Enrage(300, true, true)
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
	elseif msg == L["end_trigger"] then
		self:BossDeath(nil, self.guid)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		chargeCount = 1
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if db.phase then
			self:IfMessage(L["phase1_message"], "Attention")
		end
		self:TriggerEvent("BigWigs_HideProximity", self)
	end
end

