if tonumber((select(4, GetBuildInfo()))) < 40300 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Hagara the Stormbinder", 824, 317)
if not mod then return end
mod:RegisterEnableMob(55689)

--------------------------------------------------------------------------------
-- Locales
--

local waterShield = (GetSpellInfo(105409))
local iceLanceTargets, blocks = mod:NewTargetList(), mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{105316, "PROXIMITY"}, 105409, 104448,
		"bosskill",
	}, {
		[105316] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "IceTombStart", 104448)
	self:Log("SPELL_AURA_APPLIED", "IceTombApplied", 104451)
	self:Log("SPELL_AURA_APPLIED", "IceLanceApplied", 105285)
	self:Log("SPELL_AURA_REMOVED", "IceLanceRemowed", 105285)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 55689)
end

function mod:OnEngage(diff)
	self:Bar(105409, waterShield, 82, 105409)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:IceTombStart(_, spellId, _, _, spellName)
	self:Message(104448, spellName, "Attention", spellId)
	self:Bar(104448, spellName, 8, spellId)
end

do
	local scheduled = nil
	local function iceTomb(spellName)
		mod:TargetMessage(104448, spellName, blocks, "Important", 104448)
		scheduled = nil
	end
	function mod:IceTombApplied(player, _, _, _, spellName)
		blocks[#blocks + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(iceTomb, 0.1, spellName)
		end
	end
end

do
	local scheduled = nil
	local function iceLance(spellName)
		mod:TargetMessage(105316, spellName, iceLanceTargets, "Urgent", 105316, "Info")
		scheduled = nil
	end
	function mod:IceLanceApplied(player, _, _, _, spellName)
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

function mod:IceLanceRemowed(player)
	if UnitIsUnit(player, "player") then
		self:CloseProximity(105316)
	end
end

