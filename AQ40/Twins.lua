BigWigsTwins = AceAddon:new({
	name          = "BigWigsTwins",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = { "Emperor Vek'lor", "Emperor Vek'nilash" },

	loc = {
		bossname = "Twin Emperors, Emperor Vek'lor and Emperor Vek'nilash",
		bossnameveklor = "Emperor Vek'lor",
		bossnameveknilash = "Emperor Vek'nilash",
		disabletrigger1 = "Emperor Vek'lor dies.",
		disabletrigger2 = "Emperor Vek'nilash dies.",
		bosskill = "Twin Emperors have been defeated!",

		porttrigger1 = "Emperor Vek'lor casts Twin Teleport.",
		porttrigger2 = "Emperor Vek'nilash casts Twin Teleport.",
		portwarn = "Teleport!",
		portdelaywarn = "Teleport in 5 seconds!",
		bartext = "Teleport",
		explodebugtrigger = "gains Explode Bug%.$",
		explodebugwarn = "Bug Exploding Nearby!",
	},
})

function BigWigsTwins:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsTwins:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
end


function BigWigsTwins:Disable()
	self.disabled = true
	self:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	
end

function BigWigsTwins:CHAT_MSG_COMBAT_HOSTILE_DEATH()
    if ( arg1 == self.loc.disabletrigger1 or arg1 == self.loc.disabletrigger2 ) then
        self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
        self:Disable()
    end
end

function BigWigsTwins:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if string.find(arg1, self.loc.explodebugtrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.explodebugwarn, "Yellow" )
	end
end

function BigWigsTwins:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if( arg1 == self.loc.porttrigger1 or arg1 == self.loc.porttrigger2 ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.portwarn, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.portdelaywarn, 20, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bartext, 25, 1, "Green", "Interface\\Icons\\Spell_Arcane_Blink")
	end
end

--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsTwins:RegisterForLoad()
