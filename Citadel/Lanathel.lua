--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Blood-Queen Lana'thel", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(37955)
mod.toggleOptions = {{71340, "FLASHSHAKE"}, "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local pactTargets = mod:NewTargetList()

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

function mod:OnBossEnable()

	self:Log("SPELL_AURA_APPLIED", "PactApplied", 71340)
	self:Death("Win", 37955)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	self:Berserk(330, true)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local scheduled = nil
	local function PactWarn(spellName)
		mod:TargetMessage(71340, spellName, pactTargets, "Urgent", 71340)
		scheduled = nil
	end
	function mod:PactApplied(player, spellId, _, _, spellName)
		pactTargets[#pactTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(PactWarn, 0.3, spellName)
		end
		if UnitIsUnit(player, "player") then
			self:FlashShake(71340)
		end
	end
end

