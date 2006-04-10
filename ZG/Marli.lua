

BigWigsMarli = AceAddon:new({
	name          = "BigWigsMarli",
	cmd           = AceChatCmd:new({}, {}),

	loc = {
		trigger = "Aid me my brood!$",
		warn = "Spiders spawned!",
	},
})


function BigWigsMarli:Enable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end


function BigWigsMarli:Disable()
end


function BigWigsMarli:CHAT_MSG_MONSTER_YELL()
	if string.find(arg1, self.loc.trigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn, "Yellow")
	end
end


--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsMarli:RegisterForLoad()
