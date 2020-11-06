--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Dark Inquisitor Xanesh", 2217, 2377)
if not mod then return end
mod:RegisterEnableMob(156575) -- Dark Inquisitor Xanesh
mod.engageId = 2328
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local awakenedCount = 0
local mobCollector = {}
local awakenedList = {}

local ritualCount = 1
local flayCount = 1
local tormentCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

local awakenedTerrorMarker = mod:AddMarkerOption(false, "npc", 3, -21227, 2, 3, 1) -- Awakened Terror // In order of marking
function mod:GetOptions()
	return {
		312336, -- Void Ritual
		312406, -- Voidwoken
		313264, -- Dark Ascension
		{311551, "TANK"}, -- Abyssal Strike
		306319, -- Soul Flay
		306208, -- Torment
		305575, -- Ritual Field
		awakenedTerrorMarker,
	},{
		[312336] = "general",
		[awakenedTerrorMarker] = CL.mythic,
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

	self:Log("SPELL_CAST_START", "TerrorWave", 316211)
end

function mod:OnEngage()
	awakenedList = {}
	mobCollector = {}
	ritualCount = 1
	flayCount = 1
	tormentCount = 1
	awakenedCount = 1

	self:CDBar(306319, self:Mythic() and 25.2 or 16.9, CL.count:format(self:SpellName(306319), flayCount)) -- Soul Flay (1)
	self:CDBar(306208, self:Mythic() and 49.5 or 20.5, CL.count:format(self:SpellName(306208), tormentCount)) -- Torment (1)
	self:Bar(311551, 30) -- Abyssal Strike
	self:Bar(312336, self:Mythic() and 19.1 or 61, CL.count:format(self:SpellName(312336), ritualCount)) -- Void Ritual (1)

	if self:GetOption(awakenedTerrorMarker) then
		self:RegisterTargetEvents("AwakenedMarker")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:TerrorWave(args)
	if self:GetOption(awakenedTerrorMarker) and not mobCollector[args.sourceGUID] then
		mobCollector[args.sourceGUID] = true
		awakenedList[args.sourceGUID] = (awakenedCount % 3) + 1 -- 2, 3, 1 -- In order of marking
		awakenedCount = awakenedCount + 1
		for k, v in pairs(awakenedList) do
			local unit = self:GetUnitIdByGUID(k)
			if unit then
				SetRaidTarget(unit, awakenedList[k])
				awakenedList[k] = nil
			end
		end
	end
end

function mod:AwakenedMarker(event, unit, guid)
	if self:MobId(guid) == 162432 and awakenedList[guid] then -- Eldritch Abomination
		SetRaidTarget(unit, awakenedList[guid])
		awakenedList[guid] = nil
	end
end

function mod:VoidRitualStart(args)
	self:Message(args.spellId, "red",  CL.count:format(args.spellName, ritualCount))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 5, CL.count:format(args.spellName, ritualCount))
	ritualCount = ritualCount + 1
	self:Bar(args.spellId, 95.5, CL.count:format(args.spellName, ritualCount))

	awakenedList = {}
	awakenedCount = 1
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
	self:TargetMessage(args.spellId, "red", args.destName)
	self:PlaySound(args.spellId, "warning", args.destName)
end

function mod:AbyssalStrikeStart(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, self:Mythic() and 23 or 42.5)
end

function mod:AbyssalStrikeApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alert", nil, args.destName)
end

function mod:SoulFlayStart(args)
	self:StopBar(CL.count:format(args.spellName, flayCount))
	self:Message(args.spellId, "yellow",  CL.count:format(args.spellName, flayCount))
	self:PlaySound(args.spellId, "alert")
	flayCount = flayCount + 1
	self:CDBar(args.spellId, self:Mythic() and 59 or 60, CL.count:format(args.spellName, flayCount))
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
	self:StopBar(CL.count:format(args.spellName, tormentCount))
	self:Message(args.spellId, "yellow",  CL.count:format(args.spellName, tormentCount))
	self:PlaySound(args.spellId, "long")
	tormentCount = tormentCount + 1
	self:CDBar(args.spellId, tormentCount % 2 == 0 and 65.5 or 30.5, CL.count:format(args.spellName, tormentCount))
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
