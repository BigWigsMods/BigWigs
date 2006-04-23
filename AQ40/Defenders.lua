BigWigsDefenders = AceAddon:new({
	name          = "BigWigsDefenders",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = "Anubisath Defender",

	loc = {
		bossname = "Anubisath Defender",
		disabletrigger = "Anubisath Defender dies.",
		bosskill = "Anubisath Defender has been defeated.",

		explodetrigger = "Anubisath Defender gains Explode.",
		explodewarn = "Exploding! Run away!",
		enragetrigger = "Anubisath Defender gains Enrage.",
		enragewarn = "Enraged!",
		summonguardtrigger = "Anubisath Defender casts Summon Anubisath Swarmguard.",
		summonguardwarn = "Swarmguard Summoned",
		summonwarriortrigger = "Anubisath Defender casts Summon Anubisath Warrior.",
		summonwarriorwarn = "Warrior Summoned",
		plaguetrigger = "^([^%s]+) ([^%s]+) afflicted by Plague%.$",
		plaguewarn = " has the Plague! Keep away!",
		plagueyou = "You",
	},
})

function BigWigsDefenders:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsDefenders:Enable()
	self.disabled = nil
	self:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "checkPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "checkPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "checkPlague")
end


function BigWigsDefenders:Disable()
	self.disabled = true
	self:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE")
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE")
	
end

function BigWigsDefenders:CHAT_MSG_COMBAT_HOSTILE_DEATH()
    if ( arg1 == self.loc.disabletrigger ) then
        self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
        self:Disable()
    end
end


function BigWigsDefenders:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if( arg1 == self.loc.explodetrigger ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.explodewarn, "Red" )
	elseif( arg1 == self.loc.enragetrigger ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragewarn, "Red")
	end
end

function BigWigsDefenders:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if( arg1 == self.loc.summonguardtrigger ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.summonguardwarn, "Yellow" )
	elseif( arg1 == self.loc.summonwarriortrigger ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.summonwarriorwarn, "Yellow")
	end
end

function BigWigsDefenders:checkPlague()
	if( arg1 ) then
		local _,_,player,isare = string.find( arg1, self.loc.plaguetrigger )
		if( player and isare ) then
			local text = ""
			if( player == self.loc.plagueyou ) then
				text = UnitName("player")
			else
				text = player
			end
			text = text .. self.loc.plaguewarn
			self:TriggerEvent("BIGWIGS_MESSAGE", text, "Red")
		end
	end
end

--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsDefenders:RegisterForLoad()
