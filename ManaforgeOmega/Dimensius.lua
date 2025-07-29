if not BigWigsLoader.isNext then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Dimensius, the All-Devouring", 2810, 2691)
if not mod then return end
mod:RegisterEnableMob(241517, 234478, 233824) -- XXX Confirm
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
local reverseGravityCount = 1

local collectiveGravityOnMe = false
local collectiveGravityStacksOnMe = 0
local growingHungerOnBoss = 0

local extinctionCount = 1
local gammaBurstCount = 1
local massEjectionCount = 1
local conquerorsCrossCount = 1
local stardustNovaCount = 1

local darkenedSkyCount = 1
local cosmicCollapseCount = 1
local supernovaCount = 1
local voidgraspCount = 1

-- When we start filling this table, uncomment the timer bars in the spell's functions :)
local timers = {
	[1] = {
		[1230087] = {}, -- Massive Smash
		[1229038] = {}, -- Devour (P1)
		[1230979] = {}, -- Dark Matter
		[1243690] = {}, -- Shattered Space
		[1243577] = {}, -- Reverse Gravity
	},
	[3] = {
		[1233539] = {}, -- Devour (P3)
		[1234044] = {}, -- Darkened Sky
		[1234263] = {}, -- Cosmic Collapse
		[1232973] = {}, -- Supernova
		[1250055] = {}, -- Voidgrasp
	}
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.shattered_space = "Hands" -- Dimensius reaches down with both hands
	L.reverse_gravity = "Gravity" -- Short for Reverse Gravity
	L.extinction = "Fragment" -- Dimensius hurls a fragment of a broken world
	L.slows = "Slows"
	L.slow = "Slow" -- Singular of Slows
	L.stardust_nova = "Nova" -- Short for Stardust Nova
	L.extinguish_the_stars = "Stars" -- Short for Extinguish the Stars
	L.darkened_sky = "Rings"
	L.cosmic_collapse = "Collapse" -- Short for Cosmic Collapse
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:SetSpellRename(1230087, CL.smash) -- Massive Smash (Smash)
	self:SetSpellRename(1230979, CL.spread) -- Dark Matter (Spread)
	self:SetSpellRename(1243690, L.shattered_space) -- Shattered Space (Hands)
	self:SetSpellRename(1243699, CL.stunned) -- Spatial Fragment (Stunned)
	self:SetSpellRename(1243577, L.reverse_gravity) -- Reverse Gravity (Gravity)

	self:SetSpellRename(1238765, L.extinction) -- Extinction (Fragment)
	self:SetSpellRename(1237319, CL.pushback) -- Gamma Burst (Pushback)
	self:SetSpellRename(1237694, CL.frontal_cone) -- Mass Ejection (Frontal Cone)
	self:SetSpellRename(1239262, CL.adds) -- Conqueror's Cross (Adds)
	self:SetSpellRename(1246541, L.slow) -- Null Binding (Slow)
	self:SetSpellRename(1237695, L.stardust_nova) -- Stardust Nova (Nova)

	self:SetSpellRename(1245292, CL.weakened) -- Destabilized (Weakening)
	self:SetSpellRename(1231716, L.extinguish_the_stars) -- Extinguish the Stars (Stars)
	self:SetSpellRename(1234044, L.darkened_sky) -- Darkened Sky (Rings)
	self:SetSpellRename(1234263, L.cosmic_collapse) -- Cosmic Collapse (Collapse)\
	self:SetSpellRename(1250055, L.slows) -- Voidgrasp (Slows)
end

function mod:GetOptions()
	return {
		-- Stage One: Critical Mass
			-- 1229327, -- Oblivion
			1230087, -- Massive Smash
				-- Living Mass
					-- 1231005, -- Fission
					{1228206, "ME_ONLY_EMPHASIZE"}, -- Excess Mass
						1228207, -- Collective Gravity
				{1230168, "TANK"}, -- Mortal Fragility
			1229038, -- Devour (P1)
				-- 1229674, -- Growing Hunger
			1230979, -- Dark Matter
				1231002, -- Dark Energy
			1243690, -- Shattered Space
				1243702, -- Antimatter
				1243699, -- Spatial Fragment
			{1243577, "SAY", "SAY_COUNTDOWN"}, -- Reverse Gravity
				1243609, -- Airborne
			-- 1227665, -- Fists of the Voidlord XXX Can we warn when you got hit by the knockback?
			-- 1228367, -- Cosmic Radiation
		-- Intermission: Event Horizon
			-- Xal'atath
				1235114, -- Soaring Reshii
				-- 1235467, -- Umbral Gate XXX Notify when Soaring Reshii is refreshed?
			-- 1241188, -- Endless Darkness
			-- 1237080, -- Broken World
			1237097, -- Astrophysical Jet
			-- 1232987, -- Black Hole
				1230674, -- Spaghettification
			1246930, -- Stellar Core
		-- Stage Two: The Dark Heart
			1238765, -- Extinction
			1237319, -- Gamma Burst
			-- The Devoured Lords
				1237690, -- Eclipse
				-- Artoshion
					1237694, -- Mass Ejection
						1237696, -- Debris Field
					1239262, -- Conqueror's Cross
						-- Voidwarden
							1239270, -- Voidwarding
							-- 1246537, -- Entropic Unity
						-- Nullbinder
							1246541, -- Null Binding
					{1246145, "TANK"}, -- Touch of Oblivion
				-- Pargoth
					1237695, -- Stardust Nova
		-- Stage Three: Singularity
			1245292, -- Destabilized
			1233292, -- Accretion Disk
			{1231716, "CASTBAR"}, -- Extinguish the Stars
				1232394, -- Gravity Well
			1233539, -- Devour (P3)
				-- 1233557, -- Density
			1234044, -- Darkened Sky
				1234054, -- Shadowquake
			1234263, -- Cosmic Collapse
				{1234266, "TANK"}, -- Cosmic Fragility
			{1232973, "CASTBAR"}, -- Supernova
			1250055, -- Voidgrasp
	},{
		{
			tabName = CL.stage:format(1),
			{1230087, 1228206, 1228207, 1230168, 1229038, 1230979, 1231002, 1243690, 1243702, 1243699, 1243577, 1243609},
		},
		{
			tabName = CL.intermission,
			{1235114, 1237097, 1230674, 1246930},
		},
		{
			tabName = CL.stage:format(2),
			{1238765, 1237319, 1237690, 1237694, 1237696, 1239262, 1239270, 1246541, 1246145, 1237695},
		},
		{
			tabName = CL.stage:format(3),
			{1245292, 1233292, 1231716, 1232394, 1233539, 1234044, 1234054, 1234263, 1234266, 1232973, 1230674, 1250055},
		},
	},{
		[1230087] = CL.smash, -- Massive Smash (Smash)
		[1230979] = CL.spread, -- Dark Matter (Spread)
		[1243690] = L.shattered_space, -- Shattered Space (Hands)
		[1243699] = CL.stunned, -- Spatial Fragment (Stunned)
		[1243577] = L.reverse_gravity, -- Reverse Gravity (Gravity)
		[1238765] = L.extinction, -- Extinction (Fragment)
		[1237319] = CL.pushback, -- Gamma Burst (Pushback)
		[1237694] = CL.frontal_cone, -- Mass Ejection (Frontal Cone)
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
	-- Stage One: Critical Mass
	self:Log("SPELL_CAST_START", "MassiveSmash", 1230087)
	self:Log("SPELL_AURA_APPLIED", "ExcessMassApplied", 1228206)
	self:Log("SPELL_AURA_APPLIED", "CollectiveGravityApplied", 1228207)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CollectiveGravityApplied", 1228207)
	self:Log("SPELL_AURA_REMOVED_DOSE", "CollectiveGravityRemoved", 1228207)
	self:Log("SPELL_AURA_REMOVED", "CollectiveGravityRemoved", 1228207)
	self:Log("SPELL_AURA_APPLIED", "MortalFragilityApplied", 1230168)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MortalFragilityApplied", 1230168)
	self:Log("SPELL_CAST_START", "DevourP1", 1229038)
	self:Log("SPELL_AURA_REMOVED", "DevourP1Removed", 1229038) -- Channel Over
	self:Log("SPELL_AURA_APPLIED", "GrowingHungerApplied", 1229674)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GrowingHungerApplied", 1229674)
	self:Log("SPELL_CAST_START", "DarkMatter", 1230979)
	self:Log("SPELL_AURA_APPLIED", "DarkEnergyDamage", 1231002)
	self:Log("SPELL_PERIODIC_DAMAGE", "DarkEnergyDamage", 1231002)
	self:Log("SPELL_PERIODIC_MISSED", "DarkEnergyDamage", 1231002)
	self:Log("SPELL_CAST_START", "ShatteredSpace", 1243690)
	self:Log("SPELL_DAMAGE", "AntimatterHit", 1243702)
	self:Log("SPELL_MISSED", "AntimatterHit", 1243702)
	self:Log("SPELL_AURA_APPLIED", "SpatialFragmentApplied", 1243699)
	self:Log("SPELL_AURA_APPLIED", "ReverseGravityApplied", 1243577)
	self:Log("SPELL_AURA_REMOVED", "ReverseGravityRemoved", 1243577)
	self:Log("SPELL_AURA_APPLIED", "AirborneApplied", 1243609)
	self:Log("SPELL_AURA_REMOVED", "AirborneRemoved", 1243609)

	-- Intermission: Event Horizon
	self:Log("SPELL_AURA_APPLIED", "SoaringReshiiApplied", 1235114)
	self:Log("SPELL_AURA_APPLIED", "AstrophysicalJetDamage", 1237097)
	self:Log("SPELL_PERIODIC_DAMAGE", "AstrophysicalJetDamage", 1237097)
	self:Log("SPELL_PERIODIC_MISSED", "AstrophysicalJetDamage", 1237097)
	self:Log("SPELL_AURA_APPLIED", "SpaghettificationApplied", 1230674)
	self:Log("SPELL_AURA_APPLIED", "StellarCoreApplied", 1246930)

	-- Stage Two: The Dark Heart
	self:Log("SPELL_CAST_START", "Extinction", 1238765)
	self:Log("SPELL_CAST_START", "GammaBurst", 1237319)

	-- The Devoured Lords
	self:Log("SPELL_CAST_SUCCESS", "Eclipse", 1237690)

	-- Artoshion & Pargoth
	self:Log("SPELL_CAST_START", "MassEjection", 1237694)
	self:Log("SPELL_AURA_APPLIED", "DebrisFieldDamage", 1237696)
	self:Log("SPELL_PERIODIC_DAMAGE", "DebrisFieldDamage", 1237696)
	self:Log("SPELL_PERIODIC_MISSED", "DebrisFieldDamage", 1237696)
	self:Log("SPELL_CAST_START", "ConquerorsCross", 1239262)
	self:Log("SPELL_AURA_APPLIED", "VoidwardingApplied", 1239270)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VoidwardingApplied", 1239270)
	self:Log("SPELL_CAST_START", "NullBinding", 1246541)
	self:Log("SPELL_AURA_APPLIED", "TouchOfOblivionApplied", 1246145)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TouchOfOblivionApplied", 1246145)
	self:Log("SPELL_CAST_START", "StardustNova", 1237695)

	-- Stage Three: Singularity
	self:Log("SPELL_AURA_APPLIED", "Destabilized", 1245292)
	self:Log("SPELL_DAMAGE", "AccretionDiskDamage", 1233292)
	self:Log("SPELL_MISSED", "AccretionDiskDamage", 1233292)
	self:Log("SPELL_CAST_SUCCESS", "ExtinguishTheStars", 1231716)
	self:Log("SPELL_AURA_APPLIED", "GravityWellApplied", 1232394)
	self:Log("SPELL_AURA_REMOVED", "GravityWellRemoved", 1232394)
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
end

function mod:OnEngage()
	self:SetStage(1)

	massiveSmashCount = 1
	devourCount = 1
	darkMatterCount = 1
	shatteredSpaceCount = 1
	reverseGravityCount = 1

	collectiveGravityStacksOnMe = 0
	growingHungerOnBoss = 0

	-- self:Bar(1230087, timers[1][1230087][massiveSmashCount], CL.count:format(CL.smash, massiveSmashCount)) -- Massive Smash
	-- self:Bar(1229038, timers[1][1229038][devourCount], CL.count:format(self:SpellName(1229038), devourCount)) -- Devour
	-- self:Bar(1230979, timers[1][1230979][darkMatterCount], CL.count:format(CL.spread, darkMatterCount)) -- Dark Matter
	-- self:Bar(1243690, timers[1][1243690][shatteredSpaceCount], CL.count:format(L.shattered_space, shatteredSpaceCount)) -- Shattered Space
	-- self:Bar(1243577, timers[1][1243577][reverseGravityCount], CL.count:format(L.reverse_gravity, reverseGravityCount)) -- Reverse Gravity

	-- Stage 2
	extinctionCount = 1
	gammaBurstCount = 1
	massEjectionCount = 1
	conquerorsCrossCount = 1
	stardustNovaCount = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: Critical Mass
function mod:MassiveSmash(args)
	self:Message(args.spellId, "purple", CL.count:format(CL.smash, massiveSmashCount))
	self:PlaySound(args.spellId, "long") -- big tank hit + adds + knockback
	massiveSmashCount = massiveSmashCount + 1
	-- self:Bar(args.spellId, timers[1][args.spellId][massiveSmashCount], CL.count:format(CL.smash, massiveSmashCount))
end

function mod:ExcessMassApplied(args)
	self:TargetMessage(args.spellId, "green", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "info") -- carrying excess mass
	end
end

function mod:CollectiveGravityApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, "underyou")
		self:PlaySound(args.spellId, "underyou")
		collectiveGravityOnMe = true
		collectiveGravityStacksOnMe = args.amount or 1
	end
end

function mod:CollectiveGravityRemoved(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 0
		if amount > 0 then
			collectiveGravityStacksOnMe = amount
		else
			collectiveGravityOnMe = false
		end
	end
end

function mod:MortalFragilityApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- debuffed
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
		if collectiveGravityOnMe then return end -- safe! (maybe)

		if collectiveGravityOnMe and collectiveGravityStacksOnMe < growingHungerOnBoss then
			-- Confirm if this works, then remove the maybe check above.
			return -- safe!
		end

		mod:Message(1228207, "blue", CL.no:format(collectiveGravitySpellName))
		mod:PlaySound(1228207, "warning") -- no collective gravity
		collectiveGravityCheck = mod:ScheduleTimer(checkForCollectiveGravity, 1)
	end

	function mod:DevourP1(args)
		self:Message(args.spellId, "red", CL.count:format(args.spellName, devourCount))
		self:PlaySound(args.spellId, "warning") -- get safe
		devourCount = devourCount + 1
		-- self:Bar(args.spellId, timers[1][args.spellId][devourCount], CL.count:format(args.spellName, devourCount))
		collectiveGravityCheck = mod:ScheduleTimer(checkForCollectiveGravity, 2.5) -- check last 4~ seconds
	end

	function mod:DevourP1Removed()
		if collectiveGravityCheck then
			mod:CancelTimer(collectiveGravityCheck)
			collectiveGravityCheck = nil
		end
	end
end

function mod:GrowingHungerApplied(args)
	growingHungerOnBoss = args.amount or 1
end

function mod:DarkMatter(args)
	self:Message(args.spellId, "orange", CL.count:format(CL.spread, darkMatterCount))
	self:PlaySound(args.spellId, "alert") -- spread
	darkMatterCount = darkMatterCount + 1
	-- self:Bar(args.spellId, timers[1][args.spellId][darkMatterCount], CL.count:format(CL.spread, darkMatterCount))
end

do
	local prev = 0
	function mod:DarkEnergyDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

function mod:ShatteredSpace(args)
	self:Message(args.spellId, "yellow", CL.count:format(L.shattered_space, shatteredSpaceCount))
	self:PlaySound(args.spellId, "alert") -- move away from hands
	shatteredSpaceCount = shatteredSpaceCount + 1
	-- self:Bar(args.spellId, timers[1][args.spellId][shatteredSpaceCount], CL.count:format(L.shattered_space, shatteredSpaceCount))
end

function mod:AntimatterHit(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, "underyou")
		self:PlaySound(args.spellId, "underyou") -- soaking, but do notify
	end
end

function mod:SpatialFragmentApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "blue", CL.stunned) -- "Stun on YOU!" better?
		self:PlaySound(args.spellId, "warning") -- stunned
	end
end

do
	local prev = 0
	function mod:ReverseGravityApplied(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Message(args.spellId, "yellow", CL.count:format(L.reverse_gravity, reverseGravityCount))
			-- Not using targetsmessage because it read as it if's cast multiple times in succession fast for now
			-- sound for targetted players only
			reverseGravityCount = reverseGravityCount + 1
			-- self:Bar(args.spellId, timers[1][args.spellId][reverseGravityCount], CL.count:format(L.reverse_gravity, reverseGravityCount))
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId, nil, L.reverse_gravity)
			self:PlaySound(args.spellId, "warning") -- move
			self:Say(args.spellId, L.reverse_gravity, nil, "Gravity")
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
		self:PlaySound(args.spellId, "alarm") -- airborne
	end
end

function mod:AirborneRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info") -- back on the ground
	end
end

-- Intermission: Event Horizon
function mod:SoaringReshiiApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.flying_available)
		self:PlaySound(args.spellId, "info")
	end
end

do
	local prev = 0
	function mod:AstrophysicalJetDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

do
	local playerList = {}
	local prev = 0
	function mod:SpaghettificationApplied(args)
		if args.time - prev > 2 then
			prev = args.time
			playerList = {}
		end
		playerList[#playerList + 1] = args.destName
		self:TargetsMessage(args.spellId, "cyan", playerList)
	end
end

function mod:StellarCoreApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info")
	end
end

-- Stage Two: The Dark Heart
function mod:Extinction(args)
	self:Message(args.spellId, "orange", CL.count:format(L.extinction, extinctionCount))
	self:PlaySound(args.spellId, "alarm") -- dodge fragment
	extinctionCount = extinctionCount + 1
	-- self:Bar(args.spellId, timers[2][args.spellId][extinctionCount], CL.count:format(L.extinction, extinctionCount))
end

function mod:GammaBurst(args)
	self:Message(args.spellId, "red", CL.count:format(CL.pushback, gammaBurstCount))
	self:PlaySound(args.spellId, "long") -- pushback inc
	gammaBurstCount = gammaBurstCount + 1
	-- self:Bar(args.spellId, timers[2][args.spellId][gammaBurstCount], CL.count:format(CL.pushback, gammaBurstCount))
end

-- The Devoured Lords
function mod:Eclipse(args)
	self:Message(args.spellId, "cyan", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "info") -- long channel started
end

-- Artoshion & Pargoth
function mod:MassEjection(args)
	self:Message(args.spellId, "yellow", CL.casting:format(CL.frontal_cone))
	self:PlaySound(args.spellId, "alert") -- dodge frontal
	massEjectionCount = massEjectionCount + 1
	-- self:Bar(args.spellId, 20, CL.count:format(CL.frontal_cone, massEjectionCount))
end

do
	local prev = 0
	function mod:DebrisFieldDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PersonalMessage(args.spellId, "underyou")
			self:PlaySound(args.spellId, "underyou")
		end
	end
end

function mod:ConquerorsCross(args)
	self:Message(args.spellId, "orange", CL.count:format(CL.adds, conquerorsCrossCount))
	self:PlaySound(args.spellId, "alert") -- adds/walls incoming
	conquerorsCrossCount = conquerorsCrossCount + 1
	-- self:Bar(args.spellId, 50, CL.count:format(CL.adds, conquerorsCrossCount))
end

function mod:VoidwardingApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
		self:PlaySound(args.spellId, "underyou") -- avoidable / standing in it
	end
end

function mod:NullBinding(args)
	self:Message(args.spellId, "yellow", CL.casting:format(L.slow))
	self:PlaySound(args.spellId, "alarm") -- slows incoming!
	-- self:Bar(args.spellId, 20, L.slow)
end

function mod:TouchOfOblivionApplied(args)
	local amount = args.amount or 1
	local highStacks = self:Mythic() and 7 or 12
	self:StackMessage(args.spellId, "blue", args.destName, amount, highStacks)
	if self:Me(args.destGUID) and (amount % 2 == 1 or amount >= highStacks) then
		self:PlaySound(args.spellId, amount >= highStacks and "warning" or "info") -- care above 6
	elseif amount >= highStacks then
		self:PlaySound(args.spellId, "warning") -- taunt?
	end
end

function mod:StardustNova(args)
	self:Message(args.spellId, "orange", CL.count:format(L.stardust_nova, stardustNovaCount))
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:UnitWithinRange(unit, 20) then -- radius is 10, using 20 to be safe.
		self:PlaySound(args.spellId, "alarm") -- move out of melee
	end
	stardustNovaCount = stardustNovaCount + 1
	-- self:Bar(args.spellId, 40, CL.count:format(L.stardust_nova, stardustNovaCount))
end

-- Stage Three: Singularity
function mod:Destabilized(args)
	self:Message(args.spellId, "green", CL.weakened)
	self:PlaySound(args.spellId, "long") -- weakened
	self:Bar(args.spellId, 15, CL.weakened)

	-- XXX TEMP, unless there is no better event. Lol.
	local stage = self:GetStage()
	if stage ~= 3 then
		self:SetStage(3)

		devourCount = 1
		darkenedSkyCount = 1
		cosmicCollapseCount = 1
		supernovaCount = 1

		-- self:Bar(1231716, 10, L.extinguish_the_stars) -- Extinguish the Stars
		-- self:Bar(1234044, timers[3][1234044][darkenedSkyCount], CL.count:format(L.darkened_sky, darkenedSkyCount)) -- Darkened Sky
		-- self:Bar(1234263, timers[3][1234263][cosmicCollapseCount], CL.count:format(L.cosmic_collapse, cosmicCollapseCount)) -- Cosmic Collapse
		-- self:Bar(1233539, timers[3][1233539][devourCount], CL.count:format(self:SpellName(1233539), devourCount)) -- Devour
		-- self:Bar(1232973, timers[3][1232973][supernovaCount], CL.count:format(self:SpellName(1232973), supernovaCount)) -- Supernova
	end
end

do
	local prev = 0
	function mod:AccretionDiskDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

function mod:ExtinguishTheStars(args)
	self:Message(args.spellId, "red", CL.casting:format(L.extinguish_the_stars))
	self:PlaySound(args.spellId, "warning") -- raid damage / dodge
	self:CastBar(args.spellId, 10, L.extinguish_the_stars)
end

do
	local gravityWellOnMe, castingDevour = false, false
	local gravityWellCheck, gravityWellSpellName = nil, mod:SpellName(1232394) -- Gravity Well

	local function checkForGravityWell()
		if gravityWellCheck then
			mod:CancelTimer(gravityWellCheck)
			gravityWellCheck = nil
		end
		if gravityWellOnMe then return end -- safe!

		mod:Message(1232394, "blue", CL.no:format(gravityWellSpellName))
		mod:PlaySound(1232394, "warning") -- no gravity well
		gravityWellCheck = mod:ScheduleTimer(checkForGravityWell, 1)
	end

	function mod:GravityWellApplied(args)
		if self:Me(args.destGUID) then
			if castingDevour then
				self:Message(args.spellId, "green", CL.you:format(args.spellName))
				self:PlaySound(args.spellId, "info") -- good
			else
				self:PersonalMessage(args.spellId, "underyou")
				self:PlaySound(args.spellId, "underyou") -- bad
			end
			gravityWellOnMe = true
		end
	end

	function mod:GravityWellRemoved(args)
		if self:Me(args.destGUID) then
			gravityWellOnMe = false
		end
	end

	function mod:DevourP3(args)
		self:Message(args.spellId, "red", CL.count:format(args.spellName, devourCount))
		self:PlaySound(args.spellId, "warning") -- get safe
		devourCount = devourCount + 1
		-- self:Bar(args.spellId, timers[3][args.spellId][devourCount], CL.count:format(args.spellName, devourCount))
		castingDevour = true
		gravityWellCheck = mod:ScheduleTimer(checkForGravityWell, 4.5) -- check last 2~ seconds
	end

	function mod:DevourP3Removed()
		castingDevour = false
	end
end

function mod:DarkenedSky(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, darkenedSkyCount))
	self:PlaySound(args.spellId, "alert")
	darkenedSkyCount = darkenedSkyCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, darkenedSkyCount))
end

function mod:ShadowquakeApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, 2)
		self:PlaySound(args.spellId, amount == 1 and "info" or "warning")
	end
end

function mod:CosmicCollapse(args)
	self:Message(args.spellId, "purple", CL.count:format(L.cosmic_collapse, cosmicCollapseCount))
	self:PlaySound(args.spellId, "alert") -- don't be near the tank
	cosmicCollapseCount = cosmicCollapseCount + 1
	-- self:Bar(args.spellId, timers[3][args.spellId][cosmicCollapseCount], CL.count:format(L.cosmic_collapse, cosmicCollapseCount))
end

function mod:CosmicFragilityApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- debuffed
	elseif self:Tank() then
		self:PlaySound(args.spellId, "warning") -- taunt?
	end
end

function mod:Supernova(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, supernovaCount))
	self:PlaySound(args.spellId, "alert") -- falloff damage on star explosion
	self:CastBar(args.spellId, self:Mythic() and 8.5 or 6.5, CL.count:format(args.spellName, supernovaCount)) -- 1.5s cast + 5s explosion (7s on Mythic)
	supernovaCount = supernovaCount + 1
	-- self:Bar(args.spellId, timers[3][args.spellId][supernovaCount], CL.count:format(args.spellName, supernovaCount))
end

do
	local prev = 0
	function mod:VoidgraspApplied(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Message(args.spellId, "yellow", CL.count:format(L.slows, voidgraspCount))
			voidgraspCount = voidgraspCount + 1
			-- self:Bar(args.spellId, timers[3][args.spellId][voidgraspCount], CL.count:format(L.slows, voidgraspCount))
		end
		if self:Me(args.destGUID) then
			prev = args.time
			self:PersonalMessage(args.spellId, nil, L.slow)
			self:PlaySound(args.spellId, "alarm") -- slowed
		end
	end
end
