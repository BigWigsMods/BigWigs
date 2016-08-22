--------------------------------------------------------------------------------
-- Module Declaration
--
local mod,CL=BigWigs:NewBoss("Nithogg", -1017, 1749);
if not mod then return end

mod:RegisterEnableMob(107544)
--mod.otherMenu = 962
mod.worldBoss = 107544

--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
		return {
			212836,--Tail Lash
			212852,--Storm Breath 23.7 tanks
			212867,--Electrical Storm 31.4
			212887,--Static Charge 41
			212837,--Crackling Jolt -12
		}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "StormBreath", 212852)
	self:Log("SPELL_CAST_SUCCESS", "ElectricalStorm", 212867)
	self:Log("SPELL_CAST_SUCCESS", "StaticCharge", 212887)
	self:Log("SPELL_CAST_SUCCESS", "CracklingJolt", 212837)
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 107544)
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

function mod:TailLash(args) -- XXX -- Cant figure out TailLash CD so 7.8 is an approx timer ,might be totally random or bound to another condition.
	self:Message(args.spellId, "Urgent", "Alert")
	self:CDBar(args.spellId, 7.8)
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
