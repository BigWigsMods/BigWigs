--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("High King Maulgar", 565, 1564)
if not mod then return end
--Maulgar, Krosh Firehand (Mage), Olm the Summoner (Warlock), Kiggler the Crazed (Shaman), Blindeye the Seer (Priest)
mod:RegisterEnableMob(18831, 18832, 18834, 18835, 18836)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "Gronn are the real power in Outland!"

	L.heal_message = "Blindeye casting Prayer of Healing!"
	L.heal_bar = "<Healing!>"

	L.shield_message = "Shield on Blindeye!"

	L.spellshield_message = "Spell Shield on Krosh!"

	L.summon_message = "Felhunter being summoned!"
	L.summon_bar = "~Felhunter"

	L.whirlwind_message = "Maulgar - Whirlwind for 15sec!"
	L.whirlwind_warning = "Maulgar Engaged - Whirlwind in ~60sec!"

	L.mage = "Krosh Firehand (Mage)"
	L.warlock = "Olm the Summoner (Warlock)"
	L.priest = "Blindeye the Seer (Priest)"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		33152, 33147, 33054, 33131, 39144, 33238, 33232,
	}, {
		[33152] = L["priest"],
		[33054] = L["mage"],
		[33131] = L["warlock"],
		[39144] = self.displayName,
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Shield", 33147)
	self:Log("SPELL_AURA_APPLIED", "SpellShield", 33054)
	self:Log("SPELL_AURA_APPLIED", "Whirlwind", 33238)
	self:Log("SPELL_CAST_START", "Summon", 33131)
	self:Log("SPELL_CAST_START", "Prayer", 33152)
	self:Log("SPELL_CAST_SUCCESS", "Smash", 39144)
	self:Log("SPELL_CAST_SUCCESS", "Flurry", 33232)

	self:BossYell("Engage", L["engage_trigger"])

	self:Death("Win", 18831)
end

function mod:OnEngage()
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "StartWipeCheck")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "StopWipeCheck")

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "target", "focus")

	self:MessageOld(33238, "yellow", nil, L["whirlwind_warning"])
	self:DelayedMessage(33238, 54, "orange", CL["soon"]:format(self:SpellName(33238))) -- Whirlwind
	self:CDBar(33238, 59) -- Whirlwind
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Shield(args)
	self:MessageOld(args.spellId, "red", nil, L["shield_message"])
end

function mod:SpellShield(args)
	if self:MobId(args.destGUID) == 18832 then
		self:MessageOld(args.spellId, "yellow", "info", L["spellshield_message"])
		self:Bar(args.spellId, 30)
	end
end

function mod:Whirlwind(args)
	self:MessageOld(args.spellId, "red", nil, L["whirlwind_message"])
	self:Bar(args.spellId, 15, CL["cast"]:format(args.spellName))
	self:DelayedMessage(args.spellId, 55, "orange", CL["soon"]:format(args.spellName))
	self:CDBar(args.spellId, 60)
end

function mod:Summon(args)
	self:MessageOld(args.spellId, "yellow", "long", L["summon_message"])
	self:Bar(args.spellId, 50, L["summon_bar"])
end

function mod:Prayer(args)
	self:MessageOld(args.spellId, "red", "alarm", L["heal_message"])
end

function mod:Smash(args)
	self:CDBar(args.spellId, 10)
end

function mod:Flurry(args)
	self:MessageOld(args.spellId, "red", nil, "50% - "..args.spellName)
end

function mod:UNIT_HEALTH(event, unit)
	if self:MobId(self:UnitGUID(unit)) == 18831 then
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
		if hp > 50 and hp < 57 then
			local flurry = self:SpellName(33232)
			self:MessageOld(33232, "green", nil, CL["soon"]:format(flurry))
			self:UnregisterUnitEvent(event, "target", "focus")
		end
	end
end

