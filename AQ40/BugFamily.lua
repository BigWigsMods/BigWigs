BigWigsBugFamily = AceAddon:new({
	name          = "BigWigsBugFamily",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = { "Lord Kri", "Princess Yauj", "Vem" },

	loc = {
		bossname = "Bug Family, Kri Yauj Vem",
		bossnamekri = "Lord Kri",
		bossnameyauj = "Princess Yauj",
		bossnamevem = "Vem",

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
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
end


function BigWigsBugFamily:Disable()
	self.disabled = true
	self:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
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
