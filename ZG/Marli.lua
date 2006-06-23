local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsMarli = AceAddon:new({
	name          = "BigWigsMarli",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Zul'Gurub"),
	enabletrigger = bboss("High Priestess Mar'li"),
	bossname = bboss("High Priestess Mar'li"),

	toggleoptions = {
		notSpiders = "Spider spawn warnings",
		notDrain = "Drain life warnings",
		notBosskill = "Boss death",
	},

	loc = GetLocale() == "koKR" and {
		trigger1 = "어미를 도와라!$",
		trigger2 = "^High Priestess Mar'li's Drain Life heals High Priestess Mar'li for (.+).",

		warn1 = "거미 소환!",
		warn2 = "High Priestess Mar'li is draining life! Interrupt it!",

		disabletrigger = "대여사제 말리|1이;가; 죽었습니다.",

		bosskill = "대여사제 말리를 물리쳤습니다!",
	} or GetLocale() == "zhCN" and {
		trigger1 = "来为我作战吧，我的孩子们！$",
		trigger2 = "^高阶祭司玛尔里的生命吸取治疗了高阶祭司玛尔里(.+)。",

		warn1 = "蜘蛛出现！",
		warn2 = "高阶祭司玛尔里正在施放生命吸取，赶快打断她！",

		disabletrigger = "高阶祭司玛尔里死亡了。",

		bosskill = "高阶祭司玛尔里被击败了！",
	} or {
		trigger1 = "Aid me my brood!$",
		trigger2 = "^High Priestess Mar'li's Drain Life heals High Priestess Mar'li for (.+).",

		warn1 = "Spiders spawned!",
		warn2 = "High Priestess Mar'li is draining life! Interrupt it!",

		disabletrigger = "High Priestess Mar'li dies.",

		bosskill = "High Priest Mar'li has been defeated!",
	},
})

function BigWigsMarli:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsMarli:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
end

function BigWigsMarli:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsMarli:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if arg1 == self.loc.disabletrigger then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsMarli:CHAT_MSG_MONSTER_YELL()
	if string.find(arg1, self.loc.trigger1) and not self:GetOpt("notSpiders") then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Yellow")
	end
end

function BigWigsMarli:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if string.find(arg1, self.loc.trigger2) and not self:GetOpt("notDrain") then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "Orange")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsMarli:RegisterForLoad()