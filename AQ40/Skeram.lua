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
		mcplayer = "^([^%s]+) ([^%s]+) afflicted by True Fulfillment.",
		mcplayerwarn = " is mindcontrolled! Sheep! Fear!",
		mcyou = "You"
	},
})


function BigWigsSkeram:Initialize()
    self.disabled = true
    BigWigs:RegisterModule(self)
end

function BigWigsSkeram:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "checkForMCPlayer" )
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "checkForMCPlayer" )
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "checkForMCPlayer" )
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH" )
end


function BigWigsSkeram:Disable()
	self.disabled = true
	self:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "checkForMCPlayer" )
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "checkForMCPlayer" )
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "checkForMCPlayer" )
	self:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH" )
end

function BigWigsSkeram:checkForMCPlayer()
	if( arg1 and arg1 ~= nil ) then
		local _,_,player,isare =  string.find( arg1, self.loc.mcplayer )
		if( player and isare ) then	
			local text = ""
			if( player == self.loc.mcyou ) then
				text = UnitName("player")
			else
				text = player
			end
			text = text .. self.loc.mcplayerwarn
			self:TriggerEvent("BIGWIGS_MESSAGE", text, "Red")
		end
	end
end

function BigWigsSkeram:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if ( arg1 == self.loc.disabletrigger ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsSkeram:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if ( arg1 == self.loc.aetrigger ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.aewarn, "Orange")
	elseif( arg1 == self.loc.mctrigger ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.mcwarn, "Orange")
	end
end


--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsSkeram:RegisterForLoad()
