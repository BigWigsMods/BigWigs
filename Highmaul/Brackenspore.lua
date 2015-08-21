
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
local livingMushroomCount = 1
-- marking
local markableMobs = {}
local marksUsed = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.mythic_ability = "Special ability"
	L.mythic_ability_desc = "Show a timer bar for the next Call of the Tides or Exploding Fungus."
	L.mythic_ability_icon = "achievement_boss_highmaul_fungalgiant"
	L.mythic_ability_wave = "Incoming Wave!"

	L.custom_off_spore_shooter_marker = "Spore Shooter marker"
	L.custom_off_spore_shooter_marker_desc = "Mark Spore Shooters with {rt1}{rt2}{rt3}{rt4}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over the mobs is the fastest way to mark them.|r"
	L.custom_off_spore_shooter_marker_icon = 1

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

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Mythic ]]--
		{163755, "FLASH"}, -- Call of the Tides
		{163794, "FLASH"}, -- Exploding Fungus
		"mythic_ability",
		--[[ Hostile Fungus ]]--
		"spore_shooter", -- Small Adds
		"custom_off_spore_shooter_marker",
		"mind_fungus", -- Bad Shroom (Reduced casting speed)
		"flesh_eater", -- Big Add
		160013, -- Decay
		--[[ Beneficial Mushrooms ]]--
		"living_mushroom", -- Good Shroom (Heals units in 20yd)
		"rejuvenating_mushroom", -- Good Shroom (Increased haste and Mana regen)
		--[[ General ]]--
		{164125, "TANK"}, -- Creeping Moss
		{163241, "TANK"}, -- Rot
		{159219, "TANK_HEALER"}, -- Necrotic Breath
		159996, -- Infesting Spores
		"berserk",
	}, {
		[163755] = "mythic",
		["spore_shooter"] = -9993, -- Hostile Fungus
		["living_mushroom"] = -9998, -- Beneficial Mushrooms
		[164125] = "general"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "CreepingMossHeal", 164125, 165494)
	self:Log("SPELL_PERIODIC_HEAL", "CreepingMossHeal", 164125, 165494)
	self:Log("SPELL_AURA_APPLIED", "Rot", 163241)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Rot", 163241)
	self:Log("SPELL_CAST_START", "Decay", 160013)
	self:Log("SPELL_CAST_START", "NecroticBreath", 159219)
	self:Log("SPELL_CAST_START", "InfestingSpores", 159996)
	self:Log("SPELL_CAST_SUCCESS", "SummonMindFungus", 163141)
	self:Log("SPELL_CAST_SUCCESS", "SummonFungalFleshEater", 163142) -- Big Add
	self:Log("SPELL_SUMMON", "LivingMushroom", 160022)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "RejuvenatingMushroom", "boss1")
	--self:Log("SPELL_CAST_SUCCESS", "RejuvenatingMushroom", 177820) -- XXX Thanks to our IDIOTIC screwup in asking for the wrong id to be shown, this somehow didn't make 6.1

	self:Log("SPELL_CAST_SUCCESS", "SporeShooter", 163594) -- Small Adds
	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "CallOfTheTides", 163755)
	self:Log("SPELL_CAST_SUCCESS", "ExplodingFungus", 163794)
end

function mod:OnEngage()
	decayCount = 1
	infestingSporesCount = 1
	livingMushroomCount = 1
	self:Bar(159219, 30) -- Necrotic Breath
	self:Bar(159996, 45) -- Infesting Spores
	self:DelayedMessage(159996, 40, "Important", CL.soon:format(CL.count:format(self:SpellName(159996), infestingSporesCount)))
	self:CDBar("mind_fungus", 10, L.mind_fungus, L.mind_fungus_icon) -- Mind Fungus
	self:CDBar("spore_shooter", 20, CL.small_adds, L.spore_shooter_icon) -- Spore Shooter
	self:CDBar("flesh_eater", 32, CL.big_add, L.flesh_eater_icon) -- Fungal Flesh-Eater
	self:CDBar("living_mushroom", 18, L.living_mushroom, L.living_mushroom_icon) -- Living Mushroom
	self:CDBar("rejuvenating_mushroom", 82, L.rejuvenating_mushroom, L.rejuvenating_mushroom_icon) -- Rejuvenating Mushroom
	if self:Mythic() then
		self:CDBar("mythic_ability", 22, L.mythic_ability, L.mythic_ability_icon)
	end
	self:Berserk(600)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CallOfTheTides(args)
	self:Message(args.spellId, "Urgent", "Alarm", L.mythic_ability_wave)
	self:Flash(args.spellId)
	self:ScheduleTimer("Message", 3, args.spellId, "Urgent", "Alarm", L.mythic_ability_wave)
	self:ScheduleTimer("Message", 6, args.spellId, "Urgent", "Alarm", L.mythic_ability_wave)
	self:CDBar("mythic_ability", 20, L.mythic_ability, L.mythic_ability_icon) -- can be delayed by other casts
end

function mod:ExplodingFungus(args)
	self:Message(args.spellId, "Urgent")
	self:Flash(args.spellId)
	self:Bar(args.spellId, 7)
	self:CDBar("mythic_ability", 20, L.mythic_ability, L.mythic_ability_icon) -- can be delayed by other casts
end

function mod:CreepingMossHeal(args)
	if not self:LFR() then
		local mobId = self:MobId(args.destGUID)
		if mobId == 78491 then -- Brackenspore
			self:Message(164125, "Important", "Info", L.creeping_moss_boss_heal)
		elseif mobId == 79092 and decayCount > 1 then -- Fungal Flesh-Eater. If decayCount is 1 it probably just spawned on moss, so don't bother warning.
			self:Message(164125, "Important", nil, L.creeping_moss_add_heal)
		end
	end
end

function mod:Rot(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 3 and "Warning")
end

function mod:NecroticBreath(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:Bar(args.spellId, 32)
end

function mod:InfestingSpores(args)
	self:Message(args.spellId, "Important", "Alarm", CL.casting:format(CL.count:format(args.spellName, infestingSporesCount)))
	self:Bar(args.spellId, 12, CL.cast:format(args.spellName)) -- 2s cast + 10s channel
	infestingSporesCount = infestingSporesCount + 1
	self:Bar(args.spellId, 58, CL.count:format(args.spellName, infestingSporesCount)) -- happens at 100 energy
	self:DelayedMessage(args.spellId, 53, "Important", CL.soon:format(CL.count:format(args.spellName, infestingSporesCount)))
end

function mod:Decay(args)
	local playSound = self:Damager() or (self:Tank() and UnitGUID("target") == args.sourceGUID)
	self:Message(args.spellId, "Personal", playSound and "Alert", CL.casting:format(CL.count:format(args.spellName, decayCount)))
	decayCount = decayCount + 1
	self:Bar(args.spellId, 9.5, CL.count:format(args.spellName, decayCount))
end

function mod:SporeShooter(args)
	self:Message("spore_shooter", "Attention", self:Damager() and "Info", CL.small_adds, L.spore_shooter_icon)
	self:Bar("spore_shooter", 60, CL.small_adds, L.spore_shooter_icon)
	if self.db.profile.custom_off_spore_shooter_marker then -- Marking
		wipe(markableMobs)
		wipe(marksUsed)
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "UNIT_TARGET")
		self:RegisterEvent("UNIT_TARGET")
	end
end

-- Small add marking
function mod:UNIT_TARGET(_, firedUnit)
	local unit = firedUnit and firedUnit.."target" or "mouseover"
	local guid = UnitGUID(unit)
	if self:MobId(guid) == 79183 and not markableMobs[guid] then
		local n = self:Mythic() and 4 or 2
		for i = 1, n do
			if not marksUsed[i] then
				SetRaidTarget(unit, i)
				markableMobs[guid] = true
				marksUsed[i] = guid
				if i == n then
					self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
					self:UnregisterEvent("UNIT_TARGET")
				end
				return
			end
		end
	end
end

function mod:RejuvenatingMushroom(unit, spellName, _, _, spellId)
	if spellId == 177820 then -- Rejuvenating Mushroom
		self:Message("rejuvenating_mushroom", "Positive", self:Healer() and "Info", spellName, L.rejuvenating_mushroom_icon)
		self:CDBar("rejuvenating_mushroom", 120, spellName, L.rejuvenating_mushroom_icon) -- spawns most of the time just after 2min, sometimes delayed by boss casts (?)
	end
end

function mod:SummonMindFungus()
	self:Message("mind_fungus", "Attention", self:Damager() and "Long", L.mind_fungus, L.mind_fungus_icon)
	self:CDBar("mind_fungus", self:Mythic() and 30 or 51, L.mind_fungus, L.mind_fungus_icon) -- 51.1, 58.6, 55.5, 55, 61.5, 59.5
end

function mod:SummonFungalFleshEater()
	self:Message("flesh_eater", "Urgent", self:Tank() and "Long", CL.spawning:format(CL.big_add), L.flesh_eater_icon)
	self:Bar("flesh_eater", 120, CL.big_add, L.flesh_eater_icon)
	decayCount = 1
end

-- XXX for patch 6.1
--function mod:RejuvenatingMushroom(args)
--	self:Message("rejuvenating_mushroom", "Positive", self:Healer() and "Info", args.spellName, L.rejuvenating_mushroom_icon)
--	self:CDBar("rejuvenating_mushroom", 120, args.spellName, L.rejuvenating_mushroom_icon) -- spawns most of the time just after 2min, sometimes delayed by boss casts (?)
--end

function mod:LivingMushroom(args)
	self:Message("living_mushroom", "Positive", self:Healer() and "Long", CL.count:format(args.spellName, livingMushroomCount), L.living_mushroom_icon)
	livingMushroomCount = livingMushroomCount + 1
	self:Bar("living_mushroom", 58, CL.count:format(args.spellName, livingMushroomCount), L.living_mushroom_icon)
end

