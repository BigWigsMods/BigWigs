

BigWigsJeklik = AceAddon:new({
	name          = "BigWigsJeklik",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "ZG",
	enabletrigger = "High Priestess Jeklik",


	loc = {
		bossname = "High Priestess Jeklik",

		trigger1 = "I command you to rain fire down upon these invaders!$",
		trigger2 = "begins to cast a Great Heal!$",
		warn1 = "Incoming bomb bats!",
		warn2 = "Casting heal - interrupt it!",

		disabletrigger = "High Priestess Jeklik dies.",

		bosskill = "High Priestess Jeklik has been defeated!",
	},
})


function BigWigsJeklik:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end


function BigWigsJeklik:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end


function BigWigsJeklik:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end


function BigWigsJeklik:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if arg1 == self.loc.disabletrigger then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end


function BigWigsJeklik:CHAT_MSG_MONSTER_YELL()
	if string.find(arg1, self.loc.trigger1) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Yellow")
	end
end


function BigWigsJeklik:CHAT_MSG_MONSTER_EMOTE()
	if string.find(arg1, self.loc.trigger2) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "Orange")
	end
end


--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsJeklik:RegisterForLoad()
