--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Rotface", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36627)
mod.toggleOptions = {{69839, "FLASHSHAKE"}, {71224, "FLASHSHAKE", "ICON"}, 69508, "ooze", 72272, "berserk", "bosskill"}
mod.optionHeaders = {
	[69839] = "normal",
	[72272] = "heroic",
	berserk = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

local gasTargets = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "WEEEEEE!"

	L.infection_bar = "Infection on %s!"
	L.infection_message = "Infection"

	L.ooze = "Ooze Merge"
	L.ooze_desc = "Warn when an ooze merges."
	L.ooze_message = "Ooze %dx"

	L.spray_bar = "Next Spray"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "VileGas", 72272, 72273) --Heroic only 10/25
	self:Log("SPELL_AURA_APPLIED", "Infection", 69674, 71224, 73022, 73023)
	self:Log("SPELL_AURA_REMOVED", "InfectionRemoved", 69674, 71224, 73022, 73023)
	self:Log("SPELL_CAST_START", "SlimeSpray", 69508)
	self:Log("SPELL_CAST_START", "Explode", 69839, 73029, 73030)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Ooze", 69558)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Engage", L["engage_trigger"])

	self:Death("Win", 36627)
end

function mod:OnEngage(diff)
	self:Berserk(600,true)
	self:Bar(69508, L["spray_bar"], 19, 69508)
	if diff > 2 then
		self:Bar(72272, GetSpellInfo(72272), 20, 72272)
	end
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

function mod:InfectionRemoved(player)
	self:SendMessage("BigWigs_StopBar", self, L["infection_bar"]:format(player))
end

function mod:SlimeSpray(_, spellId, _, _, spellName)
	self:Message(69508, spellName, "Important", spellId, "Alarm")
	self:Bar(69508, L["spray_bar"], 21, 69508)
end

do
	--The cast is sometimes pushed back
	local handle = nil
	local function explodeWarn(explodeName)
		handle = nil
		mod:FlashShake(69839)
		mod:Message(69839, explodeName, "Urgent", 69839, "Alert")
	end
	function mod:Explode(_, spellId)
		local explodeName = GetSpellInfo(67729) --"Explode"
		self:Bar(69839, explodeName, 4, spellId)
		if handle then self:CancelTimer(handle, true) end
		handle = self:ScheduleTimer(explodeWarn, 4, explodeName)
	end
end

function mod:Ooze(_, spellId, _, _, _, stack)
	if stack > 4 then return end
	self:Message("ooze", L["ooze_message"]:format(stack), "Attention", spellId)
end

function mod:VileGas(player, spellId, _, _, spellName)
	self:Bar(72272, spellName, 30, 72272)
end

