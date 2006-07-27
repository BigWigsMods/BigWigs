local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsFaerlina = AceAddon:new({
	name	= "BigWigsFaerlina",
	cmd		= AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Naxxramas"),
	enabletrigger = bboss("Grand Widow Faerlina"),
	bossname = bboss("Grand Widow Faerlina"),

	toggleoptions = GetLocale() == "koKR" and {
		notEnrageWarn = "격노 경고",
		notEnrageBar = "다음 격노 타이머 바 보이기",
		notSilenceWarn = "침묵 시전, 격노 지연 경고",
		notBosskill = "보스 사망 알림",
	} or {
		notEnrageWarn = "Warn for Enrage",
		notEnrageBar = "Show the timer bar for the next Enrage",
		notSilenceWarn = "Warn when silence is casted and enrage is delayed",
		notBosskill = "Boss death",
	},
	optionorder = {"notEnrageWarn", "notEnrageBar", "notSilenceWarn", "notBosskill"},

	loc = GetLocale() == "koKR" and { 	
		disabletrigger = "귀부인 팰리나|1이;가; 죽었습니다.",		
		bosskill = "귀부인 팰리나를 물리쳤습니다!",

		starttrigger1 = "내 앞에 무릎을 꿇어라, 벌레들아!",
		starttrigger2 = "주인님의 이름으로 처단하라!",
		starttrigger3 = "나에게서 도망칠 수는 없다!",
		starttrigger4 = "두 발이 성할 때 도망쳐라!",
		
		silencetrigger = "낙스라마스 숭배자|1이;가; 귀부인의 은총에 걸렸습니다.",
		enragetrigger = "귀부인 팰리나|1이;가; 격노 효과를 얻었습니다.",
		
		startwarn = "시작 또는 격노!",
		enragewarn15sec = "15초후 격노!",
		enragewarn = "격노!",
		silencewarn = "침묵! 격노 연기!",

		enragebar = "Enrage",
	} or GetLocale() == "deDE" and { 
		disabletrigger = "Gro\195\159witwe Faerlina stirbt.",		
		bosskill = "Gro\195\159witwe Faerlina wurde besiegt!",

		starttrigger1 = "Kniet nieder, Wurm!",
		starttrigger2 = "T\195\182tet sie im Namen des Meisters!",
		starttrigger3 = "Ihr k\195\182nnt euch nicht vor mir verstecken!",
		starttrigger4 = "Flieht, solange ihr noch k\195\182nnt.",

		silencetrigger = "J\195\188nger von Naxxramas ist von Umarmung der Witwe betroffen.",
		enragetrigger = "Gro\195\159witwe Faerlina bekommt 'Wutanfall'.",

		startwarn = "Start oder Enrage!",
		enragewarn15sec = "15 s bis Enrage!",
		enragewarn = "Enrage!",
    enrageremovewarn = "Enrage entfernt! N\195\164chstes in %d Sekunden!",
		silencewarn = "Silence! Enrage verz\195\182gert!",

		enragebar = "Enrage",
	} or {
		disabletrigger = "Grand Widow Faerlina dies.",		
		bosskill = "Grand Widow Faerlina has been defeated!",

		starttrigger1 = "Kneel before me, worm!",
		starttrigger2 = "Slay them in the master's name!",
		starttrigger3 = "You cannot hide from me!",
		starttrigger4 = "Run while you still can!",

		silencetrigger = "Grand Widow Faerlina is afflicted by Widow's Embrace.", -- EDITED it affects her too.
		enragetrigger = "Grand Widow Faerlina gains Enrage.",
		enragefade = "Enrage fades from Grand Widow Faerlina.",

		startwarn = "Start or Enrage!",
		enragewarn15sec = "15 seconds until enrage!",
		enragewarn = "Enrage!",
		enrageremovewarn = "Enrage removed! %d seconds until next!", -- added
		silencewarn = "Silence! Delaying Enrage!",

		enragebar = "Enrage",
	},
})

function BigWigsFaerlina:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsFaerlina:Enable()
	self.disabled = nil
	
	self.enragetime = 60
	self.silencetime = 30
	
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	
	self:RegisterEvent("BIGWIGS_SYNC_ENRAGE")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "ENRAGE", 5)

	self:RegisterEvent("BIGWIGS_SYNC_SILENCED")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "SILENCED", 5)
end

function BigWigsFaerlina:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.enragebar)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.enragewarn15sec)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.enragebar, self.enragetime - 20)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.enragebar, self.enragetime - 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.enragebar, self.silencetime - 20)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.enragebar, self.silencetime - 10)
	
	self.enragetime = nil
	self.silencetime = nil
	
	self.enraged = nil
end

function BigWigsFaerlina:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if (not self:GetOpt("notBosskill")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsFaerlina:CHAT_MSG_MONSTER_YELL()
	if (arg1 == self.loc.starttrigger1 or arg1 == self.loc.starttrigger2 or arg1 == self.loc.starttrigger3 or arg1 == self.loc.starttrigger4) then
		if (not self:GetOpt("notEnrageWarn")) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.startwarn, "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.enragewarn15sec, self.enragetime - 15, "Red")
		end
		if (not self:GetOpt("notEnrageBar")) then
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.enragebar, self.enragetime, 1, "Yellow", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.enragebar, self.enragetime - 20, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.enragebar, self.enragetime - 10, "Red")
		end
	end
end

function BigWigsFaerlina:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (arg1 == self.loc.enragetrigger) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "ENRAGE")
	end
end

function BigWigsFaerlina:BIGWIGS_SYNC_ENRAGE()
	if (not self:GetOpt("notEnrageWarn")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragewarn, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.enragebar)
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.enragewarn15sec)
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.enragebar, self.enragetime - 20)
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.enragebar, self.enragetime - 10)
	end
	self.enraged = true
end

function BigWigsFaerlina:BIGWIGS_SYNC_SILENCED()
	if (not self.enraged) then -- preemptive, 30s silence
		self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.enragebar)
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.enragewarn15sec)
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.enragebar, self.silencetime - 10)
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.enragebar, self.silencetime - 20)
		if (not self:GetOpt("notSilenceWarn")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.silencewarn, "Orange") end
		if (not self:GetOpt("notEnrageWarn")) then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.enragewarn15sec, 15, "Red") end
		if (not self:GetOpt("notEnrageBar")) then
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.enragebar, 30, 1, "Yellow", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.enragebar, self.silencetime - 20, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.enragebar, self.silencetime - 10, "Red")
		end
	else -- Reactive, enrage removed
		if (not self:GetOpt("notEnrageWarn")) then
			self:TriggerEvent("BIGWIGS_MESSAGE", string.format(self.loc.enrageremovewarn, self.enragetime), "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.enragewarn15sec, self.enragetime - 15, "Red")
		end
		if (not self:GetOpt("notEnrageBar")) then
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.enragebar, self.enragetime, 1, "Yellow", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.enragebar, self.enragetime - 20, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.enragebar, self.enragetime - 10, "Red")
		end
		self.enraged = nil
	end
end

function BigWigsFaerlina:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE()
	if (arg1 == self.loc.silencetrigger) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "SILENCED")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsFaerlina:RegisterForLoad()