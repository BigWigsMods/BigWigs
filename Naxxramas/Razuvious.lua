------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Instructor Razuvious")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "razuvious",

	shout_cmd = "shout",
	shout_name = "Shout Alert",
	shout_desc = "Warn for disrupting shout",

	shieldwall_cmd = "shieldwall",
	shieldwall_name = "Shield Wall Timer",
	shieldwall_desc = "Show timer for shieldwall",

	startwarn	= "Instructor Razuvious engaged!, ~25secs until shout!",

	starttrigger1 	= "The time for practice is over! Show me what you have learned!",
	starttrigger2 	= "Sweep the leg... Do you have a problem with that?",
	starttrigger3 	= "Show them no mercy!",
	starttrigger4 	= "Do as I taught you!",

	shouttrigger 	= "Disrupting Shout",
	shout7secwarn 	= "7 seconds until Disrupting Shout",
	shoutwarn 		= "Disrupting Shout!",
	noshoutwarn		= "No shout! next in ~20secs",
	shoutbar 		= "Disrupting Shout",

	shieldwalltrigger   = "Deathknight Understudy gains Shield Wall.",
	shieldwallbar       = "Shield Wall",	

} end )

L:RegisterTranslations("deDE", function() return {
	startwarn = "Razuvious engaged! ~25 s bis Shout",
	
	starttrigger1 = "Die Zeit des \195\156bens ist vorbei! Zeigt mir, was ihr gelernt habt!",
	starttrigger2 = "Streckt sie nieder... oder habt ihr ein Problem damit?",
	starttrigger3 = "Lasst keine Gnade walten!",
	starttrigger4 = "Befolgt meine Befehle!",

	shouttrigger = "Unterbrechungsruf",
	shout7secwarn = "7 Sekunden bis Ruf!",
	shoutwarn = "Unterbrechungsruf!",
	noshoutwarn = "Kein Ruf! N\195\164chster in ~20s",
	shoutbar = "Unterbrechungsruf",

	shieldwalltrigger   = "Reservist der Todesritter bekommt 'Schildwall'.",
	shieldwallbar       = "Schildwall",	
} end )

L:RegisterTranslations("koKR", function() return {
	startwarn 		= "훈련교관 라주비어스 광푝화! 외침까지 25초!",

	starttrigger1 	= "훈련은 끝났다!",
	starttrigger2 	= "다리를 후려 차라! 무슨 문제 있나?",
	starttrigger3 	= "절대 봐주지 마라!",
	starttrigger4 	= "훈련받은 대로 해!",		

	shouttrigger 	= "훈련교관 라주비어스|1이;가; 분열의 외침|1으로;로; (.+)에게 (.+)의 피해를 입혔습니다.",
	shout7secwarn 	= "7초후 분열의 외침",
	shoutwarn 		= "분열의 외침!",
	shoutbar 		= "분열의 외침",
} end )


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsRazuvious = BigWigs:NewModule(boss)
BigWigsRazuvious.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsRazuvious.enabletrigger = boss
BigWigsRazuvious.toggleoptions = {"shout", "shieldwall", "bosskill"}
BigWigsRazuvious.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsRazuvious:OnEnable()
	self.timeShout = 30
	self.prior = nil
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Shout")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Shout")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Shout")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS", "Shieldwall")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")

	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "RazuviousShout", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "RazuviousNoShout", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "RazuviousShieldwall", 5)
end

function BigWigsRazuvious:CHAT_MSG_MONSTER_YELL( msg )
	if msg == L"starttrigger1" or msg == L"starttrigger2" or msg == L"starttrigger3" or msg == L"starttrigger4" then
		if self.db.profile.shout then
			self:TriggerEvent("BigWigs_Message", L"startwarn", "Orange", nil, "Alarm")
			self:ScheduleEvent("bwrazuviousshout", "BigWigs_Message", 18, L"shout7secwarn", "Yellow", nil, "Alert")
			self:TriggerEvent("BigWigs_StartBar", self, L"shoutbar", 25, 1, "Interface\\Icons\\Ability_Warrior_WarCry", "Yellow", "Orange", "Red")
		end
		self:ScheduleEvent("bwrazuviousnoshout", self.noShout, self.timeShout, self )
	end
end

function BigWigsRazuvious:BigWigs_Message(text)
	if text == L"shout7secwarn" then self.prior = nil end
end

function BigWigsRazuvious:Shieldwall( msg ) 
	if string.find(msg, L"shieldwalltrigger") then
		self:TriggerEvent("BigWigs_SendSync", "RazuviousShieldwall")
	end
end

function BigWigsRazuvious:Shout( msg )
	if string.find(msg, L"shouttrigger") and not self.prior then
		self:TriggerEvent("BigWigs_SendSync", "RazuviousShout")
		self:CancelScheduledEvent("bwrazuviousnoshout")
		self:ScheduleEvent("bwrazuviousnoshout", self.noShout, self.timeShout, self )
	end
end

function BigWigsRazuvious:noShout()	
	self:CancelScheduledEvent("bwrazuviousnoshout")
	self:ScheduleEvent("bwrazuviousnoshout", self.noShout, self.timeShout, self )
	self:TriggerEvent("BigWigs_SendSync", "RazuviousNoShout")
end

function BigWigsRazuvious:BigWigs_RecvSync( sync )
	if sync == "RazuviousShout" then
		if self.db.profile.shout then
			self:TriggerEvent("BigWigs_Message", L"shoutwarn", "Orange", nil, "Alarm")
			self:ScheduleEvent("bwrazuviousshout", "BigWigs_Message", 18, L"shout7secwarn", "Yellow", nil, "Alert")
			self:TriggerEvent("BigWigs_StartBar", self, L"shoutbar", 25, 1, "Interface\\Icons\\Ability_Warrior_WarCry", "Yellow", "Orange", "Red" )
		end
		self.prior = true
	elseif sync == "RazuviousNoShout" then
		if self.db.profile.shout then
			self:TriggerEvent("BigWigs_Message", L"noshoutwarn", "Yellow")
			self:ScheduleEvent("bwrazuviousshout", "BigWigs_Message", 13, L"shout7secwarn", "Yellow", nil, "Alert")
			self:TriggerEvent("BigWigs_StartBar", self, L"shoutbar", 20, 1, "Interface\\Icons\\Ability_Warrior_WarCry", "Yellow", "Orange", "Red")
		end
		self.prior = true
	elseif sync == "RazuviousShieldwall" then
		if self.db.profile.shieldwall then
			self:TriggerEvent("BigWigs_StartBar", self, L"shieldwallbar", 20, 2, "Interface\\Icons\\Ability_Warrior_ShieldWall", "Yellow", "Orange", "Red")
		end
	end
end

function BigWigsRazuvious:PLAYER_REGEN_ENABLED()
	local go = self:Scan()
	local running = self:IsEventScheduled("Razuvious_CheckWipe")
	if (not go) then
		self:TriggerEvent("BigWigs_RebootModule", self)
	elseif (not running) then
		self:ScheduleRepeatingEvent("Razuvious_CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)
	end
end

function BigWigsRazuvious:Scan()
	if (UnitName("target") == (boss) and UnitAffectingCombat("target")) then
		return true
	elseif (UnitName("playertarget") == (boss) and UnitAffectingCombat("playertarget")) then
		return true
	else
		local i
		for i = 1, GetNumRaidMembers(), 1 do
			if (UnitName("Raid"..i.."target") == (boss) and UnitAffectingCombat("Raid"..i.."target")) then
				return true
			end
		end
	end
	return false
end
