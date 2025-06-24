if not BigWigsLoader.isTestBuild then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Soulbinder Naazindhri", 2810, 2685)
if not mod then return end
mod:RegisterEnableMob(233816) -- Soulbinder Naazindhri XXX Confirm
mod:SetEncounterID(3130)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local soulCallingCount = 1
local essenceImplosionCount = 1
local soulfrayAnnihilationCount = 1
local mysticLashCount = 1
local arcaneExpulsionCount = 1
local soulfireConvergenceCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.voidblade_ambush = "Ambush" -- Short for Voidblade Ambush
	L.soulfray_annihilation = "Annihilation" -- Short for Soulfray Annihilation
	L.soulfire_convergence = "Convergence" -- Short for Soulfire Convergence
end

--------------------------------------------------------------------------------
-- Initialization
--

-- function mod:OnRegister()
-- 	self:SetSpellRename(1234567, "String") -- Spell (Rename)
-- end

function mod:GetOptions()
	return {
		1225582, -- Soul Calling
			-- 1239988, -- Soulweave Chrysalis
			-- Unbound Assassin
				-- Shadowguard Assassin
					{1227048, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Voidblade Ambush XXX Tooltip of debuff can't be used, no description? Might not be used.
			-- Unbound Mage
				1227052, -- Void Volley
			-- Unbound Phaseblade
				-- Shadowguard Phaseblade
					-- 1235576, -- Phase Blades XXX Timer on add needed?
		1227848, -- Essence Implosion
		{1227276, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Soulfray Annihilation
		{1241100, "TANK"}, -- Mystic Lash
		1223859, -- Arcane Expulsion
		{1225616, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Soulfire Convergence
			1226827, -- Soulrend Orb
		-- 1240754, -- Deathspindle Permanent?
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "SoulCalling", 1225582)

	self:Log("SPELL_AURA_APPLIED", "VoidbladeAmbushTargetApplied", 1227049)
	self:Log("SPELL_CAST_START", "VoidVolley", 1227052)
	self:Log("SPELL_AURA_APPLIED", "VoidVolleyApplied", 1227052)
	self:Log("SPELL_CAST_SUCCESS", "EssenceImplosion", 1227848)
	self:Log("SPELL_CAST_SUCCESS", "SoulfrayAnnihilation", 1227276)
	self:Log("SPELL_AURA_APPLIED", "SoulfrayAnnihilationApplied", 1227276)
	self:Log("SPELL_CAST_START", "MysticLash", 1241100)
	self:Log("SPELL_AURA_APPLIED", "MysticLashApplied", 1237607)
	self:Log("SPELL_CAST_START", "ArcaneExpulsion", 1223859)
	self:Log("SPELL_CAST_START", "SoulfireConvergence", 1225616)
	self:Log("SPELL_AURA_APPLIED", "SoulfireConvergenceApplied", 1225626)
	self:Log("SPELL_AURA_APPLIED", "SoulrendOrbApplied", 1226827)
end

function mod:OnEngage()
	soulCallingCount = 1
	essenceImplosionCount = 1
	soulfrayAnnihilationCount = 1
	mysticLashCount = 1
	arcaneExpulsionCount = 1
	soulfireConvergenceCount = 1

	-- self:Bar(1225582, 8.5, CL.count:format(self:SpellName(1225582), soulCallingCount)) -- Soul Calling
	-- self:Bar(1227848, 8.5, CL.count:format(self:SpellName(1227848), essenceImplosionCount)) -- Essence Implosion
	-- self:Bar(1227276, 8.5, CL.count:format(self:SpellName(1227276), soulfrayAnnihilationCount)) -- Soulfray Annihilation
	-- self:Bar(1241100, 8.5, CL.count:format(self:SpellName(1241100), mysticLashCount)) -- Mystic Lash
	-- self:Bar(1223859, 8.5, CL.count:format(self:SpellName(1223859), arcaneExpulsionCount)) -- Soul Calling
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SoulCalling(args)
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, soulCallingCount))
	self:PlaySound(args.spellId, "long") -- Unbound Souls/Binding Machines inc
	soulCallingCount = soulCallingCount + 1
	-- self:Bar(args.spellId, 8.5, CL.count:format(args.spellName, soulCallingCount))
end

function mod:VoidbladeAmbushTargetApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(1227048, nil, L.voidblade_ambush)
		self:PlaySound(1227048, "warning") -- position yourself
		self:Say(1227048, L.voidblade_ambush, nil, "Ambush")
		self:SayCountdown(1227048, 4)
	end
end

function mod:VoidVolley(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo and ready then -- kick
		self:Message(args.spellId, "orange")
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:VoidVolleyApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm") -- dot on you
	end
end

function mod:EssenceImplosion(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, essenceImplosionCount))
	self:PlaySound(args.spellId, "alert") -- raid damage dot
	essenceImplosionCount = essenceImplosionCount + 1
	-- self:Bar(args.spellId, 8.5, CL.count:format(args.spellName, essenceImplosionCount))
end

function mod:SoulfrayAnnihilation(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, soulfrayAnnihilationCount)) -- XXX TargetsMessage?
	-- self:PlaySound(args.spellId, "alert")
	soulfrayAnnihilationCount = soulfrayAnnihilationCount + 1
	-- self:Bar(args.spellId, 8.5, CL.count:format(args.spellName, soulfrayAnnihilationCount))
end

function mod:SoulfrayAnnihilationApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.soulfray_annihilation)
		self:PlaySound(args.spellId, "warning") -- move
		self:Say(args.spellId, L.soulfray_annihilation, nil, "Annihilation")
		self:SayCountdown(args.spellId, 6)
	end
end

function mod:MysticLash(args)
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, mysticLashCount))
	self:PlaySound(args.spellId, "alert") -- Current tank warning?
	mysticLashCount = mysticLashCount + 1
	-- self:Bar(args.spellId, 8.5, CL.count:format(args.spellName, mysticLashCount))
end

function mod:MysticLashApplied(args)
	local amount = args.amount or 1
	if amount % 2 == 1 then -- multiple stacks during cast?
		self:StackMessage(1241100, "purple", args.destName, args.amount, 4)
		if self:Me(args.destGUID) then
			self:PlaySound(1241100, "alarm")
		elseif self:Tank() and amount > 4 then
			self:PlaySound(1241100, "warning") -- taunt?
		end
	end
end

function mod:ArcaneExpulsion(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, arcaneExpulsionCount))
	self:PlaySound(args.spellId, "warning") -- knockback
	arcaneExpulsionCount = arcaneExpulsionCount + 1
	-- self:Bar(args.spellId, 8.5, CL.count:format(args.spellName, arcaneExpulsionCount))
end

function mod:SoulfireConvergence(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, soulfireConvergenceCount)) -- XXX TargetsMessage?
	soulfireConvergenceCount = soulfireConvergenceCount + 1
	-- self:Bar(args.spellId, 8.5, CL.count:format(args.spellName, soulfireConvergenceCount))
end
function mod:SoulfireConvergenceApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(1225616, nil, L.soulfire_convergence)
		self:PlaySound(1225616, "warning") -- move
		self:Say(1225616, L.soulfire_convergence, nil, "Convergence")
		self:SayCountdown(1225616, 3, 2)
	end
end

function mod:SoulrendOrbApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end
