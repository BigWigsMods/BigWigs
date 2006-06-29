local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsRazuvious = AceAddon:new({
	name          = "BigWigsRazuvious",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Naxxramas"),
	enabletrigger = bboss("Instructor Razuvious"),
	bossname = bboss("Instructor Razuvious"),

	toggleoptions = {
		notShoutWarn = "Warn for Disrupting Shout",
		notShoutBar = "Show the timer bar for Disrupting Shout",
		notBosskill = "Boss death",
	},
	optionorder = {"notShoutWarn", "notShoutBar", "notBosskill"},

	loc = { 
		disabletrigger = "Instructor Razuvious dies.",		
		bosskill = "Razuvious has been defeated!",
		
		startwarn = "Instructor Razuvious engaged!",
		
		starttrigger1 = "The time for practice is over! Show me what you have learned!",
		starttrigger2 = "Sweep the leg... Do you have a problem with that?",
		starttrigger3 = "Show them no mercy!",
		starttrigger4 = "Do as I taught you!",

		shouttrigger = "Instructor Razuvious's Disrupting Shout hits (.+) for (.+)",
		shout7secwarn = "7 seconds until Disrupting Shout",
		shoutwarn = "Disrupting Shout",
		shoutbar = "Disrupting Shout",
	},
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
	self:RegisterEvent("BIGWIGS_MESSAGE")
end

function BigWigsRazuvious:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.shoutbar)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.shout7secwarn)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.shoutbar, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.shoutbar, 18)
	self.prior = nil
end

function BigWigsRazuvious:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if (not self:GetOpt("notBosskill")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsRazuvious:Shout()
	if (string.find(arg1, self.loc.shouttrigger) and not self.prior) then
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
	end
end

function BigWigsRazuvious:BIGWIGS_MESSAGE(text)
	if text == self.loc.shout7secwarn then self.prior = nil end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsRazuvious:RegisterForLoad()