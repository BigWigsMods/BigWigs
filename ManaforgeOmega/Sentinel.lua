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
local cleanseTheChamberCount = 1

--------------------------------------------------------------------------------
-- Timers
--

local timersNormal = {
	[1] = {
		[1219450] = { 12.8, 34.0, 0 }, -- Manifest Matrices
		[1219263] = { 21.7, 32.8, 0 }, -- Obliteration Arcanocannon
		[1219607] = { 30.8, 0 }, -- Eradicating Salvo
	},
	[2] = {
		[1219450] = { 7.2, 36.0, 35.2, 0 }, -- Manifest Matrices
		[1219263] = { 18.1, 34.0, 34.0, 0 }, -- Obliteration Arcanocannon
		[1219607] = { 27.8, 35.2, 0 }, -- Eradicating Salvo
	},
	[3] = {
		[1219450] = { 8.0, 35.2, 35.2, 0 }, -- Manifest Matrices
		[1219263] = { 18.1, 33.9, 34.0, 0 }, -- Obliteration Arcanocannon
		[1219607] = { 27.9, 35.2, 0 }, -- Eradicating Salvo
	},
	[4] = {
		[1219450] = { 8.9, 35.2, 35.2, 35.2, 36.5, 36.5, 36.5 }, -- Manifest Matrices
		[1219263] = { 19.0, 34.0, 33.9, 34.0, 34.7, 34.5 }, -- Obliteration Arcanocannon
		[1219607] = { 28.8, 35.3, 35.1, 38.9, 35.3, 35.3, 35.3 }, -- Eradicating Salvo
		[1234733] = { 93.1, 13.3, 9.3, 11.3, 7.3, 10.9, 7.3, 9.7, 7.3, 10.9 }, -- Cleanse the Chamber
	},
}

local timersHeroic = {
	[1] = {
		[1219450] = { 13.0, 33.1, 0 }, -- Manifest Matrices
		[1219263] = { 22.2, 33.0, 0 }, -- Obliteration Arcanocannon
		[1219607] = { 30.8, 0 }, -- Eradicating Salvo
	},
	[2] = {
		[1219450] = { 8.2, 35.3, 35.3, 0 }, -- Manifest Matrices
		[1219263] = { 18.7, 33.3, 33.3, 0 }, -- Obliteration Arcanocannon
		[1219607] = { 28.5, 34.7, 0 }, -- Eradicating Salvo
	},
	[3] = {
		[1219450] = { 8.2, 35.3, 35.3, 0 }, -- Manifest Matrices
		[1219263] = { 17.7, 34.0, 34.0, 0 }, -- Obliteration Arcanocannon
		[1219607] = { 27.7, 34.0, 0 }, -- Eradicating Salvo
	},
	[4] = {
		[1219450] = { 8.2, 34.0, 34.0, 38.9, 36.5, 36.5, 36.5 }, -- Manifest Matrices
		[1219263] = { 28.3, 34.0, 34.0, 36.5, 36.5, 36.5, 36.5 }, -- Obliteration Arcanocannon
		[1219607] = { 28.3, 35.2, 34.0, 36.5, 36.5, 36.5, 36.5 }, -- Eradicating Salvo
		[1234733] = { 63.0, 12.2, 8.2, 5.3, 9.8, 12.1, 8.2, 5.2, 9.7, 11.0, 6.1, 7.0, 5.2, 9.7, 11.0, 6.1, 6.9, 10.1, 10.9, 6.1 }, -- Cleanse the Chamber
	},
}

local wallArriveTimer = { 26, 18, 12 } -- Time for the wall to reach the raid
local timersMythic = {
	[1] = {
		[1219450] = { 8.7, 28, 0 }, -- Manifest Matrices
		[1219263] = { 22.0, 30.5, 0 }, -- Obliteration Arcanocannon
		[1219607] = { 40.4, 0 }, -- Eradicating Salvo
		[1234733] = { 0.5, 0 }, -- Cleanse the Chamber
	},
	[2] = {
		[1219450] = { 4.7, 23.1, 23.1, 26.7, 0 }, -- Manifest Matrices
		[1219263] = { 13, 28.0, 30.4, 0 }, -- Obliteration Arcanocannon
		[1219607] = { 19.3, 34.9, 32.0, 0 }, -- Eradicating Salvo
		[1234733] = { 29.5 , 0 }, -- Cleanse the Chamber
	},
	[3] = {
		[1219450] = { 5.5, 26.8, 26.8, 23.1, 0 }, -- Manifest Matrices
		[1219263] = { 13.1, 28.0, 29.2, 0 }, -- Obliteration Arcanocannon
		[1219607] = { 20.2, 31.6, 33.6, 0 }, -- Eradicating Salvo
		[1234733] = { 27.5, 0 }, -- Cleanse the Chamber
	},
	[4] = {
		[1219450] = { 5.2, 23.1, 23.1, 30.4, 28.0, 24.3, 24.3 }, -- Manifest Matrices
		[1219263] = { 14.1, 29.2, 23.2, 32.0, 32.0, 32.0, 32.0, 32.0 }, -- Obliteration Arcanocannon
		[1219607] = { 21.1, 34.0, 34.0, 34.0, 38.2, 38.2, 38.2, 38.2 }, -- Eradicating Salvo
		[1234733] = { 62.3, 0 }, -- 7 after 1st all the time
	},
}

local timers = mod:Mythic() and timersMythic or mod:Heroic() and timersHeroic or timersNormal
local function getNextTimer(spellId, count)
	if timers[protocolPurgeCount] then
		return timers[protocolPurgeCount][spellId][count]
	end
end

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.cleanse_the_chamber = "Wall"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:SetSpellRename(1219450, CL.pools) -- Manifest Matrices (Pools)
	self:SetSpellRename(1218625, CL.stunned) -- Displacement Matrix (Stunned)
	self:SetSpellRename(1219263, CL.tank_bomb) -- Obliteration Arcanocannon (Tank Bomb)
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
				1218668, -- Energy Cutter
				1233110, -- Purging Lightning
				1219471, -- Expulsion Zone
		-- Mythic
		1234733, -- Cleanse the Chamber
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
			{1218668, 1233110, 1219471},
		},
	},{
		[1219450] = CL.pools, -- Manifest Matrices (Pools)
		[1218625] = CL.stunned, -- Displacement Matrix (Stunned)
		[1219263] = CL.tank_bomb, -- Obliteration Arcanocannon (Tank Bomb)
		[1219607] = CL.soak, -- Eradicating Salvo (Soak)
		[1234733] = L.cleanse_the_chamber, -- Cleanse the Chamber
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "PhaseBlinkApplied", 1220679)
	self:Log("SPELL_CAST_START", "CleanseTheChamber", 1234733)
	self:Log("SPELL_DAMAGE", "AvoidableDamage", 1219223, 1227794, 1219471, 1218668) -- Atomize, Arcane Lightning, Expulsion Zone, Energy Cutter
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
	self:Log("SPELL_AURA_APPLIED_DOSE", "PurgingLightningApplied", 1233110)

	timers = self:Mythic() and timersMythic or self:Heroic() and timersHeroic or timersNormal
end

function mod:OnEngage()
	self:SetStage(1)

	manifestMatricesCount = 1
	obliterationArcanocannonCount = 1
	eradicationgSalvoCount = 1
	protocolPurgeCount = 1
	cleanseTheChamberCount = 1

	-- Timers from normal ptr
	self:Bar(1219450, getNextTimer(1219450, 1), CL.count:format(CL.pools, manifestMatricesCount)) -- Manifest Matrices
	self:Bar(1219263, getNextTimer(1219263, 1), CL.count:format(CL.tank_bomb, obliterationArcanocannonCount)) -- Obliteration Arcanocannon
	self:Bar(1219607, getNextTimer(1219607, 1), CL.count:format(CL.soak, eradicationgSalvoCount)) -- Eradicating Salvo
	if self:Mythic() then
		self:Bar(1234733, getNextTimer(1234733, 1) + wallArriveTimer[cleanseTheChamberCount], CL.count:format(L.cleanse_the_chamber, cleanseTheChamberCount)) -- Cleanse the Chamber
	end
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
	self:Message(args.spellId, "cyan", CL.incoming:format(L.cleanse_the_chamber))
	if self:Mythic() and cleanseTheChamberCount < 4 then
		local cd = getNextTimer(1234733, 1) or 0
		local wallArrivalEta = wallArriveTimer[cleanseTheChamberCount] or 0
		self:Bar(1234733, {wallArrivalEta, cd + wallArrivalEta}, CL.count:format(L.cleanse_the_chamber, cleanseTheChamberCount)) -- Cleanse the Chamber
	else
		self:StopBar(CL.count:format(L.cleanse_the_chamber, cleanseTheChamberCount-1))
		self:StopBar(CL.count:format(L.cleanse_the_chamber, cleanseTheChamberCount))
		self:CDBar(args.spellId, 7, CL.count:format(L.cleanse_the_chamber, cleanseTheChamberCount))
	end
	cleanseTheChamberCount = cleanseTheChamberCount + 1
end

do
	local prev = 0
	function mod:AvoidableDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PersonalMessage(args.spellId, "underyou")
			self:PlaySound(args.spellId, "underyou", nil, args.destName)
		end
	end
end

do
	local prev = 0
	function mod:ArcaneRadiationDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PersonalMessage(args.spellId, "underyou")
			self:PlaySound(args.spellId, "underyou", nil, args.destName)
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
		self:SayCountdown(1219450, 6)
		self:PlaySound(1219450, "warning", nil, args.destName) -- spread out
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
			self:PersonalMessage(args.spellId, "underyou")
			self:PlaySound(args.spellId, "underyou", nil, args.destName)
		end
	end
end

function mod:ObliterationArcanocannon(args)
	self:StopBar(CL.count:format(CL.tank_bomb, obliterationArcanocannonCount))
	obliterationArcanocannonCount = obliterationArcanocannonCount + 1
	local cd = getNextTimer(args.spellId, obliterationArcanocannonCount)
	self:Bar(args.spellId, cd, CL.count:format(CL.tank_bomb, obliterationArcanocannonCount))
end

function mod:ObliterationArcanocannonApplied(args)
	self:TargetMessage(1219263, "purple", args.destName, CL.count:format(CL.tank_bomb, obliterationArcanocannonCount - 1))
	if self:Me(args.destGUID) then
		self:Say(1219263, CL.tank_bomb, nil, "Tank Bomb")
		self:SayCountdown(1219263, 6)
	end
	self:CastBar(1219263, 6, CL.count:format(CL.tank_bomb, obliterationArcanocannonCount - 1))
	if self:Me(args.destGUID) or self:Tank() then
		self:PlaySound(1219263, "warning", nil, args.destName) -- taunt / run away
	else
		self:PlaySound(1219263, "alarm") -- raid damage inc (falloff bomb damage)
	end
end

function mod:EradicatingSalvoApplied(args)
	self:StopBar(CL.count:format(CL.soak, eradicationgSalvoCount))
	self:TargetMessage(args.spellId, "orange", args.destName, CL.count:format(CL.soak, eradicationgSalvoCount))
	eradicationgSalvoCount = eradicationgSalvoCount + 1
	local cd = getNextTimer(args.spellId, eradicationgSalvoCount)
	self:Bar(args.spellId, cd, CL.count:format(CL.soak, eradicationgSalvoCount))
	if self:Me(args.destGUID) then
		self:Yell(args.spellId, CL.soak, nil, "Soak")
		self:YellCountdown(args.spellId, 5)
		self:PlaySound(args.spellId, "warning", nil, args.destName) -- targetted
	else
		self:PlaySound(args.spellId, "alert") -- soak your missile?
	end
end

-- Stage Two: The Sieve Awakens
function mod:ProtocolPurge()
	self:StopBar(CL.count:format(CL.pools, manifestMatricesCount)) -- Manifest Matrices
	self:StopBar(CL.count:format(CL.tank_bomb, obliterationArcanocannonCount)) -- Obliteration Arcanocannon
	self:StopBar(CL.count:format(CL.soak, eradicationgSalvoCount)) -- Eradicating Salvo
	self:StopBar(CL.count:format(CL.stage:format(2), protocolPurgeCount)) -- Stage 2
	self:StopBar(CL.count:format(self:SpellName(1234733), protocolPurgeCount)) -- Cleanse the Chamber

	self:SetStage(2)
	self:Message("stages", "green", CL.stage:format(2), false)
	self:PlaySound("stages", "long")
	protocolPurgeCount = protocolPurgeCount + 1
end

function mod:ProtocolPurgeRemoved()
	manifestMatricesCount = 1
	obliterationArcanocannonCount = 1
	eradicationgSalvoCount = 1
	self:SetStage(1)

	self:CDBar(1219450, getNextTimer(1219450, 1), CL.count:format(CL.pools, manifestMatricesCount)) -- Manifest Matrices
	self:CDBar(1219263, getNextTimer(1219263, 1), CL.count:format(CL.tank_bomb, obliterationArcanocannonCount)) -- Obliteration Arcanocannon
	self:CDBar(1219607, getNextTimer(1219607, 1), CL.count:format(CL.soak, eradicationgSalvoCount)) -- Eradicating Salvo
	if self:Mythic() then
		self:Bar(1234733, getNextTimer(1234733, 1) + (wallArriveTimer[cleanseTheChamberCount] or 0), CL.count:format(L.cleanse_the_chamber, cleanseTheChamberCount)) -- Cleanse the Chamber
	end
	if protocolPurgeCount == 4 then -- next is cleans the chamber
		self:Bar("stages", 94.0, CL.count:format(self:SpellName(1234733), protocolPurgeCount), 1234733) -- Cleanse the Chamber
	else
		self:Bar("stages", 94.0, CL.count:format(CL.stage:format(2), protocolPurgeCount), 1220489) -- Stage 2 (Protocol: Purge)
	end

	self:Message("stages", "green", CL.stage:format(1), false)
	self:PlaySound("stages", "long")
end

function mod:PurgingLightningApplied(args)
	local amount = args.amount or 1
	if amount % 5 == 0 then
		self:StackMessage(args.spellId, "purple", args.destName, amount, 25)
		self:PlaySound(args.spellId, "info")
	end
end
