--[[
TODO:
	code abilities used in the last phase when both bosses are there ( need logs )
	:OnEngage bar durations need to be double checked
	probably shouldn't use INSTANCE_ENCOUNTER_ENGAGE_UNIT for phase tracking ( see XXX )
	verify cosmic barrage fire timer
]]--
if select(4, GetBuildInfo()) < 50200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Twin Consorts", 930, 829)
if not mod then return end
mod:RegisterEnableMob(68905, 68904) -- Lu'lin, Suen

--------------------------------------------------------------------------------
-- Locals
--

local deadBosses = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.barrage_fired = "Barrage fired!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Lu'lin
		-7631, -7634, -- phase 1
		-7649, {137440, "FLASH"}, -- phase 2
		-- Suen
		-7643, -- phase 1
		{137408, "TANK"}, {-7638, "FLASH"}, {137491, "FLASH"}, -- phase 2
		-- Celestial Aid
		-7657, -7658, -7659, -7664,
		"proximity", "stages", "berserk", "bosskill",
	}, {
		[-7631] = -7629,
		[-7643] = -7642,
		[-7657] = -7651,
		["proximity"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "Phases")

	-- Celestial Aid
	self:Log("SPELL_AURA_APPLIED", "Tiger", 138645)
	self:Log("SPELL_AURA_APPLIED", "Serpent", 138306)
	self:Log("SPELL_DAMAGE", "Crane", 138318)
	self:Log("SPELL_AURA_APPLIED", "Ox", 138300)
	-- Suen
		-- phase 2
	self:Log("SPELL_CAST_START", "NuclearInferno", 137491)
	self:Log("SPELL_PERIODIC_DAMAGE", "FlamesOfPassion", 137417)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FanOfFlames", 137408)
	self:Log("SPELL_AURA_APPLIED", "FanOfFlames", 137408)
		-- phase 1
	self:Log("SPELL_AURA_REMOVED", "TearsOfTheSunRemoved", 137404)
	self:Log("SPELL_AURA_APPLIED", "TearsOfTheSunApplied", 137404)

	-- Lu'lin
		-- phase 2
	self:Log("SPELL_AURA_APPLIED", "IcyShadows", 137440)
	self:Log("SPELL_SUMMON", "IceComet", 137419)
		-- phase 1
	self:Log("SPELL_CAST_SUCCESS", "BeastOfNightmares", 137375)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Death("Deaths", 68905, 68904)
end

function mod:OnEngage()
	self:Berserk(720) -- XXX assumed
	self:Bar("stages", 184, CL["phase"]:format(2), 137440)
	deadBosses = 0
	self:OpenProximity("proximity", 8)
	self:CDBar(-7631, 14) -- Cosmic Barrage
	self:CDBar(-7643, 22) -- Tears of the Sun
	if self:Tank() or self:Healer() then
		self:CDBar(-7634, 50) -- Beast of Nightmares
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--------------------------------------------------------------------------------
-- Celestial Aid
--

-- Maybe should merge soem of these into 1 function?
function mod:Tiger(args)
	self:Message(-7664, "Positive", nil, args.spellId)
	self:Bar(-7664, 15, args.spellId)
end

do
	local prev = 0
	function mod:Serpent(args)
		local t = GetTime()
		if t-prev > 2 then
			self:Message(-7659, "Positive", nil, args.spellId)
			self:Bar(-7659, 15, args.spellId)
			prev = t
		end
	end
end

do
	local prev = 0
	function mod:Crane(args)
		local t = GetTime()
		if t-prev > 20 then
			self:Message(-7658, "Positive", nil, args.spellId)
			prev = t
		end
	end
end

do
	local prev = 0
	function mod:Ox(args)
		local t = GetTime()
		if t-prev > 2 then
			self:Message(-7657, "Positive", nil, args.spellId)
			self:Bar(-7657, 15, args.spellId)
			prev = t
		end
	end
end

--------------------------------------------------------------------------------
-- Suen
--

-- Phase 2


function mod:NuclearInferno(args)
	self:Message(args.spellId, "Important", "Alert")
	self:Flash(args.spellId)
	self:Bar(args.spellId, 55)
	self:Bar(args.spellId, 12, CL["cast"]:format(args.spellName))
	self:ScheduleTimer("Message", 12, args.spellId, "Positive", nil, CL["over"]:format(args.spellName))
end

do
	local prev = 0
	function mod:FlamesOfPassion(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(-7638, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(-7638)
		end
	end
end

function mod:FanOfFlames(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Urgent", "Info")
	self:CDBar(args.spellId, 11)
end

-- Phase 1

function mod:TearsOfTheSunRemoved(args)
	self:Message(-7643, "Attention")
end

function mod:TearsOfTheSunApplied(args)
	self:Message(-7643, "Positive", nil, CL["over"]:format(args.spellName))
	self:Bar(-7643, 41)
end

--------------------------------------------------------------------------------
-- Lu'lin
--

-- Phase 2

function mod:IcyShadows(args)
	if UnitDebuff("player", self:SpellName(137440)) and UnitCastingInfo("boss1") ~= self:SpellName(137491) then -- Nuclear Inferno
		self:Message(137440, "Personal", "Info", CL["underyou"]:format(self:SpellName(137440)))
		self:ScheduleTimer("IcyShadows", 2)
	end
end

function mod:IceComet(args)
	self:Message(-7649, "Positive")
	self:CDBar(-7649, 23)
end

-- Phase 1

function mod:BeastOfNightmares(args)
	if UnitIsUnit("player", args.destName) or self:Tank() then -- this is for tank
		self:Message(-7634, "Personal", "Info", CL["you"]:format(args.spellName))
		self:Bar(-7634, 51)
	elseif self:Healer() then
		self:TargetMessage(-7634, args.destName, "Attention", nil, nil, nil, true)
		self:Bar(-7634, 51)
	end
end

--------------------------------------------------------------------------------
-- General
--

function mod:Phases()
	self:CheckBossStatus()
	-- XXX could probably use some other event instead like: "<2319.7 01:50:18> [UNIT_SPELLCAST_SUCCEEDED] Lu'lin [[boss1:Dissipate::0:137187]]", -- [589]
	-- if last phase has something like that too, probably should use those instead
	if 68904 == self:MobId(UnitGUID("boss1")) and not UnitExists("boss2") then -- 2nd phase
		self:Bar("stages", 184, CL["phase"]:format(3), 138688)
		self:Message("stages", "Positive", "Long", CL["phase"]:format(2), 137401)
		self:StopBar(137404) -- Tears of the Sun
		self:StopBar(-7634) -- Beast of Nightmares
		self:StopBar(-7631) -- Cosmic Barrage
		self:CDBar(-7649, 23) -- IceComet
		if self:Heroic() then
			self:Bar(137491, 50) -- Nuclear Inferno
		end
	elseif 68904 == self:MobId(UnitGUID("boss1")) and 68905 == self:MobId(UnitGUID("boss2")) then -- do it like this in case modules stays enabled, so we don't randomly do stuff when other encounter is engaged
		self:Message("stages", "Positive", "Long", CL["phase"]:format(3), 137401)
		self:StopBar(-7649) -- Ice Comet
		self:StopBar(137408) -- Fan of Flames
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 136752 then -- channel start of Cosmic Barrage
		self:Message(-7631, "Urgent", "Alarm")
		self:CDBar(-7631, 20)
		self:ScheduleTimer("Message", 5.5, -7631, "Urgent", "Alarm", L["barrage_fired"]) -- This is when the little orbs start to move ( might not be accurate yet )
	end
end

function mod:Deaths(args)
	deadBosses = deadBosses + 1
	if deadBosses == 2 then
		self:Win()
	end
end

