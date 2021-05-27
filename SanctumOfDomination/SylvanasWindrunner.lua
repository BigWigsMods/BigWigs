--------------------------------------------------------------------------------
-- Module Declaration
--
if not IsTestBuild() then return end
local mod, CL = BigWigs:NewBoss("Sylvanas Windrunner", 2450, 2441)
if not mod then return end
mod:RegisterEnableMob(179687) -- Sylvanas Windrunne
mod:SetEncounterID(2435)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local windrunnerCount = 1
local dominationChainsCount = 1
local veilofDarknessCount = 1
local wailingArrowCount = 1
local riveCount = 1
local bansheeWailCount = 1
local ruinCount = 1
local hauntingWaveCount = 1
local bansheesBaneCount = 1
local bansheeScreamCount = 1
local razeCount = 1
local bansheesFuryCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.chains = "Chains" -- Short for Domination Chains
	L.chain = "Chain" -- Single Domination Chain
	L.darkness = "Darkness" -- Short for Veil of Darkness
	L.arrow = "Arrow" -- Short for Wailing Arrow
	L.wave = "Wave" -- Short for Haunting Wave
	L.dread = "Dread" -- Short for Crushing Dread
	L.orbs = "Orbs" -- Dark Communion
	L.curse = "Curse" -- Short for Curse of Lethargy
	L.pools = "Pools" -- Banshee's Bane
	L.scream = "Scream" -- Banshee Scream
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		-- Stage One: A Cycle of Hatred
		347504, -- Windrunner
		347928, -- Withering Fire
		347807, -- Barbed Arrow
		348627, -- Desecrating Shot
		347670, -- Shadow Dagger
		{349458, "ME_ONLY_EMPHASIZE"}, -- Domination Chains
		347704, -- Veil of Darkness
		{347609, "SAY", "SAY_COUNTDOWN"}, -- Wailing Arrow
		{352650, "TANK"}, -- Ranger's Heartseeker
		{347607, "TANK"}, -- Banshee's Mark
		-- Intermission: A Monument to our Suffering
		348145, -- Rive
		348109, -- Banshee Wail
		-- Stage Two: The Banshee Queen
		355540, -- Ruin
		351869, -- Haunting Wave
		350865, -- Accursed Might
		351075, -- Unstoppable Force
		351109, -- Enflame
		351092, -- Destabilize
		{351179, "TANK"}, -- Lashing Strike
		351180, -- Lashing Wound
		351117, -- Crushing Dread
		356021, -- Dark Communion
		351939, -- Curse of Lethargy
		{351672, "TANK"}, -- Fury
		-- Stage Three: The Freedom of Choice
		353929, -- Banshee's Bane
		353972, -- Bane Arrows
		{353965, "TANK"}, -- Banshee's Heartseeker
		354068, -- Banshee's Fury
		{357720, "SAY"}, -- Banshee Scream
		354147, -- Raze
	},{
		["stages"] = "general",
		[347504] = -23057, -- Stage One: A Cycle of Hatred
		[348145] = -22891, -- Intermission: A Monument to our Suffering
		[355540] = -23067, -- Stage Two: The Banshee Queen
		[353929] = -22890, -- Stage Three: The Freedom of Choice
	},{
		[349458] = L.chains, -- Domination Chains (Chains)
		[347704] = L.darkness, -- Veil of Darkness (Darkness)
		[347609] = L.arrow, -- Wailing Arrow (Arrow)
		[351117] = L.dread, -- Crushing Dread (Dread)
		[356021] = L.orbs, -- Dark Communion
		[351939] = L.curse, -- Curse of Lethargy (Curse)
		[353929] = L.pools, -- Banshee's Bane (Pools)
		[357720] = L.scream, -- Banshee Scream
	}
end

function mod:OnBossEnable()
	-- Stage One: A Cycle of Hatred
	self:Log("SPELL_AURA_APPLIED", "Windrunner", 347504)
	self:Log("SPELL_CAST_SUCCESS", "WitheringFire", 347928)
	self:Log("SPELL_AURA_APPLIED", "BarbedArrowApplied", 347807)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BarbedArrowApplied", 347807)
	self:Log("SPELL_CAST_SUCCESS", "DesecratingShot", 348627)
	self:Log("SPELL_CAST_SUCCESS", "ShadowDagger", 347670)
	self:Log("SPELL_AURA_APPLIED", "ShadowDaggerApplied", 347670)
	self:Log("SPELL_CAST_SUCCESS", "DominationChains", 349458)
	self:Log("SPELL_AURA_APPLIED", "DominationChainsApplied", 349458)
	self:Log("SPELL_CAST_START", "VeilOfDarkness", 354142, 347741) -- 1s & 3s cast times
	self:Log("SPELL_AURA_APPLIED", "VeilOfDarknessApplied", 347704)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VeilOfDarknessApplied", 347704)
	self:Log("SPELL_CAST_START", "WailingArrow", 347609)
	self:Log("SPELL_AURA_APPLIED", "WailingArrowApplied", 347609)
	self:Log("SPELL_AURA_REMOVED", "WailingArrowRemoved", 347609)
	self:Log("SPELL_AURA_APPLIED", "RangersHeartseekerApplied", 352650)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RangersHeartseekerApplied", 352650)
	self:Log("SPELL_AURA_APPLIED", "BansheesMarkApplied", 347607)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BansheesMarkApplied", 347607)

	-- Intermission: A Monument to our Suffering
	self:Log("SPELL_AURA_APPLIED", "BansheeShroudApplied", 350857)
	self:Log("SPELL_CAST_SUCCESS", "Rive", 348145)
	self:Log("SPELL_CAST_SUCCESS", "BansheeWail", 348109)

	-- Stage Two: The Banshee Queen
	self:Log("SPELL_AURA_APPLIED", "BansheeFormApplied", 348146)
	self:Log("SPELL_CAST_START", "Ruin", 355540)
	self:Log("SPELL_CAST_SUCCESS", "HauntingWave", 351869)
	self:Log("SPELL_CAST_START", "AccursedMight", 350865)
	self:Log("SPELL_CAST_START", "UnstoppableForce", 351075)
	self:Log("SPELL_CAST_START", "Enflame", 351109)
	self:Log("SPELL_CAST_SUCCESS", "Destabilize", 351092)
	self:Log("SPELL_AURA_APPLIED", "DestabilizeApplied", 351092)
	self:Log("SPELL_CAST_START", "LashingStrike", 351179)
	self:Log("SPELL_AURA_APPLIED", "LashingWoundApplied", 351180)
	self:Log("SPELL_AURA_APPLIED_DOSE", "LashingWoundApplied", 351180)
	self:Log("SPELL_AURA_APPLIED", "CrushingDreadApplied", 351117)
	self:Log("SPELL_CAST_START", "DarkCommunion", 356021)
	self:Log("SPELL_AURA_APPLIED", "CurseOfLethargyApplied", 351939)
	self:Log("SPELL_AURA_APPLIED", "FuryApplied", 351672)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FuryApplied", 351672)

	-- Stage Three: The Freedom of Choice
	self:Log("SPELL_AURA_REMOVED", "BansheeShroudRemoved", 350857)
	self:Log("SPELL_AURA_APPLIED", "BansheesBaneApplied", 353929)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BansheesBaneApplied", 353929)
	self:Log("SPELL_CAST_SUCCESS", "BaneArrows", 353972)
	self:Log("SPELL_AURA_APPLIED", "BansheesHeartseekerApplied", 353965)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BansheesHeartseekerApplied", 353965)
	self:Log("SPELL_CAST_START", "BansheesFury", 354068)
	self:Log("SPELL_AURA_APPLIED", "BansheeScreamApplied", 357720)
	self:Log("SPELL_CAST_START", "Raze", 354147)
end

function mod:OnEngage()
	self:SetStage(1)
	stage = 1
	windrunnerCount = 1
	dominationChainsCount = 1
	veilofDarknessCount = 1
	wailingArrowCount = 1

	--self:Bar(347504, 25, CL.count:format(self:SpellName(347504), windrunnerCount)) -- Windrunner
	--self:Bar(349458, 25, CL.count:format(L.chains, dominationChainsCount)) -- Domination Chains
	--self:Bar(347704, 25, CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
	--self:Bar(347609, 25, CL.count:format(L.arrow, wailingArrowCount)) -- Wailing Arrow

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 83 then -- Intermission at 80%
		self:Message("stages", "green", CL.soon:format(CL.intermission), false)
		self:PlaySound("stages", "info")
		self:UnregisterUnitEvent(event, unit)
	end
end

-- Stage One: A Cycle of Hatred
function mod:Windrunner(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, windrunnerCount))
	self:PlaySound(args.spellId, "alert")
	windrunnerCount = windrunnerCount + 1
	--self:Bar(args.spellId, 25, CL.count:format(args.spellName, windrunnerCount))
end

function mod:WitheringFire(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:BarbedArrowApplied(args)
	if self:Me(args.destGUID) then
		self:NewStackMessage(args.spellId, "blue", args.destName, args.amount)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:DesecratingShot(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alert")
end

function mod:ShadowDagger(args)
	self:Message(args.spellId, "orange")
	if self:Healer() then
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:ShadowDaggerApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:DominationChains(args)
	self:Message(args.spellId, "red", CL.count:format(L.chains, dominationChainsCount))
	self:PlaySound(args.spellId, "warning")
	dominationChainsCount = dominationChainsCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(L.chains, dominationChainsCount))
end

function mod:DominationChainsApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, L.chain)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:VeilOfDarkness(args)
	self:Message(347704, "yellow", CL.count:format(L.darkness, veilofDarknessCount))
	self:PlaySound(347704, "alert")
	veilofDarknessCount = veilofDarknessCount + 1
	--self:Bar(347704, 25, CL.count:format(L.darkness, veilofDarknessCount))
end

function mod:VeilOfDarknessApplied(args)
	if self:Me(args.destGUID) then
		local _, amount = self:UnitDebuff(args.destName, args.spellId) -- Checking amout as it starts with 5 in Heroic & Mythic
		self:NewStackMessage(args.spellId, "blue", args.destName, amount, nil, L.darkness)
		self:PlaySound(args.spellId, "warning")
		-- Proximity 5 yards?
	end
end

function mod:WailingArrow(args)
	self:Message(args.spellId, "yellow", CL.count:format(L.arrow, wailingArrowCount))
	self:PlaySound(args.spellId, "alert")
	wailingArrowCount = wailingArrowCount + 1
	--self:Bar(args.spellId, 25, CL.count:format(L.arrow, wailingArrowCount))
end

function mod:WailingArrowApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, L.arrow)
		self:PlaySound(args.spellId, "alarm")
		self:Say(args.spellId, L.arrow)
		self:SayCountdown(args.spellId, 3, 2)
	end
end

function mod:WailingArrowRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:RangersHeartseekerApplied(args)
	local amount = args.amount or 1
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, amount)) -- Ranger's Heartseeker (1)-(3)
	if amount == 3 then -- Damage inc
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:BansheesMarkApplied(args)
	self:NewStackMessage(args.spellId, "purple", args.destName, args.amount)
	self:PlaySound(args.spellId, "alarm")
end

-- Intermission: A Monument to our Suffering
function mod:BansheeShroudApplied()
	self:Message("stages", "cyan", CL.intermission, nil)
	self:PlaySound("stages", "long")

	self:StopBar(CL.count:format(self:SpellName(347504), windrunnerCount)) -- Windrunner
	self:StopBar(CL.count:format(L.chains, dominationChainsCount)) -- Domination Chains
	self:StopBar(CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
	self:StopBar(CL.count:format(L.arrow, wailingArrowCount)) -- Wailing Arrow

	dominationChainsCount = 1
	riveCount = 1
	bansheeWailCount = 1

	--self:Bar(349458, 25, CL.count:format(L.chains, dominationChainsCount)) -- Domination Chains
	--self:Bar(348145, 25, CL.count:format(self:SpellName(348145), riveCount)) -- Rive
	--self:Bar(348109, 25, CL.count:format(self:SpellName(348109), bansheeWailCount)) -- Banshee Wail
end

function mod:Rive(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, riveCount))
	self:PlaySound(args.spellId, "alert")
	riveCount = riveCount + 1
	--self:Bar(args.spellId, 25, CL.count:format(args.spellName, riveCount)
end

function mod:BansheeWail(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, bansheeWailCount))
	self:PlaySound(args.spellId, "alarm")
	bansheeWailCount = bansheeWailCount + 1
	--self:Bar(args.spellId, 25, CL.count:format(args.spellName, bansheeWailCount)
end

-- Stage Two: The Banshee Queen
function mod:BansheeFormApplied()
	if stage < 2 then -- PTR TEMP
		self:SetStage(2)
		stage = 2
		self:Message("stages", "cyan", CL.stage:format(stage), nil)
		self:PlaySound("stages", "long")

		self:StopBar(CL.count:format(L.chains, dominationChainsCount)) -- Domination Chains
		self:StopBar(CL.count:format(self:SpellName(348145), riveCount)) -- Rive
		self:StopBar(CL.count:format(self:SpellName(348109), bansheeWailCount)) -- Banshee Wail

		veilofDarknessCount = 1
		bansheeWailCount = 1
		ruinCount = 1
		hauntingWaveCount = 1

		--self:Bar(347704, 25, CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
		--self:Bar(348109, 25, CL.count:format(self:SpellName(348109), bansheeWailCount)) -- Banshee Wail
		--self:Bar(355540, 25, CL.count:format(self:SpellName(355540), ruinCount)) -- Ruin
		--self:Bar(351869, 25, CL.count:format(L.wave, hauntingWaveCount)) -- Haunting Wave
	end
end

function mod:Ruin(args)
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(args.spellName, ruinCount)))
	self:PlaySound(args.spellId, "warning")
	ruinCount = ruinCount + 1
	--self:Bar(args.spellId, 25, CL.count:format(args.spellName, ruinCount)
end

function mod:HauntingWave(args)
	self:Message(args.spellId, "yellow", CL.count:format(L.wave, hauntingWaveCount))
	self:PlaySound(args.spellId, "alert")
	hauntingWaveCount = hauntingWaveCount + 1
	--self:Bar(args.spellId, 25, CL.count:format(L.wave, hauntingWaveCount)
end

do
	local prev = 0
	function mod:AccursedMight(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			self:Message(args.spellId, "yellow")
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:UnstoppableForce(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

function mod:Enflame(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alert")
end

function mod:Destabilize(args)
	self:Message(args.spellId, "yellow")
end

function mod:DestabilizeApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:LashingStrike(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
end

function mod:LashingWoundApplied(args)
	if self:Me(args.destGUID) then -- When to show the other tank?
		self:NewStackMessage(args.spellId, "purple", args.destName, args.amount)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:CrushingDreadApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, L.dread)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:DarkCommunion(args)
	self:Message(args.spellId, "orange", L.orbs)
	self:PlaySound(args.spellId, "long")
end

function mod:CurseOfLethargyApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, L.curse)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:FuryApplied(args)
	local amount = args.amount or 1
	if amount % 3 == 0 or amount > 10 then
		self:NewStackMessage(args.spellId, "purple", args.destName, args.amount)
		self:PlaySound(args.spellId, "alert")
	end
end

-- Stage Three: The Freedom of Choice
function mod:BansheeShroudRemoved()
	self:SetStage(3)
	stage = 3
	self:Message("stages", "cyan", CL.stage:format(stage), nil)
	self:PlaySound("stages", "long")

	self:StopBar(CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
	self:StopBar(CL.count:format(self:SpellName(348109), bansheeWailCount)) -- Banshee Wail
	self:StopBar(CL.count:format(self:SpellName(355540), ruinCount)) -- Ruin
	self:StopBar(CL.count:format(L.wave, hauntingWaveCount)) -- Haunting Wave

	veilofDarknessCount = 1
	wailingArrowCount = 1
	bansheeScreamCount = 1
	razeCount = 1
	bansheesFuryCount = 1

	--self:Bar(347704, 25, CL.count:format(L.darkness, veilofDarknessCount)) -- Veil of Darkness
	--self:Bar(347609, 25, CL.count:format(L.arrow, wailingArrowCount)) -- Wailing Arrow
	--self:Bar(357720, 25, CL.count:format(L.scream, bansheeScreamCount)) -- Banshee Scream
	--self:Bar(354068, 25, CL.count:format(self:SpellName(354068), bansheesFuryCount)) -- Banshee's Fury
	--self:Bar(354147, 25, CL.count:format(self:SpellName(354147), razeCount)) -- Raze
end

function mod:BansheesBaneApplied(args)
	if self:Me(args.destGUID) then
		self:NewStackMessage(args.spellId, "blue", args.destName, args.amount, nil, L.pools)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:BaneArrows(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:BansheesHeartseekerApplied(args)
	local amount = args.amount or 1
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, amount)) -- Banshee's Heartseeker (1)-(3)
	if amount == 3 then -- Damage inc
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:BansheesFury(args)
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, bansheesFuryCount))
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, 5) -- 1s precast, 4s before the explosions
	bansheesFuryCount = bansheesFuryCount + 1
	--self:Bar(args.spellId, 25, CL.count:format(args.spellName, bansheesFuryCount))
end

do
	local prev = 0
	function mod:BansheeScreamApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			self:Message(args.spellId, "orange", CL.count:format(L.scream, bansheeScreamCount))
			bansheeScreamCount = bansheeScreamCount + 1
			--self:Bar(args.spellId, 25, CL.count:format(L.scream, bansheeScreamCount))
		end
		if self:Me(args.destGUID)then
			self:PersonalMessage(args.spellId, L.scream)
			self:Say(args.spellId, L.scream)
			--self:SayCountdown(args.spellId, 5)
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:Raze(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, razeCount))
	self:PlaySound(args.spellId, "warning")
	razeCount = razeCount + 1
	--self:Bar(args.spellId, 25, CL.count:format(args.spellName, razeCount))
end
