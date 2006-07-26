local metro = Metrognome:GetInstance("1")
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

	loc = GetLocale() == "deDE" and { 
		disabletrigger = "Heigan der Unreine nimmt einen letzten Atemzug.",		
		bosskill = "Heigan wurde besiegt!",

		starttrigger = "Ihr geh\195\182rt mir...",
		starttrigger2 = "Ihr seid.... als n\195\164chstes dran.",
		starttrigger3 = "Ihr entgeht mir nicht...",
		backroomtrigger = "Heigan der Unreine wirkt Seuchenwolke.",
		teleporttrigger = "Euer Ende naht.",

		startwarn = "Heigan engaged! 90 Sekunden bis Teleport",
		warn1 = "Teleport in 1 Minute",
		warn2 = "Teleport in 30 Sekunden",
		warn3 = "Teleport in 10 Sekunden",
		backwarn1 = "Teleport! Zur\195\188ck in %d Sekunden!",
		teleportwarn2 = "Zur\195\188ck im Raum in 30 Sekunden",
		teleportwarn3 = "Zur\195\188ck im Raum in 10 Sekunden",
		
		teleportwarn1 = "Zur\195\188ck im Raum! 90 Sekunden bis Teleport",
		backwarn2 = "Teleport in 30 Sekunden",
		backwarn3 = "Teleport in 10 Sekunden",

		teleportbar = "Teleport!",
		backbar = "R\195\188ckteleport!",
	} or { 
		-- [[ Boss Triggers ]]--
		disabletrigger = "Heigan the Unclean takes his last breath.",		
		bosskill = "Heigan the Unclean has been defeated!",
		-- [[ Triggers ]]--
		starttrigger = "You are mine now.",
		starttrigger2 = "You... are next.",
		starttrigger3 = "I see you...",
		teleporttrigger = "The end is upon you.",
		-- [[ Warnings ]]--
		startwarn = "Heigan the Unclean engaged! 90 seconds till teleport",
		warn1 = "Teleport in 1 minute",
		warn2 = "Teleport in 30 seconds",
		warn3 = "Teleport in 10 seconds",
		backwarn1 = "He's back on the floor! 90 seconds till next teleport",
		teleportwarn2 = "Inc to floor in 30 seconds",
		teleportwarn3 = "Inc to floor in 10 seconds",
		teleportwarn1 = "Teleport! %d sec till back in room!",
		backwarn2 = "Teleport in 30 seconds",
		backwarn3 = "Teleport in 10 seconds",
		-- [[ Bars ]]--
		teleportbar = "Teleport!",
		backbar = "Back on floor!",
	},
})

function BigWigsHeigan:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsHeigan:Enable()
	self.disabled = nil
	self.toRoomTime = 45
	self.toPlatformTime = 90
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("BIGWIGS_SYNC_TELEPORT")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "TELEPORT", 10)
	self:RegisterEvent("BIGWIGS_SYNC_BACKROOM")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "BACKROOM", 10)
	
	metro:Unregister("BigWigs_Heigan_ToRoom")
	metro:Unregister("BigWigs_Heigan_CheckWipe")
	
	metro:Register("BigWigs_Heigan_ToRoom", self.BIGWIGS_SYNC_BACKROOM, self.toRoomTime, self)
	metro:Register("BigWigs_Heigan_CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)
end

function BigWigsHeigan:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.teleportbar)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.teleportwarn2)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.teleportwarn3)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.teleportbar, self.toPlatformTime-40)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.teleportbar, self.toPlatformTime-25)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.teleportbar, self.toPlatformTime-10)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.backbar)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.backwarn2)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.backwarn3)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.backbar, self.toRoomTime-15)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.backbar, self.toRoomTime-10)
	metro:Unregister("BigWigs_Heigan_ToRoom")
	metro:Unregister("BigWigs_Heigan_CheckWipe")
	self:StopFirstTeleport()
	self.toRoomTime = nil
	self.toPlatformTime = nil
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
	if arg1 == self.loc.starttrigger or arg1 == self.loc.starttrigger2 or arg1 == self.loc.starttrigger3 then
		if not self:GetOpt("notStartWarn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.startwarn, "Red") end
		if not self:GetOpt("notFirstTeleportBar") then 
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.teleportbar, self.toPlatformTime, 2, "Green", "Interface\\Icons\\Spell_Arcane_Blink")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.teleportbar, self.toPlatformTime-40, "Yellow")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.teleportbar, self.toPlatformTime-25, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.teleportbar, self.toPlatformTime-10, "Red")
		end
		if not self:GetOpt("notTeleportSec") then 
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn1, self.toPlatformTime-60, "Green")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn2, self.toPlatformTime-30, "Yellow")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, self.toPlatformTime-10, "Orange")
		end
	elseif (string.find(arg1, self.loc.teleporttrigger)) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "TELEPORT")
	end
end

function BigWigsHeigan:PLAYER_REGEN_ENABLED()
	local go = self:Scan()
	local _,_,running = metro:Status("BigWigs_Heigan_CheckWipe")
	if (not go) then
		self:Disable()
		metro:Stop("BigWigs_Heigan_CheckWipe")
	elseif (not running) then
		metro:Start("BigWigs_Heigan_CheckWipe")
	end
end

function BigWigsHeigan:CHAT_MSG_MONSTER_EMOTE()
	if (string.find(arg1, self.loc.disabletrigger)) then
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


function BigWigsHeigan:BIGWIGS_SYNC_BACKROOM()
	metro:Stop("BigWigs_Heigan_ToRoom")
	if (not self:GetOpt("notBackRoom")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.backwarn1, "Green")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.backwarn2, self.toPlatformTime-30, "Yellow")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.backwarn3, self.toPlatformTime-10, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.teleportbar, self.toPlatformTime, 1, "Green", "Interface\\Icons\\Spell_Arcane_Blink")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.teleportbar, self.toPlatformTime-40, "Yellow")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.teleportbar, self.toPlatformTime-25, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.teleportbar, self.toPlatformTime-10, "Red")
	end
end

function BigWigsHeigan:BIGWIGS_SYNC_TELEPORT()
	metro:Start("BigWigs_Heigan_ToRoom")
	if (not self:GetOpt("notTeleport")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", string.format(self.loc.teleportwarn1, self.toRoomTime), "Green")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.teleportwarn2, self.toRoomTime-30, "Yellow")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.teleportwarn3, self.toRoomTime-10, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.backbar, self.toRoomTime, 1, "Yellow", "Interface\\Icons\\Spell_Magic_LesserInvisibilty")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.backbar, self.toRoomTime-15, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.backbar, self.toRoomTime-10, "Red")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsHeigan:RegisterForLoad()