BigWigsSkeram = AceAddon:new({
	name          = "BigWigsSkeram",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = "The Prophet Skeram",

	loc = {
		bossname = "The Prophet Skeram",
		disabletrigger = "The Prophet Skeram dies.",
		bosskill = "The Prophet Skeram has been defeated.",

		aetrigger = "The Prophet Skeram begins to cast Arcane Explosion.",
		mctrigger = "The Prophet Skeram begins to cast True Fulfillment.",
		aewarn = "Casting Arcane Explosion - interrupt it!",
		mcwarn = "Casting True Fulfillment - prepare to sheep!",
		mcplayer = "^([^%s]+) ([^%s]+) afflicted by True Fulfillment.$",
		mcplayerwarn = " is mindcontrolled! Sheep! Fear!",
		mcyou = "You",
		mcare = "are",
	},
})

function BigWigsSkeram:Initialize()
    self.disabled = true
    BigWigs:RegisterModule(self)
end

function BigWigsSkeram:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsSkeram:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsSkeram:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsSkeram:CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE()
	local _,_, Player, Type = string.find(arg1, self.loc.mcplayer)
	if (Player and Type) then	
		if (Player == self.loc.mcyou and Type == self.loc.mcare) then
			Player = UnitName("player")
		end
		self:TriggerEvent("BIGWIGS_MESSAGE", Player .. self.loc.mcplayerwarn, "Red")
	end
end

function BigWigsSkeram:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if (arg1 == self.loc.aetrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.aewarn, "Orange")
	elseif (arg1 == self.loc.mctrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.mcwarn, "Orange")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsSkeram:RegisterForLoad()