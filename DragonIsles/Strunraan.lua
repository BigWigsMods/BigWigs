--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Strunraan, The Sky's Misery", -2023, 2515)
if not mod then return end
mod:RegisterEnableMob(193534) -- Strunraan
mod.otherMenu = -1978
mod.worldBoss = 193534

--------------------------------------------------------------------------------
-- Locals
--

local tempestOnMe = false

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		383496, -- Empowered Storm
		387199, -- Strunraan's Tempest
		{387265, "ME_ONLY_EMPHASIZE"}, -- Overcharge
		387216, -- Shock Water
		385980, -- Thunder Vortex
		389951, -- Arc Expulsion
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)

	self:Log("SPELL_CAST_START", "EmpoweredStorm", 383496)
	self:Log("SPELL_AURA_APPLIED", "StrunraansTempestApplied", 387199)
	self:Log("SPELL_DAMAGE", "OverchargeTriggers", 388980, 385978) -- Storm's Strike, Thunder Vortex
	self:Log("SPELL_ABSORBED", "OverchargeTriggers", 388980, 385978)
	self:Log("SPELL_MISSED", "OverchargeTriggers", 388980, 385978)
	self:Log("SPELL_AURA_APPLIED", "OverchargeTriggers", 390295) -- Arc Expulsion
	self:Log("SPELL_AURA_REMOVED", "StrunraansTempestRemoved", 387199)
	self:Log("SPELL_DAMAGE", "ShockWater", 387216)
	self:Log("SPELL_CAST_START", "ThunderVortex", 385980)
	self:Log("SPELL_CAST_START", "ArcExpulsion", 389951)

	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
	self:CheckForWipe()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 2651 then
		self:Win()
	end
end

function mod:EmpoweredStorm(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	self:CDBar(args.spellId, 50)
end

function mod:StrunraansTempestApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "info")
		self:SimpleTimer(function() -- Delay setting to true as damage event happens after _APPLIED the first time
			tempestOnMe = true
		end, 0.1)
	end
end

function mod:OverchargeTriggers(args)
	if tempestOnMe and self:Me(args.destGUID) then
		self:PersonalMessage(387265)
		self:PlaySound(387265, "warning")
		tempestOnMe = false -- Unset so we don't warn double
	end
end

function mod:StrunraansTempestRemoved(args)
	if self:Me(args.destGUID) then
		tempestOnMe = false
	end
end

do
	local prev = 0
	function mod:ShockWater(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end

function mod:ThunderVortex(args)
	self:Message(args.spellId, "orange", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alarm")
end

function mod:ArcExpulsion(args)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 30)
end
