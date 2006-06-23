BigWigsAnubrekhan = AceAddon:new({
	name          = "BigWigsAnubrekhan",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "Naxxramas",
	enabletrigger = "Anub'Rekhan",

	loc = { 
		bossname = "Anub'Rekhan",
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
	BigWigs:RegisterModule(self)
end

function BigWigsAnubrekhan:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
end

function BigWigsAnubrekhan:Disable()
	self.disabled = true

	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.locustwarn10sec)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.locustincbar)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.swarmendwarn)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.locustbar)

	self:UnregisterAllEvents()
end

function BigWigsAnubrekhan:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory")
		self:Disable()
	end
end

function BigWigsAnubrekhan:CHAT_MSG_MONSTER_YELL()
	if (arg1 == self.loc.starttrigger1 or arg1 == self.loc.starttigger2 or arg1 == self.loc.starttrigger3) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.startwarn, "Orange")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.locustwarn10sec, 80, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.locustincbar, 90, 1, "Yellow", "Interface\\Icons\\Spell_Nature_InsectSwarm")
	end
end

function BigWigsAnubrekhan:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (arg1 == self.loc.swarmbartrigger) then
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.swarmendwarn, 20, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.locustbar, 20, 1, "Yellow", "Interface\\Icons\\Spell_Nature_InsectSwarm")		
	end
end

function BigWigsAnubrekhan:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if (arg1 == self.loc.swarmtrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.locustwarn, "Orange")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.locustwarn10sec, 90, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.locustincbar, 100, 1, "Yellow", "Interface\\Icons\\Spell_Nature_InsectSwarm")		
	end
end


function BigWigsAnubrekhan:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if (arg1 == self.loc.wormtrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.wormwarn, "Orange")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsAnubrekhan:RegisterForLoad()
