local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsGluth = AceAddon:new({
	name	= "BigWigsGluth",
	cmd		= AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Naxxramas"),
	enabletrigger = bboss("Gluth"),
	bossname = bboss("Gluth"),	

	toggleoptions = {
		notFrenzy = "Frenzy warning",
		notBosskill = "Boss death",
	},
	optionorder = {"notFrenzy", "notBosskill"},

	loc = {
		bossname = "Gluth",
		disabletrigger = "Gluth dies.",

		trigger1 = "goes into a frenzy!",

		warn1 = "Frenzy alert - Hunter Tranq shot now!",
	},
})

function BigWigsGluth:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsGluth:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsGluth:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self.prior = nil
end

function BigWigsGluth:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if not self:GetOpt("notFrenzy") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsGluth:CHAT_MSG_MONSTER_EMOTE()
	if (arg1 == self.loc.trigger1) then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red") end
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsGluth:RegisterForLoad()