BigWigsBugFamily = AceAddon:new({
	name          = "BigWigsBugFamily",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = { "Lord Kri", "Princess Yauj", "Vem" },

	loc = {
		bossname = "Bug Family - Lord Kri, Princess Yauj and Vem",
		disabletrigger1 = "Lord Kri dies.",
		disabletrigger2 = "Princess Yauj dies.",
		disabletrigger3 = "Vem dies.",
		bosskill = "The Bug Family has been defeated!",

		healtrigger = "Princess Yauj begins to cast Great Heal.",
		healwarn = "Casting heal - interrupt it!",
	},
})

function BigWigsBugFamily:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsBugFamily:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
end

function BigWigsBugFamily:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsBugFamily:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if ( arg1 == self.loc.disabletrigger1 
	or arg1 == self.loc.disabletrigger2
	or arg1 == self.loc.disabletrigger3 ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsBugFamily:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if ( arg1 == self.loc.healtrigger ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.healwarn, "Orange")
	end
end
--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsBugFamily:RegisterForLoad()