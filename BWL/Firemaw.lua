local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsFiremaw = AceAddon:new({
	name          = "BigWigsFiremaw",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Blackwing Lair"),
	enabletrigger = bboss("Firemaw"),
	bossname = bboss("Firemaw"),

	toggleoptions = GetLocale() == "koKR" and {
		notWingBuffet = "폭풍 날개 경고",
		notShadowFlame = "암흑 불길 경고",
		notBosskill = "보스 사망 알림",
	} or {
		notWingBuffet = "Warn for Wing Buffet",
		notShadowFlame = "Warn for Shadow Flame",
		notBosskill = "Boss death",
	},
	optionorder = {"notWingBuffet", "notShadowFlame", "notBosskill"},

	loc = GetLocale() == "koKR" and {
		disabletrigger = "화염아귀|1이;가; 죽었습니다.",

		trigger1 = "화염아귀|1이;가; 폭풍 날개|1을;를; 시전합니다.",
		trigger2 = "화염아귀|1이;가; 암흑의 불길|1을;를; 시전합니다.",

		warn1 = "화염 아귀가 폭풍 날개를 시전합니다!",
		warn2 = "30초후 다음 폭풍 날개!",
		warn3 = "3초 후 폭풍 날개!",
		warn4 = "암흑 불길 경고!",
		bosskill = "화염아귀를 물리쳤습니다!",

		bar1text = "폭풍 날개",
	}
		or GetLocale() == "deDE" and
	{
		disabletrigger = "Feuerschwinge stirbt.",

		trigger1 = "Feuerschwinge beginnt Fl\195\188gelsto\195\159 zu wirken.",
		trigger2 = "Feuerschwinge beginnt Schattenflamme zu wirken.",

		warn1 = "Feuerschwinge beginnt Fl\195\188gelsto\195\159 zu wirken!",
		warn2 = "30 Sekunden bis zum n\195\164chsten Fl\195\188gelsto\195\159!",
		warn3 = "3 Sekunden bis Feuerschwinge Fl\195\188gelsto\195\159 zaubert!",
		warn4 = "Schattenflamme kommt!",
		bosskill = "Feuerschwinge wurde besiegt!",

		bar1text = "Fluegelgelstoss",
	}
		or GetLocale() == "zhCN" and
	{
		disabletrigger = "费尔默死亡了。",

		trigger1 = "费尔默开始施放龙翼打击。",
		trigger2 = "费尔默开始施放暗影烈焰。",

		warn1 = "费尔默开始施放龙翼打击！",
		warn2 = "龙翼打击 - 30秒后再次发动",
		warn3 = "3秒后发动龙翼打击！",
		warn4 = "暗影烈焰发动！",
		bosskill = "费尔默被击败了！",

		bar1text = "龙翼打击",
	}
		or
	{
		disabletrigger = "Firemaw dies.",

		trigger1 = "Firemaw begins to cast Wing Buffet",
		trigger2 = "Firemaw begins to cast Shadow Flame.",

		warn1 = "Firemaw begins to cast Wing Buffet!",
		warn2 = "30 seconds till next Wing Buffet!",
		warn3 = "3 seconds before Firemaw casts Wing Buffet!",
		warn4 = "Shadow Flame Incoming!",
		bosskill = "Firemaw has been defeated!",

		bar1text = "Wing Buffet",
	},
})

function BigWigsFiremaw:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsFiremaw:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("BIGWIGS_SYNC_FIREMAW_WING_BUFFET")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "FIREMAW_WING_BUFFET", 10)
end

function BigWigsFiremaw:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn3)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 20)
end

function BigWigsFiremaw:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if (not self:GetOpt("notBosskill")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsFiremaw:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if (string.find(arg1, self.loc.trigger1)) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "FIREMAW_WING_BUFFET")
	elseif (arg1 == self.loc.trigger2 and not self:GetOpt("notShadowFlame")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn4, "Red")
	end
end

function BigWigsFiremaw:BIGWIGS_SYNC_FIREMAW_WING_BUFFET()
	if (not self:GetOpt("notWingBuffet")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red")
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "Yellow")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 29, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 32, 1, "Yellow", "Interface\\Icons\\Spell_Fire_SelfDestruct")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 20, "Red")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsFiremaw:RegisterForLoad()