
--------------------------------------------------------------------------------
-- Module Declaration
--

if not BigWigs.isWOD then return end -- XXX compat
local mod, CL = BigWigs:NewBoss("Tarlna the Ageless", 949, 1211)
if not mod then return end
mod:RegisterEnableMob(81535)
mod.otherMenu = 962
mod.worldBoss = 81535

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		175973, 175979, 176013, {176004, "PROXIMITY"}, "bosskill"
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Log("SPELL_CAST_START", "ColossalBlow", 175973)
	self:Log("SPELL_CAST_START", "Genesis", 175979)
	self:Log("SPELL_CAST_SUCCESS", "GrowMandragora", 176013)
	self:Log("SPELL_AURA_APPLIED", "SavageVines", 176004)

	self:Death("Win", 81535)
end

function mod:OnEngage()

end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ColossalBlow(args)
	self:Message(args.spellId, "Urgent", "Alarm")
end

function mod:Genesis(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 6, CL.cast:format(args.spellName))
end

function mod:GrowMandragora(args)
	self:Message(args.spellId, "Urgent")
end

do
	local vineList, vineTargets, isOnMe, scheduled = mod:NewTargetList(), {}, nil, nil
	local function warnVines(spellId)
		mod:TargetMessage(spellId, vineList, "Urgent", mod:Dispeller("magic") and "Alert", nil, nil, true)
		if not isOnMe then
			mod:OpenProximity(spellId, 8, vineTargets)
			mod:ScheduleTimer("CloseProximity", 8, spellId)
		end
		isOnMe = nil
		scheduled = nil
	end
	function mod:SavageVines(args)
		vineList[#vineList+1] = args.destName
		vineTargets[#vineTargets+1] = args.destName
		if self:Me(args.destGUID) then
			isOnMe = true
		end
		if not scheduled then
			self:Bar(args.spellId, 8)
			scheduled = self:ScheduleTimer(warnVines, 0.3, args.spellId)
		end
	end
end

