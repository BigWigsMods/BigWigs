if not GetNumGroupMembers then return end
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

local defiledGround = (GetSpellInfo(117988))
local lightningPrsionList = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.storm_him = "Storm 10 Yard!"
	L.storm_20 = "Storm 20 Yard!"
	L.storm_40 = "Storm 40 Yard!"
	L.storm_60 = "Storm 60 Yard!"
	L.storm_80 = "Storm 80 Yard!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{117988, "FLASHSHAKE", "SAY", "WHISPER"},
		{117436, "SAY", "PROXIMITY", "FLASHSHAKE"} , 118077,
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
	self:Log("SPELL_CAST_SUCCESS", "DefiledGroundCast", 117989, 117988, 118091, 117986)
	self:Log("SPELL_AURA_APPLIED", "DefiledGround", 117989, 117988, 118091, 117986)

	-- Elder Regail
	self:Log("SPELL_AURA_APPLIED", "LightningPrisonApplied", 122874, 117398, 117436, 111850)
	self:Log("SPELL_AURA_REMOVED", "LightningPrisonRemoved", 122874, 117398, 117436, 111850)
	-- Storm
	self:Log("SPELL_CAST_START", "LightningStormStart", 118077) -- at himself -- need combatlog for this
	-- not sure about the usefulness of these vv
	self:Log("SPELL_CAST_SUCCESS", "LightningStorm20", 118003) -- 20 Yard
	self:Log("SPELL_CAST_SUCCESS", "LightningStorm40", 118004) -- 40 Yard
	self:Log("SPELL_CAST_SUCCESS", "LightningStorm60", 118005) -- 60 Yard

	-- Elder Asani
	self:Log("SPELL_CAST_START", "CleansingWaterStart", 117309) -- Spawn Watter Bubble
	self:Log("SPELL_CAST_SUCCESS", "CleansingPool", 117309) -- the good one

	self:Log("SPELL_CAST_START", "CorruptedWater", 117227) -- Spawn Watter Bubble -- need combatlog for this

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:Death("Deaths", 60583, 60585, 60586)
end

function mod:OnEngage(diff)
	bossDead = 0
	self:Berserk(360) -- assume
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--Protector Kaolan

do
	local function checkTarget(sGUID)
		for i = 1, 4 do
			local bossId = ("boss%d"):format(i)
			if UnitGUID(bossId) == sGUID then
				local player = UnitName(bossId.."target")
				if player then
					mod:Whisper(117988, player, defiledGround)
				end
				if UnitIsUnit(bossId.."target", "player") then
					mod:FlashShake(117988)
					mod:Say(117988, CL["say"]:format(defiledGround))
					return
				end
			end
		end
	end
	function mod:DefiledGroundCast(...)
		local sGUID = select(11, ...)
		self:ScheduleTimer(checkTarget, 0.1, sGUID)
	end
end

do
	local last = 0
	function mod:DefiledGround(player, spellId, _, _, spellName)
		local time = GetTime()
		if (time - last) > 2 then
			last = time
			if UnitIsUnit(player, "player") then
				self:LocalMessage(117988, CL["underyou"]:format(spellName), "Personal", spellId, "Info")
				self:FlashShake(117988)
			end
		end
	end
end

-- Elder Regail

do
	local scheduled = nil
	local function Prison(spellName)
		mod:TargetMessage(117436, spellName, lightningPrsionList, "Important", 117436)
		scheduled = nil
	end
	function mod:LightningPrisonApplied(player, _, _, _, spellName)
		lightningPrsionList[#lightningPrsionList + 1] = player
		if UnitIsUnit(player, "player") then
			self:FlashShake(117436)
			self:Say(117436, CL["say"]:format(spellName))
			self:OpenProximity(7, 117436)
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(Prison, 0.2, spellName)
		end
	end
end

function mod:LightningPrisonRemoved(player)
	if UnitIsUnit(player, "player") then
		self:CloseProximity(117436)
	end
end

-- Big AOE - he start the AOE at Himself, then a Circuit at 20 Yard (10 Yrd + 10 Trigger) then 40 Yard, then 60 Yard then 80 Yard (you get dmg if you 10 Yard near at this. First Spell Cast has Casttime rest is "instant"

function mod:LightningStormStart(_, spellId)
	self:Message(118077, L["storm_him"], "Important", 118077, "Alarm")
end

function mod:LightningStorm20(_, spellId)
	self:Message(118077, L["storm_20"], "Important", 118003, "Alarm")
end
function mod:LightningStorm40(_, spellId)
	self:Message(118077, L["storm_40"], "Important", 118004, "Alarm")
end
function mod:LightningStorm60(_, spellId)
	self:Message(118077, L["storm_60"], "Important", 118005, "Alarm")
end

-- Elder Asani

function mod:CleansingWaterStart(_, _, _, _, spellName)
	self:Message(117309, CL["soon"]:format(spellName), "Attention")
	self:Bar(117309, CL["soon"]:format(spellName), 5, 117309)
end

function mod:CleansingPool(_, _, _, _, spellName)
	self:Message(117309, spellName, "Urgent")
	self:Bar(117309, "~"..spellName , 32, 117309)
end

-- Globe BAD
function mod:CorruptedWater(_, spellId, _, _, spellName)
	self:Message(117227, spellName, "Important", 117227, "Alarm")
end

function mod:Deaths(mobId)
	bossDead = bossDead + 1
	if bossDead > 3 then
		self:Win()
	end
end

