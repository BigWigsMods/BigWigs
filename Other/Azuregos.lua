BigWigsAzuregos = AceAddon:new({
	name          = "BigWigsAzuregos",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "Azshara",
	enabletrigger = GetLocale() == "koKR" and "아주어고스"
		or GetLocale() == "zhCN" and "艾索雷葛斯"
		or "Azuregos",

	loc = GetLocale() == "koKR" and {
		bossname = "Azuregos",
		disabletrigger = "아주어고스|1이;가; 죽었습니다.",

		trigger1 = "오너라, 조무래기들아! 덤벼봐라!",
		trigger2 = "아주어고스의 몸에서 반사 효과가 사라졌습니다.",
		trigger3 = "아주어고스|1이;가; 반사 효과를",

		warn1 = "강제 소환!",
		warn2 = "마법 보호막 소멸!",
		warn3 = "마법 보호막 동작 - 마법 공격 금지!",
		bosskill = "아주어고스를 물리쳤습니다!",
	} 
		or GetLocale() == "zhCN" and 
	{
		bossname = "艾索雷葛斯",
		disabletrigger = "艾索雷葛斯死亡了。",

		trigger1 = "来吧，小子。面对我！",
		trigger2 = "^反射效果从艾索雷葛斯身上消失",
		trigger3 = "^艾索雷葛斯获得了反射",

		warn1 = "传送发动！",
		warn2 = "魔法护盾消失！",
		warn3 = "魔法护盾开启 - 不要施放法术！",
		bosskill = "艾索雷葛斯被击败了！",
	}
		or 
	{
		bossname = "Azuregos",
		disabletrigger = "Azuregos dies.",

		trigger1 = "Come, little ones",
		trigger2 = "^Reflection fades from Azuregos",
		trigger3 = "^Azuregos gains Reflection",

		warn1 = "Teleport!",
		warn2 = "Magic Shield down!",
		warn3 = "Magic Shield up - Do not cast spells!",
		bosskill = "Azuregos has been defeated!",
	},
})

function BigWigsAzuregos:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsAzuregos:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsAzuregos:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsAzuregos:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsAzuregos:CHAT_MSG_MONSTER_YELL()
	if (string.find(arg1, self.loc.trigger1)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red")
	end
end

function BigWigsAzuregos:CHAT_MSG_SPELL_AURA_GONE_OTHER()
	if (string.find(arg1, self.loc.trigger2)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "White")
	end
end

function BigWigsAzuregos:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (string.find(arg1, self.loc.trigger3)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn3, "Red")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsAzuregos:RegisterForLoad()