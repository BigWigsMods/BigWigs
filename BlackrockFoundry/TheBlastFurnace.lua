
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Blast Furnace", 988, 1154)
if not mod then return end
mod:RegisterEnableMob(76809, 76808, 76806, 76815) -- Foreman Feldspar, Heat Regulator, Heart of the Mountain, Primal Elementalist
mod.engageId = 1690

--------------------------------------------------------------------------------
-- Locals
--

local regulatorDeaths = 0
local shamanDeaths = 0
local blastTime = 25
local volatileFireTargets = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.heat_increased_message = "Heat increased! Blast every %ss"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-9650, -- Bellows Operator
		155179, {155192, "FLASH"}, -- Furnace Engineer
		{160379, "TANK"}, -- Security Guard
		156937, {175104, "TANK_HEALER"}, {156932, "FLASH"}, -- Foreman Feldspar
		-10325, -- Primal Elementalist
		-10324, -- Slag Elemental
		155186, {176121, "SAY", "FLASH"}, -- Firecaller
		155209, {155242, "TANK"}, {155223, "FLASH"}, 163776, -- Heart of the Mountain
		"stages", "bosskill"
	}, {
		[-9650] = CL.adds,
		--[155179] = -9649,
		--[160379] = -9648,
		[156937] = -9640, -- Foreman Feldspar
		[-10325] = -9655, -- Primal Elementalist
		--[-10324] = -9657,
		--[155186] = -9659,
		[155209] = -9641, -- Heart of the Mountain
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Loading", 155181) -- Bellows Operator
	self:Log("SPELL_CAST_START", "Defense", 160379) -- Security Guard
	self:Log("SPELL_AURA_APPLIED", "ShieldsDown", 158345) -- Primal Elementalist
	self:Log("SPELL_AURA_APPLIED", "Fixate", 155196) -- Slag Elemental
	-- Furnace Engineer
	self:Log("SPELL_CAST_START", "Repair", 155179)
	self:Log("SPELL_AURA_APPLIED", "Bomb", 155192)
	self:Log("SPELL_AURA_REMOVED", "BombRemoved", 155192)
	-- Firecaller
	self:Log("SPELL_CAST_START", "CauterizeWounds", 155186)
	self:Log("SPELL_AURA_APPLIED", "VolatileFireApplied", 176121)
	--self:Log("SPELL_AURA_REMOVED", "VolatileFireRemoved", 176121)
	-- Foreman Feldspar
	self:Log("SPELL_CAST_START", "Pyroclasm", 156937)
	self:Log("SPELL_AURA_APPLIED", "MeltArmor", 175104)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MeltArmor", 175104)
	--self:Log("SPELL_CAST_START", "Rupture", 156934) -- 22-27.8
	self:Log("SPELL_PERIODIC_DAMAGE", "RuptureDamage", 156932)
	self:Log("SPELL_PERIODIC_MISSED", "RuptureDamage", 156932)
	-- Heart of the Mountain
	self:Log("SPELL_AURA_APPLIED", "Heat", 155242)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Heat", 155242)
	--self:Log("SPELL_CAST_SUCCESS", "Melt", 155225) -- 7.2-10.8
	self:Log("SPELL_PERIODIC_DAMAGE", "MeltDamage", 155223)
	self:Log("SPELL_PERIODIC_MISSED", "MeltDamage", 155223)
	self:Log("SPELL_AURA_APPLIED", "CoolingDown", 156880)
	self:Log("SPELL_AURA_APPLIED", "Superheated", 163776)

	self:Death("Deaths", 76808, 76815) -- Heat Regulator, Primal Elementalist
end

function mod:OnEngage()
	regulatorDeaths, shamanDeaths = 0, 0
	blastTime = 25 -- 4 energy/s
	wipe(volatileFireTargets)

	self:Bar(155209, blastTime) -- Blast
	self:Bar(-9650, 55, nil, 155181) -- Bellows Operator
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Adds

do
	local prev = 0
	function mod:Loading(args)
		local t = GetTime()
		if t-prev > 5 then
			self:Message(-9650, "Attention", "Info") -- Bellows Operator
			self:Bar(-9650, 60, nil, 155181)
			prev = t
		end
	end
end

function mod:Repair(args)
	if not self:Healer() then
		self:Message(args.spellId, "Personal", "Alert", CL.other:format(args.sourceName, args.spellName))
	end
end

function mod:Bomb(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Positive", "Alarm", CL.you:format(args.spellName)) -- is good thing
		self:TargetBar(args.spellId, 15, args.destName)
		self:Flash(args.spellId)
	end
end

function mod:BombRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellId, args.destName)
	end
end

function mod:Defense(args)
	-- warn the tank
	local unit = self:GetUnitIdByGUID(args.sourceGUID)
	if self:Tank() and UnitDetailedThreatSituation("player", unit) then
		self:Message(args.spellId, "Urgent")
	end
end

-- Primal Elementalist

function mod:ShieldsDown(args)
	self:Message(-10325, "Positive", "Info", CL.removed:format(self:SpellName(155176))) -- Damage Shield Removed!
	self:Bar(-10325, 25)
end

function mod:Fixate(args)
	if self:Me(args.destGUID) then
		self:Message(-10324, "Personal", "Alarm", CL.you:format(args.spellName))
		self:Flash(-10324)
	end
end

function mod:CauterizeWounds(args)
	self:Message(args.spellId, "Urgent", not self:Healer() and "Alert")
end

do
	local list, scheduled = mod:NewTargetList(), nil
	local function warnTargets(spellId)
		mod:TargetMessage(spellId, list, "Urgent", "Alarm")
		scheduled = nil
	end
	function mod:VolatileFireApplied(args)
		if self:Me(args.destGUID) then
			if not self:LFR() then
				self:Say(args.spellId)
			end
			self:Flash(args.spellId)
		end
		list[#list+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(warnTargets, 0.1, args.spellId)
		end
	end
end

-- Foreman Feldspar

function mod:Pyroclasm(args)
	self:Message(args.spellId, "Attention", nil, CL.casting:format(args.spellName))
end

function mod:MeltArmor(args)
	self:TargetMessage(args.spellId, args.destName, "Attention")
	self:Bar(args.spellId, 10)
end

do
	local prev = 0
	function mod:RuptureDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			self:Flash(args.spellId)
			prev = t
		end
	end
end

-- Heart of the Mountain

do
	local warned = nil
	function mod:UNIT_POWER_FREQUENT(unit, powerType)
		if powerType == "ALTERNATE" then
			-- energy rate is based on altpower, 1 = 4/s, 100 = 20/s
			local altpower = UnitPower(unit, 10)
			local ps = max(4, floor(altpower/5))
			local newTime = ceil(100/ps)

			-- adjust Blast timer
			if newTime ~= blastTime then
				if newTime < blastTime then
					self:Message(155209, "Attention", nil, L.heat_increased_message:format(newTime))
				end
				blastTime = newTime
				local t = ceil((100-UnitPower(unit))/ps)
				self:Bar(155209, t)
			end
			return
		end

		local power = UnitPower(unit)
		if power > 80 and power < 100 and not warned then
			self:Message(155209, "Urgent", "Alarm", CL.soon:format(self:SpellName(155209)))
			warned = true
		elseif power == 100 and warned then
			self:Bar(155209, blastTime)
			warned = nil
		end
	end
end

function mod:Heat(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Attention", "Warning")
end

do
	local prev = 0
	function mod:MeltDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			self:Flash(args.spellId)
			prev = t
		end
	end
end

function mod:CoolingDown(args)
	-- losing 1 altpower/3s
	local altpower = UnitPower("boss1", 10)
	local t = floor(altpower/3)
	self:Bar(163776, t) -- Superheated
end

function mod:Superheated(args)
	self:Message(args.spellId, "Important", "Warning")

	self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "boss1")
	blastTime = 5 -- 20 energy/s

	local power = UnitPower("boss1")
	local t = ceil((100-power)/20)
	self:Bar(155209, t) -- Blast
end


function mod:Deaths(args)
	if args.mobId == 76808 then
		regulatorDeaths = regulatorDeaths + 1
		self:Message("stages", "Neutral", "Info", CL.mob_killed:format(args.destName, regulatorDeaths, 2), false)
		if regulatorDeaths > 1 then
			-- Primalists spawn
			self:StopBar(-9650) -- Bellows Operator
		end
	elseif args.mobId == 76815 then
		shamanDeaths = shamanDeaths + 1
		self:Message("stages", "Neutral", "Info", CL.mob_killed:format(args.destName, shamanDeaths, 4), false)
		if shamanDeaths > 3 then
			-- The Fury is free! (after the next Blast cast?)
		end
	end
end

