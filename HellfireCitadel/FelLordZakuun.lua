
-- Notes --
-- Fel Explosions cast/aura? (hidden)
-- Wake of Destruction?
-- Fel Crystal Damage id

--------------------------------------------------------------------------------
-- Module Declaration
--

if not IsTestBuild() then return end

local mod, CL = BigWigs:NewBoss("Fel Lord Zakuun", 1026, 1391)
if not mod then return end
mod:RegisterEnableMob(91394) -- XXX not hopeful for this
--mod.engageId = 0

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1

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
		{179711, "PROXIMITY", "SAY"}, -- Befouled
		179671, -- Heavily Armed
		179407, -- Disembodied
		179582, -- Rumbling Fissure
		179620, -- Fel Crystal
		{181508, "SAY"}, -- Seed of Destruction
		179681, -- Enrage
		"berserk",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_APPLIED", "Befouled", 179711)
	self:Log("SPELL_AURA_REMOVED", "BefouledRemoved", 179711)
	self:Log("SPELL_AURA_APPLIED", "HeavilyArmed", 179671)
	self:Log("SPELL_AURA_APPLIED", "Disembodied", 179407)
	self:Log("SPELL_CAST_SUCCESS", "RumblingFissure", 179582)
	self:Log("SPELL_AURA_APPLIED", "SeedOfDestruction", 181508, 181515)
	self:Log("SPELL_AURA_APPLIED", "Enrage", 179681)

	self:Log("SPELL_AURA_APPLIED", "FelCrystalDamage", 179620)
	self:Log("SPELL_PERIODIC_DAMAGE", "FelCrystalDamage", 179620)
	self:Log("SPELL_PERIODIC_MISSED", "FelCrystalDamage", 179620)
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Fel Lord Zakuun (beta) engaged", false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local list = mod:NewTargetList()
	function mod:Befouled(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Attention", "Alarm")
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:OpenProximity(args.spellId, 10)
		end
	end
end

function mod:BefouledRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

function mod:HeavilyArmed(args)
	self:Message(args.spellId, "Positive", self:Tank() and "Warning")
end

function mod:Disembodied(args)
	self:TargetMessage(args.spellId, args.destName, "Important")
end

function mod:RumblingFissure(args)
	self:Message(args.spellId, args.destName, "Urgent", "Info")
end

do
	local list = mod:NewTargetList()
	function mod:SeedOfDestruction(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, 181508, list, "Attention", "Alarm")
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
	end
end

function mod:Enrage(args)
	self:Message(args.spellId, "Important", "Long")
end

do
	local prev = 0
	function mod:FelCrystalDamage(args)
		local t = GetTime()
		if t-prev > 1.5 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

