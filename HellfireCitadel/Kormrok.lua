
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kormrok", 1026, 1392)
if not mod then return end
mod:RegisterEnableMob(90435)
mod.engageId = 1787
mod.respawnTime = 14

--------------------------------------------------------------------------------
-- Locals
--

local poundCount = 1
local tankDebuffCount = 1
local phase = 0 -- 0:NONE, 1:EXPLOSIVE, 2:FOUL, 3:SHADOW
local explosiveCount, foulCount, shadowCount = 0, 0, 0
local enrageMod = 1

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
		180244, -- Pound
		186882, -- Enrage
		"stages",
		"proximity",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "FelOutpouring", 181292, 181293) -- Normal, Empowered
	self:Log("SPELL_CAST_START", "ExplosiveRunes", 181296, 181297) -- Normal, Empowered
	self:Log("SPELL_CAST_START", "GraspingHands", 181299, 181300) -- Normal, Empowered
	self:Log("SPELL_CAST_START", "Pound", 180244)
	self:Log("SPELL_CAST_SUCCESS", "FoulCrush", 181307)
	self:Log("SPELL_CAST_START", "Swat", 181305)
	self:Log("SPELL_CAST_SUCCESS", "ExplosiveBurst", 181306)
	self:Log("SPELL_AURA_REMOVED", "ExplosiveBurstRemoved", 181306)
	self:Log("SPELL_AURA_APPLIED", "ShadowEnergy", 180115, 186879, 189197) -- Normal, Enraged, Normal(LFR)
	self:Log("SPELL_AURA_APPLIED", "ExplosiveEnergy", 180116, 186880, 189198) -- Normal, Enraged, Normal (LFR)
	self:Log("SPELL_AURA_APPLIED", "FoulEnergy", 180117, 186881, 189199) -- Normal, Enraged, Normal (LFR)
	self:Log("SPELL_AURA_APPLIED", "Enrage", 186882)
end

function mod:OnEngage()
	phase = 0
	explosiveCount, foulCount, shadowCount = 0, 0, 0
	poundCount = 1
	tankDebuffCount = 1
	enrageMod = self:Mythic() and 0.84 or 1
	self:CDBar("stages", 10, 180068) -- Leap
	self:OpenProximity("proximity", 4)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Phases

function mod:ShadowEnergy(args)
	self:SendMessage("BigWigs_StopBars", self)
	shadowCount = self:Normal() and 2 or self:Mythic() and 4 or 3
	phase = 3
	tankDebuffCount = 1
	self:Message("stages", "Neutral", "Info", args.spellName, false)

	if args.spellId == 189197 then -- LFR
		self:Bar(181292, 10) -- Fel Outpouring
		self:Bar(181305, 30) -- Swat
		self:Bar(180244, 40, CL.count:format(self:SpellName(180244), poundCount)) -- Pound
		self:CDBar("stages", 122, 180068) -- Leap
	else
		self:Bar(181292, 13 * enrageMod, 181293) -- Empowered Fel Outpouring
		self:Bar(181305, 37 * enrageMod) -- Swat
		self:CDBar(180244, 45 * enrageMod, CL.count:format(self:SpellName(180244), poundCount)) -- Pound
		self:Bar(181296, 63 * enrageMod, explosiveCount > 0 and 181297) -- [Empowered] Explosive Runes
		self:Bar(181299, 83 * enrageMod, foulCount > 0 and 181300)-- Grasping Hands / Dragging Hands
		self:CDBar("stages", 145 * enrageMod, 180068) -- Leap
	end
end

function mod:ExplosiveEnergy(args)
	self:SendMessage("BigWigs_StopBars", self)
	explosiveCount = self:Normal() and 2 or self:Mythic() and 4 or 3
	phase = 1
	tankDebuffCount = 1
	self:Message("stages", "Neutral", "Info", args.spellName, false)

	if args.spellId == 189198 then -- LFR
		self:Bar(181296, 10) -- Explosive Runes
		self:Bar(181306, 20) -- Explosive Burst
		self:Bar(180244, 30, CL.count:format(self:SpellName(180244), poundCount)) -- Pound
		self:CDBar("stages", 92, 180068) -- Leap
	else
		self:Bar(181296, 13 * enrageMod, 181297) -- Empowered Explosive Runes
		self:Bar(181306, 25 * enrageMod) -- Explosive Burst
		self:CDBar(180244, 33 * enrageMod, CL.count:format(self:SpellName(180244), poundCount)) -- Pound
		self:Bar(181299, 51 * enrageMod, foulCount > 0 and 181300) -- Grasping Hands / Dragging Hands
		self:Bar(181292, 71 * enrageMod, shadowCount > 0 and 181293) -- [Empowered] Fel Outpouring
		self:CDBar("stages", 133 * enrageMod, 180068) -- Leap
	end
end

function mod:FoulEnergy(args)
	self:SendMessage("BigWigs_StopBars", self)
	foulCount = self:Normal() and 2 or self:Mythic() and 4 or 3
	phase = 2
	tankDebuffCount = 1
	self:Message("stages", "Neutral", "Info", args.spellName, false)

	if args.spellId == 189199 then -- LFR
		self:Bar(181299, 10) -- Grasping Hands
		self:Bar(181307, 20) -- Foul Crush
		self:Bar(180244, 30, CL.count:format(self:SpellName(180244), poundCount)) -- Pound
		self:CDBar("stages", 92, 180068) -- Leap
	else
		self:Bar(181299, 13 * enrageMod, 181300) -- Dragging Hands
		self:Bar(181307, 25 * enrageMod) -- Foul Crush
		self:CDBar(180244, 33 * enrageMod, CL.count:format(self:SpellName(180244), poundCount)) -- Pound
		self:Bar(181292, 51 * enrageMod, shadowCount > 0 and 181293) -- [Empowered] Fel Outpouring
		self:Bar(181296, 83 * enrageMod, explosiveCount > 0 and 181297) -- [Empowered] Explosive Runes
		self:CDBar("stages", 133 * enrageMod, 180068) -- Leap
	end
end

-- Tank Debuffs

function mod:ExplosiveBurst(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, true)
	self:TargetBar(args.spellId, 10, args.destName)
	tankDebuffCount = tankDebuffCount + 1
	if self:LFR() then
		if tankDebuffCount == 2 then -- Only time for 1 more in LFR
			self:Bar(args.spellId, 50)
		end
	elseif tankDebuffCount < 4 then
		self:Bar(args.spellId, tankDebuffCount == 2 and (38 * enrageMod) or (50 * enrageMod))
	end
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
	self:OpenProximity("proximity", 4)
end

function mod:FoulCrush(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", self:Tank() and "Warning")
	tankDebuffCount = tankDebuffCount + 1
	if self:LFR() then
		if tankDebuffCount == 2 then -- Only time for 1 more in LFR
			self:Bar(args.spellId, 50)
		end
	elseif tankDebuffCount < 4 then
		self:Bar(args.spellId, tankDebuffCount == 2 and (50 * enrageMod) or (38 * enrageMod))
	end
end

function mod:Swat(args)
	self:Message(args.spellId, "Attention", self:Tank() and "Warning", args.spellName)
	tankDebuffCount = tankDebuffCount + 1
	if self:LFR() then
		if tankDebuffCount == 2 then -- Only time for 1 more in LFR
			self:Bar(args.spellId, 60)
		end
	elseif tankDebuffCount < 4 then
		self:Bar(args.spellId, 38 * enrageMod)
	end
end

-- Phase Abilities

function mod:FelOutpouring(args)
	shadowCount = shadowCount - 1
	self:Message(181292, "Attention", "Long", args.spellId)
	if self:LFR() then
		if shadowCount > 0 then
			self:CDBar(args.spellId, 45) -- No Empowered on LFR
		end
	else
		self:CDBar(181292, 108 * enrageMod, shadowCount > 0 and 181293) -- [Empowered] Fel Outpouring
	end
end

function mod:ExplosiveRunes(args)
	explosiveCount = explosiveCount - 1
	self:Message(181296, "Urgent", "Info", args.spellId)
	if self:LFR() then
		if explosiveCount > 0 then
			self:CDBar(args.spellId, 35) -- No Empowered on LFR
		end
	else
		self:CDBar(181296, 108 * enrageMod, explosiveCount > 0 and 181297) -- [Empowered] Explosive Runes
	end
end

function mod:GraspingHands(args)
	foulCount = foulCount - 1
	self:Message(181299, "Important", nil, args.spellId)
	if self:LFR() then
		if foulCount > 0 then
			self:CDBar(args.spellId, 35) -- No Empowered (Dragging) on LFR
		end
	else
		self:CDBar(181299, 108 * enrageMod, foulCount > 0 and 181300) -- Grasping Hands / Dragging Hands
	end
end

function mod:Pound(args)
	self:Message(args.spellId, "Urgent", "Alert", CL.count:format(args.spellName, poundCount))
	poundCount = poundCount + 1
	if self:LFR() then
		if poundCount % 2 == 0 then -- Only 2 per phase
			self:CDBar(args.spellId, phase == 3 and 35 or 25, CL.count:format(args.spellName, poundCount))
		end
	else
		self:CDBar(args.spellId, phase == 3 and (50 * enrageMod) or (62 * enrageMod), CL.count:format(args.spellName, poundCount)) -- start->start = 50 / 42 enraged for shadow, 62 / 52 enraged for other
	end
end

function mod:Enrage(args)
	enrageMod = self:Mythic() and 0.62 or 0.84 -- 0.62 is not 100% accurate - if it's too inaccurate, we have to do separate mythic times
	self:Message(args.spellId, "Important", "Alarm")
end

