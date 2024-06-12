if not BigWigsLoader.isBeta then return end -- Beta check

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Ulgrax the Devourer", 2657, 2607)
if not mod then return end
mod:RegisterEnableMob(215657) -- Ulgrax the Devourer XXX Confirm on PTR
mod:SetEncounterID(2902)
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
		-- "stages",
		-- Gleeful Brutality
		434803, -- Brutal Lashings
		449268, -- Carnivorous Contest
		441451, -- Stalkers Webbing
		-- 439419, -- Stalker Netting
		435136, -- Venomous Lash
		{434697, "TANK"}, -- Brutal Crush
		{434705, "TANK"}, -- Tenderized
		-- Feeding Frenzy
		-- -28848, -- Ravenous Spawn
		439037, -- Disembowel
		436200, -- Juggernaut Charge
		443842, -- Swallowing Darkness
		438012, -- Hungering Bellows
		445123, -- Hulking Crash
	},{
		[434803] = -30011,
		[439037] = -28845,
	}
end

function mod:OnBossEnable()
	-- Gleeful Brutality
	self:Log("SPELL_CAST_START", "BrutalLashings", 434803)
	self:Log("SPELL_AURA_APPLIED", "CarnivorousContestApplied", 449268) -- Any pre-warning during Brutal Lasings?
	self:Log("SPELL_CAST_START", "StalkersWebbing", 441451, 441452) -- XXX Confirm if both ids are used
	self:Log("SPELL_AURA_APPLIED", "StalkerNettingApplied", 441451)
	self:Log("SPELL_CAST_START", "VenomousLash", 435136)
	self:Log("SPELL_CAST_START", "BrutalCrush", 434697)
	self:Log("SPELL_AURA_APPLIED", "TenderizedApplied", 434705)

	-- Feeding Frenzy
	-- self:Death("RavenousSpawnKilled", 216205) -- Ravenous Spawn -- energy/feed message probably better?
	self:Log("SPELL_AURA_APPLIED", "DisembowelApplied", 439037)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DisembowelApplied", 439037)
	self:Log("SPELL_CAST_START", "JuggernautCharge", 436200, 436203) -- XXX Confirm if both ids are used
	self:Log("SPELL_CAST_START", "SwallowingDarkness", 443842)
	self:Log("SPELL_CAST_START", "HungeringBellows", 438012)
	self:Log("SPELL_CAST_START", "HulkingCrash", 445123, 445290) -- XXX Confirm if both ids are used
end

function mod:OnEngage()
	-- self:Bar(434803, 45) -- Brutal Lashings
	-- self:Bar(441451, 45) -- Stalkers Webbing
	-- self:Bar(435136, 45) -- Venomous Lash
	-- self:Bar(434697, 45) -- Brutal Crush
	-- self:Bar("stages", 60, -28845, 438324) -- Feeding Frenzy
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Gleeful Brutality
function mod:BrutalLashings(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 45)
end

function mod:CarnivorousContestApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:StalkersWebbing(args)
	self:Message(441451, "cyan", CL.incoming:format(args.spellName))
	self:PlaySound(441451, "info")
	--self:Bar(441451, 45)
end

function mod:StalkerNettingApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:VenomousLash(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 45)
end

function mod:BrutalCrush(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 45)
end

function mod:TenderizedApplied(args)
	self:TargetMessage(args.spellId, "yellow", args.destName)
	self:PlaySound(args.spellId, "warning") -- tankswap
end

-- Feeding Frenzy
-- function mod:RavenousSpawnKilled()
-- 	self:Message(-28848, "cyan", CL.killed:format(self:SpellName(-28848)), false)
-- 	self:PlaySound(-28848, "info")
-- end

function mod:DisembowelApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "purple", args.destName, amount, 3)
		if amount > 3 then
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:JuggernautCharge(args)
	self:Message(436200, "red")
	self:PlaySound(436200, "alert")
	--self:Bar(436200, 45)
end

function mod:SwallowingDarkness(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, 45)
end

function mod:HungeringBellows(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 45)
end

function mod:HulkingCrash(args)
	self:Message(445123, "red")
	self:PlaySound(445123, "warning")
	--self:Bar(445123, 45)
end
