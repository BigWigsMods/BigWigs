-- Notes --
-- Bother with Fel Touch?

--------------------------------------------------------------------------------
-- Module Declaration
--

if GetBuildInfo() ~= "6.2.0" then return end

local mod, CL = BigWigs:NewBoss("Kormrok", 1026, 1392)
if not mod then return end
mod:RegisterEnableMob(90435)
mod.engageId = 1787

--------------------------------------------------------------------------------
-- Locals
--

local poundCount = 0
local tankDebuffCount = 1
local empCounts = {
	["explosive"] = 0,
	["foul"] = 0,
	["shadow"] = 0,
	["isFirst"] = true, -- is it first 'special' cast?
	["current"] = 0, -- 0:NONE, 1:EXPLOSIVE, 2:FOUL, 3:SHADOW
	["hiddenPound"] = 1, 
}
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
		181296, -- Explosive Runes
		181299, -- Grasping Hands
		{180244, "PROXIMITY"}, -- Pound
		181305, -- Swat
		181306, -- Explosive Burst
		181307, -- Foul Crush
		180115, -- Shadow Energy
		180116, -- Explosive Energy
		180117, -- Foul Energy
		186882, -- Enrage
		"stages",
		"berserk",
	}
end

function mod:OnBossEnable()

	self:Log("SPELL_CAST_SUCCESS", "FelOutpouring", 181292, 181293) -- Normal, Empowered - HAS TO BE _SUCCESS FOR MYTHIC MODULE
	self:Log("SPELL_CAST_START", "ExplosiveRunes", 181296, 181297) -- Normal, Empowered - HAS TO BE _START FOR MYTHIC MODULE
	self:Log("SPELL_CAST_SUCCESS", "GraspingHands", 181299, 181300) -- Normal, Empowered - HAS TO BE _SUCCESS FOR MYTHIC MODULE
	self:Log("SPELL_CAST_SUCCESS", "Pound", 180244)
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
	self:Message("berserk", "Neutral", nil, "Kormrok (beta) engaged", false)
	poundCount = 0
	tankDebuffCount = 1
	empCounts = {
		["explosive"] = 0,
		["foul"] = 0,
		["shadow"] = 0,
		["isFirst"] = true, -- is it first 'special' cast?
		["current"] = 0, -- 0:NONE, 1:EXPLOSIVE, 2:FOUL, 3:SHADOW
		["hiddenPound"] = 1, 
	}
	self:CDBar("stages", 12.5, self:SpellName(105543), "inv_misc_cauldron_arcane")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ShadowEnergy(args)
	-- Cancel old timers and change/reset locals
	self:SendMessage("BigWigs_StopBars", self)
	empCounts.shadow = 4
	if not self:Mythic() then -- easier to do a mythic test here instead in the bars
		empCounts.foul = 0
		empCounts.explosive = 0
	end
	empCounts.current = 3
	empCounts.isFirst = true
	empCounts.hiddenPound = 1
	tankDebuffCount = 1
	-- Start new timers
	self:Message("stages", "Positive", "Info", args.spellName, false)
	self:Bar(181292, 14, self:SpellName(181293)) -- [Empowered] Fel Outpouring
	self:Bar(181305, 31) -- Swat
	self:Bar(180244, 41) -- Pound
	self:Bar(181296, 55, empCounts.explosive > 0 and self:SpellName(181297) or nil) -- [Empowered] Explosive Runes
	self:Bar(181299, 71, empCounts.foul > 0 and self:SpellName(181300) or nil)-- Grasping Hands / Draggind Hands
	self:CDBar("stages", 124, self:SpellName(105543), "inv_misc_cauldron_arcane")
end

function mod:ExplosiveEnergy(args)
	-- Cancel old timers and change/reset locals
	self:SendMessage("BigWigs_StopBars", self)
	empCounts.explosive = 4
	if not self:Mythic() then -- easier to do a mythic test here instead in the bars
		empCounts.shadow = 0
		empCounts.foul = 0
	end
	empCounts.current = 1
	tankDebuffCount = 1
	empCounts.isFirst = true
	empCounts.hiddenPound = 1
	-- Start new timers
	self:Message("stages", "Positive", "Info", args.spellName, false)
	self:Bar(181296, 13, self:SpellName(181297)) -- [Empowered] Explosive Runes
	self:Bar(181306, 21) -- Explosive Burst
	self:Bar(180244, 31) -- Pound
	self:Bar(181299, 43, empCounts.foul > 0 and self:SpellName(181299) or nil)-- Grasping Hands / Draggind Hands
	self:Bar(181292, 62, empCounts.shadow > 0 and self:SpellName(181293) or nil) -- [Empowered] Fel Outpouring
	self:CDBar("stages", 114, self:SpellName(105543), "inv_misc_cauldron_arcane")
end

function mod:FoulEnergy(args)
	-- Cancel old timers and change/reset locals
	self:SendMessage("BigWigs_StopBars", self)
	empCounts.foul = 4
	if not self:Mythic() then -- easier to do a mythic test here instead in the bars
		empCounts.explosive = 0
		empCounts.shadow = 0
	end
	empCounts.current = 2
	empCounts.isFirst = true
	empCounts.hiddenPound = 1
	tankDebuffCount = 1
	-- Start new timers
	self:Message("stages", "Positive", "Info", args.spellName, false)
	self:Bar(181299, 13, self:SpellName(181300))-- Grasping Hands / Draggind Hands
	self:Bar(181307, 21) -- Foul Crush
	self:Bar(180244, 31) -- Pound
	self:Bar(181292, 46, empCounts.shadow > 0 and self:SpellName(181293) or nil) -- [Empowered] Fel Outpouring
	self:Bar(181296, 69, empCounts.explosive > 0 and self:SpellName(181297) or nil) -- [Empowered] Explosive Runes
	self:CDBar("stages", 114, self:SpellName(105543), "inv_misc_cauldron_arcane")
end

function mod:ExplosiveBurst(args)
	tankDebuffCount = tankDebuffCount + 1
	if tankDebuffCount == 2 then
		self:Bar(args.spellId, 32)
	elseif tankDebuffCount == 3 then
		self:Bar(args.spellId, 42)
	else -- phase will change before next cast
		self:CDBar(args.spellId, 40, self:SpellName(156260), "inv_shield_17") -- Tank Boom XXX mayby change it? i love it tho.
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
		self:CDBar(args.spellId, 40, self:SpellName(156260), "inv_shield_17") -- Tank Boom XXX mayby change it? i love it tho.
	end
	self:Message(args.spellId, "Urgent", self:Tank() and "Warning", "Foul Crush on tank!") -- XXX
end

function mod:Swat(args)
	tankDebuffCount = tankDebuffCount + 1
	if tankDebuffCount <= 3 then
		self:Bar(args.spellId, 32)
	else -- phase will change before next cast
		self:CDBar(args.spellId, 50, self:SpellName(156260), "inv_shield_17") -- Tank Boom XXX mayby change it? i love it tho.
	end
	self:Message(args.spellId, "Attention", nil, args.spellName)
end

function mod:FelOutpouring(args)
	if empCounts.isFirst then
		empCounts.isFirst = false
		self:Bar(181292, 90, self:SpellName(181293)) -- Empowered Fel Outpouring
		self:Message(181292, "Attention", "Long", self:SpellName(181293))
	else
		self:CDBar(181292, empCounts.current == 2 and 82 or 66 ,empCounts.shadow > 0 and self:SpellName(181293) or nil) -- [Empowered] Fel Outpouring
		self:Message(181292, "Attention", "Long", self:SpellName(args.spellId))
	end
end

function mod:ExplosiveRunes(args)
	if empCounts.isFirst then
		empCounts.isFirst = false
		self:Bar(181296, 90, self:SpellName(181297)) -- [Empowered] Explosive Runes
	else
		self:CDBar(181296, (empCounts.current == 1 and 121) or (empCounts.current == 3 and 70) or 56, empCounts.explosive > 1 and self:SpellName(181297) or nil) -- [Empowered] Explosive Runes
	end
	self:Message(181296, "Important", "Info", CL.incoming:format(args.spellName))
end

function mod:GraspingHands(args)
	if empCounts.isFirst then
		empCounts.isFirst = false
		self:Bar(181299, 90, self:SpellName(181300))-- Draggind Hands
	else 
		self:CDBar(181299, (empCounts.current == 3 and 65) or (empCounts.current == 1 and 82) or 54, empCounts.foul > 0 and self:SpellName(181300) or nil) -- Grasping Hands / Draggind Hands
	end
	self:Message(181299, "Important", "Info", CL.incoming:format(args.spellName))
end

function mod:Pound(args)
	empCounts.hiddenPound = empCounts.hiddenPound + 1
	if empCounts.hiddenPound == 2 then -- i don't want to use poundCount % 2 == 0, becouse if for some reason boss decides to skip a pound, then it would mess up everything, empCounts.hiddenPound is reseted in every phase
		self:Bar(args.spellId, empCounts.current == 3 and 42 or 52)
	else
		self:CDBar(args.spellId, empCounts.current == 3 and 40 or 62)
	end
	poundCount = poundCount + 1
	self:Message(args.spellId, "Urgent", "Alert", CL.count:format(args.spellName, poundCount))
	self:Bar(args.spellId, 5, CL.count:format(args.spellName, poundCount))
end

function mod:PoundStart(args)
	self:Bar(args.spellId, 4, CL.casting:format(args.spellName, poundCount))
	self:Message(args.spellId, "Urgent", "Alert", CL.casting:format(args.spellName, poundCount))
	self:OpenProximity(args.spellId, 5) -- 4 + 1 safety
end

function mod:PoundOver(args)
	self:CloseProximity(args.spellId)
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

function mod:Enrage(args)
	self:Message(args.spellId, "Positive")
end
