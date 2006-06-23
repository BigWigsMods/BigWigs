
local bboss = BabbleLib:GetInstance("Boss 1.2")


BigWigsMandokir = AceAddon:new({
	name          = "BigWigsMandokir",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "ZG",
	enabletrigger = bboss("High Priestess Arlokk"),

	loc = {
		disabletrigger = "High Priestess Arlokk dies.",

		trigger1 = "Feast on ([^%s]+), my pretties!$",

		warn1 = "You are marked!",
		warn2 = "%s is marked!",
		bosskill = "High Priestess Arlokk has been defeated!",
	},
})


function BigWigsMandokir:Initialize()
	self.loc.bossname = bboss("High Priestess Arlokk")
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
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory")
		self:Disable()
	end
end


function BigWigsMandokir:CHAT_MSG_MONSTER_YELL()
	local _,_, n = string.find(arg1, self.loc.trigger1)
	if n then
		if n == UnitName("player") then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red", true, "Alarm")
		else
			self:TriggerEvent("BIGWIGS_MESSAGE", string.format(self.loc.warn2, n), "Yellow")
			self:TriggerEvent("BIGWIGS_SENDTELL", n, self.loc.warn1)
		end
	end
end


--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsMandokir:RegisterForLoad()