--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Firemaw", 469, 1532)
if not mod then return end
mod:RegisterEnableMob(11983)
mod.toggleOptions = {23339, 22539}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "WingBuffet", 23339)
	self:Log("SPELL_CAST_START", "ShadowFlame", 22539)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 11983)
end

function mod:OnEngage()
	self:Bar(23339, 29) -- Wing Buffet
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:WingBuffet(args)
	self:Message(args.spellId, "red")
	self:DelayedMessage(args.spellId, 27, "orange", CL.custom_sec:format(args.spellName, 5))
	self:Bar(args.spellId, 32)
end

function mod:ShadowFlame(args)
	self:Message(args.spellId, "red")
end

