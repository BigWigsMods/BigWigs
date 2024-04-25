--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Primal Council", 2522, 2486)
if not mod then return end
mod:RegisterEnableMob(
	187771, -- Kadros Icewrath
	189816, -- Dathea Stormlash
	187772, -- Opalfang
	187767  -- Embar Firepath
)
mod:SetEncounterID(2590)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local blizzardCount = 1
local conductiveMarkCount = 1
local axeCount = 1
local slashCount = 1
local earthenPillarCount = 1

local timersTable = {
	[14] = { -- Normal
		[397134] = { 8.4, 43.7, 48.6, 43.7, 42.6, 47.4, 42.5, 43.7, 49.8, 40.1, 43.7, 46.2, 43.7, 43.7 }, -- Pillars
		[374038] = { 42.6, 68.0, 66.9, 66.9, 66.8, 66.8, 66.8, 65.5, 66.8 }, -- Axes
		[371624] = { 16.9, 71.7, 46.2, 45.0, 42.5, 44.9, 46.1, 43.7, 46.2, 43.7, 42.5, 44.9, 44.9 }, -- Marks
		[373059] = { 60.6, 149.4, 132.4, 133.6 }, -- Blizzard
	},
	[15] = { -- Heroic
		[397134] = { 7.7, 35.0, 37.9, 34.1, 37.7, 35.2, 34.1, 35.2, 37.8, 33.8, 35.5, 36.5, 36.4, 32.8, 37.7, 35.2, 34.0 }, -- Pillars
		[374038] = { 34.5, 54.7, 53.5, 53.5, 53.5, 53.5, 53.5, 53.5, 54.3, 51.3, 53.5 }, -- Axes
		[371624] = { 13.7, 57.2, 36.5, 36.5, 35.2, 37.7, 34.0, 36.5, 32.8, 36.5, 35.3, 35.2, 37.6, 32.8, 38.9, 35.2 }, -- Marks
		[373059] = { 50.2, 117.9, 105.8, 107.0, 106.9, 106.9 }, -- Blizzard
	},
	[16] =  { -- Mythic
		[397134] = { 5.7, 25.5, 29.6, 26.3, 25.5, 28.3, 25.6, 26.7, 27.8, 25.7, 25.5, 29.2, 27.2, 23.8, 27.9, 26.7, 25.5, 29.1 }, -- Pillar
		[374038] = { 27.7, 40.5, 40.1, 40.0, 40.1, 40.1, 40.1, 40.1, 39.7, 40.4, 40.0, 40.0 }, --  Axes
		[371624] = { 12.1, 41.3, 27.9, 27.9, 51.0, 27.9, 25.5, 29.2, 24.3, 26.8, 28.0, 27.9, 24.2, 26.7, 26.7, 26.6, 26.7 }, -- Mark
		[373059] = { 37.7, 89.8, 77.8, 82.7, 77.7, 81.3 }, -- Blizzard
	},
	[17] = { -- LFR
		[397134] = { 8.5, 43.7, 53.5, 43.7, 42.6, 47.4, 42.5, 43.7, 49.8, 40.0, 43.7, 47.4, 42.5, 43.7 }, -- Pillars
		[374038] = { 42.6, 72.9, 66.9, 66.8, 66.8, 66.8, 66.7, 66.8, 66.7 }, -- Axes
		[371624] = { 18.2, 76.5, 47.4, 46.2, 40.1, 49.8, 42.5, 41.3, 47.3, 44.9, 41.3, 47.4, 46.1, 40.1, 49.8 }, -- Marks
		[373059] = { 64.4, 144.6, 133.5, 134.7, 132.3 }, -- Blizzard
	},
}
local timers = timersTable[mod:Difficulty()]

-- Skipped code
local SKIP_CAST_THRESHOLD = 4
local checkTimer = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.primal_blizzard = "Blizzard" -- Primal Blizzard
	L.earthen_pillars = "Pillars" -- Earthen Pillars
	L.meteor_axes = "Axes" -- Meteor Axes
	L.meteor_axe = "Axe" -- Singular
	L.meteor_axes_melee = "Melee Axe"
	L.meteor_axes_ranged = "Ranged Axe"

	L.skipped_cast = "Skipped %s (%d)"
end

--------------------------------------------------------------------------------
-- Initialization
--

local conductiveMarkMarker = mod:AddMarkerOption(false, "player", 3, 371624, 3)
local meteorAxeMarker = mod:AddMarkerOption(false, "player", 1, 374043, 1, 2)
function mod:GetOptions()
	return {
		-- Kadros Icewrath
		{373059, "CASTBAR", "ME_ONLY_EMPHASIZE"}, -- Primal Blizzard
		386661, -- Glacial Convocation
		-- Dathea Stormlash
		{371624, "ME_ONLY_EMPHASIZE"}, -- Conductive Mark
		conductiveMarkMarker, -- (vs ICON, leave skull/cross for boss marking)
		{372279, "OFF"}, -- Chain Lightning
		386375, -- Storming Convocation
		-- Opalfang
		397134, -- Earthen Pillar
		{372056, "TANK"}, -- Crush
		386370, -- Quaking Convocation
		-- Embar Firepath
		{374038, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Meteor Axes
		{372027, "TANK"}, -- Slashing Blaze
		meteorAxeMarker,
		386289, -- Burning Convocation
	}, {
		[373059] = -24952, -- Kadros Icewrath
		[371624] = -24958, -- Dathea Stormlash
		[397134] = -24967, -- Opalfang
		[374038] = -24965, -- Embar Firepath
	}, {
		[373059] = L.primal_blizzard, -- Primal Blizzard (Blizzard)
		[374038] = L.meteor_axes, -- Meteor Axes (Axes)
		[371624] = CL.marks, -- Conductive Mark (Marks)
	}
end

function mod:OnBossEnable()
	-- Kadros Icewrath
	self:Log("SPELL_CAST_START", "PrimalBlizzard", 373059)
	self:Log("SPELL_AURA_APPLIED_DOSE", "PrimalBlizzardApplied", 371836)
	self:Log("SPELL_CAST_SUCCESS", "GlacialConvocation", 386440)
	-- Dathea Stormlash
	self:Log("SPELL_CAST_START", "ConductiveMark", 375331)
	self:Log("SPELL_AURA_APPLIED", "ConductiveMarkApplied", 371624)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ConductiveMarkApplied", 371624)
	self:Log("SPELL_CAST_START", "ChainLightning", 372279)
	self:Log("SPELL_CAST_SUCCESS", "StormingConvocation", 386375)
	-- Opalfang
	self:Log("SPELL_CAST_START", "EarthenPillar", 397134)
	self:Log("SPELL_CAST_START", "Crush", 372056)
	self:Log("SPELL_AURA_APPLIED", "CrushApplied", 372056)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrushApplied", 372056)
	self:Log("SPELL_CAST_SUCCESS", "QuakingConvocation", 386370)
	-- Embar Firepath
	self:Log("SPELL_CAST_START", "MeteorAxe", 374038)
	self:Log("SPELL_AURA_APPLIED", "MeteorAxeApplied", 374039)
	self:Log("SPELL_AURA_REMOVED", "MeteorAxeRemoved", 374039)
	self:Log("SPELL_CAST_START", "SlashingBlaze", 372027)
	self:Log("SPELL_CAST_SUCCESS", "BurningConvocation", 386289)
end

function mod:OnEngage(diff)
	timers = timersTable[diff]

	blizzardCount = 1
	conductiveMarkCount = 1
	axeCount = 1
	slashCount = 1
	earthenPillarCount = 1

	self:Bar(372027, 11, CL.count:format(self:SpellName(372027), slashCount)) -- Slashing Blaze
	self:CDBar(372279, 12) -- Chain Lightning
	self:Bar(372056, 19.5) -- Crush
	self:Bar(397134, timers[397134][earthenPillarCount], CL.count:format(L.earthen_pillars, earthenPillarCount)) -- Earthen Pillar
	local markCD = timers[371624][conductiveMarkCount]
	self:Bar(371624, markCD, CL.count:format(CL.marks, conductiveMarkCount))
	checkTimer = self:ScheduleTimer("ConductiveMarkCheck", markCD + SKIP_CAST_THRESHOLD, conductiveMarkCount)
	self:Bar(374038, timers[374038][axeCount], CL.count:format(L.meteor_axes, axeCount))
	self:Bar(373059, timers[373059][blizzardCount], CL.count:format(L.primal_blizzard, blizzardCount))
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ConductiveMarkCheck(castCount) -- Marks are rarely skipped
	if castCount == conductiveMarkCount then -- not on the next cast?
		mod:StopBar(CL.count:format(CL.marks, conductiveMarkCount))
		mod:Message(371624, "green", L.skipped_cast:format(CL.marks, castCount))
		conductiveMarkCount = castCount + 1
		local cd = timers[371624][conductiveMarkCount]
		if cd then
			mod:Bar(371624, cd - SKIP_CAST_THRESHOLD, CL.count:format(CL.marks, conductiveMarkCount))
			checkTimer = mod:ScheduleTimer("ConductiveMarkCheck", cd, conductiveMarkCount)
		end
	end
end

-- Kadros Icewrath
function mod:PrimalBlizzard(args)
	self:StopBar(CL.count:format(L.primal_blizzard, blizzardCount))
	self:Message(args.spellId, "cyan", CL.casting:format(CL.count:format(L.primal_blizzard, blizzardCount)))
	self:CastBar(args.spellId, 13, CL.count:format(L.primal_blizzard, blizzardCount)) -- 3s cast + 10s channel
	self:PlaySound(args.spellId, "alarm") -- spread
	blizzardCount = blizzardCount + 1
	self:CDBar(args.spellId, timers[args.spellId][blizzardCount], CL.count:format(L.primal_blizzard, blizzardCount))
end

function mod:PrimalBlizzardApplied(args)
	if self:Me(args.destGUID) and args.amount > 5 then
		self:StackMessage(373059, "blue", args.destName, args.amount, 8)
		if args.amount > 6 then
			self:PlaySound(373059, "warning")
		end
	end
end

function mod:GlacialConvocation(args)
	self:StopBar(CL.count:format(args.spellName, blizzardCount))
	self:Message(386661, "cyan")
	self:PlaySound(386661, "info")
end

-- Dathea Stormlash
function mod:ConductiveMark()
	self:StopBar(CL.count:format(CL.marks, conductiveMarkCount))
	self:Message(371624, "cyan", CL.casting:format(CL.count:format(CL.marks, conductiveMarkCount)))
	conductiveMarkCount = conductiveMarkCount + 1
	local cd = timers[371624][conductiveMarkCount]
	self:CDBar(371624, cd, CL.count:format(CL.marks, conductiveMarkCount))
	if cd then
		checkTimer = self:ScheduleTimer("ConductiveMarkCheck", cd + SKIP_CAST_THRESHOLD, conductiveMarkCount)
	end
end

function mod:ConductiveMarkApplied(args)
	if self:Me(args.destGUID) then
		if args.amount then
			self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1, CL.mark)
		else
			self:PersonalMessage(args.spellId, nil, CL.mark)
		end
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:ChainLightning(args)
	self:Message(args.spellId, "yellow")
	self:CDBar(args.spellId, 11)
end

function mod:StormingConvocation(args)
	self:StopBar(CL.count:format(CL.marks, conductiveMarkCount))
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "info")
end

-- Opalfang

function mod:EarthenPillar(args)
	self:StopBar(CL.count:format(L.earthen_pillars, earthenPillarCount))
	self:Message(args.spellId, "green", CL.count:format(L.earthen_pillars, earthenPillarCount))
	earthenPillarCount = earthenPillarCount + 1
	self:Bar(args.spellId, timers[args.spellId][earthenPillarCount], CL.count:format(L.earthen_pillars, earthenPillarCount))
end

function mod:Crush(args)
	self:Bar(args.spellId, 22)
end

function mod:CrushApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 2)
	if self:Tank() and not self:Me(args.destGUID) and not self:Tanking(self:UnitTokenFromGUID(args.sourceGUID)) then
		self:PlaySound(args.spellId, "warning") -- tauntswap
	elseif self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- On you
	end
end

function mod:QuakingConvocation(args)
	self:StopBar(CL.count:format(L.earthen_pillars, earthenPillarCount)) -- Earthen Pillar
	self:StopBar(372056) -- Crush

	self:Message(args.spellId, "green")
	self:PlaySound(args.spellId, "info")
	-- every 10s, too much?
	-- local quaking = mod:SpellName(207863)
	-- self:Bar(args.spellId, 10, quaking)
	-- self:ScheduleRepeatingTimer("Bar", 10, args.spellId, quaking)
end

-- Embar Firepath
do
	local playerList, iconList = {}, {}
	local scheduled = nil
	local function sortPriority(first, second)
		if first and second then
			if first.tank ~= second.tank then
				return first.tank and not second.tank
			end
			if first.melee ~= second.melee then
				return first.melee and not second.melee
			end
			return first.index < second.index
		end
	end

	function mod:MeteorAxe(args)
		self:StopBar(CL.count:format(L.meteor_axes, axeCount))
		axeCount = axeCount + 1
		self:Bar(args.spellId, timers[args.spellId][axeCount], CL.count:format(L.meteor_axes, axeCount))
		iconList = {}
	end

	function mod:MarkPlayers()
		local playedSound = false
		if scheduled then
			self:CancelTimer(scheduled)
			scheduled = nil
		end
		table.sort(iconList, sortPriority) -- Priority for tanks > melee > ranged
		for i = 1, #iconList do
			if iconList[i].player == self:UnitName("player") then
				if i == 1 then -- Melee Axe
					self:Say(374038, CL.rticon:format(L.meteor_axes_melee, i), nil, ("Melee Axe ({rt%d})"):format(i))
					self:PersonalMessage(374038, nil, L.meteor_axes_melee)
				else -- Ranged Axe
					self:Say(374038, CL.rticon:format(L.meteor_axes_ranged, i), nil, ("Ranged Axe ({rt%d})"):format(i))
					self:PersonalMessage(374038, nil, L.meteor_axes_ranged)
				end
				self:SayCountdown(374038, 6, i)
				self:PlaySound(374038, "warning") -- debuffmove
				playedSound = true
			end
			playerList[#playerList+1] = iconList[i].player
			playerList[iconList[i].player] = i
			self:CustomIcon(meteorAxeMarker, iconList[i].player, i)
		end
		if not playedSound then -- play for others
			self:TargetsMessage(374038, "red", playerList, 2, CL.count:format(L.meteor_axes, axeCount-1))
			self:PlaySound(374038, "alert") -- stack
		end
	end

	function mod:MeteorAxeApplied(args)
		if not scheduled then
			scheduled = self:ScheduleTimer("MarkPlayers", 1.5)
		end
		iconList[#iconList+1] = {player=args.destName, melee=self:Melee(args.destName), index=UnitInRaid(args.destName) or 99, tank=self:Tank(args.destName)} -- 99 for players not in your raid (or if you have no raid)
		if #iconList == 2 then
			self:MarkPlayers()
		end
	end

	function mod:MeteorAxeRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(374038)
		end
		self:CustomIcon(meteorAxeMarker, args.destName)
	end
end

function mod:SlashingBlaze(args)
	self:Message(args.spellId, "orange")
	if self:Tank() then
		self:PlaySound(args.spellId, "warning")
	end
	self:Bar(args.spellId, 28, CL.count:format(args.spellName, slashCount))
end

function mod:BurningConvocation(args)
	self:StopBar(CL.count:format(self:SpellName(372027), slashCount)) -- Slashing Blaze
	self:StopBar(CL.count:format(L.meteor_axes, axeCount)) -- Meteor Axes
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "info")
end
