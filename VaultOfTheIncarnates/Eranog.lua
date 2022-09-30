if not IsTestBuild() then return end
-- XXX Counters on spells
-- XXX New timers on intermisson, dont start them right before

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Eranog", 2522, 2480)
if not mod then return end
mod:RegisterEnableMob(184972) -- Eranog
mod:SetEncounterID(2587)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local flameRiftCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_nameplate_fixate = "Fixate Nameplate Icon"
	L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate of Frenzied Tarasek that are fixed on you.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."
	L.custom_on_nameplate_fixate_icon = 210130
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Stage 1
		{390715, "SAY", "SAY_COUNTDOWN"}, -- Flamerift
		370649, -- Primal Flow
		370615, -- Molten Cleave
		394917, -- Leaping Flames
		{394904, "TANK"}, -- Burning Wound
		-- Frenzied Tarasek
		370597, -- Kill Order (Fixate)
		"custom_on_nameplate_fixate",
		-- Stage 2
		370307, -- Collapsing Army
	},{
		[390715] = -26001, -- Stage One
		[370597] = -26005, -- Frenzied Tarasek
		[370307] = -26004, -- Stage Two
	},{
		[370597] = CL.fixate, -- Kill Order (Fixate)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Flamerift", 390715)
	self:Log("SPELL_AURA_APPLIED", "FlameriftApplied", 390715)
	self:Log("SPELL_PERIODIC_DAMAGE", "PrimalFlowDamage", 370648)
	self:Log("SPELL_PERIODIC_MISSED", "PrimalFlowDamage", 370648)
	self:Log("SPELL_AURA_APPLIED", "FixateApplied", 370597) -- Kill Order
	self:Log("SPELL_AURA_REMOVED", "FixateRemoved", 370597) -- Kill Order
	self:Log("SPELL_CAST_START", "MoltenCleave", 370615)
	self:Log("SPELL_CAST_START", "LeapingFlames", 394917)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BurningWoundApplied", 394904)

	self:Log("SPELL_CAST_START", "CollapsingArmy", 370307)
	self:Log("SPELL_AURA_REMOVED", "CollapsingArmyRemoved", 370307)
end

function mod:OnEngage()
	flameRiftCount = 1

	self:CDBar(394917, 4.5) -- Leaping Flames
	self:CDBar(370615, 10) -- Molten Cleave
	self:CDBar(390715, 13.5, CL.count:format(self:SpellName(390715), flameRiftCount)) -- Flamerift
	self:CDBar(370307, 92.5) -- Collapsing Army
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CollapsingArmy(args)
	self:StopBar(370307) -- Collapsing Army
	self:StopBar(394917) -- Leaping Flames
	self:StopBar(370615) -- Molten Cleave
	self:StopBar(390715) -- Flamerift

	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
	-- self:CastBar(args.spellId, 26)
end

function mod:CollapsingArmyRemoved(args)
	-- self:StopBar(CL.cast:format(args.spellName))
	self:Message(args.spellId, "cyan", CL.over:format(args.spellName))
	-- XXX cd varies a bit, should probably register UNIT_POWER_UPDATE for the first tick?
	-- or are the random Energize (370727) casts doing it?
	self:CDBar(args.spellId, 95)

	self:CDBar(394917, 6) -- Leaping Flames
	self:CDBar(370615, 10) -- Molten Cleave
	self:CDBar(390715, 34) -- Flamerift
end

function mod:Flamerift(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, flameRiftCount))
	flameRiftCount = flameRiftCount + 1
	self:Bar(args.spellId, 30, CL.count:format(args.spellName, flameRiftCount))
end

function mod:FlameriftApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 6)
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
	self:Message(args.spellId, "orange", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alarm")
	-- self:CastBar(args.spellId, 3.5)
	self:CDBar(args.spellId, 30.5)
end

function mod:BurningWoundApplied(args)
	if args.amount > 3 and args.amount % 2 == 0 then -- swap around 6?
		self:StackMessage(args.spellId, "purple", args.destName, args.amount, 6)
		self:PlaySound(args.spellId, "info")
	end
end

function mod:LeapingFlames(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 31.5)
end
