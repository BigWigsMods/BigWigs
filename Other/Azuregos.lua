BigWigsAzuregos = AceAddon:new({
	name          = "BigWigsAzuregos",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "Azshara",
	enabletrigger = "Azuregos",

	loc = {
		bossname = "Azuregos",
		disabletrigger = "Azuregos dies.",

		trigger1 = "Come, little ones",
		trigger2 = "^Reflection fades from Azuregos",
		trigger3 = "^Azuregos gains Reflection",

		warn1 = "Teleport!",
		warn2 = "Magic Shield down!",
		warn3 = "Magic Shield up - Do not cast spells!",
		bosskill = "Azuregos has been defeated!",
	},
})

function BigWigsAzuregos:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsAzuregos:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsAzuregos:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsAzuregos:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsAzuregos:CHAT_MSG_MONSTER_YELL()
	if (string.find(arg1, self.loc.trigger1)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red")
	end
end

function BigWigsAzuregos:CHAT_MSG_SPELL_AURA_GONE_OTHER()
	if (string.find(arg1, self.loc.trigger2)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "White")
	end
end

function BigWigsAzuregos:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (string.find(arg1, self.loc.trigger3)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn3, "Red")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsAzuregos:RegisterForLoad()