--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Beth'tilac", 800, 192)
if not mod then return end
mod:RegisterEnableMob(52498)

--------------------------------------------------------------------------------
-- Locals
--

local devastateCount = 1
local lastBroodlingTarget = ""

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.devastate_message = "Devastation #%d!"
	L.devastate_bar = "~Next devastation"
	L.drone_bar = "Next Drone"
	L.drone_message = "Drone incoming!"
	L.kiss_message = "Kiss"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		{99052, "FLASHSHAKE"}, "ej:2773",
		99506, 99497,
		{99559, "FLASHSHAKE", "WHISPER"}, {99990, "FLASHSHAKE", "SAY"},
		"bosskill"
	}, {
		[99052] = "ej:2764",
		[99506] = "ej:2782",
		[99559] = "heroic",
		bosskill = "general"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_DAMAGE", "BroodlingWatcher", "*")
	self:Log("SPELL_MISS", "BroodlingWatcher", "*")

	self:Log("SPELL_AURA_APPLIED", "Fixate", 99559, 99526)
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 99497)
	self:Log("SPELL_AURA_APPLIED", "Kiss", 99506)
	self:Log("SPELL_CAST_START", "Devastate", 99052)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 52498)
end

do
	local droneIcon = "INV_Misc_Head_Nerubian_01"
	local scheduled = nil

	local function droneWarning()
		mod:Message("ej:2773", L["drone_message"], "Attention", droneIcon, "Info")
		mod:Bar("ej:2773", L["drone_bar"], 60, droneIcon)
		scheduled = mod:ScheduleTimer(droneWarning, 60)
	end

	function mod:OnEngage(diff)
		devastateCount = 1
		lastBroodlingTarget = ""
		self:Bar(99052, L["devastate_bar"], 80, 99052)
		self:Bar("ej:2773", L["drone_bar"], 45, droneIcon)
		self:CancelTimer(scheduled, true)
		scheduled = self:ScheduleTimer(droneWarning, 45)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local burst = GetSpellInfo(99990)

	function mod:BroodlingWatcher()
		if self:Difficulty() < 3 then return end
		local broodling = self:GetUnitIdByGUID(53745)
		if broodling and UnitExists(broodling.."target") and UnitExists(lastBroodlingTarget) then
			if UnitIsUnit(broodling.."target", lastBroodlingTarget) then return end
			lastBroodlingTarget = UnitName(broodling.."target")
			self:TargetMessage(99990, burst, lastBroodlingTarget, "Important", 99990, "Alert")
			if UnitIsUnit(lastBroodlingTarget, "player") then
				self:FlashShake(99990)
				self:Say(99990, CL["say"]:format(burst))
			end
		end
	end
end

function mod:Fixate(player, spellId, _, _, spellName)
	self:TargetMessage(99559, spellName, player, "Attention", spellId, "Alarm")
	if UnitIsUnit("player", player) then
		self:FlashShake(99559)
		self:Whisper(99559, player, CL["you"]:format(spellName))
	end
end

function mod:Frenzy()
	self:CancelAllTimers()
	self:SendMessage("BigWigs_StopBar", self, L["drone_bar"])
	self:SendMessage("BigWigs_StopBar", self, L["devastate_bar"])
	self:Message(99497, CL["phase"]:format(2), "Positive", 99497, "Alarm")
end

function mod:Kiss(player, spellId, _, _, spellName)
	self:TargetMessage(99506, L["kiss_message"], player, "Urgent", spellId)
	-- We play the sound manually because TargetMessage strips it unless the target is the player
	self:PlaySound(99506, "Info")
end

function mod:Devastate(_, spellId, _, _, spellName)
	local name = GetSpellInfo(100048) --Fiery Web Silk
	local hasDebuff = UnitDebuff("player", name)
	if hasDebuff then
		self:Message(99052, L["devastate_message"]:format(devastateCount), "Important", spellId, "Long")
		self:FlashShake(99052)
		self:Bar(99052, spellName, 8, spellId)
	else
		self:Message(99052, L["devastate_message"]:format(devastateCount), "Attention", spellId)
	end
	devastateCount = devastateCount + 1
	-- This timer is only accurate if you dont fail with the Drones
	-- Might need to use the bosses power bar or something to adjust this
	if devastateCount > 3 then return end
	self:Bar(99052, L["devastate_bar"], 90, spellId)
end

