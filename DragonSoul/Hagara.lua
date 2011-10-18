if tonumber((select(4, GetBuildInfo()))) < 40300 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Hagara the Stormbinder", 824, 317)
if not mod then return end
mod:RegisterEnableMob(55689)

--------------------------------------------------------------------------------
-- Locales
--

local waterShield = (GetSpellInfo(105409))
local iceLanceTargets = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{105316, "PROXIMITY"}, 105409,
		"bosskill",
	}, {
		[105316] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "IceLanceApplied", 105269, 105316, 105285) -- might not need all these spellIds
	self:Log("SPELL_AURA_REMOVED", "IceLanceRemowed", 105316, 105285)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 55689)
end

function mod:OnEngage(diff)
	self:Bar(105409, waterShield, 82, 105409)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local scheduled = nil
	local function iceLance(spellName)
		mod:TargetMessage(105316, spellName, iceLanceTargets, "Attention", 105316, "Info")
		scheduled = nil
	end
	function mod:IceLanceApplied(player, spellID, _, _, spellName)
		iceLanceTargets[#iceLanceTargets + 1] = player
		if UnitIsUnit(player, "player") then
			self:OpenProximity(105316, 3)
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(iceLance, 0.1, spellName)
		end
	end
end

function mod:IceLanceRemowed(player, spellID, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:CloseProximity(105316)
	end
end

