
--------------------------------------------------------------------------------
-- Module Declaration
--

if not BigWigs.isWOD then return end -- XXX compat
local mod, CL = BigWigs:NewBoss("The Iron Maidens", 988, 1203)
if not mod then return end
mod:RegisterEnableMob(77477, 77557, 77231) -- Marak the Blooded, Admiral Gar'an, Enforcer Sorka
--mod.engageId = 1695

--------------------------------------------------------------------------------
-- Locals
--

local marak, sorka, garan = (EJ_GetSectionInfo(10033)), (EJ_GetSectionInfo(10030)), (EJ_GetSectionInfo(10025))
local bossDeaths = 0
local warnPower = 50

local function isOnABoat()
	return false
end

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.ship_trigger = "prepares to man the Dreadnaught's Main Cannon!"

	L.ship = "Jump to Ship: %s" -- 137266
	L.ship_icon = "ability_vehicle_siegeenginecannon"

	L.bombardment = GetSpellInfo(147135)
	L.bombardment_desc = select(2, EJ_GetSectionInfo(10019))
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
		"bombardment", {158683, "FLASH"},
		{156626, "ICON", "FLASH"}, 156683, {164271, "ICON", "FLASH"}, 158599,
		155794, 156214, 156007, 158315,
		{158078, "FLASH"}, 156366, {157950, "FLASH"}, "custom_off_heartseeker_marker", 156601,
		159336, "stages", "bosskill"
	}, {
		["bombardment"] = -10019, -- Dreadnaught
		[156626] = garan, -- Gar'an
		[155794] = sorka, -- Sorka
		[158078] = marak, -- Marak
		[159336] = "general"
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_APPLIED", "IronWill", 159336)
	-- Gar'an
	self:Log("SPELL_AURA_APPLIED", "RapidFire", 156626)
	self:Log("SPELL_CAST_START", "IncendiaryDevice", 156683) -- Mythic
	self:Log("SPELL_AURA_APPLIED", "PenetratingShot", 164271)
	self:Log("SPELL_CAST_START", "DeployTurret", 158599)
	-- Sorka
	self:Log("SPELL_CAST_START", "BladeDash", 155794)
	self:Log("SPELL_AURA_APPLIED", "ConvulsiveShadows", 156214) -- Mythic
	self:Log("SPELL_AURA_APPLIED", "Impale", 156007)
	self:Log("SPELL_AURA_APPLIED", "DarkHunt", 158315)
	-- Marak
	self:Log("SPELL_CAST_START", "BloodRitual", 158078)
	self:Log("SPELL_CAST_START", "WhirlOfBlood", 156366) -- Mythic
	self:Log("SPELL_AURA_APPLIED", "HeartSeekerApplied", 157950)
	self:Log("SPELL_AURA_REMOVED", "HeartSeekerRemoved", 157950)
	self:Log("SPELL_AURA_APPLIED", "SanguineStrikes", 156601)
	-- Ship
	self:Emote("Ship", L.ship_trigger) -- 10/40/70 power
	self:Log("SPELL_CAST_START", "WarmingUp", 158849)
	self:Log("SPELL_CAST_SUCCESS", "BombardmentAlpha", 157854)
	self:Log("SPELL_CAST_SUCCESS", "BombardmentOmega", 157886)
	self:Log("SPELL_PERIODIC_DAMAGE", "CorruptedBloodDamage", 158683)
	self:Log("SPELL_PERIODIC_MISSED", "CorruptedBloodDamage", 158683)

	self:Death("Deaths", 77477, 77557, 77231)
end

function mod:OnEngage()
	bossDeaths = 0
	warnPower = self:Mythic() and 25 or 50
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss1", "boss2")

	self:Bar(158078, 6) -- Blood Ritual
	self:Bar(155794, 11) -- Blade Dash
	self:Bar(156626, 16) -- Rapid Fire
	self:Bar("bombardment", 60, L.ship:format(marak), L.ship_icon)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_POWER_FREQUENT(unit)
	local power = UnitPower(unit)
	if power == warnPower then
		self:Message("stages", "Neutral", nil, L.power_message:format(power), false)
		warnPower = warnPower + 25
		if warnPower == 100 then
			self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "boss1", "boss2")
		end
	elseif power == 100 then
		self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "boss1", "boss2")
	end
end

do
	local prev = 0
	function mod:IronWill(args)
		local t = GetTime()
		if t-prev > 5 then
			self:Message(args.spellId, "Important", "Alarm")
		end
	end
end

-- Ship

function mod:Ship(msg, sender)
	self:Message("bombardment", "Neutral", "Info", L.ship:format(sender), false)
	self:Bar("bombardment", 15, L.bombardment, L.bombardment_icon)
	if sender == garan then
		self:StopBar(156626) -- Rapid Fire
	elseif sender == sorka then
		self:Bar("bombardment", 130, L.ship:format(garan), L.ship_icon)
		self:StopBar(155794) -- Blade Dash
	elseif sender == marak then
		self:Bar("bombardment", 130, L.ship:format(sorka), L.ship_icon)
		self:StopBar(158078) -- Blood Ritual
	end
end

function mod:WarmingUp(args)
	self:Bar("bombardment", 90, args.spellName, "spell_fire_selfdestruct") -- couldn't find a spell for "Obliteration barrage"
end

function mod:BombardmentAlpha(args)
	self:Message("bombardment", "Urgent", nil, args.spellId)
	self:CDBar("bombardment", 18, L.bombardment, L.bombardment_icon)
end

function mod:BombardmentOmega(args)
	self:Message("bombardment", "Urgent", nil, args.spellId)
	self:StopBar(L.bombardment)
	self:StopBar(158849) -- Warming Up
end

do
	local prev = 0
	function mod:CorruptedBloodDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			self:Flash(args.spellId)
			prev = t
		end
	end
end

-- Gar'an

function mod:RapidFire(args)
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	self:TargetBar(args.spellId, 15, args.destName)
	if self:Me(args.spellId) then
		self:Flash(args.spellId)
	end
	self:Bar(args.spellId, 30)
end

function mod:IncendiaryDevice(args)
	self:Message(args.spellId, "Important")
end

function mod:PenetratingShot(args)
	self:SecondaryIcon(args.spellId, args.destName)
	self:TargetMessage(args.spellId, args.destName, "Important", "Warning", nil, nil, true)
	self:TargetBar(args.spellId, 5, args.destName)
	if not self:Tank() then
		self:Flash(args.spellId)
	end
end

function mod:DeployTurret(args)
	self:Message(args.spellId, "Attention")
end

-- Sorka

function mod:BladeDash(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 20)
end

function mod:ConvulsiveShadows(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent")
end

function mod:Impale(args)
	self:TargetMessage(args.spellId, args.destName, "Attention")
end

function mod:DarkHunt(args)
	self:TargetMessage(args.spellId, args.destName, "Attention")
end

-- Marak

do
	local function printTarget(self, name, guid)
		if self:Me(guid) then
			self:TargetMessage(158078, name, "Urgent", "Alert")
			self:Flash(158078)
		end
		self:TargetBar(158078, 5, name)
	end
	function mod:BloodRitual(args)
		self:GetBossTarget(printTarget, 0.5, args.sourceGUID)
		self:Bar(158078, 12)
	end
end

function mod:WhirlOfBlood(args)
	self:Message(args.spellId, "Urgent")
end

do
	local targets, scheduled = mod:NewTargetList(), nil
	local function warnTargets(spellId)
		mod:TargetMessage(spellId, targets, "Urgent", "Alert")
		scheduled = nil
	end
	function mod:HeartSeekerApplied(args)
		targets[#targets+1] = args.destName
		if self:Me(args.spellId) then
			self:Flash(args.spellId)
		end
		if self.profile.custom_off_heartseeker_marker then
			SetRaidTarget(args.destName, #targets)
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(warnTargets, 0.3, args.spellId)
		end
	end
	function mod:HeartSeekerRemoved(args)
		if self.profile.custom_off_heartseeker_marker then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:SanguineStrikes(args)
	self:Message(args.spellId, "Important", "Warning")
end


function mod:Deaths(args)
	bossDeaths = bossDeaths + 1
	if bossDeaths > 2 then
		self:Win()
	end
end

