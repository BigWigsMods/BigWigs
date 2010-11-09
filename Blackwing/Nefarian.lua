if not GetSpellInfo(90000) then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Nefarian", "Blackwing Descent")
if not mod then return end
mod:RegisterEnableMob(41270, 41376)
mod.toggleOptions = {"phase", "bosskill"}
mod.optionHeaders = {
	phase = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

local phase, deadAdds = 1, 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phase = "Phases"
	L.phase_desc = "Warnings for the Phase changes"

	L.phase_two_trigger = "Curse you, mortals! Such a callous disregard for one's possessions must be met with extreme force!"

	L.chromatic_prototype = "Chromatic Prototype" -- 3 adds name
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()

	self:Yell("PhaseTwo", L["phase_two_trigger"])

	self:RegisterEvent("UNIT_DIED")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 41376)
end


function mod:OnEngage(diff)
	phase, deadAdds = 1, 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:UNIT_DIED(event, destGUID, destName) -- I guess
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