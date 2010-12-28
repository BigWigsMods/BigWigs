--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Nefarian", "Blackwing Descent")
if not mod then return end
mod:RegisterEnableMob(41270, 41376)
mod.toggleOptions = {"phase", 94085, 79339, { 80626, "FLASHSHAKE"}, "bosskill"}
mod.optionHeaders = {
	phase = "general",
}
--------------------------------------------------------------------------------
-- Locals
--

local phase, deadAdds, shadowBlazeTimer = 1, 0, 30
local cinderTargets = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phase = "Phases"
	L.phase_desc = "Warnings for the Phase changes."

	L.phase_two_trigger = "Curse you, mortals! Such a callous disregard for one's possessions must be met with extreme force!"

	L.phase_three_trigger = "I have tried to be an accommodating host, but you simply will not die! Time to throw all pretense aside and just... KILL YOU ALL!"

	L.shadowblaze_trigger = "Flesh turns to ash!"

	L.cinder_say = "Explosive Cinders on ME!"

	L.chromatic_prototype = "Chromatic Prototype" -- 3 adds name
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()

	self:Yell("PhaseTwo", L["phase_two_trigger"])
	self:Yell("PhaseThree", L["phase_three_trigger"])
	self:Yell("ShadowBlaze", L["shadowblaze_trigger"])

	self:Log("SPELL_AURA_APPLIED", "ExplosiveCinders", 79339)
	self:Log("SPELL_AURA_APPLIED_DOSE", "StolenPower", 80626)

	self:RegisterEvent("UNIT_DIED")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 41376)
end


function mod:OnEngage(diff)
	phase, deadAdds, shadowBlazeTimer = 1, 0, 30
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_DIED(event, _, _, _, _, destName) -- I guess
	if destName == L["chromatic_prototype"] then
		deadAdds = deadAdds + 1
		if mod:GetInstanceDifficulty() > 2 then
			self:SendMessage("BigWigs_StopBar", self, L["phase"]:format(phase))
			phase = 3
			self:Message("phase", L["phase"]:format(phase), "Attention", 81007)
		end
	end
	if deadAdds == 3 then
		self:SendMessage("BigWigs_StopBar", self, L["phase"]:format(phase))
		phase = 3
		self:Message("phase", L["phase"]:format(phase), "Attention", 81007)
	end
end

function mod:PhaseTwo()
	phase = 2
	self:Message("phase", L["phase"]:format(phase), "Attention", 78621)
	mod:Bar("phase", L["phase"]:format(phase), 180, 78621)
end

function mod:PhaseThree()
	self:SendMessage("BigWigs_StopBar", self, L["phase"]:format(phase))
	phase = 3
	self:Message("phase", L["phase"]:format(phase), "Attention", 78621)
	mod:Bar(94085, (GetSpellInfo(94085)), 10, 94085)
end

local function ShadowBlazeNoTrigger()
	if shadowBlazeTimer > 10 then
		shadowBlazeTimer = shadowBlazeTimer - 5
	end
	mod:Bar(94085, (GetSpellInfo(94085)), shadowBlazeTimer, 94085)
	mod:ScheduleTimer(ShadowBlazeNoTrigger, shadowBlazeTimer)
end

function mod:ShadowBlaze()
	mod:Bar(94085, (GetSpellInfo(94085)), shadowBlazeTimer, 94085)
	self:ScheduleTimer(ShadowBlazeNoTrigger, shadowBlazeTimer)
end

do
	local scheduled = nil
	local function cinderWarn(spellName)
		mod:TargetMessage(79339, spellName, cinderTargets, "Urgent", 79339, "Info")
		scheduled = nil
	end
	function mod:ExplosiveCinders(player, spellId, _, _, spellName)
		cinderTargets[#cinderTargets + 1] = player
		if UnitIsUnit(player, "player") then
			self:FlashShake(79339)
			self:Say(79339, L["cinder_say"])
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(cinderWarn, 0.3, spellName)
		end
	end
end

function mod:StolenPower(player, spellId, _, _, spellName, stack)
	if UnitIsUnit(player, "player") and stack == 150 then
		self:FlashShake(80626)
		self:LocalMessage(80626, spellName, "Personal", spellId, "Info")
	end
end
