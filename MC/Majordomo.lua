BigWigsMajordomo = AceAddon:new({
	name          = "BigWigsMajordomo",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "MC",
	enabletrigger = "Majordomo Executus",

	loc = {
		bossname = "Majordomo Executus",
		disabletrigger = "Impossible! Stay your attack, mortals... I submit! I submit!",

		trigger1 = "gains Magic Reflection",
		trigger2 = "gains Damage Shield",
		trigger3 = "Magic Reflection fades",
		trigger4 = "Damage Shield fades",

		warn1 = "Magic Reflection for 10 seconds!",
		warn2 = "Damage Shield for 10 seconds!",
		warn3 = "5 seconds until powers!",
		warn4 = " down!",
		bosskill = "Majordomo Executus has been defeated!",

		shields = {"Magic Reflection", "Damage Shield"},

		bar1text = "Magic Reflection",
		bar2text = "Damage Shield",
		bar3text = "New powers",
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
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar2text)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar3text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn3)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar3text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar3text, 20)
	self:UnregisterAllEvents()
end

function BigWigsMajordomo:CHAT_MSG_MONSTER_YELL()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsMajordomo:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (string.find(arg1, self.loc.trigger1)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 10, 1, "Red", "Interface\\Icons\\Spell_Frost_FrostShock")
		self:NewPowers()
		self.loc.aura = 1
	elseif (string.find(arg1, self.loc.trigger2)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar2text, 10, 1, "Red", "Interface\\Icons\\Spell_Shadow_AntiShadow")
		self:NewPowers()
		self.loc.aura = 2
	end
end

function BigWigsMajordomo:CHAT_MSG_SPELL_AURA_GONE_OTHER()
	if ((string.find(arg1, self.loc.trigger3)) or (string.find(arg1, self.loc.trigger4))) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.shields[self.loc.aura] .. self.loc.warn4, "Yellow")
		self.loc.aura = nil
	end
end

function BigWigsMajordomo:NewPowers()
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 25, "Orange")
	self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar3text, 30, 2, "Yellow", "Interface\\Icons\\Spell_Frost_Wisp")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar3text, 10, "Orange")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar3text, 20, "Red")
end
--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsMajordomo:RegisterForLoad()