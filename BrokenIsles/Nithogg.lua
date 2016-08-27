-- TO DO List Needs combat Testing to see how accurate timers actually are
-- Needs onEngage timers
--------------------------------------------------------------------------------
-- Module Declaration
--
local mod, CL = BigWigs:NewBoss("Nithogg", -1017, 1749)
if not mod then return end

mod:RegisterEnableMob(107544)
mod.otherMenu = 1007
mod.worldBoss = 107544
--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
	return {
		212836,--Tail Lash
		212852,--Storm Breath
		212867,--Electrical Storm
		212887,--Static Charge
		212837,--Crackling Jolt
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "StormBreath", 212852)
	self:Log("SPELL_CAST_SUCCESS", "ElectricalStorm", 212867)
	self:Log("SPELL_CAST_SUCCESS", "StaticCharge", 212887)
	self:Log("SPELL_CAST_SUCCESS", "CracklingJolt", 212837)
	self:Log("SPELL_CAST_START", "TailLash", 212836)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil)
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
--Gotta do few more tries on boss for initial timers.
end
--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:StormBreath(args)
	self:TargetMessage(args.spellId, args.destName, "Important", self:Tank() and "Warning")
	self:Message(args.spellId, "Important")
	self:CDBar(args.spellId, 23.7)
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, spellName, _, spellGUID, spellId)
	if spellId == 212837 then -- Crackling Jolt
		self:Message(args.spellId, "Important", "Alarm")
		self:CDBar(args.spellId, 12)
	end
end

function mod:TailLash(args)
	self:Message(args.spellId, "Urgent", "Alert")
end

function mod:ElectricalStorm(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:CDBar(args.spellId, 31.4)
end

function mod:StaticCharge(args)
	self:CDBar(args.spellId, 41)
end

function mod:BOSS_KILL(event, id)
	if id == 1880 then
		self:Win()
	end
end
