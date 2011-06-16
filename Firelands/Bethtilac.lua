if tonumber((select(4, GetBuildInfo()))) < 40200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Beth'tilac", 800)
if not mod then return end
mod:RegisterEnableMob(52498)

--------------------------------------------------------------------------------
-- Locals
--

local stackWarn = 5 -- probably needs change
local devastateCount = 1
local burst, smolderingDevastate = (GetSpellInfo(99990)), (GetSpellInfo(99052))
local cinderwebDrone_icon = "INV_Misc_Head_Nerubian_01"
local lastBroodlingTarget = ""

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.kiss_message = "%2$dx Kiss on %1$s"
	L.cinderwebDrone, L.cinderwebDrone_desc = EJ_GetSectionInfo(2773)
end
L = mod:GetLocale()

-- untested
local function droneWarning()
	mod:Message("cinderwebDrone", L["cinderwebDrone"], "Attention", cinderwebDrone_icon)
	mod:Bar("cinderwebDrone", L["cinderwebDrone"], 60, cinderwebDrone_icon)
	mod:ScheduleTimer(droneWarning, 60)
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		99052, "cinderwebDrone",
		99506, 99497,
		{99559, "FLASHSHAKE", "WHISPER"}, {99990, "FLASHSHAKE", "SAY"},
		"bosskill"
	}, {
		[99052] = (EJ_GetSectionInfo(2764)),
		[99506] = (EJ_GetSectionInfo(2782)),
		[99559] = "heroic",
		bosskill = "general"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_DAMAGE", "BroodlingWatcher", "*")
	self:Log("SPELL_MISS", "BroodlingWatcher", "*")

	self:Log("SPELL_AURA_APPLIED", "Fixate", 99559, 99526)
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 99497)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Kiss", 99506)
	self:Log("SPELL_CAST_START", "Devastate", 99052)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 52498)
end

function mod:OnEngage(diff)
	devastateCount = 1
	if diff > 2 then
		lastBroodlingTarget = ""
	end
	self:Bar(99052, ("~%s (%d)"):format(smolderingDevastate, devastateCount), 80, 99052)
	self:Bar("cinderwebDrone", L["cinderwebDrone"], 45, cinderwebDrone_icon)
	self:ScheduleTimer(droneWarning, 45)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local function broodlingWarn()
		local broodling = mod:GetUnitIdByGUID(53745)
		if broodling and UnitExists(broodling.."target") and UnitExists(lastBroodlingTarget) then
			if UnitIsUnit(broodling.."target", lastBroodlingTarget) then return end
			lastBroodlingTarget = UnitName(broodling.."target")
			if UnitExists(lastBroodlingTarget) then
				mod:TargetMessage(99990, burst, lastBroodlingTarget, "Important", 99990, "Alert")
				if UnitIsUnit(lastBroodlingTarget, "player") then
					mod:FlashShake(99990)
					mod:Say(99990, CL["say"]:format(burst))
				end
			end
		else
			mod:ScheduleTimer(broodlingWarn, 0.1)
		end
	end
	function mod:BroodlingWatcher()
		if GetInstanceDifficulty() < 3 then return end
		broodlingWarn()
	end
end

function mod:Fixate(player, spellId, _, _, spellName)
	self:TargetMessage(99559, spellName, player, "Important", spellId, "Alarm")
	if UnitIsUnit("player", player) then
		self:FlashShake(99559)
		self:Whisper(99559, player, CL["you"]:format(spellName))
	end
end

function mod:Frenzy()
	self:SendMessage("BigWigs_StopBar", self, ("~%s (%d)"):format(smolderingDevastate, devastateCount))
	self:Message(99497, CL["phase"]:format(2), "Attention", spellId, "Alarm")
end

function mod:Kiss(player, spellId, _, _, _, stack)
	if stack > stackWarn then
		self:TargetMessage(99506, L["kiss_message"], player, "Urgent", spellId, "Info", stack)
	end
end

function mod:Devastate(_, spellId)
	self:Message(99052, ("%s (%d)"):format(smolderingDevastate, devastateCount), "Important", spellId, "Long")
	-- This timer is only accurate if you dont fail with the Drones
	-- Might need to use the bosses power bar or something to adjust this
	self:Bar(99052, ("~%s (%d)"):format(smolderingDevastate, devastateCount), 90, spellId)
	devastateCount = devastateCount + 1
end

