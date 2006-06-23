BigWigsMoam = AceAddon:new({
	name          = "BigWigsMoam",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ20",
	enabletrigger = "Moam",

	loc = {
		bossname = "Moam",
		disabletrigger = "Moam dies.",
		bosskill = "Moam has been defeated.",
		startrigger = "senses your fear",
		startwarn = "Moam Enaged! 90 Seconds until adds! Drain mana!",
		addsbar = "Adds",
		addsincoming = "Adds incoming in %s seconds!",
		addstrigger = "drains your mana and turns to stone.",
		addswarn = "Adds spawned! Moam Paralyzed for 90 seconds!",
		paralyzebar = "Paralyze",
		returnincoming = "Moam unparalyzed in %s seconds!",
		returntrigger = "^Energize fades from Moam%.$",
		returnwarn = "Moam unparalyzed! 90 seconds until adds! Drain mana!",
	},
})

function BigWigsMoam:Initialize()
    self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsMoam:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH" )
end

function BigWigsMoam:Disable()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", format(self.loc.addsincoming, 60))
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", format(self.loc.addsincoming, 30))
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", format(self.loc.addsincoming, 15))
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", format(self.loc.addsincoming, 5))
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", format(self.loc.returnincoming, 60))
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", format(self.loc.returnincoming, 30))
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", format(self.loc.returnincoming, 15))
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", format(self.loc.returnincoming, 5))
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.addsbar)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.paralyzebar)
	self:UnregisterAllEvents()
end

function BigWigsMoam:AddsStart()
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.addsincoming, 60), 30, "Green")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.addsincoming, 30), 60, "Orange")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.addsincoming, 15), 75, "Orange")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.addsincoming, 5), 85, "Red")
	self:TriggerEvent("BIGWIGS_BAR_START", self.loc.addsbar, 90, 1, "Green", "Interface\\Icons\\Spell_Shadow_CurseOfTounges")
end

function BigWigsMoam:CHAT_MSG_MONSTER_EMOTE()
	if (arg1 == self.loc.starttrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.startwarn, "Red")
		self:AddsStart()
	elseif (arg1 == self.loc.addstrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.addswarn, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.returnincoming, 60), 30, "Green")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.returnincoming, 30), 60, "Orange")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.returnincoming, 15), 75, "Orange")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.returnincoming, 5), 85, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.paralyzebar, 90, 1, "Green", "Interface\\Icons\\Spell_Shadow_CurseOfTounges")
	end
end

function BigWigsMoam:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (string.find( arg1, self.loc.returntrigger)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.returnwarn, "Red")
		self:AddsStart()
	end
end

function BigWigsMoam:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory")
		self:Disable()
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsMoam:RegisterForLoad()