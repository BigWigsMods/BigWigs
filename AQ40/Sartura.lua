BigWigsSartura = AceAddon:new({
	name          = "BigWigsSartura",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = GetLocale() == "koKR" and "전투감시병 살투라" 
		or GetLocale() == "zhCN" and "沙尔图拉"
		or "Battleguard Sartura",

	loc = GetLocale() == "koKR" and {
		bossname = "전투감시병 살투라",
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
		bossname = "沙尔图拉",
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
		or 
	{	
		bossname = "Battleguard Sartura",
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
	BigWigs:RegisterModule(self)
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
	if (arg1 == self.loc.whirlwindon) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.whirlwindonwarn, "Red")
	elseif (arg1 == self.loc.whirlwindoff) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.whirlwindoffwarn, "Yellow")
	end
end

function BigWigsSartura:CHAT_MSG_MONSTER_YELL()
	if (string.find(arg1, self.loc.starttrigger)) then
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bartext, 600, 1, "Green", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.startwarn, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn1, 120, "Green")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn2, 300, "Yellow")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 420, "Yellow")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn4, 510, "Orange")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn5, 540, "Orange")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn6, 570, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn7, 590, "Red")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.bartext, 300, "Yellow")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.bartext, 510, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.bartext, 570, "Red")
	elseif (string.find(arg1, self.loc.disabletrigger)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory")
		self:Disable()
	end
end

function BigWigsSartura:CHAT_MSG_MONSTER_EMOTE()
	if (string.find(arg1, self.loc.enragetrigger)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragewarn, "Yellow")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsSartura:RegisterForLoad()