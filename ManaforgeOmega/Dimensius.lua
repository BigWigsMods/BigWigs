--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Dimensius, the All-Devouring", 2810, 2691)
if not mod then return end
mod:RegisterEnableMob(241517, 234478, 233824) -- P1/2/3
mod:SetEncounterID(3135)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local massiveSmashCount = 1
local devourCount = 1
local darkMatterCount = 1
local shatteredSpaceCount = 1
local gravityCount = 1

local collectiveGravityOnMe = false

local voidlordKilled = 0
local extinctionCount = 1
local gammaBurstCount = 1
local massEjectionCount = 1
local conquerorsCrossCount = 1
local stardustNovaCount = 1
local lastIntermissionCastTime
local lastIntermissionCast

local darkenedSkyCount = 1
local cosmicCollapseCount = 1
local supernovaCount = 1
local voidgraspCount = 1

--------------------------------------------------------------------------------
-- Timers
--

local timersEasy = {
	[1] = {
		[1229038] = { 12.5, 100.0, 100.0, 0 }, -- Devour
		[1230087] = { 25.0, 50.0, 50.0, 50.0, 0 }, -- Massive Smash
		[1230979] = { 37.5, 46.3, 53.7, 46.3, 0 }, -- Dark Matter
		[1243690] = { 43.7, 50.0, 50.0, 50.0, 0 }, -- Shattered Space
		[1243577] = { 56.3, 45.0, 55.0, 45.0, 0 }, -- Reverse Gravity
	},
	[3] = {
		[1233539] = { 61.6, 100.0, 100.0, 0 }, -- Devour
		[1234044] = { 94.9, 33.3, 66.7, 33.3, 0 }, -- Darkened Sky
		[1234263] = { 79.3, 33.3, 33.3, 33.3, 33.3, 33.3, 0 }, -- Cosmic Collapse
		[1232973] = { 70.5, 14.5, 33.3, 33.3, 18.9, 14.5, 33.3, 33.3, 0 }, -- Supernova
		[1250055] = { 74.9, 33.3, 33.3, 33.4, 33.3, 33.3, 0 }, -- Voidgrasp
	}
}

local timersHeroic = {
	[1] = {
		[1229038] = { 11.7, 94.1, 94.1, 0 }, -- Devour
		[1230087] = { 23.5, 47.0, 47.0, 47.0, 0 }, -- Massive Smash
		[1230979] = { 35.3, 43.5, 50.6, 43.5, 0 }, -- Dark Matter
		[1243690] = { 47.7, 47.0, 47.0, 47.0, 0 }, -- Shattered Space
		[1243577] = { 52.9, 42.3, 51.7, 42.4, 0 }, -- Reverse Gravity
	},
	[3] = {
		[1233539] = { 61.7, 100.0, 100.0, 0 }, -- Devour
		[1234044] = { 44.7, 50.4, 33.3, 66.6, 33.3, 0 }, -- Darkened Sky (first cast is emote only, next is at 95.1)
		[1234263] = { 79.5, 33.3, 33.4, 33.3, 33.3, 33.3, 0 }, -- Cosmic Collapse
		[1232973] = { 70.6, 14.5, 33.3, 33.3, 18.9, 14.5, 33.3, 33.3, 0 }, -- Supernova
		[1250055] = { 75.1, 33.3, 33.3, 33.4, 36.3, 30.4, 0 }, -- Voidgrasp
	}
}

local timersMythic = {
	[1] = {
		[1229038] = { 10.6, 84.2, 84.2, 0 }, -- Devour
		[1230087] = { 21.1, 42.1, 42.1, 42.1, 0 }, -- Massive Smash
		[1230979] = { 31.6, 39.0, 45.3, 39.0, 0 }, -- Dark Matter
		[1243690] = { 36.8, 42.1, 42.1, 42.1, 0 }, -- Shattered Space
		[1243577] = { 43.2, 42.1, 42.1, 42.1, 0 }, -- Reverse Gravity
	},
	[3] = {
		[1233539] = { 62.7, 80.0, 80.0, 0 }, -- Devour
		[1234044] = { 44.7, 43.0, 30.0, 50.0, 30.0, 0 }, -- Darkened Sky (first cast is emote only, next is at 87.7)
		[1234263] = { 72.7, 30.0, 30.0, 30.0, 30.0, 0 }, -- Cosmic Collapse
		[1234242] = { 74.7, 26.0, 32.0, 26.0, 32.0, 0 }, -- Gravitational Distortion
	}
}

local timers = mod:Mythic() and timersMythic or mod:Easy() and timersEasy or timersHeroic

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.gravity = "Gravity" -- Short for Reverse Gravity/Gravitational Distortion
	L.extinction = "Fragment" -- Dimensius hurls a fragment of a broken world
	L.slows = "Slows"
	L.slow = "Slow" -- Singular of Slows
	L.mass_destruction = "Lines"
	L.stardust_nova = "Nova" -- Short for Stardust/Starshards Nova
	L.extinguish_the_stars = "Stars" -- Short for Extinguish the Stars
	L.darkened_sky = "Rings"
	L.cosmic_collapse = "Collapse" -- Short for Cosmic Collapse
	L.soaring_reshii = "Mount Available" -- On the timer for when flying is available

	L.weakened_soon_monster_yell = "We must strike--now!" -- [CHAT_MSG_MONSTER_YELL] We must strike--now!#Xal'atath###Xal'atath##0#0##0#4873#nil#0#false#false#false#false",
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:SetSpellRename(1230087, CL.smash) -- Massive Smash (Smash)
	self:SetSpellRename(1230979, CL.spread) -- Dark Matter (Spread)
	self:SetSpellRename(1243690, CL.soaks) -- Shattered Space (Soaks)
	self:SetSpellRename(1243699, CL.stunned) -- Spatial Fragment (Stunned)
	self:SetSpellRename(1243577, L.gravity) -- Reverse Gravity (Gravity)

	self:SetSpellRename(1238765, L.extinction) -- Extinction (Fragment)
	self:SetSpellRename(1237325, CL.pushback) -- Gamma Burst (Pushback)
	self:SetSpellRename(1237694, CL.tank_frontal) -- Mass Ejection (Frontal)
	self:SetSpellRename(1239262, CL.adds) -- Conqueror's Cross (Adds)
	self:SetSpellRename(1246541, L.slow) -- Null Binding (Slow)
	self:SetSpellRename(1237695, L.stardust_nova) -- Stardust Nova (Nova)

	self:SetSpellRename(1245292, CL.weakened) -- Destabilized (Weakening)
	self:SetSpellRename(1231716, L.extinguish_the_stars) -- Extinguish the Stars (Stars)
	self:SetSpellRename(1234044, L.darkened_sky) -- Darkened Sky (Rings)
	self:SetSpellRename(1234263, L.cosmic_collapse) -- Cosmic Collapse (Collapse)
	self:SetSpellRename(1250055, L.slows) -- Voidgrasp (Slows)
end

function mod:GetOptions()
	return {
		"stages",

		-- Stage One: Critical Mass
		-- 1229327, -- Oblivion
		1230087, -- Massive Smash
			-- Living Mass
			{1228206, "ME_ONLY_EMPHASIZE"}, -- Excess Mass
				1228207, -- Collective Gravity
			{1230168, "TANK"}, -- Mortal Fragility
		{1229038, "CASTBAR"}, -- Devour (P1)
		1230979, -- Dark Matter
			1231002, -- Dark Energy
		1243690, -- Shattered Space
			1243702, -- Antimatter
			1243699, -- Spatial Fragment
		{1243577, "SAY", "SAY_COUNTDOWN"}, -- Reverse Gravity
			1243609, -- Airborne
		-- 1227665, -- Fists of the Voidlord

		-- Intermission: Event Horizon
		1235114, -- Soaring Reshii
		1237097, -- Astrophysical Jet
		1230674, -- Spaghettification
		1246930, -- Stellar Core

		-- Stage Two: The Dark Heart
		1238765, -- Extinction
		{1237325, "CASTBAR"}, -- Gamma Burst
		-- The Devoured Lords
			1237690, -- Eclipse
			{1246145, "TANK"}, -- Touch of Oblivion
			1239262, -- Conqueror's Cross
				1239270, -- Voidwarding (Voidwarden)
				1246541, -- Null Binding (Nullbinder)
			1237696, -- Debris Field
			1237694, -- Mass Ejection (Artoshion)
			1237695, -- Stardust Nova (Pargoth)
		-- Mythic
			1249423, -- Mass Destruction (Artoshion)
			1251619, -- Starshard Nova (Pargoth)
		1234242, -- Gravitational Distortion
			1234243, -- Crushing Gravity
			{1234244, "ME_ONLY_EMPHASIZE"}, -- Inverse Gravity

		-- Stage Three: Singularity
		{1245292, "CASTBAR"}, -- Destabilized
		1233292, -- Accretion Disk
		{1231716, "CASTBAR"}, -- Extinguish the Stars
			1232394, -- Gravity Well
		{1233539, "CASTBAR"}, -- Devour (P3)
		1234044, -- Darkened Sky
			1234054, -- Shadowquake
		{1234263, "CASTBAR"}, -- Cosmic Collapse
			{1234266, "TANK"}, -- Cosmic Fragility
		{1232973, "CASTBAR"}, -- Supernova
		1250055, -- Voidgrasp
	},{
		{
			tabName = CL.stage:format(1),
			{"stages", 1230087, 1228206, 1228207, 1230168, 1229038, 1230979, 1231002, 1243690, 1243702, 1243699, 1243577, 1243609},
		},
		{
			tabName = CL.intermission,
			{"stages", 1235114, 1237097, 1230674, 1246930},
		},
		{
			tabName = CL.stage:format(2),
			{"stages", 1238765, 1237325, 1237690, 1246145, 1239262, 1239270, 1246541, 1237696, 1237694, 1237695, 1249423, 1251619, 1234242, 1234243, 1234244},
		},
		{
			tabName = CL.stage:format(3),
			{"stages", 1245292, 1233292, 1231716, 1232394, 1233539, 1234044, 1234054, 1234263, 1234266, 1232973, 1230674, 1250055, 1234242, 1234243, 1234244},
		},
		[1237690] = -32738, -- The Devoured Lords
		[1249423] = "mythic",
		[1234242] = "mythic",
	},{
		[1230087] = CL.smash, -- Massive Smash (Smash)
		[1230979] = CL.spread, -- Dark Matter (Spread)
		[1243690] = CL.soaks, -- Shattered Space (Soaks)
		[1243699] = CL.stunned, -- Spatial Fragment (Stunned)
		[1243577] = L.gravity, -- Reverse Gravity (Gravity)
		[1238765] = L.extinction, -- Extinction (Fragment)
		[1237325] = CL.pushback, -- Gamma Burst (Pushback)
		[1237690] = CL.full_energy, -- Eclipse (Full Energy)
		[1237694] = CL.tank_frontal, -- Mass Ejection (Frontal Cone)
		[1239262] = CL.adds, -- Conqueror's Cross (Adds)
		[1246541] = L.slow, -- Null Binding (Slow)
		[1237695] = L.stardust_nova, -- Stardust Nova (Nova)
		[1245292] = CL.weakened, -- Destabilized (Weakening)
		[1231716] = L.extinguish_the_stars, -- Extinguish the Stars (Stars)
		[1234044] = L.darkened_sky, -- Darkened Sky (Rings)
		[1234263] = L.cosmic_collapse, -- Cosmic Collapse (Collapse)
		[1250055] = L.slows, -- Voidgrasp (Slows)
	}
end

function mod:OnBossEnable()
	if self:Story() then return end

	self:RegisterUnitEvent("UNIT_SPELLCAST_START", nil, "boss1", "boss2") -- Shattered Space, Gamma Burst
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	-- Stage One: Critical Mass
	self:Log("SPELL_CAST_START", "MassiveSmash", 1230087)
	self:Log("SPELL_AURA_APPLIED", "ExcessMassApplied", 1228206)
	self:Log("SPELL_AURA_APPLIED", "CollectiveGravityApplied", 1228207)
	self:Log("SPELL_AURA_REMOVED", "CollectiveGravityRemoved", 1228207)
	self:Log("SPELL_AURA_APPLIED", "MortalFragilityApplied", 1230168)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MortalFragilityApplied", 1230168)

	self:Log("SPELL_CAST_START", "DevourP1", 1229038)
	self:Log("SPELL_CAST_SUCCESS", "DevourP1Success", 1229038)

	self:Log("SPELL_CAST_START", "DarkMatter", 1230979)
	self:Log("SPELL_AURA_APPLIED", "DarkEnergyDamage", 1231002)
	self:Log("SPELL_PERIODIC_DAMAGE", "DarkEnergyDamage", 1231002)
	self:Log("SPELL_PERIODIC_MISSED", "DarkEnergyDamage", 1231002)

	-- self:Log("SPELL_CAST_START", "ShatteredSpace", 1243690)
	self:Log("SPELL_DAMAGE", "AntimatterHit", 1243702)
	self:Log("SPELL_MISSED", "AntimatterHit", 1243702)
	self:Log("SPELL_AURA_APPLIED", "SpatialFragmentApplied", 1243699)

	self:Log("SPELL_AURA_APPLIED", "ReverseGravityApplied", 1243577)
	self:Log("SPELL_AURA_REMOVED", "ReverseGravityRemoved", 1243577)
	self:Log("SPELL_AURA_APPLIED", "AirborneApplied", 1243609)
	self:Log("SPELL_AURA_REMOVED", "AirborneRemoved", 1243609)

	-- Intermission: Event Horizon
	self:Log("SPELL_CAST_START", "EventHorizon", 1234898) -- End of P1
	self:Log("SPELL_AURA_APPLIED", "SoaringReshiiApplied", 1235114)
	self:Log("SPELL_AURA_APPLIED", "AstrophysicalJetDamage", 1237097)
	self:Log("SPELL_PERIODIC_DAMAGE", "AstrophysicalJetDamage", 1237097)
	self:Log("SPELL_PERIODIC_MISSED", "AstrophysicalJetDamage", 1237097)
	self:Log("SPELL_AURA_APPLIED", "SpaghettificationApplied", 1230674)
	self:Log("SPELL_AURA_APPLIED", "StellarCoreApplied", 1246930)

	-- Stage Two: The Dark Heart
	self:Log("SPELL_AURA_APPLIED", "WorldsoulConsumptionApplied", 1237102)

	self:Log("SPELL_CAST_START", "Extinction", 1238765)
	-- self:Log("UNIT_SPELLCAST_START", "GammaBurst", 1237319)

	-- The Devoured Lords
	self:Log("SPELL_CAST_START", "EclipseStart", 1244606)
	self:Log("SPELL_CAST_START", "MassEjection", 1237694, 1249423) -- Mass Ejection, Mass Destruction
	self:Log("SPELL_AURA_APPLIED", "MassDestructionApplied", 1249425)
	self:Log("SPELL_AURA_APPLIED", "DebrisFieldDamage", 1237696)
	self:Log("SPELL_PERIODIC_DAMAGE", "DebrisFieldDamage", 1237696)
	self:Log("SPELL_PERIODIC_MISSED", "DebrisFieldDamage", 1237696)
	self:Log("SPELL_CAST_START", "ConquerorsCross", 1239262)
	self:Log("SPELL_AURA_APPLIED", "VoidwardingApplied", 1239270)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VoidwardingApplied", 1239270)
	self:Log("SPELL_CAST_SUCCESS", "NullBinding", 1246541)
	self:Log("SPELL_AURA_APPLIED", "TouchOfOblivionApplied", 1246145)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TouchOfOblivionApplied", 1246145)
	self:Log("SPELL_CAST_START", "StardustNova", 1237695, 1251619) -- Stardust Nova, Starshard Nova
	self:Log("SPELL_AURA_APPLIED", "CrushingGravityApplied", 1234243)
	self:Log("SPELL_AURA_APPLIED", "InverseGravityApplied", 1234244)
	self:Death("VoidlordDeath", 245255, 245222) -- Artoshion & Pargoth

	-- Stage Three: Singularity
	self:Log("SPELL_CAST_START", "TotalDestruction", 1240310)
	self:Log("SPELL_AURA_APPLIED", "DestabilizedApplied", 1245292)
	self:Log("SPELL_AURA_REMOVED", "DestabilizedRemoved", 1245292)
	self:Log("SPELL_DAMAGE", "AccretionDiskDamage", 1233292)
	self:Log("SPELL_MISSED", "AccretionDiskDamage", 1233292)
	self:Log("SPELL_CAST_SUCCESS", "ExtinguishTheStars", 1231716)
	self:Log("SPELL_AURA_APPLIED", "GravityWellApplied", 1232394)
	self:Log("SPELL_CAST_START", "DevourP3", 1233539)
	self:Log("SPELL_AURA_REMOVED", "DevourP3Removed", 1233539) -- Channel Over
	self:Log("SPELL_CAST_START", "DarkenedSky", 1234044)
	self:Log("SPELL_AURA_APPLIED", "ShadowquakeApplied", 1234054)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShadowquakeApplied", 1234054)
	self:Log("SPELL_CAST_START", "CosmicCollapse", 1234263)
	self:Log("SPELL_AURA_APPLIED", "CosmicFragilityApplied", 1234266)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CosmicFragilityApplied", 1234266)
	self:Log("SPELL_CAST_START", "Supernova", 1232973)
	self:Log("SPELL_AURA_APPLIED", "VoidgraspApplied", 1250055)

	self:Log("SPELL_AURA_REMOVED", "HoldTheLine", 1240533)

	timers = self:Mythic() and timersMythic or self:Easy() and timersEasy or timersHeroic
end

function mod:OnEngage()
	if self:Story() then return end

	self:SetStage(1)

	massiveSmashCount = 1
	devourCount = 1
	darkMatterCount = 1
	shatteredSpaceCount = 1
	gravityCount = 1

	self:Bar(1230087, timers[1][1230087][1], CL.count:format(CL.smash, massiveSmashCount)) -- Massive Smash
	self:Bar(1229038, timers[1][1229038][1], CL.count:format(self:SpellName(1229038), devourCount)) -- Devour
	self:Bar(1230979, timers[1][1230979][1], CL.count:format(CL.spread, darkMatterCount)) -- Dark Matter
	self:Bar(1243690, timers[1][1243690][1], CL.count:format(CL.soaks, shatteredSpaceCount)) -- Shattered Space
	self:Bar(1243577, timers[1][1243577][1], CL.count:format(L.gravity, gravityCount)) -- Reverse Gravity
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_START(_, unit, _, spellId)
	if spellId == 1243690 then
		self:ShatteredSpace()
	elseif spellId == 1237319 then -- Gamma Burst
		self:GammaBurst()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg == L.weakened_soon_monster_yell then
		self:Bar(1245292, {8.7, 15}, CL.weakened) -- Correct it with more precision
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	-- |TInterface\\\\ICONS\\\\INV_112_RaidDimensius_DarkenedSky.BLP:20|t %s casts |cFFFF0000|Hspell:1234052|h[Darkened Sky]|h|r!#Dimensius###Dimensius##0#0##0#4880#nil#0#false#false#false#false",
	if not self:Easy() and msg:find("spell:1234052", nil, true) and darkenedSkyCount == 1 then
		self:DarkenedSky() -- Using emote as first cast has no cast...
	end
end



-- Stage One: Critical Mass
function mod:MassiveSmash(args)
	self:Message(args.spellId, "purple", CL.count:format(CL.smash, massiveSmashCount))
	self:PlaySound(args.spellId, "long") -- big tank hit + adds + knockback
	massiveSmashCount = massiveSmashCount + 1
	self:Bar(args.spellId, timers[1][args.spellId][massiveSmashCount], CL.count:format(CL.smash, massiveSmashCount))
end

function mod:ExcessMassApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "info", nil, args.destName) -- carrying excess mass
	end
end

function mod:CollectiveGravityApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, "underyou")
		self:PlaySound(args.spellId, "underyou", nil, args.destName)
		collectiveGravityOnMe = true
	end
end

function mod:CollectiveGravityRemoved(args)
	if self:Me(args.destGUID) then
		collectiveGravityOnMe = false
	end
end

function mod:MortalFragilityApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm", nil, args.destName) -- debuffed
	elseif self:Tank() then
		self:PlaySound(args.spellId, "warning") -- taunt?
	end
end

do
	local collectiveGravityCheck, collectiveGravitySpellName = nil, mod:SpellName(1228207) -- Collective Gravity

	local function checkForCollectiveGravity()
		if collectiveGravityCheck then
			mod:CancelTimer(collectiveGravityCheck)
			collectiveGravityCheck = nil
		end
		if mod:GetStage() ~= 1 or collectiveGravityOnMe or mod:UnitIsDeadOrGhost("player") then return end -- safe! or death. or staged.

		mod:Message(1228207, "blue", CL.no:format(collectiveGravitySpellName))
		mod:PlaySound(1228207, "warning") -- no collective gravity
		collectiveGravityCheck = mod:ScheduleTimer(checkForCollectiveGravity, 1)
	end

	function mod:DevourP1(args)
		self:StopBar(CL.count:format(args.spellName, devourCount))
		self:Message(args.spellId, "red", CL.count:format(args.spellName, devourCount))
		self:PlaySound(args.spellId, "warning") -- get safe
		self:CastBar(args.spellId, 7, CL.count:format(args.spellName, devourCount))
		devourCount = devourCount + 1
		self:Bar(args.spellId, timers[1][args.spellId][devourCount], CL.count:format(args.spellName, devourCount))
		collectiveGravityCheck = mod:ScheduleTimer(checkForCollectiveGravity, 2.5) -- check last 4~ seconds
	end

	function mod:DevourP1Success()
		if collectiveGravityCheck then
			mod:CancelTimer(collectiveGravityCheck)
			collectiveGravityCheck = nil
		end
	end
end

function mod:DarkMatter(args)
	self:StopBar(CL.count:format(CL.spread, darkMatterCount))
	self:Message(args.spellId, "orange", CL.count:format(CL.spread, darkMatterCount))
	self:PlaySound(args.spellId, "alert") -- spread
	darkMatterCount = darkMatterCount + 1
	self:Bar(args.spellId, timers[1][args.spellId][darkMatterCount], CL.count:format(CL.spread, darkMatterCount))
end

do
	local prev = 0
	function mod:DarkEnergyDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou", nil, args.destName)
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

function mod:ShatteredSpace()
	self:StopBar(CL.count:format(CL.soaks, shatteredSpaceCount))
	self:Message(1243690, "yellow", CL.count:format(CL.soaks, shatteredSpaceCount))
	self:PlaySound(1243690, "alert") -- move away from hands
	shatteredSpaceCount = shatteredSpaceCount + 1
	self:Bar(1243690, timers[1][1243690][shatteredSpaceCount], CL.count:format(CL.soaks, shatteredSpaceCount))
end

do
	local prev = 0
	function mod:AntimatterHit(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PersonalMessage(args.spellId, "underyou")
			self:PlaySound(args.spellId, "info", nil, args.destName) -- soaking, good kind of soak
		end
	end
end

function mod:SpatialFragmentApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "blue", CL.stunned) -- "Stun on YOU!" better?
		self:PlaySound(args.spellId, "warning", nil, args.destName) -- stunned
	end
end

do
	local prev = 0
	function mod:ReverseGravityApplied(args)
		if args.time - prev > 2 then
			prev = args.time
			self:StopBar(CL.count:format(L.gravity, gravityCount))
			self:Message(args.spellId, "yellow", CL.count:format(L.gravity, gravityCount))
			-- Not using targetsmessage because it read as it if's cast multiple times in succession fast for now
			-- sound for targetted players only
			gravityCount = gravityCount + 1
			self:Bar(args.spellId, timers[1][args.spellId][gravityCount], CL.count:format(L.gravity, gravityCount))
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId, nil, L.gravity)
			self:PlaySound(args.spellId, "warning", nil, args.destName) -- move
			self:Say(args.spellId, L.gravity, nil, "Gravity")
			self:SayCountdown(args.spellId, 6)
		end
	end

	function mod:ReverseGravityRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:AirborneApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm", nil, args.destName) -- airborne
	end
end

function mod:AirborneRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info", nil, args.destName) -- back on the ground
	end
end

function mod:EventHorizon(args)
	self:StopBar(CL.count:format(CL.smash, massiveSmashCount)) -- Massive Smash
	self:StopBar(CL.count:format(self:SpellName(1229038), devourCount)) -- Devour
	self:StopBar(CL.count:format(CL.spread, darkMatterCount)) -- Dark Matter
	self:StopBar(CL.count:format(CL.soaks, shatteredSpaceCount)) -- Shattered Space
	self:StopBar(CL.count:format(L.gravity, gravityCount)) -- Reverse Gravity

	self:SetStage(2)
	self:Message("stages", "cyan", CL.stage:format(2), false) -- just calling it stage 2
	self:PlaySound("stages", "long") -- staging

	voidlordKilled = 0
	self:Bar(1235114, 13.8, L.soaring_reshii) -- Soaring Reshii
end

-- Intermission: Event Horizon
function mod:SoaringReshiiApplied(args)
	self:StopBar(L.soaring_reshii)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.flying_available)
		self:PlaySound(args.spellId, "info", nil, args.destName)
	end
end

do
	local prev = 0
	function mod:AstrophysicalJetDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou", nil, args.destName)
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

function mod:SpaghettificationApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "red", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "alarm") -- fail
	end
end

function mod:StellarCoreApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info", nil, args.destName)
	end
end

-- Stage Two: The Dark Heart
function mod:WorldsoulConsumptionApplied(args)
	-- self:SetStage(2)

	lastIntermissionCast = nil
	conquerorsCrossCount = 1
	massEjectionCount = 1
	stardustNovaCount = 1
	extinctionCount = 1
	gammaBurstCount = 1
	gravityCount = 1

	-- first cast times here are sketchy, times from the first Conqueror's Cross cast are good, though
	if voidlordKilled == 0 then
		-- Artoshion
		self:CDBar(1239262, self:Mythic() and 10.1 or 15.2, CL.count:format(CL.adds, conquerorsCrossCount))
		if self:Mythic() then
			self:CDBar(1249423, 13.2, CL.count:format(L.mass_destruction, massEjectionCount)) -- Mass Destruction
		else
			self:CDBar(1237694, 22.3, CL.count:format(CL.tank_frontal, massEjectionCount)) -- Mass Ejection
		end
	else
		-- Pargoth
		self:CDBar(1239262, self:Mythic() and 13.9 or 18.8, CL.count:format(CL.adds, conquerorsCrossCount))
		if self:Mythic() then
			self:CDBar(1237695, 17.0, CL.count:format(L.stardust_nova, stardustNovaCount)) -- Starshard Nova
		else
			self:CDBar(1251619, 25.9, CL.count:format(L.stardust_nova, stardustNovaCount)) -- Stardust Nova
		end
	end
end

function mod:EclipseStart()
	self:Message(1237690, "red", CL.full_energy)
	self:PlaySound(1237690, "alarm")
	self:Bar(1237690, { 3, self:Mythic() and 65 or 85 }, CL.full_energy)
end

function mod:Extinction(args)
	self:StopBar(CL.count:format(L.extinction, extinctionCount))
	self:Message(args.spellId, "orange", CL.count:format(L.extinction, extinctionCount))
	self:PlaySound(args.spellId, "warning") -- dodge fragment
	extinctionCount = extinctionCount + 1
	if extinctionCount < (self:Mythic() and 3 or 4) then
		self:Bar(args.spellId, self:Mythic() and 31.6 or 35.3, CL.count:format(L.extinction, extinctionCount))
	end

	lastIntermissionCast = "extinction"
	lastIntermissionCastTime = GetTime()
end

function mod:GammaBurst()
	self:StopBar(CL.count:format(CL.pushback, gammaBurstCount))
	self:Message(1237325, "red", CL.count:format(CL.pushback, gammaBurstCount))
	self:PlaySound(1237325, "long") -- pushback inc
	self:CastBar(1237325, 4, CL.count:format(CL.pushback, gammaBurstCount))
	gammaBurstCount = gammaBurstCount + 1
	if gammaBurstCount < 3 then
		self:Bar(1237325, self:Mythic() and 31.6 or 35.4, CL.count:format(CL.pushback, gammaBurstCount))
	end

	lastIntermissionCast = "gamma"
	lastIntermissionCastTime = GetTime()
end

-- The Devoured Lords
-- Artoshion & Pargoth
function mod:MassEjection(args)
	local spellName = self:Mythic() and L.mass_destruction or CL.tank_frontal
	self:StopBar(CL.count:format(spellName, massEjectionCount))
	self:Message(args.spellId, "yellow", CL.casting:format(spellName))
	if not self:Mythic() then
		self:PlaySound(args.spellId, "alert") -- dodge frontal
	end
	massEjectionCount = massEjectionCount + 1
	if massEjectionCount < (self:Mythic() and 5 or 6) then
		self:Bar(args.spellId, self:Mythic() and 15.8 or 17.5, CL.count:format(spellName, massEjectionCount))
	end
end

function mod:MassDestructionApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(1249423)
		self:PlaySound(1249423, "alert") -- aim line
	end
end

do
	local prev = 0
	function mod:DebrisFieldDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PersonalMessage(args.spellId, "underyou")
			self:PlaySound(args.spellId, "underyou", nil, args.destName)
		end
	end
end

function mod:ConquerorsCross(args)
	self:StopBar(CL.count:format(CL.adds, conquerorsCrossCount))
	self:Message(args.spellId, "cyan", CL.count:format(CL.adds, conquerorsCrossCount))
	self:PlaySound(args.spellId, "info") -- adds/walls incoming

	-- didn't see a reliable event before this for intermission boss timers
	if conquerorsCrossCount == 1 then
		if voidlordKilled == 0 then
			-- Artoshion
			if self:Mythic() then
				self:Bar(1249423, {3.2, 13.2}, CL.count:format(L.mass_destruction, massEjectionCount)) -- Mass Destruction
			else
				self:Bar(1237694, {7.1, 22.3}, CL.count:format(CL.tank_frontal, massEjectionCount)) -- Mass Ejection
			end
		else
			-- Pargoth
			if self:Mythic() then
				self:Bar(1237695, {3.2, 17.0}, CL.count:format(L.stardust_nova, stardustNovaCount)) -- Starshard Nova
			else
				self:Bar(1251619, {7.1, 25.9}, CL.count:format(L.stardust_nova, stardustNovaCount)) -- Stardust Nova
			end
		end
		self:Bar(1238765, self:Mythic() and 10.5 or 11.8, CL.count:format(L.extinction, extinctionCount)) -- Extinction
		self:Bar(1237325, self:Mythic() and 21.1 or self:Easy() and 30 or 25.9, CL.count:format(CL.pushback, gammaBurstCount)) -- Gamma Burst
		if self:Mythic() then
			self:Bar(1234242, 12.6, CL.count:format(L.gravity, gravityCount)) -- Gravitational Distortion
		end
		self:Bar(1237690, self:Mythic() and 65 or 85, CL.full_energy) -- Eclipse
	end

	conquerorsCrossCount = conquerorsCrossCount + 1
	if conquerorsCrossCount < (self:Mythic() and 3 or 4) then
		self:Bar(args.spellId, self:Mythic() and 31.6 or 35.3, CL.count:format(CL.adds, conquerorsCrossCount))
	end
end

function mod:VoidwardingApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
		self:PlaySound(args.spellId, "underyou", nil, args.destName) -- avoidable / standing in it
	end
end

function mod:NullBinding(args)
	self:Message(args.spellId, "yellow", L.slow)
	self:PlaySound(args.spellId, "alarm") -- slows
end

function mod:TouchOfOblivionApplied(args)
	local amount = args.amount or 1
	local highStacks = self:Mythic() and 7 or 12
	self:StackMessage(args.spellId, "blue", args.destName, amount, highStacks)
	if self:Me(args.destGUID) and (amount % 2 == 1 or amount >= highStacks) then
		self:PlaySound(args.spellId, amount >= highStacks and "warning" or "info", nil, args.destName) -- care above 6
	elseif amount >= highStacks then
		self:PlaySound(args.spellId, "warning") -- taunt?
	end
end

function mod:StardustNova(args)
	self:StopBar(CL.count:format(L.stardust_nova, stardustNovaCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.stardust_nova, stardustNovaCount))
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:UnitWithinRange(unit, 20) then -- radius is 10, using 20 to be safe.
		self:PlaySound(args.spellId, "alert") -- move out of melee
	end
	stardustNovaCount = stardustNovaCount + 1
	if stardustNovaCount < (self:Mythic() and 3 or 4) then
		self:Bar(args.spellId, self:Mythic() and 31.6 or 35.4, CL.count:format(L.stardust_nova, stardustNovaCount))
	end
end

do
	local prev = 0
	function mod:GravitationalDistortion(args)
		if args.time - prev > 3 then
			prev = args.time
			self:StopBar(CL.count:format(L.gravity, gravityCount))
			gravityCount = gravityCount + 1

			local cd = 0
			if self:GetStage() == 3 then
				cd = timers[3][1234242][gravityCount]
			elseif gravityCount < 3 then -- 2 per platform
				cd = 31.6
			end
			self:Bar(1234242, cd, CL.count:format(L.gravity, gravityCount))

			lastIntermissionCast = "gravity"
			lastIntermissionCastTime = GetTime()
		end
	end
end

function mod:CrushingGravityApplied(args)
	self:GravitationalDistortion(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:InverseGravityApplied(args)
	self:GravitationalDistortion(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:VoidlordDeath(args)
	voidlordKilled = voidlordKilled + 1
	self:StopBar(CL.count:format(CL.adds, conquerorsCrossCount))
	self:StopBar(CL.count:format(CL.tank_frontal, massEjectionCount))
	self:StopBar(CL.count:format(L.mass_destruction, massEjectionCount))
	self:StopBar(CL.count:format(L.stardust_nova, stardustNovaCount))
	self:StopBar(CL.count:format(L.extinction, extinctionCount))
	self:StopBar(CL.count:format(CL.pushback, gammaBurstCount))
	self:StopBar(CL.count:format(L.gravity, gravityCount))
	self:StopBar(CL.full_energy)

	self:Message("stages", "green", CL.mob_killed:format(args.destName, voidlordKilled, 2), false)
	self:PlaySound("stages", "info")

	if self:MobId(args.destGUID) == 245255 then -- Artoshion
		-- Soaring Reshii gets delayed by Dimensius's casts
		local cd = 5.5
		if lastIntermissionCast == "gamma" then
			-- gamma applied + 11
			cd = math.max(cd, 11 + (4 - (GetTime() - lastIntermissionCastTime)))
		elseif lastIntermissionCast == "extinction" then
			-- extinction success + 9.8
			cd = math.max(cd, 9.8 + (5 - (GetTime() - lastIntermissionCastTime)))
		elseif lastIntermissionCast == "gravity" then
			-- gravity removed + 8
			cd = math.max(cd, 8 + (5 - (GetTime() - lastIntermissionCastTime)))
		end
		self:Bar(1235114, cd, L.soaring_reshii) -- Soaring Reshii
	end
end

-- Stage Three: Singularity

function mod:TotalDestruction(args)
	self:SetStage(3)
	self:Message("stages", "cyan", CL.stage:format(3), false)
	self:PlaySound("stages", "long")

	devourCount = 1
	darkenedSkyCount = 1
	cosmicCollapseCount = 1
	supernovaCount = 1
	gravityCount = 1

	-- XXX can vary ~2s? maybe adjust everything in the _YELL?
	self:CDBar(1245292, 15, CL.weakened) -- Destabilized
	self:CDBar(1231716, 32, L.extinguish_the_stars) -- Extinguish the Stars
	self:CDBar(1233539, timers[3][1233539][1], CL.count:format(self:SpellName(1233539), devourCount)) -- Devour
	if self:Mythic() then
		self:CDBar(1234242, timers[3][1234242][1], CL.count:format(self:SpellName(1234242), gravityCount)) -- Gravitational Distortion
	else
		self:CDBar(1232973, timers[3][1232973][1], CL.count:format(self:SpellName(1232973), supernovaCount)) -- Supernova
		self:CDBar(1250055, timers[3][1250055][1], CL.count:format(L.slows, voidgraspCount)) -- Voidgrasp
	end
	self:CDBar(1234263, timers[3][1234263][1], CL.count:format(L.cosmic_collapse, cosmicCollapseCount)) -- Cosmic Collapse
	self:CDBar(1234044, timers[3][1234044][1], CL.count:format(L.darkened_sky, darkenedSkyCount)) -- Darkened Sky
end

function mod:DestabilizedApplied(args)
	self:StopBar(CL.weakened)
	self:Message(args.spellId, "green", CL.weakened)
	self:PlaySound(args.spellId, "long") -- weakened
	self:CastBar(args.spellId, 15, CL.onboss:format(CL.weakened))
end

function mod:DestabilizedRemoved(args)
	self:StopCastBar(CL.onboss:format(CL.weakened))
	self:Message(args.spellId, "green", CL.over:format(CL.weakened))
end

do
	local prev = 0
	function mod:AccretionDiskDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou", nil, args.destName)
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

function mod:ExtinguishTheStars(args)
	self:StopBar(L.extinguish_the_stars)
	self:Message(args.spellId, "red", CL.casting:format(L.extinguish_the_stars))
	self:PlaySound(args.spellId, "warning") -- raid damage / dodge
	self:CastBar(args.spellId, 10, L.extinguish_the_stars)
end

do
	local castingDevour = false

	function mod:GravityWellApplied(args)
		if self:Me(args.destGUID) then
			if castingDevour then
				self:Message(args.spellId, "green", CL.you:format(args.spellName))
				self:PlaySound(args.spellId, "info", nil, args.destName) -- good
			else
				self:PersonalMessage(args.spellId, "underyou")
				self:PlaySound(args.spellId, "underyou", nil, args.destName) -- bad
			end
		end
	end

	function mod:DevourP3(args)
		self:StopBar(CL.count:format(args.spellName, devourCount))
		self:Message(args.spellId, "red", CL.count:format(args.spellName, devourCount))
		self:PlaySound(args.spellId, "warning") -- get safe
		self:CastBar(args.spellId, 7, CL.count:format(args.spellName, devourCount))

		devourCount = devourCount + 1
		self:Bar(args.spellId, timers[3][args.spellId][devourCount], CL.count:format(args.spellName, devourCount))

		castingDevour = true
		-- No repeater, get in late
	end

	function mod:DevourP3Removed()
		if self:Mythic() and devourCount < 3 then
			self:CastBar(1232973, 7, CL.count:format(self:SpellName(1232973), devourCount)) -- Supernova
		end
		castingDevour = false
	end
end

function mod:DarkenedSky()
	self:StopBar(CL.count:format(L.darkened_sky, darkenedSkyCount))
	self:Message(1234044, "yellow", CL.incoming:format(CL.count:format(L.darkened_sky, darkenedSkyCount)))
	self:PlaySound(1234044, "alert")
	darkenedSkyCount = darkenedSkyCount + 1
	self:Bar(1234044, timers[3][1234044][darkenedSkyCount], CL.count:format(L.darkened_sky, darkenedSkyCount))
end

function mod:ShadowquakeApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, 2)
		self:PlaySound(args.spellId, amount == 1 and "info" or "warning", nil, args.destName)
	end
end

function mod:CosmicCollapse(args)
	self:StopBar(CL.count:format(L.cosmic_collapse, cosmicCollapseCount))
	self:Message(args.spellId, "purple", CL.count:format(L.cosmic_collapse, cosmicCollapseCount))
	self:PlaySound(args.spellId, "alert") -- don't be near the tank
	if not self:Easy() then
		self:CastBar(args.spellId, 4)
	end
	cosmicCollapseCount = cosmicCollapseCount + 1
	self:Bar(args.spellId, timers[3][args.spellId][cosmicCollapseCount], CL.count:format(L.cosmic_collapse, cosmicCollapseCount))
end

function mod:CosmicFragilityApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm", nil, args.destName) -- debuffed
	elseif self:Tank() then
		self:PlaySound(args.spellId, "warning") -- taunt?
	end
end

function mod:Supernova(args)
	self:StopBar(CL.count:format(args.spellName, supernovaCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, supernovaCount))
	self:PlaySound(args.spellId, "alert") -- falloff damage on star explosion
	self:CastBar(args.spellId, 6.5, CL.count:format(args.spellName, supernovaCount)) -- 1.5s cast + 5s explosion
	supernovaCount = supernovaCount + 1
	self:Bar(args.spellId, timers[3][args.spellId][supernovaCount], CL.count:format(args.spellName, supernovaCount))
end

do
	local prev = 0
	function mod:VoidgraspApplied(args)
		if args.time - prev > 2 then
			prev = args.time
			self:StopBar(CL.count:format(L.slows, voidgraspCount))
			self:Message(args.spellId, "yellow", CL.count:format(L.slows, voidgraspCount))
			voidgraspCount = voidgraspCount + 1
			self:Bar(args.spellId, timers[3][args.spellId][voidgraspCount], CL.count:format(L.slows, voidgraspCount))
		end
		if self:Me(args.destGUID) then
			prev = args.time
			self:PersonalMessage(args.spellId, nil, L.slow)
			self:PlaySound(args.spellId, "alarm", nil, args.destName) -- slowed
		end
	end
end

function mod:HoldTheLine(args)
	-- "<573.29 15:49:15> [CLEU] SPELL_AURA_REMOVED#Creature-0-4227-2810-9523-244534-00001FB17E#Xal'atath#Creature-0-4227-2810-9523-244534-00001FB17E#Xal'atath#1240533#Hold The Line#BUFF#nil#nil#nil#nil#nil",
	-- "<590.76 15:49:32> [ENCOUNTER_END] 3135#Dimensius, the All-Devouring#15#30#1",
	if self:MobId(args.sourceGUID) == 244534 then -- Xal'atath
		-- Stop bars during the victory RP
		self:SendMessage("BigWigs_StopAllBars", self)
	end
end
