------------------------------
--      Are you local?      --
------------------------------

local thane = AceLibrary("Babble-Boss-2.0")("Thane Korthazz")
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

	startwarn = "The Four Horsemen Engaged! Mark in 30 sec",

	shieldwallbar = "%s - Shield Wall",
	shieldwalltrigger = " gains Shield Wall.",
	shieldwallwarn = "%s - Shield Wall for 20 sec",
	shieldwallwarn2 = "%s - Shield Wall GONE!",
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

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenShieldWall", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenStart", 10)
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
	if (go) then
		self:TriggerEvent("BigWigs_SendSync", "HorsemenStart")
	end
end

function BigWigsHorsemen:Scan()
	if (UnitName("target") == ( thane or mograine or zeliek or blaumeux )  and UnitAffectingCombat("target")) then
		return true
	elseif (UnitName("playertarget") == ( thane or mograine or zeliek or blaumeux ) and UnitAffectingCombat("playertarget")) then
		return true
	else
		local i
		for i = 1, GetNumRaidMembers(), 1 do
			if (UnitName("raid"..i.."target") == ( thane or mograine or zeliek or blaumeux ) and UnitAffectingCombat("raid"..i.."target")) then
				return true
			end
		end
	end
	return false
end


function BigWigsHorsemen:Mark( first )
	if first then
		self:ScheduleRepeatingEvent("bwhorsemenmarkrepeater", self.Mark, 12, self )
	end
	if self.profile.mark then self:TriggerEvent("BigWigs_Message", string.format( L"markwarn1", self.marks ), "Red") end
	self.marks = self.marks + 1
	if self.profile.mark then 
		self:TriggerEvent("BigWigs_StartBar", self, L"markbar", 12, 1, "Interface\\Icons\\Spell_Shadow_CurseOfAchimonde", "Orange", "Red")
		self:ScheduleEvent("bwhorsemenmark2", "BigWigs_Message", 7, string.format( L"markwarn2", self.marks ), "Orange")
	end
end

function BigWigsHorsemen:BigWigs_RecvSync(sync, rest)
	if sync == "HorsemenStart" and not self.started then
		self.started = true
		if self.profile.mark then
			self:TriggerEvent("BigWigs_Message", L"startwarn", "Yellow")
			self:TriggerEvent("BigWigs_StartBar", self, L"markbar", 30, 1, "Interface\\Icons\\Spell_Shadow_CurseOfAchimonde", "Yellow", "Orange", "Red")
			self:ScheduleEvent("bwhorsemenmark2", "BigWigs_Message", 25, string.format( L"markwarn2", self.marks ), "Orange")
		end
		self:ScheduleEvent("bwhorsemenmark", self.Mark, 30, self, true )
	elseif sync == "HorsemenShieldWall" then
		local barnr
		if rest == thane then barnr = 2
		elseif rest == mograine then barnr = 3
		elseif rest == zeliek then barnr = 4
		elseif rest == blaumeux then barnr = 5 end
		self:TriggerEvent("BigWigs_Message", string.format(L"shieldwallwarn", rest), "White")
		self:ScheduleEvent("BigWigs_Message", 20, string.format(L"shieldwallwarn2", rest), "Green")
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L"shieldwallbar", rest), 20, barnr, "Interface\\Icons\\Ability_Warrior_ShieldWall", "Yellow", "Orange", "Red")
	end
end

function BigWigsHorsemen:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if msg == thane..L"shieldwalltrigger" then
		self:TriggerEvent("BigWigs_SendSync", "HorsemenShieldWall", thane )
	elseif msg == zeliek..L"shieldwalltrigger" then
		self:TriggerEvent("BigWigs_SendSync", "HorsemenShieldWall", zeliek )
	elseif msg == mograine..L"shieldwalltrigger" then
		self:TriggerEvent("BigWigs_SendSync", "HorsemenShieldWall", mograine )
	elseif msg == blaumeux..L"shieldwalltrigger" then
		self:TriggerEvent("BigWigs_SendSync", "HorsemenShieldWall", blaumeux )
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
