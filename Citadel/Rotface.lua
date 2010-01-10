--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Rotface", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36627)
mod.toggleOptions = {{69839, "FLASHSHAKE"}, {71224, "FLASHSHAKE", "ICON"}, 69508, 69558, "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local count = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "WEEEEEE!"

	L.infection_bar = "Infection on %s!"
	L.infection_message = "Infection"

	L.ooze_message = "Ooze %dx"

	L.spray_bar = "Next Spray"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Infection", 69674, 71224)
	self:Log("SPELL_CAST_START", "SlimeSpray", 69508)
	self:Log("SPELL_CAST_START", "Explode", 69839, 73029, 73030)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Ooze", 69558)

	self:Yell("Engage", L["engage_trigger"])

	self:Death("Win", 36627)
end

function mod:OnEngage()
	count = 1
	self:Bar(69508, L["spray_bar"], 25, 69508)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Infection(player, spellId)
	self:TargetMessage(71224, L["infection_message"], player, "Personal", spellId)
	self:Bar(71224, L["infection_bar"]:format(player), 12, spellId)
	self:PrimaryIcon(71224, player, "icon")
	if UnitIsUnit(player, "player") then self:FlashShake(71224) end
end

function mod:SlimeSpray(_, spellId, _, _, spellName)
	self:Message(69508, spellName, "Important", spellId)
	self:Bar(69508, L["spray_bar"], 21, 69508)
end

local function explodeWarn(explodeName)
	mod:FlashShake(69839)
	mod:Message(69839, explodeName, "Urgent", 69839, "Alert")
end

function mod:Explode(_, spellId)
	count = 1
	local explodeName = GetSpellInfo(67729) --"Explode"
	self:Bar(69839, explodeName, 4, spellId)
	self:ScheduleTimer(explodeWarn, 4, explodeName)
end

function mod:Ooze(_, spellId)
	count = count + 1
	if count > 4 then return end
	self:Message(69558, L["ooze_message"]:format(count), "Attention", spellId)
end

