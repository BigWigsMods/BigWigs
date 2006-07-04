local Metro = Metrognome:GetInstance("1")
local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsPatchwerk = AceAddon:new({
	name	= "BigWigsPatchwerk",
	cmd		= AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Naxxramas"),
	enabletrigger = bboss("Patchwerk"),
	bossname = bboss("Patchwerk"),

	toggleoptions = {
		notStartWarn = "Start warning",
		notEnrageWarn = "Warn for Enrage",
		notEnrageBar = "Enrage timerbar",
		notEnrageSec = "Enrage x-sec warnings",
		notBosskill = "Boss death",
	},
	optionorder = {"notStartWarn", "notEnrageBar", "notEnrageSec", "notEnrageWarn", "notBosskill"},

	loc = { 
		disabletrigger = "Patchwerk dies.",		
		bosskill = "Patchwerk has been defeated!",

		enragetrigger = "goes into a berserker rage!",

		enragewarn = "Enrage!",
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
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("BIGWIGS_SYNC_PATCHWERKENRAGE")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "PATCHWERKENRAGE", 10)

	Metro:Register("BigWigs_Patchwerk_CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)
end

function BigWigsPatchwerk:Disable()
	self.disabled = true
	self.enrageStarted = nil
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

function BigWigsPatchwerk:PLAYER_REGEN_DISABLED()
	local go = self:Scan()
	if (go) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "PATCHWERKENRAGE")
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

function BigWigsPatchwerk:BIGWIGS_SYNC_PATCHWERKENRAGE()
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