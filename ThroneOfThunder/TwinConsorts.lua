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
local icyShadowsTimer = nil
local cosmicBarrage, iceComet, fanOfFlames = mod:SpellName(136752), mod:SpellName(137419), mod:SpellName(137408)

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
		"ej:7631", "ej:7634", -- phase 1
		"ej:7649", {137440, "FLASH"}, -- phase 2
		-- Suen
		"ej:7643", -- phase 1
		{137408, "TANK"}, {"ej:7638", "FLASH"}, {137491, "FLASH"}, -- phase 2
		-- Celestial Aid
		"ej:7657", "ej:7658", "ej:7659", "ej:7664",
		"proximity", "stages", "berserk", "bosskill",
	}, {
		["ej:7631"] = "ej:7629",
		["ej:7643"] = "ej:7642",
		["ej:7657"] = "ej:7651",
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
	icyShadowsTimer = nil
	self:OpenProximity("proximity", 8)
	self:CDBar("ej:7631", 14, cosmicBarrage, 136752)
	self:CDBar("ej:7643", 22, self:SpellName(137404), 137404) -- Tears of the Sun
	if self:Tank() or self:Healer() then self:CDBar("ej:7643", 50, self:SpellName(137375), 137375) end -- Beast of Nightmares

end

--------------------------------------------------------------------------------
-- Event Handlers
--

--------------------------------------------------------------------------------
-- Celestial Aid
--

-- Maybe should merge soem of these into 1 function?
function mod:Tiger(args)
	self:Message("ej:7664", "Positive", nil, args.spellId)
	self:Bar("ej:7664", 15, args.spellId)
end

do
	local prev = 0
	function mod:Serpent(args)
		local t = GetTime()
		if t-prev > 2 then
			self:Message("ej:7659", "Positive", nil, args.spellId)
			self:Bar("ej:7659", 15, args.spellId)
			prev = t
		end
	end
end

do
	local prev = 0
	function mod:Crane(args)
		local t = GetTime()
		if t-prev > 20 then
			self:Message("ej:7658", "Positive", nil, args.spellId)
			prev = t
		end
	end
end

do
	local prev = 0
	function mod:Ox(args)
		local t = GetTime()
		if t-prev > 2 then
			self:Message("ej:7657", "Positive", nil, args.spellId)
			self:Bar("ej:7657", 15, args.spellId)
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
		mod:Message(spellId, "Positive", nil, CL["over"]:format(mod:SpellName(spellId)))
	end
	function mod:NuclearInferno(args)
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
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message("ej:7638", "Personal", "Info", CL["underyou"]:format(args.spellName), args.spellId)
			self:Flash("ej:7638")
		end
	end
end

function mod:FanOfFlames(args)
	args.amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, args.amount, "Urgent", "Info")
	self:CDBar(args.spellId, 11)
end

-- Phase 1

function mod:TearsOfTheSunRemoved(args)
	self:Message("ej:7643", "Attention", nil, args.spellId)
end

function mod:TearsOfTheSunApplied(args)
	self:Message("ej:7643", "Positive", nil, CL["over"]:format(args.spellName), args.spellId)
	self:Bar("ej:7643", 41, args.spellId)
end

--------------------------------------------------------------------------------
-- Lu'lin
--

-- Phase 2

do
	local icyShadows = mod:SpellName(137440)
	local function spamIcyShadows(spellId)
		if UnitDebuff("player", icyShadows) then
			if UnitCastingInfo("boss1") ~= mod:SpellName(137491) then -- nuclear inferno
				mod:Message(spellId, "Personal", "Info", CL["underyou"]:format(icyShadows))
			end
		else
			mod:CancelTimer(icyShadowsTimer)
			icyShadowsTimer = nil
		end
	end
	function mod:IcyShadows(args)
		if UnitIsUnit("player", args.destName) then
			if UnitCastingInfo("boss1") ~= self:SpellName(137491) then -- nuclear inferno
				self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			end
			if not icyShadowsTimer then
				icyShadowsTimer = self:ScheduleRepeatingTimer(spamIcyShadows, 2, args.spellId)
			end
		end
	end
end

function mod:IceComet(args)
	self:Message("ej:7649", "Positive", nil, args.spellId)
	self:CDBar("ej:7649", 23, args.spellId)
end

-- Phase 1

function mod:BeastOfNightmares(args)
	if UnitIsUnit("player", args.destName) or self:Tank() then -- this is for tank
		self:Message("ej:7634", "Personal", "Info", CL["you"]:format(args.spellName), args.spellId)
		self:Bar("ej:7634", 51, args.spellId)
	elseif self:Healer() then
		self:TargetMessage("ej:7634", args.destName, "Attention", nil, args.spellId, nil, true)
		self:Bar("ej:7634", 51, args.spellId)
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
		self:StopBar(137375) -- Beast of Nightmares
		self:StopBar(cosmicBarrage)
		self:CDBar("ej:7649", 23, iceComet, 137419)
		if self:Heroic() then self:Bar(137491, 50) end -- Nuclear Inferno
	elseif 68904 == self:MobId(UnitGUID("boss1")) and 68905 == self:MobId(UnitGUID("boss2")) then -- do it like this in case modules stays enabled, so we don't randomly do stuff when other encounter is engaged
		self:Message("stages", "Positive", "Long", CL["phase"]:format(3), 137401)
		self:StopBar(iceComet)
		self:StopBar(fanOfFlames)
	end
end

do
	local function barrageFired(spellId)
		mod:Message("ej:7631", "Urgent", "Alarm", L["barrage_fired"], spellId)
	end
	function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
		if spellId == 136752 then -- channel start of Cosmic Barrage
			self:Message("ej:7631", "Urgent", "Alarm", spellId)
			self:CDBar("ej:7631", 20, spellId)
			self:ScheduleTimer(barrageFired, 5.5, spellId) -- This is when the little orbs start to move ( might not be accurate yet )
		end
	end
end

function mod:Deaths(args)
	deadBosses = deadBosses + 1
	if deadBosses == 2 then
		self:Win()
	end
end

