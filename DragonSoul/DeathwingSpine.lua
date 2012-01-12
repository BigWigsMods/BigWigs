--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Spine of Deathwing", 824, 318)
if not mod then return end
-- Deathwing, Burning Tendons, Burning Tendons, Corruption, Corruption, Corruption
mod:RegisterEnableMob(53879, 56575, 56341, 53891, 56161, 56162)

--------------------------------------------------------------------------------
-- Locales
--

local gripTargets = mod:NewTargetList()
local fieryGrip, residue = GetSpellInfo(109457), GetSpellInfo(105223)
local bloodCount = 0

-- Locals for Fiery Grip, described in comments below
local corruptionStatus, lastBar, nextGrip = {}, true, 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "The plates! He's coming apart! Tear up the plates and we've got a shot at bringing him down!"
	L.roll, L.roll_desc = EJ_GetSectionInfo(4050)
	L.roll_icon = "ACHIEVEMENT_BG_RETURNXFLAGS_DEF_WSG"

	L.left_start = "about to roll left"
	L.right_start = "about to roll right"
	L.left = "rolls left"
	L.right = "rolls right"
	L.not_hooked = "YOU are >NOT< hooked!"
	L.roll_message = "He's rolling, rolling, rolling!"
	L.level_trigger = "levels out"
	L.level_message = "Nevermind, he leveled out!"

	L.exposed = "Armor Exposed"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		105248, 105223, 109457, {105845, "FLASHSHAKE"}, {"roll", "FLASHSHAKE"},
		105848, "bosskill",
	}, {
		[105248] = "general",
	}
end

function mod:OnBossEnable()
	self:Emote("AboutToRoll", L["left_start"], L["right_start"])
	self:Emote("Rolls", L["left"], L["right"])
	self:Emote("Level", L["level_trigger"])
	self:Log("SPELL_AURA_APPLIED_DOSE", "AbsorbedBlood", 105248)
	self:Log("SPELL_CAST_SUCCESS", "FieryGripCast", 109457, 109458, 109459, 105490)
	self:Log("SPELL_CAST_START", "SearingPlasmaCast", 109379) -- Only one id in both modes
	self:Death("CorruptionDeath", 56161, 56162, 53891)
	self:Log("SPELL_AURA_APPLIED", "FieryGripApplied", 109457, 109458, 109459, 105490)
	self:Log("SPELL_CAST_SUCCESS", "ResidueChange", 105248, 109371, 109372, 109373, 105219) -- Absorbed Blood, Burst (x4)
	self:Log("SPELL_CAST_START", "Nuclear", 105845)
	self:Log("SPELL_CAST_START", "Seal", 105847, 105848) -- Left, Right
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Yell("Engage", L["engage_trigger"])
	self:Death("Deaths", 53879, 56575, 56341)
end

-- Note: Engage is not called as early as you may expect. It is about 4s from the start of combat
function mod:OnEngage()
	self:Reset()

	if not self:LFR() then
		-- Initial bars for grip since we cannot trigger off of it (pad by -5s)
		if self:Difficulty() % 2 == 0 then
			-- 25 man has 2 casts of 8s
			self:Bar(109457, "~"..fieryGrip, 11, 109457)
		else
			-- 10 man has 4 casts of 8s
			self:Bar(109457, "~"..fieryGrip, 27, 109457)
		end
	end
end

function mod:OnBossDisable()
	-- OnEngage triggers on a yell, which needs to be localized, and this must
	-- be run or else much of the module will not run as expected
	self:Reset()
end

function mod:Reset()
	wipe(corruptionStatus)
	lastBar = true
	bloodCount = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local tendrils = GetSpellInfo(109454)
	local timer = nil
	local function graspCheck()
        if not mod.isEngaged then
            -- Timer should not be spamming
            mod:CancelTimer(timer, true)
        end
		if not UnitDebuff("player", tendrils) and not UnitIsDead("player") then -- Grasping Tendrils
			mod:LocalMessage("roll", L["not_hooked"], "Personal", 109454, "Alert")
		end
	end

	function mod:AboutToRoll()
		self:Bar("roll", L["roll"], 5, L["roll_icon"])
		self:Message("roll", CL["custom_sec"]:format(L["roll"], 5), "Attention", L["roll_icon"], "Long")
		self:FlashShake("roll")
		if timer then self:CancelTimer(timer, true) end
		timer = self:ScheduleRepeatingTimer(graspCheck, 0.8)
	end
	function mod:Rolls()
		self:Message("roll", L["roll_message"], "Positive", L["roll_icon"])
		self:Bar("roll", CL["cast"]:format(L["roll"]), 5, L["roll_icon"])
		self:CancelTimer(timer, true)
		timer = nil
	end
	function mod:Level()
		self:Message("roll", L["level_message"], "Attention", L["roll_icon"])
		self:SendMessage("BigWigs_StopBar", self, L["roll"])
		self:CancelTimer(timer, true)
		timer = nil
	end
end

function mod:AbsorbedBlood(_, spellId, _, _, spellName, stack)
	if stack > 5 then
		self:Message(105248, ("%s (%d)"):format(spellName, stack), "Urgent", spellId)
	end
end

--[[ 
	Notes on Fiery Grip:
	* corruptionStatus is a map from Corruption GUID to a number. We set the 
	  number to 0 initially and increment it with each cast until it is reset 
	  at the grip. A timer is shown (or readjusted) at every cast. 
	* lastBar holds the GUID of the Corruption that triggered the bar. This
	  way, if it dies, we can kill the bar. This also serves as a throttle so
	  that we have at most one bar up at any time, which should be good enough.
	  We set it to true initially because we miss the first plasma cast for some 
	  reason (likely because of the zone change).
]]
function mod:FieryGripCast(_, spellId, _, _, spellName, _, _, _, _, _, sGUID)
	-- Reset flag
	corruptionStatus[sGUID] = nil
	if lastBar == sGUID or lastBar == true then
		lastBar = nil
		self:SendMessage("BigWigs_StopBar", self, fieryGrip)
	end
end

function mod:SearingPlasmaCast(_, spellId, _, _, spellName, _, _, _, _, _, sGUID)
	-- Set flag and maybe show bar, ignore if already set
	if not corruptionStatus[sGUID] then
		corruptionStatus[sGUID] = 0
	else
		corruptionStatus[sGUID] = corruptionStatus[sGUID] + 1
	end

	local gripTime = 0
	if self:Difficulty() % 2 == 0 then
		-- 25 man has 2 casts of 8s
		gripTime = 16
	else
		-- 10 man has 4 casts of 8s
		gripTime = 32
	end
	gripTime = gripTime - corruptionStatus[sGUID] * 8
	local nextGripNew = gripTime + GetTime()

	-- Only showing the bar if one isn't already up or if we need to recalibrate (error > 0.5s)
	if not lastBar or (lastBar == sGUID and math.abs(nextGrip - nextGripNew) > 0.5) then
		lastBar = sGUID
		nextGrip = nextGripNew
		self:Bar(109457, fieryGrip, gripTime, 109457)
	end
end

function mod:CorruptionDeath(_, GUID)
	if lastBar == GUID then
		-- Cancel bar
		corruptionStatus[GUID] = nil
		lastBar = nil
		self:SendMessage("BigWigs_StopBar", self, fieryGrip)
	end
end

do
	-- Residue reporting will wait one full second after changes to report how
	-- many are up to prevent spamming when the mob picks up a bunch
	local scheduled = nil
	local function reportBloods()
		mod:Message(105223, ("%s (%d)"):format(residue, bloodCount), "Attention", 105223)
		scheduled = nil
	end
	local haltPrinting = true
	function mod:ResidueChange(_, spellId, _, _, spellName)
		if spellId == 109371 or spellId == 109372 or spellId == 109373 or spellId == 105219 then
			-- Burst (+1)
			bloodCount = bloodCount + 1
		elseif spellId == 105248 then
			-- Absorbed Blood (-1)
			bloodCount = bloodCount - 1
		end

		-- start printing if we're over 3
		if bloodCount > 3 then
			haltPrinting = false
		end

		-- We are only printing if the haltPrinting flag has been turned off
		if not haltPrinting then
			if scheduled then
				self:CancelTimer(scheduled, true)
			end
			scheduled = self:ScheduleTimer(reportBloods, 1) 
		end

		-- once we reach 0, we will hold until we pass the threshold again
		-- this must be after the print so we know when we drop to 0
		if bloodCount == 0 then
			haltPrinting = true
		end
	end
end

function mod:Nuclear(_, spellId, _, _, spellName)
	self:Message(105845, spellName, "Important", spellId, "Info")
	self:Bar(105845, spellName, 5, spellId)
	self:FlashShake(105845)
end

function mod:Seal(_, spellId)
	self:Message(105848, L["exposed"], "Important", spellId)
	self:Bar(105848, L["exposed"], self:LFR() and 33 or 23, spellId) -- 33 is a guess
end

do
	local scheduled = nil
	local function grip(spellName)
		mod:TargetMessage(109457, spellName, gripTargets, "Urgent", 109457)
		scheduled = nil
	end
	function mod:FieryGripApplied(player, spellId, _, _, spellName)
		gripTargets[#gripTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(grip, 0.2, spellName)
		end
	end
end

function mod:Deaths(mobId)
	if mobId == 53879 then
		self:Win()
	else
		self:SendMessage("BigWigs_StopBar", self, L["exposed"])
	end
end

