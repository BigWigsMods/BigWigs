--------------------------------------------------------------------------------
-- TODO:
--
--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Dark Inquisitor Xanesh", 2217, 2377)
if not mod then return end
mod:RegisterEnableMob(156575) -- Dark Inquisitor Xanesh
mod.engageId = 2328
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local ritualCount = 1
local flayCount = 1
local tormentCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		312336, -- Void Ritual
		312406, -- Voidwoken
		313264, -- Dark Ascension
		{311551, "TANK"}, -- Abyssal Strike
		306319, -- Soul Flay
		306208, -- Torment
		305575, -- Ritual Field
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "VoidRitualStart", 312336)
	self:Log("SPELL_AURA_APPLIED", "VoidwokenApplied", 312406)
	self:Log("SPELL_AURA_APPLIED", "DarkAscensionApplied", 313264)
	self:Log("SPELL_CAST_START", "AbyssalStrikeStart", 311551)
	self:Log("SPELL_AURA_APPLIED", "AbyssalStrikeApplied", 311551)
	self:Log("SPELL_AURA_APPLIED_DOSE", "AbyssalStrikeApplied", 311551)
	self:Log("SPELL_CAST_START", "SoulFlayStart", 306319)
	self:Log("SPELL_CAST_START", "SoulFlayAddStart", 306228)
	self:Log("SPELL_AURA_APPLIED", "SoulFlayApplied", 306311)
	self:Log("SPELL_CAST_SUCCESS", "Torment", 306208)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 305575) -- Ritual Field
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 305575)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 305575)
end

function mod:OnEngage()
	ritualCount = 1
	flayCount = 1
	tormentCount = 1

	self:Bar(306319, 12, CL.count:format(self:SpellName(306319), flayCount)) -- Soul Flay (1)
	self:Bar(306208, 20.5, CL.count:format(self:SpellName(306208), tormentCount)) -- Torment (1)
	self:Bar(311551, 30) -- Abyssal Strike
	self:Bar(312336, 51, CL.count:format(self:SpellName(312336), ritualCount)) -- Void Ritual (1)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:VoidRitualStart(args)
	self:Message2(args.spellId, "red",  CL.count:format(args.spellName, ritualCount))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 5, CL.count:format(args.spellName, ritualCount))
	ritualCount = ritualCount + 1
	self:Bar(args.spellId, 80, CL.count:format(args.spellName, ritualCount))
end

do
	local playerList = mod:NewTargetList()
	function mod:VoidwokenApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
		end
		self:TargetsMessage(args.spellId, "cyan", playerList)
	end
end

function mod:DarkAscensionApplied(args)
	self:TargetMessage2(args.spellId, "red", args.destName)
	self:PlaySound(args.spellId, "warning", args.destName)
end

function mod:AbyssalStrikeStart(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, 42.5)
end

function mod:AbyssalStrikeApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alert", nil, args.destName)
end

function mod:SoulFlayStart(args)
	self:Message2(args.spellId, "yellow",  CL.count:format(args.spellName, flayCount))
	self:PlaySound(args.spellId, "alert")
	flayCount = flayCount + 1
	self:Bar(args.spellId, 46.5, CL.count:format(args.spellName, flayCount))
end

function mod:SoulFlayAddStart(args)
	self:CastBar(306319, 10, CL.count:format(args.spellName, flayCount-1))
end

function mod:SoulFlayApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(306319)
		self:PlaySound(306319, "alarm", args.destName)
	end
end

function mod:Torment(args)
	self:Message2(args.spellId, "yellow",  CL.count:format(args.spellName, tormentCount))
	self:PlaySound(args.spellId, "long")
	tormentCount = tormentCount + 1
	self:Bar(args.spellId, tormentCount % 2 == 0 and 50.5 or 30.5, CL.count:format(args.spellName, tormentCount))
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
