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
local fieryGrip = GetSpellInfo(109457)

-- Locals for Fiery Grip, described in comments below
local corruptionStatus, lastBar = {}, true

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
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
		105248, 109457, {105845, "FLASHSHAKE"}, {"roll", "FLASHSHAKE"},
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
	self:Log("SPELL_CAST_START", "Nuclear", 105845)
	self:Log("SPELL_CAST_START", "Seal", 105847, 105848) -- Left, Right
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Deaths", 53879, 56575, 56341)
end

function mod:OnBossDisable()
	-- We have to clear variables OnBossDisable because OnEngage doesn't trigger
	-- sometimes until several seconds into the fight due to no boss1 unit
	wipe(corruptionStatus)
	lastBar = true
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local tendrils = GetSpellInfo(109454)
	local function graspCheck()
		if not UnitDebuff("player", tendrils) then -- Grasping Tendrils
			mod:LocalMessage("roll", L["not_hooked"], "Personal", 109454, "Alert")
		end
	end

	local timer = nil
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
	* corruptionStatus is a map from Corruption GUID to a flag. We set the flag
	  to true and show a timer on Searing Plasma cast. Since grip happens every
	  2/4 plasma casts, we use this flag to prevent a bar happening again. When
	  the grip is casted, we reset the flag so we can make a new bar.
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
		corruptionStatus[sGUID] = true
		-- Only showing the bar if one isn't already up
		if not lastBar then
			lastBar = sGUID
			if self:Difficulty() % 2 == 0 then
				-- 25 man has 2 casts of 8s
				self:Bar(109457, fieryGrip, 16, 109457)
			else
				-- 10 man has 4 casts of 8s
				self:Bar(109457, fieryGrip, 32, 109457)
			end
		end
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

