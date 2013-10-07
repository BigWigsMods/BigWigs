--[[
TODO:
	maybe mark hopeless people, need some healer feedback on it
]]--

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
local mcCounter = 1
local farseerCounter = 1
local engineerCounter = 1
local desecrateCD = 41
local desecrateCounter = 1
local phase = 1
local function getBossByMobId(mobId)
	for i=1, 5 do
		if mod:MobId(UnitGUID("boss"..i)) == mobId then
			return "boss"..i
		end
	end
	return
end
local waveTimers = { 45, 45, 40 } -- XXX there are no events for this so really what we need is videos
local waveTimer, waveCounter = nil, 1
--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.intermission = "Intermission"
	L.mind_control = "Mind Control"

	L.chain_heal = mod:SpellName(144583)
	L.chain_heal_desc = "Heals a friendly target for 40% of their max health, chaining to nearby friendly targets."
	L.chain_heal_message = "Your focus is casting Chain Heal!"
	L.chain_heal_bar = "Focus: Chain Heal"

	L.farseer_trigger = "Farseers, mend our wounds!"
	L.custom_off_shaman_marker = "Farseer marker"
	L.custom_off_shaman_marker_desc = "To help interrupt assignments, mark the Farseer Wolf Rider with {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over all the mines is the fastest way to mark them.|r"

	L.focus_only = "|cffff0000Focus target alerts only.|r "
end
L = mod:GetLocale()
L.chain_heal_desc = L.focus_only..L.chain_heal_desc

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-8298, -8292,-- phase 1
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

	-- Phase 2
	self:Log("SPELL_CAST_SUCCESS", "MindControl", 145065, 145171)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GrippingDespair", 145183)
	self:Log("SPELL_AURA_APPLIED", "GrippingDespair", 145183)
	self:Log("SPELL_CAST_START", "WhirlingCorruption", 144985, 145037)
	-- Intermissions
	self:Log("SPELL_CAST_START", "Annihilate", 144969)
	self:Log("SPELL_AURA_REMOVED", "YShaarjsProtection", 144945)
	-- Phase 1
	self:Log("SPELL_AURA_APPLIED", "AddMarkedMob", 144585) -- Ancestral Fury
	self:Log("SPELL_CAST_START", "AddMarkedMob", 144584) -- Chain Lightning
	self:Log("SPELL_CAST_START", "ChainHeal", 144583)
	self:Yell("Farseer", L["farseer_trigger"])
	self:Emote("SiegeEngineer", "144616")
	self:Log("SPELL_CAST_SUCCESS", "DesecratedWeapon", 144748, 144749)

	self:Death("RiderDeath", 71983) -- Farseer Wolf Rider
	self:Death("Win", 71865) -- Garrosh
end

function mod:OnEngage(diff)
	waveCounter = 1
	waveTimer = self:ScheduleTimer("NewWave", waveTimers[waveCounter])
	self:Bar(-8292, waveTimers[waveCounter], nil, 144582)
	self:Berserk(900, nil, nil, "Berserk (assumed)") -- XXX assumed (more than 10 min)
	annihilateCounter = 1
	self:Bar(144758, 11) -- Desecrated Weapon
	self:Bar(-8298, 20, nil, 144616) -- Siege Engineer
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
function mod:GrippingDespair(args)
	local amount = args.amount or 1
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
	if phase == 3 then
		self:Bar(145065, (mcCounter == 1) and 35 or 42, L["mind_control"])
		mcCounter = mcCounter + 1 -- XXX might need more data
	else
		self:Bar(145065, 45, L["mind_control"])
	end
end

-- Phase 1
function mod:NewWave()
	self:Message(-8292, "Attention", CL["count"]:format(self:SpellName(-8292), waveCounter), nil, 144582) -- XXX the count message is only in for debugging
	waveCounter = waveCounter + 1
	self:Bar(-8292, waveTimers[waveCounter] or 40, nil, 144582)
	waveTimer = self:ScheduleTimer("NewWave", waveTimers[waveCounter] or 40)
end

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

	function mod:RiderDeath(args)
		if self.db.profile.custom_off_shaman_marker then
			markableMobs[args.destGUID] = nil
			for i=1, 7 do
				if marksUsed[i] == args.destGUID then
					marksUsed[i] = nil
					break
				end
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
	--  cat Transcriptor.lua | sed "s/\t//g" | cut -d ' ' -f 2-300 | grep -E "(YELL].*Farseers)|(DED.*144489)|(DED.*144866)"
	function mod:Farseer()
		self:Message(-8294, "Urgent", self:Damager() and "Alert", nil, 144584)
		self:Bar(-8294, farseerTimers[farseerCounter] or 40, nil, 144584) -- chain lightning icon cuz that is some shaman spell
		farseerCounter = farseerCounter + 1
	end
end

function mod:SiegeEngineer()
	self:Message(-8298, "Attention", nil, nil, 144616)
	self:Bar(-8298, engineerCounter == 1 and 45 or 40, 144616)
	engineerCounter = engineerCounter + 1
end

-- Intermission
function mod:Annihilate(args)
	self:Message(args.spellId, "Attention", nil, CL["casting"]:format(CL["count"]:format(args.spellName, annihilateCounter)))
	annihilateCounter = annihilateCounter + 1
end

do
	local hopeList = mod:NewTargetList()
	function mod:YShaarjsProtection(args)
		if self:MobId(args.destGUID) ~= 71865 then return end
		annihilateCounter = 1
		local diff = self:Difficulty()
		for i=1, GetNumGroupMembers() do
			local name, _, subgroup = GetRaidRosterInfo(i)
			-- 149004 hope
			-- 148983 courage
			-- 148994 faith
			local debuffed = (UnitDebuff(name, self:SpellName(149004))) or (UnitDebuff(name, self:SpellName(148983))) or (UnitDebuff(name, self:SpellName(148994)))
			if not debuffed then
				if diff == 3 or diff == 5 then -- 10 man
					if subgroup < 3 then
						hopeList[#hopeList+1] = name
					end
				else
					if subgroup < 6 then
						hopeList[#hopeList+1] = name
					end
				end
			end
		end
		-- this is so people know they'll take extra damage
		if #hopeList > 0 then
			self:TargetMessage(args.spellId, hopeList, "Attention", "Warning", 29125, 149004) -- maybe add it's own option key? 29125 spell called "Hopeless"
		end
		self:Message(args.spellId, "Positive", "Long", CL["over"]:format(args.spellName))
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unitId, spellName, _, _, spellId)
	if spellId == 145235 then -- throw axe at heart , transition into first intermission
		if phase == 1 then
			self:Bar(-8305, 25, L["intermission"], "SPELL_HOLY_PRAYEROFSHADOWPROTECTION")
			self:CancelTimer(waveTimer)
			waveTimer = nil
			self:StopBar(-8292) -- Kor'kron Warbringer aka add waves
			self:StopBar(-8298) -- Siege Engineer
			self:StopBar(-8294) -- Farseer
			self:StopBar(144758) -- Desecrated Weapon
			self:StopWeaponScan()
		end
	elseif spellId == 144866 then -- Enter Realm of Y'Shaarj -- actually being pulled
		self:StopBar(144758) -- Desecrated Weapon
		self:StopWeaponScan()
		self:StopBar(L["mind_control"]) -- Mind Control
		self:StopBar(144985) -- Whirling Corruption
		self:Message(-8305, "Neutral", nil, L["intermission"], "SPELL_HOLY_PRAYEROFSHADOWPROTECTION")
		self:Bar(-8305, 210, L["intermission"], "SPELL_HOLY_PRAYEROFSHADOWPROTECTION")
	elseif spellId == 144956 then -- Jump To Ground -- exiting intermission
		if phase == 2 then
			desecrateCounter = 1
			self:Bar(144758, 10) -- Desecrated Weapon
			self:Bar(145065, 15, L["mind_control"]) -- Mind Control
			self:Bar(144985, 30) -- Whirling Corruption
			self:StartWeaponScan(5)
			local hp = UnitHealth("boss1") / UnitHealthMax("boss1") * 100
			if hp < 50 then -- XXX might need adjusting
				self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1", "boss2", "boss3") -- don't really need this till 2nd intermission phase
			end
		else -- first time, don't start timers yet
			phase = 2
		end
	elseif spellId == 145647 then -- Realm of Y'Shaarj -- phase 3
		phase = 3
		mcCounter = 1
		desecrateCounter = 1
		self:Message("stages", "Neutral", nil, CL["phase"]:format(phase), false)
		self:StopBar(L["intermission"])
		self:StopBar(144985) -- stop Whirling Corruption bar in case it was not empowered already
		self:Bar(144985, 48, 145037) -- Empowered Whirling Corruption
		self:Bar(145065, 29, L["mind_control"]) -- Mind Control
		self:Bar(144758, 21) -- Desecrated Weapon
	end
end

-- General
function mod:UNIT_HEALTH_FREQUENT(unitId)
	if self:MobId(UnitGUID(unitId)) ~= 71865 then return end
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if (hp < 15 and phase == 1) or (hp < 13 and phase == 2) then -- 10%
		self:Message("stages", "Neutral", "Info", CL["soon"]:format(CL["phase"]:format(phase+1)), false)
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
		mod:SecondaryIcon(144758, name) -- so we don't use skull as that might be used for marking the healing add
		if UnitIsUnit("player", target) then
			mod:TargetMessage(144758, name, "Urgent", "Alarm")
			mod:Flash(144758)
			mod:Say(144758)
		elseif mod:Range(name) < 15 then
			mod:Flash(144758)
			mod:RangeMessage(144758, "Urgent", "Alarm")
		else
			mod:TargetMessage(144758, name, "Urgent", "Alarm")
		end
		mod:StopWeaponScan()
	end
	function mod:StartWeaponScan(delay)
		if delay then
			self:CancelTimer(weaponTimer)
			weaponTimer = self:ScheduleTimer("StartWeaponScan", delay)
		elseif not weaponTimer then
			weaponTimer = self:ScheduleRepeatingTimer(checkWeaponTarget, 0.05)
		end
	end
	function mod:StopWeaponScan(delay)
		if delay then
			self:ScheduleTimer("StopWeaponScan", delay)
		else
			self:CancelTimer(weaponTimer)
			weaponTimer = nil
		end
	end
	local phase2DesecreteCDs = {36, 45, 36}
	function mod:DesecratedWeapon(args)
		if phase == 2 then
			local diff = self:Difficulty()
			if diff == 3 or diff == 5 then -- 10 man
				desecrateCD = phase2DesecreteCDs[desecrateCounter] or 45
			else
				desecrateCD = 35
			end
		elseif phase == 3 then
			desecrateCD = (desecrateCounter == 1) and 35 or 25
		end
		self:CDBar(144758, desecrateCD)
		desecrateCounter = desecrateCounter + 1
		self:StopWeaponScan(2) -- delay it a bit just to be safe
		self:StartWeaponScan(desecrateCD-7)
	end
end

