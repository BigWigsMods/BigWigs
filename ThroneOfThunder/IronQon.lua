--[[
TODO:
	bugged Arcing Lightning, expect a spellId or name change for this once they fix the ability ( not fixed in 10 N ptr )
	windstorm needs a better trigger, no CLEU or anything as of 10 N ptr
]]--

if select(4, GetBuildInfo()) < 50200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Iron Qon", 930, 817)
if not mod then return end
mod:RegisterEnableMob(68078, 68079, 68080, 68081) -- Iron Qon, Ro'shak, Quet'zal, Dam'ren

--------------------------------------------------------------------------------
-- Locals
--


--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.molten_energy = "Molten Energy"
	L.molten_energy_desc = EJ_GetSectionInfo(6973)
	L.molten_energy_icon = 137221

	L.overload_casting = "Molten Overload casting"
	L.overload_casting_desc = "Warning for when Molten Overload is casting"
	L.overload_casting_icon = 137221
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"ej:6914", 136520,
		"ej:6877", {137669, "FLASH"}, {136192, "ICON", "PROXIMITY"},
		137221, "overload_casting", {"ej:6870", "PROXIMITY"}, "ej:6871", {137668, "FLASH"},
		{134926, "FLASH", "SAY"}, "berserk", "bosskill",
	}, {
		["ej:6914"] = "ej:6867", -- Dam'ren
		["ej:6877"] = "ej:6866", -- Quet'zal
		[137221] = "ej:6865", -- Ro'shak
		[134926] = "general",
	}
end

function mod:OnBossEnable()
	-- Dam'ren
	self:Log("SPELL_DAMAGE", "FrozenBlood", 136520)
	self:Log("SPELL_CAST_SUCCESS", "DeadZone", 137226, 137227, 137228, 137229, 137230, 137231) -- figure out why it has so many spellIds
	-- Quet'zal
-- the bugged Arcing Lightning, expect a spellId or name change for this once they fix the ability
--1/18 02:39:13.776  SPELL_AURA_APPLIED,0xF15109F000002837,"Quet'zal",0x10a48,0x0,0x02000000000038DB,"Calebh",0x511,0x80,136192,"Lightning Storm",0x8,DEBUFF
	self:Log("SPELL_AURA_APPLIED", "ArcingLightningApplied", 136192)
	self:Log("SPELL_AURA_REMOVED", "ArcingLightningRemoved", 136192)
	self:Log("SPELL_DAMAGE", "StormCloud", 137669)
	self:Log("SPELL_AURA_APPLIED", "Windstorm", 136577)
	-- Ro'shak
	self:Log("SPELL_DAMAGE", "BurningCinders", 137668)
	self:Log("SPELL_AURA_APPLIED", "Scorched", 134647)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Scorched", 134647)
	self:Log("SPELL_AURA_APPLIED", "MoltenOverloadApplied", 137221)
	self:Log("SPELL_AURA_REMOVED", "MoltenOverloadRemoved", 137221)
	-- General
	self:Log("SPELL_SUMMON", "ThrowSpear", 134926)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Deaths", 68078, 68079, 68080, 68081)
end

function mod:OnEngage()
	self:Berserk(600) -- confirmed for 10 normal
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "PowerWarn", "boss2")
	self:OpenProximity("ej:6870", 10)
	self:Bar(134926, "~"..self:SpellName(134926), 33, 134926) -- Throw spear
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Dam'ren

do
	local prev = 0
	function mod:FrozenBlood(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(args.spellId, CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info")
			self:Flash(args.spellId)
		end
	end
end

function mod:DeadZone(args)
	self:Message("ej:6914", args.spellName, "Attention", args.spellId)
	self:Bar("ej:6914", args.spellName, 16, args.spellId)
end

-- Quet'zal

function mod:ArcingLightningApplied(args)
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetMessage(args.spellId, args.spellName, args.destName, "Urgent", args.spellId) -- no point for sound since the guy stunned can't do anything
	self:Bar(args.spellId, args.spellName, 20, args.spellId)
end

function mod:ArcingLightningRemoved(args)
	self:PrimaryIcon(args.spellId)
end

do
	local prev = 0
	function mod:StormCloud(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(args.spellId, CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info")
			self:Flash(args.spellId)
		end
	end
end

function mod:Windstorm(args)
	self:Message("ej:6877", args.spellName, "Attention", args.spellId)
	self:Bar("ej:6877", args.spellName, 90, args.spellId)
end

-- Ro'shak

do
	local prev = 0
	function mod:BurningCinders(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(args.spellId, CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info")
			self:Flash(args.spellId)
		end
	end
end

function mod:Scorched(args)
	args.amount = args.amount or 1
	if args.amount > 4 and UnitIsUnit(args.destName, "player") then
		self:LocalMessage("ej:6871", ("%s (%d)"):format(args.spellName, args.amount), "Important", args.spellId)
	end
	self:Bar("ej:6870", "~"..self:SpellName(134628), 6, 134628) -- XXX Unleashed Flame - don't think there is any point to this, maybe coordinating personal cooldowns?
end

do
	local prevPower = 0
	function mod:MoltenOverloadRemoved()
		prevPower = 0
		self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "PowerWarn", "boss2")
	end
	function mod:PowerWarn(unitId)
		if unitId ~= "boss2" then return end
		local power = UnitPower(unitId)
		if power > 64 and prevPower == 0 then
			prevPower = 65
			self:Message("molten_energy", ("%s (%d%%)"):format(L["molten_energy"], power), "Attention", 137221)
		elseif power > 74 and prevPower == 65 then
			prevPower = 75
			self:Message("molten_energy", ("%s (%d%%)"):format(L["molten_energy"], power), "Urgent", 137221)
		elseif power > 84 and prevPower == 75 then
			prevPower = 85
			self:Message("molten_energy", ("%s (%d%%)"):format(L["molten_energy"], power), "Important", 137221)
		elseif power > 94 and prevPower == 85 then
			prevPower = 95
			self:Message("molten_energy", ("%s (%d%%)"):format(L["molten_energy"], power), "Important", 137221)
		end
	end
end

function mod:MoltenOverloadApplied(args)
	self:Message("overload_casting", args.spellName, "Important", args.spellId, "Alert")
	self:Bar("overload_casting", CL["cast"]:format(args.spellName), 10, args.spellId) -- XXX don't think there is any point to this, maybe coordinating raid cooldowns?
	self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "boss2")
end

-- General
do
	local timer, fired = nil, 0
	local function spearWarn(spellId)
		fired = fired + 1
		local player = UnitName("boss2target")
		if player and (not UnitDetailedThreatSituation("boss2target", "boss2") or fired > 13) then
			-- If we've done 14 (0.7s) checks and still not passing the threat check, it's probably being cast on the tank
			mod:TargetMessage(spellId, spellId, player, "Urgent", spellId, "Alarm")
			mod:CancelTimer(timer)
			timer = nil
			if UnitIsUnit("boss2target", "player") then
				mod:Flash(spellId)
				mod:Say(spellId, CL["say"]:format(mod:SpellName(spellId)))
			end
			return
		end
		-- 19 == 0.95sec
		-- Safety check if the unit doesn't exist
		if fired > 18 then
			mod:CancelTimer(timer)
			timer = nil
		end
	end
	function mod:ThrowSpear(args)
		self:Bar(args.spellId, "~"..args.spellName, 33, args.spellId)
		fired = 0
		if not timer then
			timer = self:ScheduleRepeatingTimer(spearWarn, 0.05, args.spellId)
		end
	end
end


function mod:Deaths(args)
	if args.mobId == 68079 then -- Ro'shak
		self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "boss2")
		self:CloseProximity("ej:6870")
		self:StopBar(137221) -- Molten Overload
		self:StopBar(134628) -- Unleashed Flame
		self:Bar("ej:6877", 136577, 50, 136577) -- Windstorm
		self:Bar(136192, 136192, 17, 136192) -- Arcing Lightning
		self:OpenProximity(136192, 8) -- Arcing Lightning -- assume 8 yards
	elseif args.mobId == 68080 then -- Quet'zal
		self:StopBar(136577) -- Windstorm
		self:StopBar(136192) -- Arcing Lightning
		self:CloseProximity(136192)
		self:Bar("ej:6914", 137226, 7, 137226) -- Dead Zone
	elseif args.mobId == 68081 then -- Dam'ren
		self:StopBar(137226) -- Dead zone
	elseif args.mobId == 68078 then -- Iron Qon
		self:Win()
	end
end