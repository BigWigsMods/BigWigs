BigWigsFankriss = AceAddon:new({
	name          = "BigWigsFankriss",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = "Fankriss the Unyielding",

	loc = {	
		bossname = "Fankriss the Unyielding",
		disabletrigger = "Fankriss the Unyielding dies.",		
		bosskill = "Fankriss the Unyielding has been defeated!",

		wormtrigger = "Fankriss the Unyielding casts Summon Worm.",
		wormwarn = "Incoming Worm - Kill it!",
	},
})

function BigWigsFankriss:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsFankriss:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsFankriss:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsFankriss:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsFankriss:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if (arg1 == self.loc.wormtrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.wormwarn, "Orange")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsFankriss:RegisterForLoad()