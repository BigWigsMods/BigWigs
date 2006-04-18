BigWigsHuhuran = AceAddon:new({
	name          = "BigWigsHuhuran",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = "Princess Huhuran",

	loc = {
		bossname = "Princess Huhuran",
		disabletrigger = "Princess Huhuran dies.",
		bosskill = "Princess Huhuran has been defeated.",

		frenzytrigger = "goes into a frenzy!",
		berserktrigger = "goes into a berserker rage!",
		frenzywarn = "Frenzy - Tranq Shot!",
		berserkwarn = "Berserk - Give it all you got!",
		berserksoonwarn = "Berserk Soon - Get Ready!",
		stingtrigger = "^([^%s]+) ([^%s]+) afflicted by Wyvern Sting",
		stingwarn = "Wyvern Sting - Dispel Tanks!",
		stingdelaywarn = "Possible Wyvern Sting in 3 seconds!",
		bartext = "Wyvern Sting",
	},
})

function BigWigsHuhuran:Initialize()
	self.disabled = true
	self.berserkannounced = false
	BigWigs:RegisterModule(self)
end

function BigWigsHuhuran:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MONSTER_EMOTE")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "checkSting")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "checkSting")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "checkSting")
	self.berserkannounced = false
end


function BigWigsHuhuran:Disable()
	self.disabled = true
	self.berserkannounced = false
	self:UnregisterEvent("CHAT_MONSTER_EMOTE")
	self:UnregisterEvent("UNIT_HEALTH")
	self:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "checkSting")
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "checkSting")
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "checkSting")
	
end

function BigWigsHuhuran:CHAT_MSG_COMBAT_HOSTILE_DEATH()
    if ( arg1 == self.loc.disabletrigger ) then
        self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
        self:Disable()
    end
end


function BigWigsHuhuran:CHAT_MONSTER_EMOTE()
	if( arg2 == self.loc.bossname ) then
		if( arg1 == self.loc.frenzytrigger ) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.frenzywarn, "Orange")
		elseif( arg1 == self.loc.berserktrigger ) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.berserkwarn, "Red")
		end
	end
end

function BigWigsHuhuran:UNIT_HEALTH()
	if( arg1 ) then
		if( UnitName( arg1 ) == self.loc.bossname ) then
			local health = UnitHealth( arg1 )
			if( health > 30 and health <= 33 ) then
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.berserksoonwarn, "Red")
				self.berserkannounced = true
			elseif( health > 40 and self.berserkannounced ) then
				self.berserkannounced = false
			end
		end
	end
end

function BigWigsHuhuran:checkSting()
	if( arg1 ) then
		local _,_,player,isare = string.find( arg1, self.loc.stingtrigger )
		if( player and isare ) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.stingwarn, "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.stingdelaywarn, 22, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bartext, 25, 1, "Green", "Interface\\Icons\\INV_Spear_02")
		end
	end
end

--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsHuhuran:RegisterForLoad()
