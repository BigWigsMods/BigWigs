local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsHakkar = AceAddon:new({
	name          = "BigWigsHakkar",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Zul'Gurub"),
	enabletrigger = bboss("Hakkar"),
	bossname = bboss("Hakkar"),

	toggleoptions = GetLocale() == "koKR" and {
		notEnrageBar = "격노 타이머",
		notDrainBar = "생명력 흡수 타이머",
		notEngage = "시작 알림",
		notDrain90 = "생흡 90초전 경고",
		notDrain60 = "생흡 60초전 경고",
		notDrain45 = "생흡 45초전 경고",
		notDrain15 = "생흡 15초전 경고",
		notBosskill = "보스 사망",
	} or {
		notEnrageBar = "Enrage timer",
		notDrainBar = "Drain timer",
		notEngage = "Announce battle start",
		notDrain90 = "Drain 90-sec warning",
		notDrain60 = "Drain 60-sec warning",
		notDrain45 = "Drain 45-sec warning",
		notDrain15 = "Drain 15-sec warning",
		notBosskill = "Boss death",
	},
	optionorder = {"notEngage", "notEnrageBar", "notDrainBar", "notDrain90", "notDrain60", "notDrain45", "notDrain15", "notBosskill"},

	loc = GetLocale() == "koKR" and {
		disabletrigger = "학카르|1이;가; 죽었습니다.",
				 
		trigger1 = "자만심은 세상의 종말을 불러올 뿐이다. 오너라! 건방진 피조물들이여! 와서 신의 진노에 맞서 보아라!",
		trigger2 = "학카르|1이;가; (.+)의 피의 착취에 의해 (.+)의 자연 피해를 입었습니다.",
		flee = "Fleeing will do you no good mortals!",

		start = "학카르 시작 - 90초후 생명력 흡수 - 10분후 격노",
		warn1 = "생명력 흡수 60초전",
		warn2 = "생명력 흡수 45초전",
		warn3 = "생명력 흡수 15초전",
		warn4 = "생명력 흡수 - 다음 시전은 90초후",
		bosskill = "학카르를 물리쳤습니다!",

		bar1text = "격노",
		bar2text = "생명력 흡수",

	} or GetLocale() == "zhCN" and {
		disabletrigger = "哈卡死亡了。",

		trigger1 = "^骄傲会将你送上绝路",
		trigger2 = "^(.+)的酸性血液虹吸使哈卡受到了(%d+)点自然伤害。",
		flee = "逃跑",

		start = "哈卡已经激活 - 90秒后开始生命吸取 - 10分钟后进入激怒状态",
		warn1 = "60秒后开始生命吸取",
		warn2 = "45秒后开始生命吸取",
		warn3 = "15秒后开始生命吸取",
		warn4 = "血液虹吸 - 90秒后再次发动",
		bosskill = "哈卡被击败了！",

		bar1text = "激怒",
		bar2text = "生命吸取",
	} or {
		disabletrigger = "Hakkar dies.",

		trigger1 = "FACE THE WRATH OF THE SOULFLAYER!",
		trigger2 = "^Hakkar suffers (.+) from (.+) Blood Siphon",
		flee = "Fleeing will do you no good mortals!",

		start = "Hakkar engaged - 90 seconds until drain - 10 minutes until enrage",
		warn1 = "60 seconds until drain",
		warn2 = "45 seconds until drain",
		warn3 = "15 seconds until drain",
		warn4 = "Life Drain - 90 seconds until next",
		bosskill = "Hakkar has been defeated!",

		bar1text = "Enrage",
		bar2text = "Life Drain",
	},
})

function BigWigsHakkar:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsHakkar:Enable()
	self.disabled = nil
	self.prior = nil
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("BIGWIGS_MESSAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsHakkar:Disable()
	self.disabled = true
	self:Reset()
	self:UnregisterAllEvents()
end

function BigWigsHakkar:Reset()
	self.prior = nil
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar2text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn1)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn2)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn3)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 30)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 45)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 75)
end

function BigWigsHakkar:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if arg1 == self.loc.disabletrigger then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsHakkar:CHAT_MSG_MONSTER_YELL()
	if string.find(arg1, self.loc.trigger1) then
		if not self:GetOpt("notEngage") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.start, "Green") end
		if not self:GetOpt("notEnrageBar") then self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 600, 1, "Purple", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy") end
		self:BeginTimers(true)
	elseif string.find(arg1, self.loc.flee) then
		self:Reset()
	end
end

function BigWigsHakkar:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE()
	if not self.prior and string.find(arg1, self.loc.trigger2) then
		self.prior = true
		self:BeginTimers()
	end
end

function BigWigsHakkar:BIGWIGS_MESSAGE(text)
	if text == self.loc.warn1 then self.prior = nil end
end

function BigWigsHakkar:BeginTimers(first)
	if not first and not self:GetOpt("notDrain90") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn4, "Green") end
	if not self:GetOpt("notDrainBar") then self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar2text, 90, 2, "Green", "Interface\\Icons\\Spell_Shadow_LifeDrain") end
	if not self:GetOpt("notDrain60") then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn1, 30, "Yellow") end
	if not self:GetOpt("notDrain45") then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn2, 45, "Orange") end
	if not self:GetOpt("notDrain15") then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 75, "Red") end
	if not self:GetOpt("notDrainBar") then self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar2text, 30, "Yellow") end
	if not self:GetOpt("notDrainBar") then self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar2text, 45, "Orange") end
	if not self:GetOpt("notDrainBar") then self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar2text, 75, "Red") end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsHakkar:RegisterForLoad()