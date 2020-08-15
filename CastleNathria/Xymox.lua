if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- TODO:
-- -- Fix timers and stage transitions a lot better

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Artificer Xy'mox", 2296, 2418)
if not mod then return end
mod:RegisterEnableMob(166644) -- Artificer Xy'mox
mod.engageId = 2405
mod.respawnTime = 27

--------------------------------------------------------------------------------
-- Initialization
--

local dimensionalTearMarker = mod:AddMarkerOption(false, "player", 1, 328437, 1, 2) -- Dimensional Tear
function mod:GetOptions()
	return {
		-- General
		{328437, "SAY", "SAY_COUNTDOWN"}, -- Dimensional Tear
		dimensionalTearMarker,
		{325236, "TANK", "SAY_COUNTDOWN"}, -- Glyph of Destruction
		326271, -- Stasis Trap
		335013, -- Rift Blast
		325399, -- Hyperlight Spark
		-- The Relics of Castle Nathria
		340758, -- Fleeting Spirits
		327902, -- Fixate
		327414, -- Possesion
		340788, -- Seeds of Extinction
		340860, -- Withering Touch
		328789, -- Edge of Annihilation
	},{
		[328437] = "general",
		[340758] = -22119, -- The Relics of Castle Nathria
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "DimensionalTear", 328437)
	self:Log("SPELL_AURA_APPLIED", "DimensionalTearApplied", 328448, 328468)
	self:Log("SPELL_AURA_REMOVED", "DimensionalTearRemoved", 328448, 328468)
	self:Log("SPELL_CAST_SUCCESS", "GlyphofDestruction", 325361)
	self:Log("SPELL_AURA_APPLIED", "GlyphofDestructionApplied", 325236)
	self:Log("SPELL_AURA_REMOVED", "GlyphofDestructionRemoved", 325236)
	self:Log("SPELL_CAST_SUCCESS", "StasisTrap", 326271)
	self:Log("SPELL_CAST_START", "RiftBlast", 335013)
	self:Log("SPELL_CAST_SUCCESS", "HyperlightSpark", 325399)

	-- The Relics of Castle Nathria
	self:Log("SPELL_CAST_START", "FleetingSpirits", 327887, 340758) -- Crystal of Phantasms, Fleeting Spirits // First wave, Others
	self:Log("SPELL_AURA_APPLIED", "Fixate", 327902)
	self:Log("SPELL_AURA_APPLIED", "PossesionApplied", 327414)
	self:Log("SPELL_CAST_START", "SeedsofExtinction", 329770, 340788)
	self:Log("SPELL_AURA_APPLIED", "WitheringTouchApplied", 340860)
	self:Log("SPELL_CAST_START", "EdgeofAnnihilation", 328789)
end

function mod:OnEngage()
	self:Bar(325399, 6.5) -- Hyperlight Spark
	self:Bar(326271, 11) -- Stasis Trap
	self:Bar(328437, 15.2) -- Dimensional Tear
	self:Bar(335013, 20) -- Rift Blast
	self:Bar(325236, 31) -- Glyph of Destruction
	self:Bar(340758, 33) -- Fleeting Spirit
end

--------------------------------------------------------------------------------
-- Event Handlers
--
do
	local playerList, playerIcons = mod:NewTargetList(), {}

	function mod:DimensionalTear(args)
		self:CDBar(args.spellId, 40)
	end

	function mod:DimensionalTearApplied(args)
		local count = #playerIcons+1
		playerList[count] = args.destName
		playerIcons[count] = count
		if self:Me(args.destGUID) then
			self:Say(328437, CL.count_rticon:format(self:SpellName(328437), count, count))
			self:SayCountdown(328437, 8)
			self:PlaySound(328437, "warning")
		end
		if self:GetOption(dimensionalTearMarker) then
			SetRaidTarget(args.destName, count)
		end

		self:TargetsMessage(328437, "yellow", playerList, 2, nil, nil, nil, playerIcons)
	end

	function mod:DimensionalTearRemoved(args)
		if self:GetOption(dimensionalTearMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:GlyphofDestruction(args)
	self:CDBar(325236, 29)
end

function mod:GlyphofDestructionApplied(args)
	self:TargetMessage2(args.spellId, "purple", args.destName)
	self:PlaySound(args.spellId, "warning")
	self:TargetBar(args.spellId, 8, args.destName)
	if self:Me(args.destGUID) then
		self:SayCountdown(args.spellId, 8)
	end
end

function mod:GlyphofDestructionRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:StasisTrap(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 30)
end

function mod:RiftBlast(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, 36)
end

function mod:HyperlightSpark(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 20)
end

-- The Relics of Castle Nathria
function mod:FleetingSpirits(args)
	self:Message2(340758, "cyan")
	self:PlaySound(340758, "long")
	self:CDBar(340758, 35)
end

function mod:Fixate(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:PossesionApplied(args)
		playerList[#playerList+1] = args.destName
		self:TargetsMessage(args.spellId, "red", playerList)
	end
end

function mod:SeedsofExtinction(args)
	self:StopBar(340758) -- Fleeting Spirits
	self:Message2(340788, "cyan")
	self:PlaySound(340788, "long")
	self:CastBar(340788, 20)
	self:Bar(340788, 45)
end

function mod:WitheringTouchApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:EdgeofAnnihilation(args)
	self:StopBar(329834) -- Seeds of Extinction
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 10)
	self:CDBar(args.spellId, 40)
end
