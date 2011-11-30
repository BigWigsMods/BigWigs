--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Hagara the Stormbinder", 824, 317)
if not mod then return end
mod:RegisterEnableMob(55689)

--------------------------------------------------------------------------------
-- Locales
--

local iceLanceTargets, blocks = mod:NewTargetList(), mod:NewTargetList()
local nextPhase, nextPhaseIcon

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "You cross the Stormbinder! I'll slaughter you all."

	L.lightning_or_frost = "Lightning or Frost"
	L.ice_next = "Ice phase"
	L.lightning_next = "Lightning phase"

	L.nextphase = "Next Phase"
	L.nextphase_desc = "Warnings for next phase"
	L.nextphase_icon = 2139 -- random icon (counterspell)
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		104448, 109553, 105316,
		109561,
		108934, "nextphase", "proximity", "berserk", "bosskill",
	}, {
		[104448] = L["ice_next"],
		[109561] = L["lightning_next"],
		[108934] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "IceTombStart", 104448)
	self:Log("SPELL_AURA_APPLIED", "IceTombApplied", 104451)
	self:Log("SPELL_AURA_APPLIED", "IceLanceApplied", 105285)
	self:Log("SPELL_AURA_REMOVED", "IceLanceRemoved", 105285)
	self:Log("SPELL_AURA_APPLIED", "Feedback", 108934)
	self:Log("SPELL_CAST_START", "FrozenTempest", 109553, 109554, 105256, 109552)
	self:Log("SPELL_CAST_START", "WaterShield", 109561, 109562, 105409, 109560)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 55689)
end

function mod:OnEngage(diff)
	self:Berserk(480) -- 10 man heroic confirmed
	-- need to find a way to determine which one is at first after engage
	-- apart from looking at her weapon enchants
	if diff > 2 then
		self:Bar("nextphase", L["lightning_or_frost"], 32, 2139)
	else
		self:Bar("nextphase", L["lightning_or_frost"], 82, 2139)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:WaterShield(_, spellId, _, _, spellName)
	self:Message(109561, spellName, "Attention", spellId)
	nextPhase = L["ice_next"]
	nextPhaseIcon = 105409
end

function mod:FrozenTempest(_, spellId, _, _, spellName)
	self:Message(109553, spellName, "Attention", spellId)
	nextPhase = L["lightning_next"]
	nextPhaseIcon = 109561
end

function mod:Feedback(_, spellId, _, _, spellName)
	self:Message(108934, spellName, "Attention", spellId)
	self:Bar("nextphase", nextPhase, 63, nextPhaseIcon)
end

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
			self:OpenProximity(3)
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(iceLance, 0.1, spellName)
		end
	end
end

function mod:IceLanceRemoved(player)
	if UnitIsUnit(player, "player") then
		self:CloseProximity()
	end
end

