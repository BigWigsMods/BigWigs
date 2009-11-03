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

local ssName = GetSpellInfo(66134)
local difficulty = GetRaidDifficulty()
local pName = UnitName("player")
local phase2 = nil
local firstBurrow = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Anub'arak", "enUS", true)
if L then
	L.engage_message = "Anub'arak engaged, burrow in 80sec!"
	L.engage_trigger = "This place will serve as your tomb!"

	L.unburrow_trigger = "emerges from the ground"
	L.burrow_trigger = "burrows into the ground"
	L.burrow = "Burrow"
	L.burrow_desc = "Show a timer for Anub'Arak's Burrow ability"
	L.burrow_cooldown = "Next Burrow"
	L.burrow_soon = "Burrow soon"

	L.nerubian_burrower = "Nerubian Burrower"

	L.shadow_soon = "Shadow Strike in ~5sec!"

	L.freeze_bar = "~Next Freezing Slash"
	L.pcold_bar = "~Next Penetrating Cold"

	L.icon = "Place icon"
	L.icon_desc = "Place a raid target icon on the person targetted by Anub'arak during his burrow phase. (requires promoted or higher)"

	L.chase = "Pursue"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Anub'arak")
mod.locale = L

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

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:Yell("Engage", L["engage_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 34564)
end

local function nextwave()
	mod:Bar("burrow", L["nerubian_burrower"], 45, 66333)
end

function mod:OnEngage()
	difficulty = GetRaidDifficulty()
	self:Message("burrow", L["engage_message"], "Attention", 65919)
	self:Bar("burrow", L["burrow_cooldown"], 80, 65919)
	self:Bar("burrow", L["nerubian_burrower"], 10, 66333)

	handle_NextWave = self:ScheduleTimer(nextwave, 10)

	if self:GetOption(66134) and difficulty > 2 then
		scheduleStrike()
	end

	self:Berserk(570, true)
	phase2 = nil
	firstBurrow = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FreezeCooldown(player, spellId)
	self:Bar(66012, L["freeze_bar"], 20, spellId)
end

function mod:ColdDebuff(player, spellId, _, _, spellName)
	if player ~= pName or not phase2 then return end
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
	if player == pName then self:FlashShake(67574) end
	self:Whisper(67574, player, L["chase"])
	self:PrimaryIcon(67574, player, "icon")
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg)
	if msg:find(L["unburrow_trigger"]) then
		self:Bar("burrow", L["burrow_cooldown"], 76, 65919)
		self:DelayedMessage("burrow", 72, L["burrow_soon"], "Attention")

		self:Bar("burrow", L["nerubian_burrower"], 5, 66333)
		handle_NextWave = self:ScheduleTimer(nextwave, 5)

		if self:GetOption(66134) and difficulty > 2 then
			unscheduleStrike()
			handle_NextStrike = self:ScheduleTimer(scheduleStrike, 5.5)
		end
	elseif msg:find(L["burrow_trigger"]) then
		self:Bar("burrow", L["burrow"], 65, 65919)
		firstBurrow = true
	end
end

