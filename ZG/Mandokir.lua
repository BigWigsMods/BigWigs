BigWigsMandokir = AceAddon:new({
	name          = "BigWigsMandokir",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "ZG",
	enabletrigger = GetLocale() == "koKR" and "혈군주 만도키르"
		or GetLocale() == "zhCN" and "血领主曼多基尔"
		or "Bloodlord Mandokir",

	loc = GetLocale() == "koKR" and {
		bossname = "혈군주 만도키르",
		disabletrigger = "혈군주 만도크리|1이;가; 죽었습니다.",
		trigger1 = "(.+)! 널 지켜보고 있겠다!",

		warn1 = "당신을 지켜보고 있습니다 - 모든 동작 금지!",
		warn2 = "님을 지켜봅니다!",
		bosskill = "혈군주 만도키르를 물리쳤습니다!",
	}
		or GetLocale() == "zhCN" and
	{
		bossname = "血领主曼多基尔",
		disabletrigger = "血领主曼多基尔死亡了。",

		trigger1 = "(.+)！我正在看着你！$",

		warn1 = "你被盯上了 - 停止一切动作！",
		warn2 = "被盯上了！",
		bosskill = "血领主曼多基尔被击败了！",
	}
		or
	{
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
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory")
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