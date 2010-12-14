--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Argaloth", "Baradin Hold")
if not mod then return end
mod.otherMenu = "Baradin Hold"
mod:RegisterEnableMob(47120)
mod.toggleOptions = {88942, 88954, 88972, "berserk", "bosskill"}
mod.optionHeaders = {
	88942 = "general",
}
--------------------------------------------------------------------------------
-- Locals
--

local consumingTargets = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.darkness_message = "Darkness"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "MeteorSlash", 88942, 95172)
	self:Log("SPELL_AURA_APPLIED", "ConsumingDarkness", 88954, 95173)
	self:Log("SPELL_CAST_START", "FelFirestorm", 88972)
	self:Death("Win", 47120)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	self:Berserk(300)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MeteorSlash(_, spellId, _, _, spellName)
	self:Message(88942, spellName, "Important", spellId)
end

do
	local scheduled = nil
	local function consumingWarn()
		mod:TargetMessage(88954, L["darkness_message"], consumingTargets, "Personal", 88954)
		scheduled = nil
	end
	function mod:ConsumingDarkness(player)
		consumingTargets[#consumingTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(consumingWarn, 0.2)
		end
	end
end

function mod:FelFirestorm(_, spellId, _, _, spellName)
	self:Message(88972, spellName, "Attention", spellId)
end

