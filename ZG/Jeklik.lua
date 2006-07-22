local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsJeklik = AceAddon:new({
	name          = "BigWigsJeklik",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Zul'Gurub"),
	enabletrigger = bboss("High Priestess Jeklik"),
	bossname = bboss("High Priestess Jeklik"),

	toggleoptions = GetLocale() == "koKR" and {
		notBats = "박쥐 소환 경고",
		notHeal = "치유 시전 방해 알림",
		notBosskill = "보스 사망 알림",
	} or {
		notBats = "Warn on incoming bomb bats",
		notHeal = "Show Heal interrupt warnings",
		notBosskill = "Boss death",
	},

	optionorder = { "notBats", "notHeal", "notBosskill" },

	loc = GetLocale() == "koKR" and {
		trigger1 = "침략자들에게 뜨거운 맛을 보여줘라!$",
		trigger2 = "상급 치유를 시전하기 시작합니다!$",
		warn1 = "박쥐 소환!",
		warn2 = "치유 시전 - 시전 방해해주세요!",

		disabletrigger = "대여사제 제클릭|1이;가; 죽었습니다.",

		bosskill = "대여사제 제클릭을 물리쳤습니다!",
	} or GetLocale() == "zhCN" and {
		trigger1 = "我命令你把这些入侵者烧成灰烬！$",
		trigger2 = "开始释放强效治疗！$",
		warn1 = "炸弹蝙蝠来了！",
		warn2 = "高阶祭司耶克里克正在施放治疗，赶快打断它！",

		disabletrigger = "高阶祭司耶克里克死亡了。",

		bosskill = "高阶祭司耶克里克被击败了！",
	} or GetLocale() =="deDe" and{
		trigger1 =  "^Ich befehle Euch Feuer",
		trigger2 = "beginnt Gro\195\159es Heilen zu wirken!",
		warn1 = "Fledermaus Bomben im Anflug!",
		warn2 = "Heilversuch - unterbrechen!",

		disabletrigger = "Hohepriesterin Jeklik stirbt.",

		bosskill = "High Priestess Jeklik wurde besiegt!",
	
	} or {
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
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
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
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsJeklik:CHAT_MSG_MONSTER_YELL()
	if string.find(arg1, self.loc.trigger1) and not self:GetOpt("notBats") then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Yellow")
	end
end

function BigWigsJeklik:CHAT_MSG_MONSTER_EMOTE()
	if string.find(arg1, self.loc.trigger2) and not self:GetOpt("notHeal") then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "Orange")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsJeklik:RegisterForLoad()