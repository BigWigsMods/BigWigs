

BigWigsJeklik = AceAddon:new({
	name          = "BigWigsJeklik",
	cmd           = AceChatCmd:new({}, {}),

	loc = {
		trigger1 = "I command you to rain fire down upon these invaders!$",
		trigger2 = "begins to cast a Great Heal!$",
		warn1 = "Incoming bomb bats!",
		warn2 = "Casting heal - interrupt it!",
	},
})


function BigWigsJeklik:Enable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
end


function BigWigsJeklik:Disable()
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
