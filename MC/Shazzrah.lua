BigWigsShazzrah = AceAddon:new({
	name          = "BigWigsShazzrah",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "MC",
	enabletrigger = GetLocale() == "koKR" and "샤즈라"
		or "Shazzrah",

	loc = GetLocale() == "koKR" and {	
		bossname = "샤즈라",
		disabletrigger = "샤즈라|1이;가; 죽었습니다.",

		trigger1 = "샤즈라|1이;가; 샤즈라의 문|1을;를; 시전합니다.",
		trigger2 = "샤즈라|1이;가; 마법 약화 효과를 얻었습니다.",

		warn1 = "점멸 - 30초후 재점멸!",
		warn2 = "5초후 점멸!",
		warn3 = "마법 약화 버프 - 마법 무효화를 사용하세요!",

		bar1text = "점멸",
	} or {
		bossname = "Shazzrah",
		disabletrigger = "Shazzrah dies.",

		trigger1 = "Shazzrah gains Blink",
		trigger2 = "Shazzrah gains Deaden Magic",

		warn1 = "Blink - 30 seconds to next!",
		warn2 = "5 seconds to Blink!",
		warn3 = "Self buff - Dispel Magic!",

		bar1text = "Blink",
	},
})

function BigWigsShazzrah:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsShazzrah:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsShazzrah:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn2)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 20)
end

function BigWigsShazzrah:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsShazzrah:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (string.find(arg1, self.loc.trigger1)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn2, 25, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 30, 1, "Yellow", "Interface\\Icons\\Spell_Arcane_Blink")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 20, "Red")
	elseif (string.find(arg1, self.loc.trigger2)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn3, "Red")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsShazzrah:RegisterForLoad()