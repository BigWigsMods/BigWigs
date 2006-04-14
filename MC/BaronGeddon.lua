BigWigsBaronGeddon = AceAddon:new({
	name          = "BigWigsBaronGeddon",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "MC",
	enabletrigger = "Baron Geddon",

	loc = {
		bossname = "Baron Geddon",
		disabletrigger = "Baron Geddon dies.",

		trigger1 = "^([^%s]+) ([^%s]+) afflicted by Living Bomb",

		you = "You",
		are = "are",

		warn1 = "You are the bomb!",
		warn2 = " is the bomb!",
	},
})

function BigWigsBaronGeddon:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsBaronGeddon:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsBaronGeddon:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsBaronGeddon:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsBaronGeddon:Event()
	local _, _, EPlayer, EType = string.find(arg1, self.loc.trigger1)
	if (EPlayer and EType) then
		if (EPlayer == self.loc.you and EType == self.loc.are) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red")
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red")
		else
			self:TriggerEvent("BIGWIGS_MESSAGE", EPlayer .. self.loc.warn2, "Yellow")
		end
	end
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsBaronGeddon:RegisterForLoad()
