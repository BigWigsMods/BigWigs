------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Thaddius"]
local feugen = AceLibrary("Babble-Boss-2.2")["Feugen"]
local stalagg = AceLibrary("Babble-Boss-2.2")["Stalagg"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Thaddius",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for Enrage",

	phase_cmd = "phase",
	phase_name = "Phase Alerts",
	phase_desc = "Warn for Phase transitions",

	polarity_cmd = "polarity",
	polarity_name = "Polarity Shift Alert",
	polarity_desc = "Warn for polarity shifts",

	power_cmd = "power",
	power_name = "Power Surge Alert",
	power_desc = "Warn for Stalagg's power surge",

	charge_cmd = "charge",
	charge_name = "Charge Alert",
	charge_desc = "Warn about Positive/Negative charge for yourself only.",

	throw_cmd = "throw",
	throw_name = "Throw Alerts",
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
	trigger1 = "Thaddius begins to cast Polarity Shift",
	chargetrigger = "You are afflicted by (%w+) Charge.",
	positivetype = "Interface\\Icons\\Spell_ChargePositive",
	negativetype = "Interface\\Icons\\Spell_ChargeNegative",
	stalaggtrigger = "Stalagg gains Power Surge.",

	you = "You",
	are = "are",

	enragewarn = "Enrage!",
	startwarn = "Thaddius Phase 1",
	startwarn2 = "Thaddius Phase 2, Enrage in 5 minutes!",
	addsdownwarn = "Thaddius incoming in 10-20sec!",
	thaddiusincoming = "Thaddius incoming in 3 sec!",
	pswarn1 = "Thaddius begins to cast Polarity Shift!",
	pswarn2 = "30 seconds to Polarity Shift!",
	pswarn3 = "3 seconds to Polarity Shift!",
	poswarn = "You changed to a Positive Charge!",
	negwarn = "You changed to a Negative Charge!",
	nochange = "Your debuff did not change!",
	polaritytickbar = "Polarity tick",
	enragebartext = "Enrage",
	warn1 = "Enrage in 3 minutes",
	warn2 = "Enrage in 90 seconds",
	warn3 = "Enrage in 60 seconds",
	warn4 = "Enrage in 30 seconds",
	warn5 = "Enrage in 10 seconds",
	stalaggwarn = "Power Surge on Stalagg!",
	powersurgebar = "Power Surge",

	bar1text = "Polarity Shift",

	throwbar = "Throw",
	throwwarn = "Throw in ~5 seconds!",
} end )

L:RegisterTranslations("koKR", function() return {
	enrage_name = "격노 경고",
	enrage_desc = "격노에 대한 경고",

	phase_name = "단계 경고",
	phase_desc = "단계 변경에 대한 경고",

	polarity_name = "극성 변환 경고",
	polarity_desc = "극성 변환에 대한 경고",

	power_name = "마력의 쇄도 경고",
	power_desc = "스탈라그의 마력의 쇄도에 대한 경고",

	charge_name = "대전 경고",
	charge_desc = "당신에게 걸린 전하의 극성 종류에 대한 경고",

	throw_name = "던지기 경고",
	throw_desc = "탱커 위치 변경에 대한 경고",

	enragetrigger = "%s|1이;가; 광폭해집니다!",
	starttrigger = "스탈라그, 박살낸다!",
	starttrigger1 = "너 주인님께 바칠꺼야!",
	starttrigger2 = "잡아... 먹어주마...",
	starttrigger3 = "박살을 내주겠다!", -- CHECK
	starttrigger4 = "죽여주마...",

	adddeath = "%s|1이;가; 죽습니다.",
	teslaoverload = "%s|1이;가; 과부하 상태가 됩니다.",

	pstrigger = "자, 고통을 느껴봐라...", -- CHECK
	trigger1 = "타디우스|1이;가; 극성 변환|1을;를; 시전합니다.",
	chargetrigger = "(%w+)전하에 걸렸습니다.",
	positivetype = "Interface\\Icons\\Spell_ChargePositive",
	negativetype = "Interface\\Icons\\Spell_ChargeNegative",
	stalaggtrigger = "스탈라그|1이;가; 마력의 쇄도 효과를 얻었습니다.",

	you = "",
	are = "",

	enragewarn = "격노!",
	startwarn = "타디우스 1 단계",
	startwarn2 = "타디우스 2 단계, 5분 후 격노!",
	addsdownwarn = "2단계가 10~20초후에 시작됩니다!",
	thaddiusincoming = "2단계가 3초후 시작됩니다!",
	pswarn1 = "타디우스가 극성 변환을 시전합니다!",
	pswarn2 = "30초후 극성 변환!",
	pswarn3 = "3초후 극성 변환!",
	poswarn = "양전하로 대전!! 반대로 이동!",
	negwarn = "음전하로 대전!! 반대로 이동!",
	nochange = "극성이 변하지 않았습니다! 제자리 대기!",
	polaritytickbar = "극성 틱",
	enragebartext = "격노",
	warn1 = "3분후 격노",
	warn2 = "90초후 격노",
	warn3 = "60초후 격노",
	warn4 = "30초후 격노",
	warn5 = "10초후 격노",
	stalaggwarn = "스탈라그 힘의 쇄도 발동, 탱커 폭힐!",
	powersurgebar = "마력의 쇄도",

	bar1text = "극성 변환",

	throwbar = "던지기",
	throwwarn = "약 5초 후 던지기!",
} end )

L:RegisterTranslations("deDE", function() return {
	enrage_name = "Wutanfall",
	enrage_desc = "Warnung, wenn Thaddius w\195\188tend wird.",

	phase_name = "Phasen",
	phase_desc = "Anzeige der Phasenwechsel.",

	polarity_name = "Polarit\195\164tsver\195\164nderung Warnung",
	polarity_desc = "Warnung f\195\188r Polarit\195\164tsver\195\164nderung",

	power_name = "Energieschub Warnung",
	power_desc = "Warnung f\195\188r Stalagg's Energieschub",

	charge_name = "Ladungs-Warnung",
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
	trigger1 = "Thaddius beginnt Polarit\195\164tsver\195\164nderung zu wirken.",
	chargetrigger = "^([^%s]+) ([^%s]+) von ([^%s]+) Ladung betroffen",
	stalaggtrigger = "Stalagg bekommt 'Energieschub'.",

	you = "Ihr",
	are = "seid",

	enragewarn = "Wutanfall!",
	startwarn = "Thaddius Phase 1",
	startwarn2 = "Thaddius Phase 2, Wutanfall in 5 Minuten!",
	addsdownwarn = "Thaddius kommt frei in 10-20s!",
	thaddiusincoming = "Thaddius kommt frei in 3s!",
	pswarn1 = "Thaddius beginnt Polarit\195\164tsver\195\164nderung zu wirken!",
	pswarn2 = "30 Sekunden bis Polarit\195\164tsver\195\164nderung!",
	pswarn3 = "3 Sekunden bis Polarit\195\164tsver\195\164nderung!",
	poswarn = "Ihr seid eine positive Ladung!",
	negwarn = "Ihr seid eine negative Ladung!",
	enragebartext = "Wutanfall",
	warn1 = "Wutanfall in 3 Minuten",
	warn2 = "Wutanfall in 90 Sekunden",
	warn3 = "Wutanfall in 60 Sekunden",
	warn4 = "Wutanfall in 30 Sekunden",
	warn5 = "Wutanfall in 10 Sekunden",
	stalaggwarn = "Energieschub, Extra Heilung auf Krieger!",
	powersurgebar = "Energieschub",

	bar1text = "Polarit\195\164tsver\195\164nderung",
} end )

L:RegisterTranslations("zhCN", function() return {
	enrage_name = "激怒警报",
	enrage_desc = "激怒警报",

	phase_name = "阶段警报",
	phase_desc = "阶段转换时发出警报",

	polarity_name = "极性转换警报",
	polarity_desc = "极性转换警报",

	power_name = "力量振荡警报",
	power_desc = "力量振荡警报",

	charge_name = "电荷警报",
	charge_desc = "你身上的电荷效果发生变化时发出警报",

	throw_name = "扔人提示",
	throw_desc = "当TANK开始转换平台时发出警报",

	enragetrigger = "变得极度狂暴而愤怒！",
	starttrigger = "斯塔拉格要碾碎你！",
	starttrigger1 = "主人要吃了你！",
	starttrigger2 = "咬碎……你的……骨头……",
	starttrigger3 = "打……烂……你！",
	starttrigger4 = "杀……",

	adddeath = "%s死亡了。",
	teslaoverload = "%s超负荷！",

	pstrigger = "你感受到痛苦的滋味了吧……",
	trigger1 = "塔迪乌斯开始施放极性转化。",
	chargetrigger = "^(.+)受(.+)了(.+)电荷",
	stalaggtrigger = "斯塔拉格获得了能量涌动的效果。",

	you = "你",
	are = "到",

	enragewarn = "激怒！",
	startwarn = "塔迪乌斯第一阶段",
	startwarn2 = "塔迪乌斯第二阶段，5分钟后激怒！",
	addsdownwarn = "10-20秒后塔迪乌斯出现！",
	thaddiusincoming = "3秒后塔迪乌斯出现！",
	pswarn1 = "塔迪乌斯开始施放极性转化！",
	pswarn2 = "30秒后发动极性转化！",
	pswarn3 = "3秒后发动极性转化！",
	poswarn = "你是正电荷！",
	negwarn = "你是负电荷！",
	nochange = "你的电荷没有改变!",
	polaritytickbar = "极性 Tick",
	enragebartext = "激怒",
	warn1 = "3分钟后激怒",
	warn2 = "90秒后激怒",
	warn3 = "60秒后激怒",
	warn4 = "30秒后激怒",
	warn5 = "10秒后激怒",
	stalaggwarn = "力量振荡！加大对坦克的治疗！",
	powersurgebar = "力量振荡",

	bar1text = "极性转化",

	throwbar = "扔",
	throwwarn = "~5秒后扔人！",

} end )

L:RegisterTranslations("zhTW", function() return {
	enrage_name = "狂怒警報",
	enrage_desc = "狂怒警報",

	phase_name = "階段警報",
	phase_desc = "階段轉換時發出警報",

	polarity_name = "極性轉換警報",
	polarity_desc = "極性轉換警報",

	power_name = "力量澎湃警報",
	power_desc = "力量澎湃警報",

	charge_name = "電荷警報",
	charge_desc = "你身上的電荷效果發生變化時發出警報",

	enragetrigger = "變得極度狂暴而憤怒！",
	starttrigger = "斯塔拉格要碾碎你！",
	starttrigger1 = "主人要吃了你！",
	starttrigger2 = "咬碎……你的……骨頭……",
	starttrigger3 = "打……爛……你！",
	starttrigger4 = "殺……",

	adddeath = "%s死亡了。",
	teslaoverload = "%s超負荷！",

	pstrigger = "你感受到痛苦的滋味了吧……",
	trigger1 = "泰迪斯開始施放兩極移形。",
	chargetrigger = "^(.+)受到(.+)(.+)電荷",
	stalaggtrigger = "斯塔拉格獲得了力量澎湃的效果。",

	you = "你",
	are = "了",

	enragewarn = "狂怒！",
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
	enragebartext = "狂怒",
	warn1 = "3 分鐘後狂怒",
	warn2 = "90 秒後狂怒",
	warn3 = "60 秒後狂怒",
	warn4 = "30 秒後狂怒",
	warn5 = "10 秒後狂怒",
	stalaggwarn = "力量澎湃！加大對坦克的治療！",
	powersurgebar = "力量澎湃",

	bar1text = "兩極移形",
} end )

L:RegisterTranslations("frFR", function() return {
	enragetrigger = "%s entre dans une rage d\195\169mente !",
	starttrigger = "Stalagg \195\169craser toi !",

	starttrigger1 = "manger pour maitre !",
	starttrigger2 = "Manger.. tes... os...", -- CHECK
	starttrigger3 = "Casser... toi !", -- CHECK
	starttrigger4 = "Tuer...", -- CHECK

	adddeath = "%s meurt.",
	teslaoverload = "%s entre en surcharge !",

	pstrigger = "Maintenant toi sentir douleur...",
	trigger1 = "Thaddius commence \195\160 lancer Changement de polarit\195\169.",
	chargetrigger = "Vous subissez les effets de Charge (%w+).",
	stalaggtrigger = "Stalagg gagne Vague de puissance.",

	you = "Vous",
	are = "subissez",

	stalaggwarn = "Vague de Puissance sur Stalagg",
	powersurgebar = "Vague de Puissance",
	bar1text = "Changement de polarit\195\169",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsThaddius = BigWigs:NewModule(boss)
BigWigsThaddius.zonename = AceLibrary("Babble-Zone-2.2")["Naxxramas"]
BigWigsThaddius.enabletrigger = { boss, feugen, stalagg }
BigWigsThaddius.toggleoptions = {"enrage", "charge", "polarity", -1, "power", "throw", "phase", "bosskill"}
BigWigsThaddius.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsThaddius:OnEnable()
	self.enrageStarted = nil
	self.addsdead = 0
	self.teslawarn = nil
	self.stage1warn = nil
	self.previousCharge = ""

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "PolarityCast")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "PolarityCast")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ThaddiusPolarity", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "StalaggPower", 4)
end

function BigWigsThaddius:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if msg == L["stalaggtrigger"] then
		self:TriggerEvent("BigWigs_SendSync", "StalaggPower")
	end
end

function BigWigsThaddius:CHAT_MSG_MONSTER_YELL( msg )
	if string.find(msg, L["pstrigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "ThaddiusPolarity")
	elseif msg == L["starttrigger"] or msg == L["starttrigger1"] then
		if self.db.profile.phase and not self.stage1warn then
			self:TriggerEvent("BigWigs_Message", L["startwarn"], "Important")
		end
		self.stage1warn = true
		self:Throw()
		self:ScheduleRepeatingEvent( "bwthaddiusthrow", self.Throw, 21, self )
	elseif string.find(msg, L["starttrigger2"]) or string.find(msg, L["starttrigger3"]) or string.find(msg, L["starttrigger4"]) then
		if self.db.profile.phase then self:TriggerEvent("BigWigs_Message", L["startwarn2"], "Important") end
		if self.db.profile.enrage then
			self:TriggerEvent("BigWigs_StartBar", self, L["enragebartext"], 300, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
			self:ScheduleEvent("bwthaddiuswarn1", "BigWigs_Message", 120, L["warn1"], "Attention")
			self:ScheduleEvent("bwthaddiuswarn2", "BigWigs_Message", 210, L["warn2"], "Attention")
			self:ScheduleEvent("bwthaddiuswarn3", "BigWigs_Message", 240, L["warn3"], "Urgent")
			self:ScheduleEvent("bwthaddiuswarn4", "BigWigs_Message", 270, L["warn4"], "Important")
			self:ScheduleEvent("bwthaddiuswarn5", "BigWigs_Message", 290, L["warn5"], "Important")
		end
	end
end

function BigWigsThaddius:CHAT_MSG_MONSTER_EMOTE( msg )
	if msg == L["enragetrigger"] then
		if self.db.profile.enrage then self:TriggerEvent("BigWigs_Message", L["enragewarn"], "Important") end
		self:TriggerEvent("BigWigs_StopBar", self, L["enragebartext"])
		self:CancelScheduledEvent("bwthaddiuswarn1")
		self:CancelScheduledEvent("bwthaddiuswarn2")
		self:CancelScheduledEvent("bwthaddiuswarn3")
		self:CancelScheduledEvent("bwthaddiuswarn4")
		self:CancelScheduledEvent("bwthaddiuswarn5")
	elseif msg == L["adddeath"] then
		self.addsdead = self.addsdead + 1
		if self.addsdead == 2 then
			if self.db.profile.phase then self:TriggerEvent("BigWigs_Message", L["addsdownwarn"], "Attention") end
			self:CancelScheduledEvent("bwthaddiusthrow")
			self:CancelScheduledEvent("bwthaddiusthrowwarn")
		end
	elseif msg == L["teslaoverload"] and self.db.profile.phase and not self.teslawarn then
		self.teslawarn = true
		self:TriggerEvent("BigWigs_Message", L["thaddiusincoming"], "Important")
	end
end

function BigWigsThaddius:PolarityCast( msg )
	if self.db.profile.polarity and string.find(msg, L["trigger1"]) then
		self:TriggerEvent("BigWigs_Message", L["pswarn1"], "Important")
	end
end

function BigWigsThaddius:PLAYER_AURAS_CHANGED( msg )
	local chargetype = nil
	local iIterator = 1
	while UnitDebuff("player", iIterator) do
		local _,_,texture, applications = UnitDebuff("player", iIterator)
		if texture == L["positivetype"] or texture == L["negativetype"] then
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
		if self.previousCharge and self.previousCharge == chargetype then
			self:TriggerEvent("BigWigs_Message", L["nochange"], "Urgent", true, "Alarm")
		elseif chargetype == L["positivetype"] then
			self:TriggerEvent("BigWigs_Message", L["poswarn"], "Positive", true, "Alarm")
		elseif chargetype == L["negativetype"] then
			self:TriggerEvent("BigWigs_Message", L["negwarn"], "Important", true, "Alarm")
		end
		self:TriggerEvent("BigWigs_StartBar", self, L["polaritytickbar"], 6, chargetype, "Important")
	end
	self.previousCharge = chargetype
end

function BigWigsThaddius:BigWigs_RecvSync( sync )
	if sync == "ThaddiusPolarity" and self.db.profile.polarity then
		self:RegisterEvent("PLAYER_AURAS_CHANGED")
		self:ScheduleEvent("BigWigs_Message", 27, L["pswarn3"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["bar1text"], 30, "Interface\\Icons\\Spell_Nature_Lightning")
	elseif sync == "StalaggPower" and self.db.profile.power then
		self:TriggerEvent("BigWigs_Message", L["stalaggwarn"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["powersurgebar"], 10, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
	end
end

function BigWigsThaddius:Throw()
	if self.db.profile.throw then
		self:TriggerEvent("BigWigs_StartBar", self, L["throwbar"], 20, "Interface\\Icons\\Ability_Druid_Maul")
		self:ScheduleEvent("bwthaddiusthrowwarn", "BigWigs_Message", 15, L["throwwarn"], "Urgent")
	end
end
