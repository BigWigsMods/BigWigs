--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Azgalor", 534, 1580)
if not mod then return end
mod:RegisterEnableMob(17842)
mod:SetEncounterID(2471)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.howl_bar = "~Howl"
	L.howl_message = "AoE silence"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{31347, "ICON", "FLASH"}, 31344, 31340, "berserk"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "RainOfFire", 31340)
	self:Log("SPELL_CAST_SUCCESS", "Howl", 31344)
	self:Log("SPELL_AURA_APPLIED", "Doom", 31347)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:Death("Win", 17842)
end

function mod:OnEngage()
	self:Berserk(600)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:RainOfFire(args)
	if self:Me(args.destGUID) then
		self:MessageOld(args.spellId, "orange", "alarm", CL["you"]:format(args.spellName))
	end
end

function mod:Howl(args)
	self:MessageOld(args.spellId, "red", nil, L["howl_message"])
	self:Bar(args.spellId, 16, L["howl_bar"])
	self:DelayedMessage(args.spellId, 15, "red", CL["soon"]:format(L["howl_message"]))
end

function mod:Doom(args)
	self:TargetMessageOld(args.spellId, args.destName, "yellow", "alert")
	self:TargetBar(args.spellId, 19, args.destName)
	self:PrimaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	end
end

