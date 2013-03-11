--[[
TODO:
	VolatilePathogen no longer seems to spawn adds (25 H PTR) need to confirm this on live
]]--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Primordius", 930, 820)
if not mod then return end
mod:RegisterEnableMob(69017)

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.mutations = "Mutations |cff008000(%d)|r |cffff0000(%d)|r"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-6969,
		136037, 136216, {136218, "PROXIMITY"}, 136228, 136245, {136246, "PROXIMITY"}, -7830, {-6960, "FLASH"},
		"berserk", "bosskill",
	}, {
		[-6969] = "heroic",
		[136037] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_REMOVED", "PlayerMutations", 136184, 136186, 136182, 136180, 136185, 136187, 136183, 136181)
	self:Log("SPELL_AURA_APPLIED_DOSE", "PlayerMutations", 136184, 136186, 136182, 136180, 136185, 136187, 136183, 136181)
	self:Log("SPELL_AURA_APPLIED", "PlayerMutations", 136184, 136186, 136182, 136180, 136185, 136187, 136183, 136181)
	self:Log("SPELL_AURA_REMOVED", "FullyMutatedRemoved", 140546)
	self:Log("SPELL_AURA_APPLIED", "FullyMutatedApplied", 140546)
	self:Log("SPELL_AURA_REMOVED", "EruptingPustulesRemoved", 136246)
	self:Log("SPELL_AURA_APPLIED", "EruptingPustulesApplied", 136246)
	self:Log("SPELL_AURA_REMOVED", "MetabolicBoost", 136245)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MetabolicBoost", 136245) -- have not seen this event yet, but lets assume it exists
	self:Log("SPELL_AURA_APPLIED", "MetabolicBoost", 136245)
	self:Log("SPELL_AURA_REMOVED", "VolatilePathogenRemoved", 136228)
	self:Log("SPELL_CAST_SUCCESS", "VolatilePathogen", 136228) -- this is faster than APPLIED
	self:Log("SPELL_CAST_SUCCESS", "PathogenGlands", 136225)
	self:Log("SPELL_AURA_REMOVED", "AcidicSpinesRemoved", 136218)
	self:Log("SPELL_AURA_APPLIED", "AcidicSpinesApplied", 136218)
	self:Log("SPELL_CAST_START", "CausticGas", 136216)
	self:Log("SPELL_CAST_SUCCESS", "PrimordialStrike", 136037)

	self:Death("Win", 69017)
end

function mod:OnEngage()
	self:Berserk(480) -- confirmed 25 N live
	self:Bar(136037, 18) -- Primordial Strike
	if self:Heroic() then
		self:Bar(-6969, 12, 137000) -- Viscous Horror
		self:ScheduleTimer("ViscousHorror", 12)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ViscousHorror()
	self:Message(-6969, "Attention", nil, nil, 137000)
	self:Bar(-6969, 30, 137000)
	self:ScheduleTimer("ViscousHorror", 30)
end

do
	local scheduled = nil
	local function warnPlayerMutations()
		-- Positive
		local statsP = select(4, UnitDebuff("player", mod:SpellName(136184))) or 0 -- Thick Bones
		local masteryP = select(4, UnitDebuff("player", mod:SpellName(136186))) or 0 -- Clear Mind
		local hasteP = select(4, UnitDebuff("player", mod:SpellName(136182))) or 0 -- Improved Synampes
		local critP = select(4, UnitDebuff("player", mod:SpellName(136180))) or 0 -- Keen Eyesight
		local totalP = statsP + masteryP + hasteP + critP
		-- Negative
		local statsN = select(4, UnitDebuff("player", mod:SpellName(136185))) or 0
		local masteryN = select(4, UnitDebuff("player", mod:SpellName(136187))) or 0
		local hasteN = select(4, UnitDebuff("player", mod:SpellName(136183))) or 0
		local critN = select(4, UnitDebuff("player", mod:SpellName(136181))) or 0
		local totalN = statsN + masteryN + hasteN + critN

		mod:Message(-6960, "Personal", ((totalP > 3) or (totalN > 0)) and "Info" or nil, L["mutations"]:format(totalP, totalN), 136184)
		if totalP == 5 then
			mod:Flash(-6960)
		end
		scheduled = nil
	end
	function mod:PlayerMutations(args)
		if self:Me(args.destGUID) and not scheduled then
			scheduled = self:ScheduleTimer(warnPlayerMutations, 1)
		end
	end
end

function mod:FullyMutatedRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellId)
		self:Message(-7830, "Personal", "Info", CL["over"]:format(args.spellName), args.spellId)
	end
end

function mod:FullyMutatedApplied(args)
	if self:Me(args.destGUID) then
		self:Message(-7830, "Personal", "Info", CL["you"]:format(args.spellName), args.spellId)
		self:Bar(-7830, 120, args.spellId)
	end
end

function mod:EruptingPustulesRemoved(args)
	if not UnitBuff("boss1", self:SpellName(136218)) then -- the 5 yard spread Acidic Spines
		self:CloseProximity(args.spellId)
	end
end

function mod:EruptingPustulesApplied(args)
	if not UnitBuff("boss1", self:SpellName(136218)) then -- the 5 yard spread Acidic Spines
		self:OpenProximity(args.spellId, 5)
	end
	self:Message(args.spellId, "Attention")
end

function mod:MetabolicBoost(args)
	self:Message(args.spellId, "Attention")
end

function mod:VolatilePathogenRemoved(args)
	self:PrimaryIcon(args.spellId)
end

function mod:VolatilePathogen(args)
	if self:Healer() or self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	end
	self:CDBar(args.spellId, 27)
end

function mod:PathogenGlands(args)
	if self:Healer() then
		self:Message(136228, "Important", "Long", CL["soon"]:format(args.spellName))
	end
end

function mod:AcidicSpinesRemoved(args)
	if UnitBuff("boss1", self:SpellName(136246)) then -- the 2 yard spread Erupting Pustules
		self:CloseProximity(args.spellId)
		self:OpenProximity(136246, 2)
	else
		self:CloseProximity(args.spellId)
	end
end

function mod:AcidicSpinesApplied(args)
	self:OpenProximity(args.spellId, 5)
	self:Message(args.spellId, "Important", "Long", args.spellName) -- this maybe should say: Splash attack - SPREAD! ?
end

function mod:CausticGas(args)
	self:Message(args.spellId, "Urgent", nil, args.spellName)
	self:CDBar(args.spellId, 12)
end

function mod:PrimordialStrike(args)
	self:Message(args.spellId, "Attention", nil, args.spellName)
	self:CDBar(args.spellId, 19)
end

