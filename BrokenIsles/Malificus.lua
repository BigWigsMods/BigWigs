
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Malificus", -646, 1884)
if not mod then return end
mod:RegisterEnableMob(117303)
mod.otherMenu = -619
mod.worldBoss = 117303

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		233614, -- Pestilence
		233570, -- Incite Panic
		234452, -- Shadow Barrage
		233850, -- Virulent Infection
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")

	self:Log("SPELL_CAST_START", "Pestilence", 233614)
	self:Log("SPELL_CAST_SUCCESS", "IncitePanic", 233570)
	self:Log("SPELL_CAST_START", "ShadowBarrage", 234452)

	self:Log("SPELL_AURA_APPLIED", "VirulentInfectionDamage", 233850)
	self:Log("SPELL_PERIODIC_DAMAGE", "VirulentInfectionDamage", 233850)
	self:Log("SPELL_PERIODIC_MISSED", "VirulentInfectionDamage", 233850)

	self:Death("Win", 117303)
end

function mod:OnEngage()
	self:CheckForWipe()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	--if id == XXX then
	--	self:Win()
	--end
end

function mod:Pestilence(args)
	self:Message(args.spellId, "orange", "Warning", CL.incoming:format(args.spellName))
	self:CDBar(args.spellId, 14)
end

do
	local prev = 0
	function mod:IncitePanic(args)
		local t = GetTime()
		if t-prev > 4 then
			prev = t
			self:Message(args.spellId, "yellow", "Info")
			self:CDBar(args.spellId, 14)
		end
	end
end

function mod:ShadowBarrage(args)
	self:Message(args.spellId, "orange", "Alarm", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 17)
end

do
	local prev = 0
	function mod:VirulentInfectionDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			prev = t
			self:Message(args.spellId, "blue", "Alert", CL.underyou:format(args.spellName))
		end
	end
end
