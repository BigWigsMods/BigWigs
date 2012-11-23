
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
	L.on = "%s on %s!"
	L.under = "%s under %s!"
	L.heal = "%s heal"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{117986, "FLASHSHAKE"}, 117975,
		{117436, "SAY", "PROXIMITY", "FLASHSHAKE"} , {118077, "FLASHSHAKE"},
		117309, 117227,
		117052, "berserk", "bosskill",
	}, {
		[117986] = "ej:5789",
		[117436] = "ej:5793",
		[117309] = "ej:5794",
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
	self:Death("Deaths", 60583, 60585, 60586)
end

function mod:OnEngage()
	self:Bar(117309, "~"..self:SpellName(117309), 11, 117309) -- Cleansing Waters
	self:Bar(111850, "~"..self:SpellName(111850), 15, 111850) -- Lightning Prison
	bossDead = 0
	firstDeath = nil
	self:Berserk(self:LFR() and 600 or 490)

	if self:Tank() then
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED") -- Cleansing Waters target
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Sha Corruption "doses"

function mod:ShaCorruptionFirst(_, spellId, source, _, spellName, _, _, _, _, dGUID)
	local mobId = self:GetCID(dGUID)
	if mobId == 60583 then -- Kaolan
		self:Bar(117986, 117986, 11, 117986) -- Defiled Ground
	elseif mobId == 60585 then -- Regail
		self:Bar(118077, "~"..self:SpellName(118077), 26, 118077) -- Lightning Storm
	elseif mobId == 60586 then -- Asani
		self:Bar(117227, "~"..self:SpellName(117227), 11, 117227) -- Corrupted Waters
	end

	if not firstDeath then
		firstDeath = true
		self:Message(spellId, ("%s (%d)"):format(spellName, 1), "Attention", spellId, "Info")
	end
end

function mod:ShaCorruptionSecond(_, spellId, source, _, spellName, _, _, _, _, dGUID)
	local mobId = self:GetCID(dGUID)
	if mobId == 60583 then -- Kaolan
		self:Bar(117975, 117975, 6, 117975) -- Expel Corruption
	elseif mobId == 60585 then -- Regail
		self:Bar(118077, "~"..self:SpellName(118077), 11, 118077) -- Lightning Storm
	elseif mobId == 60586 then -- Asani
		self:Bar(117227, "~"..self:SpellName(117227), 15, 117227) -- Corrupted Waters
	end

	self:Message(spellId, ("%s (%d)"):format(spellName, 2), "Attention", spellId, "Info")
end

--Protector Kaolan

function mod:ExpelCorruption(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Urgent", spellId)
	self:Bar(spellId, spellName, 38, spellId)
	self:Bar(117986, 117986, 12, 117986) -- Defiled Ground
end

function mod:DefiledGround(_, spellId, _, _, spellName)
	self:Bar(spellId, spellName, 16, spellId)
end

do
	local prev = 0
	function mod:DefiledGroundDamage(player, _, _, _, spellName)
		if UnitIsUnit(player, "player") then
			local t = GetTime()
			if t-prev > 1 then
				prev = t
				self:LocalMessage(117986, CL["underyou"]:format(spellName), "Personal", 117986, "Info")
				self:FlashShake(117986)
			end
		end
	end
end

-- Elder Regail

do
	local lightningPrisonList, scheduled = mod:NewTargetList(), nil
	local function warnPrison(spellName)
		mod:TargetMessage(117436, spellName, lightningPrisonList, "Important", 117436, "Alert")
		scheduled = nil
	end
	function mod:LightningPrisonApplied(player, _, _, _, spellName)
		self:Bar(117436, "~"..spellName, 25, 117436)
		lightningPrisonList[#lightningPrisonList + 1] = player
		if UnitIsUnit(player, "player") then
			self:FlashShake(117436)
			self:Say(117436, CL["say"]:format(spellName))
			self:OpenProximity(7, 117436)
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(warnPrison, 0.2, spellName)
		end
	end
end

function mod:LightningPrisonRemoved(player)
	if UnitIsUnit(player, "player") then
		self:CloseProximity(117436)
	end
end

function mod:LightningStorm(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Urgent", spellId, "Alarm")
	self:Bar(spellId, "~"..spellName, bossDead < 3 and 42 or 32, spellId)
	self:FlashShake(spellId)
end

-- Elder Asani

function mod:CleansingWaters(_, spellId, _, _, spellName)
	self:Message(spellId, CL["soon"]:format(spellName), "Attention", spellId, self:Dispeller("magic", true) and "Alert" or nil)
	self:Bar(spellId, L["heal"]:format(spellName), 6, 55888) -- orb hitting the ground (water orb icon)
	self:Bar(spellId, "~"..spellName, 32, spellId)
end

do
	-- assume your kill target is the boss with the lowest health and ignore cleansing waters on others
	local function getKillTarget()
		local lowest, lowestHP = nil, 100
		for i=1,3 do
			local unit = "boss"..i
			local hp = UnitHealth(unit) / UnitHealthMax(unit)
			if hp < lowestHP then
				lowestHP = hp
				lowest = unit
			end
		end
		return lowest
	end

	-- Dispeller warning
	function mod:CleansingWatersDispel(player, _, _, _, spellName, _, _, _, _, dGUID)
		local mobId = self:GetCID(dGUID)
		if self:Dispeller("magic", true) and (mobId == 60583 or mobId == 60585 or mobId == 60586) and dGUID == UnitGUID(getKillTarget()) then
			self:LocalMessage(117309, L["on"]:format(spellName, player), "Important", 117309, "Info") --onboss
		end
	end

	-- Tank warning
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, unitId, _, _, _, spellId)
		if spellId == 122851 and unitId == "target" and UnitIsUnit(unitId, getKillTarget()) then -- Raid Warning: I'm Standing In Cleansing Waters
			local bossName = UnitName(unitId)
			self:LocalMessage(117309, L["under"]:format(self:SpellName(117309), bossName), "Urgent", 117309, "Alert")
		end
	end
end

function mod:CorruptedWaters(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Attention", spellId)
	self:Bar(spellId, "~"..spellName, 42, spellId)
end


function mod:Deaths(mobId)
	if mobId == 60583 then --Kaolan
		self:StopBar(117986) -- Defiled Ground
	elseif mobId == 60585 then -- Regail
		self:StopBar("~"..self:SpellName(111850)) -- Lightning Prison
		self:StopBar("~"..self:SpellName(118077)) -- Lightning Storm
	elseif mobId == 60586 then -- Asani
		self:StopBar("~"..self:SpellName(117309)) -- Cleansing Waters
		self:StopBar("~"..self:SpellName(117227)) -- Corrupted Waters
	end

	bossDead = bossDead + 1
	if bossDead > 2 then
		self:Win()
	end
end

