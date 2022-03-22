-------------------------------------------------------------------------------
--  Module Declaration
--

local mod, CL = BigWigs:NewBoss("Halazzi", 568, 189)
if not mod then return end
mod:RegisterEnableMob(23577)
mod:SetEncounterID(1192)
-- mod:SetRespawnTime(0) -- resets, doesn't respawn

--------------------------------------------------------------------------------
--  Locals
--

local spiritPhasesLeft = 3
local castCollector = {}

-------------------------------------------------------------------------------
--  Localization
--

local L = mod:GetLocale()
if L then
	L.spirit_message = "Spirit Phase"
	L.normal_message = "Normal Phase"
end

-------------------------------------------------------------------------------
--  Initialization
--

function mod:GetOptions()
	return {
		"stages",
		43303, -- Flame Shock
		43139, -- Frenzy
		43302, -- Lightning Totem
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

	self:Log("SPELL_AURA_APPLIED", "FlameShock", 43303)
	self:Log("SPELL_AURA_REMOVED", "FlameShockRemoved", 43303)
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 43139)
	self:Log("SPELL_CAST_START", "Totems", 43302) -- Lightning Totem
end

function mod:OnEngage()
	spiritPhasesLeft = 3
	castCollector = {}
end

-------------------------------------------------------------------------------
--  Event Handlers
--

function mod:FlameShock(args)
	self:TargetMessageOld(args.spellId, args.destName, "yellow", "alarm")
	self:TargetBar(args.spellId, 12, args.destName)
end

function mod:FlameShockRemoved(args)
	self:StopBar(args.spellName, args.destName)
end

function mod:Frenzy(args)
	self:MessageOld(args.spellId, "red")
end

function mod:Totems(args)
	self:MessageOld(args.spellId, "orange", "alert", CL.casting:format(args.spellName))
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, castGUID, spellId)
	-- All spells used are called "Halazzi Transform"
	if spellId == 43143 and not castCollector[castGUID] then -- Spirit Phase
		castCollector[castGUID] = true
		self:MessageOld("stages", "green", nil, CL.percent:format(25 * spiritPhasesLeft, L.spirit_message), "ability_hunter_pet_cat")
		spiritPhasesLeft = spiritPhasesLeft - 1
	elseif (spellId == 43145 or spellId == 43271) and not castCollector[castGUID] then -- Normal Phase
		castCollector[castGUID] = true
		self:MessageOld("stages", "green", nil, L.normal_message, "achievement_character_troll_male")
	end
end
