----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Thorim"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
local behemoth = BB["Jormungar Behemoth"]
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = {behemoth, boss}
mod.guid = 32865	--Sif(33196)
mod.toggleoptions = {"phase", "p2berserk", "hardmode", -1, "hammer", "impale", "shock", "barrier", "detonation", "charge", "strike", -1, "icon", "proximity", "bosskill"}
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

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	phase = "Phases",
	phase_desc = "Warn for phase changes.",
	phase1_message = "Entering Phase 1",
	phase2_trigger = "Interlopers! You mortals who dare to interfere with my sport will pay.... Wait--you...",
	phase2_message = "Phase 2 - Berserk in 6min 15sec!",
	phase3_trigger = "Impertinent whelps, you dare challenge me atop my pedestal? I will crush you myself!",
	phase3_message = "Phase 3 - %s Engaged!",

	p2berserk = "Phase 2 - Berserk",
	p2berserk_desc = "Warn when the boss goes Berserk in Phase 2.",

	hardmode = "Hard Mode Timer",
	hardmode_desc = "Show Timer for Hard Mode.",
	hardmode_warning = "Hard Mode Expires",

	hammer = "Stormhammer",
	hammer_desc = "Warns for Stormhammer.",
	hammer_message = "Hammer on %s",
	hammer_bar = "Stormhammer",

	impale = "Impale",
	impale_desc = "Warn who is afflicted by Impale.",
	impale_message = "Impale on %s",

	shock = "Lightning Shock",
	shock_desc = "Warn for Charge Orb and Lightning Shock.",
	shock_message = "You're getting shocked!",
	shock_warning = "Charge Orb!",
	shock_bar = "Charge Orb",

	barrier = "Runic Barrier",
	barrier_desc = "Warn when Runic Colossus gains Runic Barrier.",
	barrier_message = "Barrier up!",

	detonation = "Rune Detonation",
	detonation_desc = "Tells you who has been hit by Rune Detonation.",
	detonation_message = "Bomb on %s!",
	detonation_yell = "I'm a bomb!",

	charge = "Lightning Charge",
	charge_desc = "Count and warn for Thorim's Lightning Charge.",
	charge_message = "Charged x%d!",
	charge_bar = "Charge %d",

	strike = "Unbalancing Strike",
	strike_desc = "Warn when a player has Unbalancing Strike.",
	strike_message= "Unbalancing Strike: %s",
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
	phase2_message = "2 단계 - 6분 15초 후 광폭화!",
	phase3_trigger = "건방진 젖먹이 같으니... 감히 여기까지 기어올라와 내게 도전해? 내 손으로 쓸어버리겠다!",
	phase3_message = "3 단계 - %s 전투시작!",

	p2berserk = "2 단계 - 광폭화",
	p2berserk_desc = "1 단계의 보스 광폭화를 알립니다.",

	hardmode = "도전 모드 시간",
	hardmode_desc = "도전 모드의 시간을 표시합니다.",
	hardmode_warning = "도전 모드 종료",

	hammer = "폭풍망치",
	hammer_desc = "폭풍망치를 알립니다.",
	hammer_message = "폭풍망치: %s",
	hammer_bar = "다음 폭풍망치",

	impale = "꿰뚫기",
	impale_desc = "꿰뚫기에 걸린 플레이어를 알립니다.",
	impale_message = "꿰뚫기: %s",

	shock = "번개 충격",
	shock_desc = "번개구 충전과 번개 충격을 알립니다.",
	shock_message = "당신은 번개 충격! 이동!",
	shock_warning = "번개구 충전!",
	shock_bar = "번개구 충전",

	barrier = "룬문자 방벽",
	barrier_desc = "룬문자 거인의 룬문자 방벽 획득을 알립니다.",
	barrier_message = "거인 - 룬문자 방벽!",

	detonation = "룬 폭발",
	detonation_desc = "룬 폭발에 걸린 플레이어를 알립니다.",
	detonation_message = "룬 폭발: %s",
	detonation_yell = "저 푹탄이에요! 피하세요!",

	charge = "번개 충전",
	charge_desc = "토림의 번개 충전과 횟수를 알립니다.",
	charge_message = "충전 (%d)!",
	charge_bar = "충전 (%d)",

	strike = "혼란의 일격",
	strike_desc = "혼란의 일격에 걸린 플레이어를 알립니다.",
	strike_message= "혼란의 일격: %s",
	strike_bar = "혼란의 일격 대기시간",

	end_trigger = "무기를 거둬라! 내가 졌다!",

	icon = "전술 표시",
	icon_desc = "룬 폭발 또는 폭풍망치에 걸린 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("frFR", function() return {
	phase = "Phases",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",
	phase1_message = "Début de la phase 1",
	phase2_trigger = "Des intrus ! Mortels, vous qui osez me déranger en plein divertissement allez pay -  Attendez, vous -",
	phase2_message = "Phase 2 - Berserk dans 6 min. 15 sec. !",
	phase3_trigger = "Avortons impertinents, vous osez me défier sur mon piédestal ? Je vais vous écraser moi-même !",
	phase3_message = "Phase 3 - %s engagé !",

	p2berserk = "Phase 2 - Berserk",
	p2berserk_desc = "Prévient quand le boss devient fou furieux en phase 2.",

	hardmode = "Délai du mode difficile",
	hardmode_desc = "Affiche une barre de 3 minutes pour le mode difficile (délai avant que Sif ne disparaisse).",
	hardmode_warning = "Délai du mode difficile dépassé",

	hammer = "Marteau-tempête",
	hammer_desc = "Affiche une barre indiquant le prochain Marteau-tempête.",
	hammer_message = "Marteau-tempête : %s",
	hammer_bar = "Marteau-tempête",

	impale = "Empaler",
	impale_desc = "Prévient quand un joueur subit les effets d'un Empaler.",
	impale_message = "Empaler : %s",

	shock = "Horion de foudre",
	shock_desc = "Prévient de l'arrivée des Horions de foudre et des Charger l'orbe.",
	shock_message = "Horion de foudre sur VOUS !",
	shock_warning = "Charger l'orbe !",
	shock_bar = "Charger l'orbe",

	barrier = "Barrière runique",
	barrier_desc = "Prévient quand le Colosse runique gagne une Barrière runique.",
	barrier_message = "Barrière runique actif !",

	detonation = "Détonation runique",
	detonation_desc = "Prévient quand un joueur subit les effets d'une Détonation runique.",
	detonation_message = "Détonation : %s",
	detonation_yell = "Je suis une bombe !",

	charge = "Charge de foudre",
	charge_desc = "Compte et prévient de l'arrivée des Charges de foudre de Thorim.",
	charge_message = "Charge de foudre x%d !",
	charge_bar = "Charge %d",

	strike = "Frappe déséquilibrante",
	strike_desc = "Prévient quand un joueur subit les effets d'une Frappe déséquilibrante.",
	strike_message = "Frappe : %s",
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
	phase2_message = "Phase 2 - Berserker in ~6 min!",
	phase3_trigger = "Ihr unverschämtes Geschmeiß! Ihr wagt es, mich in meinem Refugium herauszufordern? Ich werde Euch eigenhändig zerschmettern!",
	phase3_message = "Phase 3 - %s angegriffen!",

	p2berserk = "Phase 2 - Berserker",
	p2berserk_desc = "Warnt, wenn der Boss in Phase 2 zum Berserker wird.",

	hardmode = "Hard Mode",
	hardmode_desc = "Timer für den Hard Mode.",
	hardmode_warning = "Hard Mode beendet!",

	hammer = "Sturmhammer",
	hammer_desc = "Warnung und Timer für Sturmhammer.",
	hammer_message = "Sturmhammer: %s!",
	hammer_bar = "Sturmhammer",

	impale = "Durchbohren",
	impale_desc = "Warnt, wer von Durchbohren betroffen ist.",
	impale_message = "Durchbohren: %s!",

	shock = "Blitzschock",
	shock_desc = "Warnung und Timer für Kugel aufladen and Blitzschock.",
	shock_message = "DU wirst geschockt!",
	shock_warning = "Kugel aufladen!",
	shock_bar = "Kugel aufladen",

	barrier = "Runenbarriere",
	barrier_desc = "Warnt, wenn der Runenverzierter Koloss von Runenbarriere betroffen ist.",
	barrier_message = "Runenbarriere oben!",

	detonation = "Runendetonation",
	detonation_desc = "Warnt, wer von Runendetonation betroffen ist.",
	detonation_message = "Bombe: %s!",
	detonation_yell = "Ich bin die Bombe!",

	charge = "Blitzladung",
	charge_desc = "Warnung und Zähler für Thorims Blitzladung.",
	charge_message = "Blitzladung x%d!",
	charge_bar = "Blitzladung %d",

	strike = "Schlag des Ungleichgewichts",
	strike_desc = "Warnt, wenn ein Spieler von Schlag des Ungleichgewichts betroffen ist.",
	strike_message= "Schlag: %s!",
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
	phase2_message = "第二阶段 - 6分15秒后，狂暴！",
--	phase3_trigger = "Impertinent whelps, you dare challenge me atop my pedestal? I will crush you myself!",
	phase3_message = "第三阶段 - %s已激怒！",

	p2berserk = "第二阶段 - 狂暴",
	p2berserk_desc = "当首领在第二阶段狂暴时发出警报。",

	hardmode = "困难模式计时器",
	hardmode_desc = "显示困难模式计时器。",
	hardmode_warning = "困难模式结束！",

	hammer = "风暴之锤",
	hammer_desc = "当风暴之锤时发出警报。",
	hammer_message = "风暴之锤：>%s<！",
	hammer_bar = "<风暴之锤>",

	impale = "穿刺",
	impale_desc = "当玩家中了穿刺时发出警报。",
	impale_message = "穿刺：>%s<！",

	shock = "闪电震击",
	shock_desc = "当宝珠充电和闪电震击时发出警报。",
	shock_message = ">你< 闪电震击！移动！",
	shock_warning = "宝珠充电！",
	shock_bar = "<下一宝珠充电>",

	barrier = "符文屏障",
	barrier_desc = "当符文巨像获得符文屏障时发出警报。",
	barrier_message = "符文巨像 - 符文屏障！",

	detonation = "符文爆裂",
	detonation_desc = "当玩家中了符文爆裂时发出警报。",
	detonation_message = "符文爆裂：>%s<！",
	detonation_yell = "我是炸弹！",

	charge = "闪电充能",
	charge_desc = "当托里姆施放闪电充能时记数警报。",
	charge_message = "闪电充能：>%d<！",
	charge_bar = "<闪电充能：%d>",

	strike = "重压打击",
	strike_desc = "当玩家中了重压打击时发出警报。",
	strike_message= "重压打击：>%s<！",
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
	phase2_message = "第二階段 - 6分15秒後，狂暴！",
	phase3_trigger = "無禮的小輩，你竟敢在我的王座之上挑戰我?我會親手碾碎你們!",
	phase3_message = "第三階段 - %s已狂怒！",

	p2berserk = "第二階段 - 狂暴",
	p2berserk_desc = "當首領在第二階段狂暴時發出警報。",

	hardmode = "困難模式計時器",
	hardmode_desc = "顯示困難模式計時器。",
	hardmode_warning = "困難模式結束！",

	hammer = "風暴之錘",
	hammer_desc = "當風暴之錘時發出警報。",
	hammer_message = "風暴之錘：>%s<！",
	hammer_bar = "<風暴之錘>",

	impale = "刺穿",
	impale_desc = "當玩家中了刺穿時發出警報。",
	impale_message = "刺穿：>%s<！",

	shock = "閃電震擊",
	shock_desc = "當寶珠充能和閃電震擊時發出警報。",
	shock_message = ">你< 閃電震擊！移動！",
	shock_warning = "寶珠充能！",
	shock_bar = "<下一寶珠充能>",

	barrier = "符刻屏障",
	barrier_desc = "當符刻巨像獲得符刻屏障時發出警報。",
	barrier_message = "符文巨像 - 符刻屏障！",

	detonation = "引爆符文",
	detonation_desc = "當玩家中了引爆符文時發出警報。",
	detonation_message = "引爆符文：>%s<！",
	detonation_yell = "我是炸彈！",

	charge = "閃電能量",
	charge_desc = "當索林姆施放閃電能量時記數警報。",
	charge_message = "閃電能量：>%d<！",
	charge_bar = "<閃電能量：%d>",

	strike = "失衡打擊",
	strike_desc = "當玩家中了失衡打擊時發出警報。",
	strike_message= "失衡打擊：>%s<！",
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
	phase2_message = "2ая фаза - Исступление через 6мин 15сек!",
	phase3_trigger = "Бесстыжие выскочки, вы решили бросить вызов мне лично? Я сокрушу вас всех!",
	phase3_message = "3-яя фаза - %s вступает в бой!",

	p2berserk = "2ая фаза - Исступление",
	p2berserk_desc = "Сообщает когда босс входит в Исступление на 2ой фазе.",

	hardmode = "Таймеры сложного режима",
	hardmode_desc = "Отображения таймера для сложного режима.",
	hardmode_warning = "Завершение сложного режима",

	hammer = "Молот бури",
	hammer_desc = "Сообщает о применении Молота бури.",
	hammer_message = "Молот брошен в |3-3(%s)",
	hammer_bar = "Следующий Молот",

	impale = "Прокалывание",
	impale_desc = "Сообщает кто поражен Прокалыванием.",
	impale_message = "%s проколот! Лечите!", 

	shock = "Поражение громом",
	shock_desc = "Сообщать о Заряженных сферах и Поражении громом.",
	shock_message = "На вас Поражение громом! Шевелитесь!",
	shock_warning = "Заряженная сфера!",
	shock_bar = "Следующая сфера",

	barrier = "Руническая преграда",
	barrier_desc = "Сообщать когда Рунический колосс подвергается воздействию Рунической преграды.",
	barrier_message = "Колосс под Рунической преградой!",

	detonation = "Взрыв руны",
	detonation_desc = "Сообщает кто попал под воздействие Взрыва рун.",
	detonation_message = "Бомба у: |3-1(%s)",
	detonation_yell = "Я БОМБА!",

	charge = "Разряд молнии",
	charge_desc = "Подсчитывать и сообщать о разрядах молнии Торима.",
	charge_message = "Разряд: x%d",
	charge_bar = "Разряд %d",

	strike = "Дисбалансирующий удар",
	strike_desc = "Сообщает когда игрок получает Дисбалансирующий удар.",
	strike_message= "Удар по: |3-2(%s)",

	end_trigger = "Придержите мечи! Я сдаюсь.",

	icon = "Помечать иконкой",
	icon_desc = "Помечать рейдовой иконкой игрока, который попал под воздействие Взрыва рун. (необходимо быть лидером группы или рейда)",
} end )

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

function mod:Barrier(_, spellId)
	if db.barrier then
		self:IfMessage(L["barrier_message"], "Urgent", spellId, "Alarm")
		self:Bar(L["barrier"], 20, spellId)
	end
end

function mod:Charge(_, spellId)
	if db.charge then
		self:IfMessage(L["charge_message"]:format(chargeCount), "Attention", spellId)
		chargeCount = chargeCount + 1
		self:Bar(L["charge_bar"]:format(chargeCount), 15, spellId)
	end
end

function mod:Hammer(player, spellId)
	if db.hammer then
		self:TargetMessage(L["hammer_message"], player, "Urgent", spellId)
		self:Bar(L["hammer_bar"], 16, spellId)
		self:Icon(player, "icon")
	end
end

function mod:Strike(player, spellId)
	if db.strike then
		self:TargetMessage(L["strike_message"], player, "Attention", spellId)
		self:Bar(L["strike_message"]:format(player), 15, spellId)
	end
end

function mod:StrikeCooldown(player, spellId)
	if db.strike then
		self:Bar(L["strike_bar"], 25, spellId)
	end
end

function mod:Orb(_, spellId)
	if db.shock then
		self:IfMessage(L["shock_warning"], "Urgent", spellId)
		self:Bar(L["shock_bar"], 15, spellId)
	end
end

local last = 0
function mod:Shock(player, spellId)
	local time = GetTime()
	if (time - last) > 5 then
		last = time
		if player == pName and db.shock then
			self:LocalMessage(L["shock_message"], "Personal", spellId, "Info")
		end
	end
end

function mod:Impale(player, spellId)
	if db.impale then
		self:TargetMessage(L["impale_message"], player, "Important", spellId)
	end
end

function mod:Detonation(player, spellId)
	if db.detonation then
		if player == pName then
			self:WideMessage(L["detonation_message"]:format(player))
			SendChatMessage(L["detonation_yell"], "SAY")
		else
			self:TargetMessage(L["detonation_message"], player, "Important", spellId)
		end
		self:Bar(L["detonation_message"]:format(player), 4, spellId)
		self:Icon(player, "icon")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["phase2_trigger"] then
		if db.phase then
			self:IfMessage(L["phase2_message"], "Attention")
		end
		if db.p2berserk then
			self:Enrage(375, true, true)
		end
		if db.hardmode then
			self:Bar(L["hardmode"], 173, "Ability_Warrior_Innerrage")
			self:DelayedMessage(173, L["hardmode_warning"], "Attention")
		end
	elseif msg == L["phase3_trigger"] then
		local berserkBar = GetSpellInfo(43)
		self:TriggerEvent("BigWigs_StopBar", self, berserkBar)
		self:TriggerEvent("BigWigs_StopBar", self, L["shock_bar"])
		self:TriggerEvent("BigWigs_StopBar", self, L["hammer_bar"])
		self:TriggerEvent("BigWigs_StopBar", self, L["hardmode"])
		self:CancelAllScheduledEvents()
		if db.phase then
			self:IfMessage(L["phase3_message"]:format(boss), "Attention")
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

