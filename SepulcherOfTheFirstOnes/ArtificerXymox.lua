--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Artificer Xy'mox v2", 2481, 2470)
if not mod then return end
mod:RegisterEnableMob(183501) -- Artificer Xy'mox -- New Model
mod:SetEncounterID(2553)
mod:SetRespawnTime(25)

--------------------------------------------------------------------------------
-- Locals
--

local ringCount = 1
local wormholeCount = 1
local glyphCount = 1
local sparkCount = 1
local trapCount = 1
local nextStageWarning = 77
local mobCollector = {}
local mobCount = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.traps = "Traps" -- Stasis Trap
	L.sparknova = "Sparknova" -- Hyperlight Sparknova
	L.relocation = "Tank Bomb" -- Glyph of Relocation
	L.relocation_count = "%s P%d (%d)" -- Tank Bomb (stage)(count)
	L.wormholes = "Wormholes" -- Dimensional Tear
	L.wormhole = "Wormhole"
	L.rings = "Rings P%d" -- Forerunner Rings // Added P1, P2, P3 etc to help identify what rings
end

--------------------------------------------------------------------------------
-- Initialization
--

local interdimensionalWormholesMarker = mod:AddMarkerOption(false, "player", 1, 362721, 1, 2) -- Dimensional Tear
local acolyteMarker = mod:AddMarkerOption(false, "npc", 8, -24270, 8, 7) -- Xy Acolyte
local spellslingerMarker = mod:AddMarkerOption(false, "npc", 1, -24271, 1, 2, 3) -- Xy Spellslinger
local overseerMarker = mod:AddMarkerOption(false, "npc", 8, -24450, 8, 7) -- Cartel Overseer
function mod:GetOptions()
	return {
		"stages",
		364465, -- Forerunner Rings
		{362721, "SAY", "SAY_COUNTDOWN"}, -- Dimensional Tear
		interdimensionalWormholesMarker,
		{362803, "SAY", "SAY_COUNTDOWN"}, -- Glyph of Relocation
		362885, -- Stasis Trap
		362849, -- Hyperlight Sparknova
		365681, -- Massive Blast
		364040, -- Hyperlight Ascension
		acolyteMarker,
		364030, -- Debilitating Ray
		spellslingerMarker,
		363485, -- The Cartel Elite
		overseerMarker,
		-- 365701, -- Overseer's Orders
	},{
		[365681] = CL.intermission,
		[363485] = CL.mythic,
	},{
		[364465] = L.rings:format(1), -- Forerunner Rings (Rings)
		[362721] = L.wormholes, -- Dimensional Tear (Wormholes)
		[362803] = L.relocation, -- Glyph of Relocation (Tank Bomb)
		[362849] = L.sparknova, -- Hyperlight Sparknova (Sparknova)
		[362885] = L.traps, -- Stasis Trap (Traps)
		[363485] = CL.adds,
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "DecipherRelicSuccess", 367711) -- Stage 4
	self:Log("SPELL_AURA_APPLIED", "DecipherRelic", 363139)
	self:Log("SPELL_AURA_REMOVED", "DecipherRelicRemoved", 363139)
	self:Log("SPELL_CAST_SUCCESS", "ForerunnerRings", 364465)
	self:Log("SPELL_CAST_START", "HyperlightAscension", 364040)
	self:Log("SPELL_CAST_SUCCESS", "DebilitatingRay", 364030)
	self:Log("SPELL_CAST_SUCCESS", "InterdimensionalWormholes", 362721)
	self:Log("SPELL_AURA_APPLIED", "InterdimensionalWormholesApplied", 362615, 362614)
	self:Log("SPELL_AURA_REMOVED", "InterdimensionalWormholesRemoved", 362615, 362614)
	self:Log("SPELL_AURA_APPLIED", "GlyphOfRelocationApplied", 362803)
	self:Log("SPELL_AURA_REMOVED", "GlyphOfRelocationRemoved", 362803)
	self:Log("SPELL_CAST_START", "HyperlightSparknova", 362849)
	self:Log("SPELL_CAST_SUCCESS", "StasisTrap", 362885)
	-- self:Log("SPELL_CAST_START", "XyDecipherers", 363485) -- using RAID_BOSS_EMOTE
	self:Log("SPELL_CAST_START", "MassiveBlast", 365682)
	self:Log("SPELL_AURA_APPLIED", "MassiveBlastApplied", 365681)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MassiveBlastApplied", 365681)
	-- self:Log("SPELL_CAST_START", "OverseersOrders", 365701)
end

function mod:OnEngage()
	self:SetStage(1)
	ringCount = 1
	wormholeCount = 1
	glyphCount = 1
	sparkCount = 1
	trapCount = 1
	nextStageWarning = 77
	mobCollector = {}
	mobCount = {}

	if self:Mythic() then
		self:RegisterEvent("RAID_BOSS_EMOTE") -- for adds
		self:Bar(363485, 13.6, CL.adds) -- The Cartel Elite
	end
	self:Bar(362721, self:Mythic() and 9 or 8, CL.count:format(L.wormholes, wormholeCount)) -- Dimensional Tear
	self:Bar(362849, self:Mythic() and 15.5 or 14, CL.count:format(L.sparknova, sparkCount)) -- Hyperlight Sparknova
	self:Bar(362885, self:Mythic() and 23.3 or 21, CL.count:format(L.traps, trapCount)) -- Stasis Trap
	self:Bar(364465, self:Mythic() and 29 or 26, CL.count:format(L.rings:format(self:GetStage()), ringCount)) -- Forerunner Rings
	self:Bar(362803, self:Mythic() and 44.5 or 40, L.relocation_count:format(L.relocation, self:GetStage(), glyphCount)) -- Glyph of Relocation

	if self:GetOption(spellslingerMarker) or (self:Mythic() and self:GetOption(overseerMarker)) then
		self:RegisterTargetEvents("MarkAdds")
	end
	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	local currentHealth = self:GetHealth(unit)
	if currentHealth < nextStageWarning then -- Intermission at 75% and 50%, Different timers at 30%
		if currentHealth > 35 then
			self:Message("stages", "green", CL.soon:format(CL.intermission), false)
		else
			self:Message("stages", "green", CL.soon:format(CL.stage:format(4)), false)
		end
		self:PlaySound("stages", "info")
		nextStageWarning = nextStageWarning - 25
		if nextStageWarning < 10 then
			self:UnregisterUnitEvent(event, unit)
		elseif nextStageWarning < 50 then
			nextStageWarning = 32
		end
	end
end

function mod:MarkAcolytes()
	for boss = 1, 5 do
		local unit = ("boss%d"):format(boss)
		local guid = self:UnitGUID(unit)
		local id = self:MobId(guid)
		if id == 184140 and not mobCollector[guid] then
			self:CustomIcon(acolyteMarker, unit, 8 - (mobCount[id] or 0)) -- 8, 7
			mobCount[id] = (mobCount[id] or 0) + 1
			mobCollector[guid] = true
		end
	end
end

function mod:MarkAdds(event, unit, guid)
	if not mobCollector[guid] then
		local id = self:MobId(guid)
		if id == 183707 and self:GetOption(spellslingerMarker) then -- Xy Spellslinger
			mobCount[id] = (mobCount[id] or 0) + 1
			self:CustomIcon(spellslingerMarker, unit, mobCount[id]) -- 1, 2, 3
			mobCollector[guid] = true
		elseif id == 184792 and self:GetOption(overseerMarker) then -- Cartel Overseer
			self:CustomIcon(overseerMarker, unit, 8 - (mobCount[id] or 0)) -- 8, 7
			mobCount[id] = (mobCount[id] or 0) + 1
			mobCollector[guid] = true
		end
	end
end

function mod:DecipherRelicSuccess() -- Stage 4
	self:StopBar(CL.count:format(L.rings:format(self:GetStage()), ringCount)) -- Forerunner Rings
	self:StopBar(CL.count:format(L.wormholes, wormholeCount)) -- Interdimensional Wormholes
	self:StopBar(L.relocation_count:format(L.relocation, self:GetStage(), glyphCount)) -- Glyph of Relocation
	self:StopBar(CL.count:format(L.sparknova, sparkCount)) -- Hyperlight Sparknova
	self:StopBar(CL.count:format(L.traps, trapCount)) -- Stasis Trap

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

	if self:Mythic() then
		self:Bar(363485, 12.3, CL.adds) -- The Cartel Elite
	end
	self:Bar(362849, 15.6, CL.count:format(L.sparknova, sparkCount)) -- Hyperlight Sparknova
	self:Bar(362721, 22.2, CL.count:format(L.wormholes, wormholeCount)) -- Interdimensional Wormholes
	self:Bar(362885, 23.3, CL.count:format(L.traps, trapCount)) -- Stasis Trap
	self:Bar(364465, 28.9, CL.count:format(L.rings:format(self:GetStage()), ringCount)) -- Forerunner Rings
	self:Bar(362803, 44.5, L.relocation_count:format(L.relocation, self:GetStage(), glyphCount)) -- Glyph of Relocation
end

function mod:DecipherRelic()
	self:Message("stages", "cyan", CL.intermission, false)
	self:PlaySound("stages", "long")
	self:StopBar(CL.count:format(L.rings:format(self:GetStage()), ringCount)) -- Forerunner Rings
	self:StopBar(CL.count:format(L.wormholes, wormholeCount)) -- Interdimensional Wormholes
	self:StopBar(L.relocation_count:format(L.relocation, self:GetStage(), glyphCount)) -- Glyph of Relocation
	self:StopBar(CL.count:format(L.sparknova, sparkCount)) -- Hyperlight Sparknova
	self:StopBar(CL.count:format(L.traps, trapCount)) -- Stasis Trap
	if self:GetOption(acolyteMarker) then
		self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "MarkAcolytes")
	end
end

function mod:DecipherRelicRemoved()
	local stage = self:GetStage() + 1
	self:Message("stages", "cyan", CL.stage:format(stage), false)
	self:PlaySound("stages", "info")
	self:SetStage(stage)

	if self:GetOption(acolyteMarker) then
		self:UnregisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	end
	mobCount = {}

	-- Not resetting traps as they persist throughout the whole fight
	-- Not resetting wormholes as you get 1 per stage
	-- wormholeCount = 1
	-- trapCount = 1

	ringCount = 1
	glyphCount = 1
	sparkCount = 1

	if self:Mythic() then
		self:Bar(363485, 12.3, CL.adds) -- The Cartel Elite
	end
	self:Bar(362721, 8, CL.count:format(L.wormholes, wormholeCount)) -- Interdimensional Wormholes
	self:Bar(362849, 14, CL.count:format(L.sparknova, sparkCount)) -- Hyperlight Sparknova
	self:Bar(362885, 21, CL.count:format(L.traps, trapCount)) -- Stasis Trap
	self:Bar(364465, 26, CL.count:format(L.rings:format(self:GetStage()), ringCount)) -- Forerunner Rings
	self:Bar(362803, 45, L.relocation_count:format(L.relocation, self:GetStage(), glyphCount)) -- Glyph of Relocation
end

function mod:ForerunnerRings(args)
	self:StopBar(CL.count:format(L.rings:format(self:GetStage()), ringCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.rings:format(self:GetStage()), ringCount))
	self:PlaySound(args.spellId, "alert")
	ringCount = ringCount + 1
	self:Bar(args.spellId, self:GetStage() == 4 and 33.3 or 30, CL.count:format(L.rings:format(self:GetStage()), ringCount))
end

do
	local prev = 0
	function mod:HyperlightAscension(args)
		if prev + 2 < args.time then
			prev = args.time
			self:Message(args.spellId, "red")
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:DebilitatingRay(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		local icon = CombatLog_String_GetIcon(args.sourceRaidFlags)
		self:Message(args.spellId, "yellow", icon .. args.spellName)
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
			self:Say(362721, CL.count_rticon:format(L.wormhole, count, count))
			self:SayCountdown(362721, 8, count)
			self:PlaySound(362721, "warning")
		end
		self:CustomIcon(interdimensionalWormholesMarker, args.destName, count)
		self:NewTargetsMessage(362721, "yellow", playerList, 2, CL.count:format(L.wormhole, wormholeCount-1))
	end

	function mod:InterdimensionalWormholesRemoved(args)
		self:CustomIcon(interdimensionalWormholesMarker, args.destName)
	end
end

function mod:GlyphOfRelocationApplied(args)
	self:StopBar(L.relocation_count:format(L.relocation, self:GetStage(), glyphCount))
	self:TargetMessage(args.spellId, "purple", args.destName, L.relocation_count:format(L.relocation, self:GetStage(), glyphCount))
	self:PlaySound(args.spellId, "warning")
	self:TargetBar(args.spellId, 5, args.destName, CL.bomb)
	if self:Me(args.destGUID) then
		self:Say(args.spellId, CL.bomb)
		self:SayCountdown(args.spellId, 5)
	end
	glyphCount = glyphCount + 1
	self:CDBar(362803, self:GetStage() == 4 and 40 or 66.5, L.relocation_count:format(L.relocation, self:GetStage(), glyphCount))
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
	self:Bar(args.spellId, self:GetStage() == 4 and 33.3 or 30, CL.count:format(L.sparknova, sparkCount))
end

function mod:StasisTrap(args)
	self:StopBar(CL.count:format(L.traps, trapCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.traps, trapCount))
	self:PlaySound(args.spellId, "alarm")
	trapCount = trapCount + 1
	self:Bar(args.spellId, self:GetStage() == 4 and 33.3 or 30, CL.count:format(L.traps, trapCount))
end

function mod:RAID_BOSS_EMOTE(_, msg)
	if msg:find("363485", nil, true) then -- The Cartel Elite
		self:Message(363485, "red", CL.incoming:format(CL.adds))
		self:PlaySound(363485, "alert")
	end
end

function mod:MassiveBlast(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		local icon = CombatLog_String_GetIcon(args.sourceRaidFlags)
		self:Message(365681, "purple", icon .. args.spellName)
		if self:Tank() then
			self:PlaySound(365681, "alarm")
		elseif ready then
			self:PlaySound(365681, "alert")
		end
	end
end

function mod:MassiveBlastApplied(args)
	self:NewStackMessage(args.spellId, "purple", args.destName, args.amount, 2)
end

-- function mod:OverseersOrders(args)
-- 	self:Message(args.spellId, "yellow")
-- 	self:PlaySound(args.spellId, "alert")
-- end
