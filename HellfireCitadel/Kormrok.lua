-- Notes --
-- Bother with Fel Touch?

--------------------------------------------------------------------------------
-- Module Declaration
--

if not IsTestBuild() then return end

local mod, CL = BigWigs:NewBoss("Kormrok", 1026, 1392)
if not mod then return end
mod:RegisterEnableMob(90435)
mod.engageId = 1787

--------------------------------------------------------------------------------
-- Locals
--

local poundCount = 0
local tankDebuffCount = 0
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
		{181306, "PROXIMITY", "FLASH", "SAY"}, -- Explosive Burst
		181292, -- Fel Outpouring
		181293, -- Empowered Fel Outpouring
		181296, -- Explosive Runes
		181297, -- Empowered Explosive Runes
		181299, -- Grasping Hands
		181300, -- Dragging Hands
		{180244, "PROXIMITY"}, -- Pound
		181305, -- Swat
		181345, -- Foul Crush
		180115, -- Shadow Energy
		180116, -- Explosive Energy
		180117, -- Foul Energy
		186882, -- Enrage
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "ExplosiveBurst", 181306)
	self:Log("SPELL_AURA_REMOVED", "ExplosiveBurstRemoved", 181306)
	self:Log("SPELL_CAST_START", "FelOutpouring", 181292, 181293)
	self:Log("SPELL_CAST_START", "ExplosiveRunes", 181296, 181297)
	self:Log("SPELL_CAST_START", "GraspingHands", 181299, 181300)
	self:Log("SPELL_CAST_START", "Pound", 180244)
	self:Log("SPELL_CAST_SUCCESS", "FoulCrushSuccess", 181307)
	self:Log("SPELL_AURA_REMOVED", "PoundOver", 180244)
	self:Log("SPELL_CAST_START", "Swat", 181305, 187165)
	self:Log("SPELL_AURA_APPLIED", "FoulCrush", 181345)
	self:Log("SPELL_AURA_APPLIED", "EnergyBuffs", 180115, 180116, 180117) -- Shadow Energy, Explosive Energy, Foul Energy
	self:Log("SPELL_AURA_APPLIED", "Enrage", 186882)
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Kormrok (beta) engaged", false)
	self:CDBar(180244, 39) -- Pound
	poundCount = 0
	tankDebuffCount = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ExplosiveBurst(args)
	tankDebuffCount = tankDebuffCount + 1
	self:Bar(args.spellId, tankDebuffCount % 2 == 0 and 32 or 42)
	self:TargetBar(args.spellId, 10, args.destName)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, true)
	self:PrimaryIcon(args.spellId, args.destName)
	self:Flash(args.spellId)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:OpenProximity(args.spellId, 40)
	else
		self:OpenProximity(args.spellId, 40, args.destName)
	end
end

function mod:FoulCrushSuccess(args)
	tankDebuffCount = tankDebuffCount + 1
	self:Bar(args.spellId, tankDebuffCount % 2 == 0 and 32 or 42)
	self:Message(args.spellId, "Urgent", self:Tank() and "Warning", "Foul Crush on tank!") -- XXX
end

function mod:ExplosiveBurstRemoved(args)
	self:PrimaryIcon(args.spellId)
	self:CloseProximity(args.spellId)
end

function mod:FelOutpouring(args)
	self:Message(181292, "Attention", "Long")
	self:Bar(181292, 3)
end

function mod:ExplosiveRunes(args)
	self:Message(181296, "Important", "Info", CL.incoming:format(args.spellName))
	self:Bar(181296, 4, CL.cast:format(args.spellName))
	self:Bar(181296, 48)
end

function mod:GraspingHands(args)
	self:Message(181299, "Important", "Info", CL.incoming:format(args.spellName))
end

function mod:Pound(args)
	poundCount = poundCount + 1
	self:Message(args.spellId, "Urgent", "Alert", CL.count:format(args.spellName, poundCount))
	self:CDBar(args.spellId, 40)
	self:Bar(args.spellId, 9, CL.count:format(args.spellName, poundCount))
	self:OpenProximity(args.spellId, 5) -- 4 + 1 safety
end

function mod:PoundOver(args)
	self:CloseProximity(args.spellId)
end

function mod:Swat(args)
	tankDebuffCount = tankDebuffCount + 1
	self:Bar(181305, tankDebuffCount % 2 == 0 and 32 or 42)
	self:Message(181305, "Urgent", self:Tank() and "Warning", "Swat on tank!") -- XXX
end

do
	local list = mod:NewTargetList()
	function mod:FoulCrush(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Attention")
		end
	end
end

function mod:EnergyBuffs(args)
	self:Message(args.spellId, "Positive")
end

function mod:Enrage(args)
	self:Message(args.spellId, "Positive")
end

