if not IsTestBuild() then return end
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
local markCount = 1
local axeCount = 1
local slashCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.conductive_mark = "Mark"
end

--------------------------------------------------------------------------------
-- Initialization
--

local conductiveMarkMarker = mod:AddMarkerOption(false, "player", 3, 371624, 3)
local meteorAxeMarker = mod:AddMarkerOption(false, "player", 1, 374043, 1, 2)
function mod:GetOptions()
	return {
		-- Kadros Icewrath
		391599, -- Primal Blizzard
		386661, -- Glacial Convocation
		-- Dathea Stormlash
		{371624, "SAY"}, -- Conductive Mark
		conductiveMarkMarker, -- (vs ICON, leave skull/cross for boss marking)
		372275, -- Chain Lightning
		386375, -- Storming Convocation
		-- Opalfang
		370991, -- Earthen Pillar
		{372056, "TANK"}, -- Crush
		386370, -- Quaking Convocation
		-- Embar Firepath
		{374043, "SAY", "SAY_COUNTDOWN"}, -- Meteor Axes
		372027, -- Slashing Blaze
		meteorAxeMarker,
		386289, -- Burning Convocation
	}, {
		[391599] = -24952, -- Kadros Icewrath
		[371624] = -24958, -- Dathea Stormlash
		[370991] = -24967, -- Opalfang
		[374043] = -24965, -- Embar Firepath
	}, {
		[371624] = L.conductive_mark, -- Conductive Mark (Mark)
	}
end

function mod:OnBossEnable()
	-- Kadros Icewrath
	self:Log("SPELL_CAST_START", "PrimalBlizzard", 373059)
	self:Log("SPELL_CAST_SUCCESS", "GlacialConvocation", 386440)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GlacialConvocationApplied", 386661)
	-- Dathea Stormlash
	self:Log("SPELL_CAST_SUCCESS", "ConductiveMark", 371624) -- please only cast on the initial target D;
	self:Log("SPELL_AURA_APPLIED", "ConductiveMarkApplied", 371624)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ConductiveMarkApplied", 371624)
	self:Log("SPELL_CAST_SUCCESS", "ChainLightning", 372275)
	self:Log("SPELL_CAST_SUCCESS", "StormingConvocation", 386375)
	-- Opalfang
	self:Log("SPELL_CAST_SUCCESS", "EarthenPillar", 370991)
	self:Log("SPELL_AURA_APPLIED", "CrushApplied", 372056)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrushApplied", 372056)
	self:Log("SPELL_CAST_SUCCESS", "QuakingConvocation", 386370)
	-- Embar Firepath
	self:Log("SPELL_CAST_START", "MeteorAxe", 374043)
	self:Log("SPELL_AURA_APPLIED", "MeteorAxeApplied", 374039) -- no cast log -_-;
	self:Log("SPELL_AURA_REMOVED", "MeteorAxeApplied", 374039)
	self:Log("SPELL_CAST_START", "SlashingBlaze", 372027)
	self:Log("SPELL_CAST_SUCCESS", "BurningConvocation", 386289)
end

function mod:OnEngage()
	blizzardCount = 1
	markCount = 1
	axeCount = 1
	slashCount = 1

	-- self:Bar(372056, 10) -- Crush
	-- self:Bar(372275, 15) -- Chain Lightning
	-- self:Bar(370991, 30) -- Earthen Pillar
	-- self:Bar(374043, 30, CL.count:format(self:SpellName(374043), axeCount))
	-- self:Bar(391599, 93, CL.count:format(self:SpellName(391599), blizzardCount))
	-- self:Bar(371624, 93, CL.count:format(self:SpellName(371624), markCount))
	-- self:Bar(372027, 93, CL.count:format(self:SpellName(372027), slashCount))
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Kadros Icewrath

function mod:PrimalBlizzard(args)
	self:StopBar(CL.count:format(args.spellName, blizzardCount))

	self:Message(391599, "cyan", CL.casting:format(CL.count:format(args.spellName, blizzardCount)))
	self:CastBar(391599, 13, CL.count:format(args.spellName, blizzardCount)) -- 3s cast + 10s channel
	self:PlaySound(391599, "alarm") -- spread
	blizzardCount = blizzardCount + 1
	-- self:Bar(391599, 96, CL.count:format(args.spellName, blizzardCount))
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

do
	local castTarget = nil
	local prev = 0
	function mod:ConductiveMark(args)
		if args.time - prev < 5 then return end
		prev = args.time
		self:StopBar(CL.count:format(args.spellName, markCount))

		castTarget = args.destName
		self:TargetMessage(args.spellId, "purple", args.destName, CL.count:format(args.spellName, markCount))
		markCount = markCount + 1
		if self:Me(args.destGUID) then
			self:Say(args.spellId, L.conductive_mark)
			self:PlaySound(args.spellId, "warning") -- debuffmove
		end
		self:CustomIcon(conductiveMarkMarker, args.destName, 3)
		-- self:Bar(args.spellId, 30, CL.count:format(args.spellName, markCount))
	end

	function mod:ConductiveMarkApplied(args)
		if self:Me(args.destGUID) and castTarget ~= args.destName then
			self:StackMessage(args.spellId, "blue", args.destName, args.amount, 0)
			self:PlaySound(args.spellId, "alarm") -- spread
		end
	end
end

function mod:ChainLightning(args)
	self:Message(args.spellId, "yellow")
	-- self:Bar(args.spellId, 15)
end

function mod:StormingConvocation(args)
	self:StopBar(CL.count:format(args.spellName, markCount))
	self:StopBar(372275) -- Chain Lightning

	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "info")
end

-- Opalfang

function mod:EarthenPillar(args)
	self:Message(args.spellId, "green")
	-- self:Bar(args.spellId, 30)
end

function mod:CrushApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 2)
	-- if (args.amount or 0) > 1 and self:Tank() and not self:Tanking("boss1") then
	-- 	self:PlaySound(args.spellId, "warning") -- tankswap
	-- end
	-- self:Bar(args.spellId, 20)
end

function mod:QuakingConvocation(args)
	self:StopBar(370991) -- Earthen Pillar
	self:StopBar(372056) -- Crush

	self:Message(args.spellId, "green")
	self:PlaySound(args.spellId, "info")
	-- every 10s, too much?
	-- local quaking = mod:SpellName(207863)
	-- self:Bar(args.spellId, 10, quaking)
	-- self:ScheduleRepeatingTimer("Bar", 10, args.spellId, quaking)
end

-- Embar Firepath

function mod:MeteorAxe(args)
	self:StopBar(CL.count:format(args.spellName, axeCount))
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alert") -- stack
	axeCount = axeCount + 1
	-- self:Bar(args.spellId, 30, CL.count:format(args.spellName, axeCount))
end

do
	local playerList = {}
	local prev = 0
	function mod:MeteorAxeApplied(args)
		if args.time - prev > 3 then
			prev = args.time
			playerList = {}
			-- self:Bar(374043, 30, CL.count:format(args.spellName, axeCount))
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(374043, CL.rticon:format(args.spellName, count))
			self:SayCountdown(374043, 6, count)
			self:PlaySound(374043, "warning") -- debuffmove
		end
		-- self:TargetsMessage(args.spellId, "red", playerList, 2, CL.count:format(args.spellName, axeCount-1))
		self:CustomIcon(meteorAxeMarker, args.destName, count)
	end

	function mod:MeteorAxeRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(374043)
		end
		self:CustomIcon(meteorAxeMarker, args.destName)
	end
end

function mod:SlashingBlaze(args)
	self:Message(args.spellId, "orange")
	if self:Tank() then
		self:PlaySound(args.spellId, "warning")
	end
	-- self:Bar(args.spellId, 96, CL.count:format(args.spellName, slashCount))
end

function mod:BurningConvocation(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "info")
end
