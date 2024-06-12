if not BigWigsLoader.isBeta then return end -- Beta check

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sikran, Captain of the Sureki", 2657, 2599)
if not mod then return end
mod:RegisterEnableMob(214503) -- Sikran
mod:SetEncounterID(2898)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--


--------------------------------------------------------------------------------
-- Localization
--

-- local L = mod:GetLocale()
-- if L then

-- end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		456420, -- Shattering Sweep
		458272, -- Cosmic Simulacrum
		459273, -- Cosmic Shards
		{439511, "TANK"}, -- Captain's Flourish
		{435401, "TANK"}, -- Expose
		{438845, "TANK"}, -- Exposed Weakness
		{432969, "TANK"}, -- Phase Lunge
		{435410, "TANK"}, -- Pierced Defences
		{433517, "SAY",  "ME_ONLY_EMPHASIZE"}, -- Phase Blades
		434860, -- Cosmic Wound
		439559, -- Rain of Arrows
		442428, -- Decimate
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "ShatteringSweep", 456420)
	self:Log("SPELL_CAST_SUCCESS", "CosmicSimulacrum", 458272)
	self:Log("SPELL_AURA_APPLIED", "CosmicShardsApplied", 459273)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CosmicShardsApplied", 459273)
	self:Log("SPELL_CAST_SUCCESS", "CaptainsFlourish", 439511)
	self:Log("SPELL_CAST_START", "Expose", 435401)
	self:Log("SPELL_AURA_APPLIED", "ExposedWeaknessApplied", 438845)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ExposedWeaknessApplied", 438845)
	self:Log("SPELL_CAST_START", "PhaseLunge", 432969)
	self:Log("SPELL_AURA_APPLIED", "PiercedDefencesApplied", 435410)
	-- self:Log("SPELL_CAST_SUCCESS", "PhaseBlades", 433475)
	self:Log("SPELL_AURA_APPLIED", "PhaseBladesApplied", 433517)
	self:Log("SPELL_AURA_APPLIED", "CosmicWoundApplied", 434860)
	self:Log("SPELL_CAST_START", "RainOfArrows", 439559)
	self:Log("SPELL_CAST_START", "Decimate", 442428)
end

function mod:OnEngage()
	-- self:Bar(456420, 5) -- Shattering Sweep
	-- self:Bar(458272, 5) -- Cosmic Simulacrum
	-- self:Bar(439511, 5) -- Captain's Flourish
	-- self:Bar(433517, 5) -- Phase Blades
	-- self:Bar(432969, 5) -- Rain of Arrows
	-- self:Bar(442428, 5) -- Decimate
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ShatteringSweep(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 42)
end

function mod:CosmicSimulacrum(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	--self:Bar(args.spellId, 42)
end

function mod:CosmicShardsApplied(args) -- XXX Delay announce to not spam?
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, 10)
		if amount % 5 == 0 then
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

do
	function mod:CaptainsFlourish(args)
		self:Message(args.spellId, "cyan", CL.casting:format(CL.tank_combo))
		self:PlaySound(args.spellId, "info")
		--self:Bar(args.spellId, 42, CL.tank_combo)
	end

	function mod:Expose(args)
		self:Message(args.spellId, "purple")
		local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
		if bossUnit and self:Tanking(bossUnit) then
			self:PlaySound(args.spellId, "alarm") -- defensive
		end
	end

	function mod:ExposedWeaknessApplied(args)
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "purple", args.destName, amount, 2)
		local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
		if amount > 1 and not self:Me(args.destGUID) and not self:Tanking(bossUnit) then
			self:PlaySound(args.spellId, "warning") -- taunt
		end
	end

	function mod:PhaseLunge(args)
		self:Message(args.spellId, "purple")
		local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
		if bossUnit and self:Tanking(bossUnit) then
			self:PlaySound(args.spellId, "alarm") -- defensive
		end
	end

	function mod:PiercedDefencesApplied(args)
		self:TargetMessage(args.spellId, "cyan", args.destName)
		self:PlaySound(args.spellId, "info")
	end
end

-- function mod:PhaseBlades(args)
-- 	self:Message(args.spellId, "yellow")
-- -- 	self:Bar(433517, 42)
-- end

function mod:PhaseBladesApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId, nil, nil, "Phase Blades")
	end
end

function mod:CosmicWoundApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info")
	end
end

function mod:RainOfArrows(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 42)
end

function mod:Decimate(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 42)
end
