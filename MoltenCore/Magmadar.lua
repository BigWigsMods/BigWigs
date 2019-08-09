
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Magmadar", 409, 1520)
if not mod then return end
mod:RegisterEnableMob(11982)
mod.toggleOptions = {19408, 19451, 19428}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_CAST_SUCCESS", "Panic", 19408)
	self:Log("SPELL_CAST_SUCCESS", "Enrage", 19451)
	self:Log("SPELL_AURA_APPLIED", "Conflagration", 19428)

	self:Death("Win", 11982)
end

function mod:OnEngage()
	self:Bar(19451, 8.5) -- Enrage
	self:Bar(19408, 9.7) -- Panic
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Panic(args)
	self:CDBar(args.spellId, 31) -- 31-38
	self:Message(args.spellId, "green")
end

function mod:Enrage(args)
	self:Bar(args.spellId, 8, CL.cast:format(args.spellName))
	self:Message(args.spellId, "yellow", "Info")
end

function mod:Conflagration(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "blue", "Alert", CL.underyou:format(args.spellName))
	end
end

