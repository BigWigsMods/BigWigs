local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsSartura = AceAddon:new({
	name          = "BigWigsSartura",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Temple of Ahn'Qiraj"),
	enabletrigger = bboss("Battleguard Sartura"),
	bossname = bboss("Battleguard Sartura"),

	toggleoptions = {
		notBosskill = "Boss death",
		notWhirlwindWarn = "Whirlwind warnings",
		notStartWarn = "Start warning",
		notEnrageBar = "Enrage timer",
		notEnrageTimer = "Timer warnings",
		notEnrageWarn = "Enrage warning",
	},

	optionorder = { "notStartWarn", "notWhirlwindWarn", "notEnrageBar", "notEnrageTimer", "notEnrageWarn", "notBosskill"},


	loc = GetLocale() == "koKR" and {
		disabletrigger = "최후의 그날까지!",
		bosskill = "전투감시병 살투라를 물리쳤습니다!",

		-- starttrigger = "You will be judged for defiling these sacred grounds! The laws of the Ancients will not be challenged! Trespassers will be annihilated!",
		starttrigger = "성스러운 땅을 더럽힌 죄값을 받게 되리라. 고대의 법률은 거스를 수 없다! 침입자들을 처단하라!",
		startwarn = "살투라 격노 - 10분후 다음 격노",
		enragetrigger = "becomes enraged",
		enragewarn = "격노 - 격노 - 격노",
		bartext = "격노",
		warn1 = "격노 - 8분후",
		warn2 = "격노 - 5분후",
		warn3 = "격노 - 3분후",
		warn4 = "격노 - 90초",
		warn5 = "격노 - 60초",
		warn6 = "격노 - 30초",
		warn7 = "격노 - 10초",
		whirlwindon = "전투감시병 살투라|1이;가; 소용돌이 효과를 얻었습니다.",
		whirlwindoff = "전투감시병 살투라의 몸에서 소용돌이 효과가 사라졌습니다.",
		whirlwindonwarn = "소용돌이 - 전투감시병 살투라 - 소용돌이",
		whirlwindoffwarn = "소용돌이 사라짐. 스턴! 스턴! 스턴!",	
	}
		or GetLocale() == "zhCN" and
	{ 
		disabletrigger = "我战斗到了最后一刻！",
		bosskill = "沙尔图拉被击败了！",

		-- starttrigger = "You will be judged for defiling these sacred grounds!  The laws of the Ancients will not be challenged!  Trespassers will be annihilated!\n",
		starttrigger = "我宣判你死刑",
		startwarn = "沙尔图拉已激活 - 10分钟后进入激怒状态",
		enragetrigger = "沙尔图拉进入激怒状态！",
		enragewarn = "激怒 - 激怒 - 激怒",
		bartext = "激怒",
		warn1 = "8分钟后激怒",
		warn2 = "5分钟后激怒",
		warn3 = "3分钟后激怒",
		warn4 = "90秒后激怒",
		warn5 = "60秒后激怒",
		warn6 = "30秒后激怒",
		warn7 = "10秒后激怒",
		whirlwindon = "沙尔图拉获得了旋风斩的效果。",
		whirlwindoff = "旋风斩效果从沙尔图拉身上消失。",
		whirlwindonwarn = "旋风斩 - 沙尔图拉 - 旋风斩",
		whirlwindoffwarn = "旋风斩消失！",
	}	
		or GetLocale() == "deDE" and
	{	
		disabletrigger = "Ich diene bis",
		bosskill = "Schlachtwache Sartura wurde besiegt!",

		-- starttrigger = "Ihr habt heiligen Boden entweiht;  The laws of the Ancients will not be challenged!  Trespassers will be annihilated!\n",
		starttrigger = "Ihr habt heiligen Boden entweiht",
		startwarn = "Kampf mit Sartura hat begonnen - 10 Minuten bis Rage",
		enragetrigger = "ger\195\164t in t\195\182dliche Raserei",
		enragewarn = "Rage - Rage - Rage",
		bartext = "Rage",
		warn1 = "Rage in 8 Minuten",
		warn2 = "Rage in 5 Minuten",
		warn3 = "Rage in 3 Minuten",
		warn4 = "Rage in 90 Sekunden",
		warn5 = "Rage in 60 Sekunden",
		warn6 = "Rage in 30 Sekunden",
		warn7 = "Rage in 10 Sekunden",
		whirlwindon = "Schlachtwache Sartura bekommt 'Wirbelwind'.",
		whirlwindoff = "Wirbelwind schwindet von Schlachtwache Sartura.",
		whirlwindonwarn = "Wirbelwind - Schlachtwache Sartura - Wirbelwind",
		whirlwindoffwarn = "Wirbelwind verschwunden. Draufhauen! Draufhauen! Draufhauen!",
	}
	  or
	{	
		disabletrigger = "I serve to the last",
		bosskill = "Battleguard Sartura has been defeated!",

		-- starttrigger = "You will be judged for defiling these sacred grounds!  The laws of the Ancients will not be challenged!  Trespassers will be annihilated!\n",
		starttrigger = "defiling these sacred grounds",
		startwarn = "Sartura engaged - 10 minutes until Enrage",
		enragetrigger = "becomes enraged",
		enragewarn = "Enrage - Enrage - Enrage",
		bartext = "Enrage",
		warn1 = "Enrage in 8 minutes",
		warn2 = "Enrage in 5 minutes",
		warn3 = "Enrage in 3 minutes",
		warn4 = "Enrage in 90 seconds",
		warn5 = "Enrage in 60 seconds",
		warn6 = "Enrage in 30 seconds",
		warn7 = "Enrage in 10 seconds",
		whirlwindon = "Battleguard Sartura gains Whirlwind.",
		whirlwindoff = "Whirlwind fades from Battleguard Sartura.",
		whirlwindonwarn = "Whirlwind - Battleguard Sartura - Whirlwind",
		whirlwindoffwarn = "Whirlwind faded. Spank! Spank! Spank!",
	},
})

function BigWigsSartura:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsSartura:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
end

function BigWigsSartura:Disable()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn1)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn2)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn3)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn4)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn5)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn6)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn7)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bartext, 300)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bartext, 510)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bartext, 570)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bartext)
	self:UnregisterAllEvents()
end

function BigWigsSartura:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	ace:print(arg1)
	if (arg1 == self.loc.whirlwindon) then
		if not self:GetOpt("notWhirlwindWarn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.whirlwindonwarn, "Red") end
	elseif (arg1 == self.loc.whirlwindoff) then
		if not self:GetOpt("notWhirlwindWarn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.whirlwindoffwarn, "Yellow") end
	end
end

function BigWigsSartura:CHAT_MSG_MONSTER_YELL()
	if (string.find(arg1, self.loc.starttrigger)) then
		if not self:GetOpt("notStartWarn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.startwarn, "Red") end
		if not self:GetOpt("notEnrageBar") then
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bartext, 600, 1, "Green", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.bartext, 300, "Yellow")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.bartext, 510, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.bartext, 570, "Red")
		end
		if not self:GetOpt("notEnrageTimer") then
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn1, 120, "Green")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn2, 300, "Yellow")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 420, "Yellow")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn4, 510, "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn5, 540, "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn6, 570, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn7, 590, "Red")
		end
	elseif (string.find(arg1, self.loc.disabletrigger)) then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsSartura:CHAT_MSG_MONSTER_EMOTE()
	if (string.find(arg1, self.loc.enragetrigger)) then
		if not self:GetOpt("notEnrageWarn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragewarn, "Yellow") end
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsSartura:RegisterForLoad()