----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Thaddius"]
local feugen = BB["Feugen"]
local stalagg = BB["Stalagg"]

local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.zoneName = BZ["Naxxramas"]
mod.enabletrigger = {boss, feugen, stalagg}
mod.guid = 15928
mod.toggleOptions = {28089, -1, 28134, "throw", "phase", "berserk", "bosskill"}
mod.consoleCmd = "Thaddius"

------------------------------
--      Are you local?      --
------------------------------

local deaths = 0
local stage1warn = nil
local lastCharge = nil
local shiftTime = nil

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	phase = "Phase",
	phase_desc = "Warn for Phase transitions",

	throw = "Throw",
	throw_desc = "Warn about tank platform swaps.",

	trigger_phase1_1 = "Stalagg crush you!",
	trigger_phase1_2 = "Feed you to master!",
	trigger_phase2_1 = "Eat... your... bones...",
	trigger_phase2_2 = "Break... you!!",
	trigger_phase2_3 = "Kill...",

	polarity_trigger = "Now you feel pain...",
	polarity_message = "Polarity Shift incoming!",
	polarity_warning = "3 sec to Polarity Shift!",
	polarity_bar = "Polarity Shift",
	polarity_changed = "Polarity changed!",
	polarity_nochange = "Same polarity!",

	polarity_first_positive = "You're POSITIVE!",
	polarity_first_negative = "You're NEGATIVE!",

	phase1_message = "Phase 1",
	phase2_message = "Phase 2, Berserk in 6 minutes!",

	surge_message = "Power Surge on Stalagg!",

	throw_bar = "Throw",
	throw_warning = "Throw in ~5 sec!",
} end)

L:RegisterTranslations("ruRU", function() return {
	phase = "Фазы",
	phase_desc = "Сообщать о фазах боя",

	throw = "Бросока",
	throw_desc = "Предупреждать о смене танков на платформах.",

	trigger_phase1_1 = "Сталагг сокрушить вас!",
	trigger_phase1_2 = "Я скормлю вас господину!",
	trigger_phase2_1 = "Я сожру... ваши... кости...",
	trigger_phase2_2 = "Растерзаю!!!",
	trigger_phase2_3 = "Убью...",

	polarity_trigger = "Познайте же боль...",
	polarity_message = "Таддиус сдвигает полярность!",
	polarity_warning = "3 секунды до сдвига полярности!",
	polarity_bar = "Сдвиг полярности",
	polarity_changed = "Полярность сменилась!",
	polarity_nochange = "Полярность НЕ сменилась!",

	polarity_first_positive = "Вы (+) ПОЛОЖИТЕЛЬНЫЙ!",
	polarity_first_negative = "Вы (-) ОТРИЦАТЕЛЬНЫЙ!",

	phase1_message = "Таддиус фаза 1",
	phase2_message = "Таддиус фаза 2, Берсерк через 6 минут!",

	surge_message = "Волна силы на Сталагге!",

	throw_bar = "Бросок",
	throw_warning = "Бросок через 5 секунд!",
} end)

L:RegisterTranslations("koKR", function() return {
	phase = "단계 변경",
	phase_desc = "단계 변경을 알립니다.",

	throw = "던지기",
	throw_desc = "탱커 위치 교체를 알립니다.",

	trigger_phase1_1 = "스탈라그, 박살낸다!",
	trigger_phase1_2 = "너 주인님께 바칠꺼야!",
	trigger_phase2_1 = "잡아... 먹어주마...",
	trigger_phase2_2 = "박살을 내주겠다!",
	trigger_phase2_3 = "죽여주마...",

	polarity_trigger = "자, 고통을 느껴봐라...",
	polarity_message = "타디우스 극성 변환 시전!",
	polarity_warning = "3초 이내 극성 변환!",
	polarity_bar = "극성 변환",
	polarity_changed = "극성 변경됨!",
	polarity_nochange = "같은 극성!",

	phase1_message = "타디우스 1 단계",
	phase2_message = "타디우스 2 단계, 6분 후 격노!",

	polarity_first_positive = "당신은 플러스!",
	polarity_first_negative = "당신은 마이너스!",

	surge_message = "스탈라그 마력의 쇄도!",

	throw_bar = "던지기",
	throw_warning = "약 5초 후 던지기!",
} end)

L:RegisterTranslations("deDE", function() return {
	phase = "Phasen",
	phase_desc = "Warnt bei Phasenwechsel.",

	throw = "Magnetische Anziehung",
	throw_desc = "Warnt, wenn die Tanks die Plattform wechseln.",

	trigger_phase1_1 = "Stalagg zerquetschen!",
	trigger_phase1_2 = "Verfüttere euch an Meister!",
	trigger_phase2_1 = "Eure... Knochen... zermalmen...",
	trigger_phase2_2 = "Euch... zerquetschen!",
	trigger_phase2_3 = "Töten...",

	polarity_trigger = "Jetzt spürt ihr den Schmerz...",
	polarity_message = "Thaddius beginnt Polaritätsveränderung zu wirken!",
	polarity_warning = "Polaritätsveränderung in 3 sek!",
	polarity_bar = "Polaritätsveränderung",
	polarity_changed = "Polarität geändert!",
	polarity_nochange = "Selbe Polarität!",

	polarity_first_positive = "Du bist POSITIV!",
	polarity_first_negative = "Du bist NEGATIV!",

	phase1_message = "Phase 1",
	phase2_message = "Thaddius Phase 2, Berserker in 6 min",

	surge_message = "Kraftsog auf Stalagg!",

	throw_bar = "Magnetische Anziehung",
	throw_warning = "Magnetische Anziehung in ~5 sek!",
} end)

L:RegisterTranslations("zhCN", function() return {
	phase = "阶段",
	phase_desc = "当进入不同阶段发出警报。",

	throw = "投掷",
	throw_desc = "当 MT 被投掷到对面平台时发出警报。",

	trigger_phase1_1 = "斯塔拉格要碾碎你！",
	trigger_phase1_2 = "主人要吃了你！",
	trigger_phase2_1 = "咬碎……你的……骨头……",
	trigger_phase2_2 = "打……烂……你！",
	trigger_phase2_3 = "杀……",

	polarity_trigger = "你感受到痛苦的滋味了吧……",
	polarity_message = "塔迪乌斯开始施放极性转化！",
	polarity_warning = "3秒后，极性转化！",
	polarity_bar = "<极性转化>",
	polarity_changed = "极性转化改变！",
	polarity_nochange = "相同极性转化！",

	polarity_first_positive = "你是 >正极<！",
	polarity_first_negative = "你是 >负极<！",

	phase1_message = "第一阶段",
	phase2_message = "第二阶段 - 6分钟后激怒！",

	surge_message = "力量振荡！",

	throw_bar = "<投掷>",
	throw_warning = "约5秒后，投掷！",
} end)

L:RegisterTranslations("zhTW", function() return {
	phase = "階段",
	phase_desc = "當進入不同階段時發出警報。",

	throw = "投擲",
	throw_desc = "當主坦克被投擲到對面平台時發出警報。",

	trigger_phase1_1 = "斯塔拉格要碾碎你!",
	trigger_phase1_2 = "主人要吃了你!",
	trigger_phase2_1 = "咬碎……你的……骨頭……",
	trigger_phase2_2 = "打…碎…你……",
	trigger_phase2_3 = "殺……",

	polarity_trigger = "你感受到痛苦的滋味了吧……",
	polarity_message = "泰迪斯開始施放兩極移形！",
	polarity_warning = "3秒後，兩極移形！",
	polarity_bar = "<兩極移形>",
	polarity_changed = "兩極移形改變！",
	polarity_nochange = "相同兩極移形！",

	polarity_first_positive = "你是 >正極<！",
	polarity_first_negative = "你是 >負極<！",

	phase1_message = "第一階段",
	phase2_message = "第二階段 - 6分鍾後狂怒！",

	surge_message = "力量澎湃！加大對坦克的治療！",

	throw_bar = "<投擲>",
	throw_warning = "約5秒後，投擲！",
} end)

L:RegisterTranslations("frFR", function() return {
	phase = "Phases",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",

	throw = "Lancer",
	throw_desc = "Prévient quand les tanks sont lancés d'une plate-forme à l'autre.",

	trigger_phase1_1 = "Stalagg écraser toi !",
	trigger_phase1_2 = "À manger pour maître !",
	trigger_phase2_1 = "Manger… tes… os…",
	trigger_phase2_2 = "Casser... toi !",
	trigger_phase2_3 = "Tuer…",

	polarity_trigger = "Maintenant toi sentir douleur...",
	polarity_message = "Thaddius commence à incanter un Changement de polarité !",
	polarity_warning = "3 sec. avant Changement de polarité !",
	polarity_bar = "Changement de polarité",
	polarity_changed = "La polarité a changé !",
	polarity_nochange = "Même polarité !",

	polarity_first_positive = "Vous êtes POSITIF !",
	polarity_first_negative = "Vous êtes NÉGATIF !",

	phase1_message = "Phase 1",
	phase2_message = "Phase 2, Berserk dans 6 min. !",

	surge_message = "Vague de puissance sur Stalagg !",

	throw_bar = "Lancer",
	throw_warning = "Lancer dans ~5 sec. !",
} end)

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "StalaggPower", 28134, 54529)
	self:AddCombatListener("SPELL_CAST_START", "Shift", 28089)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	deaths = 0
	stage1warn = nil
	lastCharge = nil
	shiftTime = nil

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:StalaggPower(_, spellId, _, _, spellName)
	self:IfMessage(L["surge_message"], "Important", spellId)
	self:Bar(spellName, 10, spellId)
end

function mod:UNIT_AURA(unit)
	if unit and unit ~= "player" then return end
	if not shiftTime or (GetTime() - shiftTime) < 3 then return end

	local newCharge = nil
	for i = 1, 40 do
		local name, _, icon, stack = UnitDebuff("player", i)
		if not name then break end
		-- If stack > 1 we need to wait for another UNIT_AURA event.
		-- UnitDebuff returns 0 for debuffs that don't stack.
		if icon == "Interface\\Icons\\Spell_ChargeNegative" or
		   icon == "Interface\\Icons\\Spell_ChargePositive" then
			if stack > 1 then return end
			newCharge = icon
			-- We keep scanning even though we found one, because
			-- if we have another buff with these icons that has
			-- stack > 1 then we need to break and wait for another
			-- UNIT_AURA event.
		end
	end
	if newCharge then
		if self:GetOption(28089) then
			if not lastCharge then
				self:LocalMessage(newCharge == "Interface\\Icons\\Spell_ChargePositive" and
					L["polarity_first_positive"] or L["polarity_first_negative"],
					"Personal", newCharge, "Alert")
			else
				if newCharge == lastCharge then
					self:LocalMessage(L["polarity_nochange"], "Positive", newCharge)
				else
					self:LocalMessage(L["polarity_changed"], "Personal", newCharge, "Alert")
				end
			end
		end
		lastCharge = newCharge
		shiftTime = nil
		self:UnregisterEvent("UNIT_AURA")
	end
end

function mod:Shift()
	shiftTime = GetTime()
	self:RegisterEvent("UNIT_AURA")
	if self:GetOption(28089) then
		self:IfMessage(L["polarity_message"], "Important", 28089)
	end
end

local function throw()
	if shiftTime then return end
	if mod.db.profile.throw then
		mod:Bar(L["throw_bar"], 20, "Ability_Druid_Maul")
		mod:DelayedMessage(15, L["throw_warning"], "Urgent")
	end
	mod:ScheduleEvent(throw, 21)
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self:GetOption(28089) and msg:find(L["polarity_trigger"]) then
		self:DelayedMessage(25, L["polarity_warning"], "Important")
		self:Bar(L["polarity_bar"], 28, "Spell_Nature_Lightning")
	elseif msg == L["trigger_phase1_1"] or msg == L["trigger_phase1_2"] then
		if self.db.profile.phase and not stage1warn then
			self:Message(L["phase1_message"], "Important")
		end
		deaths = 0
		stage1warn = true
		throw()
	elseif msg:find(L["trigger_phase2_1"]) or msg:find(L["trigger_phase2_2"]) or msg:find(L["trigger_phase2_3"]) then
		self:CancelAllScheduledEvents()
		self:TriggerEvent("BigWigs_StopBar", self, L["throw_bar"])
		if self.db.profile.phase then
			self:Message(L["phase2_message"], "Important")
		end
		if self.db.profile.berserk then
			self:Enrage(360, true, true)
		end
	end
end

