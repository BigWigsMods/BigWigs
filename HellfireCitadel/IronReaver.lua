
-- Notes --
-- Falling Slam target scan?
-- Will Blitz have a cast (target scan)?

--------------------------------------------------------------------------------
-- Module Declaration
--

if not IsTestBuild() then return end

local mod, CL = BigWigs:NewBoss("Iron Reaver", 1026, 1425)
if not mod then return end
mod:RegisterEnableMob(90284)
mod.engageId = 1785

--------------------------------------------------------------------------------
-- Locals
--



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
		{182280, "ICON", "PROXIMITY", "FLASH", "SAY"}, -- Artillery
		182020, -- Pounding
		185282, -- Barrage
		182001, -- Unstable Orb
		182074, -- Immolation
		182066, -- Falling Slam
		182534, -- Volatile Firebomb
		186667, -- Burning Firebomb
		186676, -- Reactive Firebomb
		186652, -- Quick-Fuse Firebomb
		"proximity",
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Artillery", 182280)
	self:Log("SPELL_AURA_REMOVED", "ArtilleryRemoved", 182280)
	self:Log("SPELL_AURA_APPLIED", "Pounding", 182020)
	self:Log("SPELL_CAST_START", "Barrage", 185282)
	self:Log("SPELL_CAST_SUCCESS", "UnstableOrb", 182001)
	self:Log("SPELL_CAST_START", "FallingSlam", 182066)

	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED") -- Firebombs are hidden casts, will they be on the boss frames is the question. One would hope so.

	self:Log("SPELL_AURA_APPLIED", "UnstableOrbDamage", 182001)
	self:Log("SPELL_AURA_APPLIED_DOSE", "UnstableOrbDamage", 182001)
	self:Log("SPELL_AURA_APPLIED", "ImmolationDamage", 182074)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ImmolationDamage", 182074)
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Iron Reaver (Beta) Engaged", false)
	if self:Healer() or self:Damager() == "RANGED" then
		self:OpenProximity("proximity", 8)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Artillery(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	self:TargetBar(args.spellId, 13, args.destName)
	self:PrimaryIcon(args.spellId, args.destName)
	self:OpenProximity(args.spellId, 20)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
	end
end

function mod:ArtilleryRemoved(args)
	self:PrimaryIcon(args.spellId)
	self:StopBar(args.spellName, args.destName)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
		if self:Healer() or self:Damager() == "RANGED" then
			self:OpenProximity("proximity", 8)
		end
	end
end

function mod:Pounding(args)
	self:Message(args.spellId, "Attention", "Long", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 6)
end

function mod:Barrage(args)
	self:Message(args.spellId, "Attention", "Long", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 4)
end

do
	local prev = 0
	function mod:UnstableOrb(args)
		local t = GetTime()
		if t-prev > 5 then
			prev = t
			self:Message(args.spellId, "Important")
			self:Bar(args.spellId, 15)
		end
	end
end

do
	local prev1, prev2, prev3, prev4 = 0, 0, 0, 0
	function mod:UNIT_SPELLCAST_SUCCEEDED(event, unit, spellName, _, _, spellId)
		if spellName == "Volatile Firebomb" or spellId == 182534 then
			local t = GetTime()
			if t-prev1 > 5 then
				prev1 = t
				self:Message(182534, "Important", "Alarm", "Volatile Firebomb exlodes in 45sec")
				self:Bar(182534, 45, "Volatile Firebomb EXPLODES")
			end
		elseif spellName == "Burning Firebomb" or spellId == 186667 then
			local t = GetTime()
			if t-prev2 > 5 then
				prev2 = t
				self:Message(186667, "Important", "Alarm", "Burning Firebomb exlodes in 40sec")
				self:Bar(186667, 40, "Burning Firebomb EXPLODES")
			end
		elseif spellName == "Reactive Firebomb" or spellId == 186676 then
			local t = GetTime()
			if t-prev3 > 5 then
				prev3 = t
				self:Message(186667, "Important", "Alarm", "Reactive Firebomb - Tank jump on it")
				self:Bar(186667, 30, "Reactive Firebomb EXPLODES")
			end
		elseif spellName == "Quick-Fuse Firebomb" or spellId == 186652 then
			local t = GetTime()
			if t-prev4 > 5 then
				prev4 = t
				self:Message(186652, "Important", "Alarm", "Quick-Fuse Firebomb explodes in 20sec")
				self:Bar(186652, 20, "Quick-Fuse Firebomb EXPLODES")
			end
		end
	end
end

do
	local prev = 0
	function mod:UnstableOrbDamage(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
		end
	end
end

do
	local prev = 0
	function mod:ImmolationDamage(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

do
	local prev = 0
	function mod:FallingSlam(args)
		local t = GetTime()
		if t-prev > 5 then
			prev = t
			self:Message(args.spellId, "Important")
			self:Bar(args.spellId, 6)
		end
	end
end

