if GetBuildInfo() ~= "4.0.3" then return end -- lets not braek live stuff
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Atramedes", "Blackwing Descent")
if not mod then return end
mod.toggleOptions = {"ground_phase", 78075, 77840, "air_phase", "bosskill"}


--------------------------------------------------------------------------------
-- Locals
--

local air_phase_duration = 30

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.ground_phase = "Ground Phase"
	L.ground_phase_desc = "Warning for when Atramedes lands"
	L.air_phase = "Air Phase"
	L.air_phase_desc = "Warning for when Atramedes takes off"
	
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

function mod:OnRegister()
	self:RegisterEnableMob(41442)
end

function mod:OnBossEnable()
	BigWigs:Print("This is a alpha module, timers ARE inaccurate. Please provide us with Transcriptor logs! You can contact us at #bigwigs@freenode.net or with the wowace ticket tracker.")

	self:Log("SPELL_CAST_SUCCESS", "SonicBreath", 78075)
	self:Log("SPELL_AURA_APPLIED", "SearingFlame", 77840)
	self:Yell("AirPhase", L["air_phase_trigger"])

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 41442)
	

end


function mod:OnEngage(diff)
	self:Bar(78075, L["sonicbreath_cooldown"], 23, 78075)
	self:Bar(77840, spellName, 45, spellId)
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
	local function GroundPhase()
		self:Message("ground_phase", L["ground_phase"], "Attention", 61882) -- Earthquake Icon
		mod:Bar("air_phase", L["air_phase"], 85, 5740) -- Rain of Fire Icon
	end	
	function mod:AirPhase()
		self:Message("air_phase", L["air_phase"], "Attention", 5740) -- Rain of Fire Icon
		self:Bar("ground_phase", L["ground_phase"], air_phase_duration, 61882) -- Earthquake Icon
		
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(GroundPhase, air_phase_duration)
		end			
	end
end