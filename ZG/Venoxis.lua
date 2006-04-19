

BigWigsVenoxis = AceAddon:new({
	name          = "BigWigsVenoxis",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "ZG",
	enabletrigger = "High Priest Venoxis",

	loc = {
		bossname = "High Priest Venoxis",
		disabletrigger = "High Priest Venoxis dies.",

		trigger1 = "High Priest Venoxis gains Renew.",
		trigger2 = "Let the coils of hate unfurl!",

		warn1 = "Renew - Dispel it now!",
		warn2 = "Incoming phase 2, watch the poison clouds!",

		bosskill = "High Priest Venoxis has been defeated!",
	},
})


function BigWigsVenoxis:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end


function BigWigsVenoxis:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end


function BigWigsVenoxis:Disable()
	self.disabled = nil
	self:UnregisterAllEvents()
end


function BigWigsVenoxis:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if arg1 == self.loc.disabletrigger then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end


function BigWigsVenoxis:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if arg1 == self.loc.trigger1 then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Orange")
	end
end

function BigWigsVenoxis:CHAT_MSG_MONSTER_YELL()
	if string.find(arg1, self.loc.trigger2) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "Yellow")
	end
end

--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsVenoxis:RegisterForLoad()
