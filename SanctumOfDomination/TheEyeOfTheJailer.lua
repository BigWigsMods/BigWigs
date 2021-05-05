--------------------------------------------------------------------------------
-- Module Declaration
--
if not IsTestBuild() then return end
local mod, CL = BigWigs:NewBoss("The Eye of the Jailer", 2450, 2442)
if not mod then return end
mod:RegisterEnableMob(179128, 175725, 178946, 178863, 177832) -- Eye of the Jailer XXX re-check on ptr
mod:SetEncounterID(2433)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local nextStageWarning = 78

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.chains = "Chains" -- Short for Dragging Chains
	L.pool = "Pool" -- Spreading Misery
	L.pools = "Pools" -- Spreading Misery (multiple)
	L.death_gaze = "Death Gaze" -- Short for Titanic Death Gaze
	L.corruption = mod:SpellName(172) -- Corruption // Short for Slothful Corruption
end

--------------------------------------------------------------------------------
-- Initialization
--

local draggingChainsMarker = mod:AddMarkerOption(false, "player", 1, 349979, 1, 2, 3) -- Dragging Chains
local slothfulCorruptionMarker = mod:AddMarkerOption(false, "player", 4, 350713, 4, 5, 6, 7) -- Slothful Corruption
function mod:GetOptions()
	return {
		"stages",
		-- Stage One: His Gaze Upon You
		{350803, "TANK"}, -- Piercing Lens
		350828, -- Deathlink
		{349979, "SAY"}, -- Dragging Chains
		draggingChainsMarker,
		348074, -- Assailing Lance
		-- Stage Two: Double Vision
		349028, -- Titanic Death Gaze
		{350847, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Desolation Beam
		350028, -- Soul Shatter
		{351825, "TANK"}, -- Shared Suffering
		350713, -- Slothful Corruption
		slothfulCorruptionMarker,
		{351827, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Spreading Misery
		-- Stage Three: Immediate Extermination
		348974, -- Immediate Extermination
		350764, -- Annihilating Glare
	},{
		["stages"] = "general",
		[350803] = mod:SpellName(-22896), -- Stage One: His Gaze Upon You
		[349028] = mod:SpellName(-22897), -- Stage Two: Double Vision
		[348974] = mod:SpellName(-23375), -- Stage Three: Immediate Extermination
	},{
		[349979] = L.chains, -- Dragging Chains (Chains)
		[349028] = L.death_gaze, -- Titanic Death Gaze (Death Gaze)
		[350847] = CL.beam, -- Glacial Wrath (Spikes)
		[350713] = L.corruption, -- Slothful Corruption (Corruption)
		[351827] = L.pools, -- Spreading Misery (Pools)
		[350764] = CL.laser, -- Annihilating Glare (Laser)
	}
end

function mod:OnBossEnable()
	-- Stage One: His Gaze Upon You
	self:Log("SPELL_CAST_START", "PiercingLens", 350803, 350453) -- Stage One, Stage Two? XXX
	self:Log("SPELL_CAST_START", "Deathlink", 350828)
	self:Log("SPELL_AURA_APPLIED", "DraggingChainsApplied", 349979)
	self:Log("SPELL_AURA_REMOVED", "DraggingChainsRemoved", 349979)
	self:Log("SPELL_CAST_START", "AssailingLance", 348074)

	-- Stage Two: Double Vision
	self:Log("SPELL_CAST_SUCCESS", "StygianEjection", 350066)
	self:Log("SPELL_CAST_SUCCESS", "TitanicDeathGaze", 349028)
	self:Log("SPELL_CAST_START", "DesolationBeam", 350847)
	self:Log("SPELL_CAST_SUCCESS", "SoulShatter", 350028)
	self:Log("SPELL_AURA_APPLIED", "ShatteredSoulApplied", 354004, 350034)
	self:Log("SPELL_AURA_APPLIED", "SharedSufferingApplied", 351825)
	self:Log("SPELL_AURA_APPLIED", "SlothfulCorruptionApplied", 350713)
	self:Log("SPELL_AURA_REMOVED", "SlothfulCorruptionRemoved", 350713)
	self:Log("SPELL_AURA_APPLIED", "SpreadingMiseryApplied", 351827)
	self:Log("SPELL_AURA_REMOVED", "SpreadingMiseryRemoved", 351827)
	self:Log("SPELL_AURA_REMOVED", "StygianDarkshieldRemoved", 348805)

	-- Stage Three: Immediate Extermination
	self:Log("SPELL_CAST_START", "ImmediateExtermination", 348974)
	self:Log("SPELL_CAST_START", "AnnihilatingGlare", 350764)
end

function mod:OnEngage()
	self:SetStage(1)

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	local currentHealth = self:GetHealth(unit)
	if currentHealth < nextStageWarning then -- Stage changes every 25%
		local nextStage = currentHealth > 30 and CL.stage:format(2) or CL.stage:format(3) -- Sub 25% is Stage 3
		self:Message("stages", "green", CL.soon:format(nextStage), false)
		nextStageWarning = nextStageWarning - 25
		if nextStageWarning < 25 then
			self:UnregisterUnitEvent(event, unit)
		end
	end
end

-- Stage One: His Gaze Upon You
function mod:PiercingLens(args)
	self:Message(350803, "purple")
	self:PlaySound(350803, "alert")
	--self:Bar(350803), 20)
end

function mod:Deathlink(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 20)
end

do
	local playerList = {}
	local prev = 0
	function mod:DraggingChainsApplied(args) -- XXX Is there a pre-debuff?
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
			--self:Bar(args.spellId, 6.3)
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Yell(args.spellId, L.chains)
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "orange", playerList, nil, L.chains)
		self:CustomIcon(draggingChainsMarker, args.destName, count)
	end

	function mod:DraggingChainsRemoved(args)
		self:CustomIcon(draggingChainsMarker, args.destName)
	end
end

do
	local function printTarget(self, name, guid)
		if self:Me(guid) then
			self:PersonalMessage(348074)
			self:PlaySound(348074, "alarm")
		end
	end

	function mod:AssailingLance(args)
		self:GetUnitTarget(printTarget, 0.1, args.sourceGUID)
		--self:Bar(args.spellId, 42)
	end
end

-- Stage Two: Double Vision
function mod:StygianEjection(args)
	self:SetStage(2)
	self:Message("stages", "green", CL.stage:format(2), false)
	self:PlaySound("stages", "long")
end

function mod:TitanicDeathGaze(args)
	self:Message(args.spellId, "orange", L.death_gaze)
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, 42, L.death_gaze)
end

do
	local function printTarget(self, name, guid)
		if self:Me(guid) then
			self:Say(350847, CL.beam)
			self:SayCountdown(350847, 6)
			self:PlaySound(350847, "warning")
		end
		self:TargetMessage(350847, "red", name, CL.beam)
	end

	function mod:DesolationBeam(args)
		--self:Bar(args.spellId, 42, CL.beam)
		self:CancelSayCountdown(350847) -- Cancelling incase you can vanish/fd/invis the cast and it re-casts
		self:GetUnitTarget(printTarget, 0.3, args.sourceGUID)
	end
end

function mod:SoulShatter(args) -- XXX _SUCCESS on targets?
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 20)
end

function mod:ShatteredSoulApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(350028)
		self:PlaySound(350028, "warning")
	end
end

function mod:SharedSufferingApplied(args)
	self:Message(args.spellId, "red", CL.onboss:format(args.spellName))
	self:PlaySound(args.spellId, "warning")
end

do
	local playerList = {}
	local prev = 0
	local soundPlayed = false
	function mod:SlothfulCorruptionApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
			soundPlayed = false
			--self:Bar(args.spellId, 6.3)
		end
		local count = #playerList+1
		local icon = count+3
		playerList[count] = args.destName
		playerList[args.destName] = icon -- Set raid marker
		if not soundPlayed and (self:Me(args.destGUID) or self:Dispeller("magic")) then
			self:PlaySound(args.spellId, "alarm")
			soundPlayed = true
		end
		self:NewTargetsMessage(args.spellId, "orange", playerList, nil, L.corruption)
		self:CustomIcon(slothfulCorruptionMarker, args.destName, icon)
	end

	function mod:SlothfulCorruptionRemoved(args)
		self:CustomIcon(draggingChainsMarker, args.destName)
	end
end

do
	local playerList = {}
	local prev = 0
	function mod:SpreadingMiseryApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
			--self:Bar(args.spellId, 6.3, L.pools)
		end
		local count = #playerList+1
		playerList[count] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId, L.pool)
			self:SayCountdown(args.spellId, 5)
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "yellow", playerList, L.pool)
	end

	function mod:SpreadingMiseryRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:StygianDarkshieldRemoved(args)
	self:SetStage(1)
	self:Message("stages", "green", CL.stage:format(1), false)
	self:PlaySound("stages", "long")
end

-- Stage Three: Immediate Extermination
function mod:ImmediateExtermination(args)
	self:SetStage(3)
	self:Message("stages", "green", CL.stage:format(3), false)
	self:PlaySound("stages", "long")
end

function mod:AnnihilatingGlare(args)
	self:Message(args.spellId, "yellow", CL.laser)
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 5, CL.laser)
	--self:Bar(args.spellId, 20, CL.laser)
end
