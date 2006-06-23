local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsMandokir = AceAddon:new({
	name          = "BigWigsMandokir",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Zul'Gurub"),
	enabletrigger = bboss("Bloodlord Mandokir"),
	bossname = bboss("Bloodlord Mandokir"),

	toggleoptions = {
		notPlayer = "Watching you warning",
		notOthers = "Watching other players warnings",
		notBosskill = "Boss death",
	},

	loc = GetLocale() == "koKR" and {
		disabletrigger = "혈군주 만도크리|1이;가; 죽었습니다.",
		trigger1 = "(.+)! 널 지켜보고 있겠다!",

		warn1 = "당신을 지켜보고 있습니다 - 모든 동작 금지!",
		warn2 = "%s님을 지켜봅니다!",
		bosskill = "혈군주 만도키르를 물리쳤습니다!",
	} or GetLocale() == "zhCN" and {
		disabletrigger = "血领主曼多基尔死亡了。",

		trigger1 = "(.+)！我正在看着你！$",

		warn1 = "你被盯上了 - 停止一切动作！",
		warn2 = "%s被盯上了！",
		bosskill = "血领主曼多基尔被击败了！",
	} or {
		disabletrigger = "Bloodlord Mandokir dies.",

		trigger1 = "([^%s]+)! I'm watching you!$",

		warn1 = "You are being watched - stop all actions!",
		warn2 = "%s is being watched!",
		bosskill = "Bloodlord Mandokir has been defeated!",
	},
})

function BigWigsMandokir:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
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
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsMandokir:CHAT_MSG_MONSTER_YELL()
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
BigWigsMandokir:RegisterForLoad()