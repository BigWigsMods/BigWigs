--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Shannox", 800, 195)
if not mod then return end
mod:RegisterEnableMob(53691, 53695, 53694) --Shannox, Rageface, Riplimb

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.safe = "%s safe"
	L.immolation_trap = "Immolation on %s!"
	L.crystaltrap = "Crystal Trap"

	L.traps_header = "Traps"
	L.immolation = "Immolation Trap"
	L.immolation_desc = "Alert when someone steps on an Immolation Trap."
	L.immolation_icon = 99838
	L.crystal = "Crystal Trap"
	L.crystal_desc = "Warn whom Shannox casts a Crystal Trap under."
	L.crystal_icon = 99836
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		100002, {100129, "ICON"}, "berserk", "bosskill",
		"immolation", {"crystal", "SAY", "FLASHSHAKE"},
	}, {
		[100002] = "general",
		["immolation"] = L["traps_header"],
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "ImmolationTrap", 101209, 99838)
	self:Log("SPELL_CAST_SUCCESS", "FaceRage", 99945, 99947)
	self:Log("SPELL_AURA_REMOVED", "FaceRageRemoved", 99945, 99947)
	self:Log("SPELL_CAST_SUCCESS", "HurlSpear", 99978)
	self:Log("SPELL_SUMMON", "CrystalTrap", 99836)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 53691)
end

function mod:OnEngage(diff)
	self:Bar(100002, (GetSpellInfo(100002)), 23, 100002) -- Hurl Spear
	self:Berserk(600)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local timer, fired = nil, 0
	local function trapWarn()
		fired = fired + 1
		if UnitExists("boss1target") and (not UnitDetailedThreatSituation("boss1target", "boss1") or fired > 13) then
			--If we've done 14 (0.7s) checks and still not passing the threat check, it's probably being cast on the tank
			mod:TargetMessage("crystal", L["crystaltrap"], (UnitName("boss1target")), "Urgent", 99836, "Alarm")
			mod:CancelTimer(timer, true)
			timer = nil
			if UnitIsUnit("boss1target", "player") then
				mod:FlashShake("crystal")
				mod:Say("crystal", CL["say"]:format(L["crystaltrap"]))
			end
			return
		end
		-- 19 == 0.95sec
		-- Safety check if the unit doesn't exist
		if fired > 18 then
			mod:CancelTimer(timer, true)
			timer = nil
		end
	end
	function mod:CrystalTrap()
		fired = 0
		if not timer then
			timer = self:ScheduleRepeatingTimer(trapWarn, 0.05)
		end
	end
end

function mod:ImmolationTrap(player, spellId, _, _, spellName, _, _, _, _, dGUID)
	local unitId = tonumber(dGUID:sub(7, 10), 16)
	if unitId == 53695 or unitId == 53694 then
		self:Message("immolation", L["immolation_trap"]:format(player), "Attention", spellId)
	end
end

function mod:HurlSpear(_, spellId, _, _, spellName)
	self:Message(100002, spellName, "Attention", spellId, "Info")
	self:Bar(100002, spellName, 41, spellId)
end

function mod:FaceRage(player, spellId, _, _, spellName)
	self:TargetMessage(100129, spellName, player, "Important", spellId, "Alert")
	self:PrimaryIcon(100129, player)
end

function mod:FaceRageRemoved(player, spellId)
	self:Message(100129, L["safe"]:format(player), "Positive", spellId)
end

