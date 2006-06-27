

local bboss = BabbleLib:GetInstance("Boss 1.2")


BigWigsArlokk = AceAddon:new({
	name          = "BigWigsArlokk",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Zul'Gurub"),
	bossname = bboss("High Priestess Arlokk"),
	enabletrigger = bboss("High Priestess Arlokk"),

	toggleoptions = {
		notPlayer = "Mark on player warning",
		notOthers = "Mark on others warning",
		notBosskill = "Boss death",
	},

	optionorder = {"notPlayer", "notOthers", "notBosskill"},

	loc = {
		disabletrigger = "High Priestess Arlokk dies.",

		trigger1 = "Feast on ([^%s]+), my pretties!$",

		warn1 = "You are marked!",
		warn2 = "%s is marked!",
		bosskill = "High Priestess Arlokk has been defeated!",
	},
})


function BigWigsArlokk:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end


function BigWigsArlokk:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end


function BigWigsArlokk:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end


function BigWigsArlokk:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if arg1 == self.loc.disabletrigger then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end


function BigWigsArlokk:CHAT_MSG_MONSTER_YELL()
	local _,_, n = string.find(arg1, self.loc.trigger1)
	if n then
		if n == UnitName("player") then
			if not self:GetOpt("notPlayer") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red", true, "Alarm") end
		elseif not self:GetOpt("notOthers") then
			self:TriggerEvent("BIGWIGS_MESSAGE", string.format(self.loc.warn2, n), "Yellow")
			self:TriggerEvent("BIGWIGS_SENDTELL", n, self.loc.warn1)
		end
	end
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsArlokk:RegisterForLoad()

