--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("The Crone", 532)
if not mod then return end
--The Crone, Dorothee, Tito, Strawman, Tinhead, Roar
mod:RegisterEnableMob(18168, 17535, 17548, 17543, 17547, 17546)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.name = "The Crone"

	L.engage_trigger = "^Oh Tito, we simply must find a way home!"

	L.spawns = "Spawn Timers"
	L.spawns_desc = "Timers for when the characters become active."
	L.spawns_warning = "%s in 5 sec"

	L.roar = "Roar"
	L.tinhead = "Tinhead"
	L.strawman = "Strawman"
	L.tito = "Tito"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"spawns", 32337
	}
end

function mod:OnRegister()
	self.displayName = L.name
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "ChainLightning", 32337)

	self:BossYell("Engage", L["engage_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 18168)
end

function mod:OnEngage()
	local swarn = L["spawns_warning"]
	self:Bar("spawns", 15, L["roar"], "INV_Staff_08")
	self:DelayedMessage("spawns", 10, "yellow", (swarn):format(L["roar"]), "INV_Staff_08")
	self:Bar("spawns", 25, L["strawman"], "Ability_Druid_ChallangingRoar")
	self:DelayedMessage("spawns", 20, "yellow", (swarn):format(L["strawman"]), "Ability_Druid_ChallangingRoar")
	self:Bar("spawns", 35, L["tinhead"], "INV_Chest_Plate06")
	self:DelayedMessage("spawns", 30, "yellow", (swarn):format(L["tinhead"]), "INV_Chest_Plate06")
	self:Bar("spawns", 48, L["tito"], "Ability_Hunter_Pet_Wolf")
	self:DelayedMessage("spawns", 43, "yellow", (swarn):format(L["tito"]), "Ability_Hunter_Pet_Wolf")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ChainLightning(args)
	self:MessageOld(args.spellId, "orange")
	self:Bar(args.spellId, 2, "<"..args.spellName..">")
end

