
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
	L.decay, L.decay_desc = EJ_GetSectionInfo(9996)
	L.decay_icon = "Spell_Nature_WispSplodeGreen"
	L.decay_message = "Your focus is casting Decay!"

	-- don't really need them here, but hey! might end up making an option for each fungus
	L.spore_shooter_icon = "INV_Elemental_Primal_Mana"
	L.mind_fungus_icon = "inv_mushroom_10"
	L.flesh_eater_icon = "Ability_Creature_Disease_02"
	L.living_mushroom_icon = "inv_misc_starspecklemushroom"
	L.rejuvenating_mushroom_icon = "Spell_Magic_ManaGain"
end
L = mod:GetLocale()
L.decay_desc = CL.focus_only..L.decay_desc

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{164125, "TANK"}, {163241, "TANK"}, {159219, "TANK_HEALER"}, 159996, "decay", -9993, {-9998, "HEALER"}, "bosskill"
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_APPLIED", "CreepingMoss", 164125)
	self:Log("SPELL_PERIODIC_HEAL", "CreepingMoss", 164125)
	self:Log("SPELL_AURA_APPLIED", "Rot", 163241)
	self:Log("SPELL_CAST_START", "NecroticBreath", 159219)
	self:Log("SPELL_CAST_START", "InfestingSpores", 159996)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "FungusSpawns", "boss1")
	self:Log("SPELL_CAST_START", "Decay", 160013)

	self:Death("Win", 78491)
end

function mod:OnEngage()
	self:Bar(159219, 30) -- Necrotic Breath
	self:Bar(159996, 90) -- Infesting Spores
	self:Bar(-9998, 60, 160022, L.living_mushroom_icon) -- Living Mushroom
	self:Bar(-9998, 80, 160021, L.rejuvenating_mushroom_icon) -- Rejuvenating Mushroom
	self:Bar(-9993, 10, 163141, L.mind_fungus_icon) -- Mind Fungus
	self:Bar(-9993, 20, 163594, L.spore_shooter_icon) -- Spore Shooter
	self:CDBar(-9993, 32, -9995, L.flesh_eater_icon) -- Fungal Flesh-Eater
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:CreepingMoss(args)
		local t = GetTime()
		local mobId = self:MobId(args.destGUID)
		if (mobId == 78491 or mobId == 79092) and t-prev > 2 then -- Brackenspore or Fungal Flesh-Eater
			self:Message(args.spellId, "Urgent", "Alarm")
			prev = t
		end
	end
end

function mod:Rot(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 4 and "Warning")
end

function mod:NecroticBreath(args)
	self:Message(args.spellId, "Urgent", "Alert")
	self:Bar(args.spellId, 30)
end

function mod:InfestingSpores(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:Bar(args.spellId, 103)
end

function mod:Decay(args)
	if UnitGUID("focus") == args.sourceGUID then
		self:Message("decay", "Personal", "Alert", L.decay_message, L.decay_icon)
	end
end

function mod:FungusSpawns(unit, spellName, _, _, spellId)
	if spellId == 163594 then -- Spore Shooter
		self:Message(-9993, "Attention", nil, spellId, L.spore_shooter_icon)
		self:Bar(-9993, 60, spellId, L.spore_shooter_icon)
	elseif spellId == 163141 then -- Mind Fungus
		self:Message(-9993, "Attention", nil, spellId, L.mind_fungus_icon)
		self:Bar(-9993, 30, spellId, L.mind_fungus_icon)
	elseif spellId == 163142 then -- Evolved Fungus (Fungal Flesh-Eater)
		self:Message(-9993, "Attention", self:Tank() and "Info", -9995, L.flesh_eater_icon)  -- Fungal Flesh-Eater
		self:Bar(-9993, 120, -9995, L.flesh_eater_icon)
	elseif spellId == 160022 then -- Living Mushroom
		self:Message(-9998, "Positive", "Info", spellId, L.living_mushroom_icon)
		self:Bar(-9998, 60, spellId, L.living_mushroom_icon)
	elseif spellId == 160021 then -- Rejuvenating Mushroom
		self:Message(-9998, "Positive", "Info", spellId, L.rejuvenating_mushroom_icon)
		self:Bar(-9998, 145, spellId, L.rejuvenating_mushroom_icon)
	end
end

