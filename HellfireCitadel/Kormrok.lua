
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kormrok", 1026, 1392)
if not mod then return end
mod:RegisterEnableMob(90435)
mod.engageId = 1787

--------------------------------------------------------------------------------
-- Locals
--

local poundCount = 0
local tankDebuffCount = 1
local isFirstSpecial = true
local hiddenPound = 1
local phase = 0 -- 0:NONE, 1:EXPLOSIVE, 2:FOUL, 3:SHADOW
local explosiveCount, foulCount, shadowCount = 0, 0, 0

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
		181307, -- Foul Crush
		{181306, "PROXIMITY", "FLASH", "SAY"}, -- Explosive Burst
		{181305, "TANK_HEALER"}, -- Swat
		181299, -- Grasping Hands
		181296, -- Explosive Runes
		181292, -- Fel Outpouring
		{180244, "PROXIMITY"}, -- Pound
		186882, -- Enrage
		"stages",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "FelOutpouring", 181292, 181293) -- Normal, Empowered - HAS TO BE _SUCCESS FOR MYTHIC MODULE
	self:Log("SPELL_CAST_START", "ExplosiveRunes", 181296, 181297) -- Normal, Empowered - HAS TO BE _START FOR MYTHIC MODULE
	self:Log("SPELL_CAST_START", "GraspingHandsStart", 181299, 181300)
	self:Log("SPELL_CAST_SUCCESS", "GraspingHands", 181299, 181300) -- Normal, Empowered - HAS TO BE _SUCCESS FOR MYTHIC MODULE
	self:Log("SPELL_CAST_SUCCESS", "Pound", 180244)
	self:Log("SPELL_CAST_START", "PoundStart", 180244)
	self:Log("SPELL_AURA_REMOVED", "PoundOver", 180244)
	self:Log("SPELL_CAST_SUCCESS", "FoulCrush", 181307)
	self:Log("SPELL_CAST_SUCCESS", "Swat", 181305)
	self:Log("SPELL_CAST_SUCCESS", "ExplosiveBurst", 181306)
	self:Log("SPELL_AURA_REMOVED", "ExplosiveBurstRemoved", 181306)
	self:Log("SPELL_AURA_APPLIED", "ShadowEnergy", 180115)
	self:Log("SPELL_AURA_APPLIED", "ExplosiveEnergy", 180116)
	self:Log("SPELL_AURA_APPLIED", "FoulEnergy", 180117)
	self:Log("SPELL_AURA_APPLIED", "Enrage", 186882)
end

function mod:OnEngage()
	phase = 0
	explosiveCount, foulCount, shadowCount = 0, 0, 0
	poundCount = 0
	tankDebuffCount = 1
	isFirstSpecial = true
	hiddenPound = 1
	self:CDBar("stages", 12.5, 180068) -- Leap
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ShadowEnergy(args)
	self:SendMessage("BigWigs_StopBars", self)
	shadowCount = 4
	phase = 3
	isFirstSpecial = true
	hiddenPound = 1
	tankDebuffCount = 1

	self:Message("stages", "Neutral", "Info", args.spellName, false)
	self:Bar(181292, 14, 181293) -- Empowered Fel Outpouring
	self:Bar(181305, 31) -- Swat
	self:CDBar(180244, 41) -- Pound
	self:Bar(181296, 55, explosiveCount > 0 and 181297) -- [Empowered] Explosive Runes
	self:Bar(181299, 71, foulCount > 0 and 181300)-- Grasping Hands / Dragging Hands
	self:CDBar("stages", 124, 180068) -- Leap
end

function mod:ExplosiveEnergy(args)
	self:SendMessage("BigWigs_StopBars", self)
	explosiveCount = 4
	phase = 1
	isFirstSpecial = true
	hiddenPound = 1
	tankDebuffCount = 1

	self:Message("stages", "Neutral", "Info", args.spellName, false)
	self:Bar(181296, 13, 181297) -- Empowered Explosive Runes
	self:Bar(181306, 21) -- Explosive Burst
	self:CDBar(180244, 31) -- Pound
	self:Bar(181299, 43, foulCount > 0 and 181300) -- Grasping Hands / Dragging Hands
	self:Bar(181292, 62, shadowCount > 0 and 181293) -- [Empowered] Fel Outpouring
	self:CDBar("stages", 114, 180068) -- Leap
end

function mod:FoulEnergy(args)
	self:SendMessage("BigWigs_StopBars", self)
	foulCount = 4
	phase = 2
	isFirstSpecial = true
	hiddenPound = 1
	tankDebuffCount = 1

	self:Message("stages", "Neutral", "Info", args.spellName, false)
	self:Bar(181299, 13, 181300) -- Dragging Hands
	self:Bar(181307, 21) -- Foul Crush
	self:CDBar(180244, 31) -- Pound
	self:Bar(181292, 46, shadowCount > 0 and 181293) -- [Empowered] Fel Outpouring
	self:Bar(181296, 69, explosiveCount > 0 and 181297) -- [Empowered] Explosive Runes
	self:CDBar("stages", 114, 180068) -- Leap
end

function mod:ExplosiveBurst(args)
	tankDebuffCount = tankDebuffCount + 1
	if tankDebuffCount == 2 then
		self:Bar(args.spellId, 32)
	elseif tankDebuffCount == 3 then
		self:Bar(args.spellId, 42)
	else -- phase will change before next cast
		self:CDBar(args.spellId, 40, 156260, "inv_shield_17") -- Tank Boom XXX mayby change it? i love it tho.
	end
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

function mod:ExplosiveBurstRemoved(args)
	self:PrimaryIcon(args.spellId)
	self:CloseProximity(args.spellId)
end

function mod:FoulCrush(args)
	tankDebuffCount = tankDebuffCount + 1
	if tankDebuffCount == 2 then
		self:Bar(args.spellId, 42)
	elseif tankDebuffCount == 3 then
		self:Bar(args.spellId, 32)
	else -- phase will change before next cast
		self:CDBar(args.spellId, 40, 156260, "inv_shield_17") -- Tank Boom XXX mayby change it? i love it tho.
	end
	self:TargetMessage(args.spellId, args.destName, "Urgent", self:Tank() and "Warning")
end

function mod:Swat(args)
	tankDebuffCount = tankDebuffCount + 1
	if tankDebuffCount < 4 then
		self:Bar(args.spellId, 32)
	else -- phase will change before next cast
		self:CDBar(args.spellId, 50, 156260, "inv_shield_17") -- Tank Boom XXX mayby change it? i love it tho.
	end
	self:Message(args.spellId, "Attention", self:Tank() and "Warning", args.spellName)
end

function mod:FelOutpouring(args)
	if isFirstSpecial then
		isFirstSpecial = nil
		self:Bar(181292, 90, 181293) -- Empowered Fel Outpouring
		self:Message(181292, "Attention", "Long", 181293)
	else
		self:CDBar(181292, phase == 2 and 82 or 66, shadowCount > 0 and 181293) -- [Empowered] Fel Outpouring
		self:Message(181292, "Attention", "Long", args.spellId)
	end
end

function mod:ExplosiveRunes(args)
	if isFirstSpecial then
		isFirstSpecial = nil
		self:Bar(181296, 90, 181297) -- [Empowered] Explosive Runes
	else
		self:CDBar(181296, (phase == 1 and 121) or (phase == 3 and 70) or 56, explosiveCount > 1 and 181297) -- [Empowered] Explosive Runes
	end
	self:Message(181296, "Urgent", "Info", CL.incoming:format(args.spellName))
end

function mod:GraspingHandsStart(args)
	self:OpenProximity(181299, 4)
end

function mod:GraspingHands(args)
	if isFirstSpecial then
		isFirstSpecial = nil
		self:Bar(181299, 90, 181300) -- Dragging Hands
	else
		self:CDBar(181299, (phase == 3 and 65) or (phase == 1 and 82) or 54, foulCount > 0 and self:SpellName(181300) or nil) -- Grasping Hands / Dragging Hands
	end
	self:Message(181299, "Important", nil, CL.incoming:format(args.spellName))
	self:ScheduleTimer("CloseProximity", 4, 181299) -- Hands spawn delayed and you still have time to move
end

function mod:Pound(args)
	hiddenPound = hiddenPound + 1
	if hiddenPound == 2 then
			-- i don't want to use poundCount % 2 == 0, becouse if for some reason boss decides to skip a pound, then it would mess up everything
		self:Bar(args.spellId, phase == 3 and 42 or 52)
	else
		self:CDBar(args.spellId, phase == 3 and 40 or 62)
	end
	poundCount = poundCount + 1
	self:Message(args.spellId, "Urgent", "Alert", CL.count:format(args.spellName, poundCount))
	self:Bar(args.spellId, 5, CL.count:format(args.spellName, poundCount))
end

function mod:PoundStart(args)
	self:Bar(args.spellId, 4, CL.cast:format(CL.count:format(args.spellName, poundCount)))
	self:Message(args.spellId, "Urgent", "Alert", CL.casting:format(args.spellName, poundCount))
	self:OpenProximity(args.spellId, 5) -- 4 + 1 safety
end

function mod:PoundOver(args)
	self:CloseProximity(args.spellId)
end

function mod:Enrage(args)
	self:Message(args.spellId, "Important")
end
