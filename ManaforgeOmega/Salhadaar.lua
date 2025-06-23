if not BigWigsLoader.isTestBuild then return end

-- TODO:
-- - Re-evaluate stage numbers, order might be wrong from journal? 2 intermissions in a row?

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nexus-King Salhadaar", 2810, 2690)
if not mod then return end
mod:RegisterEnableMob(237763) -- Nexus-King Salhadaar XXX Confirm
mod:SetEncounterID(3134)
mod:SetPrivateAuraSounds({
	{1224828, 1224855, 1224857, 1224858,
	 1224859, 1224860, 1224864, 1225055,
	 1225056, 1225057, 1225058, 1225059,
	 1225060}, -- Behead XXX Confirm if all of these are used
	1228114, -- Netherbreaker
	{1225316, 1226602, 1248128, 1226601}, -- Galactic Smash XXX Confirm if all of these are used
	1226018, -- Starkiller Swing
})
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local oathStacksOnMe = 0
local decreeCount = 1
local tankComboCount = 1
local banishmentCount = 1
local invokeCount = 1

local imagesCount = 1
local beheadCount = 1
local besiegeCount = 1

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
	L.dimension_breath = "Tank Breath"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:SetSpellRename(1224776, CL.tank_combo) -- Subjugation Rule (Tank Combo)
	self:SetSpellRename(1227470, CL.breath) -- Besiege (Breath)
	self:SetSpellRename(1225016, CL.breath) -- Command Besiege (Breath)
end

function mod:GetOptions()
	return {
		-- Stage One: Oath-Breakers
			-- Nexus-King Salhadaar
			1224731, -- Decree: Oath-Bound
				1224737, -- Oath-Bound
				{1224767, "ME_ONLY", "ME_ONLY_EMPHASIZE"}, -- King's Thrall
				-- 1224764, -- Oath-Breaker -- XXX On removed?
			1224776, -- Subjugation Rule
				{1224787, "CASTBAR"}, -- Conquer
				1224812, -- Vanquish
			{1227549, "ME_ONLY_EMPHASIZE"}, -- Banishment
			1224906, -- Invoke the Oath
			-- 1224822, -- Tyranny -- Permanently in p1?
			-- Royal Voidwing
			1225099, -- Fractal Images
				-- 1247213, -- Fractal Claw -- Personal warning when hit?
			{1224827, "PRIVATE"}, -- Behead
				1231097, -- Cosmic Rip
			1227470, -- Besiege
		-- Stage Two: Rider of the Dark
			-- Nexus-King Salhadaar
			1227891, -- Coalesce Voidwing
			{1228115, "PRIVATE"}, -- Netherbreaker
			-- Royal Voidwing
			1228163, -- Dimension Breath
			{1234529, "TANK"}, -- Cosmic Maw
		-- Intermission One: Nexus Descent
			-- Nexus-King Salhadaar
			1228065, -- Rally the Shadowguard
			-- Manaforged Titan
				1230302, -- Self-Destruct
				1232399, -- Dread Mortar XXX Nameplate icon?
			-- Nexus-Prince Ky'vor / Nexus-Prince Xevvos
				1228075, -- Nexus Beams XXX Nameplate icon?
				1230261, -- Netherblast XXX Nameplate icon?
			-- Shadowguard Reaper
				-- 1228053, -- Reap XXX Nameplate icon?
		-- Intermission Two: King's Hunger
			-- Nexus-King Salhadaar
			1228265, -- King's Hunger
		-- Stage Three: World in Twilight
			{1225319, "CASTBAR", "PRIVATE"}, -- Galactic Smash
				-- 1225405, -- Dark Star
					1225444, -- Atomized
					1225645, -- Twilight Spikes
					-- 1234906, -- Nexus Collapse
						1234907, -- Dimension Rend
					-- 1226384, -- Dark Orbit
				1226362, -- Twilight Scar
				1226413, -- Starshattered
			{1226024, "CASTBAR", "PRIVATE"}, -- Starkiller Swing
				-- Starkiller Nova
	},{
		-- Tabs
		{
			tabName = CL.stage:format(1),
			{1224731, 1224737, 1224767, 1224776, 1224787, 1224812, 1227549, 1224906, 1225099, 1224827, 1231097, 1227470}
		},
		{
			tabName = CL.stage:format(2),
			{1227891, 1228115, 1228163, 1234529, 1224827, 1231097}
		},
		{
			tabName = CL.count:format(CL.intermission, 1),
			{1228065, 1230302, 1232399, 1228075, 1230261}
		},
		{
			tabName = CL.count:format(CL.intermission, 2),
			{1228265, 1224827}
		},
		{
			tabName = CL.stage:format(3),
			{1225319, 1225444, 1225645, 1234907, 1226362, 1226413, 1226024}
		},
		-- Sections
		-- Stage 1
		[1224731] = -32227, -- Nexus-King Salhadaar
		[1225099] = -32228, -- Royal Voidwing
		-- Stage 2
		[1227891] = -32227, -- Nexus-King Salhadaar
		[1228163] = -32228, -- Royal Voidwing
		-- Intermission 1
		[1228065] = -32227, -- Nexus-King Salhadaar
		[1230302] = -32639, -- Manaforged Titan
		[1228075] = CL.plus:format(self:SpellName(-33469), self:SpellName(-32642)), -- Nexus-Prince Ky'vor + Nexus-Prince Xevvos

	},
	{
		[1224776] = CL.tank_combo, -- Subjugation Rule
		[1227470] = CL.breath, -- Besiege
	}
end

function mod:OnBossEnable()
	-- Avoidable Damage
	self:Log("SPELL_DAMAGE", "AvoidableDamage", 1225645) -- Twilight Spikes
	self:Log("SPELL_AURA_APPLIED", "AvoidableDamage", 1231097, 1227470, 1225444, 1234907) -- Cosmic Rip, Besiege, Atomized, Dimension Rend
	self:Log("SPELL_PERIODIC_DAMAGE", "AvoidableDamage", 1231097, 1227470, 1225444, 1234907)
	self:Log("SPELL_PERIODIC_MISSED", "AvoidableDamage", 1231097, 1227470, 1225444, 1234907)

	-- Stage One: Oath-Breakers
		-- Nexus-King Salhadaar
		self:Log("SPELL_CAST_START", "DecreeOathBound", 1224731)
		-- self:Log("SPELL_AURA_APPLIED", "OathBoundApplied", 1224737)
		self:Log("SPELL_AURA_APPLIED_DOSE", "OathBoundApplied", 1224737)
		self:Log("SPELL_AURA_REMOVED", "OathBoundRemoved", 1224737)
		self:Log("SPELL_AURA_REMOVED_DOSE", "OathBoundDoseRemoved", 1224737)
		self:Log("SPELL_AURA_APPLIED", "KingsThrall", 1224767)
		self:Log("SPELL_CAST_SUCCESS", "SubjugationRule", 1224776)
		self:Log("SPELL_CAST_START", "Conquer", 1224787)
		self:Log("SPELL_CAST_START", "Vanquish", 1224812)
		self:Log("SPELL_CAST_SUCCESS", "Banishment", 1227529)
		self:Log("SPELL_AURA_APPLIED", "BanishmentApplied", 1227549)
		self:Log("SPELL_CAST_START", "InvokeTheOath", 1224906)

		-- Royal Voidwing
		self:Log("SPELL_CAST_START", "FractalImages", 1225099)
		self:Log("SPELL_CAST_START", "CommandBehead", 1225010) -- XXX Pre-cast for Beheads?
		self:Log("SPELL_CAST_START", "CommandBesiege", 1225016) -- XXX Pre-cast for Besiege?

	-- Stage Two: Rider of the Dark
		-- Nexus-King Salhadaar
		self:Log("SPELL_CAST_START", "CoalesceVoidwing", 1227891)
		self:Log("SPELL_CAST_START", "Netherbreaker", 1228115)
		self:Log("SPELL_CAST_START", "DimensionBreath", 1228163)
		self:Log("SPELL_CAST_START", "CosmicMaw", 1234529)
		self:Log("SPELL_AURA_APPLIED", "CosmicMawApplied", 1234529)

	-- Intermission One: Nexus Descent
		-- Nexus-King Salhadaar
		self:Log("SPELL_CAST_START", "RallyTheShadowguard", 1228065)
		-- Manaforged Titan
		self:Log("SPELL_CAST_START", "SelfDestruct", 1230302)
		self:Log("SPELL_CAST_START", "DreadMortar", 1232399)
		self:Log("SPELL_CAST_START", "NexusBeams", 1228075)
		self:Log("SPELL_CAST_START", "Netherblast", 1230261)
		-- self:Log("SPELL_CAST_START", "Reap", 1228053)

	-- Intermission Two: King's Hunger
		self:Log("SPELL_CAST_START", "KingsHunger", 1228265)
		self:Log("SPELL_AURA_REMOVED", "KingsHungerRemoved", 1228265)

	-- Stage Three: World in Twilight
		self:Log("SPELL_CAST_START", "GalacticSmash", 1225319)
		self:Log("SPELL_AURA_APPLIED", "TwilightScarApplied", 1226362)
		self:Log("SPELL_AURA_APPLIED", "StarshatteredApplied", 1226413)
		self:Log("SPELL_CAST_START", "StarkillerSwing", 1226024)

end

function mod:OnEngage()
	self:SetStage(1)

	decreeCount = 1
	tankComboCount = 1
	banishmentCount = 1
	invokeCount = 1

	imagesCount = 1
	beheadCount = 1
	besiegeCount = 1

	-- self:Bar(1224731, 0, CL.count:format(self:SpellName(1224731), decreeCount)) -- Decree: Oath-Bound
	-- self:Bar(1224776, 0, CL.count:format(CL.tank_combo, tankComboCount)) -- Decree: Oath-Bound
	-- self:Bar(1227529, 0, CL.count:format(self:SpellName(1227529), banishmentCount)) -- Banishment
	-- self:Bar(1224906, 0, CL.count:format(self:SpellName(1224906), invokeCount)) -- Invoke the Oath

	-- self:Bar(1225099, 0, CL.count:format(self:SpellName(1225099), imagesCount)) -- Fractal Images
	-- self:Bar(1224827, 0, CL.count:format(self:SpellName(1224827), beheadCount)) -- Behead
	-- self:Bar(1227470, 0, CL.count:format(CL.breath, besiegeCount)) -- Besiege
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Damage
do
	local prev = 0
	function mod:AvoidableDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

-- Stage One: Oath-Breakers
-- Nexus-King Salhadaar
function mod:DecreeOathBound(args)
	self:StopBar(CL.count:format(args.spellName, decreeCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, decreeCount))
	self:PlaySound(args.spellId, "alert")
	decreeCount = decreeCount + 1
	--self:Bar(args.spellId, CL.count:format(args.spellName, decreeCount))
end

function mod:KingsThrall(args)
	self:TargetMessage(args.spellId, "red", args.destName)
	self:PlaySound(args.spellId, "warning", nil, args.destName) -- mind controlled
end

function mod:OathBoundApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		oathStacksOnMe = amount
		if amount == 3 then -- only warn on 3 stacks (initial application) XXX Check if its uses _DOSE on initial application
			self:StackMessage(args.spellId, "blue", args.destName, amount, 3)
			-- self:PlaySound(args.spellId, "alarm", nil, args.destName) -- stacks applied
		end
	end
end

function mod:OathBoundDoseRemoved(args)
	if self:Me(args.destGUID) then
		oathStacksOnMe = args.amount
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 0)
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

function mod:SubjugationRule(args)
	self:StopBar(CL.count:format(CL.tank_combo, tankComboCount))
	self:Message(args.spellId, "yellow", CL.count:format(CL.tank_combo, tankComboCount))
	self:PlaySound(args.spellId, "alert") -- combo inc
	tankComboCount = tankComboCount + 1
	--self:Bar(args.spellId, CL.count:format(CL.tank_combo, tankComboCount))
end

function mod:Conquer(args)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "warning") -- get in to lose a stack
	self:CastBar(args.spellId, 4)
end

function mod:Vanquish(args)
	self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alarm") -- avoid
	-- self:CastBar(args.spellId, 2) -- XXX 2s is too short for a castbar imo
end


do
	local playerList = {}

	function mod:Banishment(args)
		playerList = {}
		self:StopBar(CL.count:format(args.spellName, banishmentCount))
		banishmentCount = banishmentCount + 1
		-- self:Bar(1227549, CL.count:format(args.spellName, banishmentCount), 0)
	end

	function mod:BanishmentApplied(args)
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
		end
		playerList[#playerList+1] = args.destName
		self:TargetsMessage(args.spellId, "yellow", playerList, 4, CL.count:format(args.spellName, banishmentCount-1))
	end
end

function mod:InvokeTheOath(args)
	self:StopBar(CL.count:format(args.spellName, invokeCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, invokeCount))
	if oathStacksOnMe > 0 then
		self:PlaySound(args.spellId, "warning") -- mind control incoming
	else
		self:PlaySound(args.spellId, "info") -- safe
	end
	invokeCount = invokeCount + 1
	-- self:Bar(args.spellId, CL.count:format(args.spellName, invokeCount))
end

-- Royal Voidwing
function mod:FractalImages(args)
	self:StopBar(CL.count:format(args.spellName, imagesCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, imagesCount))
	self:PlaySound(args.spellId, "alert") -- avoid
	imagesCount = imagesCount + 1
	-- self:Bar(args.spellId, CL.count:format(args.spellName, imagesCount))
end

function mod:CommandBehead(args)
	local spellName = self:SpellName(1224827)
	self:StopBar(CL.count:format(spellName, beheadCount))
	self:Message(1224827, "yellow", CL.count:format(spellName, beheadCount))
	-- No Sound, Debuffs are Private
	beheadCount = beheadCount + 1
	-- self:Bar(1224827, CL.count:format(spellName, beheadCount))
end

function mod:CommandBesiege(args)
	self:StopBar(CL.count:format(CL.breath, besiegeCount))
	self:Message(1227470, "yellow", CL.count:format(CL.breath, besiegeCount))
	self:PlaySound(1227470, "alert") -- watch breath location
	besiegeCount = besiegeCount + 1
	-- self:Bar(1227470, CL.count:format(CL.breath, besiegeCount))
end

-- Stage Two: Rider of the Dark
-- Nexus-King Salhadaar
function mod:CoalesceVoidwing(args)
	self:SetStage(2) -- XXX Better triggers?

	self:StopBar(CL.count:format(self:SpellName(1224731), decreeCount)) -- Decree: Oath-Bound
	self:StopBar(CL.count:format(CL.tank_combo, tankComboCount)) -- Decree: Oath-Bound
	self:StopBar(CL.count:format(self:SpellName(1227529), banishmentCount)) -- Banishment
	self:StopBar(CL.count:format(self:SpellName(1224906), invokeCount)) -- Invoke the Oath
	self:StopBar(CL.count:format(self:SpellName(1225099), imagesCount)) -- Fractal Images
	self:StopBar(CL.count:format(self:SpellName(1224827), beheadCount)) -- Behead
	self:StopBar(CL.count:format(CL.breath, besiegeCount)) -- Besiege

	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long") -- staging

	beheadCount = 1
	breakerCount = 1
	breathCount = 1
	cosmicMawCount = 1

	-- self:Bar(1224827, 0, CL.count:format(self:SpellName(1224827), beheadCount)) -- Behead
	-- self:Bar(1228115, 0, CL.count:format(self:SpellName(1228115), breakerCount)) -- Netherbreaker
	-- self:Bar(1228163, 0, CL.count:format(L.dimension_breath, breathCount)) -- Dimension Breath
	-- self:Bar(1234529, 0, CL.count:format(self:SpellName(1234529), cosmicMawCount)) -- Cosmic Maw
end

function mod:Netherbreaker(args)
	self:StopBar(CL.count:format(args.spellName, breakerCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, breakerCount))
	-- No Sound, Debuffs are Private
	breakerCount = breakerCount + 1
	-- self:Bar(args.spellId, CL.count:format(args.spellName, breakerCount))
end

function mod:DimensionBreath(args)
	self:StopBar(CL.count:format(L.dimension_breath, breathCount))
	self:Message(args.spellId, "purple", CL.count:format(L.dimension_breath, breathCount))
	self:PlaySound(args.spellId, "alert") -- watch breath location
	breathCount = breathCount + 1
	-- self:Bar(args.spellId, CL.count:format(L.dimension_breath, breathCount))
end

function mod:CosmicMaw(args)
	self:StopBar(CL.count:format(args.spellName, cosmicMawCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, cosmicMawCount))
	self:PlaySound(args.spellId, "alert")
	cosmicMawCount = cosmicMawCount + 1
	-- self:Bar(args.spellId, 0, CL.count:format(args.spellName, cosmicMawCount))
end

function mod:CosmicMawApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- On you
	elseif self:Tank() then
		self:PlaySound(args.spellId, "warning") -- taunt for breath
	end
end

-- Intermission One: Nexus Descent
-- Nexus-King Salhadaar
function mod:RallyTheShadowguard(args)
	self:SetStage(1.5) -- Intermission 1

	-- Filter once we know what stages into this
	self:StopBar(CL.count:format(self:SpellName(1224827), beheadCount)) -- Behead
	self:StopBar(CL.count:format(self:SpellName(1228115), breakerCount)) -- Netherbreaker
	self:StopBar(CL.count:format(L.dimension_breath, breathCount)) -- Dimension Breath
	self:StopBar(CL.count:format(self:SpellName(1234529), cosmicMawCount)) -- Cosmic Maw
	self:StopBar(CL.count:format(self:SpellName(1224731), decreeCount)) -- Decree: Oath-Bound
	self:StopBar(CL.count:format(CL.tank_combo, tankComboCount)) -- Decree: Oath-Bound
	self:StopBar(CL.count:format(self:SpellName(1227529), banishmentCount)) -- Banishment
	self:StopBar(CL.count:format(self:SpellName(1224906), invokeCount)) -- Invoke the Oath
	self:StopBar(CL.count:format(self:SpellName(1225099), imagesCount)) -- Fractal Images
	self:StopBar(CL.count:format(self:SpellName(1224827), beheadCount)) -- Behead
	self:StopBar(CL.count:format(CL.breath, besiegeCount)) -- Besiege

	self:Message(args.spellId, "green")
	self:PlaySound(args.spellId, "long") -- intermission 1
end

function mod:SelfDestruct(args)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "warning") -- self destructing
	-- self:CastBar(args.spellId, 10) -- Enable when we know if we can cancel this if it dies?
end

function mod:DreadMortar(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert") -- watch feet
end

do
	local prev = 0
	function mod:NexusBeams(args)
		if args.time - prev > 2 then -- throttle if casts are too close together
			prev = args.time
			self:Message(args.spellId, "orange", CL.incoming:format(args.spellName))
			self:PlaySound(args.spellId, "alert") -- watch beams
		end
	end
end

function mod:Netherblast(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo and ready then
		self:Message(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alarm")
	end
end

-- do
-- 	local prev = 0
-- 	function mod:Reap(args)
-- 		if args.time - prev > 2 then -- throttle if casts are too close together
-- 			prev = args.time
-- 			self:Message(args.spellId, "orange", CL.incoming:format(args.spellName))
-- 			self:PlaySound(args.spellId, "alert") -- watch beams
-- 		end
-- 	end
-- end

-- Intermission Two: King's Hunger
function mod:KingsHunger(args)
	self:SetStage(2.5) -- Intermission 2

	-- Filter once we know what stages into this
	self:StopBar(CL.count:format(self:SpellName(1224827), beheadCount)) -- Behead
	self:StopBar(CL.count:format(self:SpellName(1228115), breakerCount)) -- Netherbreaker
	self:StopBar(CL.count:format(L.dimension_breath, breathCount)) -- Dimension Breath
	self:StopBar(CL.count:format(self:SpellName(1234529), cosmicMawCount)) -- Cosmic Maw
	self:StopBar(CL.count:format(self:SpellName(1224731), decreeCount)) -- Decree: Oath-Bound
	self:StopBar(CL.count:format(CL.tank_combo, tankComboCount)) -- Decree: Oath-Bound
	self:StopBar(CL.count:format(self:SpellName(1227529), banishmentCount)) -- Banishment
	self:StopBar(CL.count:format(self:SpellName(1224906), invokeCount)) -- Invoke the Oath
	self:StopBar(CL.count:format(self:SpellName(1225099), imagesCount)) -- Fractal Images
	self:StopBar(CL.count:format(self:SpellName(1224827), beheadCount)) -- Behead
	self:StopBar(CL.count:format(CL.breath, besiegeCount)) -- Besiege

	self:Message(args.spellId, "green")
	self:PlaySound(args.spellId, "long") -- intermission 2

	smashCount = 1
	swingCount = 1

	-- self:Bar(1225319, 0, CL.count:format(self:SpellName(1225319), smashCount)) -- Galactic Smash
	-- self:Bar(1225319, 0, CL.count:format(self:SpellName(1225319), smashCount)) -- Galactic Smash
end

function mod:KingsHungerRemoved(args)
	self:SetStage(3) -- Stage 3
	self:Message(args.spellId, "green", CL.over:format(args.spellName))
	self:PlaySound(args.spellId, "long") -- intermission over

	-- self:Bar(1225319, 0, CL.count:format(self:SpellName(1225319), smashCount)) -- Galactic Smash
	-- self:Bar(1226024, 0, CL.count:format(self:SpellName(1226024), swingCount)) -- Starkiller Swing
end

function mod:GalacticSmash(args)
	self:StopBar(CL.count:format(args.spellName, smashCount))
	self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(args.spellName, smashCount)))
	-- No Sounds, Private Debuffs
	self:CastBar(args.spellId, 8, CL.count:format(args.spellName, smashCount))
	smashCount = smashCount + 1
	-- self:Bar(args.spellId, 0, CL.count:format(args.spellName, smashCount))
end

function mod:TwilightScarApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlayerSound(args.spellId, "alarm")
	end
end

function mod:StarshatteredApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- On you
	elseif self:Tank() then
		self:PlaySound(args.spellId, "warning") -- taunt
	end
end

function mod:StarkillerSwing(args)
	self:StopBar(CL.count:format(args.spellName, swingCount))
	self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(args.spellName, swingCount)))
	-- No Sounds, Private Debuffs
	self:CastBar(args.spellId, 6, CL.count:format(args.spellName, swingCount))
	swingCount = swingCount + 1
	-- self:Bar(args.spellId, 0, CL.count:format(args.spellName, swingCount))
end
