--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nefarian", 754, 174)
if not mod then return end
mod:RegisterEnableMob(41270, 41376)

--------------------------------------------------------------------------------
-- Locals
--

local phase, deadAdds, shadowBlazeTimer = 1, 0, 35
local cinderTargets = mod:NewTargetList()
local powerTargets = mod:NewTargetList()
local shadowblaze = GetSpellInfo(94085)
local phase3warned = false
local shadowblazeHandle, lastBlaze = nil, 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phase = "Phases"
	L.phase_desc = "Warnings for the Phase changes."

	L.discharge_bar = "~Discharge CD"

	L.phase_two_trigger = "Curse you, mortals! Such a callous disregard for one's possessions must be met with extreme force!"

	L.phase_three_trigger = "I have tried to be an accommodating host"

	L.crackle_trigger = "The air crackles with electricity!"
	L.crackle_message = "Electrocute soon!"

	L.shadowblaze_trigger = "Flesh turns to ash!"
	L.shadowblaze_message = "Fire under YOU!"

	L.onyxia_power_message = "Explosion soon!"

	L.chromatic_prototype = "Chromatic Prototype" -- 3 adds name
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		94115, 78999, 81272, {94085, "FLASHSHAKE"},
		{79339, "FLASHSHAKE", "SAY", "PROXIMITY"}, "berserk",
		"phase", "bosskill"
	}, {
		[94115] = "Onyxia",
		[78999] = "normal",
		[79339] = "heroic",
		phase = "general"
	}
end

function mod:OnBossEnable()
	self:Yell("PhaseTwo", L["phase_two_trigger"])
	self:Yell("PhaseThree", L["phase_three_trigger"])
	self:Yell("ShadowblazeCorrection", L["shadowblaze_trigger"])

	--Not bad enough that there is no cast trigger, there's also over 9 thousand Id's
	self:Log("SPELL_DAMAGE", "LightningDischarge", "*")
	self:Log("SPELL_MISSED", "LightningDischarge", "*")

	self:Log("SPELL_AURA_APPLIED", "ExplosiveCindersApplied", 79339)
	self:Log("SPELL_AURA_REMOVED", "ExplosiveCindersRemoved", 79339)
	self:Log("SPELL_DAMAGE", "PersonalShadowBlaze", 81007, 94085, 94086, 94087)

	self:Emote("Electrocute", L["crackle_trigger"])

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Deaths", 41376, 41948)
end

function mod:OnEngage(diff)
	self:Berserk(630) -- is it really?
	self:Bar(94115, L["discharge_bar"], 30, 94115)
	phase, deadAdds, shadowBlazeTimer = 1, 0, 35
	phase3warned = false
	self:RegisterEvent("UNIT_POWER")
	shadowblazeHandle, lastBlaze = nil, 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	local discharge = GetSpellInfo(94115)
	function mod:LightningDischarge(_, spellId, _, _, spellName)
		if spellName ~= discharge then return end
		local t = GetTime()
		if (t - prev) > 10 then
			prev = t
			self:Bar(94115, L["discharge_bar"], 21, spellId)
		end
	end
end

do
	local prev = 0
	function mod:PersonalShadowBlaze(player, spellId)
		local t = GetTime()
		if (t - prev) > 1 and UnitIsUnit(player, "player") then
			prev = t
			self:LocalMessage(94085, L["shadowblaze_message"], "Personal", spellId, "Info")
			self:FlashShake(94085)
		end
	end
end

function mod:Electrocute()
	self:Message(81272, L["crackle_message"], "Urgent", 81272, "Alert")
	self:Bar(81272, (GetSpellInfo(81272)), 5, 81272)
end

function mod:Deaths(mobId)
	if mobId == 41948 then
		deadAdds = deadAdds + 1
		if self:Difficulty() > 2 and not phase3warned then
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
	local d = self:Difficulty()
	if d == 4 then
		-- Heroic 25man (diff 4) probably 4 minutes
		self:Bar("phase", CL["phase"]:format(phase), 240, 78621) -- random guessed number
	else
		-- Normal 10man (diff 1) probably 3 minutes
		-- Normal 25man (diff 2) confirmed 3 minutes
		self:Bar("phase", CL["phase"]:format(phase), 180, 78621)
	end
	-- XXX Heroic 10man (diff 3) - no idea.
end

local function nextBlaze()
	local diff = mod:Difficulty()
	if shadowBlazeTimer > 10 and diff > 2 then
		shadowBlazeTimer = shadowBlazeTimer - 5
	elseif shadowBlazeTimer > 15 and diff < 3 then
		shadowBlazeTimer = shadowBlazeTimer - 5
	end
	mod:Message(94085, shadowblaze, "Important", 94085, "Alarm")
	mod:Bar(94085, shadowblaze, shadowBlazeTimer, 94085)
	lastBlaze = GetTime()
	shadowblazeHandle = mod:ScheduleTimer(nextBlaze, shadowBlazeTimer)
end

function mod:ShadowblazeCorrection()
	self:CancelTimer(shadowblazeHandle, true)
	if (GetTime() - lastBlaze) <= 3 then
		shadowblazeHandle = mod:ScheduleTimer(nextBlaze, shadowBlazeTimer)
	elseif (GetTime() - lastBlaze) >= 6 then
		nextBlaze()
	end
	lastBlaze = GetTime()
end

function mod:PhaseThree()
	self:SendMessage("BigWigs_StopBar", self, CL["phase"]:format(phase))
	if not phase3warned then
		phase = 3
		self:Message("phase", CL["phase"]:format(phase), "Attention", 78621)
		phase3warned = true
	end
	self:Bar(94085, shadowblaze, 12, 94085)
	shadowblazeHandle = self:ScheduleTimer(nextBlaze, 12)
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
			self:Say(79339, CL["say"]:format(spellName))
			self:Bar(79339, spellName, 8, spellId)
			self:OpenProximity(10, 79339) -- assumed
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(cinderWarn, 0.3, spellName)
		end
	end
end

function mod:ExplosiveCindersRemoved(player)
	if UnitIsUnit(player, "player") then
		self:CloseProximity(79339)
	end
end

do
	local onyxia = BigWigs:Translate("Onyxia")
	function mod:UNIT_POWER()
		if UnitName("boss1") == onyxia then
			local power = UnitPower("boss1", ALTERNATE_POWER_INDEX)
			if power > 80 then
				self:Message(78999, L["onyxia_power_message"], "Attention", 78999)
				self:UnregisterEvent("UNIT_POWER")
			end
		end
	end
end

