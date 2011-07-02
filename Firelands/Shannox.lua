--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Shannox", 800, 195)
if not mod then return end
mod:RegisterEnableMob(53691)

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.safe = "%s safe"
	L.immolation_trap = "Immolation on %s!"
	L.crystaltrap = "Crystal Trap"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		100002, 101209, {99836, "SAY", "FLASHSHAKE"},
		{100129, "ICON"},
		"bosskill"
	}, {
		[100002] = "general"
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
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local function trapWarn()
		if UnitExists("boss1target") then
			mod:TargetMessage(99836, L["crystaltrap"], (UnitName("boss1target")), "Urgent", 99836, "Alarm")
			if UnitIsUnit("boss1target", "player") then
				mod:FlashShake(99836)
				mod:Say(99836, CL["say"]:format(L["crystaltrap"]))
			end
		end
	end

	function mod:CrystalTrap()
		self:ScheduleTimer(trapWarn, 0.2)
	end
end

function mod:ImmolationTrap(player, spellId, _, _, spellName, _, _, _, _, dGUID)
	local unitId = tonumber(dGUID:sub(7, 10), 16)
	if unitId == 53695 or unitId == 53694 then
		self:Message(100129, L["immolation_trap"]:format(player), "Attention", spellId)
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

