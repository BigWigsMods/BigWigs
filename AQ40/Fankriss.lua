local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsFankriss = AceAddon:new({
	name          = "BigWigsFankriss",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Ahn'Qiraj"),
	enabletrigger = bboss("Fankriss the Unyielding"),
	bossname = bboss("Fankriss the Unyielding"),

	toggleoptions = GetLocale() == "koKR" and {
		notBosskill = "보스 사망 알림",
		notWormWarn = "벌레 경고",
	} or {
		notBosskill = "Boss death",
		notWormWarn = "Worm warnings",
	},

	optionorder = {"notWormWarn", "notBosskill"},


	loc = GetLocale() == "koKR" and {
		disabletrigger = "불굴의 판크리스|1이;가; 죽었습니다.",
		bosskill = "불굴의 판크리스를 물리쳤습니다!",

		wormtrigger = "불굴의 판크리스|1이;가; 벌레 소환|1을;를; 시전합니다.",
		wormwarn = "벌레 소환 - 제거!",
	}
		or GetLocale() == "zhCN" and
	{
		disabletrigger = "顽强的范克瑞斯死亡了。",
		bosskill = "顽强的范克瑞斯被击败了！",

		wormtrigger = "顽强的范克瑞斯施放了召唤虫子。",
		wormwarn = "虫子出现 - 赶快杀掉！",
	}
		or
	{
		disabletrigger = "Fankriss the Unyielding dies.",
		bosskill = "Fankriss the Unyielding has been defeated!",

		wormtrigger = "Fankriss the Unyielding casts Summon Worm.",
		wormwarn = "Incoming Worm - Kill it!",
	},
})

function BigWigsFankriss:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsFankriss:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsFankriss:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsFankriss:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsFankriss:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if (not self:GetOpt("notWormWarn") and arg1 == self.loc.wormtrigger ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.wormwarn, "Orange")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsFankriss:RegisterForLoad()