if not BigWigsLoader.isTestBuild then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Stix Bunkjunker", 2769, 2642)
if not mod then return end
mod:RegisterEnableMob(230322) -- Stix Bunkjunker
mod:SetEncounterID(3012)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local electromagneticSortingCount = 1
local incineratorCount = 1
local demolishCount = 1
local meltdownCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.rolled_over_by = "Rolled over by %s" -- Rolled over by PlayerX
	L.landing = "Landing"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		464399, -- Electromagnetic Sorting
			461536, -- Rolling Rubbish -- XXX Widget messages for size of ball?
				465611, -- Rolled!
			464854, -- Garbage Pile
				1217975, -- Doomsploded
			-- Territorial Bombshell XXX Marking them? can use CLEU order.
			-- Scrapmaster
			1219384, -- Scrap Rockets
			-- Junkyard Hyena
			466748, -- Infected Bite
		464149, -- Incinerator
			472893, -- Incineration
			464248, -- Hot Garbage
		{464112, "TANK"}, -- Demolish
		{1217954, "TANK"}, -- Meltdown
		467117, -- Overdrive
			467109, -- Trash Compactor
	},{ -- Sections

	},{ -- Renames
		[467109] = L.landing, -- Trash Compactor (Landing)
	}
end

function mod:OnRegister()
	self:SetSpellRename(467109, L.landing) -- Trash Compactor (Landing)
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "ElectromagneticSorting", 464399)
	self:Log("SPELL_AURA_APPLIED", "SortedApplied", 465346) -- These players will become Rolling Rubbish -- XXX Mark
	-- self:Log("SPELL_AURA_APPLIED", "RollingRubbishRemoved", 461536) -- XXX Unmark
	self:Log("SPELL_AURA_APPLIED", "RolledApplied", 465611)
	self:Log("SPELL_AURA_APPLIED", "Doomsploded", 1217975)
	self:Log("SPELL_CAST_SUCCESS", "ScrapRockets", 1219384)
	self:Log("SPELL_AURA_APPLIED", "InfectedBiteApplied", 466748)
	self:Log("SPELL_AURA_APPLIED_DOSE", "InfectedBiteApplied", 466748)
	self:Log("SPELL_CAST_SUCCESS", "Incinerator", 464149)
	self:Log("SPELL_AURA_APPLIED", "IncinerationApplied", 472893)
	self:Log("SPELL_CAST_START", "Demolish", 464112)
	self:Log("SPELL_AURA_APPLIED", "DemolishApplied", 464112)
	self:Log("SPELL_CAST_START", "Meltdown", 1217954)
	self:Log("SPELL_CAST_START", "Overdrive", 467117)
	self:Log("SPELL_CAST_START", "TrashCompactor", 467109)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 464854, 464248) -- Garbage Pile, Hot Garbage
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 464854, 464248)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 464854, 464248)
end

function mod:OnEngage()
	self:SetStage(1)

	electromagneticSortingCount = 1
	incineratorCount = 1
	demolishCount = 1
	meltdownCount = 1

	self:Bar(464149, 11.1, CL.count:format(self:SpellName(464149), incineratorCount)) -- Incinerator
	self:Bar(464112, 17.7, CL.count:format(self:SpellName(464112), demolishCount)) -- Demolish
	self:Bar(464399, 22.2, CL.count:format(self:SpellName(464399), electromagneticSortingCount)) -- Electromagnetic Sorting
	self:Bar(1217954, 44.5, CL.count:format(self:SpellName(1217954), meltdownCount)) -- Meltdown

	self:Bar(467117, 111.1) -- Overdrive
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ElectromagneticSorting(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, electromagneticSortingCount))
	self:PlaySound(args.spellId, "long") -- damage and garbage over 5 seconds
	electromagneticSortingCount = electromagneticSortingCount + 1
	self:Bar(args.spellId, electromagneticSortingCount == 3 and 72.2 or 51.1, CL.count:format(args.spellName, electromagneticSortingCount))
end

function mod:SortedApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(461536)
		self:PlaySound(461536, "warning") -- you're becoming rubbish
	end
end

function mod:RolledApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "cyan", L.rolled_over_by:format(self:ColorName(args.sourceName)))
		self:PlaySound(args.spellId, "alarm") -- stunned
	end
end

do
	local prev = 0
	function mod:Doomsploded(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Message(args.spellId, "red")
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:ScrapRockets(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo and ready then
		self:Message(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:InfectedBiteApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 1 then
			self:StackMessage(args.spellId, "blue", args.destName, amount, 1)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:Incinerator(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, incineratorCount))
	self:PlaySound(args.spellId, "alert") -- debuffs
	incineratorCount = incineratorCount + 1
	self:Bar(args.spellId, incineratorCount == 5 and 46.7 or 25.6, CL.count:format(args.spellName, incineratorCount))
end

function mod:IncinerationApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm") -- watch surrouding
	end
end

function mod:Demolish(args)
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, demolishCount))
	self:PlaySound(args.spellId, "info")
	demolishCount = demolishCount + 1
	self:Bar(args.spellId, demolishCount == 3 and 72.2 or 51.5, CL.count:format(args.spellName, demolishCount)) -- Delayed once due to overdrive?
end

function mod:DemolishApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- On you
	end
end

function mod:Meltdown(args)
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, meltdownCount))
	self:PlaySound(args.spellId, "info") -- XXX change to play for current target?
	meltdownCount = meltdownCount + 1
	self:Bar(args.spellId, meltdownCount == 3 and 72.2 or 51.5, CL.count:format(args.spellName, meltdownCount)) -- Delayed once due to overdrive?
end

function mod:Overdrive(args)
	self:SetStage(2)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long") -- flying away
	self:Bar(467109, 13.25, L.landing) -- Trash Compactor // 12.5~14s
end

function mod:TrashCompactor(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "warning") -- watch drop location
	self:Bar(467109, {3.75, 13.25}, L.landing) -- Specify landing time by cast time
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end
