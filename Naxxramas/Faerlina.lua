local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsFaerlina = AceAddon:new({
	name          = "BigWigsFaerlina",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Naxxramas"),
	enabletrigger = bboss("Grand Widow Faerlina"),
	bossname = bboss("Grand Widow Faerlina"),

	toggleoptions = {
		notEnrageWarn = "Warn for Enrage",
		notEnrageBar = "Show the timer bar for the next Enrage",
		notBosskill = "Boss death",
	},
	optionorder = {"notEnrageWarn", "notEnrageBar", "notBosskill"},

	loc = { 
		disabletrigger = "Grand Widow Faerlina dies.",		
		bosskill = "Grand Widow Faerlina has been defeated!",

		starttrigger1 = "Kneel before me, worm!",
		starttrigger2 = "Slay them in the master's name!",
		starttrigger3 = "You cannot hide from me!",
		starttrigger4 = "Run while you still can!",

		enragetrigger = "Grand Widow Faerlina gains Enrage.",

		startwarn = "Start or Enrage!",
		enragewarn15sec = "15 seconds until enrage!",
		enragewarn = "Enrage!",

		enragebar = "Enrage",
	},
})

function BigWigsFaerlina:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsFaerlina:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
end

function BigWigsFaerlina:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsFaerlina:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if (not self:GetOpt("notBosskill")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsFaerlina:CHAT_MSG_MONSTER_YELL()
	if (arg1 == self.loc.starttrigger1 or arg1 == self.loc.starttrigger2 or arg1 == self.loc.starttrigger3 or arg1 == self.loc.starttrigger4) then
		if (not self:GetOpt("notEnrageWarn")) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.startwarn, "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.enragewarn15sec, 45, "Red")
		end
		if (not self:GetOpt("notEnrageBar")) then
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.enragebar, 60, 1, "Yellow", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.gainincbar, 40, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.gainincbar, 50, "Red")
		end
	end
end

function BigWigsFaerlina:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (arg1 == self.loc.enragetrigger) then
		if (not self:GetOpt("notEnrageWarn")) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragewarn, "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.enragewarn15sec, 45, "Red")
		end
		if (not self:GetOpt("notEnrageBar")) then
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.enragebar, 60, 1, "Yellow", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.gainincbar, 40, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.gainincbar, 50, "Red")
		end
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsFaerlina:RegisterForLoad()