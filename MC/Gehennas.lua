BigWigsGehennas = AceAddon:new({
	name          = "BigWigsGehennas",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "MC",
	enabletrigger = GetLocale() == "koKR" and "게헨나스"
		or GetLocale() == "zhCN" and "基赫纳斯"
		or "Gehennas",

	loc = GetLocale() == "koKR" and {
		bossname = "게헨나스",
		disabletrigger = "게헨나스|1이;가; 죽었습니다.",

		trigger1 = "게헨나스의 저주에 걸렸습니다.",

		warn1 = "5초후 게헨나스의 저주!",
		warn2 = "게헨나스의 저주 - 다음 저주 30초후!",

		bar1text = "게헨나스의 저주",
	}
		or GetLocale() == "zhCN" and
	{
		bossname = "基赫纳斯",
		disabletrigger = "基赫纳斯死亡了。",

		trigger1 = "受到了基赫纳斯的诅咒",

		warn1 = "5秒后发动基赫纳斯的诅咒！",
		warn2 = "基赫纳斯的诅咒 - 30秒后再次发动",

		bar1text = "基赫纳斯的诅咒",
	} or {
		bossname = "Gehennas",
		disabletrigger = "Gehennas dies.",

		trigger1 = "afflicted by Gehennas",

		warn1 = "5 seconds until Gehennas's Curse!",
		warn2 = "Gehennas's Curse - 30 seconds until next!",

		bar1text = "Gehennas's Curse",
	},
})

function BigWigsGehennas:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsGehennas:Enable()
	self.disabled = nil
	self:RegisterEvent("BIGWIGS_MESSAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsGehennas:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn1)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 20)
	self.prior = nil
end

function BigWigsGehennas:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if arg1 == self.loc.disabletrigger then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory")
		self:Disable()
	end
end

function BigWigsGehennas:Event()
	if (not self.prior and string.find(arg1, self.loc.trigger1)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn1, 25, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 30, 1, "Yellow", "Interface\\Icons\\Spell_Shadow_BlackPlague")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 20, "Red")
		self.prior = true
	end
end

function BigWigsGehennas:BIGWIGS_MESSAGE(text)
	if text == self.loc.warn1 then self.prior = nil end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsGehennas:RegisterForLoad()