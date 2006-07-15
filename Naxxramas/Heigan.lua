local Metro = Metrognome:GetInstance("1")
local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsHeigan = AceAddon:new({
	name	= "BigWigsHeigan",
	cmd		= AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Naxxramas"),
	enabletrigger = bboss("Heigan the Unclean"),
	bossname = bboss("Heigan the Unclean"),
	
	toggleoptions = {
		notStartWarn = "Start warning",
		notFirstTeleport = "Warnings of first teleport",
		notBackRoom = "Warns when incoming to the room",
		notTeleport = "Warns when go to teleport",
		notFirstTeleportBar = "First Teleport timerbar",
		notTeleportSec = "Teleport x-sec warnings",
		notBosskill = "Boss death",
	},
	optionorder = {"notStartWarn", "notFirstTeleport", "notBackRoom", "notTeleport", "notFirstTeleportBar", "notTeleportSec", "notBosskill"},

	loc = { 
		disabletrigger = "Heigan the Unclean takes his last breath.",		
		bosskill = "Heigan the Unclean has been defeated!",

		starttrigger = "You are mine now.",
		backroomtrigger = "Heigan the Unclean casts Plague Cloud.",
		teleporttrigger = "The end is upon you.",

		startwarn = "Heigan the Unclean engaged! 90 seconds till teleport",
		warn1 = "Teleport in 1 minute",
		warn2 = "Teleport in 30 seconds",
		warn3 = "Teleport in 10 seconds",
		backwarn1 = "Teleported! 40 sec till Back in room!",
		backwarn2 = "Inc to Room in 30 seconds",
		backwarn3 = "Inc to Room in 10 seconds",
		teleportwarn1 = "He's back in the room! 90 seconds till teleport",
		teleportwarn2 = "Teleport in 30 seconds",
		teleportwarn3 = "Teleport in 10 seconds",

		firstteleportbar = "First Teleport!",
		teleportbar = "Till Teleport!",
		backbar = "Till Back in room!",
	},
})

function BigWigsHeigan:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsHeigan:Enable()
	self.disabled = nil
	self.enrageStarted = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("BIGWIGS_SYNC_TELEPORT")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "TELEPORT", 10)
	self:RegisterEvent("BIGWIGS_SYNC_BACKROOM")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "BACKROOM", 10)

	Metro:Register("BigWigs_Heigan_CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)
end

function BigWigsHeigan:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.teleportbar)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.teleportwarn2)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.teleportwarn3)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.teleportbar, 50)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.teleportbar, 65)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.teleportbar, 80)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.backbar)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.backwarn2)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.backwarn3)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.backbar, 25)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.backbar, 30)
	Metro:Unregister("BigWigs_Heigan_CheckWipe")
end

function BigWigsHeigan:Scan()
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

function BigWigsHeigan:CHAT_MSG_MONSTER_YELL()
	if arg1 == self.loc.starttrigger then
		if not self:GetOpt("notStartWarn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.startwarn, "Red") end
		if not self:GetOpt("notFirstTeleportBar") then 
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.firstteleportbar, 90, 2, "Green", "Interface\\Icons\\Spell_Arcane_Blink")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.firstteleportbar, 50, "Yellow")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.firstteleportbar, 65, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.firstteleportbar, 80, "Red")
		end
		if not self:GetOpt("notEnrageSec") then 
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn1, 30, "Green")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn2, 60, "Yellow")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 80, "Orange")
		end
	elseif (string.find(arg1, self.loc.teleporttrigger)) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "TELEPORT")
	end
end

function BigWigsHeigan:PLAYER_REGEN_ENABLED()
	local go = self:Scan()
	local _,_,running = Metro:Status("BigWigs_Heigan_CheckWipe")
	if (not go) then
		self:Disable()
		Metro:Stop("BigWigs_Heigan_CheckWipe")
	elseif (not running) then
		Metro:Start("BigWigs_Heigan_CheckWipe")
	end
end

function BigWigsHeigan:CHAT_MSG_MONSTER_EMOTE()
	elseif (string.find(arg1, self.loc.disabletrigger)) then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsHeigan:StopFirstTeleport()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.firstteleportbar)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn1)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn2)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn3)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.firstteleportbar, 50)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.firstteleportbar, 65)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.firstteleportbar, 80)
end

function BigWigsHeigan:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if (string.find(arg1, self.loc.backroomtrigger)) then
		self:StopFirstTeleport()
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "BACKROOM") end
	end
end

function BigWigsHeigan:BIGWIGS_SYNC_TELEPORT()
	if (not self:GetOpt("notTeleport")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.teleportwarn1, "Green")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.teleportwarn2, 60, "Yellow")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.teleportwarn3, 80, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.teleportbar, 90, 1, "Green", "Interface\\Icons\\Spell_Arcane_Blink")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.teleportbar, 50, "Yellow")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.teleportbar, 65, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.teleportbar, 80, "Red")
	end
end

function BigWigsHeigan:BIGWIGS_SYNC_BACKROOM()
	if (not self:GetOpt("notBackRoom")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.backwarn1, "Green")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.backwarn2, 10, "Yellow")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.backwarn3, 30, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.backbar, 40, 1, "Yellow", "Interface\\Icons\\Spell_Magic_LesserInvisibilty")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.backbar, 25, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.backbar, 30, "Red")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsHeigan:RegisterForLoad()