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
	L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate on Frenzied Taraseks that are fixed on you.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."
	L.custom_on_nameplate_fixate_icon = 210130
end

--------------------------------------------------------------------------------
-- Initialization
--

local blazingBrandMarker = mod:AddMarkerOption(true, "player", 1, 370640, 1, 2, 3) -- Blazing Brand
function mod:GetOptions()
	return {
		370307, -- Collapsing Army
		370534, -- Primal Forces
		370597, -- Kill Order (Fixate)
		"custom_on_nameplate_fixate",
		{370640, "SAY"}, -- Blazing Brand
		blazingBrandMarker,
		370615, -- Molten Swing
		{371059, "TANK"}, -- Melting Armor
		373338, -- Fire Strike
	},{

	},{
		[370597] = CL.fixate, -- Kill Order (Fixate)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "CollapsingArmy", 370307)
	self:Log("SPELL_CAST_START", "PrimalForces", 370534)
	self:Log("SPELL_AURA_APPLIED", "FixateApplied", 370597) -- Kill Order
	self:Log("SPELL_AURA_REMOVED", "FixateRemoved", 370597) -- Kill Order
	self:Log("SPELL_AURA_APPLIED", "BlazingBrandApplied", 370640)
	self:Log("SPELL_AURA_REMOVED", "BlazingBrandRemoved", 370640)
	self:Log("SPELL_CAST_START", "MoltenSwing", 370615)
	self:Log("SPELL_AURA_APPLIED", "MeltingArmorApplied", 371059)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MeltingArmorApplied", 371059)
	self:Log("SPELL_CAST_START", "FireStrike", 373338)
end

function mod:OnEngage()
	--self:Bar(360281, 10) -- Blazing Brand
	--self:Bar(373338, 10) -- Fire Strike
	--self:Bar(370615, 10) -- Molten Swing
	--self:Bar(370534, 10) -- Primal Forces
	--self:Bar(370307, 100) -- Collapsing Army
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CollapsingArmy(args)
	self:Message(args.spellId, "orange", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "long")
	--self:Bar(args.spellId, 100)
end

function mod:PrimalForces(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 30)
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

do
	local playerList = {}
	local prev = 0
	function mod:BlazingBrandApplied(args)
		local t = args.time
		if t-prev > 5 then
			-- XXX Use 370659 as _start / _success after tests most likely
			prev = t
			playerList = {}
			--self:Bar(args.spellId, 30)
		end
		local count = #playerList+1
		local icon = count
		playerList[count] = args.destName
		playerList[args.destName] = icon -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, CL.count_rticon:format(args.spellName, icon, icon))
			--self:SayCountdown(args.spellId, 7, icon)
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
		self:CustomIcon(blazingBrandMarker, args.destName, icon)
	end

	function mod:BlazingBrandRemoved(args)
		-- if self:Me(args.destGUID) then
		-- 	self:CancelSayCountdown(args.spellId)
		-- end
		self:CustomIcon(blazingBrandMarker, args.destName)
	end
end

function mod:MoltenSwing(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, 30)
end

function mod:MeltingArmorApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 0)
	self:PlaySound(args.spellId, "warning")
end

function mod:FireStrike(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 30)
end
