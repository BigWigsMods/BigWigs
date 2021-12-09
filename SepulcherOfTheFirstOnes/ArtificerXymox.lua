if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Artificer Xy'mox v2", 2481, 2470)
if not mod then return end
mod:RegisterEnableMob(183501) -- Artificer Xy'mox -- New Model
mod:SetEncounterID(2553)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local tankList = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
end

--------------------------------------------------------------------------------
-- Initialization
--

local interdimensionalWormholesMarker = mod:AddMarkerOption(false, "player", 1, 362721, 1, 2) -- Interdimensional Wormholes
function mod:GetOptions()
	return {
		363413, -- Forerunner Rings
		363114, -- Ephemeral Supernova
		364040, -- Hyperlight Ascension
		364030, -- Debilitating Ray
		{362721, "SAY", "SAY_COUNTDOWN"}, -- Interdimensional Wormholes
		interdimensionalWormholesMarker,
		{362803, "SAY", "SAY_COUNTDOWN"}, -- Glyph of Relocation
		362849, -- Hyperlight Sparknova
		362885, -- Stasis Trap
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "ForerunnerRings", 363413)
	self:Log("SPELL_CAST_SUCCESS", "EphemeralSupernova", 363114)
	self:Log("SPELL_CAST_START", "HyperlightAscension", 364040)
	self:Log("SPELL_CAST_SUCCESS", "DebilitatingRay", 364030)
	self:Log("SPELL_CAST_SUCCESS", "InterdimensionalWormholes", 362721)
	self:Log("SPELL_AURA_APPLIED", "InterdimensionalWormholesApplied", 362615, 362614)
	self:Log("SPELL_AURA_REMOVED", "InterdimensionalWormholesRemoved", 362615, 362614)
	self:Log("SPELL_CAST_START", "GlyphOfRelocation", 362801)
	self:Log("SPELL_AURA_APPLIED", "GlyphOfRelocationApplied", 362803)
	self:Log("SPELL_AURA_REMOVED", "GlyphOfRelocationRemoved", 362803)
	self:Log("SPELL_CAST_START", "HyperlightSparknova", 362849)
	self:Log("SPELL_CAST_SUCCESS", "StasisTrap", 362885)

	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:GROUP_ROSTER_UPDATE()
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--


function mod:GROUP_ROSTER_UPDATE() -- Compensate for quitters (LFR)
	tankList = {}
	for unit in self:IterateGroup() do
		if self:Tank(unit) then
			tankList[#tankList+1] = unit
		end
	end
end

function mod:ForerunnerRings(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, duration)
end

function mod:EphemeralSupernova(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, duration)
end

function mod:HyperlightAscension(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:DebilitatingRay(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

do
	local playerList = {}
	function mod:InterdimensionalWormholes(args)
		playerList = {}
		--self:CDBar(328437, 20)
	end

	function mod:InterdimensionalWormholesApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(362721, CL.count_rticon:format(args.spellName, count, count))
			self:SayCountdown(362721, 8)
			self:PlaySound(362721, "warning")
		end
		self:CustomIcon(interdimensionalWormholesMarker, args.destName, count)
		self:NewTargetsMessage(362721, "yellow", playerList, 2)
	end

	function mod:InterdimensionalWormholesRemoved(args)
		self:CustomIcon(interdimensionalWormholesMarker, args.destName)
	end
end

function mod:GlyphOfRelocation(args)
	local bossUnit = self:GetBossId(args.sourceGUID)
	for i = 1, #tankList do
		local unit = tankList[i]
		if bossUnit and self:Tanking(bossUnit, unit) then
			self:TargetMessage(362803, "yellow", self:UnitName(unit), CL.casting:format(args.spellName))
			break
		elseif i == #tankList then
			self:Message(362803, "yellow", CL.casting:format(args.spellName))
		end
	end
	self:PlaySound(362803, "warning")
	self:StopBar(362803)
	--self:CDBar(362803, 10)
end

function mod:GlyphOfRelocationApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	self:PlaySound(args.spellId, "warning")
	self:TargetBar(args.spellId, self:Easy() and 8 or 4, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 5)
	end
end

function mod:GlyphOfRelocationRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:HyperlightSparknova(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, duration)
end

function mod:StasisTrap(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, duration)
end
