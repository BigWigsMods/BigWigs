local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsBroodlord = AceAddon:new({
	name          = "BigWigsBroodlord",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Blackwing Lair"),
	enabletrigger = bboss("Broodlord Lashlayer"),
	bossname = bboss("Broodlord Lashlayer"),

	toggleoptions = {
		notYouMS = "Warn when you are afflicted by Mortal Strike",
		notElseMS = "Warn when others are afflicted by Mortal Strike",
		notBosskill = "Boss death",
	},
	optionorder = {"notYouMS", "notElseMS", "notBosskill"},

	loc = GetLocale() == "deDE" and {
		disabletrigger = "Brutw\195\164chter Dreschbringer stirbt.",

		trigger1 = "^([^%s]+) ([^%s]+) von T\195\182dlicher Sto\195\159 betroffen",

		you = "Ihr",
		are = "seid",

		warn1 = "Mortal Strike on you!",
		warn2 = "Mortal Strike on %s!",
		bosskill = "Lashlayer wurde besiegt!",
	} or {
		disabletrigger = "Broodlord Lashlayer dies.",

		trigger1 = "^([^%s]+) ([^%s]+) afflicted by Mortal Strike",

		you = "You",
		are = "are",

		warn1 = "Mortal Strike on you!",
		warn2 = "Mortal Strike on %s!",
		bosskill = "Broodlord Lashlayer has been defeated!",
	},
})

function BigWigsBroodlord:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsBroodlord:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsBroodlord:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsBroodlord:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if (not self:GetOpt("notBosskill")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsBroodlord:Event()
	local _, _, EPlayer, EType = string.find(arg1, self.loc.trigger1)
	if (EPlayer and EType) then
		if (EPlayer == self.loc.you and EType == self.loc.are and not self:GetOpt("notYouMS")) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red", true)
		elseif (not self:GetOpt("notElseMS")) then 
			self:TriggerEvent("BIGWIGS_MESSAGE", string.format(self.loc.warn2, EPlayer), "Yellow")
		end
	end
end

--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsBroodlord:RegisterForLoad()
