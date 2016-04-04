--------------------------------------------------------------------------------
-- TODO List:
-- - Fix mod after testing
-- - Add nicer phase separation comments/options
-- - Respawn time
-- - Tuning sounds / message colors
-- - Remove alpha engaged message

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Spellblade Aluriel", 1530)
if not mod then return end
mod:RegisterEnableMob(107699) -- fix me
--mod.engageId = 1000000
--mod.respawnTime = 0

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
		-- General
		212492, -- Annihilate
		"berserk",

		-- Frost Phase
		212531, -- Pre Mark of Frost(?)
		212587, -- Mark of Frost
		212530, -- Replicate: Mark of Frost
		212735, -- Detonate: Mark of Frost
		212736, -- Pool of Frost
		-- Frozen Tempest TODO

		-- Fire Phase
		213166, -- Searing Brand
		-- Replicate: Searing Brand TODO, no spell id in wowhead?!
		213275, -- Detonate: Searing Brand
		213278, -- Burning Ground

		-- Arcane Phase
		213852, -- Replicate: Arcane Orb
		213568, -- Armageddon
		213520, -- Arcane Orb
		213504, -- Arcane Fog
	}
end

function mod:OnBossEnable()
	-- General
	self:Log("SPELL_CAST_START", "AnnihilateCast", 212492)  -- Pre alpha test spellId
	self:Log("SPELL_AURA_APPLIED", "AnnihilateApplied", 212494, 215458)  -- Pre alpha test spellId
	self:Log("SPELL_AURA_APPLIED_DOSE", "AnnihilateApplied", 212494, 215458)  -- Pre alpha test spellId

	-- Frost Phase
	self:Log("SPELL_AURA_APPLIED", "PreMarkOfFrostApplied", 212531)  -- Pre alpha test spellId
	self:Log("SPELL_AURA_APPLIED", "MarkOfFrostApplied", 212587, 212738)  -- Pre alpha test spellId
	self:Log("SPELL_CAST_START", "ReplicateMarkOfFrost", 212530)  -- Pre alpha test spellId
	self:Log("SPELL_CAST_START", "DetonateMarkOfFrost", 212735)  -- Pre alpha test spellId

	-- Fire Phase
	self:Log("SPELL_AURA_APPLIED", "SearingBrandApplied", 213166)  -- Pre alpha test spellId
	self:Log("SPELL_CAST_START", "DetonateSearingBrand", 213275)  -- Pre alpha test spellId

	-- Arcane Phase
	self:Log("SPELL_CAST_START", "ReplicateArcaneOrb", 213852)  -- Pre alpha test spellId
	self:Log("SPELL_CAST_START", "Armageddon", 213568)  -- Pre alpha test spellId

	-- Trying to be clever here
	self:Log("SPELL_AURA_APPLIED", "StandingInShitDamage", 212736, 213278, 213504, 213520) -- Pre alpha test spellId
	self:Log("SPELL_PERIODIC_DAMAGE", "StandingInShitDamage", 212736, 213278, 213504, 213520) -- Pre alpha test spellId
	self:Log("SPELL_PERIODIC_MISSED", "StandingInShitDamage", 212736, 213278, 213504, 213520) -- Pre alpha test spellId
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Spellblade Aluriel (Alpha) Engaged (Pre Alpha Test Mod)")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- General
-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:AnnihilateCast(args)
	self:Message(args.spellId, "Important", "Alarm", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 4, CL.cast:format(args.spellName))
end

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:AnnihilateApplied(args)
	local amount = args.amount or 1
	self:StackMessage(212492, args.destName, amount, "Important", amount > 2 and "Warning") -- XXX fix sound amount, not even alpha
end


-- Frost Phase
-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:PreMarkOfFrostApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Attention")
end

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:MarkOfFrostApplied(args)
	self:TargetMessage(212587, args.destName, "Urgent")
end

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:ReplicateMarkOfFrost(args)
	self:Message(args.spellId, "Important")
end

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:DetonateMarkOfFrost(args)
	self:Message(args.spellId, "Important")
end


-- Fire Phase
-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:SearingBrandApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent")
end

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:DetonateSearingBrand(args)
	self:Message(args.spellId, "Important")
end

-- Arcane Phase
-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:ReplicateArcaneOrb(args)
	self:Message(args.spellId, "Important")
end

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:Armageddon(args)
	self:Message(args.spellId, "Urgent")
end


-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
do
	local prev = 0
	function mod:StandingInShitDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end