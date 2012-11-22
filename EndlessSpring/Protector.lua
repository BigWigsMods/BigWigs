
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
	L.death = "%s dies!"
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
	self:Log("SPELL_SUMMON", "CorruptedWaters", 117227)

	self:Log("SPELL_AURA_APPLIED", "ShaCorruptionFirst", 117052)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShaCorruptionSecond", 117052)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:Death("Deaths", 60583, 60585, 60586)
end

function mod:OnEngage()
	bossDead = 0
	firstDeath = nil
	if not self:LFR() then
		self:Berserk(490)
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
		self:Bar(118077, 118077, 20, 118077) -- Lightning Storm
	elseif mobId == 60586 then -- Asani
		self:Bar(117227, 117227, 11, 117227) -- Courrupted Waters
	end

	if not firstDeath then
		firstDeath = true
		--self:Message(spellId, L["death"]:format(source), "Positive", spellId, "Info")
		self:Message(spellId, ("%s (%d)"):format(spellName, 1), "Attention", spellId, "Info")
	end
end

function mod:ShaCorruptionSecond(_, spellId, source, _, spellName, _, _, _, _, dGUID)
	local mobId = self:GetCID(dGUID)
	if mobId == 60583 then -- Kaolan
		self:Bar(117975, 117975, 6, 117975) -- Expel Corruption
	end

	--self:Message(spellId, L["death"]:format(source), "Positive", spellId, "Info")
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
	self:Bar(spellId, "~"..spellName, 42, spellId)
	self:FlashShake(spellId)
end

-- Elder Asani

function mod:CleansingWaters(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Urgent", spellId, self:Dispeller("magic", true) and "Alert" or nil)
	self:Bar(spellId, spellName, 6, spellId) -- orb hitting the ground
	self:Bar(spellId, "~"..spellName, 32, spellId)
end

function mod:CorruptedWaters(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Attention", spellId)
	self:Bar(spellId, "~"..spellName, 42, spellId)
end

function mod:Deaths(mobId, _, mob)
	if mobId == 60583 then --Kaolan
		self:StopBar(117986) -- Defiled Ground
	elseif mobId == 60585 then -- Regail
		self:StopBar(111850) -- Lightning Prison
		self:StopBar(118077) -- Lightning Storm
	elseif mobId == 60586 then -- Asani
		self:StopBar(117309) -- Cleansing Waters
		self:StopBar(117227) -- Courrupted Waters
	end

	bossDead = bossDead + 1
	if bossDead > 2 then
		self:Win()
	end
end

