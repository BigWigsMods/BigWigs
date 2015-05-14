
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Supreme Lord Kazzak", 945, 1452)
if not mod then return end
mod:RegisterEnableMob(94015)
mod.otherMenu = 962
mod.worldBoss = 94015

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		187664, -- Fel Breath
		187466, -- Supreme Doom
		{187668, "SAY", "PROXIMITY"}, -- Mark of Kazzak
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "FelBreath", 187664)
	self:Log("SPELL_AURA_REMOVED", "FelBreathRemoved", 187664)
	self:Log("SPELL_CAST_START", "SupremeDoom", 187466)
	self:Log("SPELL_AURA_APPLIED", "MarkOfKazzak", 187668)
	self:Log("SPELL_AURA_REMOVED", "MarkOfKazzakRemoved", 187668)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 94015)
end

function mod:OnEngage()
	
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FelBreath(args)
	if self:Tank(args.destName) then
		self:TargetMessage(args.spellId, args.destName, "Attention", self:Tank() and "Alert")
		self:TargetBar(args.spellId, 30, args.destName)
	end
end

function mod:FelBreathRemoved(args)
	if self:Tank(args.destName) then
		self:StopBar(args.spellName, args.destName)
	end
end

function mod:SupremeDoom(args)
	self:Message(args.spellId, "Important", "Info", CL.incoming:format(args.spellName))
end

function mod:MarkOfKazzak(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
		self:TargetBar(args.spellId, 15, args.destName)
		self:Say(args.spellId)
		self:OpenProximity(args.spellId, 8)
	end
end

function mod:MarkOfKazzakRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellName, args.destName)
		self:CloseProximity(args.spellId)
	end
end

