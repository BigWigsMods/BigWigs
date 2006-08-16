------------------------------
--      Are you local?      --
------------------------------

local thane = AceLibrary("Babble-Boss-2.0")("Thane Korth'azz")
local mograine = AceLibrary("Babble-Boss-2.0")("Highlord Mograine")
local zeliek = AceLibrary("Babble-Boss-2.0")("Sir Zeliek")
local blaumeux = AceLibrary("Babble-Boss-2.0")("Lady Blaumeux")
local boss = AceLibrary("Babble-Boss-2.0")("The Four Horsemen")

local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "horsemen",

	mark_cmd = "mark",
	mark_name = "Mark Alerts",
	mark_desc = "Warn for marks",

	shieldwall_cmd  = "shieldwall",
	shieldwall_name = "Shieldwall Alerts",
	shieldwall_desc = "Warn for shieldwall",

	markbar = "Mark",
	markwarn1 = "Mark (%d)!",
	markwarn2 = "Mark (%d) - 5 sec",
	marktrigger = "is afflicted by Mark of (Korth'azz|Blaumeux|Mograine|Zeliek)",

	startwarn = "The Four Horsemen Engaged! Mark in 30 sec",

	shieldwallbar = "%s - Shield Wall",
	shieldwalltrigger = " gains Shield Wall.",
	shieldwallwarn = "%s - Shield Wall for 20 sec",
	shieldwallwarn2 = "%s - Shield Wall GONE!",
} end )

L:RegisterTranslations("deDE", function() return {
	cmd = "horsemen",

	mark_cmd = "mark",
	mark_name = "Mark Alerts", -- ?
	mark_desc = "Warn for marks", -- ?

	shieldwall_cmd  = "shieldwall",
	shieldwall_name = "Schildwall",
	shieldwall_desc = "Warnung vor Schildwall.",

	markbar = "Mark", -- ?
	markwarn1 = "Mark (%d)!", -- ?
	markwarn2 = "Mark (%d) - 5 Sekunden", -- ?

	startwarn = "The Four Horsemen angegriffen! Mark in 30 Sekunden", -- ?

	shieldwallbar = "%s - Schildwall",
	shieldwalltrigger = " bekommt 'Schildwall'.",
	shieldwallwarn = "%s - Schildwall f\195\188r 20 Sekunden",
	shieldwallwarn2 = "%s - Schildwall Vorbei!",
} end )

L:RegisterTranslations("zhCN", function() return {
	mark_name = "标记警报",
	mark_desc = "标记警报",

	shieldwall_name = "盾墙警报",
	shieldwall_desc = "盾墙警报",

	markbar = "标记",
	markwarn1 = "标记(%d)！",
	markwarn2 = "标记(%d) - 5秒",

	startwarn = "四骑士已激活 - 30秒后标记",

	shieldwallbar = "%s - 盾墙",
	shieldwalltrigger = "获得了盾墙",
	shieldwallwarn = "%s - 20秒盾墙效果",
	shieldwallwarn2 = "%s - 盾墙消失了！",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsHorsemen = BigWigs:NewModule(boss)
BigWigsHorsemen.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsHorsemen.enabletrigger = { thane, mograine, zeliek, blaumeux }
BigWigsHorsemen.toggleoptions = {"mark", "shieldwall", "bosskill"}
BigWigsHorsemen.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsHorsemen:OnEnable()
	self.started = nil
	self.marks = 1
	self.deaths = 0

	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "MarkEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "MarkEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "MarkEvent")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenShieldWall", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenStart", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenMark", 8)
end

function BigWigsHorsemen:PLAYER_REGEN_ENABLED()
	local go = self:Scan()
	local running = self:IsEventScheduled("Horsemen_CheckWipe")
	if (not go) then
		self:TriggerEvent("BigWigs_RebootModule", self)
	elseif (not running) then
		self:ScheduleRepeatingEvent("Horsemen_CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)
	end
end

function BigWigsHorsemen:PLAYER_REGEN_DISABLED()
	local go = self:Scan()
	local running = self:IsEventScheduled("Horsemen_CheckStart")
	if (go) then
		self:CancelScheduledEvent("Horsemen_CheckStart")
		self:TriggerEvent("BigWigs_SendSync", "HorsemenStart")
	elseif not running then
		self:ScheduleRepeatingEvent("Horsemen_CheckStart", self.PLAYER_REGEN_DISABLED, .5, self)
	end
end

function BigWigsHorsemen:Scan()
	if ( ( UnitName("target") == thane or UnitName("target") == mograine or UnitName("target") == zeliek or UnitName("target") == blaumeux )  and UnitAffectingCombat("target")) then
		return true
	elseif ( ( UnitName("playertarget") == thane or UnitName("playertarget") == mograine or UnitName("playertarget") == zeliek or UnitName("playertarget") == blaumeux ) and UnitAffectingCombat("playertarget")) then
		return true
	else
		local i
		for i = 1, GetNumRaidMembers(), 1 do
			if ( ( UnitName("raid"..i.."target") == thane or UnitName("raid"..i.."target") == mograine or UnitName("raid"..i.."target") == zeliek or UnitName("raid"..i.."target") == blaumeux ) and UnitAffectingCombat("raid"..i.."target")) then
				return true
			end
		end
	end
	return false
end

function BigWigsMaexxna:MarkEvent( msg )
	-- web spray warning
	if string.find(msg, L"marktrigger") then
		self:TriggerEvent("BigWigs_SendSync", "HorsemenMark")
	end
end

function BigWigsHorsemen:BigWigs_RecvSync(sync, rest)
	if sync == "HorsemenStart" and not self.started then
		self.started = true
		if self.db.profile.mark then
			self:TriggerEvent("BigWigs_Message", L"startwarn", "Yellow")
			self:TriggerEvent("BigWigs_StartBar", self, L"markbar", 20, "Interface\\Icons\\Spell_Shadow_CurseOfAchimonde", "Yellow", "Orange", "Red")
			self:ScheduleEvent("bwhorsemenmark2", "BigWigs_Message", 15, string.format( L"markwarn2", self.marks ), "Orange")
		end
	elseif sync == "HorsemenMark" then
		if self.db.profile.mark then
			self:TriggerEvent("BigWigs_Message", string.format( L"markwarn1", self.marks ), "Red")
		end
		self.marks = self.marks + 1
		if self.db.profile.mark then 
			self:TriggerEvent("BigWigs_StartBar", self, L"markbar", 12, "Interface\\Icons\\Spell_Shadow_CurseOfAchimonde", "Orange", "Red")
			self:ScheduleEvent("bwhorsemenmark2", "BigWigs_Message", 7, string.format( L"markwarn2", self.marks ), "Orange")
		end			
	elseif sync == "HorsemenShieldWall" then
		self:TriggerEvent("BigWigs_Message", string.format(L"shieldwallwarn", rest), "White")
		self:ScheduleEvent("BigWigs_Message", 20, string.format(L"shieldwallwarn2", rest), "Green")
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L"shieldwallbar", rest), 20, "Interface\\Icons\\Ability_Warrior_ShieldWall", "Yellow", "Orange", "Red")
	end
end

function BigWigsHorsemen:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if msg == thane..L"shieldwalltrigger" then
		self:TriggerEvent("BigWigs_SendSync", "HorsemenShieldWall "..thane )
	elseif msg == zeliek..L"shieldwalltrigger" then
		self:TriggerEvent("BigWigs_SendSync", "HorsemenShieldWall "..zeliek )
	elseif msg == mograine..L"shieldwalltrigger" then
		self:TriggerEvent("BigWigs_SendSync", "HorsemenShieldWall "..mograine )
	elseif msg == blaumeux..L"shieldwalltrigger" then
		self:TriggerEvent("BigWigs_SendSync", "HorsemenShieldWall "..blaumeux )
	end
end

function BigWigsHorsemen:CHAT_MSG_COMBAT_HOSTILE_DEATH( msg )
	if msg == string.format(UNITDIESOTHER, thane ) or
		msg == string.format(UNITDIESOTHER, zeliek) or 
		msg == string.format(UNITDIESOTHER, mograine) or
		msg == string.format(UNITDIESOTHER, blaumeux) then
		self.deaths = self.deaths + 1
		if self.deaths == 4 then
			if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.0"):new("BigWigs")("%s have been defeated"), boss), "Green", nil, "Victory") end
			self.core:ToggleModuleActive(self, false)
		end
	end
end
