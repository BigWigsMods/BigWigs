local Metro = Metrognome:GetInstance("1")
local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsPatchwerk = AceAddon:new({
	name	= "BigWigsPatchwerk",
	cmd		= AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Naxxramas"),
	enabletrigger = bboss("Patchwerk"),
	bossname = bboss("Patchwerk"),

	toggleoptions = GetLocale() == "koKR" and {
		notStartWarn = "시작 알림",
		notEnrageWarn = "격노 경고",
		notEnrageBar = "격노 타이머바",
		notEnrageSec = "격노 시간 경고",
		notBosskill = "보스 사망 알림",
	} or {
		notStartWarn = "Start warning",
		notEnrageWarn = "Warn for Enrage",
		notEnrageBar = "Enrage timerbar",
		notEnrageSec = "Enrage x-sec warnings",
		notBosskill = "Boss death",
	},
	optionorder = {"notStartWarn", "notEnrageBar", "notEnrageSec", "notEnrageWarn", "notBosskill"},

	loc = GetLocale() == "koKR" and { 	 
		disabletrigger = "패치워크|1이;가; 죽었습니다.",		
		bosskill = "패치워크를 물리쳤습니다!",

		enragetrigger = "goes into a berserker rage!", -- 사용되지 않음

		enragewarn = "격노!",
		starttrigger1 = "패치워크랑 놀아줘!",
		starttrigger2 = "켈투자드님이 패치워크 싸움꾼으로 만들었다.",
		startwarn = "패치워크 전투시작! 격노 7분후!",
		enragebartext = "격노",
		warn1 = "격노 5분후",
		warn2 = "격노 3분후",
		warn3 = "격노 90초후",
		warn4 = "격노 60초후",
		warn5 = "격노 30초후",
		warn6 = "격노 10초후",	
	} or GetLocale() == "deDE" and {
		disabletrigger = "Flickwerk stirbt.",		
		bosskill = "Flickwerk wurde besiegt!",

		enragetrigger = "f\195\164llt in Berserkerwut!",

		enragewarn = "Enrage!",
		starttrigger1 = "Flickwerk spielen m\195\182chte!",
		starttrigger2 = "Kel'thuzad macht Flickwerk zu seinem Abgesandten von Krieg!",
		startwarn = "Patchwerk engaged! Enrage in 7 Minuten!",
		enragebartext = "Enrage",
		warn1 = "Enrage in 5 Minuten",
		warn2 = "Enrage in 3 Minuten",
		warn3 = "Enrage in 90 Skunden",
		warn4 = "Enrage in 60 Sekunden",
		warn5 = "Enrage in 30 Sekunden",
		warn6 = "Enrage in 10 Sekunden",
	} or {
		disabletrigger = "Patchwerk dies.",		
		bosskill = "Patchwerk has been defeated!",

		enragetrigger = "goes into a berserker rage!",

		enragewarn = "Enrage!",
		starttrigger1 = "Patchwerk want to play!",
		starttrigger2 = "Kel'thuzad make Patchwerk his avatar of war!",
		startwarn = "Patchwerk Engaged! Enrage in 7 minutes!",
		enragebartext = "Enrage",
		warn1 = "Enrage in 5 minutes",
		warn2 = "Enrage in 3 minutes",
		warn3 = "Enrage in 90 seconds",
		warn4 = "Enrage in 60 seconds",
		warn5 = "Enrage in 30 seconds",
		warn6 = "Enrage in 10 seconds",
	},
})

function BigWigsPatchwerk:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsPatchwerk:Enable()
	self.disabled = nil
	self.enrageStarted = nil
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")

	Metro:Register("BigWigs_Patchwerk_CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)
end

function BigWigsPatchwerk:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:StopEnrage()
	Metro:Unregister("BigWigs_Patchwerk_CheckWipe")
end

function BigWigsPatchwerk:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if (not self:GetOpt("notBosskill")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsPatchwerk:Scan()
	if (UnitName("target") == self.bossname and UnitAffectingCombat("target")) then
		return true
	elseif (UnitName("playertarget") == self.bossname and UnitAffectingCombat("playertarget")) then
		return true
	else
		local i
		for i = 1, GetNumRaidMembers(), 1 do
			if (UnitName("raid"..i.."target") == self.bossname and UnitAffectingCombat("raid"..i.."target")) then
				return true
			end
		end
	end
	return false
end

function BigWigsPatchwerk:CHAT_MSG_MONSTER_YELL()
	if arg1 == self.loc.starttrigger1 or arg1 == self.loc.starttrigger2 then
		if not self:GetOpt("notStartWarn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.startwarn, "Red") end
		if not self:GetOpt("notEnrageBar") then 
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.enragebartext, 420, 2, "Green", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.enragebartext, 120, "Yellow")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.enragebartext, 240, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.enragebartext, 360, "Red")
		end
		if not self:GetOpt("notEnrageSec") then 
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn1, 120, "Green")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn2, 240, "Yellow")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 330, "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn4, 360, "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn5, 390, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn6, 410, "Red")
		end
	end
end

function BigWigsPatchwerk:PLAYER_REGEN_ENABLED()
	local go = self:Scan()
	local _,_,running,_ = Metro:Status("BigWigs_Patchwerk_CheckWipe")
	if (not go) then
		self:Disable()
		Metro:Stop("BigWigs_Patchwerk_CheckWipe")
	elseif (not running) then
		Metro:Start("BigWigs_Patchwerk_CheckWipe")
	end
end

function BigWigsPatchwerk:CHAT_MSG_MONSTER_EMOTE()
	if ( arg1 == self.loc.enragetrigger) then
		if not self:GetOpt("notEnrageWarn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragewarn, "Red") end
		self:StopEnrage()
	end
end

function BigWigsPatchwerk:StopEnrage()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.enragebartext)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn1)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn2)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn3)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn4)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn5)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn6)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.enragebartext, 120)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.enragebartext, 240)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.enragebartext, 360)
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsPatchwerk:RegisterForLoad()