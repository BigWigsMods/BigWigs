--[[
TODO:
	code abilities used in the last phase when both bosses are there ( need logs )
	:OnEngage bar durations need to be double checked
	verify constellation durations for heroics
]]--

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
local inferno = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.last_phase_yell_trigger = "Just this once..." -- "<490.4 01:24:30> CHAT_MSG_MONSTER_YELL#Just this once...#Lu'lin###Suen##0#0##0#3273#nil#0#false#false", -- [6]

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
		137531, --Phase 3
		-- Suen
		-7643, -- phase 1
		{137408, "TANK"}, {-7638, "FLASH"}, {137491, "FLASH"}, -- phase 2
		-- Celestial Aid
		138300, 138318, 138306, 138855,
		"proximity", "stages", "berserk", "bosskill",
	}, {
		[-7631] = -7629,
		[-7643] = -7642,
		[138300] = -7651,
		["proximity"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- Celestial Aid
	self:Log("SPELL_AURA_APPLIED", "CelestialAid", 138855, 138306, 138300) -- Tiger, Serpent, Ox
	self:Log("SPELL_DAMAGE", "Crane", 138318)

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
		-- phase 3
	self:Log("SPELL_CAST_START", "TidalForce", 137531)
		-- phase 2
	self:Log("SPELL_AURA_APPLIED", "IcyShadows", 137440)
	self:Log("SPELL_SUMMON", "IceComet", 137419)
		-- phase 1
	self:Log("SPELL_CAST_SUCCESS", "CosmicBarrage", 136752)
	self:Log("SPELL_CAST_SUCCESS", "BeastOfNightmares", 137375)

	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Phase2", "boss1", "boss2")
	self:Yell("LastPhase", L["last_phase_yell_trigger"])

	self:AddSyncListener("Phase2")
	self:AddSyncListener("Phase3")
	self:AddSyncListener("TidalForce")

	self:Death("Deaths", 68905, 68904)
end

function mod:OnEngage()
	self:Berserk(600) -- 25 N PTR Confirmed
	self:Bar("stages", 184, CL["phase"]:format(2), 137440)
	deadBosses = 0
	self:OpenProximity("proximity", 8)
	self:CDBar(-7631, 14) -- Cosmic Barrage
	self:CDBar(-7643, 22) -- Tears of the Sun
	if self:Tank() or self:Healer() then
		self:CDBar(-7634, 50) -- Beast of Nightmares
	end
	inferno = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:OnSync(sync)
	if sync == "Phase2" then
		self:Bar("stages", 184, CL["phase"]:format(3), 138688)
		self:Message("stages", "Positive", "Long", CL["phase"]:format(2), 137401)
		self:StopBar(137404) -- Tears of the Sun
		self:StopBar(-7634) -- Beast of Nightmares
		self:StopBar(-7631) -- Cosmic Barrage
		self:CDBar(-7649, 23) -- Ice Comet
		if self:Heroic() then
			self:Bar(137491, 50) -- Nuclear Inferno
		end
	elseif sync == "Phase3" then
		self:Message("stages", "Positive", "Long", CL["phase"]:format(3), 137401)
		self:StopBar(-7649) -- Ice Comet
		self:StopBar(137408) -- Fan of Flames
		self:Bar(137531, self:Heroic() and 19 or 34) -- Tidal Force
	elseif sync == "TidalForce" then
		self:Message(137531, "Urgent", "Alarm")
		self:CDBar(137531, 71)
	end
end

--------------------------------------------------------------------------------
-- Celestial Aid
--

do
	local prev = 0
	function mod:CelestialAid(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Positive")
			self:Bar(args.spellId, args.spellId == 138855 and 20 or 30) -- Xuen lasts 20s
		end
	end
end

do
	local prev = 0
	function mod:Crane(args)
		local t = GetTime()
		if t-prev > 30 then
			self:Message(args.spellId, "Positive")
			prev = t
		end
	end
end


--------------------------------------------------------------------------------
-- Suen
--

-- Phase 2

do
	local function infernoOver(spellId)
		inferno = nil
		mod:Message(spellId, "Positive", nil, CL["over"]:format(mod:SpellName(spellId)))
	end
	function mod:NuclearInferno(args)
		inferno = true
		self:Message(args.spellId, "Important", "Alert")
		self:Flash(args.spellId)
		self:Bar(args.spellId, 55)
		self:Bar(args.spellId, 12, CL["cast"]:format(args.spellName))
		self:ScheduleTimer(infernoOver, 12, args.spellId)
	end
end

do
	local prev = 0
	function mod:FlamesOfPassion(args)
		if not self:Me(args.destGUID) then return end
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
	self:Message(-7643, "Positive", nil, CL["over"]:format(args.spellName))
end

function mod:TearsOfTheSunApplied(args)
	self:Message(-7643, "Attention")
	self:Bar(-7643, 41)
end

--------------------------------------------------------------------------------
-- Lu'lin
--

-- Phase 3

function mod:TidalForce(args)
	self:Sync("TidalForce")
end

-- Phase 2

function mod:IcyShadows(args)
	if self:Me(args.destGUID) and not inferno and not self:Tank() then
		self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
	end
end

function mod:IceComet(args)
	self:Message(-7649, "Positive")
	self:CDBar(-7649, 23)
end

-- Phase 1

function mod:CosmicBarrage(args)
	self:Message(-7631, "Urgent", "Alarm")
	self:CDBar(-7631, 20)
	self:ScheduleTimer("Message", 5.5, -7631, "Urgent", "Alarm", L["barrage_fired"]) -- This is when the little orbs start to move
end

function mod:BeastOfNightmares(args)
	if self:Me(args.destGUID) then -- this is for tank
		self:Message(-7634, "Personal", "Info", CL["you"]:format(args.spellName))
		self:Bar(-7634, 51)
	end
	if self:Healer() then
		self:TargetMessage(-7634, args.destName, "Attention", nil, nil, nil, true)
		self:Bar(-7634, 51)
	end
end

--------------------------------------------------------------------------------
-- General
--

function mod:Phase2(_, _, _, _, spellId)
	if spellId == 137187 then -- Lu'lin Dissipate
		self:Sync("Phase2")
	end
end

function mod:LastPhase()
	self:Sync("Phase3")
end

function mod:Deaths(args)
	if args.mobId == 68905 then -- Lu'lin
		self:StopBar(-7631) -- Cosmic Barrage
		self:StopBar(137531) -- Tidal Force
	elseif args.mobId == 68904 then -- Suen
		self:StopBar(137491) -- Nuclear Inferno
		if self:Tank() or self:Healer() then
			self:CDBar(-7634, 55) -- Beasts of Nightmare
		end
	end
	deadBosses = deadBosses + 1
	if deadBosses == 2 then
		self:Win()
	end
end

