if not BigWigsLoader.onTestBuild then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Volcoross", 2549, 2557)
if not mod then return end
mod:RegisterEnableMob(208478) -- Volcoross
mod:SetEncounterID(2737)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local serpentsFuryCount = 1
local floodOfTheFirelandsCount = 1
local volcanicDisgorgeCount = 1
local scorchtailCrashCount = 1
local cataclysmJawsCount = 1

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

function mod:GetOptions()
	return {
		421082, -- Hellboil
		421672, -- Serpent's Fury
		{421207, "SAY", "SAY_COUNTDOWN"}, -- Coiling Flames
		420933, -- Flood of the Firelands
		421616, -- Volcanic Disgorge
		420415, -- Scorchtail Crash
		423494, -- Tidal Blaze
		{419054, "TANK"}, -- Molten Venom
		{423117, "TANK"}, -- Cataclysm Jaws
		421703, -- Serpent's Wrath
		424218, -- Combusting Rage
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "SerpentsFury", 421672)
	self:Log("SPELL_AURA_APPLIED", "CoilingFlamesApplied", 421207)
	self:Log("SPELL_AURA_REMOVED", "CoilingFlamesRemoved", 421207)
	self:Log("SPELL_CAST_START", "FloodOfTheFirelands", 420933)
	self:Log("SPELL_CAST_START", "VolcanicDisgorge", 421616)
	self:Log("SPELL_CAST_START", "ScorchtailCrash", 420415)
	self:Log("SPELL_AURA_APPLIED", "MoltenVenomApplied", 419054)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MoltenVenomApplied", 419054)
	self:Log("SPELL_CAST_START", "CataclysmJaws", 423117)
	self:Log("SPELL_CAST_START", "SerpentsWrath", 421703)
	self:Log("SPELL_AURA_APPLIED", "CombustingRage", 424218)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 421082, 423494) -- Hellboil, Tidal Blaze
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 421082, 423494)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 421082, 423494)
end

function mod:OnEngage()
	serpentsFuryCount = 1
	floodOfTheFirelandsCount = 1
	volcanicDisgorgeCount = 1
	scorchtailCrashCount = 1
	cataclysmJawsCount = 1

	--self:Bar(421672, 30, CL.count:format(self:SpellName(421672), serpentsFuryCount)) -- Serpent's Fury
	--self:Bar(420933, 30, CL.count:format(self:SpellName(420933), floodOfTheFirelandsCount)) -- Flood of the Firelands
	--self:Bar(421616, 30, CL.count:format(self:SpellName(421616), volcanicDisgorgeCount)) -- Volcanic Disgorge
	--self:Bar(420415, 30, CL.count:format(self:SpellName(420415), scorchtailCrashCount)) -- Scorchtail Crash
	--self:Bar(423117, 30, CL.count:format(self:SpellName(423117), cataclysmJawsCount)) -- Cataclysm Jaws
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SerpentsFury(args)
	self:StopBar(CL.count:format(args.spellName, serpentsFuryCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, serpentsFuryCount))
	self:PlaySound(args.spellId, "alert")
	serpentsFuryCount = serpentsFuryCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(args.spellName, serpentsFuryCount))
end

do
	function mod:CoilingFlamesApplied(args)
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 10)
		end
	end

	function mod:CoilingFlamesRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:FloodOfTheFirelands(args)
	self:StopBar(CL.count:format(args.spellName, floodOfTheFirelandsCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, floodOfTheFirelandsCount))
	self:PlaySound(args.spellId, "long")
	floodOfTheFirelandsCount = floodOfTheFirelandsCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(args.spellName, floodOfTheFirelandsCount))
end

function mod:VolcanicDisgorge(args)
	self:StopBar(CL.count:format(args.spellName, volcanicDisgorgeCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, volcanicDisgorgeCount))
	self:PlaySound(args.spellId, "alert")
	volcanicDisgorgeCount = volcanicDisgorgeCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(args.spellName, volcanicDisgorgeCount))
end

function mod:ScorchtailCrash(args)
	self:StopBar(CL.count:format(args.spellName, scorchtailCrashCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, scorchtailCrashCount))
	self:PlaySound(args.spellId, "alarm")
	scorchtailCrashCount = scorchtailCrashCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(args.spellName, scorchtailCrashCount))
end

function mod:MoltenVenomApplied(args)
	local amount = args.amount or 1
	if amount % 3 == 0 then
		self:StackMessage(args.spellId, "purple", args.destName, args.amount, 6)
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm") -- On you
		end
	end
end

function mod:CataclysmJaws(args)
	self:StopBar(CL.count:format(args.spellName, cataclysmJawsCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, cataclysmJawsCount))
	self:PlaySound(args.spellId, "alarm")
	cataclysmJawsCount = cataclysmJawsCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(args.spellName, cataclysmJawsCount))
end

function mod:SerpentsWrath(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:CombustingRage(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
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
