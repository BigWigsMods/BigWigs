BigWigsOssirian = AceAddon:new({
	name          = "BigWigsOssirian",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = "Ossirian the Unscarred",

	loc = {
		bossname = "Ossirian the Unscarred",
		disabletrigger1 = "I...have...failed.",
		disabletrigger2 = "Ossirian the Unscarred dies.",
		bosskill = "Ossirian has been defeated!",

		supremetrigger = "Ossirian the Unscarred gains Strength of Ossirian.",
		supremewarn = "Ossirian Supreme Mode!",
		supremedelaywarn = "Supreme in %d seconds!",
		debufftrigger = "^Ossirian the Unscarred is afflicted by (.+) Weakness%.$",
		debuffwarn = "Ossirian now weak to %s",
		bartext = "Supreme",
	},
})

function BigWigsOssirian:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsOssirian:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "checkEnd")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL", "checkEnd")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
end


function BigWigsOssirian:Disable()
	self.disabled = true
	self:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	self:UnregisterEvent("CHAT_MSG_MONSTER_YELL")
	
end

function BigWigsOssirian:checkEnd()
    if ( arg1 == self.loc.disabletrigger1 or  arg1 == self.loc.disabletrigger2 ) then
        self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
        self:Disable()
    end
end

function BigWigsOssirian:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if( arg1 == self.loc.supremetrigger ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.supremewarn, "Yellow" )
	end
end

function BigWigsOssirian:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE()
	if ( arg1 ) then
		local _, _, debuffName = string.find(arg1, self.loc.debufftrigger);
		if ( debuffName ) then
			self:TriggerEvent("BIGWIGS_MESSAGE", format(self.loc.debuffwarn, debuffName), "Red")

			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", format(self.loc.supremedelaywarn, 30))
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", format(self.loc.supremedelaywarn, 40))
			self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bartext)

			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.supremedelaywarn, 15), 30, "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.supremedelaywarn, 5), 40, "Red")
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bartext, 45, 1, "Green", "Interface\\Icons\\Ability_FiegnDead")
		end
	end
end

--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsOssirian:RegisterForLoad()
