

BigWigsHakkar = AceAddon:new({
	name          = "BigWigsHakkar",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "ZG",
	enabletrigger = "Hakkar",

	loc = {
		bossname = "Hakkar",
		disabletrigger = "Hakkar dies.",

		trigger1 = "FACE THE WRATH OF THE SOULFLAYER!",
		trigger2 = "^Hakkar suffers (.+) from (.+) Blood Siphon",
		flee = "Fleeing will do you no good mortals!",

		start = "Hakkar engaged - 90 seconds until drain - 10 minutes until enrage",
		warn1 = "60 seconds until drain",
		warn2 = "45 seconds until drain",
		warn3 = "15 seconds until drain",
		warn4 = "Life Drain - 90 seconds until next",
		bosskill = "Hakkar has been defeated!",

		bar1text = "Enrage",
		bar2text = "Life Drain",
	},
})


function BigWigsHakkar:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end


function BigWigsHakkar:Enable()
	self.disabled = nil
	self.prior = nil
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("BIGWIGS_MESSAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end


function BigWigsHakkar:Disable()
	self.disabled = true
	self:Reset()
	self:UnregisterAllEvents()
end


function BigWigsHakkar:Reset()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar2text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn1)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn2)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn3)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 30)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 45)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 75)
end


function BigWigsHakkar:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if arg1 == self.loc.disabletrigger then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end


function BigWigsHakkar:CHAT_MSG_MONSTER_YELL()
	if string.find(arg1, self.loc.trigger1) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.start, "Green")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 600, 1, "Purple", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
		self:BeginTimers(true)
	elseif string.find(arg1, self.loc.flee) then
		self:Reset()
	end
end


function BigWigsHakkar:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE()
	if not self.prior and string.find(arg1, self.loc.trigger2) then
		self.prior = true
		self:BeginTimers()
	end
end


function BigWigsHakkar:BIGWIGS_MESSAGE(text)
	if text == self.loc.warn1 then self.prior = nil end
end


function BigWigsHakkar:BeginTimers(first)
	if not first then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn4, "Green") end
	self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar2text, 90, 2, "Green", "Interface\\Icons\\Spell_Shadow_LifeDrain")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn1, 30, "Yellow")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn2, 45, "Orange")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 75, "Red")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar2text, 30, "Yellow")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar2text, 45, "Orange")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar2text, 75, "Red")
end



--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsHakkar:RegisterForLoad()

