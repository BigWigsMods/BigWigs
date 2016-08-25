-- TO DO List 
-- Combat Testing req to see timers work correctly
-- Needs onEngage timers
-- Crackling Jolt has no SPELL_CAST_SUCCESS event on logs used the ID for unit cast succeed but might need a event register
--------------------------------------------------------------------------------
-- Module Declaration
--
local mod,CL = BigWigs:NewBoss("Nithogg", -1017, 1749);
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

function mod:CracklingJolt(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:CDBar(args.spellId, 12)
end

function mod:BOSS_KILL(event, id)
	if id == 1880 then
		self:Win()
	end
end
