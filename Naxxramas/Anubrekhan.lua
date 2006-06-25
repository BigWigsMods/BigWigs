-- local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsAnubrekhan = AceAddon:new({
	name          = "BigWigsAnubrekhan",
	cmd           = AceChatCmd:new({}, {}),

--	zonename = BabbleLib:GetInstance("Zone 1.2")("Naxxramas"),
--	enabletrigger = bboss("Anub'Rekhan"),
--	bossname = bboss("Anub'Rekhan"),

	zonename = "Naxxramas",
	enabletrigger = "Anub'Rekhan",
	bossname = "Anub'Rekhan",

	toggleoptions = {
		notSwarmWarn = "Warn when the current Locust Swarm ends",
		notLocustInc = "Warn for the incoming Locust Swarm",
		notSwarmBar = "Show the Time Bar of the current Locust Swarm",
		notLocustIncBar = "Show the Time Bar for the incoming Locust Swarm",
		notBosskill = "Boss death",
	},
	optionorder = {"notLocustInc", "notLocustIncBar", "notSwarmWarn", "notSwarmBar", "notBosskill"},

	loc = { 
		disabletrigger = "Anub'Rekhan dies.",		
		bosskill = "Anub'Rekhan has been defeated!",

		starttrigger1 = "Just a little taste...",
		starttrigger2 = "Yes, run! It makes the blood pump faster!",
		starttrigger3 = "There is no way out.",

		swarmtrigger = "Anub'Rekhan begins to cast Locust Swarm.",
		locustwarn = "Incoming Locust Swarm!",
		locustwarn10sec = "10 Seconds until Locust Swarm",

		swarmbartrigger = "Anub'Rekhan gains Locust Swarm.",
		swarmendwarn = "Locust Swarm ended!",

		locustincbar = "Locust Swarm Incoming",
		locustbar = "Locust Swarm",
	},
})

function BigWigsAnubrekhan:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsAnubrekhan:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("BIGWIGS_SYNC_LOCUSTINC")
	self:RegisterEvent("BIGWIGS_SYNC_LOCUSTSWARM")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "LOCUSTINC", 10)
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "LOCUSTSWARM", 10)
end

function BigWigsAnubrekhan:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.locustwarn10sec)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.locustincbar)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.swarmendwarn)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.locustbar)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.locustbar, 5)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.locustbar, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.locustincbar, 65)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.locustincbar, 75)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.locustincbar, 80)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.locustincbar, 90)
end

function BigWigsAnubrekhan:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		 if (not self:GetOpt("notBosskill")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsAnubrekhan:CHAT_MSG_MONSTER_YELL()
	if (arg1 == self.loc.starttrigger1 or arg1 == self.loc.starttrigger2 or arg1 == self.loc.starttrigger3) then
		self:BIGWIGS_SYNC_LOCUSTINC()
	end
end

function BigWigsAnubrekhan:BIGWIGS_SYNC_LOCUSTINC()
	if (not self:GetOpt("notLocustInc")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.locustwarn, "Orange") end
	if (not self:GetOpt("notLocustIncBar")) then 
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.locustwarn10sec, 90, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.locustincbar, 100, 1, "Yellow", "Interface\\Icons\\Spell_Nature_InsectSwarm")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.locustincbar, 75, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.locustincbar, 90, "Red")
	end
end

function BigWigsAnubrekhan:BIGWIGS_SYNC_LOCUSTSWARM()
	if (not self:GetOpt("notSwarmWarn")) then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.swarmendwarn, 20, "Red") end
	if (not self:GetOpt("notSwarmBar")) then 
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.locustbar, 20, 1, "Yellow", "Interface\\Icons\\Spell_Nature_InsectSwarm")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.locustbar, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.locustbar, 5, "Red")
	end
end

function BigWigsAnubrekhan:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (arg1 == self.loc.swarmbartrigger) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "LOCUSTSWARM")
	end
end

function BigWigsAnubrekhan:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if (arg1 == self.loc.swarmtrigger) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "LOCUSTINC")
	end
end

--[[ Unused function, commenting out 
function BigWigsAnubrekhan:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if (arg1 == self.loc.wormtrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.wormwarn, "Orange")
	end
end
--]]
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsAnubrekhan:RegisterForLoad()