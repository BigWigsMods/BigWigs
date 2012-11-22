--[[ TO DO

figure out how defile works
proper review of the module
need transcriptor log

--]]
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
		{117988, "FLASHSHAKE"}, 117975,
		{117436, "SAY", "PROXIMITY", "FLASHSHAKE"} , {118077, "FLASHSHAKE"},
		117309, 117227,
		"berserk", "bosskill",
	}, {
		[117988] = "ej:5789",
		[117436] = "ej:5793",
		[117309] = "ej:5794",
		berserk = "general",
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
	self:Log("SPELL_CAST_START", "LightningStormStart", 118077)

	-- Elder Asani
	self:Log("SPELL_CAST_START", "CleansingWaterStart", 117309) -- Spawn Watter Bubble
	self:Log("SPELL_CAST_SUCCESS", "CleansingPool", 117309) -- the good one
	self:Log("SPELL_CAST_START", "CorruptedWater", 117227) -- Spawn Watter Bubble -- need combatlog for this
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShaCorruption", 117052)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:Death("Deaths", 60583, 60585, 60586)
end

function mod:OnEngage()
	bossDead = 0
	if not self:LFR() then
		self:Berserk(490)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- boss death start 1st bars
function mod:ShaCorruption(_, _, _, _, _, _, _, _, _, dGUID) -- don't know if bossX is always same for the bosses regardles of kill order, so do CID check till we are sure
	if self:GetCID(dGUID) == 60583 then -- Protector Kaolan has 2 stacks
		self:Bar(117975, 117975, 6, 117975) -- Expel Corruption
	end
end


--Protector Kaolan

function mod:ExpelCorruption(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Urgent", spellId)
	self:Bar(spellId, spellName, 38, spellId)
	self:Bar(117988, 117988, 12, 117988) -- Defiled Ground
end

function mod:DefiledGround(_, _, _, _, spellName)
	self:Bar(117988, spellName, 16, 117988)
end

do
	local prev = 0
	function mod:DefiledGroundDamage(player, _, _, _, spellName)
		if UnitIsUnit(player, "player") then
			local t = GetTime()
			if t-prev > 1 then
				prev = t
				self:LocalMessage(117988, CL["underyou"]:format(spellName), "Personal", 117988, "Info")
				self:FlashShake(117988)
			end
		end
	end
end

-- Elder Regail

do
	local lightningPrisonList, scheduled = mod:NewTargetList(), nil
	local function prisonWarn(spellName)
		mod:TargetMessage(117436, spellName, lightningPrisonList, "Important", 117436, "Alert")
		scheduled = nil
	end
	function mod:LightningPrisonApplied(player, _, _, _, spellName)
		lightningPrisonList[#lightningPrisonList + 1] = player
		if UnitIsUnit(player, "player") then
			self:FlashShake(117436)
			self:Say(117436, CL["say"]:format(spellName))
			self:OpenProximity(7, 117436)
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(prisonWarn, 0.2, spellName)
		end
	end
end

function mod:LightningPrisonRemoved(player)
	if UnitIsUnit(player, "player") then
		self:CloseProximity(117436)
	end
end

function mod:LightningStormStart(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Urgent", spellId, "Alarm")
	self:FlashShake(spellId)
end

-- Elder Asani

function mod:CleansingWaterStart(_, spellId, _, _, spellName)
	self:Message(spellId, CL["soon"]:format(spellName), "Attention")
	self:Bar(spellId, spellName, 7, spellId) -- 5+2 so it is exact for dispell
end

function mod:CleansingPool(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Urgent", spellId)
	self:Bar(spellId, "~"..spellName , 32, spellId)
end

-- Globe BAD
function mod:CorruptedWater(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Attention", spellId)
end

function mod:Deaths()
	bossDead = bossDead + 1
	if bossDead > 2 then
		self:Win()
	end
end

