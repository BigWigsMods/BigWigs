--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Ebonroc", 469, 1533)
if not mod then return end
mod:RegisterEnableMob(14601)
mod.toggleOptions = {23339, 22539, {23340, "ICON"}}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "WingBuffet", 23339)
	self:Log("SPELL_CAST_START", "ShadowFlame", 22539)
	self:Log("SPELL_AURA_APPLIED", "Curse", 23340)
	self:Log("SPELL_AURA_REMOVED", "CurseRemoved", 23340)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 14601)
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

function mod:Curse(args)
	self:TargetMessage(args.spellId, args.destName, "yellow")
	self:TargetBar(args.spellId, 8, args.destName, 107905, args.spellId) -- Shadow
	self:PrimaryIcon(args.spellId, args.destName)
end

function mod:CurseRemoved(args)
	self:StopBar(107905, args.destName) -- Shadow
	self:PrimaryIcon(args.spellId)
end

