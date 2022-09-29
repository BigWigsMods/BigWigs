if not IsTestBuild() then return end
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
		390715, -- Flamerift
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
	self:Log("SPELL_AURA_APPLIED", "BurningWoundApplied", 394904)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BurningWoundApplied", 394904)

	self:Log("SPELL_CAST_START", "CollapsingArmy", 370307)
end

function mod:OnEngage()
	--self:Bar(390715, 10) -- Flamerift
	--self:Bar(370615, 10) -- Molten Cleave
	--self:Bar(394917, 10) -- Leaping Flames
	--self:Bar(394904, 10) -- Burning Wound
	--self:Bar(370307, 100) -- Collapsing Army
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CollapsingArmy(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
	--self:Bar(args.spellId, 100)
end

function mod:Flamerift(args)
	self:Message(args.spellId, "red")
	--self:Bar(args.spellId, 30)
end

function mod:FlameriftApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
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
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, 30)
end

function mod:BurningWoundApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 0)
	self:PlaySound(args.spellId, "info")
	--self:Bar(args.spellId, 30)
end

function mod:LeapingFlames(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 30)
end
