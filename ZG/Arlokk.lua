

local bboss = BabbleLib:GetInstance("Boss 1.2")


BigWigsArlokk = AceAddon:new({
	name          = "BigWigsArlokk",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Zul'Gurub"),
	bossname = bboss("High Priestess Arlokk"),
	enabletrigger = bboss("High Priestess Arlokk"),

	toggleoptions = GetLocale() == "koKR" and {
		notPlayer = "당신이 표적일 때 경고",
		notOthers = "다른이가 표적일 때 경고",
		notBosskill = "보스 사망 알림",
	} or {
		notPlayer = "Warn when you are marked",
		notOthers = "Warn when others are marked",
		notBosskill = "Boss death",
	},

	optionorder = {"notPlayer", "notOthers", "notBosskill"},

	loc = GetLocale() == "koKR" and {
		disabletrigger = "대여사제 알로크|1이;가; 죽었습니다.",

		trigger1 = "내 귀여운 것들아, (.+)%|1을;를; 잡아먹어라!$",

		warn1 = "당신은 표적입니다!",
		warn2 = "%s님은 표적입니다!",
		bosskill = "대여사제 알로크를 물리쳤습니다!",
	} or GetLocale() == "deDE" and {
		disabletrigger = "Hohepriesterin Arlokk stribt.",

		trigger1 ="Labt euch an ([^%s]+), meine S\195\188\195\159en!$",

		warn1 = "Du bist markiert!",
		warn2 = "%s ist markiert!",
		bosskill = "Hohepriesterin Arlokk wurde besiegt!",
	
	} or {
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

