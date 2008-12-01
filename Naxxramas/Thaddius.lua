------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Thaddius"]
local feugen = BB["Feugen"]
local stalagg = BB["Stalagg"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local enrageStarted = nil
local addsdead = 0
local teslawarn = nil
local stage1warn = nil
local previousCharge = ""
local plus = nil
local minus = nil

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

	charge = "Charge",
	charge_desc = "Warn about Positive/Negative charge for yourself only.",

	throw = "Throw",
	throw_desc = "Warn about tank platform swaps.",

	enragetrigger = "%s goes into a berserker rage!",
	starttrigger = "Stalagg crush you!",
	starttrigger1 = "Feed you to master!",
	starttrigger2 = "Eat... your... bones...",
	starttrigger3 = "Break... you!!",
	starttrigger4 = "Kill...",

	adddeath = "%s dies.",
	teslaoverload = "%s overloads!",

	pstrigger = "Now you feel pain...",
	chargetrigger = "You are afflicted by (%w+) Charge.",

	startwarn = "Thaddius Phase 1",
	startwarn2 = "Thaddius Phase 2, Enrage in 6 minutes!",
	addsdownwarn = "Thaddius incoming in 10-20sec!",
	thaddiusincoming = "Thaddius incoming in 3 sec!",
	pswarn1 = "Thaddius begins to cast Polarity Shift!",
	pswarn2 = "30 seconds to Polarity Shift!",
	pswarn3 = "3 seconds to Polarity Shift!",
	poswarn = "You changed to a Positive Charge!",
	negwarn = "You changed to a Negative Charge!",
	nochange = "Your debuff did not change!",
	polaritytickbar = "Polarity tick",
	stalaggwarn = "Power Surge on Stalagg!",
	powersurgebar = "Power Surge",

	bar1text = "Polarity Shift",

	throwbar = "Throw",
	throwwarn = "Throw in ~5 seconds!",
} end )

L:RegisterTranslations("ruRU", function() return {
	phase = "Фазы",
	phase_desc = "Сообщать о фазах боя",

	polarity = "Сдвиг полярности",
	polarity_desc = "Предупреждать о сдвиге полярности",

	power = "Волна силы",
	power_desc = "Предупреждать о волне силы",

	charge = "Заряды",
	charge_desc = "Сообщать о положительном/отрицательном заряде только для Вас.",

	throw = "Бросока",
	throw_desc = "Предупреждать об обменах платформы резервуара.",

	enragetrigger = "%s впадает в Ярость берсерка!",  --correct this
	starttrigger = "Stalagg ломает тебя!",  --correct this
	starttrigger1 = "Мастер хочеш съесть тебя =P !!",  --correct this
	starttrigger2 = "Ем... твои... кости...",  --correct this
	starttrigger3 = "Сломаю... тебя!!",  --correct this
	starttrigger4 = "убит...",  --correct this

	adddeath = "%s умер.",
	teslaoverload = "%s перегружен!",

	pstrigger = "Ты почувствует новую боль...",  --correct this
	chargetrigger = "Ваш заряд - (%w+).",

	startwarn = "Таддиус фаза 1",
	startwarn2 = "Таддиус фаза 2, ярость через 5 минут!",
	addsdownwarn = "Таддиус появится через 10-20 секунд!",
	thaddiusincoming = "Таддиус появится через 3 секунды!",
	pswarn1 = "Таддиус сдвигает полярность!",
	pswarn2 = "30 секунд до сдвига полярности!",
	pswarn3 = "3 секунды до сдвига полярности!",
	poswarn = "Ваш заряд - положительный!",
	negwarn = "Ваш заряд - отрицательный!",
	nochange = "Ваш дебафф не изменился!",
	polaritytickbar = "Тик полярности",
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
	polarity_desc = "극성 변환에 대한 경고",

	power = "마력의 쇄도",
	power_desc = "스탈라그의 마력의 쇄도를 알립니다.",

	charge = "전하",
	charge_desc = "당신에게 걸린 전하의 극성 종류를 알립니다.",

	throw = "던지기",
	throw_desc = "탱커 위치 교체를 알립니다.",

	enragetrigger = "%s|1이;가; 광폭해집니다!",
	starttrigger = "스탈라그, 박살낸다!",
	starttrigger1 = "너 주인님께 바칠꺼야!",
	starttrigger2 = "잡아... 먹어주마...",
	starttrigger3 = "박살을 내주겠다!",
	starttrigger4 = "죽여주마...",

	adddeath = "%s|1이;가; 죽습니다.",
	teslaoverload = "%s|1이;가; 과부하 상태가 됩니다.",

	pstrigger = "자, 고통을 느껴봐라...",
	chargetrigger = "(%w+)전하에 걸렸습니다.",

	startwarn = "타디우스 1 단계",
	startwarn2 = "타디우스 2 단계, 6분 후 격노!",
	addsdownwarn = "10~20초 이내 2단계 시작!",
	thaddiusincoming = "3초 이내 2단계 시작!",
	pswarn1 = "타디우스 극성 변환 시전!",
	pswarn2 = "30초 이내 극성 변환!",
	pswarn3 = "3초 이내 극성 변환!",
	poswarn = "양전하로 변환!! 반대로 이동!",
	negwarn = "음전하로 변환!! 반대로 이동!",
	nochange = "당신의 전하가 변하지 않았습니다!",
	polaritytickbar = "극성 틱",
	stalaggwarn = "스탈라그 마력의 쇄도!",
	powersurgebar = "마력의 쇄도",

	bar1text = "극성 변환",

	throwbar = "던지기",
	throwwarn = "약 5초 후 던지기!",
} end )

L:RegisterTranslations("deDE", function() return {
	phase = "Phasen",
	phase_desc = "Anzeige der Phasenwechsel.",

	polarity = "Polarit\195\164tsver\195\164nderung Warnung",
	polarity_desc = "Warnung f\195\188r Polarit\195\164tsver\195\164nderung",

	power = "Energieschub Warnung",
	power_desc = "Warnung f\195\188r Stalagg's Energieschub",

	charge = "Ladungs-Warnung",
	charge_desc = "Warnung bei positiver/negativer Aufladung bei euch selbst.",

	enragetrigger = "verf\195\164llt in Berserkerwut",
	starttrigger = "Stalagg zerquetschen!",
	starttrigger1 = "Verf\195\188ttere euch an Meister!",
	starttrigger2 = "Eure... Knochen... zermalmen...",
	starttrigger3 = "Euch... zerquetschen!",
	starttrigger4 = "T\195\182ten...",

	adddeath = "stirbt.",
	teslaoverload = "\195\188berl\195\164dt!",

	pstrigger = "Jetzt sp\195\188rt ihr den Schmerz",
	chargetrigger = "^([^%s]+) ([^%s]+) von ([^%s]+) Ladung betroffen",

	startwarn = "Thaddius Phase 1",
	startwarn2 = "Thaddius Phase 2, Wutanfall in 5 Minuten!",
	addsdownwarn = "Thaddius kommt frei in 10-20s!",
	thaddiusincoming = "Thaddius kommt frei in 3s!",
	pswarn1 = "Thaddius beginnt Polarit\195\164tsver\195\164nderung zu wirken!",
	pswarn2 = "30 Sekunden bis Polarit\195\164tsver\195\164nderung!",
	pswarn3 = "3 Sekunden bis Polarit\195\164tsver\195\164nderung!",
	poswarn = "Ihr seid eine positive Ladung!",
	negwarn = "Ihr seid eine negative Ladung!",
	stalaggwarn = "Energieschub, Extra Heilung auf Krieger!",
	powersurgebar = "Energieschub",

	bar1text = "Polarit\195\164tsver\195\164nderung",
} end )

L:RegisterTranslations("zhCN", function() return {
	phase = "阶段",
	phase_desc = "当进入不同阶段发出警报。",

	polarity = "极性转换",
	polarity_desc = "当施放极性转换时发出警报。",

	power = "力量振荡",
	power_desc = "当施放力量振荡时发出警报。",

	charge = "电荷",
	charge_desc = "当你身上的电荷效果发生变化时发出警报。",

	throw = "投掷",
	throw_desc = "当 MT 被投掷到对面平台时发出警报。",

	enragetrigger = "%s变得极度狂暴而愤怒！",
	starttrigger = "斯塔拉格要碾碎你！",
	starttrigger1 = "主人要吃了你！",
	starttrigger2 = "咬碎……你的……骨头……",
	starttrigger3 = "打……烂……你！",
	starttrigger4 = "杀……",

	adddeath = "%s死了。",
	teslaoverload = "%s超载了！",

	pstrigger = "你感受到痛苦的滋味了吧……",
	chargetrigger = "你受到了(.+)电荷",

	startwarn = "第一阶段",
	startwarn2 = "第二阶段 - 5分钟后激怒！",
	addsdownwarn = "10-20秒后，塔迪乌斯出现！",
	thaddiusincoming = "3秒后，塔迪乌斯出现！",
	pswarn1 = "塔迪乌斯开始施放极性转化！",
	pswarn2 = "30秒后，极性转化！",
	pswarn3 = "3秒后，极性转化！",
	poswarn = "你是正电荷！",
	negwarn = "你是负电荷！",
	nochange = "你的电荷没有改变！",
	polaritytickbar = "极性标记",
	stalaggwarn = "力量振荡！",
	powersurgebar = "<力量振荡>",

	bar1text = "<极性转化>",

	throwbar = "<投掷>",
	throwwarn = "约5秒，投掷！",

} end )

L:RegisterTranslations("zhTW", function() return {
	phase = "階段警報",
	phase_desc = "階段轉換時發出警報",

	polarity = "極性轉換警報",
	polarity_desc = "極性轉換警報",

	power = "力量澎湃警報",
	power_desc = "力量澎湃警報",

	charge = "電荷警報",
	charge_desc = "你身上的電荷效果發生變化時發出警報",

	throw = "投擲警報",
	throw_desc = "主坦克轉換平台時發出警報",

	enragetrigger = "變得極度狂暴而憤怒！",
	starttrigger = "斯塔拉格要碾碎你！",
	starttrigger1 = "主人要吃了你！",
	starttrigger2 = "咬碎……你的……骨頭……",
	starttrigger3 = "打……爛……你！",
	starttrigger4 = "殺……",

	adddeath = "%s死亡了。",
	teslaoverload = "%s超負荷！",

	pstrigger = "你感受到痛苦的滋味了吧……",
	chargetrigger = "^(.+)受到(.+)(.+)電荷",

	startwarn = "泰迪斯第一階段",
	startwarn2 = "泰迪斯第二階段 - 5 分鍾後狂怒！",
	addsdownwarn = "10-20秒後泰迪斯出現！",
	thaddiusincoming = "3 秒後泰迪斯出現！",
	pswarn1 = "泰迪斯開始施放兩極移形！",
	pswarn2 = "30 秒後發動兩極移形！",
	pswarn3 = "3 秒後發動兩極移形！",
	poswarn = "你是正電荷！",
	negwarn = "你是負電荷！",
	nochange = "你的電荷沒有改變！",
	polaritytickbar = "極性狀態",
	stalaggwarn = "力量澎湃！加大對坦克的治療！",
	powersurgebar = "力量澎湃",

	bar1text = "兩極移形",

	throwbar = "投擲",
	throwwarn = "~5 秒後投擲 MT！",
} end )

L:RegisterTranslations("frFR", function() return {
	phase = "Phases",
	phase_desc = "Préviens quand la rencontre entre dans une nouvelle phase.",

	polarity = "Changement de polarité",
	polarity_desc = "Préviens quand les polarités sont changées.",

	power = "Vague de puissance",
	power_desc = "Préviens quand Stalagg utilise sa Vague de puissance.",

	charge = "Charge",
	charge_desc = "Préviens si vous changez de charge ou non.",

	throw = "Lancer",
	throw_desc = "Préviens quand les tanks sont lancés d'une plateforme à l'autre.",

	enragetrigger = "%s entre dans une rage démente !",
	starttrigger = "Stalagg écraser toi !",
	starttrigger1 = "À manger pour maître !",
	starttrigger2 = "Manger… tes… os…",
	starttrigger3 = "Casser... toi !",
	starttrigger4 = "Tuer…",

	adddeath = "%s meurt.",
	teslaoverload = "%s entre en surcharge !",

	pstrigger = "Maintenant toi sentir douleur...",
	chargetrigger = "Vous subissez les effets .* Charge (%w+)",

	startwarn = "Thaddius Phase 1",
	startwarn2 = "Thaddius Phase 2, Enrager dans 5 min. !",
	addsdownwarn = "Thaddius arrive dans 10-20 sec. !",
	thaddiusincoming = "Thaddius arrive dans 3 sec. !",
	pswarn1 = "Thaddius commence à lancer Changement de polarité !",
	pswarn2 = "30 sec. avant Changement de polarité !",
	pswarn3 = "3 sec. avant Changement de polarité !",
	poswarn = "Vous avez maintenant une charge positive !",
	negwarn = "Vous avez maintenant une charge négative !",
	nochange = "Votre charge n'a pas changé !",
	polaritytickbar = "Tick de polarité",
	stalaggwarn = "Vague de puissance sur Stalagg !",
	powersurgebar = "Vague de puissance",

	bar1text = "Changement de polarité",

	throwbar = "Lancer",
	throwwarn = "Lancer dans ~5 sec. !",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = {boss, feugen, stalagg}
mod.guid = 15928
mod.toggleoptions = {"enrage", "charge", "polarity", -1, "power", "throw", "phase", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddSyncListener("SPELL_CAST_SUCCESS", 28134, "StalaggPower")
	self:AddCombatListener("SPELL_CAST_START", "Shift", 28089)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	enrageStarted = nil
	addsdead = 0
	teslawarn = nil
	stage1warn = nil
	previousCharge = ""
	plus = "Interface\\Icons\\Spell_ChargePositive"
	minus = "Interface\\Icons\\Spell_ChargeNegative"

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:RegisterEvent("BigWigs_RecvSync")
	self:Throttle(4, "StalaggPower")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Shift()
	if self.db.profile.polarity then
		self:IfMessage(L["pswarn1"], "Important", 28089)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["pstrigger"]) and self.db.profile.polarity then
		self:RegisterEvent("PLAYER_AURAS_CHANGED")
		self:DelayedMessage(27, L["pswarn3"], "Important")
		self:Bar(L["bar1text"], 30, "Spell_Nature_Lightning")
	elseif msg == L["starttrigger"] or msg == L["starttrigger1"] then
		if self.db.profile.phase and not stage1warn then
			self:Message(L["startwarn"], "Important")
		end
		enrageStarted = nil
		addsdead = 0
		teslawarn = nil
		previousCharge = ""
		stage1warn = true
		self:Throw()
		self:ScheduleRepeatingEvent( "bwthaddiusthrow", self.Throw, 21, self )
	elseif msg:find(L["starttrigger2"]) or msg:find(L["starttrigger3"]) or msg:find(L["starttrigger4"]) then
		if self.db.profile.phase then
			self:Message(L["startwarn2"], "Important")
		end
		if self.db.profile.enrage then
			self:Enrage(360, nil, true)
		end
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L["enragetrigger"] then
		if self.db.profile.enrage then
			self:Message(L2["enrage_end"]:format(boss), "Attention", nil, "Alarm")
		end
	elseif msg == L["adddeath"] then
		addsdead = addsdead + 1
		if addsdead == 2 then
			if self.db.profile.phase then
				self:Message(L["addsdownwarn"], "Attention")
			end
			self:CancelScheduledEvent("bwthaddiusthrow")
			self:CancelScheduledEvent("bwthaddiusthrowwarn")
		end
	elseif msg == L["teslaoverload"] and self.db.profile.phase and not teslawarn then
		teslawarn = true
		self:Message(L["thaddiusincoming"], "Important")
	end
end

function mod:PLAYER_AURAS_CHANGED(msg)
	local chargetype = nil
	local iIterator = 1
	while UnitDebuff("player", iIterator) do
		local texture, applications = select(3, UnitDebuff("player", iIterator))
		if texture == plus or texture == minus then
			-- If we have a debuff with this texture that has more
			-- than one application, it means we still have the
			-- counter debuff, and thus nothing has changed yet.
			-- (we got a PW:S or Renew or whatever after he casted
			--  PS, but before we got the new debuff)
			if applications > 1 then return end
			chargetype = texture
			-- Note that we do not break out of the while loop when
			-- we found a debuff, since we still have to check for
			-- debuffs with more than 1 application.
		end
		iIterator = iIterator + 1
	end
	if not chargetype then return end

	self:UnregisterEvent("PLAYER_AURAS_CHANGED")

	if self.db.profile.charge then
		if previousCharge and previousCharge == chargetype then
			self:Message(L["nochange"], "Urgent", true, "Alarm")
		elseif chargetype == plus then
			self:Message(L["poswarn"], "Personal", true, "Alarm")
		elseif chargetype == minus then
			self:Message(L["negwarn"], "Personal", true, "Alarm")
		end
		self:TriggerEvent("BigWigs_StartBar", self, L["polaritytickbar"], 6, chargetype, "Important")
	end
	previousCharge = chargetype
end

function mod:BigWigs_RecvSync(sync)
	if sync == "StalaggPower" and self.db.profile.power then
		self:IfMessage(L["stalaggwarn"], "Important", 28134)
		self:Bar(L["powersurgebar"], 10, 28134)
	end
end

function mod:Throw()
	if self.db.profile.throw then
		self:Bar(L["throwbar"], 20, "Ability_Druid_Maul")
		self:ScheduleEvent("bwthaddiusthrowwarn", "BigWigs_Message", 15, L["throwwarn"], "Urgent")
	end
end

