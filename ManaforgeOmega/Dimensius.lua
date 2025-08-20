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

local voidlordKilled = 0
local artoshionKilled = false
local extinctionCount = 1
local gammaBurstCount = 1
local massEjectionCount = 1
local conquerorsCrossCount = 1
local stardustNovaCount = 1

local darkenedSkyCount = 1
local cosmicCollapseCount = 1
local supernovaCount = 1
local voidgraspCount = 1

local timersEasy = {
	[1] = {
		[1230087] = {25, 50, 50, 50}, -- Massive Smash
		[1229038] = {12.5, 100, 100}, -- Devour (P1)
		[1230979] = {37.5, 46.3, 53.7, 46.2}, -- Dark Matter
		[1243690] = {43.7, 50, 50, 50}, -- Shattered Space
		[1243577] = {56.3, 45, 55, 45}, -- Reverse Gravity
	},
	[3] = {
		[1233539] = {47.3, 100}, -- Devour (P3)
		[1234044] = {81, 33.3, 66.6, 33.3, 33.3}, -- Darkened Sky
		[1234263] = {69.6, 33.3, 33.3, 33.3, 33.3, 33.3}, -- Cosmic Collapse
		[1232973] = {56.3, 14.5, 33.3, 33.3, 18.9, 14.5, 33.3}, -- Supernova
		[1250055] = {60.7, 33.3, 33.3, 33.3, 33.3, 33.3, 33.3, 33.3, 33.3}, -- Voidgrasp
	}
}

local timersHeroic = {
	[1] = {
		[1230087] = {23.5, 47.0, 47.0, 47.0}, -- Massive Smash
		[1229038] = {11.7, 94.0, 94.0}, -- Devour (P1)
		[1230979] = {35.3, 43.5, 50.5, 43.5}, -- Dark Matter
		[1243690] = {47.7, 47.0, 47.0, 47.0}, -- Shattered Space
		[1243577] = {52.9, 42.3, 51.7, 42.3}, -- Reverse Gravity
	},
	[3] = {
		[1233539] = {47.3, 100.0, 100.0}, -- Devour (P3)
		[1234044] = {30.0, 51.1, 33.3, 66.6, 33.3}, -- Darkened Sky
		[1234263] = {65.3, 33.3, 33.3, 33.3, 33.3, 33.3}, -- Cosmic Collapse
		[1232973] = {56.3, 14.5, 33.3, 33.3, 18.9, 14.5, 33.3}, -- Supernova
		[1250055] = {60.7, 33.3, 33.3, 33.3, 33.3, 33.3, 33.3, 33.3, 33.3}, -- Voidgrasp
	}
}

local timers = mod:Easy() and timersEasy or timersHeroic

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.reverse_gravity = "Gravity" -- Short for Reverse Gravity
	L.extinction = "Fragment" -- Dimensius hurls a fragment of a broken world
	L.slows = "Slows"
	L.slow = "Slow" -- Singular of Slows
	L.stardust_nova = "Nova" -- Short for Stardust Nova
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
	self:SetSpellRename(1243577, L.reverse_gravity) -- Reverse Gravity (Gravity)

	self:SetSpellRename(1238765, L.extinction) -- Extinction (Fragment)
	self:SetSpellRename(1237325, CL.pushback) -- Gamma Burst (Pushback)
	self:SetSpellRename(1237694, CL.frontal_cone) -- Mass Ejection (Frontal Cone)
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
			1237325, -- Gamma Burst
			-- The Devoured Lords
				-- 1237690, -- Eclipse
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
			{1245292, "CASTBAR", "COUNTDOWN"}, -- Destabilized
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
			tabName = CL.general,
			{"stages"}
		},
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
			{1238765, 1237325, 1237694, 1237696, 1239262, 1239270, 1246541, 1246145, 1237695},
		},
		{
			tabName = CL.stage:format(3),
			{1245292, 1233292, 1231716, 1232394, 1233539, 1234044, 1234054, 1234263, 1234266, 1232973, 1230674, 1250055},
		},
	},{
		[1230087] = CL.smash, -- Massive Smash (Smash)
		[1230979] = CL.spread, -- Dark Matter (Spread)
		[1243690] = CL.soaks, -- Shattered Space (Soaks)
		[1243699] = CL.stunned, -- Spatial Fragment (Stunned)
		[1243577] = L.reverse_gravity, -- Reverse Gravity (Gravity)
		[1238765] = L.extinction, -- Extinction (Fragment)
		[1237325] = CL.pushback, -- Gamma Burst (Pushback)
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
	self:RegisterUnitEvent("UNIT_SPELLCAST_START", nil, "boss1", "boss2") -- Shattered Space, Gamma Burst
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

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
	self:Log("SPELL_CAST_START", "EventHorizon", 1234898) -- End of P1

	-- Intermission: Event Horizon
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
	-- self:Log("SPELL_AURA_REMOVED", "EclipseRemoved", 1237690)

	-- Artoshion & Pargoth
	self:Log("SPELL_CAST_START", "MassEjection", 1237694)
	self:Log("SPELL_AURA_APPLIED", "DebrisFieldDamage", 1237696)
	self:Log("SPELL_PERIODIC_DAMAGE", "DebrisFieldDamage", 1237696)
	self:Log("SPELL_PERIODIC_MISSED", "DebrisFieldDamage", 1237696)
	self:Log("SPELL_CAST_START", "ConquerorsCross", 1239262)
	self:Log("SPELL_AURA_APPLIED", "VoidwardingApplied", 1239270)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VoidwardingApplied", 1239270)
	self:Log("SPELL_CAST_SUCCESS", "NullBinding", 1246541)
	self:Log("SPELL_AURA_APPLIED", "TouchOfOblivionApplied", 1246145)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TouchOfOblivionApplied", 1246145)
	self:Log("SPELL_CAST_START", "StardustNova", 1237695)
	self:Death("VoidlordDeath", 245255, 245222) -- Artoshion & Pargoth

	-- Stage Three: Singularity
	self:Log("SPELL_AURA_APPLIED", "Destabilized", 1245292)
	self:Log("SPELL_DAMAGE", "AccretionDiskDamage", 1233292)
	self:Log("SPELL_MISSED", "AccretionDiskDamage", 1233292)
	self:Log("SPELL_CAST_SUCCESS", "ExtinguishTheStars", 1231716)
	self:Log("SPELL_AURA_APPLIED", "GravityWellApplied", 1232394)
	self:Log("SPELL_CAST_START", "DevourP3", 1233539)
	self:Log("SPELL_AURA_REMOVED", "DevourP3Removed", 1233539) -- Channel Over
	-- self:Log("SPELL_CAST_START", "DarkenedSky", 1234044) -- Have to use the emote, not all have a cast.
	self:Log("SPELL_AURA_APPLIED", "ShadowquakeApplied", 1234054)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShadowquakeApplied", 1234054)
	self:Log("SPELL_CAST_START", "CosmicCollapse", 1234263)
	self:Log("SPELL_AURA_APPLIED", "CosmicFragilityApplied", 1234266)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CosmicFragilityApplied", 1234266)
	self:Log("SPELL_CAST_START", "Supernova", 1232973)
	self:Log("SPELL_AURA_APPLIED", "VoidgraspApplied", 1250055)

	timers = mod:Easy() and timersEasy or timersHeroic
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

	self:Bar(1230087, timers[1][1230087][massiveSmashCount], CL.count:format(CL.smash, massiveSmashCount)) -- Massive Smash
	self:Bar(1229038, timers[1][1229038][devourCount], CL.count:format(self:SpellName(1229038), devourCount)) -- Devour
	self:Bar(1230979, timers[1][1230979][darkMatterCount], CL.count:format(CL.spread, darkMatterCount)) -- Dark Matter
	self:Bar(1243690, timers[1][1243690][shatteredSpaceCount], CL.count:format(CL.soaks, shatteredSpaceCount)) -- Shattered Space
	self:Bar(1243577, timers[1][1243577][reverseGravityCount], CL.count:format(L.reverse_gravity, reverseGravityCount)) -- Reverse Gravity
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
		self:Bar(1245292, {8.7, 14.5}, CL.soon:format(CL.weakened)) -- Correct it with more precision
	end
end

do
	local prev = 0
	function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
		-- |TInterface\\\\ICONS\\\\INV_112_RaidDimensius_DarkenedSky.BLP:20|t %s casts |cFFFF0000|Hspell:1234052|h[Darkened Sky]|h|r!#Dimensius###Dimensius##0#0##0#4880#nil#0#false#false#false#false",
		if msg:find("spell:1234052", nil, true) then
			local time = GetTime()
			if time - prev > 2 then
				prev = time
				self:DarkenedSky() -- Using emote as first cast has no cast...
			end
		end
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
	self:TargetMessage(args.spellId, "green", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "info", nil, args.destName) -- carrying excess mass
	end
end

function mod:CollectiveGravityApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, "underyou")
		self:PlaySound(args.spellId, "underyou", nil, args.destName)
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
		if collectiveGravityOnMe or mod:UnitIsDeadOrGhost("player") then return end -- safe! (or death)

		mod:Message(1228207, "blue", CL.no:format(collectiveGravitySpellName))
		mod:PlaySound(1228207, "warning") -- no collective gravity
		collectiveGravityCheck = mod:ScheduleTimer(checkForCollectiveGravity, 1)
	end

	function mod:DevourP1(args)
		self:StopBar(CL.count:format(args.spellName, devourCount))
		self:Message(args.spellId, "red", CL.count:format(args.spellName, devourCount))
		self:PlaySound(args.spellId, "warning") -- get safe
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
			self:StopBar(CL.count:format(L.reverse_gravity, reverseGravityCount))
			self:Message(args.spellId, "yellow", CL.count:format(L.reverse_gravity, reverseGravityCount))
			-- Not using targetsmessage because it read as it if's cast multiple times in succession fast for now
			-- sound for targetted players only
			reverseGravityCount = reverseGravityCount + 1
			self:Bar(args.spellId, timers[1][args.spellId][reverseGravityCount], CL.count:format(L.reverse_gravity, reverseGravityCount))
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId, nil, L.reverse_gravity)
			self:PlaySound(args.spellId, "warning", nil, args.destName) -- move
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
	self:StopBar(CL.count:format(L.reverse_gravity, reverseGravityCount)) -- Reverse Gravity

	self:Message("stages", "yellow", CL.intermission, args.spellId)
	self:PlaySound("stages", "long") -- staging
	self:SetStage(1.5)

	voidlordKilled = 0
	artoshionKilled = false
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
		self:PlaySound(args.spellId, "info", nil, args.destName)
	end
end

-- Stage Two: The Dark Heart
function mod:WorldsoulConsumptionApplied(args)
	self:SetStage(2)

	conquerorsCrossCount = 1
	massEjectionCount = 1
	stardustNovaCount = 1
	extinctionCount = 1
	gammaBurstCount = 1

	self:CDBar(1238765, artoshionKilled and 30.5 or 26.2, CL.count:format(L.extinction, extinctionCount))
	self:CDBar(1237325, artoshionKilled and 44.8 or 40.0, CL.count:format(CL.pushback, gammaBurstCount))

	self:CDBar(1239262, 14, CL.count:format(CL.adds, conquerorsCrossCount))
	if not artoshionKilled then
		self:CDBar(1237694, 21.5, CL.count:format(CL.frontal_cone, massEjectionCount))
	else
		self:CDBar(1237695, 25.9, CL.count:format(L.stardust_nova, stardustNovaCount))
	end
end

function mod:Extinction(args)
	self:StopBar(CL.count:format(L.extinction, extinctionCount))
	self:Message(args.spellId, "orange", CL.count:format(L.extinction, extinctionCount))
	self:PlaySound(args.spellId, "alarm") -- dodge fragment
	extinctionCount = extinctionCount + 1
	self:Bar(args.spellId, 33.2, CL.count:format(L.extinction, extinctionCount))
end

function mod:GammaBurst()
	self:StopBar(CL.count:format(CL.pushback, gammaBurstCount))
	self:Message(1237325, "red", CL.count:format(CL.pushback, gammaBurstCount))
	self:PlaySound(1237325, "warning") -- pushback inc
	gammaBurstCount = gammaBurstCount + 1
	self:Bar(1237325, 35.0, CL.count:format(CL.pushback, gammaBurstCount))
end

-- The Devoured Lords
-- Artoshion & Pargoth
function mod:MassEjection(args)
	self:StopBar(CL.count:format(CL.frontal_cone, massEjectionCount))
	self:Message(args.spellId, "yellow", CL.casting:format(CL.frontal_cone))
	self:PlaySound(args.spellId, "alert") -- dodge frontal
	massEjectionCount = massEjectionCount + 1
	local cd = {17.7, 12.7, 17}
	self:Bar(args.spellId, 20, CL.count:format(CL.frontal_cone, massEjectionCount))
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
	self:Message(args.spellId, "orange", CL.count:format(CL.adds, conquerorsCrossCount))
	self:PlaySound(args.spellId, "alert") -- adds/walls incoming
	conquerorsCrossCount = conquerorsCrossCount + 1
	self:Bar(args.spellId, 35.3, CL.count:format(CL.adds, conquerorsCrossCount))
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
	self:Message(args.spellId, "orange", CL.count:format(L.stardust_nova, stardustNovaCount))
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:UnitWithinRange(unit, 20) then -- radius is 10, using 20 to be safe.
		self:PlaySound(args.spellId, "alarm") -- move out of melee
	end
	stardustNovaCount = stardustNovaCount + 1
	-- self:Bar(args.spellId, 40, CL.count:format(L.stardust_nova, stardustNovaCount))
end

function mod:VoidlordDeath(args)
	voidlordKilled = voidlordKilled + 1
	self:StopBar(CL.count:format(CL.adds, conquerorsCrossCount))
	self:StopBar(CL.count:format(CL.frontal_cone, massEjectionCount))
	self:StopBar(CL.count:format(L.stardust_nova, stardustNovaCount))
	self:StopBar(CL.count:format(L.extinction, extinctionCount))
	self:StopBar(CL.count:format(CL.pushback, gammaBurstCount))

	self:Message("stages", "green", CL.mob_killed:format(args.destName, voidlordKilled, 2), "warlock_summon_-voidlord")
	self:PlaySound("stages", "info")

	if self:MobId(args.destGUID) == 245255 then -- Artoshion
		self:SetStage(1.5) -- Fly time
		artoshionKilled = true
		self:Bar(1235114, 5.5, L.soaring_reshii) -- Soaring Reshii
	else -- stage 3 inc
		self:Bar(1245292, 14.5, CL.soon:format(CL.weakened))
	end
end

-- Stage Three: Singularity
function mod:Destabilized(args)
	self:SetStage(3)
	self:Message(args.spellId, "green", CL.weakened)
	self:PlaySound(args.spellId, "long") -- weakened
	self:CastBar(args.spellId, 15, CL.weakened)

	devourCount = 1
	darkenedSkyCount = 1
	cosmicCollapseCount = 1
	supernovaCount = 1

	self:Bar(1231716, 17, L.extinguish_the_stars) -- Extinguish the Stars
	self:Bar(1234044, timers[3][1234044][darkenedSkyCount], CL.count:format(L.darkened_sky, darkenedSkyCount)) -- Darkened Sky
	self:Bar(1250055, timers[3][1250055][voidgraspCount], CL.count:format(L.slows, voidgraspCount)) -- Void Grasp
	self:Bar(1234263, timers[3][1234263][cosmicCollapseCount], CL.count:format(L.cosmic_collapse, cosmicCollapseCount)) -- Cosmic Collapse
	self:Bar(1233539, timers[3][1233539][devourCount], CL.count:format(self:SpellName(1233539), devourCount)) -- Devour
	self:Bar(1232973, timers[3][1232973][supernovaCount], CL.count:format(self:SpellName(1232973), supernovaCount)) -- Supernova
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
		devourCount = devourCount + 1
		self:Bar(args.spellId, timers[3][args.spellId][devourCount], CL.count:format(args.spellName, devourCount))
		castingDevour = true
		-- No repeater, get in late
	end

	function mod:DevourP3Removed()
		castingDevour = false
	end
end

function mod:DarkenedSky()
	self:StopBar(CL.count:format(L.darkened_sky, darkenedSkyCount))
	self:Message(1234044, "yellow", CL.count:format(L.darkened_sky, darkenedSkyCount))
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
	self:CastBar(args.spellId, self:Mythic() and 8.5 or 6.5, CL.count:format(args.spellName, supernovaCount)) -- 1.5s cast + 5s explosion (7s on Mythic)
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
