local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsMoam = AceAddon:new({
	name          = "BigWigsMoam",
	cmd           = AceChatCmd:new({}, {}),


	zonename = BabbleLib:GetInstance("Zone 1.2")("Ruins of Ahn'Qiraj"),

	enabletrigger = "Moam",
	bossname = "Moam",
--	enabletrigger = bboss("Moam"),
--	bossname = bboss("Moam"),

	toggleoptions = {
		notBosskill = "Boss death",
		notStart = "Start warning",
		notAddsBar = "Adds timerbar",
		notAdds = "Adds warning",
		notParalyze = "Paralyze warning",
		notParalyzeBar = "Paralyze timerbar",
		notReturn = "Return warning",
	},

	optionorder = {"notStart", "notAddsBar", "notAdds", "notParalyze", "notParalyzeBar", "notReturn", "notBosskill"},



	loc = {
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
	if not self:GetOpt("notAdds") then
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.addsincoming, 60), 30, "Green")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.addsincoming, 30), 60, "Orange")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.addsincoming, 15), 75, "Orange")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.addsincoming, 5), 85, "Red")
	end
	if not self:GetOpt("notAddsBar") then self:TriggerEvent("BIGWIGS_BAR_START", self.loc.addsbar, 90, 1, "Green", "Interface\\Icons\\Spell_Shadow_CurseOfTounges") end
end

function BigWigsMoam:CHAT_MSG_MONSTER_EMOTE()
	if (arg1 == self.loc.starttrigger) then
		if not self:GetOpt("noStart") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.startwarn, "Red") end
		self:AddsStart()
	elseif (arg1 == self.loc.addstrigger) then
		if not self:GetOpt("notAdds") then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.addswarn, "Red")
		end
		if not self:GetOpt("notParalyze") then
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.returnincoming, 60), 30, "Green")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.returnincoming, 30), 60, "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.returnincoming, 15), 75, "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.returnincoming, 5), 85, "Red")
		end
		if not self:GetOpt("notParalyzeBar") then self:TriggerEvent("BIGWIGS_BAR_START", self.loc.paralyzebar, 90, 1, "Green", "Interface\\Icons\\Spell_Shadow_CurseOfTounges") end
	end
end

function BigWigsMoam:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (string.find( arg1, self.loc.returntrigger)) then
		if not self:GetOpt("notReturn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.returnwarn, "Red") end
		self:AddsStart()
	end
end

function BigWigsMoam:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsMoam:RegisterForLoad()