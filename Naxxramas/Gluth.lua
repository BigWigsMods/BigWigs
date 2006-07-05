local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsGluth = AceAddon:new({
	name = "BigWigsGluth",
	cmd = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Naxxramas"),
	enabletrigger = bboss("Gluth"),
	bossname = bboss("Gluth"),

	toggleoptions = {	
		notFear = "Warn for Fear",
		notFrenzy = "Warn when Gluth goes into a frenzy",
		notBosskill = "Boss death",
	},
	optionorder = {"notFear", "notFrenzy", "notBosskill"},

	loc = {
		bossname = "Gluth",
		disabletrigger = "Gluth dies.",

		trigger1 = "goes into a frenzy!",
		trigger2 = "by Terrifying Roar.",

		warn1 = "Frenzy alert - Hunter Tranq shot now!",
		warn2 = "5 second until AoE Fear!",
		warn3 = "AoE Fear alert - 20 seconds till next!",

		bar1text = "AoE Fear",
	},
})

function BigWigsGluth:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsGluth:Enable()
	self.disabled = nil
	self:RegisterEvent("BIGWIGS_MESSAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Fear")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Fear")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Fear")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsGluth:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn2)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 5)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 15)
	self.prior = nil
end

function BigWigsGluth:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if (not self:GetOpt("notBosskill")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsGluth:CHAT_MSG_MONSTER_EMOTE()
	if (arg1 == self.loc.trigger1 and not self:GetOpt("notFrenzy")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red")
	end
end

function BigWigsGluth:Fear()
	if (not self.prior and string.find(arg1, self.loc.trigger2) and not self:GetOpt("notFear")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn3, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn2, 15, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 20, 1, "Yellow", "Interface\\Icons\\Spell_Shadow_PsychicScream")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 5, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 15, "Red")
		self.prior = true
	end
end

function BigWigsGluth:BIGWIGS_MESSAGE(text)
	if text == self.loc.warn2 then self.prior = nil end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsGluth:RegisterForLoad()
