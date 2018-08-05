
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Shar'thos", -641, 1763)
if not mod then return end
mod:RegisterEnableMob(108678)
mod.otherMenu = -619
mod.worldBoss = 108678

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		216044, -- Cry of the Tormented
		215876, -- Burning Earth
		216043, -- Dread Flame
		215821, -- Nightmare Breath
		215806, -- Tail Lash
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "CryOfTheTormented", 216044)
	self:Log("SPELL_CAST_SUCCESS", "DreadFlame", 216043)
	self:Log("SPELL_CAST_SUCCESS", "NightmareBreath", 215821)

	self:Log("SPELL_AURA_APPLIED", "BurningEarthDamage", 215876)
	self:Log("SPELL_PERIODIC_DAMAGE", "BurningEarthDamage", 215876)
	self:Log("SPELL_PERIODIC_MISSED", "BurningEarthDamage", 215876)

	self:Log("SPELL_DAMAGE", "TailLash", 215806)

	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
	self:CheckForWipe()
	self:CDBar(216043, 11) -- Dread Flame
	self:CDBar(215821, 16) -- Nightmare Breath
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CryOfTheTormented(args)
	self:Message(args.spellId, "orange", "Warning", CL.casting:format(args.spellName))
end

function mod:DreadFlame(args)
	self:TargetMessage(args.spellId, args.destName, "yellow", "Alarm")
	self:CDBar(args.spellId, 16)
end

function mod:NightmareBreath(args)
	self:Message(args.spellId, "red", "Info")
	self:CDBar(args.spellId, 19)
end

do
	local prev = 0
	function mod:BurningEarthDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 3 then
			prev = t
			self:Message(args.spellId, "blue", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

function mod:TailLash(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "blue", "Alert", CL.you:format(args.spellName))
	end
end

function mod:BOSS_KILL(_, id)
	if id == 1888 then
		self:Win()
	end
end
