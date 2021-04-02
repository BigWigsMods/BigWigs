
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Artificer Xy'mox", 2296, 2418)
if not mod then return end
mod:RegisterEnableMob(166644) -- Artificer Xy'mox
mod:SetEncounterID(2405)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local dimensionalTearCount = 1
local spiritCount = 1
local seedCount = 1
local annihilateCount = 1
local sparkCount = 1
local glyphCount = 1
local trapCount = 1
local lastStaged = 0
local playerListSpirits = {}
local tankList = {}

local stage3MythicTimers = {
	[340758] = {34.3, 60, 92.1, 78.2}, -- Spirits
	[340788] = {32.3, 70, 81.1, 71.2}, -- Seeds
	[328789] = {28.3, 73, 72, 88} -- Annihilate
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.tear = "Tear" -- Short for Dimensional Tear
	L.spirits = "Spirits" -- Short for Fleeting Spirits
	L.seeds = "Seeds" -- Short for Seeds of Extinction
end

--------------------------------------------------------------------------------
-- Initialization
--

local dimensionalTearMarker = mod:AddMarkerOption(false, "player", 1, 328437, 1, 2) -- Dimensional Tear
function mod:GetOptions()
	return {
		-- General
		"stages",
		{328437, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Dimensional Tear
		dimensionalTearMarker,
		{325236, "TANK_HEALER", "SAY", "SAY_COUNTDOWN"}, -- Glyph of Destruction
		326271, -- Stasis Trap
		335013, -- Rift Blast
		325399, -- Hyperlight Spark
		-- The Relics of Castle Nathria
		340758, -- Fleeting Spirits
		{327902, "ME_ONLY_EMPHASIZE"}, -- Fixate
		327414, -- Possesion
		340788, -- Seeds of Extinction
		329107, -- Extinction
		340860, -- Withering Touch
		328789, -- Annihilate
	},{
		[328437] = "general",
		[340758] = -22119, -- The Relics of Castle Nathria
	},{
		[328437] = L.tear, -- Dimensional Tear (Tear)
		[325236] = CL.bomb, -- Glyph of Destruction (Bomb)
		[326271] = CL.traps, -- Stasis Trap (Traps)
		[340758] = L.spirits, -- Fleeting Spirits (Spirits)
		[327902] = CL.fixate, -- Fixate (Fixate)
		[340788] = L.seeds, -- Seeds of Extinction (Seeds)
		[329107] = CL.explosion, -- Extinction (Explosion)
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("RAID_BOSS_EMOTE") -- Used for Relics
	self:Log("SPELL_CAST_SUCCESS", "EncounterEvent", 181089) -- Stage changes

	self:Log("SPELL_CAST_SUCCESS", "DimensionalTear", 328437, 342310)
	self:Log("SPELL_AURA_APPLIED", "DimensionalTearApplied", 328448, 328468)
	self:Log("SPELL_AURA_REMOVED", "DimensionalTearRemoved", 328448, 328468)
	self:Log("SPELL_CAST_START", "GlyphOfDestruction", 325361)
	self:Log("SPELL_AURA_APPLIED", "GlyphOfDestructionApplied", 325236)
	self:Log("SPELL_AURA_REMOVED", "GlyphOfDestructionRemoved", 325236)
	self:Log("SPELL_CAST_SUCCESS", "StasisTrap", 326271)
	self:Log("SPELL_CAST_START", "RiftBlast", 335013)
	self:Log("SPELL_CAST_SUCCESS", "HyperlightSpark", 325399)

	-- The Relics of Castle Nathria
	--self:Log("SPELL_CAST_START", "FleetingSpirits", 327887, 340758) -- Crystal of Phantasms, Fleeting Spirits // First wave, Others
	self:Log("SPELL_AURA_APPLIED", "Fixate", 327902)
	self:Log("SPELL_AURA_APPLIED", "PossesionApplied", 327414)
	--self:Log("SPELL_CAST_START", "SeedsofExtinction", 329770, 340788) -- Root of Extinction, Seeds of Extinction // First wave, Others
	self:Log("SPELL_CAST_START", "Extinction", 329107)
	self:Log("SPELL_AURA_APPLIED", "WitheringTouchApplied", 340860)
	--self:Log("SPELL_CAST_START", "Annihilate", 328789)

	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:GROUP_ROSTER_UPDATE()
end

function mod:OnEngage()
	dimensionalTearCount = 1
	spiritCount = 1
	seedCount = 1
	annihilateCount = 1
	sparkCount = 1
	glyphCount = 1
	trapCount = 1
	lastStaged = 0
	self:SetStage(1)

	self:Bar(325399, 5.5, CL.count:format(self:SpellName(325399), sparkCount)) -- Hyperlight Spark
	if not self:Easy() then -- No traps in Normal (and LFR?)
		self:Bar(326271, 11, CL.count:format(CL.traps, trapCount)) -- Stasis Trap
	end
	self:Bar(328437, 17, CL.count:format(L.tear, dimensionalTearCount)) -- Dimensional Tear
	self:Bar(335013, 21) -- Rift Blast
	self:Bar(325236, 31, CL.count:format(self:SpellName(325236), glyphCount)) -- Glyph of Destruction
	self:Bar(340758, 25, CL.count:format(L.spirits, spiritCount)) -- Fleeting Spirit
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

function mod:RAID_BOSS_EMOTE(_, msg)
	local t = GetTime()
	local allowTimers = true
	if t-lastStaged < 20 then
		-- In Mythic, if the boss started a combo he will finish it with all 3.
		-- So emote 1 can be before the stage change, while 2 and 3 are after.
		-- We filter out any new timers and count with this by not allowin timers for 20s after a stage change
		allowTimers = false
	end
	if msg:find("327887", nil, true) then -- Spirits
		playerListSpirits = {}
		self:Message(340758, "cyan", CL.count:format(L.spirits, spiritCount))
		self:PlaySound(340758, "long")
		if allowTimers then
			spiritCount = spiritCount + 1
			local cd = 42.5
			if self:GetStage() == 2 then -- Mythic only
				cd = 61.2
			elseif self:GetStage() == 3 then
				cd = stage3MythicTimers[340758][spiritCount]
			end
			self:CDBar(340758, cd, CL.count:format(L.spirits, spiritCount))
		end
	elseif msg:find("329834", nil, true) then -- Seeds
		self:Message(340788, "cyan", CL.count:format(L.seeds, seedCount))
		self:PlaySound(340788, "long")
		if allowTimers then
			seedCount = seedCount + 1
			local cd = self:Mythic() and 55.5 or seedCount == 2 and 51 or 41
			if self:GetStage() == 3 then -- Mythic only
				cd = stage3MythicTimers[340788][seedCount]
			end
			self:Bar(340788, cd, CL.count:format(L.seeds, seedCount))
		end
	elseif msg:find("328789", nil, true) then -- Annihilate
		local spellName = self:SpellName(328789)
		self:Message(328789, "orange", CL.count:format(spellName, annihilateCount))
		self:PlaySound(328789, "warning")
		self:CastBar(328789, 10, CL.count:format(spellName, annihilateCount))
		if allowTimers then
			annihilateCount = annihilateCount + 1
			self:CDBar(328789, self:Mythic() and stage3MythicTimers[328789][annihilateCount] or 52, CL.count:format(spellName, annihilateCount))
		end
	end
end

function mod:EncounterEvent() -- Stage changes
	local prevStage = self:GetStage()
	local nextStage = prevStage + 1
	if nextStage == 2 then
		self:StopBar(CL.count:format(CL.traps, trapCount)) -- Stasis Trap
		self:StopBar(CL.count:format(L.tear, dimensionalTearCount)) -- Dimensional Tear
		self:StopBar(CL.count:format(L.spirits, spiritCount)) -- Fleeting Spirit
		self:StopBar(CL.count:format(self:SpellName(325399), sparkCount)) -- Hyperlight Spark

		self:SetStage(2)
		lastStaged = GetTime()
		self:Message("stages", "green", CL.stage:format(2), false)
		self:PlaySound("stages", "info")

		dimensionalTearCount = 1
		spiritCount = 1
		seedCount = 1
		sparkCount = 1

		self:Bar(325399, 6.5, CL.count:format(self:SpellName(325399), sparkCount)) -- Hyperlight Spark
		if not self:Easy() then
			self:Bar(326271, 10.5, CL.count:format(CL.traps, trapCount)) -- Stasis Trap
		end
		self:Bar(328437, 16.5, CL.count:format(L.tear, dimensionalTearCount)) -- Dimensional Tear
		self:Bar(340788, 22.3, CL.count:format(L.seeds, seedCount)) -- Seeds of Extinction
		self:Bar(325236, 25.2, CL.count:format(self:SpellName(325236), glyphCount)) -- Glyph of Destruction
		if self:Mythic() then
			self:Bar(340758, 27, CL.count:format(L.spirits, spiritCount)) -- Fleeting Spirit
		end
	elseif nextStage == 3 then
		self:StopBar(CL.count:format(CL.traps, trapCount)) -- Stasis Trap
		self:StopBar(CL.count:format(L.tear, dimensionalTearCount)) -- Dimensional Tear
		self:StopBar(CL.count:format(L.spirits, spiritCount)) -- Fleeting Spirit
		self:StopBar(CL.count:format(L.seeds, seedCount)) -- Seeds of Extinction
		self:StopBar(CL.count:format(self:SpellName(325399), sparkCount)) -- Hyperlight Spark

		self:SetStage(3)
		lastStaged = GetTime()
		self:Message("stages", "green", CL.stage:format(3), false)
		self:PlaySound("stages", "info")

		dimensionalTearCount = 1
		spiritCount = 1
		seedCount = 1
		annihilateCount = 1
		sparkCount = 1

		self:Bar(325399, 6.5, CL.count:format(self:SpellName(325399), sparkCount)) -- Hyperlight Spark
		if not self:Easy() then
			self:CDBar(326271, 10.5, CL.count:format(CL.traps, trapCount)) -- Stasis Trap
		end
		self:CDBar(328437, 16.5, CL.count:format(L.tear, dimensionalTearCount)) -- Dimensional Tear
		self:Bar(328789, 28.3, CL.count:format(self:SpellName(328789), annihilateCount)) -- Annihilate
		self:CDBar(325236, self:Mythic() and 52 or 50, CL.count:format(self:SpellName(325236), glyphCount)) -- Glyph of Destruction
		if self:Mythic() then
			self:CDBar(340788, 32.3, CL.count:format(L.seeds, seedCount)) -- Seeds of Extinction
			self:Bar(340758, 34.3, CL.count:format(L.spirits, spiritCount)) -- Fleeting Spirit
		end
	end
end

do
	local playerList = {}

	function mod:DimensionalTear(args)
		playerList = {}
		self:StopBar(CL.count:format(L.tear, dimensionalTearCount))
		dimensionalTearCount = dimensionalTearCount + 1
		local stage = self:GetStage()
		local cd = stage == 3 and 51 or stage == 2 and 42 or 35 -- XXX Can be made more precise with a table most likely
		if self:Mythic() then
			cd = 36.5
			if dimensionalTearCount > 2 then -- There's a longer time between casts after the second cast in Mythic
				cd = stage == 3 and 80 or 51
			end
		end
		self:CDBar(328437, cd, CL.count:format(L.tear, dimensionalTearCount))
	end

	function mod:DimensionalTearApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(328437, CL.count_rticon:format(L.tear, count, count))
			self:SayCountdown(328437, 8)
			self:PlaySound(328437, "warning")
		end
		self:CustomIcon(dimensionalTearMarker, args.destName, count)

		self:NewTargetsMessage(328437, "yellow", playerList, 2, L.tear)
	end

	function mod:DimensionalTearRemoved(args)
		self:CustomIcon(dimensionalTearMarker, args.destName)
	end
end

function mod:GlyphOfDestruction(args)
	local bossUnit = self:GetBossId(args.sourceGUID)
	for i = 1, #tankList do
		local unit = tankList[i]
		if bossUnit and self:Tanking(bossUnit, unit) then
			self:TargetMessage(325236, "yellow", self:UnitName(unit), CL.casting:format(CL.bomb))
			break
		elseif i == #tankList then
			self:Message(325236, "yellow", CL.casting:format(CL.bomb))
		end
	end
	self:PlaySound(325236, "alert")
	self:StopBar(CL.count:format(self:SpellName(325236), glyphCount))
	glyphCount = glyphCount + 1
	self:CDBar(325236, self:Mythic() and 36.5 or 29, CL.count:format(self:SpellName(325236), glyphCount))
end

function mod:GlyphOfDestructionApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName, CL.count:format(CL.bomb, glyphCount-1))
	self:PlaySound(args.spellId, "warning")
	self:TargetBar(args.spellId, self:Easy() and 8 or 4, args.destName, CL.bomb)
	if self:Me(args.destGUID) then
		self:Say(args.spellId, CL.bomb)
		self:SayCountdown(args.spellId, self:Easy() and 8 or 4)
	end
end

function mod:GlyphOfDestructionRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:StasisTrap(args)
	if not self:Easy() then -- this event triggers in normal but no traps spawn, lets filter anything there
		self:Message(args.spellId, "red", CL.count:format(CL.traps, trapCount))
		self:PlaySound(args.spellId, "alert")
		trapCount = trapCount + 1
		self:CDBar(args.spellId, self:Mythic() and (self:GetStage() == 3 and 36 or 30) or 30, CL.count:format(CL.traps, trapCount))
	end
end

function mod:RiftBlast(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, 36)
end

function mod:HyperlightSpark(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, sparkCount))
	self:PlaySound(args.spellId, "alert")
	sparkCount = sparkCount + 1
	local cd = 15.8
	if self:Mythic() and self:GetStage() == 3 then
		cd = sparkCount == 2 and 53.5 or (sparkCount % 2 == 1 and 15.8 or 19.5)
	end
	self:CDBar(args.spellId, cd, CL.count:format(args.spellName, sparkCount))
end
-- The Relics of Castle Nathria
-- function mod:FleetingSpirits(args)
-- 	self:Message(340758, "cyan", CL.count:format(L.spirits, spiritCount))
-- 	self:PlaySound(340758, "long")
-- 	spiritCount = spiritCount + 1
-- 	self:CDBar(340758, 41.5, CL.count:format(L.spirits, spiritCount))
-- end

function mod:Fixate(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.fixate)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:PossesionApplied(args)
	playerListSpirits[#playerListSpirits+1] = args.destName
	self:NewTargetsMessage(args.spellId, "red", playerListSpirits)
end

-- function mod:SeedsofExtinction(args)
-- 	self:Message(340788, "cyan", CL.count:format(L.seeds, seedCount))
-- 	self:PlaySound(340788, "long")
-- 	seedCount = seedCount + 1
-- 	self:Bar(340788, self:Mythic() and 59.5 or seedCount % 2 and 53.3 or 41.3, CL.count:format(L.seeds, seedCount))
-- end

function mod:Extinction(args)
	self:Bar(args.spellId, self:Easy() and 16 or 12, CL.count:format(CL.explosion, seedCount-1))
end

function mod:WitheringTouchApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

-- function mod:Annihilate(args)
-- 	self:StopBar(CL.count:format(args.spellName, annihilateCount))
-- 	self:Message(args.spellId, "orange", CL.count:format(args.spellName, annihilateCount))
-- 	self:PlaySound(args.spellId, "warning")
-- 	self:CastBar(args.spellId, 10, CL.count:format(args.spellName, annihilateCount))
-- 	annihilateCount = annihilateCount + 1
-- 	self:CDBar(args.spellId, self:Mythic() and 74 or 52, CL.count:format(args.spellName, annihilateCount))
-- end
