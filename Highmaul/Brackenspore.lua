
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Brackenspore", 994, 1196)
if not mod then return end
mod:RegisterEnableMob(78491)
mod.engageId = 1720

--------------------------------------------------------------------------------
-- Locals
--
local decayCount = 1
local infestingSporesCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.spore_shooter = ("{-9987} (%s)"):format(CL.small_adds) -- Spore Shooter
	L.spore_shooter_desc = -9988 -- Spore Shoot
	L.spore_shooter_icon = "Ability_Creature_Disease_03"

	L.mind_fungus = -9986 -- Mind Fungus
	L.mind_fungus_icon = "inv_mushroom_10"

	L.flesh_eater = ("{-9995} (%s)"):format(CL.big_add) -- Fungul Flesh-Eater
	L.flesh_eater_desc = -9997 -- Flesh Eater
	L.flesh_eater_icon = "Ability_Creature_Disease_02"

	L.living_mushroom = -9989 -- Living Mushroom
	L.living_mushroom_desc = -9990 -- Living Spores
	L.living_mushroom_icon = "inv_misc_starspecklemushroom"

	L.rejuvenating_mushroom = -9991 -- Rejuvenating Mushroom
	L.rejuvenating_mushroom_desc = -9992 -- Rejuvenating Spores
	L.rejuvenating_mushroom_icon = "Spell_Magic_ManaGain"

	L.creeping_moss_boss_heal = "Moss under BOSS (healing)"
	L.creeping_moss_add_heal = "Moss under BIG ADD (healing)"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Mythic ]]--
		163755, -- Call of the Tides
		163794, -- Exploding Fungus
		--[[ Hostile Fungus ]]--
		"spore_shooter", -- Small Adds
		"mind_fungus", -- Bad Shroom (Reduced casting speed)
		"flesh_eater", -- Big Add
		160013, -- Decay
		--[[ Beneficial Mushrooms ]]--
		"living_mushroom", -- Good Shroom (Heals units in 20yd)
		"rejuvenating_mushroom", -- Good Shroom (Increased haste and Mana regen)
		--[[ General ]]--
		{164125, "FLASH"}, -- Creeping Moss
		{163241, "TANK"}, -- Rot
		{159219, "TANK_HEALER"}, -- Necrotic Breath
		159996, -- Infesting Spores
		"berserk",
		"bosskill"
	}, {
		[163755] = "mythic",
		["spore_shooter"] = -9993, -- Hostile Fungus
		["living_mushroom"] = -9998, -- Beneficial Mushrooms
		[164125] = "general"
	}
end

function mod:OnBossEnable()
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
end

function mod:OnEngage()
	self:Bar(159219, 32) -- Necrotic Breath
	self:Bar(159996, 45) -- Infesting Spores
	self:CDBar("mind_fungus", 10, L.mind_fungus, L.mind_fungus_icon) -- Mind Fungus
	self:CDBar("spore_shooter", 20, CL.small_adds, L.spore_shooter_icon) -- Spore Shooter
	self:CDBar("flesh_eater", 32, CL.big_add, L.flesh_eater_icon) -- Fungal Flesh-Eater
	self:CDBar("living_mushroom", 18, L.living_mushroom, L.living_mushroom_icon) -- Living Mushroom
	self:CDBar("rejuvenating_mushroom", 82, L.rejuvenating_mushroom, L.rejuvenating_mushroom_icon) -- Rejuvenating Mushroom
	self:Berserk(600) -- LFR enrage
	decayCount = 1
	infestingSporesCount = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CallOfTheTides(args)
	self:Message(args.spellId, "Urgent")
	self:CDBar(args.spellId, 21) -- 21-32
end

do
	local prevAdd = 0
	local prevBoss = 0
	function mod:CreepingMossHeal(args)
		local t = GetTime()
		if self:Tank() and not self:LFR() then
			local mobId = self:MobId(args.destGUID)
			if t-prevBoss > 2 and mobId == 78491 then -- Brackenspore
				self:Message(args.spellId, "Important", "Info", L.creeping_moss_boss_heal)
				prevBoss = t
			elseif t-prevAdd > 2 and mobId == 79092 then -- Fungal Flesh-Eater
				self:Message(args.spellId, "Important", nil, L.creeping_moss_add_heal)
				prevAdd = t
			end
		end
	end
end

function mod:Rot(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 4 and "Warning")
end

function mod:NecroticBreath(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:Bar(args.spellId, 32)
end

function mod:InfestingSpores(args)
	self:Message(args.spellId, "Important", "Alarm", CL.casting:format(CL.count:format(args.spellName, infestingSporesCount)))
	infestingSporesCount = infestingSporesCount + 1
	self:Bar(args.spellId, 65, CL.count:format(args.spellName, infestingSporesCount))
end

function mod:Decay(args)
	self:Message(args.spellId, "Personal", not self:Healer() and "Alert", CL.casting:format(CL.count:format(args.spellName, decayCount)))
	decayCount = decayCount + 1
	self:Bar(args.spellId, 10, CL.count:format(args.spellName, decayCount))
end

function mod:FungusSpawns(unit, spellName, _, _, spellId)
	if spellId == 164125 then -- Creeping Moss
		local flamethrower = UnitBuff("player", self:SpellName(163322))
		self:Message(spellId, "Urgent", flamethrower and "Warning")
		if flamethrower then
			self:Flash(spellId)
		end
	elseif spellId == 163594 then -- Spore Shooter
		self:Message("spore_shooter", "Attention", nil, CL.small_adds, L.spore_shooter_icon)
		self:Bar("spore_shooter", 60, CL.small_adds, L.spore_shooter_icon)
	elseif spellId == 163141 then -- Mind Fungus
		self:Message("mind_fungus", "Attention", nil, spellId, L.mind_fungus_icon)
		self:CDBar("mind_fungus", 51, spellId, L.mind_fungus_icon) -- 51.1, 58.6, 55.5, 55, 61.5, 59.5
	elseif spellId == 163142 then -- Evolved Fungus (Fungal Flesh-Eater)
		self:Message("flesh_eater", "Urgent", self:Tank() and "Long", CL.spawning:format(CL.big_add), L.flesh_eater_icon)
		self:Bar("flesh_eater", 120, CL.big_add, L.flesh_eater_icon)
		decayCount = 1
	elseif spellId == 160022 then -- Living Mushroom
		self:Message("living_mushroom", "Positive", self:Healer() and "Long", spellId, L.living_mushroom_icon)
		self:Bar("living_mushroom", 58, spellId, L.living_mushroom_icon)
	elseif spellId == 160021 then -- Rejuvenating Mushroom
		self:Message("rejuvenating_mushroom", "Positive", self:Healer() and "Long", spellId, L.rejuvenating_mushroom_icon)
		self:Bar("rejuvenating_mushroom", 135, spellId, L.rejuvenating_mushroom_icon)
	elseif spellId == 163794 then -- Exploding Fungus (Mythic)
		self:Message(spellId, "Urgent")
		self:Bar(spellId, 5)
	end
end