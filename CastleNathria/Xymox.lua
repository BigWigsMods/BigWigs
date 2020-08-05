if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Artificer Xy'mox", 2296, 2418)
if not mod then return end
mod:RegisterEnableMob(166644) -- Artificer Xy'mox
mod.engageId = 2405
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.collapsing_realities = "Collapsing Realities" -- Short for Activate Crystal of Collapsing Realities (spellId: 329770)
end

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Initialization
--

local displacementCypherMarker = mod:AddMarkerOption(false, "player", 1, 328437, 1, 2) -- Displacement Cypher
function mod:GetOptions()
	return {
		-- General
		{328437, "SAY", "SAY_COUNTDOWN"}, -- Displacement Cypher
		displacementCypherMarker,
		{325236, "TANK", "SAY_COUNTDOWN"}, -- Glyph of Destruction
		326271, -- Stasis Trap
		329256, -- Rift Blast
		325399, -- Hyperlight Spark
		-- The Relics of Castle Nathria
		327887, -- Activate Coalescence of Souls
		-- 000000, -- Spirit Fixate
		327414, -- Possesion
		329770, -- Activate Crystal of Collapsing Realities
		328789, -- Worldbreaking
	},{
		[328437] = "general",
		[327887] = -22119, -- The Relics of Castle Nathria
	},{
		[327887] = self:SpellName(-22124), -- Activate Coalescence of Souls (Fleeting Spirit)
		[329770] = L.collapsing_realities, -- Activate Crystal of Collapsing Realities (Collapsing Realities)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "DisplacementCypher", 328437)
	self:Log("SPELL_AURA_APPLIED", "DisplacementCypherApplied", 328448, 328468)
	self:Log("SPELL_AURA_REMOVED", "DisplacementCypherRemoved", 328448, 328468)
	self:Log("SPELL_AURA_APPLIED", "GlyphofDestructionApplied", 325236)
	self:Log("SPELL_AURA_REMOVED", "GlyphofDestructionRemoved", 325236)
	self:Log("SPELL_CAST_SUCCESS", "StasisTrap", 326271)
	self:Log("SPELL_CAST_START", "RiftBlast", 329256)
	self:Log("SPELL_CAST_SUCCESS", "HyperlightSpark", 325399)

	-- The Relics of Castle Nathria
	self:Log("SPELL_CAST_SUCCESS", "ActivateCoalescenceofSouls", 327887) -- Fleeting Spirits incoming
	--self:Log("SPELL_AURA_APPLIED", "SpiritFixate", 000000)
	self:Log("SPELL_AURA_APPLIED", "PossesionApplied", 327414)
	self:Log("SPELL_CAST_START", "CollapsingRealities", 329770)
	self:Log("SPELL_CAST_START", "Worldbreaking", 328789)
end

function mod:OnEngage()
	-- self:Bar(328437, 5) -- Displacement Cypher
	-- self:Bar(325236, 10) -- Glyph of Destruction
	-- self:Bar(326271, 15) -- Stasis Trap
	-- self:Bar(329256, 20) -- Rift Blast
	-- self:Bar(325399, 25) -- Hyperlight Spark

	-- self:Bar(327887, 25, -22124) -- Fleeting Spirit
	-- self:Bar(329770, 25, L.collapsing_realities) -- Collapsing Realities
	-- self:Bar(328789, 25) -- Worldbreaking
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local playerList, playerIcons = mod:NewTargetList(), {}

	function mod:DisplacementCypher(args)
		-- self:Bar(args.spellId, 30)
	end

	function mod:DisplacementCypherApplied(args)
		local count = #playerIcons+1
		playerList[count] = args.destName
		playerIcons[count] = count
		if self:Me(args.destGUID) then
			self:Say(328437, CL.count_rticon:format(self:SpellName(328437), count, count)) -- Displacement Cypher
			self:SayCountdown(328437, 8) -- Displacement Cypher
			self:PlaySound(328437, "warning") -- Displacement Cypher
		end
		if self:GetOption(displacementCypherMarker) then
			SetRaidTarget(args.destName, count)
		end

		self:TargetsMessage(328437, "yellow", playerList, 2, nil, nil, nil, playerIcons) -- Displacement Cypher
	end

	function mod:DisplacementCypherRemoved(args)
		if self:GetOption(displacementCypherMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:GlyphofDestructionApplied(args)
	self:TargetMessage2(args.spellId, "purple", args.destName)
	self:PlaySound(args.spellId, "warning")
	self:SayCountdown(args.spellId, 4)
	--self:Bar(args.spellId, 25)
end

function mod:GlyphofDestructionRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:StasisTrap(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 25)
end

function mod:RiftBlast(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, 25)
end

function mod:HyperlightSpark(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 25)
end

function mod:ActivateCoalescenceofSouls(args)
	self:Message2(args.spellId, "cyan", CL.incoming:format(self:SpellName(-22124))) -- Fleeting Spirit
	self:PlaySound(args.spellId, "long")
	--self:Bar(args.spellId, 25, -22124) -- Fleeting Spirit
end

-- function mod:SpiritFixate(args)
-- 	if self:Me(args.destGUID) then
-- 		self:PersonalMessage(args.spellId)
-- 		self:PlaySound(args.spellId, "warning")
-- 	end
-- end

do
	local playerList = mod:NewTargetList()
	function mod:PossesionApplied(args)
		playerList[#playerList+1] = args.destName
		self:TargetsMessage(args.spellId, "red", playerList)
	end
end

function mod:CollapsingRealities(args)
	self:Message2(args.spellId, "cyan", L.collapsing_realities)
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 21.5, L.collapsing_realities)
	--self:Bar(args.spellId, 25, L.collapsing_realities)
end

function mod:Worldbreaking(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:CastBar(args.spellId, 10)
	--self:Bar(args.spellId, 25)
end
