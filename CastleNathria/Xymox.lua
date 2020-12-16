--------------------------------------------------------------------------------
-- TODO:
-- -- Fallback if yells are not detected for stage changes

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Artificer Xy'mox", 2296, 2418)
if not mod then return end
mod:RegisterEnableMob(166644) -- Artificer Xy'mox
mod.engageId = 2405
mod.respawnTime = 27

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local dimensionalTearCount = 1
local spiritCount = 1
local seedCount = 1
local annihilateCount = 1
local sparkCount = 1
local glyphCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.stage2_yell = "The anticipation to use this relic is killing me! Though, it will more likely kill you."
	L.stage3_yell = "I hope this wondrous item is as lethal as it looks!"
end

--------------------------------------------------------------------------------
-- Initialization
--

local dimensionalTearMarker = mod:AddMarkerOption(false, "player", 1, 328437, 1, 2) -- Dimensional Tear
function mod:GetOptions()
	return {
		-- General
		"stages",
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
		329107, -- Extinction
		340860, -- Withering Touch
		328789, -- Edge of Annihilation
	},{
		[328437] = "general",
		[340758] = -22119, -- The Relics of Castle Nathria
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:Log("SPELL_CAST_SUCCESS", "DimensionalTear", 328437, 342310)
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
	self:Log("SPELL_CAST_START", "SeedsofExtinction", 329770, 340788) -- Root of Extinction, Seeds of Extinction // First wave, Others
	self:Log("SPELL_CAST_START", "Extinction", 329107)
	self:Log("SPELL_AURA_APPLIED", "WitheringTouchApplied", 340860)
	self:Log("SPELL_CAST_START", "EdgeofAnnihilation", 328789)
end

function mod:OnEngage()
	stage = 1
	dimensionalTearCount = 1
	spiritCount = 1
	seedCount = 1
	annihilateCount = 1
	sparkCount = 1
	glyphCount = 1

	self:Bar(325399, 5.5, CL.count:format(self:SpellName(325399), sparkCount)) -- Hyperlight Spark
	self:Bar(326271, 11) -- Stasis Trap
	self:Bar(328437, 17, CL.count:format(self:SpellName(328437), dimensionalTearCount)) -- Dimensional Tear
	self:Bar(335013, 21) -- Rift Blast
	self:Bar(325236, 31, CL.count:format(self:SpellName(325236), glyphCount)) -- Glyph of Destruction
	self:Bar(340758, 27, CL.count:format(self:SpellName(340758), spiritCount)) -- Fleeting Spirit
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg:find(L.stage2_yell) then
		self:StopBar(326271) -- Stasis Trap
		self:StopBar(CL.count:format(self:SpellName(328437), dimensionalTearCount)) -- Dimensional Tear
		self:StopBar(CL.count:format(self:SpellName(340758), spiritCount)) -- Fleeting Spirit

		stage = 2
		self:Message("stages", "green", CL.stage:format(stage), false)
		self:PlaySound("stages", "info")

		dimensionalTearCount = 1
		spiritCount = 1
		seedCount = 1

		self:CDBar(326271, 10) -- Stasis Trap
		self:CDBar(328437, 14, CL.count:format(self:SpellName(328437), dimensionalTearCount)) -- Dimensional Tear
		self:CDBar(340788, 16, CL.count:format(self:SpellName(340788), seedCount)) -- Seeds of Extinction
	elseif msg:find(L.stage3_yell) then
		self:StopBar(326271) -- Stasis Trap
		self:StopBar(CL.count:format(self:SpellName(328437), dimensionalTearCount)) -- Dimensional Tear
		self:StopBar(CL.count:format(self:SpellName(340788), seedCount)) -- Seeds of Extinction

		stage = 3
		self:Message("stages", "green", CL.stage:format(stage), false)
		self:PlaySound("stages", "info")

		dimensionalTearCount = 1
		spiritCount = 1
		seedCount = 1
		annihilateCount = 1

		self:CDBar(326271, 10) -- Stasis Trap
		self:CDBar(328437, 16, CL.count:format(self:SpellName(328437), dimensionalTearCount)) -- Dimensional Tear
		self:CDBar(328789, 28, CL.count:format(self:SpellName(328789), annihilateCount)) -- Annihilate
	end
end

do
	local playerList, playerIcons = mod:NewTargetList(), {}

	function mod:DimensionalTear(args)
		self:StopBar(CL.count:format(self:SpellName(328437), dimensionalTearCount))
		dimensionalTearCount = dimensionalTearCount + 1
		self:CDBar(328437, 41.3, CL.count:format(self:SpellName(328437), dimensionalTearCount))
	end

	function mod:DimensionalTearApplied(args)
		local count = #playerList+1
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
	self:StopBar(CL.count:format(self:SpellName(325236), glyphCount))
	glyphCount = glyphCount + 1
	self:CDBar(325236, 29, CL.count:format(self:SpellName(325236), glyphCount))
end

function mod:GlyphofDestructionApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName, CL.count:format(args.spellName, glyphCount-1))
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
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 30)
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
	self:CDBar(args.spellId, 15.8, CL.count:format(args.spellName, sparkCount))
end

-- The Relics of Castle Nathria
function mod:FleetingSpirits(args)
	self:Message(340758, "cyan", CL.count:format(self:SpellName(340758), spiritCount))
	self:PlaySound(340758, "long")
	spiritCount = spiritCount + 1
	self:CDBar(340758, 41.5, CL.count:format(self:SpellName(340758), spiritCount))
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
	self:Message(340788, "cyan", CL.count:format(self:SpellName(340788), seedCount))
	self:PlaySound(340788, "long")
	seedCount = seedCount + 1
	self:Bar(340788, seedCount % 2 and 53.3 or 41.3, CL.count:format(self:SpellName(340788), seedCount))
end

function mod:Extinction(args)
	self:CastBar(args.spellId, self:Normal() and 16 or 14, CL.count:format(args.spellName, seedCount-1))
end

function mod:WitheringTouchApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:EdgeofAnnihilation(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, annihilateCount))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 10, CL.count:format(args.spellName, annihilateCount))
	annihilateCount = annihilateCount + 1
	self:CDBar(args.spellId, 52, CL.count:format(args.spellName, annihilateCount))
end
