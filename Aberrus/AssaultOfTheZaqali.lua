--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Assault of the Zaqali", 2569, 2524)
if not mod then return end
mod:RegisterEnableMob(199659, 202791) -- Warlord Kagni, Ignara
mod:SetEncounterID(2682)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local pullTime = 0

-- Stage 1
local heavyCudgelCount = 1
local devastatingLeapCount = 1
local phoenixRushCount = 1
local vigerousGaleCount = 1
local commandersCount = 1

-- Stage 2
local devastatingSlamCount = 1
local flamingCudgelCount = 1

local addTimers = {
	-- Can use improvements on Mystics, do we even care about Wallclimbers?
	[-26217] = {25, 80, 135, 180, 235, 280}, -- Magma Mystic
	--[-26221] = {80, 100, 100, 100}, -- Zaqali Wallclimbers
}

local addWaveCount = {
	[-26217] = 1, -- Magma Mystic
	[-26221] = 1, -- Zaqali Wallclimbers
}
local addScheduledTimers = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.big_adds_timer = "Timers for Huntsman + Guards"
	L.final_assault_soon = "Final Assault soon"

	L.south_adds_message = "Big Adds Climbing SOUTH!"
	L.south_adds = "Commanders ascend the southern battlement!" -- |TInterface\\ICONS\\Ability_Hunter_KillCommand.blp:20|t Commanders ascend the southern battlement!
	L.north_adds_message = "Big Adds Climbing NORTH!"
	L.north_adds = "Commanders ascend the northern battlement!" -- |TInterface\\ICONS\\Ability_Hunter_KillCommand.blp:20|t Commanders ascend the northern battlement!

	L.wallclimbers_bartext = "Wallclimbers"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		-- Warlord Kagni
		408959, -- Devastating Leap
		{401258, "TANK"}, -- Heavy Cudgel
		-- Magma Mystic
		-26217, -- Magma Mystic
		397383, -- Molten Barrier
		409275, -- Magma Flow
		397386, -- Lava Bolt
		-- Flamebound Huntsman
		"big_adds_timer",
		{401401, "SAY"}, -- Blazing Spear
		-- Obsidian Guard
		408620, -- Scorching Roar
		{401867, "SAY", "SAY_COUNTDOWN"}, -- Volcanic Shield
		-26221, -- Zaqali Wallclimbers
		-- Stage Two: Warlord's Will
		409359, -- Desperate Immolation
		410516, -- Devastating Slam
		{410351, "TANK"}, -- Flaming Cudgel
		-- Mythic
		401108, -- Phoenix Rush
		401381, -- Blazing Focus
		407017, -- Vigorous Gale
	}, {
		[398938] = -26209, -- Warlord Kagni
		[397383] = -26217, -- Magma Mystic
		[401401] = -26213, -- Flamebound Huntsman
		[408620] = -26210, -- Obsidian Guard
		[409359] = -26683, -- Stage Two: Warlord's Will
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("RAID_BOSS_EMOTE")

	-- Warlord Kagni
	self:Log("SPELL_CAST_SUCCESS", "DevastatingLeap", 408959)
	self:Log("SPELL_CAST_START", "HeavyCudgel", 401258)
	self:Log("SPELL_AURA_APPLIED", "HeavyCudgelApplied", 408873)
	self:Log("SPELL_AURA_APPLIED_DOSE", "HeavyCudgelApplied", 408873)

	-- Magma Mystic
	self:Log("SPELL_CAST_START", "MoltenBarrier", 397383)
	self:Log("SPELL_CAST_START", "MagmaFlow", 409271)
	self:Log("SPELL_AURA_APPLIED", "MagmaFlowApplied", 409275)
	self:Log("SPELL_CAST_START", "LavaBolt", 397386)

	-- Flamebound Huntsman
	self:Log("SPELL_AURA_APPLIED", "BlazingSpearApplied", 401452)

	-- Obsidian Guard
	self:Log("SPELL_CAST_START", "ScorchingRoar", 408620)
	self:Log("SPELL_AURA_APPLIED", "VolcanicShieldApplied", 401867)
	self:Log("SPELL_AURA_REMOVED", "VolcanicShieldRemoved", 401867)

	-- Stage Two: Warlord's Will
	self:Log("SPELL_CAST_SUCCESS", "DesperateImmolation", 397514)
	self:Log("SPELL_CAST_SUCCESS", "DevastatingSlam", 410516)
	self:Log("SPELL_CAST_START", "FlamingCudgel", 410351)
	self:Log("SPELL_AURA_APPLIED", "FlamingCudgelApplied", 410353)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FlamingCudgelApplied", 410353)

	-- Mythic
	self:Log("SPELL_CAST_START", "PhoenixRush", 401108)
	self:Log("SPELL_AURA_APPLIED", "BlazingFocusApplied", 401381)
	self:Log("SPELL_CAST_SUCCESS", "VigorousGale", 407017)
end

function mod:OnEngage()
	pullTime = GetTime()
	addWaveCount = {
		[-26217] = 1, -- Magma Mystic
		[-26221] = 1, -- Zaqali Wallclimbers
	}
	addScheduledTimers = {}

	heavyCudgelCount = 1
	devastatingLeapCount = 1
	phoenixRushCount = 1
	vigerousGaleCount = 1
	commandersCount = 1

	self:Bar(401258, 12, CL.count:format(self:SpellName(401258), heavyCudgelCount)) -- Heavy Cudgel
	self:Bar(408959, 98, CL.count:format(self:SpellName(408959), devastatingLeapCount)) -- Devastating Leap
	self:Bar("big_adds_timer", 42, CL.count:format(CL.big_adds, commandersCount), "inv_10_blacksmithing_consumable_repairhammer_color2")

	for key,count in pairs(addWaveCount) do
		self:StartAddTimer(key, count)
	end

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:RAID_BOSS_EMOTE(_, msg)
	if msg:find(L.south_adds, nil, true) then
		self:Message("big_adds_timer", "yellow", L.south_adds_message, "inv_10_blacksmithing_consumable_repairhammer_color2") -- Any better icon for these adds?
	elseif msg:find(L.north_adds, nil, true)  then
		self:Message("big_adds_timer", "yellow", L.north_adds_message, "inv_10_blacksmithing_consumable_repairhammer_color2")
	end
	commandersCount = commandersCount + 1
	local cd = {5, 22, 29, 23, 21}
	local addWaveMod = commandersCount % 5 + 1 -- 1, 2, 3, 4, 5
	self:Bar("big_adds_timer", commandersCount == 2 and 34 or cd[addWaveMod], CL.count:format(CL.big_adds, commandersCount), "inv_10_blacksmithing_consumable_repairhammer_color2")
end

do
	local addStyling = {
			[-26217] = {mod:SpellName(-26217), "inv_misc_orb_05"}, -- Magma Mystic
			[-26221] = {L.wallclimbers_bartext, "creatureportrait_ropeladder01"}, -- Zaqali Wallclimbers
	}

	function mod:StartAddTimer(addType, count)
		local timers = addTimers[addType]
		if not timers[count] then return end

		local time = addTimers[addType][count] - (GetTime()-pullTime)
		local spellName, icon = unpack(addStyling[addType])
		local spellId = addType -- SetOption:-26217, -26221:
		self:Bar(spellId, time, CL.count:format(spellName, addWaveCount[spellId]), icon)
		self:DelayedMessage(spellId, time, "yellow", CL.count:format(spellName, addWaveCount[spellId]), icon, "info")
		addWaveCount[spellId] = addWaveCount[spellId] + 1
		addScheduledTimers[spellId] = self:ScheduleTimer("StartAddTimer", time, spellId, addWaveCount[spellId])
	end
end


function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 28 then -- "Final Assault" at 15%
		self:Message("stages", "cyan", L.final_assault_soon, false)
		self:PlaySound("stages", "info")
		self:UnregisterUnitEvent(event, unit)
	end
end

-- Warlord Kagni
function mod:HeavyCudgel(args)
	self:StopBar(CL.count:format(args.spellName, heavyCudgelCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, heavyCudgelCount))
	self:PlaySound(args.spellId, "alert")
	heavyCudgelCount = heavyCudgelCount + 1
	local cd = {26.0, 22.0, 31.0, 21.0} -- Repeats after 2nd cast
	local castCount = (heavyCudgelCount % 4) + 1 -- 1, 2, 3, 4
	self:Bar(args.spellId, heavyCudgelCount == 2 and 59.5 or cd[castCount], CL.count:format(args.spellName, heavyCudgelCount))
end

function mod:HeavyCudgelApplied(args)
	local amount = args.amount or 1
	self:StackMessage(401258, "purple", args.destName, amount, 2)
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	if amount > 2 and self:Tank() and not self:Tanking(bossUnit) then -- Maybe swap?
		self:PlaySound(401258, "warning")
	elseif self:Me(args.destGUID) then
		self:PlaySound(401258, "alarm")
	end
end

function mod:DevastatingLeap(args)
	self:StopBar(CL.count:format(args.spellName, devastatingLeapCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, devastatingLeapCount))
	self:PlaySound(args.spellId, "alert")
	devastatingLeapCount = devastatingLeapCount + 1
	self:CDBar(args.spellId, devastatingLeapCount % 2 == 0 and 47.4 or 52.3, CL.count:format(args.spellName, devastatingLeapCount))
end

-- Magma Mystic
do
	local prev = 0
	function mod:MoltenBarrier(args)
		if args.time-prev > 2 then
			prev = args.time
			self:Message(args.spellId, "yellow")
			self:PlaySound(args.spellId, "info")
		end
	end
end

do
	local prev = 0
	function mod:MagmaFlow(args)
		if args.time-prev > 2 then
			prev = args.time
			-- Range check?
			self:Message(409275, "orange")
			self:PlaySound(409275, "alert")
		end
	end
end

function mod:MagmaFlowApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:LavaBolt(args)
	-- Range check?
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "orange")
		if ready then
			self:PlaySound(args.spellId, "alert") -- interrupt
		end
	end
end

-- Flamebound Huntsman
function mod:BlazingSpearApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(401401)
		self:Say(401401)
		self:PlaySound(401401, "warning")
	end
end

-- Obsidian Guard
do
	local prev = 0
	function mod:ScorchingRoar(args)
		if args.time-prev > 2 then
			prev = args.time
			self:Message(args.spellId, "orange")
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:VolcanicShieldApplied(args)
	self:TargetMessage(args.spellId, "yellow", args.destName)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Yell(args.spellId)
		self:YellCountdown(args.spellId, 6)
	end
end

function mod:VolcanicShieldRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelYellCountdown(args.spellId)
	end
end

-- Stage 2
function mod:DesperateImmolation(args)
	for key,count in pairs(addWaveCount) do -- Cancel add bars and scheduled messages
		local text = CL.count:format(self:SpellName(key), count-1)
		self:CancelDelayedMessage(text)
		self:StopBar(text)
	end
	for key, scheduled in pairs(addScheduledTimers) do -- cancel all scheduled add timers
		self:CancelTimer(scheduled)
		addScheduledTimers[key] = nil
	end

	self:SetStage(2)
	self:StopBar(CL.count:format(self:SpellName(408959), devastatingLeapCount)) -- Devastating Leap
	self:StopBar(CL.count:format(self:SpellName(401258), heavyCudgelCount)) -- Heavy Cudgel
	self:StopBar(CL.count:format(self:SpellName(401108), phoenixRushCount)) -- Phoenix Rush
	self:StopBar(CL.count:format(self:SpellName(407017), vigerousGaleCount)) -- Vigerous Gale
	self:StopBar(CL.count:format(CL.big_adds, commandersCount)) -- Big Adds

	self:Message(409359, "red")
	self:PlaySound(409359, "long")

	self:Bar(410351, 26, CL.count:format(self:SpellName(410351), flamingCudgelCount)) -- Flaming Cudgel
	self:CDBar(410516, 43.5, CL.count:format(self:SpellName(410516), devastatingSlamCount)) -- Devastating Slam
end

function mod:DevastatingSlam(args)
	self:StopBar(CL.count:format(args.spellName, devastatingSlamCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, devastatingSlamCount))
	self:PlaySound(args.spellId, "warning")
	devastatingSlamCount = devastatingSlamCount + 1
	self:CDBar(args.spellId, 32, CL.count:format(args.spellName, devastatingSlamCount))
end

function mod:FlamingCudgel(args)
	self:StopBar(CL.count:format(args.spellName, flamingCudgelCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, flamingCudgelCount))
	self:PlaySound(args.spellId, "alert")
	flamingCudgelCount = flamingCudgelCount + 1
	self:Bar(args.spellId, 34, CL.count:format(args.spellName, flamingCudgelCount))
end

function mod:FlamingCudgelApplied(args)
	local amount = args.amount or 1
	self:StackMessage(401258, "purple", args.destName, amount, 2)
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	if amount > 2 and self:Tank() and not self:Tanking(bossUnit) then -- Maybe swap?
		self:PlaySound(401258, "warning")
	elseif self:Me(args.destGUID) then
		self:PlaySound(401258, "alarm")
	end
end

-- Mythic
function mod:PhoenixRush(args)
	self:StopBar(CL.count:format(args.spellName, phoenixRushCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, phoenixRushCount))
	self:PlaySound(args.spellId, "long")
	phoenixRushCount = phoenixRushCount + 1
	--self:CDBar(args.spellId, 32, CL.count:format(args.spellName, phoenixRushCount))
end

function mod:BlazingFocusApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.fixate)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:VigorousGale(args)
	-- Range Check?
	self:StopBar(CL.count:format(args.spellName, vigerousGaleCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, vigerousGaleCount))
	self:PlaySound(args.spellId, "alert")
	vigerousGaleCount = vigerousGaleCount + 1
	--self:Bar(args.spellId, 34, CL.count:format(args.spellName, vigerousGaleCount))
end
