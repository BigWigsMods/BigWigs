--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Shade of Aran", 532, 1559)
if not mod then return end
mod:RegisterEnableMob(16524)
mod:SetAllowWin(true)
mod:SetEncounterID(2450)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.adds = "Elementals"
	L.adds_desc = "Warn about the water elemental adds spawning."
	L.adds_icon = "spell_frost_summonwaterelemental_2"
	L.adds_message = "Elementals Incoming!"
	L.adds_warning = "Elementals Soon"
	L.adds_bar = "Elementals despawn"

	L.drink = "Drinking"
	L.drink_desc = "Warn when Aran starts to drink."
	L.drink_icon = "inv_drink_16"
	L.drink_warning = "Low Mana - Drinking Soon!"
	L.drink_message = "Drinking - AoE Polymorph!"
	L.drink_bar = "Super Pyroblast Incoming"

	L.blizzard = "Blizzard"
	L.blizzard_desc = "Warn when Blizzard is being cast."
	L.blizzard_icon = 29969
	L.blizzard_message = "Blizzard!"

	L.pull = "Pull/Super AE"
	L.pull_desc = "Warn for the magnetic pull and Super Arcane Explosion."
	L.pull_icon = 29973
	L.pull_message = "Arcane Explosion!"
	L.pull_bar = "Arcane Explosion"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"adds", "drink", "blizzard", "pull", 30004
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "FlameWreathStart", 30004)
	self:Log("SPELL_AURA_APPLIED", "FlameWreath", 29946)
	self:Log("SPELL_CAST_START", "Blizzard", 29969)
	self:Log("SPELL_CAST_START", "Drinking", 29963) --Mass Polymorph
	self:Log("SPELL_SUMMON", "Elementals", 29962)
	self:Log("SPELL_CAST_SUCCESS", "Pull", 29979) --Arcane Explosion

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 16524)
end

function mod:OnEngage()
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "target", "focus")
	self:RegisterUnitEvent("UNIT_HEALTH", nil, "target", "focus")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local scheduled = nil
	local inWreath = mod:NewTargetList()
	local function wreathWarn(spellId)
		mod:TargetMessageOld(30004, inWreath, "red", "long", spellId)
		scheduled = nil
	end
	function mod:FlameWreath(args)
		inWreath[#inWreath + 1] = args.destName
		if not scheduled then
			scheduled = true
			self:Bar(30004, 21, L["flame_bar"], args.spellId)
			self:ScheduleTimer(wreathWarn, 0.4, args.spellId)
		end
	end
end

function mod:FlameWreathStart(args)
	self:MessageOld(args.spellId, "red", "alarm", CL["cast"]:format(args.spellName))
	self:Bar(args.spellId, 5, CL["cast"]:format(args.spellName))
end

function mod:Blizzard(args)
	self:MessageOld("blizzard", "yellow", nil, L["blizzard_message"], args.spellId)
	self:Bar("blizzard", 36, L["blizzard_message"], args.spellId)
end

function mod:Drinking()
	self:MessageOld("drink", "green", nil, L["drink_message"], L.drink_icon)
	self:Bar("drink", 15, L["drink_bar"], 29978) --Pyroblast id
end

function mod:Elementals()
	self:MessageOld("adds", "red", nil, L["adds_message"], L["adds_icon"])
	self:Bar("adds", 90, L["adds_bar"], L["adds_icon"])
end

do
	local last = 0
	function mod:Pull()
		local time = GetTime()
		if (time - last) > 5 then
			last = time
			self:MessageOld("pull", "yellow", nil, L["pull_message"], 29973)
			self:Bar("pull", 12, L["pull_bar"], 29973)
		end
	end
end

function mod:UNIT_POWER_FREQUENT(event, unit)
	if self:MobId(self:UnitGUID(unit)) == 16524 then
		local mana = UnitPower(unit)
		if mana > 33000 and mana < 37000 then
			self:MessageOld("drink", "orange", "alert", L["drink_warning"], false)
			self:UnregisterUnitEvent(event, "target", "focus")
		end
	end
end

function mod:UNIT_HEALTH(event, unit)
	if self:MobId(self:UnitGUID(unit)) == 16524 then
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
		if hp > 40 and hp < 46 then
			self:MessageOld("adds", "orange", "alert", L["adds_warning"], false)
			self:UnregisterUnitEvent(event, "target", "focus")
		end
	end
end

