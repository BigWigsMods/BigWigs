------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Thaddius"]
local feugen = BB["Feugen"]
local stalagg = BB["Stalagg"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local enrageStarted = nil
local deaths = 0
local overloads = 1
local teslawarn = nil
local stage1warn = nil
local lastCharge = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Thaddius",

	phase = "Phase",
	phase_desc = "Warn for Phase transitions",

	polarity = "Polarity Shift",
	polarity_desc = "Warn for polarity shifts",

	power = "Power Surge",
	power_desc = "Warn for Stalagg's power surge",

	throw = "Throw",
	throw_desc = "Warn about tank platform swaps.",

	starttrigger = "Stalagg crush you!",
	starttrigger1 = "Feed you to master!",
	starttrigger2 = "Eat... your... bones...",
	starttrigger3 = "Break... you!!",
	starttrigger4 = "Kill...",

	adddeath = "dies.",
	teslaoverload = "overloads!",

	pstrigger = "Now you feel pain...",
	polarity_trigger = "The polarity has Shifted!",

	startwarn = "Thaddius Phase 1",
	startwarn2 = "Thaddius Phase 2, Berserk in 6 minutes!",
	addsdownwarn = "Thaddius incoming in 10-20sec!",
	thaddiusincoming = "Thaddius incoming in 3 sec!",
	pswarn1 = "Thaddius begins to cast Polarity Shift!",
	pswarn2 = "28 sec to Polarity Shift!",
	pswarn3 = "3 sec to Polarity Shift!",
	stalaggwarn = "Power Surge on Stalagg!",
	powersurgebar = "Power Surge",
	
	polarity_changed = "Polarity changed!",
	polarity_nochange = "Same polarity!",

	bar1text = "Polarity Shift",

	throwbar = "Throw",
	throwwarn = "Throw in ~5 sec!",
} end )

L:RegisterTranslations("ruRU", function() return {
	phase = "Фазы",
	phase_desc = "Сообщать о фазах боя",

	polarity = "Сдвиг полярности",
	polarity_desc = "Предупреждать о сдвиге полярности",

	power = "Волна силы",
	power_desc = "Предупреждать о волне силы",

	throw = "Бросока",
	throw_desc = "Предупреждать о смене танков на платформах.",

	starttrigger = "Сталагг сокрушить вас!",  
	starttrigger1 = "Я скормлю вас господину!",  
	starttrigger2 = "Я сожру... ваши... кости...",  
	starttrigger3 = "Растерзаю!!!",  
	starttrigger4 = "Убью...",  

	adddeath = "умирает.",
	teslaoverload = "%s перезагружается!", 

	pstrigger = "Познайте же боль...",
	polarity_trigger = "Полярность изменилась!",

	startwarn = "Таддиус фаза 1",
	startwarn2 = "Таддиус фаза 2, Берсерк через 6 минут!",
	addsdownwarn = "Таддиус появится через 10-20 секунд!",
	thaddiusincoming = "Таддиус появится через 3 секунды!",
	pswarn1 = "Таддиус сдвигает полярность!",
	pswarn2 = "28 секунд до сдвига полярности!",
	pswarn3 = "3 секунды до сдвига полярности!",
	stalaggwarn = "Волна силы на Сталагге!",
	powersurgebar = "Волна силы",

	bar1text = "Сдвиг полярности",

	throwbar = "Бросок",
	throwwarn = "Бросок через 5 секунд!",
} end )

L:RegisterTranslations("koKR", function() return {
	phase = "단계 변경",
	phase_desc = "단계 변경을 알립니다.",

	polarity = "극성 변환",
	polarity_desc = "극성 변환에 대하여 알립니다.",

	power = "마력의 쇄도",
	power_desc = "스탈라그의 마력의 쇄도를 알립니다.",

	throw = "던지기",
	throw_desc = "탱커 위치 교체를 알립니다.",

	starttrigger = "스탈라그, 박살낸다!",
	starttrigger1 = "너 주인님께 바칠꺼야!",
	starttrigger2 = "잡아... 먹어주마...",
	starttrigger3 = "박살을 내주겠다!",
	starttrigger4 = "죽여주마...",

	adddeath = "죽습니다.",
	teslaoverload = "과부하 상태가 됩니다.",

	pstrigger = "자, 고통을 느껴봐라...",
	polarity_trigger = "극성이 바뀌었습니다!",

	startwarn = "타디우스 1 단계",
	startwarn2 = "타디우스 2 단계, 6분 후 격노!",
	addsdownwarn = "10~20초 이내 2단계 시작!",
	thaddiusincoming = "3초 이내 2단계 시작!",
	pswarn1 = "타디우스 극성 변환 시전!",
	pswarn2 = "28초 이내 극성 변환!",
	pswarn3 = "3초 이내 극성 변환!",
	stalaggwarn = "스탈라그 마력의 쇄도!",
	powersurgebar = "마력의 쇄도",

	bar1text = "극성 변환",

	throwbar = "던지기",
	throwwarn = "약 5초 후 던지기!",
} end )

L:RegisterTranslations("deDE", function() return {
	phase = "Phasen",
	phase_desc = "Warnt bei Phasenwechsel.",

	polarity = "Polaritätsveränderung",
	polarity_desc = "Warnt bei Polaritätsveränderung.",

	power = "Kraftsog", -- aka "Energieschub", Blizzard's inconsistence
	power_desc = "Warnungen und Timer für Kraftsog von Stalagg.",

	throw = "Magnetische Anziehung",
	throw_desc = "Warnt, wenn die Tanks die Plattform wechseln.",

	starttrigger = "Stalagg zerquetschen!",
	starttrigger1 = "Verfüttere euch an Meister!",
	starttrigger2 = "Eure... Knochen... zermalmen...",
	starttrigger3 = "Euch... zerquetschen!",
	starttrigger4 = "Töten...",

	adddeath = "stirbt.",
	teslaoverload = "überlädt!",

	pstrigger = "Jetzt spürt ihr den Schmerz...",
	polarity_trigger = "Die Polarität hat sich verschoben!",

	startwarn = "Phase 1",
	startwarn2 = "Thaddius Phase 2, Berserker in 6 min",
	addsdownwarn = "Thaddius kommt in 10-20 sek!",
	thaddiusincoming = "Thaddius kommt in 3 sek!",
	pswarn1 = "Thaddius beginnt Polaritätsveränderung zu wirken!",
	pswarn2 = "Polaritätsveränderung in 28 sek!",
	pswarn3 = "Polaritätsveränderung in 3 sek!",
	stalaggwarn = "Kraftsog auf Stalagg!",
	powersurgebar = "Kraftsog",
	
	polarity_changed = "Polarität geändert!",
	polarity_nochange = "Selbe Polarität!",

	bar1text = "Polaritätsveränderung",

	throwbar = "Magnetische Anziehung",
	throwwarn = "Magnetische Anziehung in ~5 sek!",
} end )

L:RegisterTranslations("zhCN", function() return {
	phase = "阶段",
	phase_desc = "当进入不同阶段发出警报。",

	polarity = "极性转化",
	polarity_desc = "当施放极性转化时发出警报。",

	power = "力量振荡",
	power_desc = "当施放力量振荡时发出警报。",

	throw = "投掷",
	throw_desc = "当 MT 被投掷到对面平台时发出警报。",

	starttrigger = "斯塔拉格要碾碎你！",
	starttrigger1 = "主人要吃了你！",
	starttrigger2 = "咬碎……你的……骨头……",
	starttrigger3 = "打……烂……你！",
	starttrigger4 = "杀……",

	adddeath = "死了。",
	teslaoverload = "超载！",

	pstrigger = "你感受到痛苦的滋味了吧……",
	--polarity_trigger = "The polarity has Shifted!",

	startwarn = "第一阶段",
	startwarn2 = "第二阶段 - 6分钟后激怒！",
	addsdownwarn = "10-20秒后，塔迪乌斯出现！",
	thaddiusincoming = "3秒后，塔迪乌斯出现！",
	pswarn1 = "塔迪乌斯开始施放极性转化！",
	pswarn2 = "28秒后，极性转化！",
	pswarn3 = "3秒后，极性转化！",
	stalaggwarn = "力量振荡！",
	powersurgebar = "<力量振荡>",

	polarity_changed = "极性转化改变！",
	polarity_nochange = "相同极性转化！",
	
	bar1text = "<极性转化>",

	throwbar = "<投掷>",
	throwwarn = "约5秒，投掷！",

} end )

L:RegisterTranslations("zhTW", function() return {
	phase = "階段",
	phase_desc = "當進入不同階段時發出警報。",

	polarity = "兩極移形",
	polarity_desc = "當施放兩極移形時發出警報。",

	power = "力量澎湃",
	power_desc = "當施放力量澎湃時發出警報。",

	throw = "投擲",
	throw_desc = "當主坦克被投擲到對面平台時發出警報。",

	starttrigger = "斯塔拉格要碾碎你！",
	starttrigger1 = "主人要吃了你！",
	starttrigger2 = "咬碎……你的……骨頭……",
	starttrigger3 = "打……爛……你！",
	starttrigger4 = "殺……",

	adddeath = "死亡了。",
	teslaoverload = "超負荷！",

	pstrigger = "你感受到痛苦的滋味了吧……",
	--polarity_trigger = "The polarity has Shifted!",

	startwarn = "第一階段",
	startwarn2 = "第二階段 - 6分鍾後狂怒！",
	addsdownwarn = "10-20秒後，泰迪斯出現！",
	thaddiusincoming = "3秒後，泰迪斯出現！",
	pswarn1 = "泰迪斯開始施放兩極移形！",
	pswarn2 = "28秒後，兩極移形！",
	pswarn3 = "3秒後，兩極移形！",
	stalaggwarn = "力量澎湃！加大對坦克的治療！",
	powersurgebar = "<力量澎湃>",
	
	polarity_changed = "兩極移形改变！",
	polarity_nochange = "相同兩極移形！",

	bar1text = "<兩極移形>",

	throwbar = "<投擲>",
	throwwarn = "約5秒後，投擲！",
} end )

L:RegisterTranslations("frFR", function() return {
	phase = "Phases",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",

	polarity = "Changement de polarité",
	polarity_desc = "Prévient quand un Changement de polarité est incanté.",

	power = "Vague de puissance",
	power_desc = "Prévient quand Stalagg utilise sa Vague de puissance.",

	throw = "Lancer",
	throw_desc = "Prévient quand les tanks sont lancés d'une plate-forme à l'autre.",

	starttrigger = "Stalagg écraser toi !",
	starttrigger1 = "À manger pour maître !",
	starttrigger2 = "Manger… tes… os…",
	starttrigger3 = "Casser... toi !",
	starttrigger4 = "Tuer…",

	adddeath = "meurt.",
	teslaoverload = "%s entre en surcharge !",

	pstrigger = "Maintenant toi sentir douleur...",
	polarity_trigger = "La polarité vient de changer !",

	startwarn = "Thaddius - Phase 1",
	startwarn2 = "Thaddius - Phase 2, Berserk dans 6 min. !",
	addsdownwarn = "Arrivée de Thaddius dans 10-20 sec. !",
	thaddiusincoming = "Arrivée de Thaddius dans 3 sec. !",
	pswarn1 = "Thaddius commence à incanter un Changement de polarité !",
	pswarn2 = "28 sec. avant Changement de polarité !",
	pswarn3 = "3 sec. avant Changement de polarité !",
	stalaggwarn = "Vague de puissance sur Stalagg !",
	powersurgebar = "Vague de puissance",

	bar1text = "Changement de polarité",

	throwbar = "Lancer",
	throwwarn = "Lancer dans ~5 sec. !",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = {boss, feugen, stalagg}
mod.guid = 15928
mod.toggleoptions = {"polarity", -1, "power", "throw", "phase", "berserk", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "StalaggPower", 28134, 54529)
	self:AddCombatListener("SPELL_CAST_START", "Shift", 28089)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	enrageStarted = nil
	deaths = 0
	overloads = 1
	teslawarn = nil
	stage1warn = nil
	lastCharge = nil
	
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:StalaggPower()
	if self.db.profile.power then
		self:IfMessage(L["stalaggwarn"], "Important", 28134)
		self:Bar(L["powersurgebar"], 10, 28134)
	end
end

function mod:UNIT_AURA()
	local newCharge = nil
	for i = 1, 40 do
		local name, _, icon, stack = UnitDebuff("player", i)
		if not name then break end
		-- If stack > 1 we need to wait for another UNIT_AURA event.
		if stack == 1 then
			if icon == "Interface\\Icons\\Spell_ChargeNegative" or
			   icon == "Interface\\Icons\\Spell_ChargePositive" then
				newCharge = icon
			end
		end
	end
	if newCharge then
		if self.db.profile.polarity then
			if newCharge == lastCharge then
				self:LocalMessage(L["polarity_nochange"], "Positive", newCharge)
			else
				self:LocalMessage(L["polarity_changed"], "Personal", newCharge, "Alert")
			end
		end
		lastCharge = newCharge
		self:UnregisterEvent("UNIT_AURA")
	end
end

function mod:Shift()
	self:RegisterEvent("UNIT_AURA")
	if self.db.profile.polarity then
		self:IfMessage(L["pswarn1"], "Important", 28089)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["pstrigger"]) and self.db.profile.polarity then
		self:DelayedMessage(25, L["pswarn3"], "Important")
		self:Bar(L["bar1text"], 28, "Spell_Nature_Lightning")
	elseif msg == L["starttrigger"] or msg == L["starttrigger1"] then
		if self.db.profile.phase and not stage1warn then
			self:Message(L["startwarn"], "Important")
		end
		enrageStarted = nil
		deaths = 0
		teslawarn = nil
		stage1warn = true
		self:Throw()
	elseif msg:find(L["starttrigger2"]) or msg:find(L["starttrigger3"]) or msg:find(L["starttrigger4"]) then
		if self.db.profile.phase then
			self:Message(L["startwarn2"], "Important")
		end
		if self.db.profile.berserk then
			self:Enrage(360, true, true)
		end
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg:find(L["adddeath"]) then
		deaths = deaths + 1
		if deaths == 2 then
			if self.db.profile.phase then
				self:Message(L["addsdownwarn"], "Attention")
			end
			self:CancelScheduledEvent("Bwthaddiusthrow")
			self:CancelScheduledEvent("Bwthaddiusthrowwarn")
			self:TriggerEvent("BigWigs_StopBar", self, L["throwbar"])
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg:find(L["teslaoverload"]) and self.db.profile.phase and not teslawarn then
		teslawarn = true
		overloads = overloads + 1
		if overloads == 2 then
			self:Message(L["thaddiusincoming"], "Important")
		end
	elseif msg:find(L["polarity_trigger"]) then
		if self.db.profile.polarity then
			self:Message(L["polarity_trigger"], "Attention")
		end
	end
end

function mod:Throw()
	if self.db.profile.throw then
		self:Bar(L["throwbar"], 20, "Ability_Druid_Maul")
		self:ScheduleEvent("Bwthaddiusthrowwarn", "BigWigs_Message", 15, L["throwwarn"], "Urgent")
		self:ScheduleEvent("Bwthaddiusthrow", self.Throw, 21, self)
	end
end

