--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Gothik the Harvester", 533)
if not mod then return end
mod:RegisterEnableMob(16060)
mod:SetAllowWin(true)
mod.engageId = 1109

--------------------------------------------------------------------------------
-- Locales
--

local wave = 0
local numTrainer, numDK, numRider = 1, 1, 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Gothik the Harvester"

	L.room = "Room Arrival Warnings"
	L.room_desc = "Warn for Gothik's arrival"

	L.add = "Add Warnings"
	L.add_desc = "Warn for adds"

	L.adddeath = "Add Death Alert"
	L.adddeath_desc = "Alerts when an add dies."

	L.starttrigger1 = "Foolishly you have sought your own demise."
	L.starttrigger2 = "Teamanare shi rikk mannor rikk lok karkun"
	L.startwarn = "Gothik the Harvester engaged! 4:30 till he's in the room."

	L.rider = "Unrelenting Rider"
	L.spectral_rider = "Spectral Rider"
	L.deathknight = "Unrelenting Deathknight"
	L.spectral_deathknight = "Spektral Deathknight"
	L.trainee = "Unrelenting Trainee"
	L.spectral_trainee = "Spectral Trainee"

	L.riderdiewarn = "Rider dead!"
	L.dkdiewarn = "Death Knight dead!"

	L.warn1 = "In room in 3 min"
	L.warn2 = "In room in 90 sec"
	L.warn3 = "In room in 60 sec"
	L.warn4 = "In room in 30 sec"
	L.warn5 = "Gothik Incoming in 10 sec"

	L.wave = "%d/23: %s"

	L.trawarn = "Trainees in 3 sec"
	L.dkwarn = "Deathknights in 3 sec"
	L.riderwarn = "Rider in 3 sec"

	L.trabar = "Trainee - %d"
	L.dkbar = "Deathknight - %d"
	L.riderbar = "Rider - %d"

	L.inroomtrigger = "I have waited long enough. Now you face the harvester of souls."
	L.inroomwarn = "He's in the room!"

	L.inroombartext = "In Room"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"room",
		"add",
		"adddeath",
	}
end

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	self:BossYell("InRoom", L.inroomtrigger)
	self:Death("Deaths", 16125, 16126) -- DK, Rider
end

function mod:OnEngage()
	self:Message("room", "yellow", L.startwarn, false)
	self:Bar("room", 270, L.inroombartext, "Spell_Magic_LesserInvisibilty")
	self:DelayedMessage("room", 90, "yellow", L.warn1)
	self:DelayedMessage("room", 180, "yellow", L.warn2)
	self:DelayedMessage("room", 210, "orange", L.warn3)
	self:DelayedMessage("room", 240, "red", L.warn4)
	self:DelayedMessage("room", 260, "red", L.warn5)

	wave = 0
	numTrainer, numDK, numRider = 1, 1, 1
	self:NewTrainee(27)
	self:NewDeathknight(77)
	self:NewRider(137)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Deaths(args)
	if args.mobId == 16125 then
		self:Message("adddeath", "red", L.dkdiewarn, false)
	elseif args.mobId == 16126 then
		self:Message("adddeath", "red", L.riderdiewarn, false)
	end
end

function mod:InRoom()
	self:Message("room", "red", L.inroomwarn, false)
end

-- Wave timers

local colors = {
	[L.trawarn] = "yellow",
	[L.dkwarn] = "orange",
	[L.riderwarn] = "red",
}
local function waveWarn(message)
	wave = wave + 1
	if wave < 24 then
		mod:Message("add", colors[message], L.wave:format(wave, message), false) -- SetOption::yellow,orange,red::
	end
	if wave == 23 then
		mod:StopBar(L.trabar:format(numTrainer - 1))
		mod:StopBar(L.dkbar:format(numDK - 1))
		mod:StopBar(L.riderbar:format(numRider - 1))
		mod:CancelAllTimers()
	end
end

function mod:NewTrainee(timeTrainer)
	self:Bar("add", timeTrainer, L.trabar:format(numTrainer), "Ability_Seal")
	self:ScheduleTimer(waveWarn, timeTrainer - 3, L.trawarn)
	self:ScheduleTimer("NewTrainee", timeTrainer, 20)
	numTrainer = numTrainer + 1
end

function mod:NewDeathknight(timeDK)
	self:Bar("add", timeDK, L.dkbar:format(numDK), "INV_Boots_Plate_08")
	self:ScheduleTimer(waveWarn, timeDK - 3, L.dkwarn)
	self:ScheduleTimer("NewDeathknight", timeDK, 25)
	numDK = numDK + 1
end

function mod:NewRider(timeRider)
	self:Bar("add", timeRider, L.riderbar:format(numRider), "Spell_Shadow_DeathPact")
	self:ScheduleTimer(waveWarn, timeRider - 3, L.riderwarn)
	self:ScheduleTimer("NewRider", timeRider, 30)
	numRider = numRider + 1
end
