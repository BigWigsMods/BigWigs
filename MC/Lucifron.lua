BigWigsLucifron = AceAddon:new({
	name          = "BigWigsLucifron",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "MC",
	enabletrigger = "Lucifron",

	loc = {
		bossname = "Lucifron",
		disabletrigger = "Lucifron dies.",

		trigger1 = "afflicted by Lucifron",
		trigger2 = "afflicted by Impending Doom",

		warn1 = "5 seconds until Lucifron's Curse!",
		warn2 = "Lucifron's Curse - 20 seconds until next!",
		warn3 = "5 seconds until Impending Doom!",
		warn4 = "Impending Doom - 20 seconds until next!",

		bar1text = "Lucifron's Curse",
		bar2text = "Impending Doom",
	},
})

function BigWigsLucifron:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsLucifron:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsLucifron:Disable()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar2text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn1)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn3)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 15)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 15)
	self:UnregisterAllEvents()
end

function BigWigsLucifron:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsLucifron:Event()
	if (string.find(arg1, self.loc.trigger1)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn1, 15, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 20, 1, "Yellow", "Interface\\Icons\\Spell_Shadow_BlackPlague")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 15, "Red")
	elseif (string.find(arg1, self.loc.trigger2)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn4, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 15, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar2text, 20, 2, "Yellow", "Interface\\Icons\\Spell_Shadow_NightOfTheDead")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar2text, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar2text, 15, "Red")
	end
end
--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsLucifron:RegisterForLoad()