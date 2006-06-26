local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsMajordomo = AceAddon:new({
	name = "BigWigsMajordomo",
	cmd = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Molten Core"),
	enabletrigger = bboss("Majordomo Executus"),
	bossname = bboss("Majordomo Executus"),

	toggleoptions = {
		notMagic = "Warn for Magic Reflection",
		notDmg = "Warn for Damage Shields",
		notBosskill = "Boss death",
	},
	optionorder = {"notMagic", "notDmg", "notBosskill"},

	loc = GetLocale() == "koKR" and {
		bossname = "청지기 이그젝큐투스",
		disabletrigger = "이럴 수가! 그만! 제발 그만! 내가 졌다! 내가 졌어!",

		trigger1 = "마법 반사 효과를 얻었습니다.",
		trigger2 = "피해 보호막 효과를 얻었습니다.",
		trigger3 = "마법 반사 효과가 사라졌습니다.",
		trigger4 = "피해 보호막 효과가 사라졌습니다.",

		warn1 = "마법 보호막 - 10초간!",
		warn2 = "피해 보호막 - 10초간!",
		warn3 = "5초후 버프!",
		warn4 = "마법 반사 사라짐!",
		warn5 = "피해 보호 사라짐!",
		bosskill = "청지기를 물리쳤습니다!",

		bar1text = "마법 반사",
		bar2text = "피해 보호막",
		bar3text = "새로운 버프",

		texture1 = "Interface\\Icons\\Spell_Frost_FrostShock",
		texture2 = "Interface\\Icons\\Spell_Shadow_AntiShadow",
	}
		or GetLocale() == "zhCN" and
	{
		bossname = "管理者埃克索图斯",
		disabletrigger = "不可能！等一下",

		trigger1 = "获得了魔法反射的效果",
		trigger2 = "获得了伤害反射护盾的效果",
		trigger3 = "魔法反射效果从",
		trigger4 = "伤害反射护盾效果从",

		warn1 = "魔法反射护盾，持续10秒！",
		warn2 = "伤害反射护盾，持续10秒！",
		warn3 = "5秒后可以攻击！",
		warn4 = "魔法反射护盾已消失！",
		warn5 = "伤害反射护盾已消失！",
		bosskill = "管理者埃克索图斯被击败了！",

		bar1text = "魔法反射护盾",
		bar2text = "伤害反射护盾",
		bar3text = "新生力量",

		texture1 = "Interface\\Icons\\Spell_Frost_FrostShock",
		texture2 = "Interface\\Icons\\Spell_Shadow_AntiShadow",
	} or {
		bossname = "Majordomo Executus",
		disabletrigger = "Impossible! Stay your attack, mortals... I submit! I submit!",

		trigger1 = "gains Magic Reflection",
		trigger2 = "gains Damage Shield",
		trigger3 = "Magic Reflection fades",
		trigger4 = "Damage Shield fades",

		warn1 = "Magic Reflection for 10 seconds!",
		warn2 = "Damage Shield for 10 seconds!",
		warn3 = "5 seconds until powers!",
		warn4 = "Magic Reflection down!",
		warn5 = "Damage Shield down!",
		bosskill = "Majordomo Executus has been defeated!",

		bar1text = "Magic Reflection",
		bar2text = "Damage Shield",
		bar3text = "New powers",

		texture1 = "Interface\\Icons\\Spell_Frost_FrostShock",
		texture2 = "Interface\\Icons\\Spell_Shadow_AntiShadow",
	},
})

function BigWigsMajordomo:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsMajordomo:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

function BigWigsMajordomo:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar2text)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar3text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn3)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar3text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar3text, 20)
end

function BigWigsMajordomo:CHAT_MSG_MONSTER_YELL()
	if (arg1 == self.loc.disabletrigger) then
		if (not self:GetOpt("notBosskill")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsMajordomo:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (string.find(arg1, self.loc.trigger1) and not self.aura and not self:GetOpt("notMagic")) then self:NewPowers(1)
	elseif (string.find(arg1, self.loc.trigger2) and not self.aura and not self:GetOpt("notDmg")) then self:NewPowers(2) end
end

function BigWigsMajordomo:CHAT_MSG_SPELL_AURA_GONE_OTHER()
	if ((string.find(arg1, self.loc.trigger3) or string.find(arg1, self.loc.trigger4)) and self.aura) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.aura == 1 and self.loc.warn4 or self.loc.warn5, "Yellow")
		self.aura = nil
	end
end

function BigWigsMajordomo:NewPowers(power)
	self.aura = power
	self:TriggerEvent("BIGWIGS_MESSAGE", power == 1 and self.loc.warn1 or self.loc.warn2, "Red")
	self:TriggerEvent("BIGWIGS_BAR_START", power == 1 and self.loc.bar1text or self.loc.bar2text, 10, 1, "Red", power == 1 and self.loc.texture1 or self.loc.texture2)
	self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar3text, 30, 2, "Yellow", "Interface\\Icons\\Spell_Frost_Wisp")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 25, "Orange")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar3text, 10, "Orange")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar3text, 20, "Red")
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsMajordomo:RegisterForLoad()