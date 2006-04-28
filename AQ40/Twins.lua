BigWigsTwins = AceAddon:new({
	name          = "BigWigsTwins",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = {"Emperor Vek'lor", "Emperor Vek'nilash"},

	loc = {
		bossname = "Twin Emperors - Emperor Vek'lor and Emperor Vek'nilash",
		veklor = "Emperor Vek'lor",
		veknilash = "Emperor Vek'nilash",
		disabletrigger = " dies.",
		bosskill = "Twin Emperors have been defeated!",

		porttrigger = "casts Twin Teleport.",
		portwarn = "Teleport!",
		portdelaywarn = "Teleport in 5 seconds!",
		bartext = "Teleport",
		explodebugtrigger = "gains Explode Bug%.$",
		explodebugwarn = "Bug Exploding Nearby!",
		enragetrigger = "becomes enraged.",
		enragewarn = "Twins are Enraged",
		healtrigger1 = "'s Heal Brother heals",
		healtrigger2 = " Heal Brother heals",
		healwarn = "Casting Heal Brother - Separate them fast!",
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
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bartext)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.portdelaywarn)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bartext, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bartext, 20)
end

function BigWigsTwins:CHAT_MSG_COMBAT_HOSTILE_DEATH()
    if (arg1 == self.loc.veklor .. self.loc.disabletrigger or arg1 == self.loc.veknilash .. self.loc.disabletrigger) then
        self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
        self:Disable()
    end
end

function BigWigsTwins:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if (string.find(arg1, self.loc.porttrigger)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.portwarn, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.portdelaywarn, 25, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bartext, 30, 1, "Yellow", "Interface\\Icons\\Spell_Arcane_Blink")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bartext, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bartext, 20, "Red")
	end
end

function BigWigsTwins:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (string.find(arg1, self.loc.explodebugtrigger)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.explodebugwarn, "Yellow")
	end
end

function BigWigsTwins:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if ((string.find(arg1, self.loc.healtrigger1) or string.find(arg1, self.loc.healtrigger2)) and not self.prior) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.healwarn, "Red")
		self.prior = true
		Timex:AddNamedSchedule("BigWigsTwinsHealReset", 10, false, 1, function() BigWigsTwins.prior = nil end)
	end
end

function BigWigsTwins:CHAT_MSG_MONSTER_EMOTE()
	if (string.find(arg1, self.loc.enragetrigger)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragewarn, "Red")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsTwins:RegisterForLoad()