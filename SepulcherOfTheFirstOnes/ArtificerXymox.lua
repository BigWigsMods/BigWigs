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
local ringCount = 1
local wormholeCount = 1
local glyphCount = 1
local sparkCount = 1
local trapCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.traps = "Traps" -- Stasis Trap
	L.sparknova = "Sparknova" -- Hyperlight Sparknova
	L.relocation = "Tank Bomb" -- Glyph of Relocation
	L.wormholes = "Wormholes" -- Interdimensional Wormholes
	L.rings = "Rings P%d" -- Forerunner Rings // Added P1, P2, P3 etc to help identify what rings
end

--------------------------------------------------------------------------------
-- Initialization
--

local interdimensionalWormholesMarker = mod:AddMarkerOption(false, "player", 1, 362721, 1, 2) -- Interdimensional Wormholes
function mod:GetOptions()
	return {
		"stages",
		364465, -- Forerunner Rings
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
	self:Log("SPELL_AURA_APPLIED", "DecipherRelic", 363139)
	self:Log("SPELL_AURA_REMOVED", "DecipherRelicRemoved", 363139)
	self:Log("SPELL_CAST_SUCCESS", "ForerunnerRings", 364465)
	self:Log("SPELL_CAST_START", "HyperlightAscension", 364040)
	self:Log("SPELL_CAST_SUCCESS", "DebilitatingRay", 364030)
	self:Log("SPELL_CAST_SUCCESS", "InterdimensionalWormholes", 362721)
	self:Log("SPELL_AURA_APPLIED", "InterdimensionalWormholesApplied", 362615, 362614)
	self:Log("SPELL_AURA_REMOVED", "InterdimensionalWormholesRemoved", 362615, 362614)
	self:Log("SPELL_CAST_START", "GlyphOfRelocation", 362801)
	self:Log("SPELL_CAST_SUCCESS", "GlyphOfRelocationSuccess", 362801)
	self:Log("SPELL_AURA_APPLIED", "GlyphOfRelocationApplied", 362803)
	self:Log("SPELL_AURA_REMOVED", "GlyphOfRelocationRemoved", 362803)
	self:Log("SPELL_CAST_START", "HyperlightSparknova", 362849)
	self:Log("SPELL_CAST_SUCCESS", "StasisTrap", 362885)

	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:GROUP_ROSTER_UPDATE()
end

function mod:OnEngage()
	self:SetStage(1)
	ringCount = 1
	wormholeCount = 1
	glyphCount = 1
	sparkCount = 1
	trapCount = 1

	self:Bar(362721, 8, CL.count:format(L.wormholes, wormholeCount)) -- Interdimensional Wormholes
	self:Bar(362849, 14, CL.count:format(L.sparknova, sparkCount)) -- Hyperlight Sparknova
	self:Bar(362885, 21, CL.count:format(L.traps, trapCount)) -- Stasis Trap
	self:Bar(364465, 26, CL.count:format(L.rings:format(self:GetStage()), ringCount)) -- Forerunner Rings
	self:Bar(362803, 40, CL.count:format(L.relocation, glyphCount)) -- Glyph of Relocation
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

function mod:DecipherRelic()
	self:Message("stages", "cyan", CL.intermission, false)
	self:PlaySound("stages", "long")
	self:StopBar(CL.count:format(L.rings:format(self:GetStage()), ringCount)) -- Forerunner Rings
	self:StopBar(CL.count:format(L.wormholes, wormholeCount)) -- Interdimensional Wormholes
	self:StopBar(CL.count:format(L.relocation, glyphCount)) -- Glyph of Relocation
	self:StopBar(CL.count:format(L.sparknova, sparkCount)) -- Hyperlight Sparknova
	self:StopBar(CL.count:format(L.traps, trapCount)) -- Stasis Trap
end

function mod:DecipherRelicRemoved()
	local stage = self:GetStage() + 1
	self:Message("stages", "cyan", CL.stage:format(stage), false)
	self:PlaySound("stages", "info")
	self:SetStage(stage)

	-- Not resetting traps as they persist throughout the whole fight
	-- Not resetting wormholes as you get 1 per stage
	-- wormholeCount = 1
	-- trapCount = 1

	ringCount = 1
	glyphCount = 1
	sparkCount = 1

	self:Bar(362721, 8, CL.count:format(L.wormholes, wormholeCount)) -- Interdimensional Wormholes
	self:Bar(362849, 14, CL.count:format(L.sparknova, sparkCount)) -- Hyperlight Sparknova
	self:Bar(362885, 21, CL.count:format(L.traps, trapCount)) -- Stasis Trap
	self:Bar(364465, 26, CL.count:format(L.rings:format(self:GetStage()), ringCount)) -- Forerunner Rings
	self:Bar(362803, 40, CL.count:format(L.relocation, glyphCount)) -- Glyph of Relocation
end

function mod:ForerunnerRings(args)
	self:StopBar(CL.count:format(L.rings:format(self:GetStage()), ringCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.rings:format(self:GetStage()), ringCount))
	self:PlaySound(args.spellId, "alert")
	ringCount = ringCount + 1
	self:Bar(args.spellId, 30, CL.count:format(L.rings:format(self:GetStage()), ringCount))
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
		wormholeCount = wormholeCount + 1
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
		self:NewTargetsMessage(362721, "yellow", playerList, 2, CL.count:format(L.rings:format(self:GetStage()), wormholeCount-1))
	end

	function mod:InterdimensionalWormholesRemoved(args)
		self:CustomIcon(interdimensionalWormholesMarker, args.destName)
	end
end

function mod:GlyphOfRelocation(args)
	self:StopBar(CL.count:format(L.relocation, glyphCount))
	local bossUnit = self:GetBossId(args.sourceGUID)
	for i = 1, #tankList do
		local unit = tankList[i]
		if bossUnit and self:Tanking(bossUnit, unit) then
			self:TargetMessage(362803, "yellow", self:UnitName(unit), CL.casting:format(CL.count:format(L.relocation, glyphCount)))
			break
		elseif i == #tankList then
			self:Message(362803, "yellow", CL.casting:format(CL.count:format(L.relocation, glyphCount)))
		end
	end
	self:PlaySound(362803, "warning")
end

function mod:GlyphOfRelocationSuccess(args)
	glyphCount = glyphCount + 1
	self:CDBar(362803, 30, CL.count:format(L.relocation, glyphCount))
	-- XXX Timer for healers to explosion / update timer on applied
end

function mod:GlyphOfRelocationApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	self:PlaySound(args.spellId, "warning")
	self:TargetBar(args.spellId, 5, args.destName)
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
	self:StopBar(CL.count:format(L.sparknova, sparkCount))
	self:Message(args.spellId, "orange", CL.count:format(L.sparknova, sparkCount))
	self:PlaySound(args.spellId, "alert")
	sparkCount = sparkCount + 1
	self:Bar(args.spellId, 30, CL.count:format(L.sparknova, sparkCount))
end

function mod:StasisTrap(args)
	self:StopBar(CL.count:format(L.traps, trapCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.traps, trapCount))
	self:PlaySound(args.spellId, "alarm")
	trapCount = trapCount + 1
	self:Bar(args.spellId, 30, CL.count:format(L.traps, trapCount))
end
