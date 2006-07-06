local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsGluth = AceAddon:new({
	name = "BigWigsGluth",
	cmd = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Naxxramas"),
	enabletrigger = bboss("Gluth"),
	bossname = bboss("Gluth"),

	toggleoptions = {	
		notFear = "Fear warning",
		notFrenzy = "Frenzy warning",
		notStartWarn = "Start warning",
		notDecimateWarn = "Decimate warning",
		notDecimate30Sec = "Decimate 30-sec warning",
		notDecimate5Sec = "Decimate 5-sec warning",
		notDecimateBar = "Decimate timerbar",
		notBosskill = "Boss death",
	},
	optionorder = {"notStartWarn", "notFear", "notFrenzy", "notDecimateWarn", "notDecimate30Sec", "notDecimate5Sec", "notDecimateBar", "notBosskill"},

	loc = {
		bossname = "Gluth",
		disabletrigger = "Gluth dies.",

		trigger1 = "goes into a frenzy!",
		trigger2 = "by Terrifying Roar.",
		starttrigger = "devours all nearby zombies!",

		warn1 = "Frenzy alert - Hunter Tranq shot now!",
		warn2 = "5 second until AoE Fear!",
		warn3 = "AoE Fear alert - 20 seconds till next!",
		startwarn = "Gluth Engaged! 105 seconds till Zombies!",
		decimate30secwarn = "30 seconds till Zombies!",
		decimate5secwarn = "5 seconds till Zombies!",
		decimatewarn = "Decimate! - AoE Zombies!",
		decimatetrigger = "Gluth gains Decimate.",

		bar1text = "AoE Fear",
		decimatebartext = "Decimate Zombies",
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
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("BIGWIGS_SYNC_GLUTHDECIMATE")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "GLUTHDECIMATE", 10)
end

function BigWigsGluth:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.decimatebartext)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.decimate30secwarn, 75)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.decimate5secwarn, 100)
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
	elseif( arg1 == self.loc.starttrigger ) then
		if not self:GetOpt("notStartWarn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.startwarn, "Yellow") end
		if not self:GetOpt("notDecimateBar") then self:TriggerEvent("BIGWIGS_BAR_START", self.loc.decimatebartext, 105, 2, "Red", "Interface\\Icons\\INV_Shield_01") end
		if not self:GetOpt("notDecimate30Sec") then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.decimate30secwarn, 75, "Yellow") end
		if not self:GetOpt("notDecimate5Sec") then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.decimate5secwarn, 100, "Orange") end
	end
end

function BigWigsGluth:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (arg1 == self.loc.decimatetrigger ) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "GLUTHDECIMATE")
	end
end

function BigWigsGluth:BIGWIGS_SYNC_GLUTHDECIMATE()
	if not self:GetOpt("notDecimateWarn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.decimatewarn, "Red") end
	if not self:GetOpt("notDecimateBar") then self:TriggerEvent("BIGWIGS_BAR_START", self.loc.decimatebartext, 105, 2, "Red", "Interface\\Icons\\INV_Shield_01") end
	if not self:GetOpt("notDecimate30Sec") then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.decimate30secwarn, 75, "Yellow") end
	if not self:GetOpt("notDecimate5Sec") then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.decimate5secwarn, 100, "Orange") end
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
