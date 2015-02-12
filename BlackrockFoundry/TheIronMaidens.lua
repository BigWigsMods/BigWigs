
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Iron Maidens", 988, 1203)
if not mod then return end
mod:RegisterEnableMob(77477, 77557, 77231) -- Marak the Blooded, Admiral Gar'an, Enforcer Sorka
mod.engageId = 1695

--------------------------------------------------------------------------------
-- Locals
--

local shipCount = 0
local boatTimers = {} -- don't announce while on the boat, but track the cd times

local function isOnABoat()
	local _, pos = UnitPosition("player")
	return pos > 3200
end

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.ship_trigger = "prepares to man the Dreadnaught's Main Cannon!"

	L.ship = "Jump to Ship" -- 137266 = Jump to Ship, but doesn't seem to be translated

	L.bombardment = 147135 -- Bombardment
	L.bombardment_desc = -10019 -- The Dreadnaught
	L.bombardment_icon = "ability_ironmaidens_bombardment"

	L.custom_off_heartseeker_marker = "Bloodsoaked Heartseeker marker"
	L.custom_off_heartseeker_marker_desc = "Marks Heartseeker targets with {rt1}{rt2}{rt3}, requires promoted or leader."
	L.custom_off_heartseeker_marker_icon = 1

	L.power_message = "%d Iron Fury!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Dreadnaught ]]--
		"bombardment",
		{158683, "FLASH"}, -- Corrupted Blood
		158708, -- Earthen Barrier
		158692, -- Deadly Throw
		--[[ Gar'an ]]--
		{156631, "ICON", "SAY", "FLASH"}, -- Rapid Fire
		{164271, "ICON", "SAY", "FLASH"}, -- Penetrating Shot
		158599, -- Deploy Turret
		--[[ Sorka ]]--
		155794, -- Blade Dash
		{156109, "DISPEL"}, -- Convulsive Shadows
		158315, -- Dark Hunt
		--[[ Marak ]]--
		{159724, "SAY", "FLASH"}, -- Blood Ritual
		{158010, "SAY", "FLASH"}, -- Heartseeker
		"custom_off_heartseeker_marker",
		156601, -- Sanguine Strikes
		-- [[ General ]]--
		159336, -- Iron Will
		"bosskill"
	}, {
		["bombardment"] = -10019, -- Dreadnaught
		[156626] = -10025, -- Gar'an
		[155794] = -10030, -- Sorka
		[159724] = -10033, -- Marak
		[159336] = "general"
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3")

	self:Log("SPELL_AURA_APPLIED", "IronWill", 159336)
	-- Gar'an
	self:RegisterEvent("RAID_BOSS_WHISPER")
	self:Log("SPELL_AURA_APPLIED", "RapidFire", 156631)
	self:Log("SPELL_AURA_APPLIED", "PenetratingShot", 164271)
	self:Log("SPELL_CAST_START", "DeployTurret", 158599)
	-- Sorka
	self:Log("SPELL_CAST_START", "BladeDash", 155794)
	self:Log("SPELL_CAST_SUCCESS", "ConvulsiveShadows", 156109)
	self:Log("SPELL_AURA_APPLIED", "DarkHunt", 158315)
	-- Marak
	self:Log("SPELL_AURA_APPLIED", "BloodRitual", 159724)
	self:Log("SPELL_AURA_APPLIED", "HeartseekerApplied", 158010)
	self:Log("SPELL_AURA_REMOVED", "HeartseekerRemoved", 158010)
	self:Log("SPELL_AURA_APPLIED", "SanguineStrikes", 156601)
	-- Ship
	self:Emote("ShipPhase", L.ship_trigger) -- 10/40/70 power
	--self:Log("SPELL_CAST_SUCCESS", "ShipPhase", 181089) -- XXX 6.1
	self:Log("SPELL_CAST_SUCCESS", "BombardmentAlpha", 157854)
	self:Log("SPELL_CAST_SUCCESS", "BombardmentOmega", 157886)
	self:Log("SPELL_PERIODIC_DAMAGE", "CorruptedBloodDamage", 158683)
	self:Log("SPELL_PERIODIC_MISSED", "CorruptedBloodDamage", 158683)
	self:Log("SPELL_CAST_START", "EarthenBarrier", 158708)
	self:Log("SPELL_CAST_START", "DeadlyThrow", 158692)
end

function mod:OnEngage()
	shipCount = 0
	wipe(boatTimers)
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss1", "boss2", "boss3")

	self:Bar(158078, 5) -- Blood Ritual
	self:Bar(155794, 11) -- Blade Dash
	self:Bar(156626, 19) -- Rapid Fire
	self:Bar("bombardment", 60, L.ship, "ability_vehicle_siegeenginecannon") -- Jump to Ship
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:UNIT_POWER_FREQUENT(unit, powerType)
		if powerType == "ALTERNATE" then
			local power = UnitPower(unit, 10)
			if power == 1 then
				self:Bar("bombardment", 88, 158849, "inv_elemental_primal_fire") -- Warming Up
			elseif power == 0 then
				self:StopBar(158849) -- Warming Up
				self:StopBar(L.bombardment)
				-- restart timers
				local t = GetTime()
				for spellId, nextTime in next, boatTimers do
					if nextTime > t then
						self:CDBar(spellId, nextTime-t)
					end
				end
				wipe(boatTimers)
			end
		else
			local power = UnitPower(unit)
			if power == prev then return end
			if power == 30 or power == 100 then
				self:Message(159336, "Neutral", "Info", L.power_message:format(power), false)
			end
			prev = power
		end
	end
end

do
	local prev = 0
	function mod:IronWill(args)
		local t = GetTime()
		if t-prev > 5 then
			prev = t
			self:Message(args.spellId, "Important", "Long")
			self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "boss1", "boss2", "boss3")
			self:StopBar(L.ship) -- Jump to Ship
		end
	end
end

-- Ship

local function stopBars(mobId)
	if mobId == 77477 or mobId == true then -- Marak
		mod:StopBar(159724) -- Blood Ritual
		mod:StopBar(158010) -- Heartseeker
		mod:StopBar(156601) -- Sanguine Strikes
	end
	if mobId == 77557 or mobId == true then -- Gar'an
		mod:StopBar(156631) -- Rapid Fire
		mod:StopBar(164271) -- Penetrating Shot
		mod:StopBar(158599) -- Deploy Turret
	end
	if mobId == 77231 or mobId == true then -- Sorka
		mod:StopBar(155794) -- Blade Dash
		mod:StopBar(156109) -- Convulsive Shadows
	end
end

local function checkBoat()
	if isOnABoat() then
		stopBars(true)
	end
end

--[[
-- XXX 6.1
function mod:ShipPhase(args)
	shipCount = shipCount + 1
	self:Message("bombardment", "Neutral", "Info", CL.other:format(L.ship, args.sourceName), false)
	stopBars(self:MobId(args.sourceGUID))
	if shipCount < 3 then
		self:Bar("bombardment", 198, L.ship, "ability_vehicle_siegeenginecannon")
	end
	self:ScheduleTimer(checkBoat, 6)
end
--]]

function mod:ShipPhase(msg, sender)
	shipCount = shipCount + 1
	self:Message("bombardment", "Neutral", "Info", CL.other:format(L.ship, sender), false)
	if sender == self:SpellName(-10025) then -- Gar'an
		stopBars(77557)
	elseif sender == self:SpellName(-10030) then -- Sorka
		stopBars(77231)
	elseif sender == self:SpellName(-10033) then -- Marak
		stopBars(77477)
	end
	if shipCount < 3 then
		self:Bar("bombardment", 198, L.ship, "ability_vehicle_siegeenginecannon")
	end
	self:ScheduleTimer(checkBoat, 6)
end

function mod:BombardmentAlpha(args)
	if isOnABoat() then return end
	self:Message("bombardment", "Neutral", nil, args.spellId)
	self:CDBar("bombardment", 18, L.bombardment, L.bombardment_icon)
end

function mod:BombardmentOmega(args)
	if isOnABoat() then return end
	self:Message("bombardment", "Neutral", nil, args.spellId)
end

do
	local prev = 0
	function mod:CorruptedBloodDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

function mod:EarthenBarrier(args)
	if isOnABoat() then
		self:Message(args.spellId, "Urgent", "Alert")
		self:CDBar(args.spellId, 10)
	end
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(158692, name, "Urgent", "Alert")
	end
	function mod:DeadlyThrow(args)
		if isOnABoat() then
			self:GetBossTarget(printTarget, 0.1, args.sourceGUID)
			self:Bar(args.spellId, 13)
		end
	end
end

-- Gar'an

function mod:RAID_BOSS_WHISPER(_, msg, sender)
	if msg:find("156626", nil, true) then -- Rapid Fire
		local text = CL.you:format(self:SpellName(156631))
		self:Message(156631, "Personal", "Alarm", text)
		self:Bar(156631, 10.5, text)
		self:Flash(156631)
		self:Say(156631)
	end
end

function mod:RapidFire(args)
	self:PrimaryIcon(args.spellId, args.destName)
	if isOnABoat() then
		boatTimers[args.spellId] = GetTime() + 31.6
		return
	end
	if not self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Urgent")
	end
	self:Bar(args.spellId, 31.6)
end

function mod:IncendiaryDevice(args)
	if isOnABoat() then
		return
	end
	self:Message(args.spellId, "Important")
end

function mod:PenetratingShot(args)
	self:SecondaryIcon(args.spellId, args.destName)
	if isOnABoat() then
		boatTimers[args.spellId] = GetTime() + 30
		return
	end
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:Flash(args.spellId)
		self:Bar(args.spellId, self:Normal() and 8 or 6, CL.you:format(args.spellName))
		self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
	else
		self:TargetBar(args.spellId, self:Normal() and 8 or 6, args.destName)
		self:TargetMessage(args.spellId, args.destName, "Important", "Warning", nil, nil, true)
	end
	self:Bar(args.spellId, 30)
end

function mod:DeployTurret(args)
	if isOnABoat() then
		boatTimers[args.spellId] = GetTime() + 22
		return
	end
	self:Message(args.spellId, "Attention")
	--self:CDBar(args.spellId, 22) -- 17-43 (?!)
end

-- Sorka

function mod:BladeDash(args)
	if isOnABoat() then
		boatTimers[args.spellId] = GetTime() + 20
		return
	end
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 20)
end

function mod:ConvulsiveShadows(args)
	local dispeller = self:Dispeller("magic", nil, 156109)
	if dispeller and isOnABoat() then
		boatTimers[args.spellId] = GetTime() + 56
		return
	end
	if dispeller or self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Urgent", "Info")
	end
	if dispeller then
		self:Bar(args.spellId, 56)
	end
end

function mod:DarkHunt(args)
	if isOnABoat() then
		--boatTimers[args.spellId] = GetTime() + 13
		return
	end
	self:TargetMessage(args.spellId, args.destName, "Attention")
	self:TargetBar(args.spellId, 8, args.destName)
	--self:CDBar(args.spellId, 13) -- 13.39-15.89
end

-- Marak

function mod:BloodRitual(args)
	if isOnABoat() then
		boatTimers[args.spellId] = GetTime() + 20
		return
	end
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:Flash(args.spellId)
		self:Bar(args.spellId, 5, CL.you:format(args.spellName))
		self:Message(args.spellId, "Personal", "Alert", CL.you:format(args.spellName))
	else
		self:TargetBar(args.spellId, 5, args.destName)
		self:TargetMessage(args.spellId, args.destName, "Attention")
	end
	self:Bar(args.spellId, 20)
end

do
	local targets, scheduled = mod:NewTargetList(), nil
	local function warnTargets(spellId)
		if not isOnABoat() then
			mod:TargetMessage(spellId, targets, "Urgent", "Alert")
		end
		wipe(targets)
		scheduled = nil
	end
	function mod:HeartseekerApplied(args)
		targets[#targets+1] = args.destName
		if self:Me(args.spellId) then
			self:TargetBar(args.spellId, 5, args.destName)
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
		if self.db.profile.custom_off_heartseeker_marker then
			SetRaidTarget(args.destName, #targets)
		end
		if not scheduled then
			if isOnABoat() then
				boatTimers[args.spellId] = GetTime() + 70
			else
				self:CDBar(args.spellId, 70)
			end
			scheduled = self:ScheduleTimer(warnTargets, 0.1, args.spellId)
		end
	end
	function mod:HeartseekerRemoved(args)
		if self.db.profile.custom_off_heartseeker_marker then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:SanguineStrikes(args)
	self:Message(args.spellId, "Important")
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 70628 then -- Permanent Feign Death
		local mobId = self:MobId(UnitGUID(unit))
		stopBars(mobId)
	end
end

