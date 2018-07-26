
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Levantus", -630, 1769)
if not mod then return end
mod:RegisterEnableMob(108829)
mod.otherMenu = -619
mod.worldBoss = 108829

--------------------------------------------------------------------------------
-- Locals
--

local whirlCount = 0

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		217249, -- Massive Spout
		217344, -- Electrify
		217235, -- Rending Whirl
		217206, -- Gust of Wind
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "MassiveSpout", 217249)
	self:Log("SPELL_CAST_START", "Electrify", 217344)
	self:Log("SPELL_CAST_START", "RendingWhirl", 217235)
	self:Log("SPELL_AURA_APPLIED", "GustOfWind", 217206)
	self:Log("SPELL_AURA_REMOVED", "GustOfWindRemoved", 217206)

	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
	self:CheckForWipe()
	whirlCount = 0
	self:CDBar(217235, 15) -- Rending Whirl
	self:CDBar(217249, 30) -- Massive Spout
	self:CDBar(217344, 54) -- Electrify
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MassiveSpout(args)
	self:Message(args.spellId, "yellow", "Long", CL.incoming:format(args.spellName))
	self:CDBar(args.spellId, 66.5)
end

function mod:Electrify(args)
	self:Message(args.spellId, "green", "Alert", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 33)
end

do
	local timers = {47, 67, 66, 66, 58}
	function mod:RendingWhirl(args)
		whirlCount = whirlCount + 1
		self:Message(args.spellId, "orange", self:Melee() and "Warning", CL.incoming:format(args.spellName))
		-- This timer has the potential to go way wrong if you release or miss engage but still better than a static timer
		self:CDBar(args.spellId, timers[whirlCount] or 66)
	end
end

function mod:GustOfWind(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "blue")
		self:TargetBar(args.spellId, 45, args.destName)
	end
end

function mod:GustOfWindRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "blue", "Alarm", CL.removed:format(args.spellName))
		self:StopBar(args.spellName, args.destName)
	end
end

function mod:BOSS_KILL(_, id)
	if id == 1953 then
		whirlCount = 0
		self:Win()
	end
end
