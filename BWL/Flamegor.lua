local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsFlamegor = AceAddon:new({
	name          = "BigWigsFlamegor",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Blackwing Lair"),
	enabletrigger = bboss("Flamegor"),
	bossname = bboss("Flamegor"),

	toggleoptions = GetLocale() == "koKR" and {
		notWingBuffet = "폭풍 날개 경고",
		notShadowFlame = "암흑의 불길 경고",
		notFrenzy = "광란 경고",
		notBosskill = "보스 사망 알림",
	} or {
		notWingBuffet = "Warn for Wing Buffet",
		notShadowFlame = "Warn for Shadow Flame",
		notFrenzy = "Warn when Flamegor goes into a frenzy",
		notBosskill = "Boss death",
	},
	optionorder = {"notWingBuffet", "notShadowFlame", "notFrenzy", "notBosskill"},

	loc = GetLocale() == "koKR" and {
		disabletrigger = "플레임고르|1이;가; 죽었습니다.",

		trigger1 = "플레임고르|1이;가; 폭풍 날개|1을;를; 시전합니다.",
		trigger2 = "플레임고르|1이;가; 암흑의 불길|1을;를; 시전합니다.",
		trigger3 = "광란의 상태에 빠집니다!",

		warn1 = "플레임고르가 폭풍 날개를 시전합니다!",
		warn2 = "30초후 폭풍 날개!",
		warn3 = "3초후 폭풍 날개!",
		warn4 = "암흑의 불길 경보!",
		warn5 = "광란 - 평정 사격!",
		bosskill = "플레임고르를 물리쳤습니다!",

		bar1text = "폭풍 날개",
	}
		or GetLocale() == "deDE" and
	{
		disabletrigger = "Flammenmaul stirbt.",

		trigger1 = "Flammenmaul beginnt Fl\195\188gelsto\195\159 zu wirken.",
		trigger2 = "Flammenmaul beginnt Schattenflamme zu wirken.",
		trigger3 = "ger\195\164t in Raserei!",

		warn1 = "Flammenmaul beginnt Fl\195\188gelsto\195\159 zu wirken!",
		warn2 = "30 Sekunden bis zum n\195\64chsten Fl\195\188gelsto\195\159!",
		warn3 = "3 Sekunden bis Flammenmaul Fl\195\188gelsto\195\159 wirkt!",
		warn4 = "Schattenflamme kommt!",
		warn5 = "Raserei - Einlullender Schuss!",
		bosskill = "Flammenmaul wurde besiegt!",

		bar1text = "Fluegelgelstoss",
	}
		or GetLocale() == "zhCN" and
	{
		disabletrigger = "弗莱格尔死亡了。",

		trigger1 = "弗莱格尔开始施放龙翼打击。",
		trigger2 = "弗莱格尔开始施放暗影烈焰。",
		trigger3 = "变得狂暴起来！",

		warn1 = "弗莱格尔开始施放龙翼打击！",
		warn2 = "龙翼打击 - 30秒后再次发动",
		warn3 = "3秒后发动龙翼打击！",
		warn4 = "暗影烈焰发动！",
		warn5 = "狂暴警报 - 猎人立刻使用宁神射击！",
		bosskill = "弗莱格尔被击败了！",

		bar1text = "龙翼打击",
	}
		or
	{
		disabletrigger = "Flamegor dies.",

		trigger1 = "Flamegor begins to cast Wing Buffet",
		trigger2 = "Flamegor begins to cast Shadow Flame.",
		trigger3 = "goes into a frenzy!",

		warn1 = "Flamegor begins to cast Wing Buffet!",
		warn2 = "30 seconds till next Wing Buffet!",
		warn3 = "3 seconds before Flamegor casts Wing Buffet!",
		warn4 = "Shadow Flame incoming!",
		warn5 = "Frenzy - Tranq Shot!",
		bosskill = "Flamegor has been defeated!",

		bar1text = "Wing Buffet",
	},
})

function BigWigsFlamegor:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsFlamegor:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("BIGWIGS_SYNC_FLAMEGOR_WING_BUFFET")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "FLAMEGOR_WING_BUFFET", 10)
end

function BigWigsFlamegor:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn3)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 20)
end

function BigWigsFlamegor:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if (not self:GetOpt("notBosskill")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsFlamegor:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if (string.find(arg1, self.loc.trigger1)) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "FLAMEGOR_WING_BUFFET")
	elseif (arg1 == self.loc.trigger2 and not self:GetOpt("notShadowFlame")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn4, "Red")
	end
end

function BigWigsFlamegor:CHAT_MSG_MONSTER_EMOTE()
	if (arg1 == self.loc.trigger3 and not self:GetOpt("notFrenzy")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn5, "Red")
	end
end

function BigWigsFlamegor:BIGWIGS_SYNC_FLAMEGOR_WING_BUFFET()
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
BigWigsFlamegor:RegisterForLoad()