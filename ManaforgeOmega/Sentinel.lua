if not BigWigsLoader.isTestBuild then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Plexus Sentinel", 2810, 2684)
if not mod then return end
mod:RegisterEnableMob(233814) -- Plexus Sentinel XXX Confirm
mod:SetEncounterID(3129)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local manifestMatricesCount = 1
local obliterationArcanocannonCount = 1
local eradicationgSalvoCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

-- function mod:OnRegister()
-- 	self:SetSpellRename(1234567, "String") -- Spell (Rename)
-- end

function mod:GetOptions()
	return {
		"stages",
		-- 1218148, -- Phase Blink
		-- 1217649, -- Arcanomatrix Sieve
			1219223, -- Atomize
			1219248, -- Arcane Radiation
		-- 1227794, -- Static Lightning
		-- Stage One: Purge The Intruders
			1219450, -- Manifest Matrices
				-- 1218625, -- Displacement Matrix
					1219354, -- Potent Residue
			1219263, -- Obliteration Arcanocannon
			-- 1223364, -- Powered Automaton
				-- 1219687, -- Charged Lightning
			1219607, -- Eradicating Salvo
		-- Stage Two: The Sieve Awakens
			-- 1220489, -- Protocol: Purge
				1237084, -- Energy Cutter
				1233110, -- Purging Lightning
				-- 1219471, -- Expulsion Zone
	},{
		{
			tabName = CL.general,
			{"stages", 1219223, 1219248},
		},
		{
			tabName = CL.stage:format(1),
			{1219450, 1219354, 1219263, 1219607},
		},
		{
			tabName = CL.stage:format(2),
			{1237084, 1233110},
		},
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_DAMAGE", "AtomizeDamage", 1219223)
	-- Merge these into 1 damage tracker for potent residue and arcane radiation?
	self:Log("SPELL_AURA_APPLIED", "ArcaneRadiationDamage", 1219248)
	self:Log("SPELL_PERIODIC_DAMAGE", "ArcaneRadiationDamage", 1219248)
	self:Log("SPELL_PERIODIC_MISSED", "ArcaneRadiationDamage", 1219248)

	-- Stage One: Purge The Intruders
	self:Log("SPELL_CAST_START", "ManifestMatrices", 1219450)
	self:Log("SPELL_AURA_APPLIED", "PotentResidueDamage", 1219354)
	self:Log("SPELL_PERIODIC_DAMAGE", "PotentResidueDamage", 1219354)
	self:Log("SPELL_PERIODIC_MISSED", "PotentResidueDamage", 1219354)
	self:Log("SPELL_CAST_START", "ObliterationArcanocannon", 1219263)
	self:Log("SPELL_AURA_APPLIED", "ObliterationArcanocannonApplied", 1219263)
	self:Log("SPELL_AURA_APPLIED", "EradicatingSalvoApplied", 1219607)

	-- Stage Two: The Sieve Awakens
	self:Log("SPELL_CAST_START", "ProtocolPurge", 1220489)
	self:Log("SPELL_AURA_REMOVED", "ProtocolPurgeRemoved", 1220618) -- End of Stage 2
	self:Log("SPELL_AURA_APPLIED", "EnergyCutterApplied", 1237084)
	self:Log("SPELL_AURA_APPLIED", "PurgingLightningApplied", 1233110)
	self:Log("SPELL_AURA_APPLIED_DOSE", "PurgingLightningApplied", 1233110)
end

function mod:OnEngage()
	self:SetStage(1)

	manifestMatricesCount = 1
	obliterationArcanocannonCount = 1
	eradicationgSalvoCount = 1

	-- self:Bar(1219450, 30, CL.count:format(self:SpellName(1219450), manifestMatricesCount)) -- Manifest Matrices
	-- self:Bar(1219263, 30, CL.count:format(self:SpellName(1219263), obliterationArcanocannonCount)) -- Obliteration Arcanocannon
	-- self:Bar(1219607, 30, CL.count:format(self:SpellName(1219607), eradicationgSalvoCount)) -- Eradicating Salvo
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:AtomizeDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

do
	local prev = 0
	function mod:ArcaneRadiationDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

-- Stage One: Purge The Intruders
function mod:ManifestMatrices(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, manifestMatricesCount))
	self:PlaySound(args.spellId, "alert")
	manifestMatricesCount = manifestMatricesCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, manifestMatricesCount))
end

do
	local prev = 0
	function mod:PotentResidueDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

function mod:ObliterationArcanocannon(args)
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, obliterationArcanocannonCount))
	obliterationArcanocannonCount = obliterationArcanocannonCount + 1
	-- self:Bar(args.spellId, 30, CL.count:format(args.spellName, obliterationArcanocannonCount))
	-- Bar for healers until raid damage?
end

function mod:ObliterationArcanocannonApplied(args)
	if self:Tank() then -- raid has the bar + cast starting messages
		self:TargetMessage(args.spellId, "purple", args.destName)
		self:PlaySound(args.spellId, "warning") -- taunt / run away
	end
end

function mod:EradicatingSalvoApplied(args)
	self:TargetMessage(args.spellId, "orange", args.destName, CL.count:format(args.spellName, eradicationgSalvoCount))
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning") -- targetted
	else
		self:PlaySound(args.spellId, "alert") -- soak your missile?
	end
	eradicationgSalvoCount = eradicationgSalvoCount + 1
	-- self:Bar(args.spellId, 30, CL.count:format(args.spellName, eradicationgSalvoCount))
end

-- Stage Two: The Sieve Awakens
function mod:ProtocolPurge(args)
	self:SetStage(2)
	self:Message("stages", "green", CL.stage:format(2), false)
	self:PlaySound("stages", "long")

	self:StopBar(CL.count:format(self:SpellName(1219450), manifestMatricesCount)) -- Manifest Matrices
	self:StopBar(CL.count:format(self:SpellName(1219263), obliterationArcanocannonCount)) -- Obliteration Arcanocannon
	self:StopBar(CL.count:format(self:SpellName(1219607), eradicationgSalvoCount)) -- Eradicating Salvo
end

function mod:ProtocolPurgeRemoved(args)
	self:SetStage(1)
	self:Message("stages", "green", CL.stage:format(1), false)
	self:PlaySound("stages", "long")

	manifestMatricesCount = 1
	obliterationArcanocannonCount = 1
	eradicationgSalvoCount = 1

	-- self:Bar(1219450, 30, CL.count:format(self:SpellName(1219450), manifestMatricesCount)) -- Manifest Matrices
	-- self:Bar(1219263, 30, CL.count:format(self:SpellName(1219263), obliterationArcanocannonCount)) -- Obliteration Arcanocannon
	-- self:Bar(1219607, 30, CL.count:format(self:SpellName(1219607), eradicationgSalvoCount)) -- Eradicating Salvo
end

function mod:EnergyCutterApplied(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId)
		self:PersonalMessage(args.spellId)
	end
end

function mod:PurgingLightningApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "purple", args.destName, amount, 5)
		self:PlaySound(args.spellId, "info") -- increasing damage taken on next application
	end
end
