--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Rotface", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36627)
mod.toggleOptions = {{69839, "FLASHSHAKE"}, {71224, "FLASHSHAKE", "ICON"}, 69508, "ooze", 72272, "gasicon", "bosskill"}
mod.optionHeaders = {
	[69839] = "normal",
	[72272] = "heroic",
	bosskill = "general",
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
	
	L.gas_bar = "Next Vile Gas"

	L.gasicon = "Icon on Gas targets"
	L.gasicon_desc = "Set Cross, Square, Moon icons on the players with a Gas (requires promoted or leader)."
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "VileGas", 72272, 72273)
	self:Log("SPELL_AURA_REMOVED", "GasRemoved", 72272, 72273)
	self:Log("SPELL_AURA_APPLIED", "Infection", 69674, 71224, 73022, 73023)
	self:Log("SPELL_AURA_REMOVED", "InfectionRemoved", 69674, 71224)
	self:Log("SPELL_CAST_START", "SlimeSpray", 69508)
	self:Log("SPELL_CAST_START", "Explode", 69839, 73029, 73030)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Ooze", 69558)

	self:Yell("Engage", L["engage_trigger"])

	self:Death("Win", 36627)
end

function mod:OnEngage()
	self:Bar(69508, L["spray_bar"], 19, 69508)
	mod:Bar(72272, L["gas_bar"], 20, 72272)
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

do
	local scheduled = nil
	local num = 7
	local function gasWarn(spellName)
		mod:TargetMessage(72272, spellName, gasTargets, "Urgent", 72272)
		mod:Bar(72272, L["gas_bar"], 30, 72272)
		scheduled = nil
		num = 7
	end
	function mod:VileGas(player, spellId, _, _, spellName)
		gasTargets[#gasTargets + 1] = player
		if self.db.profile.gasicon then
			SetRaidTarget(player, num)
			num = num - 1
		end
		if UnitIsUnit(player, "player") then
			self:FlashShake(72272)
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(gasWarn, 0.2, spellName)
		end
	end
end

function mod:GasRemoved(player)
	if self.db.profile.gasicon then
		SetRaidTarget(player, 0)
	end
end

