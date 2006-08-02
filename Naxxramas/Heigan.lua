------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Heigan the Unclean")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "heigan",

	teleport_cmd = "teleport",
	teleport_name = "Teleport Alert",
	teleport_desc = "Warn for Teleports",

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
} end )

L:RegisterTranslations("deDE", function() return {
	starttrigger = "Ihr geh\195\182rt mir...",
	starttrigger2 = "Ihr seid.... als n\195\164chstes dran.",
	starttrigger3 = "Ihr entgeht mir nicht...",
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
} end )


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsHeigan = BigWigs:NewModule(boss)
BigWigsHeigan.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsHeigan.enabletrigger = boss
BigWigsHeigan.toggleoptions = {"teleport", "bosskill"}
BigWigsHeigan.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsHeigan:OnEnable()
	self.toRoomTime = 45
	self.toPlatformTime = 90
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("CHAT_MSG_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "HeiganTeleport", 10)
end

function BigWigsHeigan:CHAT_MSG_MONSTER_YELL( msg )
	if self.db.profile.teleport and msg == L"starttrigger" or msg == L"starttrigger2" or msg == L"starttrigger3" then
		self:TriggerEvent("BigWigs_Message", L"startwarn", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L"teleportbar", self.toPlatformTime, 2, "Interface\\Icons\\Spell_Arcane_Blink", "Green", "Yellow", "Orange", "Red")
		self:ScheduleEvent("bwheiganwarn1", "BigWigs_Message", self.toPlatformTime-60, "Green")
		self:ScheduleEvent("bwheiganwarn2", "BigWigs_Message", self.toPlatformTime-30, "Yellow")
		self:ScheduleEvent("bwheiganwarn3", "BigWigs_Message", self.toPlatformTime-10, "Orange")
	elseif string.find(msg, L"teleporttrigger") then
		self:TriggerEvent("BigWigs_SendSync", "HeiganTeleport")
	end
end

function BigWigsHeigan:PLAYER_REGEN_ENABLED()
	local go = self:Scan()
	local running = self:IsEventScheduled("Heigan_CheckWipe")
	if (not go) then
		self:TriggerEvent("BigWigs_RebootModule", self)
	elseif (not running) then
		self:ScheduleRepeatingEvent("Heigan_CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)
	end
end

function BigWigsHeigan:Scan()
	if (UnitName("target") == boss and UnitAffectingCombat("target")) then
		return true
	elseif (UnitName("playertarget") == boss and UnitAffectingCombat("playertarget")) then
		return true
	else
		local i
		for i = 1, GetNumRaidMembers(), 1 do
			if (UnitName("raid"..i.."target") == boss and UnitAffectingCombat("raid"..i.."target")) then
				return true
			end
		end
	end
	return false
end

function BigWigsHeigan:BigWigs_RecvSync( sync )
	if sync ~= "HeiganTeleport" then return end

	self:ScheduleEvent( self.BackToRoom, self.toRoomTime, self )	

	if self.db.profile.teleport then
		self:TriggerEvent("BigWigs_Message", string.format(L"teleportwarn1", self.toRoomTime), "Green")
		self:ScheduleEvent("BigWigs_Message", self.toRoomTime-30, L"teleportwarn2", "Yellow")
		self:ScheduleEvent("BigWigs_Message", self.toRoomTime-10, L"teleportwarn3", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L"backbar", self.toRoomTime, 1, "Interface\\Icons\\Spell_Magic_LesserInvisibilty", "Yellow", "Orange", "Red")
	end
end

function BigWigsHeigan:BackToRoom()
	if self.db.profile.teleport then
		self:TriggerEvent("BigWigs_Message", L"backwarn1", "Green")
		self:ScheduleEvent("BigWigs_Message", self.toPlatformTime-30, L"backwarn2", "Yellow")
		self:ScheduleEvent("BigWigs_Message", self.toPlatformTime-10, L"backwarn3", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L"teleportbar", self.toPlatformTime, 1, "Interface\\Icons\\Spell_Arcane_Blink", "Green", "Yellow", "Orange", "Red")
	end
end

