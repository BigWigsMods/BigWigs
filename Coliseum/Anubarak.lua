-------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Anub'arak", "Trial of the Crusader")
if not mod then return end
mod.toggleOptions = {66012, "burrow", {67574, "WHISPER", "ICON", "FLASHSHAKE"}, {68510, "FLASHSHAKE"}, 66118, 66134, "berserk", "bosskill"}
mod:RegisterEnableMob(34564, 34607, 34605)
mod.optionHeaders = {
	[66012] = "normal",
	[66134] = "heroic",
	berserk = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

local handle_NextWave = nil
local handle_NextStrike = nil

local isBurrowed = nil
local ssName = GetSpellInfo(66134)
local difficulty = 0
local coldTargets = mod:NewTargetList()
local phase2 = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_message = "Anub'arak engaged, burrow in 80sec!"
	L.engage_trigger = "This place will serve as your tomb!"

	L.unburrow_trigger = "emerges from the ground"
	L.burrow_trigger = "burrows into the ground"
	L.burrow = "Burrow"
	L.burrow_desc = "Shows timers for emerges and submerges, and also add spawn timers."
	L.burrow_cooldown = "Next Burrow"
	L.burrow_soon = "Burrow soon"

	L.nerubian_message = "Adds incoming!"
	L.nerubian_burrower = "More adds"

	L.shadow_soon = "Shadow Strike in ~5sec!"

	L.freeze_bar = "~Next Freezing Slash"
	L.pcold_bar = "~Next Penetrating Cold"

	L.chase = "Pursue"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

-- Fucking Shadow Strike!
-- 1. On engage, start a 30.5 second shadow strike timer if difficulty > 2.
-- 2. When the 30.5 second timer is over, restart it.
-- 3. When an add casts shadow strike, cancel all timers and restart at 30.5 seconds.
-- 4. When Anub'arak emerges from a burrow, start the timers after 5.5 seconds, so
--    the time from emerge -> Shadow Strike is 5.5 + 30.5 seconds = 36 seconds.

local function unscheduleStrike()
	mod:CancelDelayedMessage(L["shadow_soon"])
	mod:CancelTimer(handle_NextStrike, true)
	mod:SendMessage("BigWigs_StopBar", mod, ssName)
end

local function scheduleStrike()
	unscheduleStrike()
	mod:Bar(66134, ssName, 30.5, 66134)
	mod:DelayedMessage(66134, 25.5, L["shadow_soon"], "Attention")
	handle_NextStrike = mod:ScheduleTimer(scheduleStrike, 30.5)
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Swarm", 66118, 67630, 68646, 68647)
	self:Log("SPELL_CAST_SUCCESS", "ColdCooldown", 66013, 67700, 68509, 68510)
	self:Log("SPELL_AURA_APPLIED", "ColdDebuff", 66013, 67700, 68509, 68510)
	self:Log("SPELL_AURA_APPLIED", "Pursue", 67574)

	self:Log("SPELL_CAST_START", scheduleStrike, 66134)
	self:Log("SPELL_CAST_SUCCESS", "FreezeCooldown", 66012)
	self:Log("SPELL_MISSED", "FreezeCooldown", 66012)

	self:Emote("Burrow", L["burrow_trigger"])
	self:Emote("Surface", L["unburrow_trigger"])

	self:Yell("Engage", L["engage_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 34564)
end

local function scheduleWave()
	if isBurrowed then return end
	mod:Message("burrow", L["nerubian_message"], "Urgent", 66333)
	mod:Bar("burrow", L["nerubian_burrower"], 45, 66333)
	handle_NextWave = mod:ScheduleTimer(scheduleWave, 45)
end

function mod:OnEngage(diff)
	isBurrowed = nil
	difficulty = diff
	self:Message("burrow", L["engage_message"], "Attention", 65919)
	self:Bar("burrow", L["burrow_cooldown"], 80, 65919)
	self:DelayedMessage("burrow", 65, L["burrow_soon"], "Attention")

	self:Bar("burrow", L["nerubian_burrower"], 10, 66333)
	handle_NextWave = self:ScheduleTimer(scheduleWave, 10)

	if self:GetOption(66134) and diff > 2 then
		scheduleStrike()
	end

	self:Berserk(570, true)
	phase2 = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FreezeCooldown(player, spellId)
	self:Bar(66012, L["freeze_bar"], 20, spellId)
end

do
	local scheduled = nil
	local function coldWarn(spellName)
		mod:TargetMessage(68510, spellName, coldTargets, "Urgent", 68510)
		scheduled = nil
	end
	function mod:ColdDebuff(player, spellId, _, _, spellName)
		if not phase2 then return end
		coldTargets[#coldTargets + 1] = player
		if not scheduled then
			self:ScheduleTimer(coldWarn, 0.2, spellName)
			scheduled = true
		end
		if UnitIsUnit(player, "player") then
			self:FlashShake(68510)
		end
	end
end

function mod:ColdDebuff(player, spellId, _, _, spellName)
	if not UnitIsUnit(player, "player") or not phase2 then return end
	self:LocalMessage(68510, spellName, "Personal", spellId)
	self:FlashShake(68510)
end

function mod:ColdCooldown(_, spellId)
	if not phase2 then return end
	self:Bar(68510, L["pcold_bar"], 15, spellId)
end

function mod:Swarm(player, spellId, _, _, spellName)
	self:Message(66118, spellName, "Important", spellId, "Long")
	phase2 = true
	self:SendMessage("BigWigs_StopBar", self, L["burrow_cooldown"])
	self:CancelDelayedMessage(L["burrow_soon"])
	if difficulty < 3 then -- Normal modes
		self:SendMessage("BigWigs_StopBar", self, L["nerubian_burrower"])
		self:CancelTimer(handle_NextWave, true)
	end
end

function mod:Pursue(player, spellId)
	self:TargetMessage(67574, L["chase"], player, "Personal", spellId, "Alert")
	if UnitIsUnit(player, "player") then self:FlashShake(67574) end
	self:Whisper(67574, player, L["chase"])
	self:PrimaryIcon(67574, player, "icon")
end

function mod:Burrow()
	isBurrowed = true
	unscheduleStrike()
	self:SendMessage("BigWigs_StopBar", self, L["freeze_bar"])
	self:SendMessage("BigWigs_StopBar", self, L["nerubian_burrower"])
	self:CancelTimer(handle_NextWave, true)

	self:Bar("burrow", L["burrow"], 65, 65919)
end

function mod:Surface()
	isBurrowed = nil
	self:Bar("burrow", L["burrow_cooldown"], 76, 65919)
	self:DelayedMessage("burrow", 61, L["burrow_soon"], "Attention")

	self:Bar("burrow", L["nerubian_burrower"], 5, 66333)
	handle_NextWave = self:ScheduleTimer(scheduleWave, 5)

	if self:GetOption(66134) and difficulty > 2 then
		unscheduleStrike()
		handle_NextStrike = self:ScheduleTimer(scheduleStrike, 5.5)
	end
end

