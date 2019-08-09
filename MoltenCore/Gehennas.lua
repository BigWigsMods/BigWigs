
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Gehennas", 409)
if not mod then return end
mod:RegisterEnableMob(12259)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		19716, -- Gehennas' Curse
		{19717, "FLASH"}, -- Rain of Fire
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_CAST_SUCCESS", "Curse", self:SpellName(19716))
	self:Log("SPELL_AURA_APPLIED", "Fire", self:SpellName(19717))

	self:Death("Win", 12259)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Curse(args)
	self:Bar(19716, 30)
	self:Message(19716, "orange")
	self:DelayedMessage(19716, 25, "yellow", CL.custom_sec:format(args.spellName, 5))
end

function mod:Fire(args)
	if self:Me(args.destGUID) then
		self:Flash(19717)
		self:Message(19717, "blue", "Alarm", CL.you:format(args.spellName))
	end
end

