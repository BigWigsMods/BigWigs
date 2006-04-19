BigWigsMarli = AceAddon:new({
	name          = "BigWigsMarli",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "ZG",
	enabletrigger = "High Priestess Mar'li",

	loc = {
		bossname = "High Priestess Mar'li",

		trigger1 = "Aid me my brood!$",
		trigger2 = "^High Priestess Mar'li's Drain Life heals High Priestess Mar'li for (.+).",

		warn1 = "Spiders spawned!",
		warn2 = "High Priestess Mar'li is draining life! Interrupt it!",

		disabletrigger = "High Priestess Mar'li dies.",

		bosskill = "High Priest Mar'li has been defeated!",
	},
})


function BigWigsMarli:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end


function BigWigsMarli:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
end


function BigWigsMarli:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end


function BigWigsMarli:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if arg1 == self.loc.disabletrigger then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end


function BigWigsMarli:CHAT_MSG_MONSTER_YELL()
	if string.find(arg1, self.loc.trigger1) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Yellow")
	end
end


function BigWigsMarli:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if string.find(arg1, self.loc.trigger2) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "Orange")
	end
end


--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsMarli:RegisterForLoad()
