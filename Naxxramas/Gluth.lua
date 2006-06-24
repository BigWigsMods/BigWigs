BigWigsGluth = AceAddon:new({
	name	= "BigWigsGluth",
	cmd		= AceChatCmd:new({}, {}),

	zonename = "Naxxramas",
	enabletrigger = "Gluth",

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
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn2)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 20)
	self.prior = nil
end

function BigWigsGluth:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory")
		self:Disable()
	end
end

function BigWigsGluth:CHAT_MSG_MONSTER_EMOTE()
	if (arg1 == self.loc.trigger1) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsGluth:RegisterForLoad()