
--------------------------------------------------------------------------------
-- Module Declaration
--

if not BigWigs.isWOD then return end -- XXX compat
local mod, CL = BigWigs:NewBoss("Brackenspore", 994, 1196)
if not mod then return end
mod:RegisterEnableMob(78491)
--mod.engageId = 1720

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.spore_shooter = EJ_GetSectionInfo(9987)
	L.spore_shooter_desc = select(2, EJ_GetSectionInfo(9988))
	L.spore_shooter_icon = "Ability_Creature_Disease_03"

	L.mind_fungus, L.mind_fungus_desc = EJ_GetSectionInfo(9986)
	L.mind_fungus_icon = "inv_mushroom_10"

	L.flesh_eater, L.flesh_eater_desc = EJ_GetSectionInfo(9995)
	L.flesh_eater_icon = "Ability_Creature_Disease_02"

	L.living_mushroom = EJ_GetSectionInfo(9989)
	L.living_mushroom_desc = select(2, EJ_GetSectionInfo(9990))
	L.living_mushroom_icon = "inv_misc_starspecklemushroom"

	L.rejuvenating_mushroom = EJ_GetSectionInfo(9991)
	L.rejuvenating_mushroom_desc = select(2, EJ_GetSectionInfo(9992))
	L.rejuvenating_mushroom_icon = "Spell_Magic_ManaGain"

	L.creeping_moss_heal = "Creeping Moss under BOSS (healing)"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		163755, 163794,
		"spore_shooter", "mind_fungus", "flesh_eater", 160013,
		"living_mushroom", "rejuvenating_mushroom",
		{164125, "FLASH"}, {163241, "TANK"}, {159219, "TANK_HEALER"}, 159996, "berserk", "bosskill"
	}, {
		[163755] = "mythic",
		["spore_shooter"] = -9993,
		["living_mushroom"] = -9998,
		[164125] = "general"
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_APPLIED", "CreepingMossHeal", 164125)
	self:Log("SPELL_PERIODIC_HEAL", "CreepingMossHeal", 164125)
	self:Log("SPELL_AURA_APPLIED", "Rot", 163241)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Rot", 163241)
	self:Log("SPELL_CAST_START", "NecroticBreath", 159219)
	self:Log("SPELL_CAST_START", "InfestingSpores", 159996)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "FungusSpawns", "boss1")
	self:Log("SPELL_CAST_START", "Decay", 160013)
	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "CallOfTheTides", 163755)

	self:Death("Win", 78491)
end

function mod:OnEngage()
	self:Bar(159219, 30) -- Necrotic Breath
	self:Bar(159996, 90) -- Infesting Spores
	self:CDBar("mind_fungus", 10, L.mind_fungus, L.mind_fungus_icon) -- Mind Fungus
	self:CDBar("spore_shooter", 20, L.spore_shooter, L.spore_shooter_icon) -- Spore Shooter
	self:CDBar("flesh_eater", 32, CL.big_add, L.flesh_eater_icon) -- Fungal Flesh-Eater
	self:CDBar("living_mushroom", 60, L.living_mushroom, L.living_mushroom_icon) -- Living Mushroom
	self:CDBar("rejuvenating_mushroom", 80, L.rejuvenating_mushroom, L.rejuvenating_mushroom_icon) -- Rejuvenating Mushroom
	self:Berserk(600) -- LFR enrage
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CallOfTheTides(args)
	self:Message(args.spellId, "Urgent")
end

do
	local prev = 0
	function mod:CreepingMossHeal(args)
		local t = GetTime()
		local mobId = self:MobId(args.destGUID)
		if self:Tank() and not self:LFR() and (mobId == 78491 or mobId == 79092) and t-prev > 1 then -- Brackenspore or Fungal Flesh-Eater
			self:Message(args.spellId, "Important", "Alarm", L.creeping_moss_heal)
			prev = t
		end
	end
end

function mod:Rot(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 4 and "Warning")
end

function mod:NecroticBreath(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:Bar(args.spellId, 30)
end

function mod:InfestingSpores(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:Bar(args.spellId, 103)
end

function mod:Decay(args)
	self:Message(args.spellId, "Personal", not self:Healer() and "Alert", CL.casting:format(args.spellName))
end

function mod:FungusSpawns(unit, spellName, _, _, spellId)
	if spellId == 164125 then -- Creeping Moss
		local flamethrower = UnitBuff("player", self:SpellName(163322))
		self:Message(spellId, "Urgent", flamethrower and "Warning")
		if flamethrower then
			self:Flash(spellId)
		end
	elseif spellId == 163594 then -- Spore Shooter
		self:Message("spore_shooter", "Attention", nil, spellId, L.spore_shooter_icon)
		self:Bar("spore_shooter", 60, spellId, L.spore_shooter_icon)
	elseif spellId == 163141 then -- Mind Fungus
		self:Message("mind_fungus", "Attention", nil, spellId, L.mind_fungus_icon)
		self:Bar("mind_fungus", 30, spellId, L.mind_fungus_icon)
	elseif spellId == 163142 then -- Evolved Fungus (Fungal Flesh-Eater)
		self:Message("flesh_eater", "Urgent", self:Tank() and "Info", CL.spawning:format(CL.big_add), L.flesh_eater_icon)
		self:Bar("flesh_eater", 120, CL.big_add, L.flesh_eater_icon)
	elseif spellId == 160022 then -- Living Mushroom
		self:Message("living_mushroom", "Positive", self:Healer() and "Info", spellId, L.living_mushroom_icon)
		self:Bar("living_mushroom", 60, spellId, L.living_mushroom_icon)
	elseif spellId == 160021 then -- Rejuvenating Mushroom
		self:Message("rejuvenating_mushroom", "Positive", self:Healer() and "Info", spellId, L.rejuvenating_mushroom_icon)
		self:Bar("rejuvenating_mushroom", 145, spellId, L.rejuvenating_mushroom_icon)
	elseif spellId == 163794 then  -- Exploding Fungus (Mythic)
		self:Message(spellId, "Urgent")
		self:Bar(spellId, 5)
	end
end

