--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Deathbound Ward", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(37007)
mod.toggleOptions = {71022}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Shout", 71022)
	self:Death("Deaths", 37007)
end

--------------------------------------------------------------------------------
-- Event handlers
--

function mod:Shout(player, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Personal", spellId, "Alert")
	self:Bar(spellId, spellName, 3, spellId)
end

function mod:Deaths()
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "Disable")
end

