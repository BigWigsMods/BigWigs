BigWigsMajordomo = AceAddon:new({
	name          = "BigWigsMajordomo",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "MC",
	enabletrigger = GetLocale() == "koKR" and "청지기"
		or "Majordomo Executus",

	loc = GetLocale() == "koKR" and {
		bossname = "청지기",
		disabletrigger = "Impossible! Stay your attack, mortals... I submit! I submit!",

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
	BigWigs:RegisterModule(self)
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
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsMajordomo:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (string.find(arg1, self.loc.trigger1) and not self.aura) then self:NewPowers(1)
	elseif (string.find(arg1, self.loc.trigger2) and not self.aura) then self:NewPowers(2) end
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