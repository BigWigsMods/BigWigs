if not IsTestBuild() then return end
-- XXX Add counts!
-- XXX Not Molten Rupture cast event

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kurog Grimtotem", 2522, 2491)
if not mod then return end
mod:RegisterEnableMob(184986) -- Kurog Grimtotem
mod:SetEncounterID(2605)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--


--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
end

--------------------------------------------------------------------------------
-- Initialization
--

-- local searingCarnageMarker = mod:AddMarkerOption(false, "player", 1, 374023, 1, 2, 3)
local aboluteZeroMarker = mod:AddMarkerOption(false, "player", 1, 372458, 1, 2)
local envelopingEarthMarker = mod:AddMarkerOption(false, "player", 1, 391056, 1, 2, 3)
local lightningCrashMarker = mod:AddMarkerOption(false, "player", 1, 373487, 1, 2, 3)
local shockingBurstMarker = mod:AddMarkerOption(false, "player", 4, 390920, 4, 5)
local groundShatterMarker = mod:AddMarkerOption(false, "player", 1, 374427, 1, 2, 3)
function mod:GetOptions()
	return {
		371971, -- Elemental Surge
		374861, -- Elemental Shift
		{372158, "TANK"}, -- Sundering Strike
		-- Fire Altar
		374881, -- Blistering Dominance
		{382563, "SAY", "SAY_COUNTDOWN"}, -- Magma Burst
		373329, -- Molten Rupture
		374023, -- Searing Carnage
		-- searingCarnageMarker,
		-- Frost Altar
		374916, -- Chilling Dominance
		373678, -- Biting Chill
		391019, -- Frigid Torrent
		{372458, "SAY", "SAY_COUNTDOWN"}, -- Absolute Zero
		aboluteZeroMarker,
		-- Earthen Altar
		374917, -- Shattering Dominance
		391056, -- Enveloping Earth
		envelopingEarthMarker,
		390796, -- Erupting Bedrock
		374705, -- Seismic Rupture
		-- Storm Altar
		374918, -- Thundering Dominance
		{373487, "SAY", "SAY_COUNTDOWN"}, -- Lightning Crash
		{390920, "SAY", "SAY_COUNTDOWN"}, -- Shocking Burst
		shockingBurstMarker,
		374217, -- Thunder Strike
		-- Stage 2
		374779, -- Primal Barrier
		{374321, "TANK"}, -- Breaking Gravel
		{374427, "SAY", "SAY_COUNTDOWN"}, -- Ground Shatter
		groundShatterMarker,
		374430, -- Violent Upheaval
		374624, -- Freezing Tempest
		391696, -- Lethal Current
	}, {
		[371971] = -25036, -- Stage 1
		[374881] = -25040, -- Fire Altar
		[373678] = -25061, -- Frost Altar
		[374917] = -25064, -- Earthen Altar
		[374918] = -25068, -- Storm Altar
		[374779] = -25071, -- Stage 2
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "ElementalShift", 374861)
	self:Log("SPELL_AURA_APPLIED", "PrimalBarrierApplied", 374779)
	self:Log("SPELL_AURA_REMOVED", "PrimalBarrierRemoved", 374779)
	self:Log("SPELL_AURA_APPLIED", "Dominance", 374881, 374916, 374917, 374918) -- Blistering, Chilling, Shattering, Thundering
	self:Log("SPELL_AURA_APPLIED_DOSE", "Dominance", 374881, 374916, 374917, 374918)

	self:Log("SPELL_AURA_APPLIED", "SunderingStrikeApplied", 372158)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SunderingStrikeApplied", 372158)
	-- Fire
	self:Log("SPELL_CAST_START", "MagmaBurst", 382563)
	self:Log("SPELL_CAST_START", "MoltenRupture", 373329)
	self:Log("SPELL_AURA_APPLIED", "SearingCarnage", 374022)
	-- self:Log("SPELL_AURA_APPLIED", "SearingCarnageApplied", 374023)
	-- self:Log("SPELL_AURA_REMOVED", "SearingCarnageRemoved", 374023)
	-- Frost
	self:Log("SPELL_CAST_START", "BitingChill", 373678)
	self:Log("SPELL_CAST_START", "FrigidTorrent", 391019)
	self:Log("SPELL_CAST_START", "AbsoluteZero", 372456)
	self:Log("SPELL_AURA_APPLIED", "AbsoluteZeroApplied", 372458)
	self:Log("SPELL_AURA_REMOVED", "AbsoluteZeroRemoved", 372458)
	-- Earthen
	self:Log("SPELL_AURA_APPLIED", "EnvelopingEarthApplied", 391056)
	self:Log("SPELL_AURA_REMOVED", "EnvelopingEarthRemoved", 391056)
	self:Log("SPELL_CAST_START", "EruptingBedrock", 390796)
	self:Log("SPELL_CAST_START", "SeismicRupture", 374705)
	-- Storm
	self:Log("SPELL_AURA_APPLIED", "LightningCrashApplied", 373487)
	self:Log("SPELL_AURA_REMOVED", "LightningCrashRemoved", 373487)
	self:Log("SPELL_AURA_APPLIED", "ShockingBurstApplied", 390920)
	self:Log("SPELL_AURA_REMOVED", "ShockingBurstRemoved", 390920)
	self:Log("SPELL_CAST_SUCCESS", "ThunderStrike", 374217)
	-- Stage 2
	-- Tectonic Crusher
	self:Log("SPELL_AURA_APPLIED_DOSE", "BreakingGravelApplied", 374321)
	self:Log("SPELL_AURA_APPLIED", "GroundShatterApplied", 374427)
	self:Log("SPELL_AURA_REMOVED", "GroundShatterRemoved", 374427)
	self:Log("SPELL_CAST_START", "ViolentUpheaval", 374430)
	-- Frozen Destroyer
	self:Log("SPELL_CAST_START", "FreezingTempest", 374624)
	self:Log("SPELL_AURA_APPLIED", "LethalCurrentApplied", 391696)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ElementalShift(args)
	-- self:Message(args.spellId, "cyan")
	-- self:PlaySound(args.spellId, "long")
	-- self:Bar(args.spellId, 40)

	-- which?
	-- self:Bar(372158, 15) -- Sundering Strike
	-- self:Bar(382563, 30) -- Magma Burst
	-- self:Bar(373329, 30) -- Molten Rupture

	-- self:Bar(373678, 30) -- Biting Chill
	-- self:Bar(391019, 30) -- Frigid Torrent
	-- self:Bar(372456, 30) -- Absolute Zero

	-- self:Bar(391056, 30) -- Enveloping Earth
	-- self:Bar(390796, 30) -- Erupting Bedrock
	-- self:Bar(374705, 30) -- Seismic Rupture

	-- self:Bar(373487, 30) -- Lightning Crash

end

function mod:PrimalBarrierApplied(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long") -- phase
end

function mod:PrimalBarrierRemoved(args)
	self:Message(args.spellId, "green", CL.over:format(args.spellName))
	self:PlaySound(args.spellId, "long") -- phase
end

function mod:Dominance(args)
	-- self:StackMessage(args.spellId, "cyan", args.destName, args.amount, 0)
	-- self:PlaySound(args.spellId, "info")
end

function mod:SunderingStrikeApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 2)
	self:PlaySound(args.spellId, "warning")
	self:Bar(args.spellId, 30)
end

-- Fire

function mod:MagmaBurst(args)
	self:Message(args.spellId, "orange", CL.casting:format(args.spellName))
end

function mod:MoltenRupture(args)
	self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "info")
end

-- do
-- 	local playerList = {}
-- 	local prev = 0
-- 	function mod:SearingCarnageApplied(args)
-- 		if args.time - prev > 3 then
-- 			prev = args.time
-- 			playerList = {}
-- 			-- self:Bar(args.spellId, 30)
-- 		end
-- 		local count = #playerList+1
-- 		playerList[count] = args.destName
-- 		playerList[args.destName] = count -- Set raid marker
-- 		if self:Me(args.destGUID) then
-- 			self:Say(args.spellId)
-- 			self:SayCountdown(args.spellId, 5, count)
-- 			self:PlaySound(args.spellId, "warning") -- debuffmove
-- 		end
-- 		self:TargetsMessage(args.spellId, "yellow", playerList, 0)
-- 		self:CustomIcon(searingCarnageMarker, args.destName, count)
-- 	end

-- 	function mod:SearingCarnageRemoved(args)
-- 		if self:Me(args.destGUID) then
-- 			self:CancelSayCountdown(args.spellId)
-- 		end
-- 		self:CustomIcon(searingCarnageMarker, args.destName)
-- 	end
-- end

function mod:SearingCarnage(args)
	self:Message(374023, "orange")
	self:PlaySound(374023, "warning")
end

-- Frost Altar

function mod:BitingChill(args)
	self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 13) -- 3s cast + 10s duration
	self:Bar(args.spellId, 30)
end

function mod:FrigidTorrent(args)
	self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
	self:PlaySoud(args.spellId, "info")
	self:Bar(args.spellId, 61)
end

function mod:AbsoluteZero(args)
	self:Message(372458, "orange", CL.casting:format(args.spellName))
	self:PlaySound(372458, "alert") -- stack
end

do
	local playerList = {}
	local prev = 0
	function mod:AbsoluteZeroApplied(args)
		if args.time - prev > 3 then
			prev = args.time
			playerList = {}
			-- self:Bar(args.spellId, 30)
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 5, count)
			self:PlaySound(args.spellId, "warning") -- debuffmove
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, 0)
		self:CustomIcon(aboluteZeroMarker, args.destName, count)
	end

	function mod:AbsoluteZeroRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(aboluteZeroMarker, args.destName)
	end
end

-- Earth Altar

do
	local playerList = {}
	local prev = 0
	function mod:EnvelopingEarthApplied(args)
		if args.time - prev > 3 then
			prev = args.time
			playerList = {}
			if self:Healer() then
				self:PlaySound(args.spellId, "alert") -- debuffheal
			end
			self:Bar(args.spellId, 30)
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) and not self:Healer() then
			self:PlaySound(args.spellId, "alarm") -- debuffdamage
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, 0)
		self:CustomIcon(envelopingEarthMarker, args.destName, count)
	end

	function mod:EnvelopingEarthRemoved(args)
		self:CustomIcon(envelopingEarthMarker, args.destName)
	end
end

function mod:EruptingBedrock(args)
	self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 30)
end

function mod:SeismicRupture(args)
	self:Message(args.spellId, "orange", CL.casting:format(args.spellName))
	-- self:PlaySound(args.spellId, "warning")
	-- self:Bar(args.spellId, 30)
end

-- Storm Altar

do
	local playerList = {}
	local prev = 0
	function mod:LightningCrashApplied(args)
		if args.time - prev > 3 then
			prev = args.time
			playerList = {}
			self:Bar(args.spellId, 30)
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 4, count)
			self:PlaySound(args.spellId, "warning") -- debuffmove
		end
		self:TargetsMessage(args.spellId, "orange", playerList, 0)
		self:CustomIcon(lightningCrashMarker, args.destName, count)
	end

	function mod:LightningCrashRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(lightningCrashMarker, args.destName)
	end
end

do
	local playerList = {}
	local prev = 0
	function mod:ShockingBurstApplied(args)
		if args.time - prev > 3 then
			prev = args.time
			playerList = {}
			self:Bar(args.spellId, 67.1)
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count + 3 -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 5, count)
			self:PlaySound(args.spellId, "warning") -- debuffmove
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, 0)
		self:CustomIcon(shockingBurstMarker, args.destName, count)
	end

	function mod:ShockingBurstRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(shockingBurstMarker, args.destName)
	end
end

function mod:ThunderStrike(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId)
	self:Bar(args.spellId, 67)
end

-- Stage 2

function mod:BreakingGravelApplied(args)
	if args.amount % 3 == 0 then
		self:StackMessage(args.spellId, "purple", args.destName, args.amount, 0)
		self:PlaySound(args.spellId, "info")
	end
end

do
	local playerList = {}
	local prev = 0
	function mod:GroundShatterApplied(args)
		if args.time - prev > 3 then
			prev = args.time
			playerList = {}
			self:Bar(args.spellId, 34)
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 5, count)
			self:PlaySound(args.spellId, "warning") -- debuffmove
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, 0)
		self:CustomIcon(groundShatterMarker, args.destName, count)
	end

	function mod:GroundShatterRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(groundShatterMarker, args.destName)
	end
end

function mod:ViolentUpheaval(args)
	self:Message(args.spellId, "orange", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alarm") -- castmove
	self:Bar(args.spellId, 34)
end

function mod:FreezingTempest(args)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "warning") -- danger
end

function mod:LethalCurrentApplied(args)
	self:TargetMessage(args.spellId, "yellow", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning") -- debuffmove
	end
	self:Bar(args.spellId, 20)
end
