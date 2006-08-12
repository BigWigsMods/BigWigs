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

	enragetrigger = "goes into a berserker rage!",
	starttrigger = "Stalagg crush you!",
	starttrigger1 = "Feed you to master!",
	starttrigger2 = "Eat... your... bones...",
	starttrigger3 = "Break... you!!",
	starttrigger4 = "Kill...",
	
	adddeath = "dies.",
	teslaoverload = "overloads!",

	pstrigger = "Now you feel pain...",
	trigger1 = "Thaddius begins to cast Polarity Shift",
	chargetrigger = "^([^%s]+) ([^%s]+) afflicted by ([^%s]+) Charge",
	positivetype = "Positive",
	negativetype = "Negative",
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
	poswarn = "You are a Positive Charge!",
	negwarn = "You are a Negative Charge!",
	enragebartext = "Enrage",
	warn1 = "Enrage in 3 minutes",
	warn2 = "Enrage in 90 seconds",
	warn3 = "Enrage in 60 seconds",
	warn4 = "Enrage in 30 seconds",
	warn5 = "Enrage in 10 seconds",
	stalaggwarn = "Power Surge, extra healing on tank!",

	bar1text = "Polarity Shift",
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
	
	adddeath = "死亡了。",
	teslaoverload = "超负荷！",

	pstrigger = "你感受到痛苦的滋味了吧……",
	trigger1 = "塔迪乌斯开始施放极性转化。",
	chargetrigger = "^(.+)受(.+)了(.+)电荷",
	positivetype = "正",
	negativetype = "负",
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
	stalaggwarn = "力量振荡",

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

-- TODO: Add sync'ing for Stalagg's Power Surge.

function BigWigsThaddius:OnEnable()
	self.enrageStarted = nil
	self.addsdead = 0
	self.teslawarn = nil
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "PolarityCast")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "PolarityCast")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "ChargeEvent")

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
	if msg == L"pstrigger" then
		self:TriggerEvent("BigWigs_SendSync", "ThaddiusPolarity")
	elseif msg == L"starttrigger" or msg == L"starttrigger1" then
		if self.db.profile.phase then self:TriggerEvent("BigWigs_Message", L"startwarn", "Red") end
	elseif msg == L"starttrigger2" or msg == L"starttrigger3" or msg == L"starttrigger4" then
		if self.db.profile.phase then self:TriggerEvent("BigWigs_Message", L"startwarn2", "Red") end
		if self.db.profile.enrage then
			self:TriggerEvent("BigWigs_StartBar", self, L"enragebartext", 300, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy", "Green", "Yellow", "Orange", "Red")
			self:ScheduleEvent("bwthaddiuswarn1", "BigWigs_Message", 120, L"warn1", "Green")
			self:ScheduleEvent("bwthaddiuswarn2", "BigWigs_Message", 210, L"warn2", "Yellow")
			self:ScheduleEvent("bwthaddiuswarn3", "BigWigs_Message", 240, L"warn3", "Orange")
			self:ScheduleEvent("bwthaddiuswarn4", "BigWigs_Message", 270, L"warn4", "Red")
			self:ScheduleEvent("bwthaddiuswarn5", "BigWigs_Message", 290, L"warn5", "Red")
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
	if msg == L"enragetrigger" then
		if self.db.profile.enrage then self:TriggerEvent("BigWigs_Message", L"enragewarn", "Red") end
		self:TriggerEvent("BigWigs_StopBar", self, L"enragebartext")
		self:CancelScheduledEvent("bwthaddiuswarn1")
		self:CancelScheduledEvent("bwthaddiuswarn2")
		self:CancelScheduledEvent("bwthaddiuswarn3")
		self:CancelScheduledEvent("bwthaddiuswarn4")
		self:CancelScheduledEvent("bwthaddiuswarn5")
	elseif msg == L"adddeath" then
		self.addsdead = self.addsdead + 1
		if self.addsdead == 2 and self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L"addsdownwarn", "Yellow")
		end
	elseif msg == L"teslaoverload" and self.db.profile.phase and not self.teslawarn then
		self.teslawarn = true
		self:TriggerEvent("BigWigs_Message", L"thaddiusincoming", "Red")
	end
end

function BigWigsThaddius:PolarityCast( msg )
	if self.db.profile.polarity and string.find(msg, L"trigger1") then
		self:TriggerEvent("BigWigs_Message", L"pswarn1", "Red")
	end
end

function BigWigsThaddius:BigWigs_RecvSync( sync )
	if sync == "ThaddiusPolarity" and self.db.profile.polarity then
		self:TriggerEvent("BigWigs_Message", L"pswarn2", "Yellow")
		self:ScheduleEvent("BigWigs_Message", 27, L"pswarn3", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L"bar1text", 30, "Interface\\Icons\\Spell_Nature_Lightning", "Yellow", "Orange", "Red")
    elseif sync == "StalaggPower" and self.db.profile.power then
        self:TriggerEvent("BigWigs_Message", L"stalaggwarn", "Red")
	end
end

function BigWigsThaddius:ChargeEvent( msg )
	if not self.db.profile.charge then return end

	local _, _, playername, playertype, chargetype = string.find(msg, L"chargetrigger")
	if playername and playertype and chargetype and playername == L"you" then
		if chargetype == L"positivetype" then
			self:TriggerEvent("BigWigs_Message", L"poswarn", "Green", true)
		else
			self:TriggerEvent("BigWigs_Message", L"negwarn", "Red", true)
		end
	end
end
