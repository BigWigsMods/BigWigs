--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Oondasta", 929, 826)
if not mod then return end
mod:RegisterEnableMob(69161)
mod.otherMenu = 6
mod.worldBoss = 69161

--------------------------------------------------------------------------------
-- Locals
--

local roarCounter = 0

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {{137504, "TANK_HEALER"}, 137457, 137505, "proximity", "bosskill"}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Crush", 137504)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Crush", 137504)
	self:Log("SPELL_CAST_START", "PiercingRoar", 137457)
	self:Log("SPELL_CAST_START", "FrillBlast", 137505)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 69161)
end

function mod:OnEngage()
	self:OpenProximity("proximity", 10)
	roarCounter = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Crush(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Urgent", "Info")
end

function mod:PiercingRoar(args)
	roarCounter = roarCounter + 1
	self:Message(args.spellId, "Attention", UnitPowerType("player") == 0 and "Long", CL["count"]:format(args.spellName, roarCounter)) -- sound for mana users
	self:CDBar(args.spellId, 25, CL["count"]:format(args.spellName, roarCounter+1))
end

function mod:FrillBlast(args)
	self:Message(args.spellId, "Important", "Alert")
	self:CDBar(args.spellId, 25)
end

