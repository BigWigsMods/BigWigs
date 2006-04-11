BigWigsLucifron = AceAddon:new({
	name          = "BigWigsLucifron",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "MC",
	enabletrigger = "Lucifron",

	loc = {
		bossname = "Lucifron",
		disabletrigger = "Lucifron dies.",
		bosskill = "Lucifron has been defeated!",

		cursetrigger = "afflicted by Lucifron",
		doomtrigger = "afflicted by Impending Doom",

		cursewarn = "AE Curse Alert - 20 seconds till next",
		doomwarn = "Impending Doom Alert - 20 seconds till next",
		
		curse5sec = "5 seconds until AE Curse",
		doom5sec = "5 seconds until Impending Doom",

		bar1text = "AE Curse",
		bar2text = "Impending Doom",
	},
})

function BigWigsLucifron:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end


function BigWigsLucifron:Enable()
	self.disabled = nil
	self.doomed = nil
	self.cursed = nil
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("BIGSWIGS_MESSAGE")
end


function BigWigsLucifron:Disable()
	self.disabled = true

	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "checkCurse")
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "checkCurse")
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "checkCurse")
	self:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:UnregisterEvent("BIGWIGS_MESSAGE")

end


function BigWigsLucifron:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if arg1 == self.loc.disabletrigger then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end


function BigWigsLucifron:checkCurse()
	if( not self.cursed and string.find(arg1, self.loc.cursetrigger) ) then
		self.cursed = true
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 20, 1, "Red" )
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.curse5sec, 15, "Yellow")
	elseif( not self.doomed and string.find( arg1, self.loc.doomtrigger) ) then
		self.doomed = true
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar2text, 20, 2, "Red" )
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.doom5sec, 15, "Yellow")
	end
end

function BigWigsLucifron:BIGWIGS_MESSAGE(text)
	if text == self.loc.doom5sec then self.doomed = nil end
	if text == self.loc.curse5sec then self.cursed = nil end
end

--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsLucifron:RegisterForLoad()

