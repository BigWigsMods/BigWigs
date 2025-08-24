
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Vexie and the Geargrinders", 2769, 2639)
if not mod then return end
mod:RegisterEnableMob(225821, 225822) -- The Geargrinder, Vexie Fullthrottle
mod:SetEncounterID(3009)
mod:SetPrivateAuraSounds({
	459669, -- Spew Oil
	468486, -- Incendiary Fire (Pre-debuff on SPELL_CAST_START)
})
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local tankBusterCount = 1
local spewOilCount = 1
local callBikersCount = 1
local incendiaryFireCount = 1
local unrelentingCarnageCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	local _, vexie = EJ_GetCreatureInfo(2, 2639)
	L.vexie = vexie
end

--------------------------------------------------------------------------------
-- Initialization
--

local vexieMarker = mod:AddMarkerOption(true, "npc", 8, "vexie", 8) -- Vexie
function mod:GetOptions()
	return {
		-- Stage One: Fury Road
		466615, -- Protective Plating
		471403, -- Unrelenting CAR-nage
		459943, -- Call Bikers
		459678, -- Spew Oil
			459683, -- Oil Slick
		{468216, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Incendiary Fire
		459978, -- Bomb Voyage!
		{465865, "TANK", "EMPHASIZE"}, -- Tank Buster
			468147,	-- Exhaust Fumes (DPS / Healers)
		-- Stage Two: Pit Stop
		460116, -- Tune-Up
		vexieMarker,
		"stages",
	},{ -- Sections
		[466615] = CL.stage:format(1),
		[460116] = CL.stage:format(2),
		[vexieMarker] = CL.stage:format(3),
	},{ -- Renames
		[471403] = CL.full_energy, -- Unrelenting CAR-nage (Full Energy)
		[459943] = CL.adds, -- Call Bikers (Adds)
		[468216] = CL.fire, -- Incendiary Fire (Fire)
		[468147] = CL.raid_damage, -- Exhaust Fumes (Raid Damage)
		[460116] = CL.weakened, -- Tune-Up (Weakened)
	}
end

function mod:OnRegister()
	self:SetSpellRename(471403, CL.full_energy) -- Unrelenting CAR-nage (Full Energy)
	self:SetSpellRename(459943, CL.adds) -- Call Bikers (Adds)
	self:SetSpellRename(468487, CL.fire) -- Incendiary Fire (Fire)
	self:SetSpellRename(460116, CL.weakened) -- Tune-Up (Weakened)
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_REMOVED_DOSE", "ProtectivePlatingRemovedDose", 466615)
	self:Log("SPELL_CAST_START", "UnrelentingCARnage", 471403)
	self:Log("SPELL_CAST_START", "CallBikers", 459943)
	self:Log("SPELL_CAST_START", "SpewOil", 459671)
	self:Log("SPELL_AURA_APPLIED", "SpewOilApplied", 459678) -- DOT after getting hit
	self:Log("SPELL_CAST_START", "IncendiaryFire", 468487)
	self:Log("SPELL_AURA_APPLIED", "IncendiaryFireApplied", 468216)
	self:Log("SPELL_AURA_REMOVED", "IncendiaryFireRemoved", 468216)
	self:Log("SPELL_AURA_APPLIED", "BombVoyageApplied", 459978) -- DOT after getting hit
	self:Log("SPELL_CAST_START", "TankBuster", 459627)
	self:Log("SPELL_AURA_APPLIED", "ExhaustFumesApplied", 468149) -- On Boss
	self:Log("SPELL_AURA_APPLIED_DOSE", "ExhaustFumesApplied", 468149)

	self:Log("SPELL_CAST_START", "MechanicalBreakdown", 460603)
	self:Log("SPELL_AURA_APPLIED", "TuneUpApplied", 460116)
	self:Log("SPELL_AURA_REMOVED", "TuneUpRemoved", 460116)

	self:Log("SPELL_AURA_APPLIED", "OilSlickDamage", 459683) -- Oil Slick
	self:Log("SPELL_PERIODIC_DAMAGE", "OilSlickDamage", 459683)
	self:Log("SPELL_PERIODIC_MISSED", "OilSlickDamage", 459683)

	self:Death("GeargrinderDeath", 225821)
end

function mod:OnEngage()
	self:SetStage(1)
	tankBusterCount = 1
	spewOilCount = 1
	callBikersCount = 1
	incendiaryFireCount = 1
	unrelentingCarnageCount = 1

	self:CDBar(465865, 6.2, CL.count:format(self:SpellName(465865), tankBusterCount)) -- Tank Buster
	if not self:Tank() then
		self:CDBar(468147, 7.7, CL.count:format(CL.raid_damage, tankBusterCount)) -- Exhaust Fumes (Tank Buster cooldown 6.2 + cast time 1.5 = 7.7)
	end
	self:CDBar(459678, 12.2, CL.count:format(self:SpellName(459678), spewOilCount)) -- Spew Oil
	self:CDBar(459943, 20.4, CL.count:format(CL.adds, callBikersCount)) -- Call Bikers
	self:CDBar(468216, 15, CL.count:format(CL.fire, incendiaryFireCount)) -- Incendiary Fire
	self:Bar(471403, 121, CL.count:format(CL.full_energy, unrelentingCarnageCount)) -- Unrelenting CAR-nage
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ProtectivePlatingRemovedDose(args)
	self:StackMessage(args.spellId, "cyan", CL.boss, args.amount, args.amount == 1 and 1 or 100) -- Only emph on 1
end

function mod:UnrelentingCARnage(args)
	self:StopBar(CL.count:format(CL.full_energy, unrelentingCarnageCount)) -- Unrelenting CAR-nage
	self:StopBar(CL.count:format(self:SpellName(465865), tankBusterCount)) -- Tank Buster
	self:StopBar(CL.count:format(CL.raid_damage, tankBusterCount)) -- Exhaust Fumes
	self:StopBar(CL.count:format(self:SpellName(459678), spewOilCount)) -- Spew Oil
	self:StopBar(CL.count:format(CL.adds, callBikersCount)) -- Call Bikers
	self:StopBar(CL.count:format(CL.fire, incendiaryFireCount)) -- Incendiary Fire

	self:Message(args.spellId, "red", CL.count:format(CL.full_energy, unrelentingCarnageCount))
	self:PlaySound(args.spellId, "warning") -- big damage inc
end

function mod:CallBikers(args)
	self:StopBar(CL.count:format(CL.adds, callBikersCount))
	self:Message(args.spellId, "yellow", CL.count:format(CL.adds, callBikersCount))
	callBikersCount = callBikersCount + 1
	-- 20.4, 28.6, 28.2, 73.9, 28.2, 33.0, 28.1, 82.7
	self:CDBar(args.spellId, 28.2, CL.count:format(CL.adds, callBikersCount))
	self:PlaySound(args.spellId, "alert") -- adds incoming
end

function mod:SpewOil(args)
	self:StopBar(CL.count:format(args.spellName, spewOilCount))
	self:Message(459678, "yellow", CL.count:format(args.spellName, spewOilCount))
	-- self:PlaySound(459678, "alert") -- Private aura for targeted players
	-- 12.2, 38.0, 93.1, 21.3, 20.8, 20.8, 20.7, 20.8, 67.1, 21.9
	spewOilCount = spewOilCount + 1
	self:CDBar(459678, 20.7, CL.count:format(args.spellName, spewOilCount))
end

function mod:SpewOilApplied(args)
	if self:Me(args.destGUID) then
		-- Debuff after Private Aura expires
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm", nil, args.destName)
	end
end

function mod:IncendiaryFire(args)
	self:StopBar(CL.count:format(CL.fire, incendiaryFireCount))
	self:Message(468216, "orange", CL.count:format(CL.fire, incendiaryFireCount))
	incendiaryFireCount = incendiaryFireCount + 1
	-- 25.7, 31.0, 25.3, 92.0, 35.4, 89.5, 35.3, 36.4
	self:CDBar(468216, 30.5, CL.count:format(CL.fire, incendiaryFireCount))
end

function mod:IncendiaryFireApplied(args) -- There's a Private Aura for the pre-debuff (3 sec cast) and then this applies
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:Say(args.spellId, CL.fire, nil, "Fire")
		self:SayCountdown(args.spellId, 6)
		self:PlaySound(args.spellId, "warning", nil, args.destName)
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
		self:PlaySound(args.spellId, "alarm", nil, args.destName)
	end
end

function mod:TankBuster(args)
	local msg = CL.count:format(self:SpellName(465865), tankBusterCount)
	self:StopBar(msg)
	tankBusterCount = tankBusterCount + 1
	-- 6.2, 23.0, 27.1, 22.1, 59.1, 17.2, 16.7, 20.0, 22.0, 19.7, 75.6, 17.0, 17.0
	self:CDBar(465865, 17.0, CL.count:format(self:SpellName(465865), tankBusterCount))

	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	local destGUID, targetName = nil, nil
	if unit then
		local unitTarget = unit.."target"
		targetName = self:UnitName(unitTarget)
		destGUID = self:UnitGUID(unitTarget)
	end
	if destGUID and targetName then
		if self:Me(destGUID) then
			self:PersonalMessage(465865)
			self:PlaySound(465865, "alarm", nil, targetName) -- On you
		elseif self:Tank() then
			self:TargetMessage(465865, "purple", targetName, msg)
			self:PlaySound(465865, "warning", nil, targetName) -- Taunt
		end
	else
		self:Message(465865, "purple", msg, nil, true) -- Disable emphasize
		self:PlaySound(465865, "alarm") -- Backup if unit scan fails
	end
end

function mod:ExhaustFumesApplied(args)
	-- reusing tankBusterCount as this is a result of that cast
	if not self:Tank() then
		self:StopBar(CL.count:format(CL.raid_damage, tankBusterCount-1)) -- Exhaust Fumes for non-tanks
		self:Message(468147, "yellow", CL.count:format(CL.raid_damage, tankBusterCount-1))
		self:CDBar(468147, 17.0, CL.count:format(CL.raid_damage, tankBusterCount)) -- Exhaust Fumes for non-tanks
		self:PlaySound(468147, "info") -- raid dot effect
	end
end

function mod:MechanicalBreakdown()
	self:StopBar(CL.count:format(self:SpellName(465865), tankBusterCount)) -- Tank Buster
	self:StopBar(CL.count:format(CL.raid_damage, tankBusterCount)) -- Exhaust Fumes
	self:StopBar(CL.count:format(self:SpellName(459678), spewOilCount)) -- Spew Oil
	self:StopBar(CL.count:format(CL.adds, callBikersCount)) -- Call Bikers
	self:StopBar(CL.count:format(CL.fire, incendiaryFireCount)) -- Incendiary Fire
	self:StopBar(CL.count:format(CL.full_energy, unrelentingCarnageCount)) -- Unrelenting CAR-nage
	self:StackMessage(466615, "cyan", CL.boss, 0, 0) -- Do this here instead of in the REMOVED function, to prevent showing a "0 stacks" message when she ejects
end

function mod:TuneUpApplied(args)
	self:SetStage(2)
	self:Message(args.spellId, "green", CL.weakened)
	self:Bar(args.spellId, 45, CL.weakened)
	self:PlaySound(args.spellId, "long")
end

function mod:TuneUpRemoved(args)
	self:StopBar(CL.weakened)

	self:SetStage(1)
	tankBusterCount = 1
	spewOilCount = 1
	callBikersCount = 1
	incendiaryFireCount = 1
	unrelentingCarnageCount = unrelentingCarnageCount + 1

	self:CDBar(465865, 6.2, CL.count:format(self:SpellName(465865), tankBusterCount)) -- Tank Buster
	self:CDBar(468147, 7.7, CL.count:format(CL.raid_damage, tankBusterCount)) -- Exhaust Fumes (Tank Buster cooldown 6.2 + cast time 1.5 = 7.7)
	self:CDBar(459678, 12.2, CL.count:format(self:SpellName(459678), spewOilCount)) -- Spew Oil
	self:CDBar(459943, 20.4, CL.count:format(CL.adds, callBikersCount)) -- Call Bikers
	self:CDBar(468216, 15, CL.count:format(CL.fire, incendiaryFireCount)) -- Incendiary Fire
	self:Bar(471403, 121, CL.count:format(CL.full_energy, unrelentingCarnageCount)) -- Unrelenting CAR-nage

	self:Message(args.spellId, "green", CL.over:format(CL.weakened))
	self:PlaySound(args.spellId, "info")
end

do
	local prev = 0
	function mod:OilSlickDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PersonalMessage(args.spellId, "underyou")
			self:PlaySound(args.spellId, "underyou")
		end
	end
end

do
	function mod:VexieMarking(_, unit, guid)
		if self:MobId(guid) == 225822 then
			self:CustomIcon(vexieMarker, unit, 8)
			self:UnregisterTargetEvents()
		end
	end

	function mod:GeargrinderDeath()
		self:SetStage(3)
		self:RegisterTargetEvents("VexieMarking")
		self:Message("stages", "cyan", L.vexie, 8)
		self:PlaySound("stages", "info")
	end
end
