if not BigWigsLoader.isNext then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Plexus Sentinel", 2810, 2684)
if not mod then return end
mod:RegisterEnableMob(233814) -- Plexus Sentinel
mod:SetEncounterID(3129)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local manifestMatricesCount = 1
local obliterationArcanocannonCount = 1
local eradicationgSalvoCount = 1
local protocolPurgeCount = 1

--------------------------------------------------------------------------------
-- Timers
--

local timersOther = {
	[1] = {
		[1219450] = {11.1, 33.1, 0}, -- Manifest Matrices
		[1219263] = {20.9, 33.0, 0}, -- Obliteration Arcanocannon
		[1219607] = {30.8, 0}, -- Eradicating Salvo
	},
	[2] = {
		[1219450] = {6.2, 35.3, 35.3, 0}, -- Manifest Matrices
		[1219263] = {28.3, 34.0, 34.0, 0}, -- Obliteration Arcanocannon
		[1219607] = {28.3, 34.0, 0}, -- Eradicating Salvo
	},
	[3] = {
		[1219450] = {6.2, 35.3, 35.3, 0}, -- Manifest Matrices
		[1219263] = {28.3, 34.0, 34.0, 0}, -- Obliteration Arcanocannon
		[1219607] = {28.3, 34.0, 0}, -- Eradicating Salvo
	},
	[4] = {
		[1219450] = {6.2, 34.0, 34.0, 38.9, 36.5, 36.5, 36.5}, -- Manifest Matrices
		[1219263] = {28.3, 34.0, 34.0, 36.5, 36.5, 36.5, 36.5}, -- Obliteration Arcanocannon
		[1219607] = {28.3, 35.2, 34.0, 36.5, 36.5, 36.5, 36.5}, -- Eradicating Salvo
	},
}

local timersMythic = {
	[1] = {
		[1219450] = {9.5, 28.5, 0}, -- Manifest Matrices
		[1219263] = {21.9, 30.8, 0}, -- Obliteration Arcanocannon
		[1219607] = {41.3, 0}, -- Eradicating Salvo
	},
	[2] = {
		[1219450] = {5.5, 26.5, 27, 23.2, 0}, -- Manifest Matrices
		[1219263] = {13, 28.1, 28.1, 0}, -- Obliteration Arcanocannon
		[1219607] = {21, 31.9, 33.8, 0}, -- Eradicating Salvo
	},
	[3] = {
		[1219450] = {5.5, 35.3, 35.3, 0}, -- Manifest Matrices
		[1219263] = {13, 28.1, 28.1, 0}, -- Obliteration Arcanocannon
		[1219607] = {21, 31.9, 33.8, 0}, -- Eradicating Salvo
	},
	[4] = {
		[1219450] = {5.5, 23.1, 23.1, 32.0, 32.0, 32.0, 32.0, 32.0}, -- Manifest Matrices
		[1219263] = {13, 29.2, 29.2, 32.0, 32.0, 32.0, 32.0, 32.0}, -- Obliteration Arcanocannon
		[1219607] = {21, 33.7, 31.6, 38.2, 38.2, 38.2, 38.2, 38.2}, -- Eradicating Salvo
	},
}

local timers = mod:Mythic() and timersMythic or timersOther
local function getNextTimer(spellId, count)
	if timers[protocolPurgeCount] then
		return timers[protocolPurgeCount][spellId][count]
	end
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:SetSpellRename(1219450, CL.pools) -- Manifest Matrices (Pools)
	self:SetSpellRename(1218625, CL.stunned) -- Displacement Matrix (Stunned)
	self:SetSpellRename(1219263, CL.bomb) -- Obliteration Arcanocannon (Bomb)
	self:SetSpellRename(1219607, CL.soak) -- Eradicating Salvo (Soak)
end

function mod:GetOptions()
	return {
		"stages",
		1220679, -- Phase Blink
			1219223, -- Atomize
			1219248, -- Arcane Radiation
		1227794, -- Arcane Lightning
		-- Stage One: Purge The Intruders
			{1219607, "SAY", "SAY_COUNTDOWN"}, -- Eradicating Salvo
			{1219450, "SAY_COUNTDOWN"}, -- Manifest Matrices
				1218625, -- Displacement Matrix
					1219354, -- Potent Residue
			{1219263, "CASTBAR", "SAY", "SAY_COUNTDOWN"}, -- Obliteration Arcanocannon
		-- Stage Two: The Sieve Awakens
				1237084, -- Energy Cutter
				1233110, -- Purging Lightning
				1219471, -- Expulsion Zone
	},{
		{
			tabName = CL.general,
			{"stages", 1220679, 1219223, 1219248, 1227794},
		},
		{
			tabName = CL.stage:format(1),
			{1219607, 1219450, 1218625, 1219354, 1219263},
		},
		{
			tabName = CL.stage:format(2),
			{1237084, 1233110, 1219471},
		},
	},{
		[1219450] = CL.pools, -- Manifest Matrices (Pools)
		[1218625] = CL.stunned, -- Displacement Matrix (Stunned)
		[1219263] = CL.bomb, -- Obliteration Arcanocannon (Bomb)
		[1219607] = CL.soak, -- Eradicating Salvo (Soak)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "PhaseBlinkApplied", 1220679)
	self:Log("SPELL_CAST_START", "CleanseTheChamber", 1234733)
	self:Log("SPELL_DAMAGE", "AvoidableDamage", 1219223, 1227794, 1219471) -- Atomize, Arcane Lightning, Expulsion Zone
	self:Log("SPELL_AURA_APPLIED", "ArcaneRadiationDamage", 1219248)
	self:Log("SPELL_PERIODIC_DAMAGE", "ArcaneRadiationDamage", 1219248)
	self:Log("SPELL_PERIODIC_MISSED", "ArcaneRadiationDamage", 1219248)

	-- Stage One: Purge The Intruders
	self:Log("SPELL_CAST_SUCCESS", "ManifestMatrices", 1219450)
	self:Log("SPELL_AURA_APPLIED", "ManifestMatricesApplied", 1219459)
	self:Log("SPELL_AURA_APPLIED", "DisplacementMatrixApplied", 1218625)
	self:Log("SPELL_AURA_APPLIED", "PotentResidueDamage", 1219354)
	self:Log("SPELL_PERIODIC_DAMAGE", "PotentResidueDamage", 1219354)
	self:Log("SPELL_PERIODIC_MISSED", "PotentResidueDamage", 1219354)
	self:Log("SPELL_CAST_START", "ObliterationArcanocannon", 1219263)
	self:Log("SPELL_AURA_APPLIED", "ObliterationArcanocannonApplied", 1219439)
	self:Log("SPELL_AURA_APPLIED", "EradicatingSalvoApplied", 1219607)

	-- Stage Two: The Sieve Awakens
	self:Log("SPELL_CAST_START", "ProtocolPurge", 1220489, 1220553, 1220555)
	self:Log("SPELL_AURA_REMOVED", "ProtocolPurgeRemoved", 1220618, 1220981, 1220982) -- End of Stage 2
	self:Log("SPELL_AURA_APPLIED", "EnergyCutterApplied", 1237084)
	self:Log("SPELL_AURA_APPLIED_DOSE", "PurgingLightningApplied", 1233110)

	timers = self:Mythic() and timersMythic or timersOther
end

function mod:OnEngage()
	self:SetStage(1)

	manifestMatricesCount = 1
	obliterationArcanocannonCount = 1
	eradicationgSalvoCount = 1
	protocolPurgeCount = 1

	-- Timers from normal ptr
	self:Bar(1219450, getNextTimer(1219450, 1), CL.count:format(CL.pools, manifestMatricesCount)) -- Manifest Matrices
	self:Bar(1219263, getNextTimer(1219263, 1), CL.count:format(CL.bomb, obliterationArcanocannonCount)) -- Obliteration Arcanocannon
	self:Bar(1219607, getNextTimer(1219607, 1), CL.count:format(CL.soak, eradicationgSalvoCount)) -- Eradicating Salvo
	self:Bar("stages", 61, CL.count:format(CL.stage:format(2), protocolPurgeCount), 1220489) -- Stage 2 (Protocol: Purge)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:PhaseBlinkApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info", nil, args.destName) -- buffed
	end
end

function mod:CleanseTheChamber(args)
	self:Message("stages", "yellow", args.spellName, args.spellId) -- enrage started
	self:PlaySound("stages", "long")
end

do
	local prev = 0
	function mod:AvoidableDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou", nil, args.destName)
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

do
	local prev = 0
	function mod:ArcaneRadiationDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou", nil, args.destName)
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

-- Stage One: Purge The Intruders
function mod:ManifestMatrices(args)
	self:StopBar(CL.count:format(CL.pools, manifestMatricesCount))
	self:Message(args.spellId, "yellow", CL.count:format(CL.pools, manifestMatricesCount))
	manifestMatricesCount = manifestMatricesCount + 1
	local cd = getNextTimer(args.spellId, manifestMatricesCount)
	self:Bar(args.spellId, cd, CL.count:format(CL.pools, manifestMatricesCount))
end


function mod:ManifestMatricesApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(1219450, nil, CL.pool)
		self:PlaySound(1219450, "warning", nil, args.destName) -- spread out
		self:SayCountdown(1219450, 6)
	end
end

function mod:DisplacementMatrixApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.stunned)
		self:PlaySound(args.spellId, "warning", nil, args.destName) -- stunned
	end
end

do
	local prev = 0
	function mod:PotentResidueDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou", nil, args.destName)
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

function mod:ObliterationArcanocannon(args)
	self:StopBar(CL.count:format(CL.bomb, obliterationArcanocannonCount))
	obliterationArcanocannonCount = obliterationArcanocannonCount + 1
	local cd = getNextTimer(args.spellId, obliterationArcanocannonCount)
	self:Bar(args.spellId, cd, CL.count:format(CL.bomb, obliterationArcanocannonCount))
end

function mod:ObliterationArcanocannonApplied(args)
	self:TargetMessage(1219263, "purple", args.destName, CL.count:format(CL.bomb, obliterationArcanocannonCount - 1))
	if self:Me(args.destGUID) then
		self:Say(1219263, CL.bomb, nil, "Bomb")
		self:SayCountdown(1219263, 6)
	end
	if self:Me(args.destGUID) or self:Tank() then
		self:PlaySound(1219263, "warning", nil, args.destName) -- taunt / run away
	else
		self:PlaySound(1219263, "alarm") -- raid damage inc (falloff bomb damage)
	end
	self:CastBar(1219263, 6, CL.count:format(CL.bomb, obliterationArcanocannonCount - 1))
end

function mod:EradicatingSalvoApplied(args)
	self:StopBar(CL.count:format(CL.soak, eradicationgSalvoCount))
	self:TargetMessage(args.spellId, "orange", args.destName, CL.count:format(CL.soak, eradicationgSalvoCount))
	if self:Me(args.destGUID) then
		self:Say(args.spellId, CL.soak, nil, "Soak")
		self:SayCountdown(args.spellId, 5)
		self:PlaySound(args.spellId, "warning", nil, args.destName) -- targetted
	else
		self:PlaySound(args.spellId, "alert") -- soak your missile?
	end
	eradicationgSalvoCount = eradicationgSalvoCount + 1
	local cd = getNextTimer(args.spellId, eradicationgSalvoCount)
	self:Bar(args.spellId, cd, CL.count:format(CL.soak, eradicationgSalvoCount))
end

-- Stage Two: The Sieve Awakens
function mod:ProtocolPurge()
	self:StopBar(CL.count:format(CL.pools, manifestMatricesCount)) -- Manifest Matrices
	self:StopBar(CL.count:format(CL.bomb, obliterationArcanocannonCount)) -- Obliteration Arcanocannon
	self:StopBar(CL.count:format(CL.soak, eradicationgSalvoCount)) -- Eradicating Salvo
	self:StopBar(CL.count:format(CL.stage:format(2), protocolPurgeCount)) -- Stage 2
	self:StopBar(CL.count:format(self:SpellName(1234733), protocolPurgeCount)) -- Cleanse the Chamber

	self:SetStage(2)
	self:Message("stages", "green", CL.stage:format(2), false)
	self:PlaySound("stages", "long")
	protocolPurgeCount = protocolPurgeCount + 1
end

function mod:ProtocolPurgeRemoved()
	self:SetStage(1)
	self:Message("stages", "green", CL.stage:format(1), false)
	self:PlaySound("stages", "long")

	manifestMatricesCount = 1
	obliterationArcanocannonCount = 1
	eradicationgSalvoCount = 1

	self:CDBar(1219450, getNextTimer(1219450, 1), CL.count:format(CL.pools, manifestMatricesCount)) -- Manifest Matrices
	self:CDBar(1219263, getNextTimer(1219263, 1), CL.count:format(CL.bomb, obliterationArcanocannonCount)) -- Obliteration Arcanocannon
	self:CDBar(1219607, getNextTimer(1219607, 1), CL.count:format(CL.soak, eradicationgSalvoCount)) -- Eradicating Salvo
	if protocolPurgeCount == 4 then -- next is cleans the chamber
		self:Bar("stages", 94.0, CL.count:format(self:SpellName(1234733), protocolPurgeCount), 1234733) -- Cleanse the Chamber
	else
		self:Bar("stages", 94.0, CL.count:format(CL.stage:format(2), protocolPurgeCount), 1220489) -- Stage 2 (Protocol: Purge)
	end
end

function mod:EnergyCutterApplied(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "underyou", nil, args.destName)
		self:PersonalMessage(args.spellId)
	end
end

function mod:PurgingLightningApplied(args)
	local amount = args.amount or 1
	if amount % 5 == 0 or amount > 25 then
		self:StackMessage(args.spellId, "purple", args.destName, amount, 25)
		self:PlaySound(args.spellId, amount > 25 and "alarm" or "info") -- increasing damage taken on next application
	end
end
