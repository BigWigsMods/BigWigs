if not BigWigsLoader.onTestBuild then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Gnarlroot", 2549, 2564)
if not mod then return end
mod:RegisterEnableMob(209333) -- Gnarlroot XXX Confirm
mod:SetEncounterID(2820)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local flamingPestilenceCount = 1
local controlledBurnCount = 1
local torturedScreamCount = 1
local shadowflameCleaveCount = 1
local intermissionCount = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.placeholder = "placeholder"
end

--------------------------------------------------------------------------------
-- Initialization
--

local controlledBurnMarker = mod:AddMarkerOption(true, "player", 1, 421972, 1, 2, 3, 4) -- Controlled Burn
function mod:GetOptions()
	return {
		"stages",
		-- Stage One: Garden of Despair
		421898, -- Flaming Pestilence
		422053, -- Shadow Spines
		{421972, "SAY", "SAY_COUNTDOWN"}, -- Controlled Burn
		controlledBurnMarker,
		{424352, "TANK"}, -- Dreadfire Barrage
		422026, -- Tortured Scream
		422039, -- Shadowflame Cleave
		-- Intermission: Frenzied Growth
		421038, -- Ember-Charred
		424970, -- Corrupted Soil
		421840, -- Uprooted Agony
	}
end

function mod:OnBossEnable()
	-- Stage One: Garden of Despair
	self:Log("SPELL_CAST_SUCCESS", "FlamingPestilence", 421898)
	self:Log("SPELL_AURA_APPLIED", "ShadowSpinesApplied", 422053)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShadowSpinesApplied", 422053)
	self:Log("SPELL_CAST_SUCCESS", "ControlledBurn", 421971)
	self:Log("SPELL_AURA_APPLIED", "ControlledBurnApplied", 421972)
	self:Log("SPELL_AURA_REMOVED", "ControlledBurnRemoved", 421972)
	self:Log("SPELL_CAST_START", "DreadfireBarrage", 424352)
	self:Log("SPELL_AURA_APPLIED", "DreadfireBarrageApplied", 426106)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DreadfireBarrageApplied", 426106)
	self:Log("SPELL_CAST_START", "TorturedScream", 422026)
	self:Log("SPELL_CAST_START", "ShadowflameCleave", 422039)

	-- Intermission: Frenzied Growth
	self:Log("SPELL_CAST_START", "PotentFertilization", 421013)
	self:Log("SPELL_AURA_APPLIED", "EmberCharredApplied", 421038)
	self:Log("SPELL_AURA_APPLIED_DOSE", "EmberCharredApplied", 421038)
	self:Log("SPELL_AURA_APPLIED", "UprootedAgonyApplied", 421840)
	self:Log("SPELL_AURA_REMOVED", "UprootedAgonyRemoved", 421840)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 424970) -- Corrupted Soil
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 424970)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 424970)
end

function mod:OnEngage()
	self:SetStage(1)
	flamingPestilenceCount = 1
	controlledBurnCount = 1
	torturedScreamCount = 1
	shadowflameCleaveCount = 1
	intermissionCount = 1

	--self:Bar(424352, 30) -- Dreadfire Barrage
	--self:Bar(421898, 30, CL.count:format(self:SpellName(421898), flamingPestilenceCount)) -- Flaming Pestilence
	--self:Bar(421972, 30, CL.count:format(self:SpellName(421972), controlledBurnCount)) -- Controlled Burn
	--self:Bar(422026, 30, CL.count:format(self:SpellName(422026), torturedScreamCount)) -- Tortured Scream
	--self:Bar(422039, 30, CL.count:format(self:SpellName(422039), shadowflameCleaveCount)) -- Shadowflame Cleave
	--self:Bar("stages", 30, CL.count:format(CL.intermission, intermissionCount)) -- Intermission / Potent Fertilization
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: Garden of Despair
function mod:FlamingPestilence(args)
	self:StopBar(CL.count:format(args.spellName, flamingPestilenceCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, flamingPestilenceCount))
	self:PlaySound(args.spellId, "alert")
	flamingPestilenceCount = flamingPestilenceCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, flamingPestilenceCount))
end

function mod:ShadowSpinesApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, 1)
		self:PlaySound(args.spellId, "alarm")
	end
end

do
	local playerList = {}
	function mod:ControlledBurn(args)
		playerList = {}
		self:StopBar(CL.count:format(args.spellName, controlledBurnCount))
		controlledBurnCount = controlledBurnCount + 1
		--self:Bar(421972, 35, CL.count:format(args.spellName, controlledBurnCount))
	end

	function mod:ControlledBurnApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, CL.count_rticon:format(args.spellName, count, count))
			self:SayCountdown(args.spellId, 6, count)
		end
		self:CustomIcon(controlledBurnMarker, args.destName, count)
		self:TargetsMessage(args.spellId, "yellow", playerList, 4, CL.count:format(args.spellName, controlledBurnCount))
	end

	function mod:ControlledBurnRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(controlledBurnMarker, args.destName)
	end
end

function mod:DreadfireBarrage(args)
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	if self:Tanking(bossUnit) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
	else -- TargetMessage?
		self:Message(args.spellId, "purple")
	end
	--self:Bar(args.spellId, 30)
end

function mod:DreadfireBarrageApplied(args)
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	local amount = args.amount or 1
	if amount % 2 == 0 or amount > 4 then
		self:StackMessage(424352, "purple", args.destName, amount, 5)
		if not self:Tanking(bossUnit) and amount > 4 then -- Taunt?
			self:PlaySound(424352, "warning")
		elseif self:Me(args.destGUID) then
			self:PlaySound(424352, "alarm")
		end
	end
end

function mod:TorturedScream(args)
	self:StopBar(CL.count:format(args.spellName, torturedScreamCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, torturedScreamCount))
	self:PlaySound(args.spellId, "alert")
	torturedScreamCount = torturedScreamCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, torturedScreamCount))
end

function mod:ShadowflameCleave(args)
	self:StopBar(CL.count:format(args.spellName, shadowflameCleaveCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, shadowflameCleaveCount))
	self:PlaySound(args.spellId, "alert")
	shadowflameCleaveCount = shadowflameCleaveCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, shadowflameCleaveCount))
end

-- Intermission: Frenzied Growth
function mod:PotentFertilization(args)
	self:StopBar(424352) -- Dreadfire Barrage
	self:StopBar(CL.count:format(self:SpellName(421898), flamingPestilenceCount)) -- Flaming Pestilence
	self:StopBar(CL.count:format(self:SpellName(421972), controlledBurnCount)) -- Controlled Burn
	self:StopBar(CL.count:format(self:SpellName(422026), torturedScreamCount)) -- Tortured Scream
	self:StopBar(CL.count:format(self:SpellName(422039), shadowflameCleaveCount)) -- Shadowflame Cleave
	self:StopBar(CL.count:format(CL.intermission, intermissionCount)) -- Intermission / Potent Fertilization

	self:Message("stages", "yellow", CL.intermission, false)
	self:PlaySound("stages", "info")
	self:SetStage(2)

	-- Timer for Splintered Charcoal? every 8s from cast _SUCCESS, is there an event?
	-- Timer / How often is Toxic Loam for healers?
	-- How Many Doom Roots? Can we track stacks until stage ends?
end

function mod:EmberCharredApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, 1)
		self:PlaySound(args.spellId, "alarm")
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

function mod:UprootedAgonyApplied(args)
	self:Message(args.spellId, "green", CL.count:format(args.spellName, intermissionCount))
	self:PlaySound(args.spellId, "long")
	self:Bar(args.spellId, 20, CL.count:format(args.spellName, intermissionCount))
end

function mod:UprootedAgonyRemoved(args)
	self:Message("stages", "yellow", CL.stage:format(1), false)
	self:PlaySound("stages", "info")
	self:SetStage(1)
	flamingPestilenceCount = 1
	controlledBurnCount = 1
	torturedScreamCount = 1
	shadowflameCleaveCount = 1
	intermissionCount = intermissionCount + 1

	--self:Bar(424352, 30) -- Dreadfire Barrage
	--self:Bar(421898, 30, CL.count:format(self:SpellName(421898), flamingPestilenceCount)) -- Flaming Pestilence
	--self:Bar(421972, 30, CL.count:format(self:SpellName(421972), controlledBurnCount)) -- Controlled Burn
	--self:Bar(422026, 30, CL.count:format(self:SpellName(422026), torturedScreamCount)) -- Tortured Scream
	--self:Bar(422039, 30, CL.count:format(self:SpellName(422039), shadowflameCleaveCount)) -- Shadowflame Cleave
	--self:Bar("stages", 30, CL.count:format(CL.intermission, intermissionCount)) -- Intermission / Potent Fertilization
end
