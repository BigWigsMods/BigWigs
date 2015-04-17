
-- Notes --
-- Falling Slam target scan?
-- Immolation under you?
-- Will Blitz have a cast (target scan)?

--------------------------------------------------------------------------------
-- Module Declaration
--

if not IsTestBuild() then return end

local mod, CL = BigWigs:NewBoss("Iron Reaver", 1026, 1425)
if not mod then return end
mod:RegisterEnableMob(90284)
--mod.engageId = 1000000

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
		{182108, "ICON", "PROXIMITY", "FLASH", "SAY"}, -- Artillery
		182022, -- Pounding
		182001, -- Unstable Orb
		182362, -- Falling Slam
		182534, -- Volatile Firebomb
		186667, -- Burning Firebomb
		186676, -- Reactive Firebomb
		186652, -- Quick-Fuse Firebomb
		"berserk",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_APPLIED", "Artillery", 182108)
	self:Log("SPELL_AURA_REMOVED", "ArtilleryRemoved", 182108)
	self:Log("SPELL_CAST_START", "Pounding", 182022)
	self:Log("SPELL_CAST_SUCCESS", "UnstableOrb", 182001)
	self:Log("SPELL_CAST_SUCCESS", "FallingSlam", 182362)

	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED") -- Firebombs are hidden casts, will they be on the boss frames is the question. One would hope so.

	self:Log("SPELL_AURA_APPLIED", "UnstableOrbDamage", 182001)
	self:Log("SPELL_PERIODIC_DAMAGE", "UnstableOrbDamage", 182001)
	self:Log("SPELL_PERIODIC_MISSED", "UnstableOrbDamage", 182001)

	self:Death("Win", 90284)
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Iron Reaver (Beta) Engaged")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Artillery(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	self:PrimaryIcon(args.spellId, args.destName)
	self:OpenProximity(args.spellId, 20)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
	end
end

function mod:ArtilleryRemoved(args)
	self:PrimaryIcon(args.spellId)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

function mod:Pounding(args)
	self:Message(args.spellId, "Attention", "Long", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 6)
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
	local prev = 0
	function mod:UNIT_SPELLCAST_SUCCEEDED(event, unit, spellName, _, _, spellId)
		if spellName == "Volatile Firebomb" or spellId == 182534 then
			local t = GetTime()
			if t-prev > 5 then
				prev = t
				self:Message(182534, "Important", "Alarm", "Volatile Firebomb exlodes in 45sec")
				self:Bar(182534, 45, "Volatile Firebomb EXPLODES")
			end
		elseif spellName == "Burning Firebomb" or spellId == 186667 then
			local t = GetTime()
			if t-prev > 5 then
				prev = t
				self:Message(186667, "Important", "Alarm", "Burning Firebomb exlodes in 40sec")
				self:Bar(186667, 40, "Burning Firebomb EXPLODES")
			end
		elseif spellName == "Reactive Firebomb" or spellId == 186676 then
			local t = GetTime()
			if t-prev > 5 then
				prev = t
				self:Message(186667, "Important", "Alarm", "Reactive Firebomb - Tank jump on it")
				self:Bar(186667, 30, "Reactive Firebomb EXPLODES")
			end
		elseif spellName == "Quick-Fuse Firebomb" or spellId == 186652 then
			local t = GetTime()
			if t-prev > 5 then
				prev = t
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
	function mod:FallingSlam(args)
		local t = GetTime()
		if t-prev > 5 then
			prev = t
			self:Message(args.spellId, "Important")
		end
	end
end

