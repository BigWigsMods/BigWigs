local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsLucifron = AceAddon:new({
	name = "BigWigsLucifron",
	cmd = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Molten Core"),
	enabletrigger = bboss("Lucifron"),
	bossname = bboss("Lucifron"),
	
	toggleoptions = {
		notCurse = "Warn for Lucifron's Curse",
		notDoom= "Warn for Impending Doom",
		notBosskill = "Boss death",
	},
	optionorder = {"notCurse", "notDoom", "notBosskill"},

	loc = GetLocale() == "deDE" and
	{
		bossname = "Lucifron",
		disabletrigger = "Lucifron stirbt.",

		trigger1 = "betroffen von Lucifron",
		trigger2 = "betroffen von Impending Verdammnis",

		warn1 = "5 Sekunden bis Lucifrons Fluch!",
		warn2 = "Lucifrons Fluch - 20 Sekunden bis zum n\195\164chsten!",
		warn3 = "5 Sekunden bis Impending Verdammnis!",
		warn4 = "Impending Verdammnis - 20 Sekunden bis zum n\195\164chsten!",

		bar1text = "Lucifrons Fluch",
		bar2text = "Impending Verdammnis",
	}
		or GetLocale() == "koKR" and
	{
		bossname = "루시프론",
		disabletrigger = "루시프론|1이;가; 죽었습니다.",

		trigger1 = "루시프론의 저주에 걸렸습니다.",
		trigger2 = "파멸의 예언에 걸렸습니다.",

		warn1 = "5초후 루시프론의 저주!",
		warn2 = "루시프론의 저주 - 다음 저주는 20초후!",
		warn3 = "5초후 파멸의 예언!",
		warn4 = "파멸의 예언 - 다음 예언은 20초후!",

		bar1text = "루시프론의 저주",
		bar2text = "파멸의 예언",
	}
		or GetLocale() == "zhCN" and
	{
		bossname = "鲁西弗隆",
		disabletrigger = "鲁西弗隆死亡了。",

		trigger1 = "受到了鲁西弗隆的诅咒",
		trigger2 = "受到了末日降临",

		warn1 = "5秒后发动鲁西弗隆的诅咒！",
		warn2 = "鲁西弗隆的诅咒 - 20秒后再次发动",
		warn3 = "5秒后发动末日降临！",
		warn4 = "末日降临 - 20秒后再次发动",

		bar1text = "鲁西弗隆的诅咒",
		bar2text = "末日降临",
	}
		or
	{
		bossname = "Lucifron",
		disabletrigger = "Lucifron dies.",

		trigger1 = "afflicted by Lucifron",
		trigger2 = "afflicted by Impending Doom",

		warn1 = "5 seconds until Lucifron's Curse!",
		warn2 = "Lucifron's Curse - 20 seconds until next!",
		warn3 = "5 seconds until Impending Doom!",
		warn4 = "Impending Doom - 20 seconds until next!",

		bar1text = "Lucifron's Curse",
		bar2text = "Impending Doom",
	},
})

function BigWigsLucifron:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsLucifron:Enable()
	self.disabled = nil
	self:RegisterEvent("BIGWIGS_MESSAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsLucifron:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar2text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn1)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn3)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 15)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 15)
	self.prior1 = nil
	self.prior2 = nil
end

function BigWigsLucifron:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if arg1 == self.loc.disabletrigger then
		if (not self:GetOpt("notBosskill")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsLucifron:Event()
	if (not self.prior1 and string.find(arg1, self.loc.trigger1) and not self:GetOpt("notCurse")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn1, 15, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 20, 1, "Yellow", "Interface\\Icons\\Spell_Shadow_BlackPlague")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 15, "Red")
		self.prior1 = true
	elseif (not self.prior2 and string.find(arg1, self.loc.trigger2) and not self:GetOpt("notDoom")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn4, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 15, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar2text, 20, 2, "Yellow", "Interface\\Icons\\Spell_Shadow_NightOfTheDead")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar2text, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar2text, 15, "Red")
		self.prior2 = true
	end
end

function BigWigsLucifron:BIGWIGS_MESSAGE(text)
	if text == self.loc.warn1 then self.prior1 = nil
	elseif text == self.loc.warn3 then self.prior2 = nil end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsLucifron:RegisterForLoad()