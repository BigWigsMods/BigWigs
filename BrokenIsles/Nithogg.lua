
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Nithogg", -634, 1749)
if not mod then return end
mod:RegisterEnableMob(107023)
mod.otherMenu = -619
mod.worldBoss = 107023

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-13327, -- Crackling Jolt
		212836, -- Tail Lash
		212867, -- Electrical Storm
		212852, -- Storm Breath
		{212887, "SAY"}, -- Static Charge
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "StormBreath", 212852)
	self:Log("SPELL_CAST_SUCCESS", "ElectricalStorm", 212867)
	self:Log("SPELL_CAST_SUCCESS", "StaticCharge", 212887)
	self:Log("SPELL_AURA_APPLIED", "StaticChargeApplied", 212887)
	self:Log("SPELL_CAST_START", "TailLash", 212836)

	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
	self:CheckForWipe()
	self:CDBar(212852, 10) -- Storm Breath
	self:CDBar(212867, 16) -- Electrical Storm
	self:CDBar(212887, 19) -- Static Charge
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:StormBreath(args)
	self:Message(args.spellId, "Urgent", self:Tank() and "Warning")
	self:CDBar(args.spellId, 23.7)
end

do
	local prev = nil
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, castGUID, spellId)
		if spellId == 212837 and castGUID ~= prev then -- Crackling Jolt
			prev = castGUID
			self:Message(-13327, "Important", "Alarm")
			self:CDBar(-13327, 11)
		end
	end
end

function mod:TailLash(args)
	self:Message(args.spellId, "Attention", self:Melee() and "Alert")
end

function mod:ElectricalStorm(args)
	self:Message(args.spellId, "Important", "Info")
	self:CDBar(args.spellId, 30)
end

function mod:StaticCharge(args)
	self:CDBar(args.spellId, 39)
end

function mod:StaticChargeApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Positive", "Warning")
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
end

function mod:BOSS_KILL(_, id)
	if id == 1880 then
		self:Win()
	end
end

