--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Broodkeeper Diurna", 2522, 2493)
if not mod then return end
mod:RegisterEnableMob(190245) -- Broodkeeper Diurna
mod:SetEncounterID(2614)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local mobCollector = {}
local primalistMageMarks = {}
local greatstaffCount = 1
local rapidIncubationCount = 1
local wildfireCount = 1
local icyShroudCount = 1
local primalReinforcementsCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.eggs_remaining = "%d Eggs Remaining!"
	L.broodkeepers_bond = "Eggs Remaining"
	L.greatstaff_of_the_broodkeeper = "Greatstaff"
	L.greatstaffs_wrath = "Laser"
	L.clutchwatchers_rage = "Rage"
	L.rapid_incubation = "Infuse Eggs"
	L.icy_shroud = "Heal Absorb"
	L.broodkeepers_fury = "Fury"
	L.frozen_shroud = "Root Absorb"

	L.add_count = "%s (%d-%d)"
end

--------------------------------------------------------------------------------
-- Initialization
--

local primalistMageMarker = mod:AddMarkerOption(false, "npc", 1, -25144, 8, 7) -- Primalist Mage
function mod:GetOptions()
	return {
		-- Stage One: The Primalist Clutch
		375809, -- Broodkeeper's Bond
		380175, -- Greatstaff of the Broodkeeper
		{375889, "SAY"}, -- Greatstaff's Wrath
		375829, -- Clutchwatcher's Rage
		376073, -- Rapid Incubation
		375871, -- Wildfire
		388716, -- Icy Shroud
		{375870, "TANK_HEALER"}, -- Mortal Stoneclaws
		{378782, "TANK"}, -- Mortal Wounds
		-25129, -- Primalist Reinforcements
		-- Primalist Mage
		375716, -- Ice Barrage
		primalistMageMarker,
		-- Tarasek Earthreaver
		{376266, "TANK"}, -- Burrowing Strike
		{376257}, -- Tremors
		-- Dragonspawn Flamebender
		{375485}, -- Cauterizing Flashflames
		{375575}, -- Flame Sentry
		-- Juvenile Frost Proto-Dragon
		{375475, "TANK"}, -- Rending Bite
		{375457}, -- Chilling Tantrum
		-- Drakonid Stormbringer
		375653, -- Static Jolt
		{375620, "SAY"}, -- Ionizing Charge
		-- Stage Two: A Broodkeeper Scorned
		375879, -- Broodkeeper's Fury
		392194, -- Empowered Greatstaff of the Broodkeeper
		{380483, "SAY"}, -- Empowered Greatstaff's Wrath
		388918, -- Frozen Shroud
	}, {
		[375809] = -25119, -- Stage One: The Primalist Clutch
		[375716] = -25144, -- Primalist Mage
		[376266] = -25130, -- Tarasek Earthreaver
		[375485] = -25133, -- Dragonspawn Flamebender
		[375475] = -25136, -- Juvenile Frost Proto-Dragon
		[375653] = -25139, -- Drakonid Stormbringer
		[375879] = -25146, -- Stage Two: A Broodkeeper Scorned
	}, {
		[375809] = L.broodkeepers_bond, -- Broodkeeper's Bond (Eggs Remaining)
		[380175] = L.greatstaff_of_the_broodkeeper, -- Greatstaff of the Broodkeeper (Greatstaff)
		[375889] = L.greatstaffs_wrath, -- Greatstaff's Wrath (Laser)
		[375829] = L.clutchwatchers_rage, -- Clutchwatcher's Rage (Rage)
		[375829] = L.rapid_incubation, -- Rapid Incubation (Infuse Eggs)
		[388716] = L.icy_shroud, -- Icy Shroud (Heal Absorb)
		[-25129] = CL.adds, -- Primalist Reinforcements (Adds)
		[375879] = L.broodkeepers_fury, --  Broodkeeper's Fury (Fury)
		[392194] = L.greatstaff_of_the_broodkeeper, -- Empowered Greatstaff of the Broodkeeper (Greatstaff)
		[380483] = L.greatstaffs_wrath, -- Empowered Greatstaff's Wrath (Wrath)
		[388918] = L.icy_shroud, -- Frozen Shroud (Heal Absorb)
	}
end

function mod:OnBossEnable()
	-- Stage One: The Primalist Clutch
	self:Log("SPELL_AURA_REMOVED_DOSE", "BroodkeepersBondStacks", 375809)
	self:Log("SPELL_AURA_REMOVED", "BroodkeepersBondRemoved", 375809)
	self:Log("SPELL_CAST_SUCCESS", "GreatstaffOfTheBroodkeeper", 380175, 392194) -- Stage 1, Stage 2 (Empowered)
	self:Log("SPELL_AURA_APPLIED", "GreatstaffsWrathApplied", 375889, 380483) -- Stage 1, Stage 2 (Empowered)
	self:Log("SPELL_AURA_APPLIED", "ClutchwatchersRage", 375829)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ClutchwatchersRage", 375829)
	self:Log("SPELL_CAST_START", "RapidIncubation", 376073)
	self:Log("SPELL_CAST_START", "Wildfire", 375871)
	self:Log("SPELL_CAST_START", "IcyShroud", 388716, 388918) -- Stage 1, Stage 2 (Frozen Shroud)
	self:Log("SPELL_CAST_START", "MortalStoneclaws", 375870)
	self:Log("SPELL_AURA_APPLIED", "MortalWounds", 378782)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MortalWounds", 378782)

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE") -- Primalist Reinforcements
	-- Primalist Mage
	self:Log("SPELL_CAST_START", "IceBarrage", 375716)
	self:Death("PrimalistMageDeath", 191206) -- Primalist Mage
	-- Tarasek Earthreaver
	self:Log("SPELL_CAST_SUCCESS", "BurrowingStrike", 376266)
	self:Log("SPELL_AURA_APPLIED", "BurrowingStrikeApplied", 376266)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BurrowingStrikeApplied", 376266)
	self:Log("SPELL_CAST_START", "Tremors", 376257)
	-- Dragonspawn Flamebender
	self:Log("SPELL_CAST_START", "CauterizingFlashflames", 375485)
	self:Log("SPELL_CAST_START", "FlameSentry", 375575)
	-- Juvenile Frost Proto-Dragon
	self:Log("SPELL_CAST_SUCCESS", "RendingBite", 375475)
	self:Log("SPELL_AURA_APPLIED", "RendingBiteApplied", 375475)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RendingBiteApplied", 375475)
	self:Log("SPELL_CAST_START", "ChillingTantrum", 375457)
	-- Drakonid Stormbringer
	self:Log("SPELL_CAST_START", "StaticJolt", 375653)
	self:Log("SPELL_CAST_START", "IonizingCharge", 375630)
	self:Log("SPELL_AURA_APPLIED", "IonizingChargeApplied", 375620)
	self:Log("SPELL_AURA_REMOVED", "IonizingChargeRemoved", 375620)
	self:Log("SPELL_DAMAGE", "IonizingChargeDamage", 375634)
	self:Log("SPELL_MISSED", "IonizingChargeDamage", 375634)

	-- Stage Two: A Broodkeeper Scorned
	self:Log("SPELL_AURA_APPLIED", "BroodkeepersFury", 375879)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BroodkeepersFury", 375879)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 375575) -- Flame Sentry
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 375575)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 375575)
end

function mod:OnEngage()
	self:SetStage(1)
	mobCollector = {}
	primalistMageMarks = {}
	greatstaffCount = 1
	rapidIncubationCount = 1
	wildfireCount = 1
	icyShroudCount = 1
	primalReinforcementsCount = 1

	self:CDBar(375871, 8.5, CL.count:format(self:SpellName(375871), wildfireCount)) -- Wildfire
	self:CDBar(376073, 14.5, CL.count:format(L.rapid_incubation, rapidIncubationCount)) -- Rapid Incubation
	self:CDBar(380175, 17, CL.count:format(L.greatstaff_of_the_broodkeeper, greatstaffCount)) -- Greatstaff of the Broodkeeper
	self:CDBar(-25129, 22, L.add_count:format(CL.adds, primalReinforcementsCount, 1), "inv_dragonwhelpproto_blue") -- Primalist Reinforcements / Adds
	self:CDBar(388716, 26.5, CL.count:format(L.icy_shroud, icyShroudCount)) -- Icy Shroud

	if self:GetOption(primalistMageMarker) then
		self:RegisterTargetEvents("AddMarking")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:AddMarking(_, unit, guid)
	if guid and not mobCollector[guid] and self:MobId(guid) == 191206 then -- Primalist Mage
		for i = 8, 7, -1 do -- 8, 7
			if not primalistMageMarks[i] then
				mobCollector[guid] = true
				primalistMageMarks[i] = guid
				self:CustomIcon(primalistMageMarker, unit, i)
				return
			end
		end
	end
end

function mod:PrimalistMageDeath(args)
	if self:GetOption(primalistMageMarker) then
		for i = 8, 7, -1 do -- 8, 7
			if primalistMageMarks[i] == args.destGUID then
				primalistMageMarks[i] = nil
				return
			end
		end
	end
end

-- Stage One: The Primalist Clutch
do
	local stacks = 0
	local scheduled = nil
	function mod:BroodkeepersBondMessage()
		mod:Message(375809, "cyan", L.eggs_remaining:format(stacks))
		mod:PlaySound(375809, "info")
		scheduled = nil
	end

	function mod:BroodkeepersBondStacks(args)
		stacks = args.amount or 0
		if not scheduled then
			scheduled = self:ScheduleTimer("BroodkeepersBondMessage", 2) -- Throttle here
		end
	end

	function mod:BroodkeepersBondRemoved(args)
		if scheduled then
			self:CancelTimer(scheduled)
			scheduled = nil
		end
		self:Message(args.spellId, "green", L.eggs_remaining:format(0))
		self:PlaySound(args.spellId, "long")
		-- Cancel Add timers? Do they spawn after Emote?
	end
end

function mod:GreatstaffOfTheBroodkeeper(args)
	self:StopBar(CL.count:format(L.greatstaff_of_the_broodkeeper, greatstaffCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.greatstaff_of_the_broodkeeper, greatstaffCount), 380175) -- Same icon for stage 1 + 2
	self:PlaySound(args.spellId, "alert")
	greatstaffCount = greatstaffCount + 1
	self:CDBar(args.spellId, self:Mythic() and 25 or 19, CL.count:format(L.greatstaff_of_the_broodkeeper, greatstaffCount), 380175) -- Same icon for stage 1 + 2
end

function mod:GreatstaffsWrathApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.greatstaffs_wrath)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId, L.greatstaffs_wrath)
	end
end

function mod:ClutchwatchersRage(args)
	self:StackMessage(args.spellId, "orange", args.destName, args.amount, args.amount, L.clutchwatchers_rage)
	self:PlaySound(args.spellId, "alarm")
end

function mod:RapidIncubation(args)
	self:StopBar(CL.count:format(L.rapid_incubation, rapidIncubationCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.rapid_incubation, rapidIncubationCount))
	self:PlaySound(args.spellId, "alert")
	rapidIncubationCount = rapidIncubationCount + 1
	self:CDBar(args.spellId, self:Mythic() and 24.5 or 19.9, CL.count:format(L.rapid_incubation, rapidIncubationCount))
end

do
	local prev = 0
	function mod:Wildfire(args)
		local t = args.time
		if t-prev > 10 then -- Double casts in stage 2
			prev = t
			self:StopBar(CL.count:format(args.spellName, wildfireCount))
			self:Message(args.spellId, "yellow")
			self:PlaySound(args.spellId, "alert")
			wildfireCount = wildfireCount + 1
			local cd = self:GetStage() == 2 and 25 or 21
			if self:Mythic() then
				local cd = 25
			end
			self:CDBar(args.spellId, cd, CL.count:format(args.spellName, wildfireCount))
		end
	end
end

function mod:IcyShroud(args)
	self:StopBar(CL.count:format(L.icy_shroud, icyShroudCount))
	self:StopBar(CL.count:format(L.frozen_shroud, icyShroudCount))
	local text = self:GetStage() == 2 and L.frozen_shroud or L.icy_shroud
	self:Message(args.spellId, "yellow", CL.count:format(text, icyShroudCount))
	self:PlaySound(args.spellId, "alert")
	icyShroudCount = icyShroudCount + 1
	self:CDBar(args.spellId, 40.5, CL.count:format(text, icyShroudCount)) -- XXX Frozen Shroud had a 36s?
end

function mod:MortalStoneclaws(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	local cd = self:GetStage() == 2 and 10 or 20 -- Stage 1: 20~25, Stage 2: 8.5~15
	self:CDBar(args.spellId, cd)
end

function mod:MortalWounds(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, args.amount)
	self:PlaySound(args.spellId, "warning")
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	if msg:find("ABILITY_WARRIOR_DRAGONROAR.BLP") then
		-- [CHAT_MSG_RAID_BOSS_EMOTE] |TInterface\\\\ICONS\\\\ABILITY_WARRIOR_DRAGONROAR.BLP:20|t %s calls for Primalist Reinforcements!#Broodkeeper Diurna#####0#0##0#40970#nil#0#false#false#false#false"

		local offset = 12 -- Timer from emote until activation for the first wave
		self:ScheduleTimer("StopBar", offset, L.add_count:format(CL.adds, primalReinforcementsCount, 1))
		self:ScheduleTimer("Message", offset, -25129, "yellow", L.add_count:format(CL.adds, primalReinforcementsCount, 1), "inv_dragonwhelpproto_blue")
		self:ScheduleTimer("PlaySound", offset, -25129, "long")

		local waveTwoTimer = self:Easy() and 40 or 25 -- Timer from emote until activation
		self:ScheduleTimer("Bar", offset, -25129, waveTwoTimer-offset,  L.add_count:format(CL.adds, primalReinforcementsCount, 2), "inv_dragonwhelpproto_blue")
		self:ScheduleTimer("Message", waveTwoTimer, -25129, "yellow",  L.add_count:format(CL.adds, primalReinforcementsCount, 2), "inv_dragonwhelpproto_blue")
		self:ScheduleTimer("PlaySound", waveTwoTimer, -25129, "long")
		primalReinforcementsCount = primalReinforcementsCount + 1

		self:ScheduleTimer("Bar", waveTwoTimer, -25129, 60 - waveTwoTimer + offset, L.add_count:format(CL.adds, primalReinforcementsCount, 1), "inv_dragonwhelpproto_blue")
		primalistMageMarks = {}
	end
end

-- Primalist Mage
function mod:IceBarrage(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

-- Tarasek Earthreaver
function mod:BurrowingStrike(args)
	--self:NameplateBar(args.spellId, 8.8, args.sourceGUID)
end

function mod:BurrowingStrikeApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "purple", args.destName, args.amount, args.amount)
		if amount > 2 then -- Pay attention on 3+
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

do
	local prev = 0
	function mod:Tremors(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "orange")
			self:PlaySound(args.spellId, "alarm")
		end
		--self:NameplateBar(args.spellId, 11.0, args.sourceGUID)
	end
end

-- Dragonspawn Flamebender
do
	local prev = 0
	function mod:CauterizingFlashflames(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "red")
			self:PlaySound(args.spellId, "alert")
		end
		--self:NameplateBar(args.spellId, 11.5, args.sourceGUID)
	end
end

do
	local prev = 0
	function mod:FlameSentry(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "cyan")
			self:PlaySound(args.spellId, "info")
		end
		--self:NameplateBar(args.spellId, 11.5, args.sourceGUID)
	end
end

-- Juvenile Frost Proto-Dragon
function mod:RendingBite(args)
	--self:NameplateBar(args.spellId, 11.5, args.sourceGUID)
end

function mod:RendingBiteApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, args.amount)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm")
	end
end

do
	local prev = 0
	function mod:ChillingTantrum(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "yellow")
			self:PlaySound(args.spellId, "alert")
		end
		--self:NameplateBar(args.spellId, 11.5, args.sourceGUID)
	end
end

-- Drakonid Stormbringer
function mod:StaticJolt(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

do
	local playerList = {}
	local onMe = false
	function mod:IonizingCharge()
		playerList = {}
	end

	function mod:IonizingChargeApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:PlaySound(args.spellId, "warning")
			onMe = true
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end

	function mod:IonizingChargeRemoved(args)
		if self:Me(args.destGUID) then
			onMe = false
		end
	end

	function mod:IonizingChargeDamage(args)
		if self:Me(args.destGUID) and not onMe then
			self:PlaySound(375620, "underyou")
		end
	end
end

-- Stage Two: A Broodkeeper Scorned
function mod:BroodkeepersFury(args)
	if self:GetStage() == 1 then
		self:SetStage(2)
	end
	local amount = args.amount or 1
	self:StopBar(CL.count:format(L.broodkeepers_fury, amount))
	self:Message(args.spellId, "yellow", CL.count:format(L.broodkeepers_fury, amount))
	self:PlaySound(args.spellId, "info")
	self:Bar(args.spellId, 30, CL.count:format(L.broodkeepers_fury, amount+1))
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
