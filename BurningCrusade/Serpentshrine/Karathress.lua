--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Fathom-Lord Karathress", 548, 1570)
if not mod then return end
mod:RegisterEnableMob(21214, 21966, 21965, 21964) --Karathress, Sharkkis, Tidalvess, Caribdis
mod:SetAllowWin(true)
mod:SetEncounterID(2461)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.enrage_trigger = "Guards, attention! We have visitors...."

	L.totem = "Spitfire Totem"
	L.totem_desc = "Warn for Spitfire Totems and who cast them."
	L.totem_icon = 38236
	L.totem_message1 = "Tidalvess: Spitfire Totem"
	L.totem_message2 = "Karathress: Spitfire Totem"
	L.heal_message = "Caribdis casting heal!"

	L.priest = "Fathom-Guard Caribdis"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		38330, "totem", "berserk"
	}, {
		[38330] = L["priest"],
		totem = CL["general"],
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Heal", 38330)
	self:Log("SPELL_SUMMON", "Totem", 38236)

	self:BossYell("Engage", L["enrage_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 21214)
end

function mod:OnEngage()
	self:Berserk(600)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Heal(args)
	self:MessageOld(args.spellId, "red", "long", L["heal_message"])
end

function mod:Totem(args)
	if self:MobId(args.sourceGUID) == 21214 then
		self:MessageOld("totem", "orange", "alarm", L["totem_message2"], args.spellId)
	else
		self:MessageOld("totem", "yellow", nil, L["totem_message1"], args.spellId)
	end
end

