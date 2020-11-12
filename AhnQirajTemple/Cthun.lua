
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("C'Thun", 531)
if not mod then return end
mod:RegisterEnableMob(15727, 15589) -- C'Thun, Eye of C'Thun
mod:SetAllowWin(true)
mod.engageId = 717

local timeP1Tentacle = 45      -- tentacle timers for phase 1
local timeP1TentacleStart = 45 -- delay for first tentacles from engage onwards
local timeP1GlareStart = 48    -- delay for first dark glare from engage onwards
local timeP1Glare = 86         -- interval for dark glare
local timeP1GlareDuration = 40 -- duration of dark glare
local timeP2Offset = 12        -- delay for all timers to restart after the Eye dies
local timeP2Tentacle = 30      -- tentacle timers for phase 2
local timeReschedule = 60      -- delay from the moment of weakening for timers to restart
local timeTarget = 0.2         -- delay for target change checking on Eye of C'Thun
local timeWeakened = 45        -- duration of a weaken

local phase2started = nil
local firstGlare = nil
local firstWarning = nil
local target = nil
local tentacletime = timeP1TentacleStart

local timerTentacles = nil
local timerDarkGlare = nil
local timerGroupWarning = nil
local timerCheckTarget = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "C'Thun"

	L.tentacle = "Tentacles"
	L.tentacle_desc = "Warn for Tentacles"
	L.tentacle_icon = 26391 -- inv_misc_ahnqirajtrinket_05 / Tentacle Call

	L.giant = "Giant Eye Alert"
	L.giant_desc = "Warn for Giant Eyes"

	L.weakened = "Weakened Alert"
	L.weakened_desc = "Warn for Weakened State"
	L.weakened_icon = 23578 -- ability_hunter_snipershot / Expose Weakness

	L.weakenedtrigger = "%s is weakened!"

	L.weakened_msg = "C'Thun is weakened for 45 sec"
	L.invulnerable2 = "Party ends in 5 seconds"
	L.invulnerable1 = "Party over - C'Thun invulnerable"

	L.giant3 = "Giant Eye - 10 sec"
	L.giant2 = "Giant Eye - 5 sec"
	L.giant1 = "Giant Eye - Poke it!"

	L.startwarn = "C'Thun engaged! - 45 sec until Dark Glare and Eyes"

	L.tentacleParty = "Tentacle party!"
	L.barWeakened = "C'Thun is weakened!"
	L.barGiant = "Giant Eye!"

	L.groupwarning = "Dark Glare on group %s (%s)"
	L.phase2starting = "The Eye is dead! Body incoming!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"tentacle",
		26029, -- Dark Glare
		"giant",
		"weakened",
		"stages",
		"proximity",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterMessage("BigWigs_BossComm")

	self:Death("EyeKilled", 15589)
end

function mod:OnEngage()
	target = nil
	firstGlare = true
	firstWarning = true
	phase2started = nil
	tentacletime = timeP1Tentacle

	self:Message("stages", "yellow", L.startwarn, false)

	self:Bar("tentacle", timeP1TentacleStart, L.tentacleParty, L.tentacle_icon) -- Tentacle party
	self:DelayedMessage("tentacle", timeP1TentacleStart - 5, "orange", CL.custom_sec:format(L.tentacle, 5)) -- Tentacles in 5 sec
	self:DelayedMessage("tentacle", timeP1TentacleStart, "red", L.tentacleParty, L.tentacle_icon) -- Tentacle party

	self:Bar(26029, timeP1GlareStart) -- Dark Glare
	self:DelayedMessage(26029, timeP1GlareStart - 5, "orange", CL.custom_sec:format(self:SpellName(26029), 5)) -- Dark Glare in 5 sec
	self:DelayedMessage(26029, timeP1GlareStart, "red", 26029, 26029) -- Dark Glare

	timerTentacles = self:ScheduleTimer("StartTentacles", timeP1TentacleStart)
	timerDarkGlare = self:ScheduleTimer("DarkGlare", timeP1GlareStart)
	timerGroupWarning = self:ScheduleTimer("GroupWarning", timeP1GlareStart - 3)
	timerCheckTarget = self:ScheduleRepeatingTimer("CheckTarget", timeTarget)

	self:OpenProximity("proximity", 10)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CHAT_MSG_MONSTER_EMOTE(_, msg)
	if msg == L.weakenedtrigger then
		self:Sync("CThunWeakened")
	end
end

function mod:EyeKilled()
	self:Sync("CThunP2Start")
end

do
	local times = {
		["CThunP2Start"] = 0,
		["CThunWeakened"] = 0,
	}
	function mod:BigWigs_BossComm(_, msg)
		if times[msg] then
			local t = GetTime()
			if t-times[msg] > 5 then
				times[msg] = t
				self[msg](self)
			end
		end
	end
end

function mod:CThunP2Start()
	if not phase2started then
		phase2started = true
		tentacletime = timeP2Tentacle

		self:Message("stages", "cyan", L.phase2starting, false)

		self:StopBar(L.tentacleParty)

		local darkGlare = self:SpellName(26029)
		self:StopBar(darkGlare) -- Dark Glare
		self:StopBar(CL.cast:format(darkGlare)) -- Cast: Dark Glare
		self:CancelDelayedMessage(darkGlare) -- Dark Glare
		self:CancelDelayedMessage(CL.custom_sec:format(darkGlare, 5)) -- Dark Glare in 5 sec
		self:CancelDelayedMessage(CL.over:format(darkGlare)) -- Dark Glare Over

		-- cancel the repeaters
		self:CancelTimer(timerTentacles)
		self:CancelTimer(timerDarkGlare)
		self:CancelTimer(timerGroupWarning)
		self:CancelTimer(timerCheckTarget)

		self:DelayedMessage("tentacle", timeP2Tentacle + timeP2Offset -.1, "red", L.tentacleParty, L.tentacle_icon) -- Tentacle party
		self:DelayedMessage("tentacle", timeP2Tentacle + timeP2Offset - 5, "orange", CL.custom_sec:format(L.tentacle, 5)) -- Tentacles in 5 sec
		self:Bar("tentacle", timeP2Tentacle + timeP2Offset, L.tentacleParty, L.tentacle_icon) -- Tentacle party

		-- Giant eye warnings seem off now, possibly changed or broken by Blizz
		--self:DelayedMessage("giant", timeP2Tentacle + timeP2Offset -.1, "red", L["giant1"], "Ability_EyeOfTheOwl")
		--self:DelayedMessage("giant", timeP2Tentacle + timeP2Offset - 5, "orange", L["giant2"])
		--self:DelayedMessage("giant", timeP2Tentacle + timeP2Offset - 10, "yellow", L["giant3"])
		--self:Bar("giant", timeP2Tentacle + timeP2Offset, L["barGiant"], "Ability_EyeOfTheOwl")

		timerTentacles = self:ScheduleTimer("StartTentacles", timeP2Tentacle + timeP2Offset)
	end
end

function mod:CThunWeakened()
	self:Message("weakened", "green", L.weakened_msg, L.weakened_icon)
	self:Bar("weakened", timeWeakened, L.barWeakened, L.weakened_icon)
	self:DelayedMessage("weakened", timeWeakened - 5, "orange", L.invulnerable2)
	self:DelayedMessage("weakened", timeWeakened, "red", L.invulnerable1)

	-- cancel tentacle timers
	self:CancelDelayedMessage(L.tentacleParty) -- Tentacle party
	self:CancelDelayedMessage(CL.custom_sec:format(L.tentacle, 5)) -- Tentacles in 5 sec
	self:StopBar(L.tentacleParty)

	--self:CancelDelayedMessage(L["giant1"])
	--self:CancelDelayedMessage(L["giant2"])
	--self:CancelDelayedMessage(L["giant3"])
	--self:StopBar(L["barGiant"])
	-- flipflop the giant eye flag
	--gianteye = not gianteye

	self:CancelTimer(timerTentacles)
	self:ScheduleTimer("OutOfWeaken", timeReschedule)
end

--------------------------------------------------------------------------------
-- Utility Functions
--

function mod:OutOfWeaken()
	self:StartTentacles()
	-- Also fires up a big claw here, but we don't warn for them?
end

function mod:StartTentacles()
	self:Tentacles()
	timerTentacles = self:ScheduleRepeatingTimer("Tentacles", tentacletime)
end

function mod:CheckTarget()
	local unit = self:GetUnitIdByGUID(15589) -- Eye of C'Thun
	if unit then
		local unitTarget = unit.."target"
		local guid = UnitGUID(unitTarget)
		if guid then
			target = guid
		end
	end
end

function mod:GroupWarning()
	if target then
		for unit in self:IterateGroup() do
			local guid = UnitGUID(unit)
			if target == guid then
				local name = self:UnitName(unit)
				if not IsInRaid() then
					self:Message(26029, "red", L.groupwarning:format(1, name), 26029)
				else
					for i = 1, GetNumGroupMembers() do
						local n, _, group = GetRaidRosterInfo(i)
						if name == n then
							self:Message(26029, "red", L.groupwarning:format(group, name), 26029)
							break
						end
					end
				end
				break
			end
		end
	end
	if firstWarning then
		firstWarning = nil
		self:CancelTimer(timerGroupWarning)
		timerGroupWarning = self:ScheduleRepeatingTimer("GroupWarning", timeP1Glare)
	end
end

function mod:Tentacles()
	if phase2started then
		--if gianteye then
		--	gianteye = nil
		--	self:Bar("giant", tentacletime, L["barGiant"], "Ability_EyeOfTheOwl")
		--	self:DelayedMessage("giant", tentacletime -.1, "red", L["giant1"])
		--	self:DelayedMessage("giant", tentacletime - 5, "orange", L["giant2"])
		--	self:DelayedMessage("giant", tentacletime - 10, "yellow", L["giant3"])
		--else
		--	gianteye = true
		--end
	end
	self:Bar("tentacle", tentacletime, L.tentacleParty, L.tentacle_icon) -- Tentacle party
	self:DelayedMessage("tentacle", tentacletime -.1, "red", L.tentacleParty, L.tentacle_icon) -- Tentacle party
	self:DelayedMessage("tentacle", tentacletime -5, "orange", CL.custom_sec:format(L.tentacle, 5)) -- Tentacles in 5 sec
end

function mod:DarkGlare()
	self:CastBar(26029, timeP1GlareDuration)
	self:Bar(26029, timeP1Glare) -- Dark Glare
	local darkGlare = self:SpellName(26029)
	self:DelayedMessage(26029, timeP1Glare - .1, "red", darkGlare, 26029) -- Dark Glare
	self:DelayedMessage(26029, timeP1Glare - 5, "orange", CL.custom_sec:format(darkGlare, 5)) -- Dark Glare in 5 sec
	self:DelayedMessage(26029, timeP1GlareDuration, "red", CL.over:format(darkGlare)) -- Dark Glare Over
	if firstGlare then
		firstGlare = nil
		self:CancelTimer(timerDarkGlare)
		timerDarkGlare = self:ScheduleRepeatingTimer("DarkGlare", timeP1Glare)
	end
end
