
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Calamir", -1015, 1774)
if not mod then return end
mod:RegisterEnableMob(109331)
mod.otherMenu = -1007
mod.worldBoss = 109331

--------------------------------------------------------------------------------
-- Locals
--

local burningBombCount = 1
local arcaneDesolationCount = 1
local howlingGaleCount = 1
local arcanopulseCount = 1
local castCollector = {} -- for all UNIT casts

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ General ]]--
		"stages",
		--[[ Ancient Rage: Fire ]]--
		{217877, "SAY", "PROXIMITY"}, -- Burning Bomb
		217893, -- Wrathful Flames
		--[[ Ancient Rage: Frost ]]--
		217966, -- Howling Gale
		217925, -- Icy Comet
		--[[ Ancient Rage: Arcane  ]]--
		217986, -- Arcane Desolation
		218012, -- Arcanopulse
	},{
		["stages"] = "general",
		[217877] = 217563, -- Ancient Rage: Fire
		[217966] = 217831, -- Ancient Rage: Frost
		[217986] = 217834, -- Ancient Rage: Arcane
	}
end

function mod:OnBossEnable()
	--[[ General ]] --
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")

	--[[ Ancient Rage: Fire ]]--
	self:Log("SPELL_AURA_APPLIED", "BurningBomb", 217877)
	self:Log("SPELL_AURA_REMOVED", "BurningBombRemoved", 217877)
	self:Log("SPELL_CAST_SUCCESS", "BurningBombSuccess", 217874)
	self:Log("SPELL_CAST_SUCCESS", "WrathfulFlames", 217893)

	--[[ Ancient Rage: Frost ]]--
	self:Log("SPELL_CAST_SUCCESS", "HowlingGale", 217966)
	self:Log("SPELL_AURA_APPLIED", "IcyCometApplied", 217925)

	--[[ Ancient Rage: Arcane  ]]--
	self:Log("SPELL_CAST_SUCCESS", "ArcaneDesolation", 217986)
end

function mod:OnEngage()
	self:CheckForWipe()
	burningBombCount = 1
	howlingGaleCount = 1
	arcaneDesolationCount = 1
	arcanopulseCount = 1
	wipe(castCollector)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ General ]] --
function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, castGUID, spellId)
	if castCollector[castGUID] then return end -- don't fire twice for the same cast

	if spellId == 217563 then --[[ Ancient Rage: Fire ]]--
		castCollector[castGUID] = true
		self:Message("stages", "Neutral", "Info", spellId)
		self:Bar("stages", 25.6, self:SpellName(217831), 217831) -- next: Frost
		burningBombCount = 1
		self:CDBar(217877, 2) -- Burning Bomb
		self:CDBar(217893, 8.2) -- Wrathful Flames
	elseif spellId == 217831 then --[[ Ancient Rage: Frost ]]--
		castCollector[castGUID] = true
		self:Message("stages", "Neutral", "Info", spellId)
		self:Bar("stages", 25.6, self:SpellName(217834), 217834) -- next: Arcane
		howlingGaleCount = 1
		self:CDBar(217966, 2) -- Howling Gale
		self:CDBar(217925, 8.5) -- Icy Comet
	elseif spellId == 217834 then --[[ Ancient Rage: Arcane  ]]--
		castCollector[castGUID] = true
		self:Message("stages", "Neutral", "Info", spellId)
		self:Bar("stages", 25.6, self:SpellName(217563), 217563) -- next: Fire
		arcanopulseCount = 1
		arcaneDesolationCount = 1
		self:CDBar(217986, 2) -- Arcane Desolation
		-- First Arcanopulse happens directly in the phase, so we start the bar after it
	elseif spellId == 217919 then -- Icy Comet
		castCollector[castGUID] = true
		self:Message(217925, "Attention", "Long")
	elseif spellId == 218005 then -- Arcanopulse
		castCollector[castGUID] = true
		self:Message(218012, "Attention", "Long")
		if arcanopulseCount == 1 then -- first one is happening directly after Ancient Rage: Arance
			self:CDBar(218012, 10.5)
		end
		arcanopulseCount = arcanopulseCount + 1
	end
end

function mod:BOSS_KILL(_, id)
	if id == 1952 then
		wipe(castCollector)
		self:Win()
	end
end

--[[ Ancient Rage: Fire ]]--
do
	local list = mod:NewTargetList()
	function mod:BurningBomb(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Attention", "Alert", nil, nil, self:Dispeller("magic"))
		end
		if self:Me(args.destGUID) then
			self:OpenProximity(args.spellId, 10)
			self:Say(args.spellId)
			self:TargetBar(args.spellId, 8, args.destName)
		end
	end

	function mod:BurningBombRemoved(args)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", nil, CL.removed:format(args.spellName))
			self:CloseProximity(args.spellId)
			self:StopBar(args.spellId, args.destName)
		end
	end
end

function mod:BurningBombSuccess()
	if burningBombCount == 1 then
		self:CDBar(217877, 13.4)
	end
	burningBombCount = burningBombCount + 1
end

function mod:WrathfulFlames(args)
	self:Message(args.spellId, "Important", "Alarm")
end

--[[ Ancient Rage: Frost ]]--
function mod:HowlingGale(args)
	self:Message(args.spellId, "Important", "Warning")
	if howlingGaleCount == 1 then
		self:CDBar(args.spellId, 12.5)
	end
	howlingGaleCount = howlingGaleCount + 1
end

function mod:IcyCometApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
	end
end

--[[ Ancient Rage: Arcane  ]]--
function mod:ArcaneDesolation(args)
	self:Message(args.spellId, "Important", "Alert")
	if arcaneDesolationCount == 1 then
		self:CDBar(args.spellId, 12)
	end
	arcaneDesolationCount = arcaneDesolationCount + 1
end
