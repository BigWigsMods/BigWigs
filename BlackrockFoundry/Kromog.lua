
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kromog", 988, 1162)
if not mod then return end
mod:RegisterEnableMob(77692)
mod.engageId = 1713

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
		173917, -9706,
		{156766, "TANK"}, {156852, "HEALER"}, 156704, 157592, -9702, 157060, 157054, 156861, "berserk", "bosskill"
	}, {
		[173917] = "mythic",
		[156766] = "general"
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_AURA_APPLIED", "WarpedArmor", 156766)
	self:Log("SPELL_AURA_APPLIED_DOSE", "WarpedArmor", 156766)
	self:Log("SPELL_CAST_SUCCESS", "StoneBreath", 156852)
	self:Log("SPELL_CAST_START", "Slam", 156704)
	self:Log("SPELL_CAST_START", "RipplingSmash", 157592)
	self:Log("SPELL_CAST_START", "GraspingEarth", 157060)
	self:Log("SPELL_CAST_START", "ThunderingBlows", 157054)
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 156861)
	-- Mythic
	self:Log("SPELL_CAST_SUCCESS", "TremblingEarth", 173917)
	self:Log("SPELL_CAST_START", "CallOfTheMountain", 158217)
end

function mod:OnEngage()
	-- XXX all of the timers for this module are probably shit, need more logs
	self:CDBar(156852, 9) -- Stone Breath
	self:CDBar(156766, 16) -- Warped Armor
	self:CDBar(156704, 22) -- Slam
	self:CDBar(157592, 30) -- Rippling Smash
	self:CDBar(157060, 50) -- Grasping Earth
	if self:Mythic() then
		self:CDBar(173917, 81) -- Trembling Earth
	end
	self:Berserk(600)
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Mythic

function mod:TremblingEarth(args)
	self:Message(args.spellId, "Attention")
	self:Bar(-9706, 26) -- Call of the Mountain
	self:CDBar(156852, 61) -- Stone Breath
	self:CDBar(157592, 72) -- Rippling Smash
end

function mod:CallOfTheMountain(args)
	self:Message(-9706, "Important")
end

-- General

function mod:UNIT_HEALTH_FREQUENT(unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < 35 then
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1")
		self:Message(156861, "Neutral", "Info", CL.soon:format(self:SpellName(156861))) -- Frenzy
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 156980 then -- Rune of Crushing Earth
		self:Message(-9702, "Attention")
		--self:Bar(spellId, 5, "Clap!")
	end
end

function mod:WarpedArmor(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 2 and "Warning")
	self:CDBar(args.spellId, 14)
end

function mod:StoneBreath(args)
	self:Message(args.spellId, "Urgent")
	self:CDBar(args.spellId, 26)
end

function mod:Slam(args)
	self:Message(args.spellId, "Urgent", self:Damager() == "MELEE" and "Alarm", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 24)
end

function mod:RipplingSmash(args)
	self:Message(args.spellId, "Urgent", "Alert")
	self:CDBar(args.spellId, self:Mythic() and 41 or 22)
	-- XXX second cast is always skipped in mythic, it comes off cd during a stone breath->pillars->call combo
	-- next cast happens 72-88s after pillars, so what happened to the third cast? sigh.
end

function mod:GraspingEarth(args)
	self:Message(args.spellId, "Positive", "Info")
	self:CDBar(args.spellId, 114)
	self:CDBar(157054, 13) -- Thundering Blows

	self:StopBar(156766) -- Warped Armor
	self:StopBar(156704) -- Slam
	self:StopBar(157592) -- Rippling Smash

	self:CDBar(156852, 26) -- Stone Breath
end

function mod:ThunderingBlows(args)
	self:Message(args.spellId, "Important", nil, CL.casting:format(args.spellName))
	self:Bar(args.spellId, 7, CL.cast:format(args.spellName))

end

function mod:Frenzy(args)
	self:Message(args.spellId, "Important", "Alarm")
end

