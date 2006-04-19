BigWigsMandokir = AceAddon:new({
	name          = "BigWigsMandokir",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "ZG",
	enabletrigger = "Bloodlord Mandokir",

	loc = {
		bossname = "Bloodlord Mandokir",
		disabletrigger = "Bloodlord Mandokir dies.",

		trigger1 = "([^%s]+)! I'm watching you!$",

		warn1 = "You are being watched - stop all actions!",
		warn2 = " is being watched!",
		bosskill = "Bloodlord Mandokir has been defeated!",
	},
})


function BigWigsMandokir:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end


function BigWigsMandokir:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end


function BigWigsMandokir:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end


function BigWigsMandokir:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if arg1 == self.loc.disabletrigger then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end


function BigWigsMandokir:CHAT_MSG_MONSTER_YELL()
	local _,_, EPlayer = string.find(arg1, self.loc.trigger1)
	if EPlayer then
		if EPlayer == UnitName("player") then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red", true)
		else
			self:TriggerEvent("BIGWIGS_MESSAGE", EPlayer .. self.loc.warn2, "Yellow")
			self:TriggerEvent("BIGWIGS_SENDTELL", EPlayer, self.loc.warn1)
		end
	end
end


--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsMandokir:RegisterForLoad()