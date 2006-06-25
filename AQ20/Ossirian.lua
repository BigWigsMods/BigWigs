local bboss = BabbleLib:GetInstance("Boss 1.2")


BigWigsOssirian = AceAddon:new({
	name          = "BigWigsOssirian",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Ruins of Ahn'Qiraj"),
	enabletrigger = bboss("Ossirian the Unscarred"),
	bossname = bboss("Ossirian the Unscarred"),

	toggleoptions = {
		notBosskill = "Boss death",
		notSupreme = "Supreme warning",
		notSupremeDelay = "Supreme x-sec warnings",
		notSupremeBar = "Supreme timerbar",
		notDebuff = "Debuff warning",
	},

	optionorder = {"notDebuff", "notSupremeBar", "notSupreme", "notSupremeDelay", "notBosskill"},

	loc = GetLocale() == "koKR" and {
		disabletrigger1 = "내가... 졌다.",
		disabletrigger2 = "무적의 오시리안|1이;가; 죽었습니다.",
		bosskill = "오시리안을 물리쳤습니다!",

		supremetrigger = "무적의 오시리안|1이;가; 오시리안의 힘 효과를 얻었습니다.",
		supremewarn = "오시리안 무적 상태!",
		supremedelaywarn = "%d초후 무적 상태 돌입!",
		debufftrigger = "무적의 오시리안|1이;가; (.+) 약점에 걸렸습니다.",
		debuffwarn = "오시리안이 %s 계열 마법에 약해졌습니다.",
		bartext = "무적 상태",
	}
		or GetLocale() == "zhCN" and
	{
		disabletrigger1 = "我……败……了。",
		disabletrigger2 = "无疤者奥斯里安死亡了。",
		bosskill = "无疤者奥斯里安被击败了！",

		supremetrigger = "无疤者奥斯里安获得了奥斯里安之力的效果。",
		supremewarn = "无疤者奥斯里安无敌了！速退！",
		supremedelaywarn = "%d秒后奥斯里安无敌",
		debufftrigger = "^无疤者奥斯里安受到了(.+)虚弱效果的影响。$",
		debuffwarn = "奥斯里安新法术弱点: %s",
		bartext = "无敌",
	}
		or
	{
		disabletrigger1 = "I...have...failed.",
		disabletrigger2 = "Ossirian the Unscarred dies.",
		bosskill = "Ossirian has been defeated!",

		supremetrigger = "Ossirian the Unscarred gains Strength of Ossirian.",
		supremewarn = "Ossirian Supreme Mode!",
		supremedelaywarn = "Supreme in %d seconds!",
		debufftrigger = "^Ossirian the Unscarred is afflicted by (.+) Weakness%.$",
		debuffwarn = "Ossirian now weak to %s",
		bartext = "Supreme",
	},
})

function BigWigsOssirian:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsOssirian:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "checkEnd")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL", "checkEnd")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
end

function BigWigsOssirian:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", format(self.loc.supremedelaywarn, 30))
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", format(self.loc.supremedelaywarn, 40))
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bartext)
end

function BigWigsOssirian:checkEnd()
    if (arg1 == self.loc.disabletrigger1 or arg1 == self.loc.disabletrigger2) then
        if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
        self:Disable()
    end
end

function BigWigsOssirian:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (arg1 == self.loc.supremetrigger) then
		if not self:GetOpt("notSupreme") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.supremewarn, "Yellow") end
	end
end

function BigWigsOssirian:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE()
	local _, _, debuffName = string.find(arg1, self.loc.debufftrigger)
	if (debuffName) then
		if not self:GetOpt("notDebuff") then self:TriggerEvent("BIGWIGS_MESSAGE", format(self.loc.debuffwarn, debuffName), "Red") end

		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", format(self.loc.supremedelaywarn, 30))
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", format(self.loc.supremedelaywarn, 40))
		self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bartext)

		if not self:GetOpt("notSupremeDelay") then
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.supremedelaywarn, 15), 30, "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.supremedelaywarn, 5), 40, "Red")
		end
		if not self:GetOpt("notSupremeBar") then self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bartext, 45, 1, "Green", "Interface\\Icons\\Spell_Shadow_CurseOfTounges") end
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsOssirian:RegisterForLoad()