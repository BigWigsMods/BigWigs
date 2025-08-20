--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nexus-King Salhadaar", 2810, 2690)
if not mod then return end
mod:RegisterEnableMob(237763) -- Nexus-King Salhadaar
mod:SetEncounterID(3134)
mod:SetPrivateAuraSounds({
	1224864, -- Behead, Unused: 1224828, 1224855, 1224857, 1224858,  1224859, 1224860, 1225055, 1225056, 1225057, 1225058, 1225059, 1225060
	1228114, -- Netherbreaker
	1225316, -- Galactic Smash, Unused: 1226602, 1248128, 1226601
	1226018, -- Starkiller Swing
	1237108, -- Twilight Massacre
})
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local intermissionDone = false
local stage2StartTime = 0

local oathStacksOnMe = 0
local tankComboCount = 1
local conquerCount = 1
local banishmentCount = 1
local invokeCount = 1

local beheadCount = 1
local besiegeCount = 1

local manaForgedTitansKilled = 1

local breakerCount = 1
local breathCount = 1
local cosmicMawCount = 1

local smashCount = 1
local swingCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.oath_bound_removed_dose = "1x Oath-Bound Removed"
	L.behead = "Claws" -- Claws of a dragon
	L.netherbreaker = "Circles"
	L.galaxy_smash = "Smashes" -- Short for Galactic Smash, and multiple of them.
	L.starkiller_swing = "Starkillers" -- Short for Starkiller Swing, and multiple of them.
	L.vengeful_oath = "Spirits"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	-- Stage 1
	self:SetSpellRename(1224776, CL.tank_combo) -- Subjugation Rule (Tank Combo)
	self:SetSpellRename(1224787, CL.soak) --  Conquer (Soak)
	self:SetSpellRename(1224827, L.behead) -- Behead (Claws)
	self:SetSpellRename(1227470, CL.breath) -- Besiege (Breath)
	self:SetSpellRename(1225016, CL.breath) -- Command Besiege (Breath)

	-- Stage 2
	self:SetSpellRename(1227734, CL.knockback) -- Coalesce Voidwing (Knockback)
	self:SetSpellRename(1228115, L.netherbreaker) -- Netherbreaker (Circles)
	self:SetSpellRename(1228163, CL.beams) -- Dimension Breath (Beams)

	-- Intermission 1
	self:SetSpellRename(1228075, CL.beams) -- Nexus Beams (Beams)

	-- Stage 3
	self:SetSpellRename(1226648, L.galaxy_smash) -- Galactic Smash (Smashes)
	self:SetSpellRename(1225319, L.galaxy_smash) -- Galactic Smash (Smashes)
	self:SetSpellRename(1226442, L.starkiller_swing) -- Starkiller Swing (Starkillers)
	self:SetSpellRename(1226024, L.starkiller_swing) -- Starkiller Swing (Starkillers)
end

function mod:GetOptions()
	return {
		"stages",
		-- Stage One: Oath-Breakers
			-- Nexus-King Salhadaar
				1224737, -- Oath-Bound
				{1224767, "ME_ONLY", "ME_ONLY_EMPHASIZE"}, -- King's Thrall
			1224776, -- Subjugation Rule
				{1224787, "CASTBAR"}, -- Conquer
				{1224812, "TANK"}, -- Vanquish
			{1227549, "ME_ONLY", "ME_ONLY_EMPHASIZE"}, -- Banishment
			1224906, -- Invoke the Oath
			-- Royal Voidwing
				{1224827, "PRIVATE"}, -- Behead
					1231097, -- Cosmic Rip
			1227470, -- Besiege
		-- Stage Two: Rider of the Dark
			-- Nexus-King Salhadaar
			{1227734, "CASTBAR", "CASTBAR_COUNTDOWN"}, -- Coalesce Voidwing
			{1228115, "PRIVATE"}, -- Netherbreaker
			-- Royal Voidwing
			1228163, -- Dimension Breath
			{1234529, "TANK"}, -- Cosmic Maw
		-- Intermission One: Nexus Descent
			-- Manaforged Titan
				1230302, -- Self-Destruct
				1232399, -- Dread Mortar
			-- Nexus-Prince Ky'vor / Nexus-Prince Xevvos
				1228075, -- Nexus Beams
				1230261, -- Netherblast
		-- Intermission Two: King's Hunger
			-- Nexus-King Salhadaar
			{1228265, "CASTBAR"}, -- King's Hunger
		-- Stage Three: World in Twilight
			{1226648, "CASTBAR", "PRIVATE"}, -- Galactic Smash
					1225444, -- Atomized
					1225645, -- Twilight Spikes
				1226362, -- Twilight Scar
				{1226413, "TANK"}, -- Starshattered
			{1226442, "CASTBAR", "PRIVATE"}, -- Starkiller Swing
			1225634, -- World in Twilight
		-- Mythic
		1238975, -- Vengeful Oath
	},{
		-- Tabs
		{
			tabName = CL.general,
			{"stages"}
		},
		{
			tabName = CL.stage:format(1),
			{1224737, 1224767, 1224776, 1224787, 1224812, 1227549, 1224906, 1224827, 1231097, 1227470, 1238975}
		},
		{
			tabName = CL.stage:format(2),
			{1227734, 1228115, 1228163, 1234529, 1224827, 1231097}
		},
		{
			tabName = CL.count:format(CL.intermission, 1),
			{1230302, 1232399, 1228075, 1230261}
		},
		{
			tabName = CL.count:format(CL.intermission, 2),
			{1228265}
		},
		{
			tabName = CL.stage:format(3),
			{1226648, 1225444, 1225645, 1226362, 1226413, 1226442, 1225634}
		},
		-- Sections
		-- Stage 1
		[1224737] = -32227, -- Nexus-King Salhadaar
		[1224827] = -32228, -- Royal Voidwing
		-- Stage 2
		[1227734] = -32227, -- Nexus-King Salhadaar
		[1228163] = -32228, -- Royal Voidwing
		-- Intermission 1
		[1230302] = -32639, -- Manaforged Titan
		[1228075] = CL.plus:format(self:SpellName(-33469), self:SpellName(-32642)), -- Nexus-Prince Ky'vor + Nexus-Prince Xevvos
		-- Mythic
		[1238975] = "mythic", -- Vengeful Oath
	},
	{
		[1224827] = L.behead, -- Behead (Claws)
		[1224776] = CL.tank_combo, -- Subjugation Rule (Tank Combo)
		[1224787] = CL.soak, -- Conquer (Soak)
		[1227470] = CL.breath, -- Besiege (Breath)
		[1227734] = CL.knockback, -- Coalesce Voidwing (Knockback)
		[1228115] = L.netherbreaker, -- Netherbreaker (Circles)
		[1228163] = CL.beams, -- Dimension Breath (Beams)
		[1228075] = CL.beams, -- Nexus Beams (Beams)
		[1226648] = L.galaxy_smash, -- Galactic Smash (Smashes)
		[1226442] = L.starkiller_swing, -- Starkiller Swing (Starkillers)
		[1238975] = L.vengeful_oath, -- Vengeful Oath (Spirits)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	-- Avoidable Damage
	self:Log("SPELL_DAMAGE", "AvoidableDamage", 1225645) -- Twilight Spikes
	self:Log("SPELL_AURA_APPLIED", "AvoidableDamage", 1231097, 1227470, 1225444) -- Cosmic Rip, Besiege, Atomized
	self:Log("SPELL_PERIODIC_DAMAGE", "AvoidableDamage", 1231097, 1227470, 1225444)
	self:Log("SPELL_PERIODIC_MISSED", "AvoidableDamage", 1231097, 1227470, 1225444)

	-- Stage One: Oath-Breakers
		-- Nexus-King Salhadaar
		self:Log("SPELL_AURA_APPLIED_DOSE", "OathBoundApplied", 1224737)
		self:Log("SPELL_AURA_REMOVED", "OathBoundRemoved", 1224737)
		self:Log("SPELL_AURA_REMOVED_DOSE", "OathBoundDoseRemoved", 1224737)
		self:Log("SPELL_AURA_APPLIED", "KingsThrall", 1224767)
		self:Log("SPELL_CAST_START", "Conquer", 1224787)
		self:Log("SPELL_CAST_START", "Vanquish", 1224812)
		self:Log("SPELL_CAST_SUCCESS", "Banishment", 1227529)
		self:Log("SPELL_AURA_APPLIED", "BanishmentApplied", 1227549)
		self:Log("SPELL_CAST_START", "InvokeTheOath", 1224906)

		-- Royal Voidwing
		self:Log("SPELL_CAST_START", "CommandBehead", 1225010, 1234904) -- Stage 1, Stage 2
		self:Log("SPELL_CAST_START", "CommandBesiege", 1225016)

	-- Stage Two: Rider of the Dark
		self:Log("SPELL_CAST_START", "CoalesceVoidwing", 1227734)
		-- Nexus-King Salhadaar
		self:Log("SPELL_CAST_START", "Netherbreaker", 1228115)
		self:Log("SPELL_CAST_START", "DimensionBreath", 1228163)
		self:Log("SPELL_CAST_START", "CosmicMaw", 1234529)
		self:Log("SPELL_AURA_APPLIED", "CosmicMawApplied", 1234529)

	-- Intermission One: Nexus Descent
		-- Nexus-King Salhadaar
		self:Log("SPELL_CAST_START", "RallyTheShadowguard", 1228065)
		self:Log("SPELL_AURA_REMOVED", "RoyalWardRemoved", 1228284)

		-- Manaforged Titan
		self:Log("SPELL_CAST_START", "SelfDestruct", 1230302)
		self:Log("SPELL_CAST_START", "DreadMortar", 1232399)
		self:Death("ManaforgedTitanDeath", 241800)

		-- Nexus-Prince Ky'vor / Nexus-Prince Xevvos
		self:Log("SPELL_CAST_START", "NexusBeams", 1228075)
		self:Log("SPELL_CAST_START", "Netherblast", 1230261)

	-- Intermission Two: King's Hunger
		self:Log("SPELL_CAST_START", "KingsHunger", 1228265)
		self:Log("SPELL_AURA_REMOVED", "KingsHungerRemoved", 1228265)

	-- Stage Three: World in Twilight
		self:Log("SPELL_CAST_SUCCESS", "GalacticSmashApplied", 1226648) -- PA Debuffs applying
		self:Log("SPELL_CAST_SUCCESS", "GalacticSmashStart", 1225319)
		self:Log("SPELL_AURA_APPLIED", "TwilightScarApplied", 1226362)
		self:Log("SPELL_AURA_APPLIED", "StarshatteredApplied", 1226413)
		self:Log("SPELL_CAST_SUCCESS", "StarkillerSwing", 1226442)
		self:Log("SPELL_CAST_START", "WorldInTwilight", 1225634)
end

function mod:OnEngage()
	self:SetStage(1)

	tankComboCount = 1
	conquerCount = 1
	banishmentCount = 1
	beheadCount = 1
	besiegeCount = 1

	self:Bar(1224776, 13.5, CL.count:format(CL.tank_combo, tankComboCount)) -- Subjugation Rule
	if not self:Easy() then
		self:Bar(1227549, 33.1, CL.count:format(self:SpellName(1227549), banishmentCount)) -- Banishment
	end
	self:Bar(1224827, 34.5, CL.count:format(L.behead, beheadCount)) -- Behead
	self:Bar(1227470, self:Easy() and 46 or 49.0, CL.count:format(CL.breath, besiegeCount)) -- Besiege
	self:Bar(1224906, 115.0) -- Invoke the Oath
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 1227891 then -- Coalesce Voidwing, Stage 2 trigger
		self:Stage2Start()
	elseif spellId == 1224776 then -- Subjugation Rule
		self:SubjugationRule()
	end
end


-- Damage
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

-- Stage One: Oath-Breakers
-- Nexus-King Salhadaar
function mod:KingsThrall(args)
	self:TargetMessage(args.spellId, "red", args.destName)
	self:PlaySound(args.spellId, "warning", nil, args.destName) -- mind controlled
end

function mod:OathBoundApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		oathStacksOnMe = amount
		if amount == 3 then -- only warn on 3 stacks (initial application)
			-- xxx todo: warn for every stack gained back in mythic after first 3 are applied
			self:StackMessage(args.spellId, "blue", args.destName, amount, 3)
		end
	end
end

function mod:OathBoundDoseRemoved(args)
	if self:Me(args.destGUID) then
		oathStacksOnMe = args.amount
		self:Message(args.spellId, "blue", L.oath_bound_removed_dose)
		self:PlaySound(args.spellId, "info", nil, args.destName) -- stack removed
	end
end

function mod:OathBoundRemoved(args)
	if self:Me(args.destGUID) then
		oathStacksOnMe = 0
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "long", nil, args.destName) -- stacks cleared
	end
end

function mod:SubjugationRule()
	self:StopBar(CL.count:format(CL.tank_combo, tankComboCount))
	-- No need for sound/messages, those are on Conquer/Vanquish
	tankComboCount = tankComboCount + 1
	if tankComboCount <= 3 then -- 3 in p1
		self:Bar(1224776, 40, CL.count:format(CL.tank_combo, tankComboCount))
	end
	if self:Mythic() then
		local spiritsTimer = 15.8
		self:Bar(1238975, spiritsTimer, L.vengeful_oath)
		self:ScheduleTimer("SpiritsSpawn", spiritsTimer)
	end
end

function mod:SpiritsSpawn()
	self:Message(1238975, "red", CL.spawning:format(L.vengeful_oath))
	self:PlaySound(1238975, "warning") -- face your spirits
end

function mod:Conquer(args)
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(CL.soak, conquerCount)))
	self:PlaySound(args.spellId, "warning") -- get in to lose a stack
	conquerCount = conquerCount + 1
	self:CastBar(args.spellId, 4, CL.count:format(CL.soak, conquerCount))
end

function mod:Vanquish(args)
	self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alarm") -- avoid or face away from raid
end

do
	local playerList = {}
	function mod:Banishment(args)
		playerList = {}
		self:StopBar(CL.count:format(args.spellName, banishmentCount))
		banishmentCount = banishmentCount + 1
		local banishmentTimers = {33.1, 13.4, 23.6, 16.4, 0}
		self:Bar(1227549, banishmentTimers[banishmentCount], CL.count:format(args.spellName, banishmentCount))
	end

	function mod:BanishmentApplied(args)
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
		end
		playerList[#playerList+1] = args.destName
		self:TargetsMessage(args.spellId, "yellow", playerList, 4, CL.count:format(args.spellName, banishmentCount-1))
	end
end

function mod:InvokeTheOath(args)
	self:StopBar(args.spellId)
	self:Message(args.spellId, "orange")
	if oathStacksOnMe > 0 then
		self:PlaySound(args.spellId, "warning") -- mind control incoming
	else
		self:PlaySound(args.spellId, "info") -- safe
	end
end

-- Royal Voidwing
function mod:CommandBehead()
	self:StopBar(CL.count:format(L.behead, beheadCount))
	self:Message(1224827, "yellow", CL.count:format(L.behead, beheadCount))
	-- No Sound, Debuffs are Private
	beheadCount = beheadCount + 1

	local stage = self:GetStage()
	if stage == 2 or (stage == 1 and beheadCount > 2) then return end -- 2x in stage 1, 1x stage 2
	self:Bar(1224827, 38.0, CL.count:format(L.behead, beheadCount))
end

function mod:CommandBesiege()
	self:StopBar(CL.count:format(CL.breath, besiegeCount))
	self:Message(1227470, "yellow", CL.count:format(CL.breath, besiegeCount))
	self:PlaySound(1227470, "alert") -- watch breath location
	besiegeCount = besiegeCount + 1
	local maxCasts = self:Mythic() and 3 or 2
	if besiegeCount <= maxCasts then
		self:Bar(1227470, 40, CL.count:format(CL.breath, besiegeCount))
	end
end

-- Stage Two: Rider of the Dark
-- Nexus-King Salhadaar
function mod:Stage2Start()
	self:SetStage(2)
	stage2StartTime = GetTime()

	self:StopBar(CL.count:format(CL.tank_combo, tankComboCount)) -- Subjugation Rule
	self:StopBar(CL.count:format(self:SpellName(1227549), banishmentCount)) -- Banishment
	self:StopBar(CL.count:format(self:SpellName(1224906), invokeCount)) -- Invoke the Oath
	self:StopBar(CL.count:format(L.behead, beheadCount)) -- Behead
	self:StopBar(CL.count:format(CL.breath, besiegeCount)) -- Besiege

	self:Message("stages", "yellow", CL.stage:format(2), false)
	self:PlaySound("stages", "long") -- staging

	beheadCount = 1
	breakerCount = 1
	breathCount = 1
	cosmicMawCount = 1

	self:Bar(1228115, self:Mythic() and 9.0 or 12.0, CL.count:format(L.netherbreaker, breakerCount)) -- Netherbreaker
	if not self:Mythic() then
		self:Bar(1224827, 21, CL.count:format(L.behead, beheadCount)) -- Behead
	end
	self:Bar(1234529, self:Mythic() and 16.0 or 23.0, CL.count:format(self:SpellName(1234529), cosmicMawCount)) -- Cosmic Maw
	self:Bar(1228163, self:Mythic() and 21.0 or 29.0, CL.count:format(CL.beams, breathCount)) -- Dimension Breath
	self:Bar("stages", 38.9, CL.count:format(CL.intermission, 1), 1228065) -- Rally the Shadowguard
end

function mod:CoalesceVoidwing(args)
	self:Message(args.spellId, "red", CL.casting:format(CL.knockback))
	self:PlaySound(args.spellId, "warning") -- knockback incoming
	self:CastBar(args.spellId, 6.2, CL.knockback) -- Coalesce Voidwing
end

function mod:Netherbreaker(args)
	self:StopBar(CL.count:format(L.netherbreaker, breakerCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.netherbreaker, breakerCount))
	-- No Sound, Debuffs are Private
	-- In Mythic it's on the floor so we do play a sound
	if self:Mythic() then
		self:PlaySound(args.spellId, "alert") -- watch circles
	end
	breakerCount = breakerCount + 1
	if intermissionDone then
		self:Bar(args.spellId, 39.0, CL.count:format(L.netherbreaker, breakerCount))
	end
end

function mod:DimensionBreath(args)
	self:StopBar(CL.count:format(CL.beams, breathCount))
	self:Message(args.spellId, "purple", CL.count:format(CL.beams, breathCount))
	self:PlaySound(args.spellId, "alert") -- watch breath location
	breathCount = breathCount + 1
	if intermissionDone then
		self:Bar(args.spellId, 39.0, CL.count:format(CL.beams, breathCount))
	end
end

function mod:CosmicMaw(args)
	self:StopBar(CL.count:format(args.spellName, cosmicMawCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, cosmicMawCount))
	self:PlaySound(args.spellId, "alert")
	cosmicMawCount = cosmicMawCount + 1
	if intermissionDone then
		self:Bar(args.spellId, 39.0, CL.count:format(args.spellName, cosmicMawCount))
	end
end

function mod:CosmicMawApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm", nil, args.destName) -- On you
	elseif self:Tank() then
		self:PlaySound(args.spellId, "warning") -- taunt for breath
	end
end

-- Intermission One: Nexus Descent
-- Nexus-King Salhadaar
function mod:RallyTheShadowguard()
	self:SetStage(1.5) -- Intermission 1
	intermissionDone = false

	self:StopBar(CL.count:format(L.behead, beheadCount)) -- Behead
	self:StopBar(CL.count:format(L.netherbreaker, breakerCount)) -- Netherbreaker
	self:StopBar(CL.count:format(CL.beams, breathCount)) -- Dimension Breath
	self:StopBar(CL.count:format(self:SpellName(1234529), cosmicMawCount)) -- Cosmic Maw
	self:StopBar(CL.count:format(CL.intermission, 1))

	self:Message("stages", "green", CL.count:format(CL.intermission, 1), false)
	self:PlaySound("stages", "long") -- intermission

	manaForgedTitansKilled = 0
	self:Bar(1228075, 24.4, CL.beams) -- Nexus Beams eta
	self:Bar(1232399, 15.9) -- Dread Mortar eta
	self:Bar(1230302, 64.0) -- Self-Destruct, until success
end

do
	local prev	= 0
	function mod:SelfDestruct(args)
		if args.time - prev > 2 then -- throttle
			prev = args.time
			self:Message(args.spellId, "red", CL.casting:format(args.spellName))
			self:PlaySound(args.spellId, "warning") -- self destructing
			-- update the bar so it fits the end
			self:Bar(1230302, {10.0, 64.0}) -- Update remaining time
		end
	end
end

function mod:DreadMortar(args)
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:UnitWithinRange(unit, 45) then
		self:Message(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alert") -- watch feet
		self:Bar(args.spellId, 24.5)
	end
end

function mod:ManaforgedTitanDeath()
	manaForgedTitansKilled = manaForgedTitansKilled + 1
	if manaForgedTitansKilled == 2 then
		self:StopBar(1230302) -- Self-Destruct
		self:StopBar(1232399) -- Dread Mortar
	end
end

function mod:NexusBeams(args)
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:UnitWithinRange(unit, 45) then
		self:Message(args.spellId, "orange", CL.beams)
		self:PlaySound(args.spellId, "alert") -- watch beams
		self:Bar(args.spellId, 20.9, CL.beams)
	end
end

function mod:Netherblast(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo and ready then
		self:Message(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:RoyalWardRemoved(args)
	if self:MobId(args.destGUID) == 233823 then -- The Royal Voidwing
		intermissionDone = true
		self:SetStage(2) -- Stage 2
		self:Message("stages", "green", CL.over:format(CL.count:format(CL.intermission, 1)), false)
		self:PlaySound("stages", "long") -- intermission over

		-- Let's keep the counts from pre-intermission.
		-- beheadCount = 1
		-- breakerCount = 1
		-- breathCount = 1
		-- cosmicMawCount = 1

		local time = GetTime()
		local stage2Offset = time - stage2StartTime
		self:Bar(1228115, 114.0 - stage2Offset, CL.count:format(L.netherbreaker, breakerCount)) -- Netherbreaker
		self:Bar(1224827, 121.0 - stage2Offset, CL.count:format(L.behead, beheadCount)) -- Behead
		self:Bar(1234529, 123.0 - stage2Offset, CL.count:format(self:SpellName(1234529), cosmicMawCount)) -- Cosmic Maw
		self:Bar(1228163, 129.0 - stage2Offset, CL.count:format(CL.beams, breathCount)) -- Dimension Breath
		self:Bar("stages", 140.5 - stage2Offset, CL.intermission, 1228265) -- King's Hunger icon
	end
end

-- Intermission Two: King's Hunger
function mod:KingsHunger(args)
	self:StopBar(CL.count:format(L.behead, beheadCount)) -- Behead
	self:StopBar(CL.count:format(L.netherbreaker, breakerCount)) -- Netherbreaker
	self:StopBar(CL.count:format(CL.beams, breathCount)) -- Dimension Breath
	self:StopBar(CL.count:format(self:SpellName(1234529), cosmicMawCount)) -- Cosmic Maw
	self:StopBar(CL.count:format(self:SpellName(1227529), banishmentCount)) -- Banishment
	self:StopBar(CL.count:format(CL.breath, besiegeCount)) -- Besiege

	self:Message("stages", "green", CL.count:format(CL.intermission, 2), false)
	self:PlaySound("stages", "long") -- intermission 2
	self:SetStage(2.5)
	self:CastBar(args.spellId, 36, CL.count:format(args.spellName, 1)) -- King's Hunger
end

function mod:KingsHungerRemoved(args)
	self:StopCastBar(args.spellId)
	self:Message(args.spellId, "green", CL.over:format(args.spellName))
	self:PlaySound(args.spellId, "long") -- intermission over
	self:SetStage(3) -- Stage 3

	smashCount = 1
	swingCount = 1

	self:Bar(1226648, 9, CL.count:format(L.galaxy_smash, smashCount)) -- Galactic Smash
	self:Bar(1226442, self:Normal() and 46.8 or 36.8, CL.count:format(L.starkiller_swing, swingCount)) -- Starkiller Swing
	self:Bar(1225634, 182.0) -- World in Twilight // end of channel aka full room (Also adjust time in _START function)
end

function mod:GalacticSmashApplied(args)
	self:StopBar(CL.count:format(L.galaxy_smash, smashCount))
	-- No Sounds, Private Debuffs
	smashCount = smashCount + 1
	if smashCount <= 3 then -- only 3 before enrage
		self:Bar(args.spellId, 55, CL.count:format(L.galaxy_smash, smashCount))
	end
end

function mod:GalacticSmashStart(args)
	self:Message(1226648, "orange", CL.casting:format(CL.count:format(L.galaxy_smash, smashCount)))
	self:CastBar(1226648, 8, CL.count:format(L.galaxy_smash, smashCount))
end

function mod:TwilightScarApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm", nil, args.destName)
	end
end

function mod:StarshatteredApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm", nil, args.destName) -- On you
	elseif self:Tank() then
		self:PlaySound(args.spellId, "warning") -- taunt
	end
end

function mod:StarkillerSwing(args)
	self:StopBar(CL.count:format(L.starkiller_swing, swingCount))
	self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(L.starkiller_swing, swingCount)))
	-- No Sounds, Private Debuffs
	self:CastBar(args.spellId, 6, CL.count:format(L.starkiller_swing, swingCount))
	swingCount = swingCount + 1
	if swingCount <= 3 then -- only 3 before enrage
		local cd = swingCount % 2 == 0 and 15 or 40 -- Heroic
		if self:Easy() then
			cd = 55
		end
		self:Bar(args.spellId, cd, CL.count:format(L.starkiller_swing, swingCount))
	end
end

function mod:WorldInTwilight(args)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "long") -- enrage
	self:Bar(args.spellId, {10, 182.0}) -- Update remaining time until room full
end
