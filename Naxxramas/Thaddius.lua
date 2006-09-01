------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Thaddius")
local feugen = AceLibrary("Babble-Boss-2.0")("Feugen")
local stalagg = AceLibrary("Babble-Boss-2.0")("Stalagg")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "thaddius",

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

	enragetrigger = "变得极度狂暴而愤怒！",
	starttrigger = "斯塔拉格要碾碎你！",
	starttrigger1 = "主人要吃了你！",
	starttrigger2 = "咬碎……你的……骨头……",
	starttrigger3 = "打……烂……你！",
	starttrigger4 = "杀……",
	
	adddeath = "死亡了。",
	teslaoverload = "超负荷！",

	pstrigger = "你感受到痛苦的滋味了吧……",
	trigger1 = "塔迪乌斯开始施放极性转化。",
	chargetrigger = "^(.+)受(.+)了(.+)电荷",
	stalaggtrigger = "斯塔拉格获得了力量振荡的效果。",

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
	enragebartext = "激怒",
	warn1 = "3分钟后激怒",
	warn2 = "90秒后激怒",
	warn3 = "60秒后激怒",
	warn4 = "30秒后激怒",
	warn5 = "10秒后激怒",
	stalaggwarn = "力量振荡！加大对坦克的治疗！",
	powersurgebar = "力量振荡",

	bar1text = "极性转化",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsThaddius = BigWigs:NewModule(boss)
BigWigsThaddius.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsThaddius.enabletrigger = { boss, feugen, stalagg }
BigWigsThaddius.toggleoptions = {"enrage", "charge", "polarity", "power", "phase", "bosskill"}
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
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "PolarityCast")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "PolarityCast")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ThaddiusPolarity", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "StalaggPower", 4)
end

function BigWigsThaddius:Scan()
	if ( (UnitName("target") == boss or UnitName("target") == feugen or UnitName("target") == stalagg) and UnitAffectingCombat("target")) then
		return true
	elseif ((UnitName("playertarget") == boss or UnitName("playertarget") == feugen or UnitName("playertarget") == stalagg) and UnitAffectingCombat("playertarget")) then
		return true
	else
		local i
		for i = 1, GetNumRaidMembers(), 1 do
			if ( (UnitName("raid"..i.."target") == boss or UnitName("raid"..i.."target") == feugen or UnitName("raid"..i.."target") == stalagg) and UnitAffectingCombat("raid"..i.."target")) then
				return true
			end
		end
	end
	return false
end

function BigWigsThaddius:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if msg == L"stalaggtrigger" then
		self:TriggerEvent("BigWigs_SendSync", "StalaggPower")
	end
end

function BigWigsThaddius:CHAT_MSG_MONSTER_YELL( msg )
	if msg == L["pstrigger"] then
		self:TriggerEvent("BigWigs_SendSync", "ThaddiusPolarity")
	elseif msg == L["starttrigger"] or msg == L["starttrigger1"] then
		if self.db.profile.phase and not self.stage1warn then
			self:TriggerEvent("BigWigs_Message", L["startwarn"], "Red")
		end
		self.stage1warn = true
	elseif msg == L["starttrigger2"] or msg == L["starttrigger3"] or msg == L["starttrigger4"] then
		if self.db.profile.phase then self:TriggerEvent("BigWigs_Message", L["startwarn2"], "Red") end
		if self.db.profile.enrage then
			self:TriggerEvent("BigWigs_StartBar", self, L["enragebartext"], 300, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy", "Green", "Yellow", "Orange", "Red")
			self:ScheduleEvent("bwthaddiuswarn1", "BigWigs_Message", 120, L["warn1"], "Green")
			self:ScheduleEvent("bwthaddiuswarn2", "BigWigs_Message", 210, L["warn2"], "Yellow")
			self:ScheduleEvent("bwthaddiuswarn3", "BigWigs_Message", 240, L["warn3"], "Orange")
			self:ScheduleEvent("bwthaddiuswarn4", "BigWigs_Message", 270, L["warn4"], "Red")
			self:ScheduleEvent("bwthaddiuswarn5", "BigWigs_Message", 290, L["warn5"], "Red")
		end
	end
end

function BigWigsThaddius:PLAYER_REGEN_ENABLED()
	local go = self:Scan()
	local running = self:IsEventScheduled("Thaddius_CheckWipe")
	if (not go) then
		self:TriggerEvent("BigWigs_RebootModule", self)
	elseif (not running) then
		self:ScheduleRepeatingEvent("Thaddius_CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)
	end
end

function BigWigsThaddius:CHAT_MSG_MONSTER_EMOTE( msg )
	if msg == L["enragetrigger"] then
		if self.db.profile.enrage then self:TriggerEvent("BigWigs_Message", L["enragewarn"], "Red") end
		self:TriggerEvent("BigWigs_StopBar", self, L["enragebartext"])
		self:CancelScheduledEvent("bwthaddiuswarn1")
		self:CancelScheduledEvent("bwthaddiuswarn2")
		self:CancelScheduledEvent("bwthaddiuswarn3")
		self:CancelScheduledEvent("bwthaddiuswarn4")
		self:CancelScheduledEvent("bwthaddiuswarn5")
	elseif msg == L["adddeath"] then
		self.addsdead = self.addsdead + 1
		if self.addsdead == 2 and self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["addsdownwarn"], "Yellow")
		end
	elseif msg == L["teslaoverload"] and self.db.profile.phase and not self.teslawarn then
		self.teslawarn = true
		self:TriggerEvent("BigWigs_Message", L["thaddiusincoming"], "Red")
	end
end

function BigWigsThaddius:PolarityCast( msg )
	if self.db.profile.polarity and string.find(msg, L["trigger1"]) then
		self:TriggerEvent("BigWigs_Message", L["pswarn1"], "Red")
	end
end

function BigWigsThaddius:PLAYER_AURAS_CHANGED( msg )
	local chargetype = nil
	local iIterator = 1
	while UnitDebuff("player", iIterator) do
		local texture, applications = UnitDebuff("player", iIterator)
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
		if self.previousCharge == chargetype then
			self:TriggerEvent("BigWigs_Message", L["nochange"], "Orange", true)
		elseif chargetype == L"positivetype" then
			self:TriggerEvent("BigWigs_Message", L["poswarn"], "Green", true, "Alarm")
		elseif chargetype == L"negativetype" then
			self:TriggerEvent("BigWigs_Message", L["negwarn"], "Red", true, "Alarm")
		end
		self:TriggerEvent("BigWigs_StartBar", self, L["polaritytickbar"], 6, chargetype, "Red")
	end
	self.previousCharge = chargetype
end

function BigWigsThaddius:BigWigs_RecvSync( sync )
	if sync == "ThaddiusPolarity" and self.db.profile.polarity then
		self:RegisterEvent("PLAYER_AURAS_CHANGED")
		self:ScheduleEvent("BigWigs_Message", 27, L["pswarn3"], "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L["bar1text"], 30, "Interface\\Icons\\Spell_Nature_Lightning", "Yellow", "Orange", "Red")
	elseif sync == "StalaggPower" and self.db.profile.power then
		self:TriggerEvent("BigWigs_Message", L["stalaggwarn"], "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L["powersurgebar"], 10, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy", "Red")
	end
end

