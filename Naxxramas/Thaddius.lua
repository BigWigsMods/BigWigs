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
	pswarn1 = "Thaddius begins to cast Polarity Shift!",
	pswarn2 = "30 seconds till next Polarity Shift!",
	pswarn3 = "3 seconds before Thaddius casts Polarity Shift!",
	poswarn = "You are a Positive Charge!",
	negwarn = "You are a Negative Charge!",
	enragebartext = "Enrage",
	warn1 = "Enrage in 3 minutes",
	warn2 = "Enrage in 90 seconds",
	warn3 = "Enrage in 60 seconds",
	warn4 = "Enrage in 30 seconds",
	warn5 = "Enrage in 10 seconds",
	stalaggwarn = "Power Surge",

	bar1text = "PolarityShift",
	
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
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "ChargeEvent")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ThaddiusPolarity", 10)
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
	if self.db.profile.power and msg == L"stalaggtrigger" then
		self:TriggerEvent("BigWigs_Message", L"stalaggwarn", "Red")
	end
end

function BigWigsThaddius:CHAT_MSG_MONSTER_YELL( msg )
	if string.find(msg, L"pstrigger") then
		self:TriggerEvent("BigWigs_SendSync", "ThaddiusPolarity")
	elseif msg == L"starttrigger" or msg == L"starttrigger1" then
		if self.db.profile.phase then self:TriggerEvent("BigWigs_Message", L"startwarn", "Red") end
	elseif msg == L"starttrigger2" or msg == L"starttrigger3" then
		if self.db.profile.phase then self:TriggerEvent("BigWigs_Message", L"startwarn2", "Red") end
		if self.db.profile.enrage then
			self:TriggerEvent("BigWigs_StartBar", self, L"enragebartext", 300, 2, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy", "Green", "Yellow", "Orange", "Red")
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
	if (msg == L"enragetrigger") then
		if self.db.profile.enrage then self:TriggerEvent("BigWigs_Message", L"enragewarn", "Red") end
		self:TriggerEvent("BigWigs_StopBar", self, L"enragebartext")
		self:CancelScheduledEvent("bwthaddiuswarn1")
		self:CancelScheduledEvent("bwthaddiuswarn2")
		self:CancelScheduledEvent("bwthaddiuswarn3")
		self:CancelScheduledEvent("bwthaddiuswarn4")
		self:CancelScheduledEvent("bwthaddiuswarn5")
	end
end

function BigWigsThaddius:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE( msg )
	if self.db.profile.polarity and string.find(msg, L"trigger1") then
		self:TriggerEvent("BigWigs_Message", L"pswarn1", "Red")
	end
end

function BigWigsThaddius:BigWigs_RecvSync( sync )
	if sync == "ThaddiusPolarity" and self.db.profile.polarity then
		self:TriggerEvent("BigWigs_Message", L"pswarn2", "Yellow")
		self:ScheduleEvent("BigWigs_Message", 27, L"pswarn3", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L"bar1text", 30, 1, "Interface\\Icons\\Spell_Nature_Lightning", "Yellow", "Orange", "Red")
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
