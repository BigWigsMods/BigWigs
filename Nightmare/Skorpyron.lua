--------------------------------------------------------------------------------
-- TODO List:
-- - The whole fight (this mod is based on dungeon journal / wowhead guessing)

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Skorpyron", 1520) -- TODO (wrong map id)
if not mod then return end
mod:RegisterEnableMob(102263) -- TODO
-- mod.engageId = 0 -- TODO
-- mod.respawnTime = 0 -- TODO

--------------------------------------------------------------------------------
-- Locals
--


--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		204316, -- Shockwave
		204448, -- Chitinous Exoskeleton
		204459, -- Exoskeletal Vulnerability
		204371, -- Call of the Scorpid
		{204531, "PROXIMITY"}, -- Arcane Tether
		204471, -- Nether Discharge
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Shockwave", 204316) -- Pre alpha testing spellId
	self:Log("SPELL_CAST_START", "ChitinousExoskeletonCast", 204448) -- Pre alpha testing spellId
	self:Log("SPELL_AURA_APPLIED", "ChitinousExoskeletonApplied", 204448, 206947) -- Pre alpha testing spellId, this might also be redundant
	self:Log("SPELL_AURA_APPLIED", "ExoskeletalVulnerabilityApplied", 204459) -- Pre alpha testing spellId
	self:Log("SPELL_CAST_SUCCESS", "CallOfTheScorpid", 204371) -- Pre alpha testing spellId
	self:Log("SPELL_AURA_APPLIED", "ArcaneTether", 204531) -- Pre alpha testing spellId
	self:Log("SPELL_AURA_REMOVED", "ArcaneTetherRemoved", 204531) -- Pre alpha testing spellId
	self:Log("SPELL_CAST_START", "NetherDischarge", 204471) -- Pre alpha testing spellId
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Skorpyron (Alpha) Engaged (Pre Alpha Test Mod)", 123886) -- some scorpion icon
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:Shockwave(args)
	self:Message(args.spellId, "Important", "Alarm", CL.casting:format(args.spellName) .. " - Stand behind Broken Shards") -- TODO alpha stuff
	self:Bar(args.spellId, 3, CL.cast:format(args.spellName))
end

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:ChitinousExoskeletonCast(args)
	self:Message(args.spellId, "Urgent", nil, CL.casting:format(args.spellName))
	self:Bar(args.spellId, 10, CL.cast:format(args.spellName))
end

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:ChitinousExoskeletonApplied(args)
	self:TargetMessage(204448, args.destName, "Urgent", nil)
end

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:ExoskeletalVulnerabilityApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Positive", "Info")
end

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:CallOfTheScorpid(args)
	self:Message(args.spellId, "Attention", "Long")
end

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:ArcaneTether(args)
	self:TargetMessage(args.spellId, args.destName, "Important", "Alert")
	if self:Me(args.destGUID) then
		self:OpenProximity(args.spellId, 10)
	end
end

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:ArcaneTetherRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:NetherDischarge(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:Bar(args.spellId, 3, CL.cast:format(args.spellName))
end
