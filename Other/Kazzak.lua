local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsKazzak = AceAddon:new({
	name          = "BigWigsKazzak",
	cmd           = AceChatCmd:new({}, {}),
	
	zonename 		= "Outdoor Raid Bosses", BabbleLib:GetInstance("Zone 1.2")("Blasted Lands"),
	enabletrigger 	= bboss("Lord Kazzak"),
	bossname 		= bboss("Lord Kazzak"),

	toggleoptions = {
		notBossKill 	= "Boss Death",
		notSupremeWarn  = "Supreme warnings",
		notSupremeBar 	= "Supreme timerbar",
	},
	
	optionorder = {"notSupremeWarn", "notSupremeBar", "notBossKill"},
	
	loc = {
		starttrigger = "For the Legion! For Kil'Jaeden!",
		
		disabletrigger = "Lord Kazzak dies.",
		
		bosskill 	 = "Lord Kazzak has been defeated!",
		
		engagewarn	 = "Lord Kazzak engaged, 3mins until Supreme!",
		
		supreme1min	 = "Supreme mode in 1 minute!",
		supreme30sec = "Supreme mode in 30 seconds!",
		supreme10sec = "Supreme mode in 10 seconds!",
		
		bartext = "Supreme mode",
	},
})

function BigWigsKazzak:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsKazzak:Enable()
	self.disabled = nil
	self.supremetime = 180
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")	
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsKazzak:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.supreme1min)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.supreme30sec)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.supreme10sec)
	
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bartext, self.supremetime - 60)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bartext, self.supremetime - 30)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bartext, self.supremetime - 10)
	
	self.supremetime = nil
end

function BigWigsKazzak:CHAT_MSG_MONSTER_YELL()
	if (arg1 == self.loc.starttrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.engagewarn, "Red")
		
		if not self:GetOpt("notSupremeWarn") then
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.supreme1min, self.supremetime - 60, "Yellow")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.supreme30sec, self.supremetime - 30, "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.supreme10sec, self.supremetime - 10, "Red")
		end
		
		if not self:GetOpt("notSupremeBar") then
		
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bartext, self.supremetime, 1, "Green", "Interface\\Icons\\Spell_Shadow_ShadowWordPain")
 			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bartext, self.supremetime - 60, "Yellow")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bartext, self.supremetime - 30, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bartext, self.supremetime - 10, "Red")
		
		end
	end
end

function BigWigsKazzak:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger and not self:GetOpt("notBossKill")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory")
	end
	self:Disable()
end
-------------------------------
--     Load this bitch!      --
-------------------------------
BigWigsKazzak:RegisterForLoad()