
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

local timers = {
	-- Conductive Mark
	[371624] = {10.5, 44.0, 25.5, 29.0, 24.3, 25.5, 30.5, 50, 26.8, 25.6, 28},
	-- Earthen Pillar
	[397134] = {5.7, 25.8, 29.2, 27.2, 24.4, 28.1, 25.7, 26.8, 28.2, 25.6, 25.7, 28.0, 29.2},
	-- Slashing Blaze
	[372027] = {10.5, 28.3, 30.5, 28.2, 28.2, 28.1, 28.1, 28.1, 28.1, 31.7, 28.0, 28.0},
	-- Meteor Axes
	[374038] = {22.9, 40.4, 40.4, 40.4, 40.3, 39.2, 40.2, 40.2, 39.0},
	-- Primal Blizzard
	[373059] = {36.4, 89.4, 79.4, 80.6},
}

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
	L.conductive_marks = "Marks" -- Conductive Marks
	L.conductive_mark = "Mark" -- Singular

	L.custom_off_chain_lightning = "Chain Lightning is off by default, enable this to enable chain lightning."

	L.custom_on_stop_timers = "Always show ability bars"
	L.custom_on_stop_timers_desc = "Abilities that will always be shown: Conductive Mark"
end

--------------------------------------------------------------------------------
-- Initialization
--

local conductiveMarkMarker = mod:AddMarkerOption(false, "player", 3, 371624, 3)
local meteorAxeMarker = mod:AddMarkerOption(false, "player", 1, 374043, 1, 2)
function mod:GetOptions()
	return {
		"custom_on_stop_timers",
		-- Kadros Icewrath
		373059, -- Primal Blizzard
		386661, -- Glacial Convocation
		-- Dathea Stormlash
		371624, -- Conductive Mark
		conductiveMarkMarker, -- (vs ICON, leave skull/cross for boss marking)
		372279, -- Chain Lightning
		"custom_off_chain_lightning",
		386375, -- Storming Convocation
		-- Opalfang
		397134, -- Earthen Pillar
		{372056, "TANK"}, -- Crush
		386370, -- Quaking Convocation
		-- Embar Firepath
		{374038, "SAY", "SAY_COUNTDOWN"}, -- Meteor Axes
		{372027, "TANK"}, -- Slashing Blaze
		meteorAxeMarker,
		386289, -- Burning Convocation
	}, {
		["custom_on_stop_timers"] = "general",
		[391599] = -24952, -- Kadros Icewrath
		[371624] = -24958, -- Dathea Stormlash
		[397134] = -24967, -- Opalfang
		[374038] = -24965, -- Embar Firepath
	}, {
		[373059] = L.primal_blizzard, -- Primal Blizzard (Blizzard)
		[374038] = L.meteor_axes, -- Meteor Axes (Axes)
		[371624] = L.conductive_marks, -- Conductive Mark (Mark)
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_BarCreated", "BarCreated")

	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4")
	-- Kadros Icewrath
	self:Log("SPELL_CAST_START", "PrimalBlizzard", 373059)
	self:Log("SPELL_CAST_SUCCESS", "GlacialConvocation", 386440)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GlacialConvocationApplied", 386661)
	-- Dathea Stormlash
	self:Log("SPELL_AURA_APPLIED", "ConductiveMarkApplied", 371624)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ConductiveMarkApplied", 371624)
	self:Log("SPELL_CAST_START", "ChainLightning", 372279)
	self:Log("SPELL_CAST_SUCCESS", "StormingConvocation", 386375)
	-- Opalfang
	self:Log("SPELL_CAST_START", "EarthenPillar", 397134)
	self:Log("SPELL_AURA_APPLIED", "CrushApplied", 372056)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrushApplied", 372056)
	self:Log("SPELL_CAST_SUCCESS", "QuakingConvocation", 386370)
	-- Embar Firepath
	self:Log("SPELL_CAST_START", "MeteorAxe", 374038)
	self:Log("SPELL_AURA_APPLIED", "MeteorAxeApplied", 374039) -- no cast log -_-;
	self:Log("SPELL_AURA_REMOVED", "MeteorAxeRemoved", 374039)
	self:Log("SPELL_CAST_START", "SlashingBlaze", 372027)
	self:Log("SPELL_CAST_SUCCESS", "BurningConvocation", 386289)
end

function mod:OnEngage()
	blizzardCount = 1
	conductiveMarkCount = 1
	axeCount = 1
	slashCount = 1
	earthenPillarCount = 1

	self:Bar(397134, 5, CL.count:format(L.earthen_pillars, earthenPillarCount)) -- Earthen Pillar
	self:Bar(372056, 19.5) -- Crush
	if self:GetOption("custom_off_chain_lightning") then
		self:CDBar(372279, 14.5) -- Chain Lightning
	end
	self:CDBar(374038, 26, CL.count:format(L.meteor_axes, axeCount))
	self:CDBar(373059, 42.4, CL.count:format(L.primal_blizzard, blizzardCount))
	self:Bar(371624, 18, CL.count:format(L.conductive_marks, conductiveMarkCount))
	self:Bar(372027, 10.9, CL.count:format(self:SpellName(372027), slashCount))
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local abilitysToPause = {
		[371624] = true, -- Conductive Marks
	}

	local castPattern = CL.cast:gsub("%%s", ".+")

	local function stopAtZeroSec(bar, key, text)
		if bar.remaining < 0.045 then -- Pause at 0.0
			bar:SetDuration(0.01) -- Make the bar look full
			bar:Start()
			bar:SetTimeVisibility(false)
			mod:PauseBar(key, text)
		end
	end

	function mod:BarCreated(_, _, bar, _, key, text)
		if self:GetOption("custom_on_stop_timers") and abilitysToPause[key] and not text:match(castPattern) then
			bar:AddUpdateFunction(function() stopAtZeroSec(bar,key,text) end)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 375331 then -- Conductive Mark
		self:StopBar(CL.count:format(L.conductive_marks, conductiveMarkCount))
		self:Message(371624, "cyan", CL.count:format(L.conductive_marks, conductiveMarkCount))
		conductiveMarkCount = conductiveMarkCount + 1
		self:CDBar(371624, timers[371624][conductiveMarkCount], CL.count:format(L.conductive_marks, conductiveMarkCount))
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

function mod:GlacialConvocation(args)
	self:StopBar(CL.count:format(args.spellName, blizzardCount))

	self:Message(386661, "cyan")
	self:PlaySound(386661, "info")
end

function mod:GlacialConvocationApplied(args)
	if self:Me(args.destGUID) and args.amount % 3 == 0 then -- every 5s, drop stacks around 5?
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 6)
		if args.amount > 5 then
			self:PlaySound(args.spellId, "info")
		end
	end
end

-- Dathea Stormlash
function mod:ConductiveMarkApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, args.amount, L.conductive_mark)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:ChainLightning(args)
	if self:GetOption("custom_off_chain_lightning") then
		self:Message(args.spellId, "yellow")
		self:CDBar(args.spellId, 11)
	end
end

function mod:StormingConvocation(args)
	self:StopBar(CL.count:format(L.conductive_marks, conductiveMarkCount))
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

function mod:CrushApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 2)
	-- if (args.amount or 0) > 1 and self:Tank() and not self:Tanking("boss1") then
	-- 	self:PlaySound(args.spellId, "warning") -- tankswap
	-- end
	self:Bar(args.spellId, 22)
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
				local text = i == 1 and L.meteor_axes_melee or L.meteor_axes_ranged -- Melee or Ranged Axe
				self:Say(374038, CL.rticon:format(text, i))
				self:PersonalMessage(374038, nil, text)
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
	self:Bar(args.spellId, timers[args.spellId][axeCount], CL.count:format(args.spellName, slashCount))
end

function mod:BurningConvocation(args)
	self:StopBar(CL.count:format(L.meteor_axes, axeCount))
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "info")
end
