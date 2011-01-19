--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Halfus Wyrmbreaker", "The Bastion of Twilight")
if not mod then return end
mod:RegisterEnableMob(44600)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions() return {86169, "berserk", "bosskill"} end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "FuriousRoar", 86169, 86170, 86171, 83710)

	--no CheckBossStatus here as event does not fire, GM confirms known issue
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 44600)
end

function mod:OnEngage()
	self:Berserk(360)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FuriousRoar(_, spellId, _, _, spellName)
	self:Message(86169, spellName, "Urgent", spellId)
	self:Bar(86169, spellName, 25, 86169)
end

