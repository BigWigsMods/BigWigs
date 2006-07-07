local bboss = BabbleLib:GetInstance("Boss 1.2")
local metro = Metrognome:GetInstance("1")

BigWigsRazuvious = AceAddon:new({
	name          = "BigWigsRazuvious",
	cmd           = AceChatCmd:new({}, {}),

	zonename 		= BabbleLib:GetInstance("Zone 1.2")("Naxxramas"),
	enabletrigger 	= bboss("Instructor Razuvious"),
	bossname 		= bboss("Instructor Razuvious"),

	toggleoptions = GetLocale() == "koKR" and {
		notShoutWarn 		= "분열의 외침 경고",
		notShoutBar 		= "분열의 외침 타이머바 보이기",
		notBosskill 		= "보스 사망 알림",
	} or {
		notShoutWarn 		= "Warn when Razuvious uses Disrupting Shout",
		notShoutBar 		= "Show the Time Bar for Disrupting Shout",
		notBosskill 		= "Boss death",
	},
	optionorder = {"notShoutWarn", "notShoutBar", "notBosskill"},
	
	loc = GetLocale() == "koKR" and {
		disabletrigger 	= "훈련교관 라주비어스|1이;가; 죽었습니다.", 		
		bosskill 		= "라주비어스를 물리쳤습니다!",
		
		startwarn 		= "훈련교관 라주비어스 광푝화! 외침까지 25초!",
	
		starttrigger1 	= "훈련은 끝났다!",
		starttrigger2 	= "다리를 후려 차라! 무슨 문제 있나?",
		starttrigger3 	= "절대 봐주지 마라!",
		starttrigger4 	= "훈련받은 대로 해!",		

		shouttrigger 	= "훈련교관 라주비어스|1이;가; 분열의 외침|1으로;로; (.+)에게 (.+)의 피해를 입혔습니다.",
		shout7secwarn 	= "7초후 분열의 외침",
		shoutwarn 		= "분열의 외침!",
		shoutbar 		= "분열의 외침",
	} or {
		disabletrigger 	= "Instructor Razuvious dies.",		
		bosskill 		= "Razuvious has been defeated!",
		
		startwarn 		= "Instructor Razuvious engaged!, ~25secs until shout!",
	
		starttrigger1 	= "The time for practice is over! Show me what you have learned!",
		starttrigger2 	= "Sweep the leg... Do you have a problem with that?",
		starttrigger3 	= "Show them no mercy!",
		starttrigger4 	= "Do as I taught you!",

		shouttrigger 	= "Instructor Razuvious's Disrupting Shout hits (.+) for (.+)",
		shout7secwarn 	= "7 seconds until Disrupting Shout",
		shoutwarn 		= "Disrupting Shout!",
		shoutbar 		= "Disrupting Shout",
	},
	timeShout = 25
})

function BigWigsRazuvious:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsRazuvious:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Shout")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Shout")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Shout")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("BIGWIGS_MESSAGE")
	self:RegisterEvent("BIGWIGS_SYNC_SHOUTWARN")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "SHOUTWARN", 5)
	metro:Register("BigWigs_Razuvious_CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)
	metro:Unregister("BigWigs Razuvious Shout")
	metro:Register("BigWigs Razuvious Shout", self.BIGWIGS_SYNC_SHOUTWARN, self.timeShout, self )
end

function BigWigsRazuvious:Disable()
	self.disabled = true
	metro:Unregister("BigWigs Razuvious Shout")
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.shoutbar)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.shout7secwarn)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.shoutbar, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.shoutbar, 18)
	self.prior = nil
end

function BigWigsRazuvious:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if (not self:GetOpt("notBosskill")) then 
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory!")
		end
		self:Disable()
	end
end

function BigWigsRazuvious:BIGWIGS_SYNC_SHOUTWARN()
	if (not self:GetOpt("notShoutWarn")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.shoutwarn, "Orange")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.shout7secwarn, 18, "Yellow")
	end
	if (not self:GetOpt("notShoutBar")) then
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.shoutbar, 25, 1, "Yellow", "Interface\\Icons\\Ability_Warrior_WarCry")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.shoutbar, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.shoutbar, 18, "Red")
	end
	self.prior = true
end 

function BigWigsRazuvious:Shout()
	if (string.find(arg1, self.loc.shouttrigger) and not self.prior) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "SHOUTWARN")
		metro:Stop("BigWigs Razuvious Shout")
		metro:Start("BigWigs Razuvious Shout")
	end
end

function BigWigsRazuvious:CHAT_MSG_MONSTER_YELL()
	if (arg1 == self.loc.starttrigger1 or arg1 == self.loc.starttrigger2 or arg1 == self.loc.starttrigger3 or arg1 == self.loc.starttrigger4) then
		if (not self:GetOpt("notShoutWarn")) then 
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.startwarn, "Orange") 
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.shout7secwarn, 18, "Yellow") 
		end
		if (not self:GetOpt("notShoutBar")) then 
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.shoutbar, 25, 1, "Yellow", "Interface\\Icons\\Ability_Warrior_WarCry")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.shoutbar, 10, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.shoutbar, 18, "Red")
		end
	metro:Start("BigWigs Razuvious Shout")
	end
end

function BigWigsRazuvious:PLAYER_REGEN_ENABLED()
	local go = self:Scan()
	local _,_,running,_ = metro:Status("BigWigs_Razuvious_CheckWipe")
	if (not go) then
		metro:Stop("BigWigs Razuvious Shout")
		metro:Stop("BigWigs_Razuvious_CheckWipe")
	elseif (not running) then
		metro:Start("BigWigs_Razuvious_CheckWipe")
	end
end

function BigWigsRazuvious:Scan()
	if (UnitName("target") == (self.bossname) and UnitAffectingCombat("target")) then
		return true
	elseif (UnitName("playertarget") == (self.bossname) and UnitAffectingCombat("playertarget")) then
		return true
	else
		local i
		for i = 1, GetNumRaidMembers(), 1 do
			if (UnitName("Raid"..i.."target") == (self.bossname) and UnitAffectingCombat("Raid"..i.."target")) then
				return true
			end
		end
	end
	return false
end


function BigWigsRazuvious:BIGWIGS_MESSAGE(text)
	if text == self.loc.shout7secwarn then self.prior = nil end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsRazuvious:RegisterForLoad()