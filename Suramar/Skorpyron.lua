if select(4, GetBuildInfo()) < 70000 then return end -- XXX legion check for live

--------------------------------------------------------------------------------
-- TODO List:
-- - Figure out how Arcane Tether works (see comment on event handler)
-- - Be a little bit smarter about timers:
-- -- It looks like Shockwave is always cast on CD. This delays the other abilitys though
-- -- We don't know how the vulnerability phase affect timers yet

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Skorpyron", 1033, 1706)
if not mod then return end
mod:RegisterEnableMob(102263)
mod.engageId = 1849
mod.respawnTime = 30 -- might not be accurate

--------------------------------------------------------------------------------
-- Locals
--

local arcanoslashCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		204275, -- Arcanoslash
		204316, -- Shockwave
		204448, -- Chitinous Exoskeleton
		204459, -- Exoskeletal Vulnerability
		204372, -- Call of the Scorpid
		204471, -- Nether Discharge
		204292, -- Broken Shard
		--{204531, "PROXIMITY"}, -- Arcane Tether
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Arcanoslash", 204275)
	self:Log("SPELL_CAST_START", "Shockwave", 204316)
	self:Log("SPELL_AURA_APPLIED", "ChitinousExoskeletonApplied", 204448)
	self:Log("SPELL_AURA_REMOVED_DOSE", "ChitinousExoskeletonStacks", 204448)
	self:Log("SPELL_AURA_APPLIED", "ExoskeletalVulnerabilityApplied", 204459)
	self:Log("SPELL_CAST_SUCCESS", "CallOfTheScorpid", 204372)
	self:Log("SPELL_CAST_START", "NetherDischarge", 204471)
	self:Log("SPELL_SUMMON", "BrokenShard", 204292)
	--self:Log("SPELL_AURA_APPLIED", "ArcaneTether", 204531) -- Pre alpha testing spellId
	--self:Log("SPELL_AURA_REMOVED", "ArcaneTetherRemoved", 204531) -- Pre alpha testing spellId
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Skorpyron (Alpha) Engaged (Post Alpha Test Mod)", 123886) -- some scorpion icon
	self:Bar(204316, 60) 	-- Shockwave (time to _success)
	self:Bar(204372, 21)	-- Call of the Scorpid
	self:CDBar(204471, 16)	-- Nether Discharge (time to _success)
	arcanoslashCount = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:Arcanoslash(args)
	self:Message(args.spellId, "Important", "Alarm", CL.casting:format(args.spellName))
	if arcanoslashCount % 3 == 1 then -- flurry of 3x 1s casts
		self:CDBar(args.spellId, 10)
	end
	arcanoslashCount = arcanoslashCount + 1
end

function mod:Shockwave(args)
	self:Message(args.spellId, "Important", "Alarm", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 3, CL.cast:format(args.spellName))
	self:Bar(args.spellId, 60)
end

function mod:ChitinousExoskeletonApplied(args)
	self:Message(args.spellId, "Neutral", nil)
end

function mod:ChitinousExoskeletonStacks(args)
	if (args.amount % 5 == 0) or args.amount < 4 then -- 20,15,10,5,3,2,1 This seems sane for now
		self:Message(args.spellId, "Neutral", nil, CL.count:format(self:SpellName(args.spellId), args.amount))
	end
end

function mod:ExoskeletalVulnerabilityApplied(args)
	self:Message(args.spellId, "Positive", "Info") -- 50% more damage taken is positive
	self:Bar(args.spellId, 15) -- this was 14s in alpha tests, but 15s in tooltips, let's gamble
end

function mod:CallOfTheScorpid(args)
	self:Message(args.spellId, "Attention", "Long")
	self:CDBar(args.spellId, 18) -- alpha heroic timing, did vary between 18-22
	-- the 3rd cast was always delayed by ~8s due to shockwave happening
end

function mod:NetherDischarge(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:Bar(args.spellId, 3, CL.cast:format(args.spellName))
	self:CDBar(args.spellId, 30) -- alpha heroic timing, did vary between 30-34
end

function mod:BrokenShard(args)
	self:Message(args.spellId, "Positive", nil, CL.spawned:format(args.spellName))
end

--[[
-- TODO: I have no idea how this works yet.
-- Might be a debuff you only get when you are near the tank (like a fail mechanic)
-- I got the debuff with 2 stacks on the test, ran away and it disapperead - no how, why, ...

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
]]
