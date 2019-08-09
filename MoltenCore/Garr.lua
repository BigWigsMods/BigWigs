
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Garr", 409)
if not mod then return end
mod:RegisterEnableMob(12057)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		19492, -- Antimagic Pulse
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_CAST_SUCCESS", "Pulse", self:SpellName(19492))

	self:Death("Win", 12057)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Pulse(args)
	self:Bar(19492, 18)
end

