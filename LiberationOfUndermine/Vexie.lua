if not BigWigsLoader.isTestBuild then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Vexie and the Geargrinders", 2769, 2639)
if not mod then return end
mod:RegisterEnableMob(225821) -- The Geargrinder
mod:SetEncounterID(3009)
mod:SetPrivateAuraSounds({
	459669, -- Spew Oil
})
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local tankBusterCount = 1
local spewOilCount = 1
local callBikersCount = 1
local incediaryFireCount = 1
local unrelentingCarnageCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.plating_removed = "%d Protective Plating left"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Stage One: Fury Road
		466615, -- Protective Plating
		471403, -- Unrelenting CAR-nage
		459943, -- Call Bikers
		459678, -- Spew Oil
			459683, -- Oil Slick
		{468216, "SAY", "SAY_COUNTDOWN"}, -- Incendiary Fire
		459978, -- Bomb Voyage!
		{465865, "TANK"}, -- Tank Buster
			468147,	-- Exhaust Fumes (DPS / Healers)
		-- Stage Two: Pit Stop
		{460116, "CASTBAR"}, -- Tune-Up
	},{ -- Sections
		[466615] = CL.stage:format(1),
		[460116] = CL.stage:format(2),
	},{ -- Renames
		[471403] = CL.full_energy, -- Unrelenting CAR-nage (Full Energy)
		[460116] = CL.weakened, -- Tune-Up (Weakened)
	}
end

function mod:OnRegister()
	self:SetSpellRename(460603, CL.weakened) -- Mechanical Breakdown (Weakened)
	self:SetSpellRename(460116, CL.weakened) -- Tune-Up (Weakened)
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_REMOVED_DOSE", "ProtectivePlatingRemoved", 466615)
	self:Log("SPELL_CAST_START", "UnrelentingCARnage", 471403)
	self:Log("SPELL_CAST_START", "CallBikers", 459943)
	self:Log("SPELL_CAST_START", "SpewOil", 459671)
	self:Log("SPELL_AURA_APPLIED", "SpewOilApplied", 459678) -- DOT after getting hit
	self:Log("SPELL_CAST_START", "IncendiaryFire", 468487)
	self:Log("SPELL_AURA_APPLIED", "IncendiaryFireApplied", 468216)
	self:Log("SPELL_AURA_REMOVED", "IncendiaryFireRemoved", 468216)
	self:Log("SPELL_AURA_APPLIED", "BombVoyageApplied", 459978) -- DOT after getting hit
	self:Log("SPELL_CAST_START", "TankBuster", 459627)
	self:Log("SPELL_CAST_SUCCESS", "TankBusterSuccess", 459627)
	self:Log("SPELL_AURA_APPLIED", "TankBusterApplied", 465865)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TankBusterApplied", 465865)

	self:Log("SPELL_CAST_START", "MechanicalBreakdown", 460603)
	self:Log("SPELL_AURA_APPLIED", "TuneUpApplied", 460116)
	self:Log("SPELL_AURA_REMOVED", "TuneUpRemoved", 460116)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 459683) -- Oil Slick
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 459683)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 459683)
end

function mod:OnEngage()
	self:SetStage(1)
	tankBusterCount = 1
	spewOilCount = 1
	callBikersCount = 1
	incediaryFireCount = 1
	unrelentingCarnageCount = 1

	self:CDBar(465865, 6.2, CL.count:format(self:SpellName(465865), tankBusterCount)) -- Tank Buster
	self:CDBar(468147, 6.2 + 1.5, CL.count:format(self:SpellName(468147), tankBusterCount)) -- Exhaust Fumes
	self:CDBar(459678, 12.2, CL.count:format(self:SpellName(459678), spewOilCount)) -- Spew Oil
	self:CDBar(459943, 20.4, CL.count:format(self:SpellName(459943), callBikersCount)) -- Call Bikers
	self:CDBar(468216, 15, CL.count:format(self:SpellName(468216), incediaryFireCount)) -- Incendiary Fire
	self:Bar(471403, 121, CL.count:format(CL.full_energy, unrelentingCarnageCount)) -- Unrelenting CAR-nage
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ProtectivePlatingRemoved(args)
	local platingsLeft = args.amount or 0
	if platingsLeft < 3 or platingsLeft % 2 == 0 then
		self:Message(args.spellId, "cyan", L.plating_removed:format(platingsLeft))
		if platingsLeft < 3 then
			self:PlaySound(args.spellId, "info") -- breaking soon
		end
	end
end

function mod:UnrelentingCARnage(args)
	self:Message(args.spellId, "red", CL.count:format(CL.full_energy, unrelentingCarnageCount))
	self:PlaySound(args.spellId, "warning") -- big damage inc
end

function mod:CallBikers(args)
	self:StopBar(CL.count:format(self:SpellName(args.spellName), callBikersCount))
	self:Message(args.spellId, "yellow", CL.count:format(self:SpellName(args.spellName), callBikersCount))
	self:PlaySound(args.spellId, "alert") -- adds incoming
	callBikersCount = callBikersCount + 1
	-- 20.4, 28.6, 28.2, 73.9, 28.2, 33.0, 28.1, 82.7
	self:CDBar(args.spellId, 28.2, CL.count:format(self:SpellName(args.spellName), callBikersCount))
end

function mod:SpewOil(args)
	self:StopBar(CL.count:format(self:SpellName(args.spellName), spewOilCount))
	self:Message(459678, "yellow", CL.count:format(self:SpellName(args.spellName), spewOilCount))
	-- self:PlaySound(459678, "alert") -- Private aura for targeted players
	-- 12.2, 38.0, 93.1, 21.3, 20.8, 20.8, 20.7, 20.8, 67.1, 21.9
	spewOilCount = spewOilCount + 1
	self:CDBar(459678, 20.7, CL.count:format(self:SpellName(args.spellName), spewOilCount))
end

function mod:SpewOilApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:IncendiaryFire(args)
	self:StopBar(CL.count:format(self:SpellName(args.spellName), incediaryFireCount))
	self:Message(468216, "orange", CL.count:format(self:SpellName(args.spellName), incediaryFireCount))
	incediaryFireCount = incediaryFireCount + 1
	-- 25.7, 31.0, 25.3, 92.0, 35.4, 89.5, 35.3, 36.4
	self:CDBar(468216, 30.5, CL.count:format(self:SpellName(args.spellName), incediaryFireCount))
end

function mod:IncendiaryFireApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:Say(args.spellId, nil, nil, "Incendiary Fire")
		self:SayCountdown(args.spellId, 6)
	end
end

function mod:IncendiaryFireRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:BombVoyageApplied(args) -- cast every 8s
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

do
	local tankbusterCD = 17.0
	function mod:TankBuster()
		self:StopBar(CL.count:format(self:SpellName(465865), tankBusterCount))
		self:Message(465865, "purple", CL.count:format(self:SpellName(465865), tankBusterCount))
		self:PlaySound(465865, "info")
		-- 6.2, 23.0, 27.1, 22.1, 59.1, 17.2, 16.7, 20.0, 22.0, 19.7, 75.6, 17.0, 17.0
		self:Bar(465865, tankbusterCD, CL.count:format(self:SpellName(465865), tankBusterCount + 1))
	end

	function mod:TankBusterSuccess()
		tankBusterCount = tankBusterCount + 1
		if not self:Tank() then
			self:CDBar(468147, tankbusterCD, CL.count:format(self:SpellName(468147), tankBusterCount)) -- Exhaust Fumes for non-tanks
		end
	end
end
function mod:TankBusterApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- On you
	end
end

function mod:MechanicalBreakdown()
	self:StopBar(CL.count:format(self:SpellName(465865), tankBusterCount)) -- Tank Buster
	self:StopBar(CL.count:format(self:SpellName(468147), tankBusterCount)) -- Exhaust Fumes
	self:StopBar(CL.count:format(self:SpellName(459678), spewOilCount)) -- Spew Oil
	self:StopBar(CL.count:format(self:SpellName(459943), callBikersCount)) -- Call Bikers
	self:StopBar(CL.count:format(self:SpellName(468216), incediaryFireCount)) -- Incendiary Fire
	self:StopBar(CL.count:format(CL.full_energy, unrelentingCarnageCount)) -- Unrelenting CAR-nage

	self:SetStage(2)
	self:Message(460116, "green", CL.casting:format(CL.weakened))
	self:PlaySound(460116, "long")
end

function mod:TuneUpApplied(args)
	self:CastBar(args.spellId, 45, CL.weakened)
end

function mod:TuneUpRemoved(args)
	self:StopCastBar(CL.weakened)

	self:SetStage(1)
	tankBusterCount = 1
	spewOilCount = 1
	callBikersCount = 1
	incediaryFireCount = 1
	unrelentingCarnageCount = unrelentingCarnageCount + 1

	self:CDBar(465865, 6.2, CL.count:format(self:SpellName(465865), tankBusterCount)) -- Tank Buster
	self:CDBar(468147, 6.2 + 1.5, CL.count:format(self:SpellName(468147), tankBusterCount)) -- Exhaust Fumes
	self:CDBar(459678, 12.2, CL.count:format(self:SpellName(459678), spewOilCount)) -- Spew Oil
	self:CDBar(459943, 20.4, CL.count:format(self:SpellName(459943), callBikersCount)) -- Call Bikers
	self:CDBar(468216, 15, CL.count:format(self:SpellName(468216), incediaryFireCount)) -- Incendiary Fire
	self:Bar(471403, 121, CL.count:format(CL.full_energy, unrelentingCarnageCount)) -- Unrelenting CAR-nage
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
