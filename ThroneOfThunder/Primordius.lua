--[[
TODO:
	I have put metabolic boost stack count in every message, so it is easier to figure out what is affected by it and what is not from a transcriptor log
		this should be removed once we figure things out
]]--
if select(4, GetBuildInfo()) < 50200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Primordius", 930, 820)
if not mod then return end
mod:RegisterEnableMob(69017)

--------------------------------------------------------------------------------
-- Locals
--
local MB = "<MB:0>" -- MetabolicBoost


--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.stream_of_blobs = "Stream of blobs"
	L.mutations = "Mutations"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		136037, 136216, {136218, "PROXIMITY"}, {136228, "ICON"}, 136245, {136246, "PROXIMITY"}, "ej:7830", {"ej:6960", "FLASH"},
		"berserk", "bosskill",
	}, {
		[136037] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_REMOVED", "PlayerMutations", 136184, 136186, 136182, 136180) -- Thick Bones, Clear Mind, Improved Synampes, Keen Eyesight
	self:Log("SPELL_AURA_APPLIED_DOSE", "PlayerMutations", 136184, 136186, 136182, 136180) -- Thick Bones, Clear Mind, Improved Synampes, Keen Eyesight
	self:Log("SPELL_AURA_APPLIED", "PlayerMutations", 136184, 136186, 136182, 136180) -- Thick Bones, Clear Mind, Improved Synampes, Keen Eyesight
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
	self:Berserk(600) -- XXX Assumed
	self:Bar(136037, 18) -- Primordial Strike
	MB = "<MB:0>"
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local function warnPlayerMutations()
		local stats = select(4, UnitDebuff("player", mod:SpellName(136184))) or 0   -- Thick Bones
		local mastery = select(4, UnitDebuff("player", mod:SpellName(136186))) or 0 -- Clear Mind
		local haste = select(4, UnitDebuff("player", mod:SpellName(136182))) or 0   -- Improved Synampes
		local crit  = select(4, UnitDebuff("player", mod:SpellName(136180))) or 0   -- Keen Eyesight
		local total = stats + mastery + haste + crit
		if total == 5 then mod:Flash("ej:6960") end
		local stacks = (total < 6) and (" |c00008000(%d)|r"):format(total) or (" |c00FF0000(%d)|r"):format(total) -- less than 6 stacks is a buff, more than that is a debuff, so color less than 6 green, more than that red
		mod:Message("ej:6960", "Personal", (total > 3) and "Info" or nil, L["mutations"]..stacks, 136184)
	end
	function mod:PlayerMutations(args)
		if not UnitIsUnit("player", args.destName) then return end
		self:ScheduleTimer(warnPlayerMutations, 1)
	end
end

function mod:FullyMutatedRemoved(args)
	if not UnitIsUnit("player", args.destName) then return end
	self:StopBar(args.spellId)
	self:Message("ej:7830", "Personal", "Info", CL["over"]:format(args.spellName), args.spellId)
end

function mod:FullyMutatedApplied(args)
	if not UnitIsUnit("player", args.destName) then return end
	self:Bar("ej:7830", 120, args.spellId)
	self:Message("ej:7830", "Personal", "Info", CL["you"]:format(args.spellName), args.spellId)
end

function mod:EruptingPustulesRemoved(args)
	if not UnitBuff("boss1", self:SpellName(136218)) then -- the 5 yard spread Acidic Spines
		self:CloseProximity(args.spellId)
	end
end

function mod:EruptingPustulesApplied(args)
	if not UnitBuff("boss1", self:SpellName(136218)) then -- the 5 yard spread AcidicSpines
		self:OpenProximity(args.spellId, 2)
	end
	self:Message(args.spellId, "Attention", nil, args.spellName..MB)
end

function mod:MetabolicBoost(args)
	local MBStacks = select(4, UnitBuff("boss1", self:SpellName(136245))) or 0
	MB = ("<MB:%d>"):format(MBStacks)
	self:Message(args.spellId, "Attention", nil, ("%s (%d)"):format(args.spellName, MBStacks))
end

function mod:VolatilePathogenRemoved(args)
	self:PrimariyIcon(args.spellId)
end

function mod:VolatilePathogen(args)
	self:PrimariyIcon(args.spellId, args.destName)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm", L["Stream of blobs"]..MB)
	self:CDBar(args.spellId, 27, L["Stream of blobs"])
end

function mod:PathogenGlands(args)
	self:Message(136228, "Important", "Long", CL["soon"]:format(L["stream_of_blobs"]..MB))
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
	self:OpenProximity(args.spellid, 5)
	self:Message(args.spellId, "Important", "Long", args.spellName..MB) -- this maybe should say: Splash attack - SPREAD! ?
end

function mod:CausticGas(args)
	self:Message(args.spellId, "Urgent", nil, args.spellName..MB)
	self:CDBar(args.spellId, 12)
end

function mod:PrimordialStrike(args)
	self:Message(args.spellId, "Attention", nil, args.spellName..MB)
	self:CDBar(args.spellId, 19)
end

