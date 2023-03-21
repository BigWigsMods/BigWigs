if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Molgoth", 2569, 2529)
if not mod then return end
mod:RegisterEnableMob(201774, 201773, 201934) -- Krozgoth Moltannia, Molgoth
mod:SetEncounterID(2687)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

-- Krozgoth
local coalescingVoidCount = 1
local umbralDetonationCount = 1
local shadowsConvergenceCount = 1

-- Moltannia
local fieryMeteorCount = 1
local moltenEruptionCount = 1
local swirlingFlameCount = 1

-- Molgoth
local gloomConflagrationCount = 1
local blisteringTwilightCount = 1
local convergentEruptionCount = 1
local shadowflameBurstCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		-- Krozgoth
		401809, -- Corrupting Shadow
		403459, -- Coalescing Void
		{405036, "SAY", "SAY_COUNTDOWN"}, -- Umbral Detonation
		405084, -- Lingering Umbra
		407640, -- Shadows Convergence
		-- {403699, "TANK"} -- Shadow Spike
		-- Moltannia
		402617, -- Blazing Heat
		404732, -- Fiery Meteor
		403101, -- Molten Eruption
		404896, -- Swirling Flame
		-- {403203, "TANK"}, -- Flame Slash
		-- Molgoth
		405394, -- Shadowflame
		405437, -- Gloom Conflagration
		{405642, "SAY", "SAY_COUNTDOWN"}, -- Blistering Twilight
		405645, -- Engulfing Heat
		408193, -- Convergent Eruption
		{405914, "TANK"}, -- Crushing Vulnerability
		{406783, "TANK"}, -- Shadowflame Burst
	}
end

function mod:OnBossEnable()
	-- Krozgoth
	self:Log("SPELL_AURA_APPLIED", "CorruptingShadowApplied", 401809)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CorruptingShadowApplied", 401809)
	self:Log("SPELL_AURA_REMOVED", "CorruptingShadowRemoved", 401809)
	self:Log("SPELL_CAST_START", "CoalescingVoid", 403459)
	self:Log("SPELL_CAST_START", "UmbralDetonation", 405016)
	self:Log("SPELL_AURA_APPLIED", "UmbralDetonationApplied", 405036)
	self:Log("SPELL_AURA_REMOVED", "UmbralDetonationRemoved", 405036)
	self:Log("SPELL_CAST_START", "ShadowsConvergence", 407640)
	-- self:Log("SPELL_CAST_START", "ShadowSpike", 403699)

	-- Moltannia
	self:Log("SPELL_AURA_APPLIED", "BlazingHeatApplied", 402617)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlazingHeatApplied", 402617)
	self:Log("SPELL_AURA_REMOVED", "BlazingHeatRemoved", 402617)
	self:Log("SPELL_CAST_START", "FieryMeteor", 404732)
	self:Log("SPELL_CAST_START", "MoltenEruption", 403101)
	self:Log("SPELL_CAST_START", "SwirlingFlame", 404896)
	-- self:Log("SPELL_CAST_START", "FlameSlash", 403203)

	-- Molgoth
	self:Log("SPELL_CAST_SUCCESS", "Stage2Trigger", 406730)
	self:Log("SPELL_AURA_APPLIED", "ShadowflameApplied", 405394)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShadowflameApplied", 405394)
	self:Log("SPELL_AURA_REMOVED", "ShadowflameRemoved", 405394)
	self:Log("SPELL_CAST_START", "GloomConflagration", 405437)
	self:Log("SPELL_CAST_START", "BlisteringTwilight", 405641)
	self:Log("SPELL_AURA_APPLIED", "BlisteringTwilightApplied", 405642)
	self:Log("SPELL_AURA_REMOVED", "BlisteringTwilightRemoved", 405642)
	self:Log("SPELL_CAST_START", "ConvergentEruption", 408193)
	self:Log("SPELL_CAST_SUCCESS", "CrushingVulnerability", 405914)
	self:Log("SPELL_AURA_APPLIED", "CrushingVulnerabilityApplied", 405914)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrushingVulnerabilityApplied", 405914)
	self:Log("SPELL_CAST_START", "ShadowflameBurst", 406783)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 405084, 405645) -- Lingering Umbra
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 405084, 405645)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 405084, 405645)
end

function mod:OnEngage()
	mod:SetStage(1)
	-- Krozgoth
	coalescingVoidCount = 1
	umbralDetonationCount = 1
	shadowsConvergenceCount = 1
	self:Bar(403459, 30, CL.count:format(self:SpellName(403459), coalescingVoidCount)) -- Coalescing Void
	self:Bar(405036, 19.5, CL.count:format(self:SpellName(405036), umbralDetonationCount)) -- Umbral Detonation
	self:Bar(407640, 23, CL.count:format(self:SpellName(407640), shadowsConvergenceCount)) -- Shadows Convergence

	-- Moltannia
	fieryMeteorCount = 1
	moltenEruptionCount = 1
	swirlingFlameCount = 1
	self:Bar(404732, 32.5, CL.count:format(self:SpellName(404732), fieryMeteorCount)) -- Fiery Meteor
	self:Bar(403101, 23.0, CL.count:format(self:SpellName(403101), moltenEruptionCount)) -- Molten Eruption
	self:Bar(404896, 9.5, CL.count:format(self:SpellName(404896), swirlingFlameCount)) -- Swirling Flame
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Krozgoth
function mod:CorruptingShadowApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount > 20 then -- start with 20+, update after PTR
			self:StackMessage(args.spellId, "blue", args.destName, amount, 20)
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:CorruptingShadowRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:CoalescingVoid(args)
	self:StopBar(CL.count:format(args.spellName, coalescingVoidCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, coalescingVoidCount))
	self:PlaySound(args.spellId, "alert")
	coalescingVoidCount = coalescingVoidCount + 1
	self:Bar(args.spellId, 22, CL.count:format(args.spellName, coalescingVoidCount))
end

do
	local count = 1
	function mod:UmbralDetonation(args)
		self:StopBar(CL.count:format(args.spellName, umbralDetonationCount))
		self:Message(405036, "yellow", CL.count:format(args.spellName, umbralDetonationCount))
		self:PlaySound(405036, "alert")
		umbralDetonationCount = umbralDetonationCount + 1
		self:Bar(405036, 22, CL.count:format(args.spellName, umbralDetonationCount))
		count = 1
	end


	function mod:UmbralDetonationApplied(args)
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 6)
		end
		count = count + 1
	end

	function mod:UmbralDetonationRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:ShadowsConvergence(args)
	self:StopBar(CL.count:format(args.spellName, shadowsConvergenceCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, shadowsConvergenceCount))
	self:PlaySound(args.spellId, "alert")
	shadowsConvergenceCount = shadowsConvergenceCount + 1
	self:Bar(args.spellId, 21, CL.count:format(args.spellName, shadowsConvergenceCount))
end

-- function mod:ShadowSpike(args)
-- 	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
-- 	if bossUnit and self:Tanking(bossUnit) then
-- 		self:Message(args.spellId, "purple")
-- 		self:PlaySound(args.spellId, "alarm")
-- 	end
-- end

-- Moltannia
function mod:BlazingHeatApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount > 20 then -- start with 20+, update after PTR
			self:StackMessage(args.spellId, "blue", args.destName, amount, 20)
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:BlazingHeatRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:FieryMeteor(args)
	self:StopBar(CL.count:format(args.spellName, fieryMeteorCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, fieryMeteorCount))
	self:PlaySound(args.spellId, "alert")
	fieryMeteorCount = fieryMeteorCount + 1
	self:Bar(args.spellId, 31.5, CL.count:format(args.spellName, fieryMeteorCount))
end

function mod:MoltenEruption(args)
	self:StopBar(CL.count:format(args.spellName, moltenEruptionCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, moltenEruptionCount))
	self:PlaySound(args.spellId, "alert")
	moltenEruptionCount = moltenEruptionCount + 1
	self:CDBar(args.spellId, 23.1, CL.count:format(args.spellName, moltenEruptionCount))
end

function mod:SwirlingFlame(args)
	self:StopBar(CL.count:format(args.spellName, swirlingFlameCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, swirlingFlameCount))
	self:PlaySound(args.spellId, "alert")
	swirlingFlameCount = swirlingFlameCount + 1
	self:CDBar(args.spellId, 21, CL.count:format(args.spellName, swirlingFlameCount))
end

-- function mod:FlameSlash(args)
-- 	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
-- 	if bossUnit and self:Tanking(bossUnit) then
-- 		self:Message(args.spellId, "purple")
-- 		self:PlaySound(args.spellId, "alarm")
-- 	end
-- end

-- Molgoth

do
	local prev = 0
	function mod:Stage2Trigger(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:StopBar(CL.count:format(self:SpellName(403459), coalescingVoidCount)) -- Coalescing Void
			self:StopBar(CL.count:format(self:SpellName(405036), umbralDetonationCount)) -- Umbral Detonation
			self:StopBar(CL.count:format(self:SpellName(407640), shadowsConvergenceCount)) -- Shadows Convergence
			self:StopBar(CL.count:format(self:SpellName(404732), fieryMeteorCount)) -- Fiery Meteor
			self:StopBar(CL.count:format(self:SpellName(403101), moltenEruptionCount)) -- Molten Eruption
			self:StopBar(CL.count:format(self:SpellName(404896), swirlingFlameCount)) -- Swirling Flame

			mod:SetStage(2)
			self:Message("stages", "cyan", CL.stage:format(2), false)
			self:PlaySound("stages", "long")
			gloomConflagrationCount = 1
			blisteringTwilightCount = 1
			convergentEruptionCount = 1
			shadowflameBurstCount = 1


			self:Bar(405914, 17.5)
			self:Bar(406783, 18.5, CL.count:format(self:SpellName(406783), shadowflameBurstCount))
			self:Bar(405642, 21.5, CL.count:format(self:SpellName(405642), blisteringTwilightCount))
			self:Bar(405437, 32.5, CL.count:format(self:SpellName(405437), gloomConflagrationCount))
			self:Bar(408193, 47.0, CL.count:format(self:SpellName(408193), convergentEruptionCount))
		end
	end
end

function mod:ShadowflameApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount > 20 then -- start with 20+, update after PTR
			self:StackMessage(args.spellId, "blue", args.destName, amount, 20)
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:ShadowflameRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:GloomConflagration(args)
	self:StopBar(CL.count:format(args.spellName, gloomConflagrationCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, gloomConflagrationCount))
	self:PlaySound(args.spellId, "alert")
	gloomConflagrationCount = gloomConflagrationCount + 1
	self:Bar(args.spellId, 40, CL.count:format(args.spellName, gloomConflagrationCount))
end

do
	local count = 1
	function mod:BlisteringTwilight(args)
		self:StopBar(CL.count:format(args.spellName, blisteringTwilightCount))
		self:Message(405642, "yellow", CL.count:format(args.spellName, blisteringTwilightCount))
		self:PlaySound(405642, "alert")
		blisteringTwilightCount = blisteringTwilightCount + 1
		self:Bar(405642, 40, CL.count:format(args.spellName, blisteringTwilightCount))
	end

	function mod:BlisteringTwilightApplied(args)
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 6)
		end
	end

	function mod:BlisteringTwilightRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:ConvergentEruption(args)
	self:StopBar(CL.count:format(args.spellName, convergentEruptionCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, convergentEruptionCount))
	self:PlaySound(args.spellId, "alert")
	convergentEruptionCount = convergentEruptionCount + 1
	self:Bar(args.spellId, 40, CL.count:format(args.spellName, convergentEruptionCount))
end

function mod:CrushingVulnerability(args)
	self:Bar(args.spellId, 35.5)
end

function mod:CrushingVulnerabilityApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
	if self:Tank() and not self:Me(args.destGUID) and not self:Tanking(self:UnitTokenFromGUID(args.sourceGUID)) then
		self:PlaySound(args.spellId, "warning")
	elseif self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:ShadowflameBurst(args)
	self:StopBar(CL.count:format(args.spellName, shadowflameBurstCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, shadowflameBurstCount))
	self:PlaySound(args.spellId, "alert")
	shadowflameBurstCount = shadowflameBurstCount + 1
	self:Bar(args.spellId, shadowflameBurstCount > 5 and 40 or 35.3, CL.count:format(args.spellName, shadowflameBurstCount))
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
