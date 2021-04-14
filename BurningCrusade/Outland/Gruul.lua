--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Gruul the Dragonkiller", 565, 1565)
if not mod then return end
mod:RegisterEnableMob(19044)
mod:SetEncounterID(2456)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "Come.... and die."
	L.engage_message = "%s Engaged!"

	L.grow = "Grow"
	L.grow_desc = "Count and warn for Grull's grow."
	L.grow_icon = 36300
	L.grow_message = "Grows: (%d)"
	L.grow_bar = "Grow (%d)"

	L.grasp = "Grasp"
	L.grasp_desc = "Grasp warnings and timers."
	L.grasp_icon = 33525
	L.grasp_message = "Ground Slam - Shatter in ~10sec!"
	L.grasp_warning = "Ground Slam Soon"

	L.silence_message = "AOE Silence"
	L.silence_warning = "AOE Silence soon!"
	L.silence_bar = "~Silence"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"grasp", "grow", {36240, "FLASH"}, 36297, "proximity"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Grow", 36300)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Grow", 36300)

	self:Log("SPELL_AURA_APPLIED", "CaveIn", 36240)
	self:Log("SPELL_CAST_SUCCESS", "Silence", 36297)
	self:Log("SPELL_CAST_START", "Shatter", 33654)
	self:Log("SPELL_CAST_START", "Slam", 33525)

	self:BossYell("Engage", L["engage_trigger"])

	self:Death("Win", 19044)
end

function mod:OnEngage()
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "StartWipeCheck")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "StopWipeCheck")

	self:OpenProximity("proximity", 15)

	self:MessageOld("grasp", "yellow", nil, L["engage_message"]:format(self.displayName), false)
	self:DelayedMessage("grasp", 30, "orange", L["grasp_warning"])
	self:CDBar("grasp", 33, 33525) -- Ground Slam

	self:DelayedMessage(36297, 97, "orange", L["silence_warning"])
	self:Bar(36297, 102, L["silence_bar"])

	self:Bar("grow", 30, L["grow_bar"]:format(1), 36300)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CaveIn(args)
	if self:Me(args.destGUID) then
		self:MessageOld(args.spellId, "blue", "alarm", CL["you"]:format(args.spellName))
		self:Flash(args.spellId)
	end
end

function mod:Grow(args)
	local stack = args.amount or 1
	self:MessageOld("grow", "red", nil, L["grow_message"]:format(stack), args.spellId)
	stack = stack + 1
	if stack < 31 then
		self:Bar("grow", 30, L["grow_bar"]:format(stack), args.spellId)
	else
		stack = 1
		self:Bar("grow", 300, L["grow_bar"]:format(stack), args.spellId)
	end
end

function mod:Silence(args)
	self:MessageOld(args.spellId, "yellow", nil, L["silence_message"])
	self:DelayedMessage(args.spellId, 28, "orange", L["silence_warning"])
	self:Bar(args.spellId, 31, L["silence_bar"])
end

function mod:Shatter(args)
	self:MessageOld("grasp", "green", nil, args.spellId)
	self:DelayedMessage("grasp", 56, "orange", L["grasp_warning"])
	self:CDBar("grasp", 62, 33525)
end

function mod:Slam(args)
	self:MessageOld("grasp", "yellow", nil, L["grasp_message"], args.spellId)
	self:Bar("grasp", 10, 33654) -- Shatter
end

