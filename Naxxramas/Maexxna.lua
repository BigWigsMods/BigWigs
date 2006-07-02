local Metro = Metrognome:GetInstance("1")
local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsMaexxna = AceAddon:new({
	name          = "BigWigsMaexxna",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Naxxramas"),
	enabletrigger = bboss("Maexxna"),
	bossname = bboss("Maexxna"),

	toggleoptions = {
		notBosskill = "Boss death",
		notStart = "Start warning",
		notSpray = "Web Spray warning",
		notSpray5Sec = "5 Second Web Spray warning",
		notSpray10Sec = "Spiders Spawn/Web Spray 10-sec warning",
		notSpray20Sec = "Web Wrap/Spiders Spawn 10-sec warning",
		notSprayBar = "Web Spray timerbar",
		notEnrageSoon = "Enrage soon warning",
		notEnrageWarn = "Enrage warning",
	},

	optionorder = {"notStart", "notSpray", "notSpray5Sec", "notSpray10Sec", "notSpray20Sec", "notSprayBar", "notEnrageSoon","notEnrageWarn", "notBosskill"},

	loc = { 
		disabletrigger = "Maexxna dies.",		
		bosskill = "Maexxna has been defeated!",

		webwraptrigger = "(.*) (.*) afflicted by Web Wrap.",
		webspraytrigger = "is afflicted by Web Spray.",

		enragetrigger = "Maexxna gains Enrage.",

		startwarn = "Maexxna engaged! 40 seconds until Web Spray!",
		--webwrapwarn = "%s is all wrapped up!",
		--webwrapyouwarn = "You are all wrapped up!",
		webspraywarn30sec = "Web wrap in 10 seconds",
		webspraywarn20sec = "Web Wrap. 10 seconds until Spiders spawn!",
		webspraywarn10sec = "Spiders Spawn. 10 seconds until Web Spray!",
		webspraywarn5sec = "5 seconds! HOTS/ABOLISH/GOGO",
		webspraywarn = "Web Spray! 40 seconds until next!",
		enragewarn = "Enrage - Give it all you got!",
		enragesoonwarn = "Enrage Soon - Get Ready!",

		webspraybar = "Web Spray",

		you = "You",
		are = "are",
	},
})

function BigWigsMaexxna:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsMaexxna:Enable()
	self.disabled = nil
	self:RegisterEvent("BIGWIGS_MESSAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("BIGWIGS_SYNC_WEBSPRAY")
	
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "WEBSPRAY", 10)
	Metro:Register("BigWigs_Maexxna_CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)	
end

function BigWigsMaexxna:Disable()
	self.disabled = true
	self.enrageannounced = nil
	self:UnregisterAllEvents()
end

function BigWigsMaexxna:StopTimers()
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.webspraywarn30sec)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.webspraywarn20sec)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.webspraywarn10sec)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.webspraybar)
end

function BigWigsMaexxna:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green") end
		self:Disable()
	end
end

function BigWigsMaexxna:BIGWIGS_SYNC_WEBSPRAY()
	if not self:GetOpt("notSpray") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.webspraywarn, "Red") end
	if not self:GetOpt("notSpray30Sec") then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.webspraywarn30sec, 10, "Yellow") end
	if not self:GetOpt("notSpray20Sec") then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.webspraywarn20sec, 20, "Yellow") end
	if not self:GetOpt("notSpray10Sec") then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.webspraywarn10sec, 30, "Yellow") end
	if not self:GetOpt("notSpray5Sec") then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.webspraywarn5sec, 35, "Yellow") end
	if not self:GetOpt("notSprayBar") then self:TriggerEvent("BIGWIGS_BAR_START", self.loc.webspraybar, 40, 1, "Yellow", "Interface\\Icons\\Ability_Ensnare") end
end

function BigWigsMaexxna:Event()
	-- web spray warning
	if string.find(arg1, self.loc.webspraytrigger) then
		if not webspraytime or (time() - webspraytime > 8) then
			webspraytime = time()
			self:TriggerEvent("BIGWIGS_SYNC_SEND", "WEBSPRAY")
		end
	end

	-- let people know when people get wrapped up
	-- this might be too spammy, since I don't know the fight, so I disabled it. -Ammo
--	local _,_, EPlayer, EType = string.find(arg1, self.loc.webwraptrigger)
--	if (EPlayer and EType) then
--		if (EPlayer == self.loc.you and EType == self.loc.are) then
--			self:TriggerEvent("BIGWIGS_MESSAGE", string.format(self.loc.webwrapwarn, UnitName("player")), "Red", true)
--		else
--			self:TriggerEvent("BIGWIGS_MESSAGE", string.format(self.loc.webwrapwarn, EPlayer), "Yellow")
--			self:TriggerEvent("BIGWIGS_SENDTELL", EPlayer, self.loc.webwrapyouwarn)
--		end
--	end

end

function BigWigsMaexxna:Scan()
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
function BigWigsMaexxna:PLAYER_REGEN_DISABLED()
	local go = self:Scan()
	if (go) then
		ace:print("sent webspray sync")
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "WEBSPRAY")
	end
end

function BigWigsMaexxna:PLAYER_REGEN_ENABLED()
	local go = self:Scan()
	if (not go) then
		self:StopTimers()
		Metro:Stop("BigWigs_Maexxna_CheckWipe")
	elseif (not Metro:Status("BigWigs_Maexxna_CheckWipe")) then
		Metro:Start("BigWigs_Maexxna_CheckWipe")
	end
end

function BigWigsMaexxna:CHAT_MSG_MONSTER_EMOTE()
	if (not self:GetOpt("notEnrageWarn") and arg1 == self.loc.enragektrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragekwarn, "Red")
	end
end

function BigWigsMaexxna:UNIT_HEALTH()
	if (UnitName(arg1) == self.bossname) then
		local health = UnitHealth(arg1)
		if (health > 30 and health <= 33) then
			if not self:GetOpt("notEnrageSoon") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragesoonwarn, "Red") end
			self.enrageannounced = true
		elseif (health > 40 and self.enrageannounced) then
			self.enrageannounced = nil
		end
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsMaexxna:RegisterForLoad()
