--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Al'Akir", "Throne of the Four Winds")
if not mod then return end
mod:RegisterEnableMob(46753)
mod.toggleOptions = {{88427, "FLASHSHAKE"}, 87770, "bosskill"}
mod.optionHeaders = {
	bosskill = "general",
}

--------------------------------------------------------------------------------
-- Locals
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

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Electrocute", 88427)
	self:Log("SPELL_CAST_START", "WindBurst", 87770, 93261)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:Death("Win", 46753)
end


function mod:OnEngage(diff)
	
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Electrocute(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:FlashShake(88427)
	end
	self:TargetMessage(88427, spellName, player, "Personal", spellId, "Alarm")
end

function mod:WindBurst(_, spellId, _, _, spellName)
	self:Bar(87770, spellName, 26, spellId)
	self:Message(87770, spellName, "Important", spellId, "Alert")
end

