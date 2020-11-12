
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Heigan the Unclean", 533)
if not mod then return end
mod:RegisterEnableMob(15936)
mod:SetAllowWin(true)
mod.engageId = 1112

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Heigan the Unclean"

	L.starttrigger = "You are mine now."
	L.starttrigger2 = "You... are next."
	L.starttrigger3 = "I see you..."

	L.engage = "Engage"
	L.engage_desc = "Warn when Heigan is engaged."
	L.engage_message = "Heigan the Unclean engaged! 90 sec to teleport!"

	L.teleport = "Teleport"
	L.teleport_desc = "Warn for Teleports."
	L.teleport_icon = "Spell_Arcane_Blink"
	L.teleport_trigger = "The end is upon you."
	L.teleport_1min_message = "Teleport in 1 min"
	L.teleport_30sec_message = "Teleport in 30 sec"
	L.teleport_10sec_message = "Teleport in 10 sec!"
	L.on_platform_message = "Teleport! On platform for 45 sec!"

	L.to_floor_30sec_message = "Back in 30 sec"
	L.to_floor_10sec_message = "Back in 10 sec!"
	L.on_floor_message = "Back on the floor! 90 sec to next teleport!"

	L.teleport_bar = "Teleport!"
	L.back_bar = "Back on the floor!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"engage",
		"teleport",
	}
end

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	self:BossYell("Teleport", L.teleport_trigger)

	self:BossYell("Engage", L.starttrigger, L.starttrigger2, L.starttrigger3)
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 15936)
end

function mod:OnEngage()
	self:Message("engage", "red", L.engage_message, false)
	self:Bar("teleport", 90, L.teleport_bar, L.teleport_icon)
	self:DelayedMessage("teleport", 30, "yellow", L.teleport_1min_message)
	self:DelayedMessage("teleport", 60, "orange", L.teleport_30sec_message)
	self:DelayedMessage("teleport", 80, "red", L.teleport_10sec_message)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function backToRoom()
	mod:Message("teleport", "yellow", L.on_floor_message, false)
	mod:DelayedMessage("teleport", 60, "orange", L.teleport_30sec_message)
	mod:DelayedMessage("teleport", 80, "red", L.teleport_10sec_message)
	mod:Bar("teleport", 90, L.teleport_bar, L.teleport_icon)
end

function mod:Teleport()
	self:ScheduleTimer(backToRoom, 45)
	self:Message("teleport", "yellow", L.on_platform_message, false)
	self:DelayedMessage("teleport", 15, "orange", L.to_floor_30sec_message)
	self:DelayedMessage("teleport", 35, "red", L.to_floor_10sec_message)
	self:Bar("teleport", 45, L.back_bar, L.teleport_icon)
end
