--[[
TODO:
	-- maybe try and add wave timers
	-- fix p2 desecrated weapon timer
]]--
if select(4, GetBuildInfo()) < 50400 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Garrosh Hellscream", 953, 869)
if not mod then return end
mod:RegisterEnableMob(71865)

--------------------------------------------------------------------------------
-- Locals
--

local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax
local annihilateCounter
local markableMobs = {}
local marksUsed = {}
local markTimer = nil
local farseerCounter = 1
local engineerCounter = 1
local desecrateCD = 41
local desecrateCounter = 1
local phase = 1
local function getBossByMobId(mobId)
	for i=1, 5 do
		if mod:MobId("boss"..i) == mobId then
			return "boss"..i
		end
	end
	return
end
--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.mind_control = "Mind Control"

	L.chain_heal = mod:SpellName(144583)
	L.chain_heal_desc = "Heals a friendly target for 40% of their max health, chaining to nearby friendly targets."
	L.chain_heal_message = "Your focus is casting Chain Heal!"
	L.chain_heal_bar = "Focus: Chain Heal"

	L.farseer_trigger = "Farseers, mend our wounds!"
	L.custom_off_shaman_marker = "Farseer marker"
	L.custom_off_shaman_marker_desc = "To help interrupt assignments, mark the Farseer Wolf Rider with %s%s%s%s%s%s%s (in that order)(not all marks may be used), requires promoted or leader."

	L.focus_only = "|cffff0000Focus target alerts only.|r "
end
L = mod:GetLocale()
L.chain_heal_desc = L.focus_only..L.chain_heal_desc
L.custom_off_shaman_marker_desc = L.custom_off_shaman_marker_desc:format(
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_1.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_2.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_3.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_4.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_5.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_6.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_7.blp:15\124t"
)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-8298, -- phase 1
		-8294, "chain_heal", "custom_off_shaman_marker", -- Farseer
		-8305, 144945, 144969, -- Intermissions
		145065, 144985, {145183, "TANK"}, -- phase 2
		{144758, "SAY", "FLASH", "ICON"},
		"stages", "berserk", "bosskill",
	}, {
		[-8298] = -8288, -- phase 1
		[-8294] = -8294, -- Farseer
		[-8305] = -8305, -- Intermissions
		[145065] = -8307, -- phase 2
		[144758] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3")

	-- phase 2
	self:Log("SPELL_AURA_APPLIED_DOSE", "GrippingDispair", 145183)
	self:Log("SPELL_AURA_APPLIED", "GrippingDispair", 145183)
	self:Log("SPELL_CAST_START", "WhirlingCorruption", 144985, 145037)
	self:Log("SPELL_CAST_START", "MindControl", 145065, 145171)
	-- Intermissions
	self:Log("SPELL_CAST_START", "Annihilate", 144969)
	self:Log("SPELL_AURA_REMOVED", "YShaarjsProtection", 144945)
	-- Phase 1
	self:Log("SPELL_AURA_APPLIED", "AddMarkedMob", 144585) -- Ancestral Fury
	self:Log("SPELL_CAST_START", "AddMarkedMob", 144584) -- Chain Lightning
	self:Log("SPELL_CAST_START", "ChainHeal", 144583)
	self:Yell("Farseer", L["farseer_trigger"])
	self:Emote("SiegeEngineer", "144616")
	self:Log("SPELL_CAST_SUCCESS", "DesecratedWeapon", 144758) -- XXX need empowered spellId
	self:Death("Win", 71865)
end

function mod:OnEngage()
	self:Bar(144758, 60) -- DesecratedWeapon
	self:Bar(-8298, 20) -- Siege Engineer
	self:Bar(-8294, 30, nil, 144584) -- Farseer
	farseerCounter = 1
	engineerCounter = 1
	desecrateCD = 41
	phase = 1
	wipe(markableMobs)
	wipe(marksUsed)
	markTimer = nil
	if self.db.profile.custom_off_shaman_marker then
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	end
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1", "boss2", "boss3")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- phase 2
function mod:GrippingDispair(args)
	local amount = args.amount or 1
	self:CDBar(args.spellId, 8)
	local sound
	if amount > 3 and not self:Me(args.destGUID) then
		sound = "Warning"
	end
	self:StackMessage(args.spellId, args.destName, amount, "Attention", sound)
end

function mod:WhirlingCorruption(args)
	self:Message(144985, "Important", "Long", args.spellName)
	self:Bar(144985, 50, args.spellName)
end

function mod:MindControl(args)
	self:Message(145065, "Urgent", "Alert", CL["casting"]:format(L["mind_control"]))
	self:Bar(145065, 45, L["mind_control"])
end

-- Phase 1
-- marking
do
	local function setMark(unit, guid)
		for mark = 1, 7 do
			if not marksUsed[mark] then
				SetRaidTarget(unit, mark)
				markableMobs[guid] = "marked"
				marksUsed[mark] = guid
				return
			end
		end
	end

	local function markMobs()
		local continue
		for guid in next, markableMobs do
			if markableMobs[guid] == true then
				local unit = mod:GetUnitIdByGUID(guid)
				if unit then
					setMark(unit, guid)
				else
					continue = true
				end
			end
		end
		if not continue or not mod.db.profile.custom_off_shaman_marker then
			mod:CancelTimer(markTimer)
			markTimer = nil
		end
	end

	function mod:UPDATE_MOUSEOVER_UNIT()
		local guid = UnitGUID("mouseover")
		if guid and markableMobs[guid] == true then
			setMark("mouseover", guid)
		end
	end

	function mod:AddMarkedMob(args)
		if not markableMobs[args.destGUID] then
			markableMobs[args.destGUID] = true
			if self.db.profile.custom_off_shaman_marker and not markTimer then
				markTimer = self:ScheduleRepeatingTimer(markMobs, 0.2)
			end
		end
	end
end

do
	local prev = 0
	function mod:ChainHeal(args)
		mod:AddMarkedMob(args)
		local t = GetTime()
		if t-prev > 3 and UnitGUID("focus") == args.sourceGUID then -- don't spam
			prev = t
			self:Message("chain_heal", "Personal", "Alert", L["chain_heal_message"], args.spellId)
		end
	end
end

do
	local farseerTimers = { 50, 50, 40 } -- XXX need more data
	function mod:Farseer()
		self:Message(-8294, "Urgent", self:Damager() and "Alert")
		self:Bar(-8294, farseerTimers[farseerCounter] or 40, nil, 144584) -- chain lightning icon cuz that is some shaman spell
		farseerCounter = farseerCounter + 1
	end
end

function mod:SiegeEngineer()
	self:Message(-8298, "Attention")
	self:Bar(-8298, engineerCounter == 1 and 45 or 40)
	engineerCounter = engineerCounter + 1
end

-- Intermission
function mod:Annihilate(args)
	self:Message(args.spellId, "Attention", nil, CL["casting"]:format(CL["count"]:format(args.spellName, annihilateCounter)))
	annihilateCounter = annihilateCounter + 1
end

function mod:YShaarjsProtection(args)
	self:Message(args.spellId, "Positive", "Long", CL["over"]:format(args.spellName))
	annihilateCounter = 1
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unitId, spellName, _, _, spellId)
	if spellId == 145235 then -- throw axe at heart , transition into first intermission
		self:Bar(-8305, 25, 144866, "SPELL_HOLY_PRAYEROFSHADOWPROTECTION")
		phase = 2
	elseif spellId == 144866 then -- Enter Realm of Y'Shaarj -- actually being pulled
		self:StopBar(144758) -- Desecrated Weapon
		self:StopWeaponScan()
		self:StopBar(145065) -- Mind Control
		self:StopBar(144985) -- Whirling Corruption
		self:Message(-8305, "Neutral", nil, 144866, "SPELL_HOLY_PRAYEROFSHADOWPROTECTION")
		self:Bar(-8305, 210, 144866, "SPELL_HOLY_PRAYEROFSHADOWPROTECTION")
	elseif spellId == 144956 then -- Jump To Ground -- exiting intermission
		desecrateCounter = 1
		self:Bar(144758, 10) -- Desecrated Weapon
		self:Bar(145065, 15) -- Mind Control
		self:Bar(144985, 30) -- Whirling Corruption
		self:ScheduleTimer("StartWeaponScan", 5)
		local hp = UnitHealth("boss1") / UnitHealthMax("boss1") * 100
		if hp < 50 then -- XXX might need adjusting
			self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1", "boss2", "boss3") -- don't really need this till 2nd intermission phase
		end
	end
end

-- General
function mod:UNIT_HEALTH_FREQUENT(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if (hp < 15 and phase == 1) or (hp < 13 and phase == 2) then -- 10%
		self:Message("stages", "Neutral", "Info", CL["soon"]:format(CL["phase"]:format(phase+1)))
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1", "boss2", "boss3")
	end
end

do
	local UnitDetailedThreatSituation, UnitExists, UnitIsUnit = UnitDetailedThreatSituation, UnitExists, UnitIsUnit
	local weaponTimer = nil
	local function checkWeaponTarget()
		local boss = getBossByMobId(71865)
		if not boss then return end
		local target = boss.."target"
		if not UnitExists(target) or mod:Tank(target) or UnitDetailedThreatSituation(target, boss) then return end

		local name = mod:UnitName(target)
		mod:TargetMessage(144758, name, "Urgent", "Alarm")
		mod:SecondaryIcon(144758, name) -- so we don't use skull as that might be used for marking the healing add
		if UnitIsUnit("player", target) then
			mod:Flash(144758)
			mod:Say(144758)
		end
		mod:StopWeaponScan()
	end
	function mod:StartWeaponScan()
		if not weaponTimer then
			weaponTimer = self:ScheduleRepeatingTimer(checkWeaponTarget, 0.2)
		end
	end
	function mod:StopWeaponScan()
		self:CancelTimer(weaponTimer)
		weaponTimer = nil
	end
	local phase2DesecreteCDs = {36, 45, 36} -- XXX need more data
	function mod:DesecratedWeapon(args)
		if not phase == 1 then
			desecrateCD = phase2DesecreteCDs[desecrateCounter] or 45
			print("desecrateCounter: "..desecrateCounter)
		end
		self:Bar(args.spellId, desecrateCD)
		desecrateCounter = desecrateCounter + 1
		self:ScheduleTimer("StopWeaponScan", 2) -- delay it a bit just to be safe
		self:ScheduleTimer("StartWeaponScan", desecrateCD-7)
	end
end

