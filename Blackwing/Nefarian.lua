--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Nefarian", "Blackwing Descent")
if not mod then return end
mod:RegisterEnableMob(41270, 41376)

--------------------------------------------------------------------------------
-- Locals
--

local phase, deadAdds, shadowBlazeTimer = 1, 0, 30
local cinderTargets = mod:NewTargetList()
local powerTargets = mod:NewTargetList()
local shadowblaze = GetSpellInfo(94085)
local phase3warned = false
local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phase = "Phases"
	L.phase_desc = "Warnings for the Phase changes."

	L.phase_two_trigger = "Curse you, mortals! Such a callous disregard for one's possessions must be met with extreme force!"

	L.phase_three_trigger = "I have tried to be an accommodating host, but you simply will not die! Time to throw all pretense aside and just... KILL YOU ALL!"

	L.crackle_trigger = "The air crackles with electricity!"
	L.crackle_message = "Electrocute soon!"

	L.onyxia_power_message = "Explosion soon!"

	L.cinder_say = "Explosive Cinders on ME!"

	L.chromatic_prototype = "Chromatic Prototype" -- 3 adds name
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		78999, 81272, 94085,
		{79339, "FLASHSHAKE", "SAY", "PROXIMITY"}, { 80626, "FLASHSHAKE"}, "berserk",
		"phase", "bosskill"
	}, {
		[78999] = "normal",
		[79339] = "heroic",
		phase = "general"
	}
end

function mod:OnBossEnable()
	self:Yell("PhaseTwo", L["phase_two_trigger"])
	self:Yell("PhaseThree", L["phase_three_trigger"])

	self:Log("SPELL_AURA_APPLIED", "ExplosiveCindersApplied", 79339)
	self:Log("SPELL_AURA_REMOVED", "ExplosiveCindersRemoved", 79339)
	self:Log("SPELL_AURA_APPLIED_DOSE", "StolenPower", 80626)
	self:Log("SPELL_AURA_APPLIED", "InitialStolenPower", 80573, 80591, 80592, 80621, 80622, 80623, 80624, 80625, 80626, 80627)

	self:Emote("Electrocute", L["crackle_trigger"])

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:RegisterEvent("UNIT_POWER")

	self:Death("Deaths", 41376, 41948)
end


function mod:OnEngage(diff)
	if diff > 2 then
		self:Berserk(600) -- is it really?
	end
	phase, deadAdds, shadowBlazeTimer = 1, 0, 35
	phase3warned = false
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Electrocute()
	self:Message(81272, L["crackle_message"], "Urgent", 81272, "Alert")
end

function mod:Deaths(mobId)
	if mobId == 41948 then
		deadAdds = deadAdds + 1
		if self:GetInstanceDifficulty() > 2 and not phase3warned then
			self:SendMessage("BigWigs_StopBar", self, CL["phase"]:format(phase))
			phase = 3
			self:Message("phase", CL["phase"]:format(phase), "Attention", 81007)
			phase3warned = true
		end
		if deadAdds == 3 and not phase3warned then
			self:SendMessage("BigWigs_StopBar", self, CL["phase"]:format(phase))
			phase = 3
			self:Message("phase", CL["phase"]:format(phase), "Attention", 81007)
			phase3warned = true
		end
	elseif mobId == 41376 then
		self:Win()
	end
end

function mod:PhaseTwo()
	phase = 2
	self:Message("phase", CL["phase"]:format(phase), "Attention", 78621)
	local d = self:GetInstanceDifficulty()
	if d == 2 then
		self:Bar("phase", CL["phase"]:format(phase), 127, 78621)
	elseif d == 4 then
		self:Bar("phase", CL["phase"]:format(phase), 240, 78621) -- random guessed number
	else
		self:Bar("phase", CL["phase"]:format(phase), 180, 78621)
	end
end

local function nextBlaze()
	if mod:GetInstanceDifficulty() > 2 then
		if shadowBlazeTimer > 5 then
			shadowBlazeTimer = shadowBlazeTimer - 5
		end
	else
		if shadowBlazeTimer > 10 then
			shadowBlazeTimer = shadowBlazeTimer - 5
		end
	end
	mod:Message(94085, shadowblaze, "Important", 94085, "Alarm")
	mod:Bar(94085, shadowblaze, shadowBlazeTimer, 94085)
	mod:ScheduleTimer(nextBlaze, shadowBlazeTimer)
end

function mod:PhaseThree()
	self:SendMessage("BigWigs_StopBar", self, CL["phase"]:format(phase))
	if not phase3warned then
		phase = 3
		self:Message("phase", CL["phase"]:format(phase), "Attention", 78621)
		phase3warned = true
	end
	self:Bar(94085, shadowblaze, 10, 94085)
	self:ScheduleTimer(nextBlaze, 10)
end

do
	local scheduled = nil
	local function cinderWarn(spellName)
		mod:TargetMessage(79339, spellName, cinderTargets, "Urgent", 79339, "Info")
		scheduled = nil
	end
	function mod:ExplosiveCindersApplied(player, spellId, _, _, spellName)
		cinderTargets[#cinderTargets + 1] = player
		if UnitIsUnit(player, "player") then
			self:FlashShake(79339)
			self:Say(79339, L["cinder_say"])
			self:Bar(79339, spellName, 8, 79339)
			self:OpenProximity(10, 79339) -- assumed
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(cinderWarn, 0.3, spellName)
		end
	end
end

do
	local scheduled = nil
	local function powerWarn(spellName)
		mod:TargetMessage(80626, spellName, powerTargets, "Attention", 80626)
		scheduled = nil
	end
	function mod:InitialStolenPower(player, _, _, _, spellName)
		powerTargets[#powerTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(powerWarn, 1, spellName) -- 1 sec :S
		end
	end
end

function mod:StolenPower(player, spellId, _, _, spellName, stack)
	if UnitIsUnit(player, "player") and stack == 150 then
		self:FlashShake(80626)
		self:LocalMessage(80626, spellName, "Personal", spellId, "Info")
	end
end

function mod:ExplosiveCindersRemoved(player)
	if UnitIsUnit(player, "player") then
		self:CloseProximity(79339)
	end
end

function mod:UNIT_POWER(event, unit, powerType)
	if unit == "boss1" and powerType == "ALTERNATE" then
		local power = UnitPower(unit, ALTERNATE_POWER_INDEX)
		if power > 80 then
			self:Message(78999, L["onyxia_power_message"], "Attention", 78999)
			self:UnregisterEvent("UNIT_POWER")
		end
	end
end

