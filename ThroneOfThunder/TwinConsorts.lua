--[[
TODO:
	code abilities used in the last phase when both bosses are there ( need logs )
	:OnEngage bar durations need to be double checked
	probably shouldn't use INSTANCE_ENCOUNTER_ENGAGE_UNIT for phase tracking ( see XXX )
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
		{137408, "TANK"}, {"ej:7638", "FLASH"}, -- phase 2
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
	self:Bar("stages", CL["phase"]:format(2), 184, 137440)
	deadBosses = 0
	icyShadowsTimer = nil
	self:OpenProximity("proximity", 8)
	self:Bar("ej:7631", "~"..cosmicBarrage, 14, 136752)
	self:Bar("ej:7643", "~"..self:SpellName(137404), 22, 137404) -- Tears of the Sun
	if self:Tank() or self:Healer() then self:Bar("ej:7643", "~"..self:SpellName(137375), 50, 137375) end -- Beast of Nightmares

end

--------------------------------------------------------------------------------
-- Event Handlers
--

--------------------------------------------------------------------------------
-- Celestial Aid
--

-- Maybe should merge soem of these into 1 function?
function mod:Tiger(args)
	self:Message("ej:7664", args.spellName, "Positive", args.spellId)
	self:Bar("ej:7664", args.spellName, 15, args.spellId)
end

do
	local prev = 0
	function mod:Serpent(args)
		local t = GetTime()
		if t-prev > 2 then
			self:Message("ej:7659", args.spellName, "Positive", args.spellId)
			self:Bar("ej:7659", args.spellName, 15, args.spellId)
			prev = t
		end
	end
end

do
	local prev = 0
	function mod:Crane(args)
		local t = GetTime()
		if t-prev > 2 then
			self:Message("ej:7658", args.spellName, "Positive", args.spellId)
			prev = t
		end
	end
end

do
	local prev = 0
	function mod:Ox(args)
		local t = GetTime()
		if t-prev > 2 then
			self:Message("ej:7657", args.spellName, "Positive", args.spellId)
			self:Bar("ej:7657", args.spellName, 15, args.spellId)
			prev = t
		end
	end
end

--------------------------------------------------------------------------------
-- Suen
--

-- Phase 2

do
	local prev = 0
	function mod:FlamesOfPassion(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage("ej:7638", CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info")
			self:Flash("ej:7638")
		end
	end
end

function mod:FanOfFlames(args)
	args.amount = args.amount or 1
	self:LocalMessage(args.spellId, CL["stack"], "Urgent", args.spellId, "Info", args.destName, args.amount, args.spellName)
	self:Bar(args.spellId, "~"..args.spellName, 11, args.spellId)
end

-- Phase 1

function mod:TearsOfTheSunRemoved(args)
	self:Message("ej:7643", args.spellName, "Attention", args.spellId)
end

function mod:TearsOfTheSunApplied(args)
	self:Message("ej:7643", CL["over"]:format(args.spellName), "Positive", args.spellId)
	self:Bar("ej:7643", args.spellName, 41, args.spellId)
end

--------------------------------------------------------------------------------
-- Lu'lin
--

-- Phase 2

do
	local icyShadows = mod:SpellName(137440)
	local function spamIcyShadows(spellId)
		if UnitDebuff("player", icyShadows) then
			mod:LocalMessage(spellId, CL["underyou"]:format(icyShadows), "Personal", spellId, "Info")
		else
			mod:CancelTimer(icyShadowsTimer)
			icyShadowsTimer = nil
		end
	end
	function mod:IcyShadows(args)
		if UnitIsUnit("player", args.destName) then
			self:LocalMessage(args.spellId, CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info")
			if not icyShadowsTimer then
				icyShadowsTimer = self:ScheduleRepeatingTimer(spamIcyShadows, 2, args.spellId)
			end
		end
	end
end

function mod:IceComet(args)
	self:Message("ej:7649", args.spellName, "Positive", args.spellId)
	self:Bar("ej:7649", "~"..args.spellName, 23, args.spellId)
end

-- Phase 1

function mod:BeastOfNightmares(args)
	if UnitIsUnit("player", destName) or self:Tank() then -- this is for tank
		self:LocalMessage("ej:7634", CL["you"]:format(args.spellName), "Personal", args.spellId, "Info")
		self:Bar("ej:7634", args.spellName, 51, args.spellId)
	elseif self:Healer() then
		self:LocalMessage("ej:7634", args.spellName, "Attention", args.spellId, nil, args.destName)
		self:Bar("ej:7634", args.spellName, 51, args.spellId)
	end
end

--------------------------------------------------------------------------------
-- General
--

function mod:Phases()
	self:CheckBossStatus()
	-- XXX could probably use some other event instead like: "<2319.7 01:50:18> [UNIT_SPELLCAST_SUCCEEDED] Lu'lin [[boss1:Dissipate::0:137187]]", -- [589]
	-- if last phase has something like that too, probably should use those instead
	if 68904 == self:GetCID(UnitGUID("boss1")) and not UnitExists("boss2") then -- 2nd phase
		self:Bar("stages", CL["phase"]:format(3), 184, 138688)
		self:Message("stages", CL["phase"]:format(2), "Positive", 137401, "Long")
		self:StopBar(137404) -- Tears of the Sun
		self:StopBar(137375) -- Beast of Nightmares
		self:StopBar("~"..cosmicBarrage)
		self:Bar("ej:7649", "~"..iceComet, 23, 137419)
	elseif 68904 == self:GetCID(UnitGUID("boss1")) and 68905 == self:GetCID(UnitGUID("boss2")) then -- do it like this in case modules stays enabled, so we don't randomly do stuff when other encounter is engaged
		self:Message("stages", CL["phase"]:format(3), "Positive", 137401, "Long")
		self:StopBar("~"..iceComet)
		self:StopBar("~"..fanOfFlames)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 136752 then -- channel start of Cosmic Barrage
		self:Message("ej:7631", spellName, "Urgent", spellId, "Alarm")
		self:Bar("ej:7631", "~"..spellName, 20, spellId)
	end
end

function mod:Deaths(args)
	deadBosses = deadBosses + 1
	if deadBosses == 2 then
		self:Win()
	end
end

