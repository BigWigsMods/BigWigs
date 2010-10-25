if not GetSpellInfo(90000) then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Atramedes", "Blackwing Descent")
if not mod then return end
mod:RegisterEnableMob(41442)
mod.toggleOptions = {"ground_phase", 78075, 77840, "air_phase", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local airPhaseDuration = 30

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.ground_phase = "Ground Phase"
	L.ground_phase_desc = "Warning for when Atramedes lands."
	L.air_phase = "Air Phase"
	L.air_phase_desc = "Warning for when Atramedes takes off."
	
	L.air_phase_trigger = "Yes, run! With every step your heart quickens. The beating, loud and thunderous... Almost deafening. You cannot escape!"
	
	L.sonicbreath_cooldown = "~Sonic Breath"
end
L = mod:GetLocale()

mod.optionHeaders = {
	ground_phase = L["ground_phase"],
	air_phase = L["air_phase"],
	bosskill = "general",
}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "SonicBreath", 78075)
	self:Log("SPELL_AURA_APPLIED", "SearingFlame", 77840)
	self:Yell("AirPhase", L["air_phase_trigger"])

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 41442)
end

function mod:OnEngage(diff)
	self:Bar(78075, L["sonicbreath_cooldown"], 23, 78075)
	self:Bar(77840, (GetSpellInfo(77840)), 45, 77840)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SonicBreath(_, spellId, _, _, spellName)
	self:Message(78075, spellName, "Urgent", spellId, "Info")
	self:Bar(78075, L["sonicbreath_cooldown"], 42, spellId)
end

function mod:SearingFlame(_, spellId, _, _, spellName)
	self:Message(77840, spellName, "Urgent", spellId, "Alarm")
	self:Bar(77840, spellName, 120, spellId) -- or is it realated to air/ground phase?
end

do 
	local scheduled = nil
	local function groundPhase()
		mod:Message("ground_phase", L["ground_phase"], "Attention", 61882) -- Earthquake Icon
		mod:Bar("air_phase", L["air_phase"], 85, 5740) -- Rain of Fire Icon
	end
	function mod:AirPhase()
		self:Message("air_phase", L["air_phase"], "Attention", 5740) -- Rain of Fire Icon
		self:Bar("ground_phase", L["ground_phase"], airPhaseDuration, 61882) -- Earthquake Icon
		
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(groundPhase, airPhaseDuration)
		end
	end
end

