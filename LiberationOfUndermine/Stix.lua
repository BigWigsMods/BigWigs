
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
local powercoilCount = 1

local muffledDoomsplosionCount = 0

local mobCollector = {}
local mobMark = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.ball_size_medium = "Medium Ball!"
	L.ball_size_large = "Large Ball!"
	L.rolled_on_you = "%s rolled over YOU"
	L.rolled_from_you = "Rolled over %s"
	L.garbage_dump_message = "YOU hit BOSS for %s"

	L.electromagnetic_sorting = "Sorting" -- Short for Electromagnetic Sorting
	L.muffled_doomsplosion = "Bomb Soaked"
	L.short_fuse = "Bombshell Explosion"
	L.incinerator = "Fire Circles"
	L.landing = "Landing" -- Landing down from the sky
end

--------------------------------------------------------------------------------
-- Initialization
--

local rollingRubbishMarker = mod:AddMarkerOption(false, "player", 1, 461536, 1, 2, 3, 4)
local scrapmasterMarker = mod:AddMarkerOption(false, "npc", 8, -31645, 8, 7, 6, 5)
function mod:GetOptions()
	return {
		"berserk",
		464399, -- Electromagnetic Sorting
			{461536, "ME_ONLY_EMPHASIZE", "COUNTDOWN"}, -- Rolling Rubbish
				rollingRubbishMarker,
				465741, -- Garbage Dump
				465611, -- Rolled!
			464854, -- Garbage Pile
				465747, -- Muffled Doomsplosion
				1217975, -- Doomsploded
			-- Territorial Bombshell -- XXX announce/count deaths? show bar until all dead?
				473119, -- Short Fuse

		-- Cleanup Crew
			-- Scrapmaster
			1219384, -- Scrap Rockets
			1220648, -- Marked for Recycling
			scrapmasterMarker,
			-- Junkyard Hyena
			466748, -- Infected Bite

		-- Incinerator
		{464149, "CASTBAR"}, -- Incinerator
			472893, -- Incineration
			464248, -- Hot Garbage

		-- Demolish
		{464112, "TANK"}, -- Demolish
		{1217954, "TANK_HEALER"}, -- Meltdown

		-- Overdrive
		467117, -- Overdrive
			{467135, "CASTBAR"}, -- Trash Compactor
		-- Mythic
		1218704, -- Prototype Powercoil
	},{ -- Sections
		[1219384] = -30533, -- Cleanup Crew
		-- break up the list with dividers (the headers are options, and showing the same text twice is awkward)
		-- [466849] = "", -- Cleanup Crew
		[464149] = "", -- Incinerator
		[464112] = "", -- Demolish
		[467117] = "", -- Overdrive
		[1218704] = CL.mythic,
	},{ -- Renames
		[464399] = L.electromagnetic_sorting, -- Electromagnetic Sorting (Balls + Adds)
		[465747] = L.muffled_doomsplosion, -- Muffled Doomsplosion (Bomb Soaked)
		[473119] = L.short_fuse, -- Short Fuse (Bombshell Explosion)
		[464149] = L.incinerator, -- Incinerator (Fire Circles)
		[467135] = L.landing, -- Trash Compactor (Landing)
	}
end

function mod:OnRegister()
	self:SetSpellRename(464399, L.electromagnetic_sorting) -- Electromagnetic Sorting (Balls + Adds)
	self:SetSpellRename(464149, L.incinerator) -- Incinerator (Fire Circles)
	self:SetSpellRename(467109, L.landing) -- Trash Compactor (Landing)
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "SortedApplied", 465346) -- These players will become Rolling Rubbish
	self:Log("SPELL_AURA_APPLIED", "RollingRubbishApplied", 461536)
	self:Log("SPELL_AURA_REMOVED", "RollingRubbishRemoved", 461536)
	self:Log("SPELL_AURA_APPLIED", "RolledApplied", 465611)
	self:Log("SPELL_DAMAGE", "GarbageDumpDamage", 465741) -- Rolling Rubbish hitting the boss

	self:Log("SPELL_DAMAGE", "DiscardedDoomsplosiveDamage", 464865) -- Doomsplosives detonating
	self:Log("SPELL_MISSED", "DiscardedDoomsplosiveDamage", 464865)
	self:Log("SPELL_DAMAGE", "MuffledDoomsplosionDamage", 465747) -- Rolling Rubbish picking up Doomsplosives
	self:Log("SPELL_MISSED", "MuffledDoomsplosionDamage", 465747)
	self:Log("SPELL_AURA_APPLIED", "ShortFuseApplied", 473119) -- Bombshell detonating

	self:Log("SPELL_CAST_START", "ElectromagneticSorting", 464399)
	self:Log("SPELL_CAST_SUCCESS", "Incinerator", 464149)
	self:Log("SPELL_AURA_APPLIED", "IncinerationApplied", 472893)
	self:Log("SPELL_CAST_START", "Demolish", 464112)
	self:Log("SPELL_AURA_APPLIED", "DemolishApplied", 464112)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DemolishApplied", 464112)
	self:Log("SPELL_CAST_SUCCESS", "Meltdown", 1217954)
	-- Scrapmaster
	self:Log("SPELL_CAST_SUCCESS", "MessedUp", 1217685)
	self:Log("SPELL_CAST_SUCCESS", "ScrapRockets", 1219384)
	-- Junkyard Hyena
	self:Log("SPELL_AURA_APPLIED", "InfectedBiteApplied", 466748)
	self:Log("SPELL_AURA_APPLIED_DOSE", "InfectedBiteApplied", 466748)

	self:Log("SPELL_CAST_START", "Overdrive", 467117)
	self:Log("SPELL_AURA_APPLIED", "OverdriveApplied", 467117)
	self:Log("SPELL_AURA_REMOVED", "OverdriveRemoved", 467117)
	self:Log("SPELL_CAST_START", "TrashCompactor", 467109)
	self:Log("SPELL_CAST_SUCCESS", "TrashCompactorSuccess", 467109)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "MarkedForRecyclingApplied", 1220648)
	self:Log("SPELL_AURA_REMOVED", "MarkedForRecyclingRemoved", 1220648)
	self:Log("SPELL_AURA_APPLIED", "PrototypePowercoilApplied", 1218704)
	self:Log("SPELL_AURA_REMOVED", "PrototypePowercoilRemoved", 1218704)

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
	powercoilCount = 1

	mobCollector = {}

	if not self:Easy() then
		self:Berserk(self:Mythic() and 386 or 481, true) -- 6:25/8:00
	end

	self:Bar(464149, 11.1, CL.count:format(L.incinerator, incineratorCount)) -- Incinerator -- Fire
	self:Bar(464112, 17.7, CL.count:format(self:SpellName(464112), demolishCount)) -- Demolish
	self:Bar(464399, 22.2, CL.count:format(L.electromagnetic_sorting, electromagneticSortingCount)) -- Electromagnetic Sorting -- Balls + Adds
	self:Bar(1217954, 45.5, CL.count:format(self:SpellName(1217954), meltdownCount)) -- Meltdown
	self:Bar(467117, self:Mythic() and 66.7 or 111.2) -- Overdrive
	if self:Mythic() then
		self:Bar(1218704, 33.3, CL.count:format(self:SpellName(1218704), powercoilCount)) -- Prototype Powercoil
	end

	if self:GetOption(scrapmasterMarker) then
		self:RegisterTargetEvents("AddMarking")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:AddMarking(_, unit, guid)
	if mobCollector[guid] then
		self:CustomIcon(scrapmasterMarker, unit, mobCollector[guid])
		mobCollector[guid] = false
	end
end

do
	local iconList = {}
	local scheduled = nil
	local function sortPriority(first, second)
		if first and second then
			if first.healer ~= second.healer then
				return not first.healer and second.healer
			end
			if first.tank ~= second.tank then
				return first.tank and not second.tank
			end
			return first.index < second.index
		end
	end

	function mod:MarkPlayers()
		if scheduled then
			self:CancelTimer(scheduled)
			scheduled = nil
		end
		table.sort(iconList, sortPriority) -- Priority for tank > others > healers
		for i = 1, #iconList do
			local player = iconList[i].player
			self:CustomIcon(rollingRubbishMarker, player, i)
		end
	end

	function mod:ElectromagneticSorting(args)
		self:StopBar(CL.count:format(L.electromagnetic_sorting, electromagneticSortingCount))
		self:Message(args.spellId, "orange", CL.count:format(L.electromagnetic_sorting, electromagneticSortingCount))
		self:PlaySound(args.spellId, "long") -- damage and garbage over 5 seconds
		electromagneticSortingCount = electromagneticSortingCount + 1

		local cd
		if self:Mythic() then
			cd = electromagneticSortingCount == 2 and (44.4 + 22.5) or 51.1
		else
			cd = electromagneticSortingCount == 3 and (37.8 + 22.5) or 51.1
		end
		self:Bar(args.spellId, cd, CL.count:format(L.electromagnetic_sorting, electromagneticSortingCount))

		muffledDoomsplosionCount = 0
		mobMark = 8
		iconList = {}
	end

	function mod:SortedApplied(args)
		if self:Me(args.destGUID) then
			self:PersonalMessage(461536) -- Rolling Rubbish
			self:PlaySound(461536, "warning") -- you're becoming rubbish
		end

		iconList[#iconList+1] = {
			player = args.destName,
			tank = self:Tank(args.destName),
			healer = self:Healer(args.destName),
			index = UnitInRaid(args.destName) or 99, -- 99 for players not in your raid (or if you have no raid)
		}
		if not scheduled then
			scheduled = self:ScheduleTimer("MarkPlayers", 0.1)
		end
	end
end

do
	local ballSize = 0
	function mod:RollingRubbishApplied(args)
		if self:Me(args.destGUID) then
			ballSize = 0
			self:RegisterUnitEvent("UNIT_POWER_UPDATE", nil, "player", "vehicle")
			self:TargetBar(args.spellId, self:Mythic() and 20 or 24, args.destName)
		end
	end

	function mod:UNIT_POWER_UPDATE(_, unit, powerType)
		if powerType == "ALTERNATE" then
			local power = UnitPower(unit, 10)
			if power >= 200 and ballSize < 200 then
				self:Message(461536, "green", L.ball_size_large) -- Rolling Rubbish
				self:PlaySound(461536, "info")
			elseif power >= 100 and ballSize < 100 then
				self:Message(461536, "green", L.ball_size_medium) -- Rolling Rubbish
				self:PlaySound(461536, "alert")
			end
			ballSize = power
		end
	end

	function mod:RollingRubbishRemoved(args)
		if self:Me(args.destGUID) then
			self:StopBar(args.spellName, args.destName)
			self:PersonalMessage(461536, "removed")
			self:PlaySound(461536, "info")
			self:UnregisterUnitEvent("UNIT_POWER_UPDATE", "player", "vehicle")
		end
		self:CustomIcon(rollingRubbishMarker, args.destName)
	end
end

function mod:GarbageDumpDamage(args)
	if self:MobId(args.destGUID) == 230322 and self:Me(args.sourceGUID) then -- Stix
		self:Message(465741, "green", L.garbage_dump_message:format(self:AbbreviateNumber(args.extraSpellId))) -- Garbage Dump
	end
end

function mod:RolledApplied(args)
	if self:Me(args.destGUID) then
		self:Message(465611, "red", L.rolled_on_you:format(self:ColorName(args.sourceName)))
		self:PlaySound(465611, "alarm")
	elseif self:Me(args.sourceGUID) then
		self:Message(465611, "red", L.rolled_from_you:format(self:ColorName(args.destName)))
		self:PlaySound(465611, "alarm")
	end
end

do
	local prev = 0
	function mod:DiscardedDoomsplosiveDamage(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Message(1217975, "red")
			self:PlaySound(1217975, "alarm") -- failed
		end
	end
end

do
	local prev = 0
	function mod:MuffledDoomsplosionDamage(args)
		if args.time - prev > 0.2 then
			prev = args.time
			muffledDoomsplosionCount = muffledDoomsplosionCount + 1
			self:Message(args.spellId, "green", CL.count_amount:format(L.muffled_doomsplosion, muffledDoomsplosionCount, self:GetStage()))
			-- self:PlaySound(args.spellId, "info")
		end
	end
end

do
	local prev = 0
	function mod:ShortFuseApplied(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Message(args.spellId, "red", L.short_fuse)
			self:PlaySound(args.spellId, "alarm") -- failed
		end
	end
end

function mod:Incinerator(args)
	self:StopBar(CL.count:format(L.incinerator, incineratorCount))
	self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(L.incinerator, incineratorCount)))
	self:CastBar(args.spellId, 3)
	self:PlaySound(args.spellId, "alert") -- debuffs
	incineratorCount = incineratorCount + 1

	local cd
	if self:Mythic() then
		cd = incineratorCount == 4 and (4.5 + 11.4) or 25.6
	else
		cd = incineratorCount == 5 and (23.4 + 11.4) or 25.6
	end
	self:Bar(args.spellId, cd, CL.count:format(L.incinerator, incineratorCount))
end

function mod:IncinerationApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning") -- watch surrouding
	end
end

function mod:Demolish(args)
	self:StopBar(CL.count:format(args.spellName, demolishCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, demolishCount))
	self:PlaySound(args.spellId, "info")
	demolishCount = demolishCount + 1

	local cd
	if self:Mythic() then
		cd = demolishCount == 2 and (48.9 + 18.1) or 51.1
	else
		cd = demolishCount == 3 and (42.2 + 18.0) or 51.1
	end
	self:Bar(args.spellId, cd, CL.count:format(args.spellName, demolishCount))
end

function mod:DemolishApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, "purple", args.destName, amount, 3)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- On you
	elseif self:Tank() and amount > 2 then
		self:PlaySound(args.spellId, "warning") -- tauntswap
	end
end

function mod:Meltdown(args)
	self:StopBar(CL.count:format(args.spellName, meltdownCount))
	self:TargetMessage(args.spellId, "purple", args.destName, CL.count:format(args.spellName, meltdownCount))
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- On you
	else
		self:PlaySound(args.spellId, "alert") -- healer
	end
	meltdownCount = meltdownCount + 1

	local cd
	if self:Mythic() then
		cd = meltdownCount == 2 and (21.2 + 45.7) or 51.1
	else
		cd = meltdownCount == 3 and (14.5 + 45.7) or 51.1
	end
	self:Bar(args.spellId, cd, CL.count:format(args.spellName, meltdownCount))
end

function mod:MessedUp(args)
	if self:MobId(args.sourceGUID) == 231839 then -- Scrapmaster
		mobCollector[args.sourceGUID] = mobMark
		mobMark = mobMark - 1
	end
end

function mod:ScrapRockets(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo and ready then
		self:Message(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alarm")
	end
	-- flag the guid for marking if it wasn't rolled over
	if mobCollector[args.sourceGUID] == nil then
		mobCollector[args.sourceGUID] = mobMark
		mobMark = mobMark - 1
	end
end

function mod:InfectedBiteApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 1 then
			self:StackMessage(args.spellId, "blue", args.destName, amount, 6)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:Overdrive(args)
	self:StopBar(args.spellId)
	self:SetStage(2)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long") -- flying away

	-- The Overdrive "gap" cds are ((Overdrive _START - last cast) + (next cast - Trash Compactor _SUCCESS))
	self:PauseBar(464149, CL.count:format(L.incinerator, incineratorCount)) -- Incinerator
	self:PauseBar(464112, CL.count:format(self:SpellName(464112), demolishCount)) -- Demolish
	self:PauseBar(464399, CL.count:format(L.electromagnetic_sorting, electromagneticSortingCount)) -- Electromagnetic Sorting
	self:PauseBar(1217954, CL.count:format(self:SpellName(1217954), meltdownCount)) -- Meltdown
	if self:Mythic() then
		self:PauseBar(1218704, CL.count:format(self:SpellName(1218704), powercoilCount))
	end
end

function mod:OverdriveApplied(args)
	self:Bar(args.spellId, 9.0, CL.onboss:format(args.spellName))
end

function mod:OverdriveRemoved(args)
	self:StopBar(CL.onboss:format(args.spellName))
end

function mod:TrashCompactor(args)
	self:Message(467135, "red", L.landing)
	self:PlaySound(467135, "warning") -- watch drop location
	self:CastBar(467135, 3.75, L.landing)
end

function mod:TrashCompactorSuccess(args)
	self:ResumeBar(464149, CL.count:format(L.incinerator, incineratorCount)) -- Incinerator
	self:ResumeBar(464112, CL.count:format(self:SpellName(464112), demolishCount)) -- Demolish
	self:ResumeBar(464399, CL.count:format(L.electromagnetic_sorting, electromagneticSortingCount)) -- Electromagnetic Sorting
	self:ResumeBar(1217954, CL.count:format(self:SpellName(1217954), meltdownCount)) -- Meltdown
	if self:Mythic() then
		self:ResumeBar(1218704, CL.count:format(self:SpellName(1218704), powercoilCount)) -- Prototype Powercoil
	end
end

function mod:MarkedForRecyclingApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "blue")
		-- self:PlaySound(args.spellId, "info") -- should be saved
		-- self:TargetBar(args.spellId, 10, args.destName)
	end
end

function mod:MarkedForRecyclingRemoved(args)
	-- if self:Me(args.destGUID) then
	-- 	self:StopBar(args.spellId, args.destName)
	-- end
end

do
	local prev = 0
	function mod:PrototypePowercoilApplied(args)
		if args.time - prev > 1 then
			prev = args.time
			self:StopBar(CL.count:format(args.spellName, powercoilCount))
			self:Message(args.spellId, "cyan", CL.count:format(args.spellName, powercoilCount))
			powercoilCount = powercoilCount + 1

			local cd = powercoilCount == 2 and (33.4 + 33.6) or 51.1
			self:Bar(args.spellId, cd, CL.count:format(args.spellName, powercoilCount))
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "alarm")
			self:TargetBar(args.spellId, 10, args.destName)
		end
	end

	function mod:PrototypePowercoilRemoved(args)
		if self:Me(args.destGUID) then
			self:StopBar(args.spellId, args.destName)
		end
	end
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
