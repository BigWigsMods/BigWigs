
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
local blastTime = 30
local volatileFireOnMe = nil
local volatileFireTargets = {}
local bombOnMe = nil
local bombTargets = {}

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
		155179,
		{155192, "SAY", "PROXIMITY", "FLASH"}, -- Furnace Engineer
		156937,
		{175104, "TANK_HEALER"},
		{156932, "FLASH"}, -- Foreman Feldspar
		-10325,
		{155173, "DISPEL"}, -- Primal Elementalist
		{-10324, "SAY"}, -- Slag Elemental
		155186,
		{176121, "SAY", "PROXIMITY", "FLASH"}, -- Firecaller
		155209,
		{155242, "TANK"},
		{155223, "SAY", "FLASH"}, -- Heart of the Mountain
		"stages",
		"bosskill"
	}, {
		[-9650] = CL.adds,
		[156937] = -9640, -- Foreman Feldspar
		[-10325] = -9655, -- Primal Elementalist
		[155209] = -9641, -- Heart of the Mountain
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Loading", 155181) -- Bellows Operator
	-- Primal Elementalist
	self:Log("SPELL_AURA_APPLIED", "ShieldsDown", 158345) 
	self:Log("SPELL_AURA_APPLIED", "ReactiveEarthShield", 155173)
	self:Log("SPELL_AURA_APPLIED", "Fixate", 155196) -- Slag Elemental
	-- Furnace Engineer
	self:Log("SPELL_CAST_START", "Repair", 155179)
	self:Log("SPELL_AURA_APPLIED", "Bomb", 155192, 176123) -- 2nd is the bomb from stack after the engineer is dead
	self:Log("SPELL_AURA_REMOVED", "BombRemoved", 155192, 176123)
	-- Firecaller
	self:Log("SPELL_CAST_START", "CauterizeWounds", 155186)
	self:Log("SPELL_AURA_APPLIED", "VolatileFireApplied", 176121)
	self:Log("SPELL_AURA_REMOVED", "VolatileFireRemoved", 176121)
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
	self:Log("SPELL_AURA_APPLIED", "Melt", 155225) -- player will spawn puddle when the debuff expires
	self:Log("SPELL_PERIODIC_DAMAGE", "MeltDamage", 155223)
	self:Log("SPELL_PERIODIC_MISSED", "MeltDamage", 155223)

	self:Death("Deaths", 76808, 76815) -- Heat Regulator, Primal Elementalist
end

function mod:OnEngage()
	regulatorDeaths, shamanDeaths = 0, 0
	blastTime = 30
	
	wipe(volatileFireTargets)
	wipe(bombTargets)
	volatileFireOnMe = nil
	bombOnMe = nil
	
	self:Bar(155209, blastTime) -- Blast
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss1")
end

function mod:OnBossDisable()
	wipe(volatileFireTargets)
	wipe(bombTargets)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function updateProximity()
	-- open in reverse order so if you disable one it doesn't block others from showing
	if #volatileFireTargets > 0 then
		mod:OpenProximity(176121, 8, volatileFireTargets)
	end
	if #bombTargets > 0 then -- someone shouldn't be standing there without a bomb, so this might not be needed
		mod:OpenProximity(155192, 8, bombTargets) -- how big is the radius? i have no idea
	end
	if volatileFireOnMe then
		mod:OpenProximity(176121, 8)
	end
	if bombOnMe then
		mod:OpenProximity(155192, 8) -- how big is the radius? i have no idea
	end
end

-- Adds

do
	local prev = 0
	function mod:Loading(args)
		local t = GetTime()
		if t-prev > 5 then
			prev = t
			self:Message(-9650, "Attention", "Info") -- Bellows Operator
			self:Bar(-9650, 64, nil, 155181)
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
		self:Message(155192, "Positive", "Alarm", CL.you:format(args.spellName)) -- is good thing
		self:TargetBar(155192, 15, args.destName)
		self:Flash(155192)
		self:Say(155192)
		bombOnMe = true
	end
	if not tContains(bombTargets, args.destName) then -- SPELL_AURA_REFRESH
		bombTargets[#bombTargets+1] = args.destName
	end
	
	updateProximity()
end

function mod:BombRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellId, args.destName)
		self:CloseProximity(args.spellId)
		bombOnMe = nil
	end
	tDeleteItem(bombTargets, args.destName)
	
	if #bombTargets == 0 then
		self:CloseProximity(args.spellId)
	end
	
	updateProximity()
end

-- Primal Elementalist

function mod:ShieldsDown(args)
	self:Message(-10325, "Positive", "Info", CL.removed:format(self:SpellName(155176))) -- Damage Shield Removed!
	self:Bar(-10325, 25)
	
	for i = 1,5 do -- i have no idea if this works
		if UnitAura("boss"..i, self:SpellName(158345)) then  -- Look for Shield Down Buff
			SetRaidTarget("boss"..i, 8)
		end 
	end
end

function mod:Fixate(args)
	if self:Me(args.destGUID) then
		self:Message(-10324, "Personal", "Alarm", CL.you:format(args.spellName))
		self:Flash(-10324)
		self:Say(-10324)
	end
end

function mod:ReactiveEarthShield(args)
	if self:Dispeller("magic", nil, args.spellId) then
		self:Message(args.spellId, "Urgent", "Info")
	end
end

function mod:CauterizeWounds(args)
	self:Message(args.spellId, "Urgent", not self:Healer() and "Alert")
end

function mod:VolatileFireApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
		self:Bar(args.spellId, 8, CL.you:format(args.spellName))
		if not self:LFR() then
			self:Say(args.spellId)
		end
		self:Flash(args.spellId)
		volatileFireOnMe = true
	end
	
	if not tContains(volatileFireTargets, args.destName) then -- SPELL_AURA_REFRESH
		volatileFireTargets[#volatileFireTargets+1] = args.destName
	end
	
	updateProximity()
end

function mod:VolatileFireRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
		volatileFireOnMe = nil
	end
	tDeleteItem(volatileFireTargets, args.destName)
	
	if #volatileFireTargets == 0 then
		self:CloseProximity(args.spellId)
	end
	
	updateProximity()
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
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

-- Heart of the Mountain

do
	local warned = nil
	function mod:UNIT_POWER_FREQUENT(unit, powerType)
		if powerType == "ALTERNATE" then
			-- energy rate is based on altpower
			local altpower = UnitPower(unit, 10)
			local newTime = 30
			if altpower == 100 then
				newTime = 6
			elseif altpower > 74 then
				newTime = 9
			elseif altpower > 49 then
				newTime = 15
			elseif altpower > 24 then
				newTime = 20
			end

			-- adjust Blast timer
			if newTime ~= blastTime then
				if newTime < blastTime then
					self:Message(155209, "Attention", nil, L.heat_increased_message:format(newTime))
				end
				blastTime = newTime
				local t = ceil((100-UnitPower(unit))/(100/newTime))
				self:Bar(155209, t)
			end
			return
		end

		local power = UnitPower(unit)
		if power > 80 and power < 100 and not warned then
			if blastTime > 10 then
				self:Message(155209, "Urgent", "Alarm", CL.soon:format(self:SpellName(155209)))
			end
			warned = true
		elseif power == 0 and warned then
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
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
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

function mod:Melt(args)
	if self:Me(args.destGUID) then
		self:Message(155223, "Personal", "Alarm", CL.you:format(args.spellName))
		self:Flash(155223)
		self:Say(155223)
	end
end
