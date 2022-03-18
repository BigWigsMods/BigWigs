--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Void Reaver", 550, 1574)
if not mod then return end
mod:RegisterEnableMob(19516)
mod:SetAllowWin(true)
mod:SetEncounterID(731)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "Alert! You are marked for extermination."
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{34172, "ICON", "SAY"}, 25778, 34162, "berserk"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "KnockAway", 25778)
	self:Log("SPELL_CAST_SUCCESS", "Pounding", 34162)
	self:Log("SPELL_CAST_SUCCESS", "Orb", 34172)

	self:BossYell("Engage", L["engage_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 19516)
end

function mod:OnEngage()
	self:Berserk(600)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:KnockAway(args)
	self:TargetMessageOld(args.spellId, args.destName, "green", "alarm")
	self:CDBar(args.spellId, 20)
end

function mod:Pounding(args)
	self:CDBar(args.spellId, 13)
end

function mod:Orb(args)
	self:TargetMessageOld(args.spellId, args.destName, "yellow", "alert")
	self:PrimaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
end

