local Metro = Metrognome:GetInstance("1")
local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsThaddius = AceAddon:new({
	name	= "BigWigsThaddius",
	cmd		= AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Naxxramas"),
	enabletrigger = { bboss("Feugen"), bboss("Stalagg"), bboss("Thaddius")  },
	bossname = "Thaddius and company - " .. bboss("Feugen") .. ", ".. bboss("Stalagg") .. " & ".. bboss("Thaddius"),
	
	toggleoptions = {
		notStartWarn = "Phase 1 warning",
		notPowerSurge = "Power Surge warning from Stalagg",
		notStartWarn2 = "Phase 2 warning",
		notPolarityShift = "Warn for Polarity Shift",
		notYouPositive = "Warn when you are a Positive Charge",
		notYouNegative = "Warn when you are a Negative Charge",
		notEnrageWarn = "Warn for Enrage",
		notEnrageBar = "Enrage timerbar",
		notEnrageSec = "Enrage x-sec warnings",
		notBosskill = "Boss death",
	},
	optionorder = {"notStartWarn", "notPowerSurge", "notStartWarn2", "notPolarityShift", "notYouPositive", "notYouNegative", "notEnrageBar", "notEnrageSec", "notEnrageWarn", "notBosskill"},

	loc = { 
		disabletrigger = "Thank... you...",		
		bosskill = "Thaddius has been defeated!",

		enragetrigger = "goes into a berserker rage!",
		starttrigger = "Stalagg crush you!",
		starttrigger1 = "Feed you to master!",
		starttrigger2 = "Eat... your... bones...",
		pstrigger = "Now you feel pain...",
		trigger1 = "Thaddius begins to cast Polarity Shift",
		postrigger = "^([^%s]+) ([^%s]+) afflicted by Positive Charge",
		negtrigger = "^([^%s]+) ([^%s]+) afflicted by Negative Charge",
		stalaggtrigger = "Stalagg gains Power Surge.",

		you = "You",
		are = "are",

		enragewarn = "Enrage!",
		startwarn = "Thaddius Phase 1",
		startwarn2 = "Thaddius Phase 2, Enrage in 5 minutes!",
		pswarn1 = "Thaddius begins to cast Polarity Shift!",
		pswarn2 = "30 seconds till next Polarity Shift!",
		pswarn3 = "3 seconds before Thaddius casts Polarity Shift!",
		poswarn = "You are a Positive Charge!",
		negwarn = "You are a Negative Charge!",
		enragebartext = "Enrage",
		warn1 = "Enrage in 3 minutes",
		warn2 = "Enrage in 90 seconds",
		warn3 = "Enrage in 60 seconds",
		warn4 = "Enrage in 30 seconds",
		warn5 = "Enrage in 10 seconds",
		stalaggwarn = "Power Surge",

		bar1text = "PolarityShift",
	},
})

function BigWigsThaddius:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsThaddius:Enable()
	self.disabled = nil
	self.enrageStarted = nil
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("BIGWIGS_SYNC_POLARITY")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "POLARITY", 10)

	Metro:Register("BigWigs_Thaddius_CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)
end

function BigWigsThaddius:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.pswarn3)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 20)
	self:StopEnrage()
	Metro:Unregister("BigWigs_Thaddius_CheckWipe")
end

function BigWigsThaddius:Scan()
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

function BigWigsThaddius:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (not self:GetOpt("notPowerSurge") and arg1 == self.loc.stalaggtrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.stalaggwarn, "Red")
	end
end

function BigWigsThaddius:CHAT_MSG_MONSTER_YELL()
	if (string.find(arg1, self.loc.pstrigger)) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "POLARITY")
	elseif arg1 == self.loc.starttrigger or arg1 == self.loc.starttrigger1 then
		if not self:GetOpt("notStartWarn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.startwarn, "Red") end
	elseif arg1 == self.loc.starttrigger2 then
		if not self:GetOpt("notStartWarn2") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.startwarn2, "Red") end
		if not self:GetOpt("notEnrageBar") then 
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.enragebartext, 300, 2, "Green", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.enragebartext, 75, "Yellow")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.enragebartext, 150, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.enragebartext, 225, "Red")
		end
		if not self:GetOpt("notEnrageSec") then 
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn1, 120, "Green")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn2, 210, "Yellow")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 240, "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn4, 270, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn5, 290, "Red")
		end
	elseif (string.find(arg1, self.loc.disabletrigger)) then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsThaddius:PLAYER_REGEN_ENABLED()
	local go = self:Scan()
	local _,_,running,_ = Metro:Status("BigWigs_Thaddius_CheckWipe")
	if (not go) then
		self:Disable()
		Metro:Stop("BigWigs_Thaddius_CheckWipe")
	elseif (not running) then
		Metro:Start("BigWigs_Thaddius_CheckWipe")
	end
end

function BigWigsThaddius:CHAT_MSG_MONSTER_EMOTE()
	if ( arg1 == self.loc.enragetrigger) then
		if not self:GetOpt("notEnrageWarn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragewarn, "Red") end
		self:StopEnrage()
	end
end

function BigWigsThaddius:StopEnrage()
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

function BigWigsThaddius:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if (string.find(arg1, self.loc.trigger1)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.pswarn1, "Red")
	end
end

function BigWigsThaddius:BIGWIGS_SYNC_POLARITY()
	if (not self:GetOpt("notPolarityShift")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.pswarn2, "Yellow")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.pswarn3, 27, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 30, 1, "Yellow", "Interface\\Icons\\Spell_Nature_CallStorm")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 20, "Red")
	end
end

function BigWigsThaddius:Event()
		local _, _, EPlayer = string.find(arg1, self.loc.postrigger)
		if (EPlayer) then
			if (EPlayer == self.loc.you and not self:GetOpt("notYouPositive")) then
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.poswarn, "Green", true)
	elseif local _, _, EPlayer = string.find(arg1, self.loc.negtrigger)
		if (EPlayer) then
			if (EPlayer == self.loc.you and not self:GetOpt("notYouNegative")) then
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.negwarn, "Red", true)
			end
		end
	end
	return false
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsThaddius:RegisterForLoad()