--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Oondasta", 929, 826)
if not mod then return end
mod:RegisterEnableMob(69161)
mod.otherMenu = 6
mod.worldBoss = true

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {{137504, "TANK_HEALER"}, 137457, 137505, "bosskill"}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Crush", 137504)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Crush", 137504)
	self:Log("SPELL_CAST_START", "PiercingRoar", 137457)
	self:Log("SPELL_CAST_START", "FrillBlast", 137505)

	self:Death("Win", 69161)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Crush(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Urgent", "Info")
end

function mod:PiercingRoar(args)
	self:Message(args.spellId, "Attention", UnitPowerType("player") == 0 and "Alarm") -- sound for mana users
end

function mod:FrillBlast(args)
	self:Message(args.spellId, "Important", "Alert")
end

