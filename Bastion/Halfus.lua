--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Halfus Wyrmbreaker", "The Bastion of Twilight")
if not mod then return end
mod:RegisterEnableMob(44600)
mod.toggleOptions = {86169, "berserk", "bosskill"}
mod.optionHeaders = {
	berserk = "general",
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
	self:Log("SPELL_CAST_START", "FuriousRoar", 86169)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	
	self:RegisterEvent("UNIT_HEALTH")

	self:Death("Win", 44600)
end


function mod:OnEngage(diff)
	self:Berserk(360)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	if unit == "boss1" then
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
		if hp == 50 then
			self:Message(86169, (GetSpellInfo(86169)), "Urgent", 86169)
			self:Bar(86169, (GetSpellInfo(86169)), 25, 86169)
		end
	end
end

function mod:FuriousRoar(_, spellId, _, _, spellName)
	self:Message(86169, spellName, "Urgent", spellId)
	self:Bar(86169, spellName, 25, 86169)
end

