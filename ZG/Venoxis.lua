

BigWigsVenoxis = AceAddon:new({
	name          = "BigWigsVenoxis",
	cmd           = AceChatCmd:new({}, {}),

	loc = {
		trigger = "High Priest Venoxis gains Renew.",
		warn = "Renew - Dispel it now!",
	},
})


function BigWigsVenoxis:Enable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
end


function BigWigsVenoxis:Disable()
end


function BigWigsVenoxis:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if arg1 == self.loc.trigger then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn, "Orange")
	end
end


--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsVenoxis:RegisterForLoad()
