

BigWigsJeklik = AceAddon:new({
	name          = "BigWigsJeklik",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "ZG",
	enabletrigger = GetLocale() == "koKR" and "대여사제 제클릭" 
		or "High Priestess Jeklik",


	loc = GetLocale() == "koKR" and {
		bossname = "대여사제 제클릭",

		trigger1 = "침략자들에게 뜨거운 맛을 보여줘라!$",
		trigger2 = "상급 치유를 시전하기 시작합니다!$",
		warn1 = "박쥐 소환!",
		warn2 = "치유 시전 - 시전 방해해주세요!",

		disabletrigger = "대여사제 제클릭|1이;가; 죽었습니다.",

		bosskill = "대여사제 제클릭을 물리쳤습니다!",	
	} or {
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
