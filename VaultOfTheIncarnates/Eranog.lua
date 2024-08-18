--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Eranog", 2522, 2480)
if not mod then return end
mod:RegisterEnableMob(184972) -- Eranog
mod:SetEncounterID(2587)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local flameRiftCount = 1
local moltenCleaveCount = 1
local incineratingRoarCount = 1
local moltenSpikesCount = 1
local collapsingArmyCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_nameplate_fixate = "Fixate Nameplate Icon"
	L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate of Frenzied Tarasek that are fixed on you.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."
	L.custom_on_nameplate_fixate_icon = 210130

	L.molten_cleave = "Frontal"
	L.molten_spikes = "Spikes"
	L.collapsing_army = "Army"
	L.greater_flamerift = "Mythic Add"
	L.leaping_flames = "Flames"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Stage 1
		{390715, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Flamerift
		370649, -- Primal Flow
		370615, -- Molten Cleave
		396023, -- Incinerating Roar
		396022, -- Molten Spikes
		{394906, "TANK"}, -- Burning Wound
		-- Frenzied Tarasek
		{370597, "ME_ONLY_EMPHASIZE"}, -- Kill Order (Fixate)
		"custom_on_nameplate_fixate",
		-- Stage 2
		{370307, "CASTBAR"}, -- Collapsing Army
		-- Mythic
		{396094, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Greater Flamerift
		394917, -- Leaping Flames
		393780, -- Pyroblast
	},{
		[390715] = -26001, -- Stage One
		[370597] = -26005, -- Frenzied Tarasek
		[370307] = -26004, -- Stage Two
		[396094] = "mythic",
	},{
		[390715] = CL.adds, -- Flamerift (Rifts)
		[370615] = L.molten_cleave, -- Molten Cleave (Frontal Cone)
		[396023] = CL.roar, -- Incinerating Roar (Roar)
		[396022] = L.molten_spikes, -- Molten Spikes (Spikes)
		[370597] = CL.fixate, -- Kill Order (Fixate)
		[370307] = L.collapsing_army, -- Collapsing Army (Army)
		[396094] = L.greater_flamerift, -- Greater Flamerift (Mythic Add)
		[394917] = L.leaping_flames, -- Leaping Flames (Flames)
	}
end

function mod:OnBossEnable()
	-- Stage 1
	self:Log("SPELL_CAST_START", "Flamerift", 390715)
	self:Log("SPELL_AURA_APPLIED", "FlameriftApplied", 390715)
	self:Log("SPELL_AURA_REMOVED", "FlameriftRemoved", 390715)
	self:Log("SPELL_PERIODIC_DAMAGE", "PrimalFlowDamage", 370648)
	self:Log("SPELL_PERIODIC_MISSED", "PrimalFlowDamage", 370648)
	self:Log("SPELL_AURA_APPLIED", "FixateApplied", 370597) -- Kill Order
	self:Log("SPELL_AURA_REMOVED", "FixateRemoved", 370597) -- Kill Order
	self:Log("SPELL_CAST_START", "MoltenCleave", 370615)
	self:Log("SPELL_CAST_START", "IncineratingRoar", 396023)
	self:Log("SPELL_CAST_SUCCESS", "MoltenSpikes", 396022)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BurningWoundApplied", 394906)

	-- Stage 2
	self:Log("SPELL_CAST_START", "CollapsingArmy", 370307)
	self:Log("SPELL_AURA_REMOVED", "CollapsingArmyRemoved", 370307)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "GreaterFlameriftApplied", 396094)
	self:Log("SPELL_AURA_REMOVED", "GreaterFlameriftRemoved", 396094)
	self:Log("SPELL_CAST_START", "LeapingFlames", 394917)
	self:Log("SPELL_CAST_START", "Pyroblast", 393780)
	self:Death("FlamescaleCamptainDeath", 199233) -- Flamescale Captain
end

function mod:OnEngage()
	self:SetStage(1)
	flameRiftCount = 1
	moltenCleaveCount = 1
	incineratingRoarCount = 1
	moltenSpikesCount = 1
	collapsingArmyCount = 1

	self:CDBar(396023, 10, CL.count:format(CL.roar, incineratingRoarCount)) -- Incinerating Roar
	self:CDBar(390715, 14, CL.count:format(CL.adds, flameRiftCount)) -- Flamerift
	self:CDBar(396022, 22, CL.count:format(L.molten_spikes, moltenSpikesCount)) -- Molten Spikes
	self:CDBar(370615, 38, CL.count:format(L.molten_cleave, moltenCleaveCount)) -- Molten Cleave
	self:CDBar(370307, 92, CL.count:format(L.collapsing_army, collapsingArmyCount)) -- Collapsing Army
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Flamerift(args)
	self:StopBar(CL.count:format(CL.adds, flameRiftCount))
	self:Message(args.spellId, "red", CL.count:format(CL.adds, flameRiftCount))
	flameRiftCount = flameRiftCount + 1
	if flameRiftCount < 4 then -- 3 per rotation
		self:Bar(args.spellId, flameRiftCount == 2 and 29.0 or 31.0, CL.count:format(CL.adds, flameRiftCount))
	end
end

function mod:FlameriftApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.add)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId, CL.add, nil, "Add")
		self:SayCountdown(args.spellId, 6)
	end
end

function mod:FlameriftRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

do
	local prev = 0
	function mod:PrimalFlowDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 3 then
			prev = args.time
			self:PersonalMessage(370649, "underyou")
			self:PlaySound(370649, "underyou")
		end
	end
end

function mod:FixateApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.fixate)
		self:PlaySound(args.spellId, "alarm")
		if self:GetOption("custom_on_nameplate_fixate") then
			self:AddPlateIcon(210130, args.sourceGUID) -- 210130 = ability_fixated_state_red
		end
	end
end

function mod:FixateRemoved(args)
	if self:Me(args.destGUID) and self:GetOption("custom_on_nameplate_fixate") then
		self:RemovePlateIcon(210130, args.sourceGUID)
	end
end

function mod:MoltenCleave(args)
	self:StopBar(CL.count:format(L.molten_cleave, moltenCleaveCount))
	self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(L.molten_cleave, moltenCleaveCount)))
	self:PlaySound(args.spellId, "alarm")
	moltenCleaveCount = moltenCleaveCount + 1
	if moltenCleaveCount < 3 then -- 2 per rotation
		self:Bar(args.spellId, 30, CL.count:format(L.molten_cleave, moltenCleaveCount))
	end
end

function mod:BurningWoundApplied(args)
	if args.amount > 3 and args.amount % 2 == 0 then -- swap around 6?
		self:StackMessage(args.spellId, "purple", args.destName, args.amount, 6)
		self:PlaySound(args.spellId, "info")
	end
end

function mod:IncineratingRoar(args)
	self:StopBar(CL.count:format(CL.roar, incineratingRoarCount))
	self:Message(args.spellId, "yellow", CL.count:format(CL.roar, incineratingRoarCount))
	self:PlaySound(args.spellId, "alert")
	incineratingRoarCount = incineratingRoarCount + 1
	if incineratingRoarCount < 5 then -- 4 per rotation
		self:CDBar(args.spellId, incineratingRoarCount == 2 and 24 or 22, CL.count:format(CL.roar, incineratingRoarCount))
	end
end

function mod:MoltenSpikes(args)
	self:StopBar(CL.count:format(L.molten_spikes, moltenSpikesCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.molten_spikes, moltenSpikesCount))
	self:PlaySound(args.spellId, "alert")
	moltenSpikesCount = moltenSpikesCount + 1
	if moltenSpikesCount < 4 then -- 3 per rotation
		self:CDBar(args.spellId, moltenSpikesCount == 2 and 22.5 or 21.5, CL.count:format(L.molten_spikes, moltenSpikesCount))
	end
end

-- Stage 2
function mod:CollapsingArmy(args)
	self:SetStage(2)
	self:StopBar(CL.count:format(L.collapsing_army, collapsingArmyCount)) -- Collapsing Army
	self:StopBar(CL.count:format(CL.roar, incineratingRoarCount)) -- Incinerating Roar
	self:StopBar(CL.count:format(L.molten_spikes, moltenSpikesCount)) -- Molten Spikes
	self:StopBar(CL.count:format(L.molten_cleave, moltenCleaveCount)) -- Molten Cleave
	self:StopBar(CL.count:format(CL.adds, flameRiftCount)) -- Flamerift

	self:Message(args.spellId, "cyan", CL.count:format(L.collapsing_army, collapsingArmyCount))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 27.5, L.collapsing_army)
end

function mod:CollapsingArmyRemoved(args)
	self:SetStage(1)
	self:StopBar(CL.cast:format(L.collapsing_army))
	self:Message(args.spellId, "cyan", CL.over:format(CL.count:format(L.collapsing_army, collapsingArmyCount)))
	collapsingArmyCount = collapsingArmyCount + 1

	flameRiftCount = 1
	moltenCleaveCount = 1
	incineratingRoarCount = 1
	moltenSpikesCount = 1

	self:CDBar(396023, 10, CL.count:format(CL.roar, incineratingRoarCount)) -- Incinerating Roar
	self:CDBar(390715, 14, CL.count:format(CL.adds, flameRiftCount)) -- Flamerift
	self:CDBar(396022, 22, CL.count:format(L.molten_spikes, moltenSpikesCount)) -- Molten Spikes
	self:CDBar(370615, 38, CL.count:format(L.molten_cleave, moltenCleaveCount)) -- Molten Cleave
	self:CDBar(args.spellId, 92.5, CL.count:format(L.collapsing_army, collapsingArmyCount)) -- Collapsing Army
end

-- Mythic
function mod:GreaterFlameriftApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.greater_flamerift)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId, L.greater_flamerift, nil, "Mythic Add")
		self:SayCountdown(args.spellId, 6)
	end
end

function mod:GreaterFlameriftRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:LeapingFlames(args)
	self:Message(args.spellId, "yellow", L.leaping_flames)
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 25, L.leaping_flames)
end

function mod:Pyroblast(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "red")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:FlamescaleCamptainDeath(args)
	self:StopBar(L.leaping_flames)
end
