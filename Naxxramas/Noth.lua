--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Noth the Plaguebringer", 533)
if not mod then return end
mod:RegisterEnableMob(15954)
mod:SetAllowWin(true)
mod.engageId = 1117

--------------------------------------------------------------------------------
-- Locals
--

local timeroom = 90
local timebalcony = 70
local cursetime = 55
local wave1time = 10
local wave2time = 41

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Noth the Plaguebringer"

	L.starttrigger1 = "Die, trespasser!"
	L.starttrigger2 = "Glory to the master!"
	L.starttrigger3 = "Your life is forfeit!"
	L.startwarn = "Noth the Plaguebringer engaged! 90 sec till teleport"
	L.add_trigger = "Rise, my soldiers! Rise and fight once more!"

	L.blink = "Blink"
	L.blink_desc = "Warnings when Noth blinks."
	L.blink_icon = "Spell_Arcane_Blink"
	L.blink_trigger = "%s blinks away!"
	L.blink_bar = "Blink"

	L.teleport = "Teleport"
	L.teleport_desc = "Warnings and bars for teleport."
	L.teleport_icon = "Spell_Magic_LesserInvisibilty"
	L.teleport_bar = "Teleport!"
	L.teleportwarn = "Teleport! He's on the balcony!"
	L.teleportwarn2 = "Teleport in 10 sec!"
	L.back_bar = "Back in room!"
	L.back_warn = "He's back in the room for %d sec!"
	L.back_warn2 = "10 sec until he's back in the room!"

	L.curse_explosion = "Curse explosion!"
	L.curse_warn = "Curse! next in ~55 sec"
	L.curse_10sec_warn = "Curse in ~10 sec"
	L.curse_bar = "Next Curse"

	L.wave = "Waves"
	L.wave_desc = "Alerts for the different waves."
	L.wave1_bar = "Wave 1"
	L.wave2_bar = "Wave 2"
	L.wave2_message = "Wave 2 in 10 sec"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"blink",
		"teleport",
		29213, -- Curse of the Plaguebringer
		"wave",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Curse", 29213)
	self:Emote("Blink", L.blink_trigger)

	self:BossYell("Engage", L.starttrigger1, L.starttrigger2, L.starttrigger3)
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 15954)
end

function mod:OnEngage(diff)
	timeroom = 90
	timebalcony = 70

	self:Message("teleport", "red", L.startwarn, false)
	self:DelayedMessage("teleport", timeroom - 10, "orange", L.teleportwarn2)
	self:Bar("teleport", timeroom, L.teleport_bar, L.teleport_icon)
	if diff == 4 then
		self:DelayedMessage("blink", 25, "yellow", CL.soon:format(L.blink))
		self:Bar("blink", 30, L.blink_bar, L.blink_icon)
	end
	self:ScheduleTimer("TeleportToBalcony", timeroom)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Curse(args)
	self:Message(29213, "red", L.curse_warn)
	self:PlaySound(29213, "alarm")
	self:DelayedMessage(29213, cursetime - 10, "orange", L.curse_10sec_warn)
	self:Bar(29213, cursetime, L.curse_bar)
	self:Bar(29213, 10, L.curse_explosion)
end

function mod:Blink()
	self:Message("blink", "red", L.blink, L.blink_icon)
	self:DelayedMessage("blink", 34, "yellow", CL.soon:format(L.blink))
	self:Bar("blink", 39, L.blink_bar, L.blink_icon)
end

function mod:TeleportToBalcony()
	if timeroom == 90 then
		timeroom = 110
	elseif timeroom == 110 then
		timeroom = 180
	end

	self:StopBar(L.blink_bar)
	self:StopBar(L.curse_bar)

	self:Message("teleport", "red", L.teleportwarn, false)
	self:Bar("teleport", L.back_bar, timebalcony, L.teleport_icon)
	self:DelayedMessage("teleport", timebalcony - 10, "orange", L.back_warn2)

	self:Bar("wave", wave1time, L.wave1_bar, "Spell_ChargePositive")
	self:Bar("wave", wave2time, L.wave2_bar, "Spell_ChargePositive")
	self:DelayedMessage("wave", wave2time - 10, "orange", L.wave2_message)

	self:ScheduleTimer("TeleportToRoom", timebalcony)
	wave2time = wave2time + 15
end

function mod:TeleportToRoom()
	if timebalcony == 70 then
		timebalcony = 95
	elseif timebalcony == 95 then
		timebalcony = 120
	end

	self:Message("teleport", "red", L.back_warn:format(timeroom), false)
	self:Bar("teleport", timeroom, L.teleport_bar, L.teleport_icon)
	self:DelayedMessage("teleport", timeroom - 10, "orange", L.teleportwarn2)
	self:ScheduleTimer("TeleportToBalcony", timeroom)
end
