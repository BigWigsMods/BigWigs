
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
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "FelBreath", 187664)
	self:Log("SPELL_AURA_REMOVED", "FelBreathRemoved", 187664)
	self:Log("SPELL_CAST_START", "SupremeDoom", 187466)

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

