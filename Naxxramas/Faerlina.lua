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
	} or {
		disabletrigger = "Grand Widow Faerlina dies.",		
		bosskill = "Grand Widow Faerlina has been defeated!",

		starttrigger1 = "Kneel before me, worm!",
		starttrigger2 = "Slay them in the master's name!",
		starttrigger3 = "You cannot hide from me!",
		starttrigger4 = "Run while you still can!",

		silencetrigger = "Naxxramas Worshipper is afflicted by Widow's Embrace.",
		enragetrigger = "Grand Widow Faerlina gains Enrage.",

		startwarn = "Start or Enrage!",
		enragewarn15sec = "15 seconds until enrage!",
		enragewarn = "Enrage!",
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
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE")
end

function BigWigsFaerlina:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.enragebar)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.enragewarn15sec)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.enragebar, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.enragebar, 20)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.enragebar, 40)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.enragebar, 50)
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
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.enragewarn15sec, 45, "Red")
		end
		if (not self:GetOpt("notEnrageBar")) then
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.enragebar, 60, 1, "Yellow", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.enragebar, 40, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.enragebar, 50, "Red")
		end
	end
end

function BigWigsFaerlina:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (arg1 == self.loc.enragetrigger) then
		if (not self:GetOpt("notEnrageWarn")) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragewarn, "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.enragewarn15sec, 45, "Red")
		end
		if (not self:GetOpt("notEnrageBar")) then
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.enragebar, 60, 1, "Yellow", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.enragebar, 40, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.enragebar, 50, "Red")
		end
	end
end

function BigWigsFaerlina:CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE()
	if (arg1 == self.loc.silencetrigger) then
		local id = "BigWigsBar "..self.loc.enragebar
		if (TimexBar:Check(id)) then
			local timexBar = TimexBar.barMap[id]
			if (timexBar) then
				local v = timexBar.v
				if (v < 30) then
					self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.enragebar)
					self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.enragewarn15sec)
					self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.enragebar, 10)
					self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.enragebar, 20)
					if (not self:GetOpt("notSilenceWarn")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.silencewarn, "Orange") end
					if (not self:GetOpt("notEnrageWarn")) then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.enragewarn15sec, 15, "Red") end
					if (not self:GetOpt("notEnrageBar")) then
						self:TriggerEvent("BIGWIGS_BAR_START", self.loc.enragebar, 30, 1, "Yellow", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
						self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.gainincbar, 10, "Orange")
						self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.gainincbar, 20, "Red")
					end
				end
			end
		end
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsFaerlina:RegisterForLoad()