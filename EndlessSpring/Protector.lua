
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Protectors of the Endless", 886, 683)
if not mod then return end
mod:RegisterEnableMob(60583, 60585, 60586) -- Kaolan, Regail, Asani

-----------------------------------------------------------------------------------------
-- Locals
--

local bossDead = 0
local firstDeath = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.under = "%s under %s!"
	L.heal = "%s heal"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{117986, "FLASH"}, 117975,
		{117436, "SAY", "PROXIMITY", "FLASH"} , {118077, "FLASH"},
		117309, 117227,
		117052, "berserk", "bosskill",
	}, {
		[117986] = -5789,
		[117436] = -5793,
		[117309] = -5794,
		[117052] = "general",
	}
end

function mod:OnBossEnable()
	-- Protector Kaolan
	self:Log("SPELL_CAST_SUCCESS", "DefiledGround", 117986)
	self:Log("SPELL_DAMAGE", "DefiledGroundDamage", 117988)
	self:Log("SPELL_MISSED", "DefiledGroundDamage", 117988)
	self:Log("SPELL_CAST_START", "ExpelCorruption", 117975)

	-- Elder Regail
	self:Log("SPELL_AURA_APPLIED", "LightningPrisonApplied", 111850)
	self:Log("SPELL_AURA_REMOVED", "LightningPrisonRemoved", 111850)
	self:Log("SPELL_CAST_START", "LightningStorm", 118077)

	-- Elder Asani
	self:Log("SPELL_SUMMON", "CleansingWaters", 117309)
	self:Log("SPELL_AURA_APPLIED", "CleansingWatersDispel", 117283)
	self:Log("SPELL_PERIODIC_HEAL", "CleansingWatersDispel", 117283) -- every 3s
	self:Log("SPELL_SUMMON", "CorruptedWaters", 117227)

	self:Log("SPELL_AURA_APPLIED", "ShaCorruptionFirst", 117052)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShaCorruptionSecond", 117052)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:Death("BossDeaths", 60583, 60585, 60586)
end

function mod:OnEngage()
	self:CDBar(117309, 11) -- Cleansing Waters
	self:CDBar(111850, 15) -- Lightning Prison
	bossDead = 0
	firstDeath = nil
	self:Berserk(self:LFR() and 660 or 490)

	if self:Tank() then
		self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "CleansingWatersTank", "target") -- Cleansing Waters target
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Sha Corruption "doses"

function mod:ShaCorruptionFirst(args)
	local mobId = self:MobId(args.destGUID)
	if mobId == 60583 then -- Kaolan
		self:Bar(117986, 11) -- Defiled Ground
	elseif mobId == 60585 then -- Regail
		self:CDBar(118077, 26) -- Lightning Storm
	elseif mobId == 60586 then -- Asani
		self:CDBar(117227, 11) -- Corrupted Waters
	end

	if not firstDeath then
		firstDeath = true
		self:Message(args.spellId, "Attention", "Info", CL["count"]:format(args.spellName, 1), args.spellId)
	end
end

function mod:ShaCorruptionSecond(args)
	local mobId = self:MobId(args.destGUID)
	if mobId == 60583 then -- Kaolan
		self:Bar(117975, 6) -- Expel Corruption
	elseif mobId == 60585 then -- Regail
		self:Bar(118077, 11) -- Lightning Storm
	elseif mobId == 60586 then -- Asani
		self:Bar(117227, 15) -- Corrupted Waters
	end

	self:Message(args.spellId, "Attention", "Info", CL["count"]:format(args.spellName, 2))
end

--Protector Kaolan

function mod:ExpelCorruption(args)
	self:Message(args.spellId, "Urgent")
	self:Bar(args.spellId, 38)
	self:Bar(117986, 12) -- Defiled Ground
end

function mod:DefiledGround(args)
	self:Bar(args.spellId, 16)
end

do
	local prev = 0
	function mod:DefiledGroundDamage(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 1 then
				prev = t
				self:Message(117986, "Personal", "Info", CL["underyou"]:format(args.spellName))
				self:Flash(117986)
			end
		end
	end
end

-- Elder Regail

do
	local lightningPrisonList, scheduled = mod:NewTargetList(), nil
	local function warnPrison()
		mod:TargetMessage(117436, lightningPrisonList, "Important", "Alert")
		scheduled = nil
	end
	function mod:LightningPrisonApplied(args)
		lightningPrisonList[#lightningPrisonList + 1] = args.destName
		if self:Me(args.destGUID) then
			self:Flash(117436)
			self:Say(117436)
			self:OpenProximity(117436, 7)
		end
		if not scheduled then
			self:CDBar(117436, 25)
			scheduled = self:ScheduleTimer(warnPrison, 0.2)
		end
	end
end

function mod:LightningPrisonRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(117436)
	end
end

function mod:LightningStorm(args)
	self:Message(args.spellId, "Urgent", "Alarm")
	self:CDBar(args.spellId, bossDead < 3 and 42 or 32)
	self:Flash(args.spellId)
end

-- Elder Asani

function mod:CleansingWaters(args)
	if not self:Tank() then
		self:Message(args.spellId, "Attention", self:Dispeller("magic", true) and "Alert", CL["soon"]:format(args.spellName))
	end
	self:Bar(args.spellId, 6, L["heal"]:format(args.spellName), 55888) -- orb hitting the ground (water orb icon)
	self:CDBar(args.spellId, bossDead > 0 and 42 or 32)
end

do
	-- assume your kill target is the boss with the lowest health and ignore cleansing waters on others
	local function getKillTarget()
		local lowest, lowestHP = nil, 100
		for i=1,3 do
			local unit = ("boss%d"):format(i)
			local hp = UnitHealth(unit) / UnitHealthMax(unit)
			if hp < lowestHP then
				lowestHP = hp
				lowest = unit
			end
		end
		return lowest
	end

	-- Dispeller warning
	function mod:CleansingWatersDispel(args)
		local mobId = self:MobId(args.destGUID)
		if self:Dispeller("magic", true) and (mobId == 60583 or mobId == 60585 or mobId == 60586) and args.destGUID == UnitGUID(getKillTarget()) then
			self:Message(117309, "Important", "Info", CL["on"]:format(args.spellName, args.destName)) --onboss
		end
	end

	-- Tank warning
	function mod:CleansingWatersTank(unitId, _, _, _, spellId)
		if spellId == 122851 and self:Tank() and UnitIsUnit(unitId, getKillTarget()) then
			local bossName = UnitName(unitId)
			self:Message(117309, "Urgent", "Alert", L["under"]:format(self:SpellName(117309), bossName))
		end
	end
end

function mod:CorruptedWaters(args)
	self:Message(args.spellId, "Attention")
	self:CDBar(args.spellId, 42)
end


function mod:BossDeaths(args)
	if args.mobId == 60583 then -- Kaolan
		self:StopBar(117986) -- Defiled Ground
	elseif args.mobId == 60585 then -- Regail
		self:StopBar(111850) -- Lightning Prison
		self:StopBar(118077) -- Lightning Storm
	elseif args.mobId == 60586 then -- Asani
		self:StopBar(117227) -- Corrupted Waters
	end
	self:StopBar(117309) -- Cleansing Waters, CD goes wack after kill

	bossDead = bossDead + 1
	if bossDead > 2 then
		self:Win()
	end
end

