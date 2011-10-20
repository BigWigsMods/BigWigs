if tonumber((select(4, GetBuildInfo()))) < 40300 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Warmaster Blackhorn", 824, 332)
if not mod then return end
mod:RegisterEnableMob(56427, 56598, 42288) -- Blackhorn, The Skyfire, Ka'anu Reevs

--------------------------------------------------------------------------------
-- Locales
--

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
		108043, "bosskill",
	}, {
		[108043] = "general"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED_DOSE", "Sunder", 108043)
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 56427)
end

function mod:OnEngage(diff)

end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MalevolentStrikes(player, spellId, _, _, spellName, stack)
	local stackWarn = 3 -- self:Difficulty() > 2 and 5 or 10
	if stack > stackWarn then
		self:TargetMessage(108043, spellName, player, "Urgent", spellId, "Info", stack)
	end
end


