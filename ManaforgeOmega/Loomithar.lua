if not BigWigsLoader.isTestBuild then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Loom'ithar", 2810, 2686)
if not mod then return end
mod:RegisterEnableMob(233815) -- Loom'ithar XXX Confirm
mod:SetEncounterID(3131)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local lairWeavingCount = 1
local overinfusionBurstCount = 1
local infusionTetherCount = 1
local piercingStrandCount = 1

local arcaneOutrageCount = 1
local writhingWaveCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

-- function mod:OnRegister()
-- 	self:SetSpellRename(1234567, "String") -- Spell (Rename)
-- end

function mod:GetOptions()
	return {
		-- Phase 1: The Silkbound Beast
			-- 1231408, -- Arcane Overflow
			1237272, -- Lair Weaving
				-- 1238502, -- Woven Ward
			-- 1226867, -- Primal Spellstorm XXX No cast timer, just passive dodges?
			1226395, -- Overinfusion Burst
			{1226311, "ME_ONLY_EMPHASIZE"}, -- Infusion Tether
				1226366, -- Living Silk
			{1237212, "TANK"}, -- Piercing Strand
			-- 1231403, -- Silk Blast (Melee Replacement)
		-- Intermission: Unravelling
			1228059, -- Unbound Rage
				1243771, -- Arcane Ichor
		-- Phase 2: The Deathbound Beast
			1227782, -- Arcane Outrage
			1227226, -- Writhing Wave
	},{
		{
			tabName = CL.stage:format(1),
			{1237272, 1226395, 1226311, 1226366, 1237212},
		},
		{
			tabName = CL.intermission,
			{1228059, 1243771}
		},
		{
			tabName = CL.stage:format(2),
			{1227782, 1243771, 1227226}
		},
	}
end

function mod:OnBossEnable()
	-- Phase 1: The Silkbound Beast
	self:Log("SPELL_AURA_APPLIED", "LairWeaving", 1237272) -- Channeled
	self:Log("SPELL_AURA_APPLIED", "OverinfusionBurst", 1226395) -- Channeled
	self:Log("SPELL_CAST_SUCCESS", "InfusionTether", 1226315)
	self:Log("SPELL_AURA_APPLIED", "InfusionTetherApplied", 1226311)
	self:Log("SPELL_AURA_APPLIED", "LivingSilkDamage", 1226366)
	self:Log("SPELL_PERIODIC_DAMAGE", "LivingSilkDamage", 1226366)
	self:Log("SPELL_PERIODIC_MISSED", "LivingSilkDamage", 1226366)
	self:Log("SPELL_CAST_START", "PiercingStrand", 1227263)
	self:Log("SPELL_AURA_APPLIED", "PiercingStrandApplied", 1237212)
	-- Intermission: Unravelling
	self:Log("SPELL_AURA_APPLIED", "UnboundRageApplied", 1228059)
	self:Log("SPELL_AURA_APPLIED", "ArcaneIchorDamage", 1243771)
	self:Log("SPELL_PERIODIC_DAMAGE", "ArcaneIchorDamage", 1243771)
	self:Log("SPELL_PERIODIC_MISSED", "ArcaneIchorDamage", 1243771)
	-- Phase 2: The Deathbound Beast
	self:Log("SPELL_CAST_START", "ArcaneOutrage", 1227782)
	self:Log("SPELL_CAST_START", "WrithingWave", 1227226)
end

function mod:OnEngage()
	self:SeStage(1)

	lairWeavingCount = 1
	overinfusionBurstCount = 1
	infusionTetherCount = 1
	piercingStrandCount = 1

	-- self:Bar(1237272, 8.0, CL.count:format(self:SpellName(1237272), lairWeavingCount)) -- Lair Weaving
	-- self:Bar(1226395, 12.0, CL.count:format(self:SpellName(1226395), overinfusionBurstCount)) -- Overinfusion Burst
	-- self:Bar(1226311, 15.0, CL.count:format(self:SpellName(1226311), infusionTetherCount)) -- Infusion Tether
	-- self:Bar(1237212, 20.0, CL.count:format(self:SpellName(1237212), piercingStrandCount)) -- Piercing Strand

	arcaneOutrageCount = 1 -- XXX Move to stage 2 start
	writhingWaveCount = 1 -- XXX Move to stage 2 start
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:LairWeaving(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, lairWeavingCount))
	self:PlaySound(args.spellId, "alert") -- ring coming, kill for gap?
	lairWeavingCount = lairWeavingCount + 1
	--self:Bar(args.spellId, 9, CL.count:format(args.spellName, lairWeavingCount))
end

function mod:OverinfusionBurst(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, overinfusionBurstCount))
	self:PlaySound(args.spellId, "warning") -- move away
	overinfusionBurstCount = overinfusionBurstCount + 1
	--self:Bar(args.spellId, 9, CL.count:format(args.spellName, overinfusionBurstCount))
end

function mod:InfusionTether(args)
	self:Message(1226311, "cyan", CL.count:format(args.spellName, overinfusionBurstCount))
	overinfusionBurstCount = overinfusionBurstCount + 1
	--self:Bar(1226311, 9, CL.count:format(args.spellName, overinfusionBurstCount))
end

function mod:InfusionTetherApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning") -- break tether
	end
end

do
	local prev = 0
	function mod:LivingSilkDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

function mod:PiercingStrand(args)
	self:Message(1237212, "purple", CL.count:format(args.spellName, piercingStrandCount))
	self:PlaySound(1237212, "alert") -- tank hit inc
	piercingStrandCount = piercingStrandCount + 1
	-- self:Bar(1237212, 9, CL.count:format(args.spellName, piercingStrandCount))
end

function mod:PiercingStrandApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- big dot
	elseif self:Tank() then
		self:PlaySound(args.spellId, "warning") -- taunt?
	end
end

-- Intermission: Unravelling
function mod:UnboundRageApplied(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "long") -- intermission?
end

do
	local prev = 0
	function mod:ArcaneIchorDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

-- Phase 2: The Deathbound Beast
function mod:ArcaneOutrage(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, arcaneOutrageCount))
	self:PlaySound(args.spellId, "alert") -- watch pools spawning?
	arcaneOutrageCount = arcaneOutrageCount + 1
	--self:Bar(args.spellId, 9, CL.count:format(args.spellName, arcaneOutrageCount))
end

function mod:WrithingWave(args)
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, writhingWaveCount))
	self:PlaySound(args.spellId, "warning") -- soak or avoid
	writhingWaveCount = writhingWaveCount + 1
	--self:Bar(args.spellId, 9, CL.count:format(args.spellName, writhingWaveCount))
end
