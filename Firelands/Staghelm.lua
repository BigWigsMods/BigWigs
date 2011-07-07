--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Majordomo Staghelm", 800, 197)
if not mod then return end
mod:RegisterEnableMob(52571)

--------------------------------------------------------------------------------
-- Locales
--

local leapingFlames, flameScythe = (GetSpellInfo(98476)), (GetSpellInfo(100213))
-- got data up to 15 stacks, after 11 its 3.7
local specialCD = {17.5, 13.4, 10.9, 8.6, 7.4, 7.3, 6.1, 6.1, 4.9, 4.9, 4.9}
local specialCounter = 1
local leapWarned = nil
local form = "cat"

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.seed_explosion = "You explode soon!"
	L.seed_bar = "You explode!"
	L.adrenaline_message = "Adrenaline x%d!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		98379, 100213,
		{98374, "PROXIMITY"}, {98476, "FLASHSHAKE", "ICON", "SAY"},
		{98450, "FLASHSHAKE", "PROXIMITY"},
		97238, "berserk", "bosskill"
	}, {
		[98379] = 98379,
		[98374] = 98374,
		[98450] = "ej:2922",
		[97238] = "general"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Adrenaline", 97238)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Adrenaline", 97238)
	self:Log("SPELL_AURA_APPLIED", "CatForm", 98374)
	self:Log("SPELL_AURA_APPLIED", "ScorpionForm", 98379)
	self:Log("SPELL_CAST_SUCCESS", "LeapingFlames", 98476, 100206)
	self:Log("SPELL_AURA_APPLIED", "SearingSeeds", 98450)
	self:Log("SPELL_AURA_REMOVED", "SearingSeedsRemoved", 98450)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 52571)
end

function mod:OnEngage(diff)
	self:Berserk(600) -- assumed
	specialCounter = 1
	leapWarned = nil
	form = "cat"
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Adrenaline(_, spellId, _, _, spellName, stack)
	self:Message(97238, L["adrenaline_message"]:format(stack), "Attention", spellId)
	 -- this is power based, not time. Power regen is affected by adrenaline
	 -- adrenaline gets stacked every special
	specialCounter = specialCounter + 1
	if form == "cat" then
		self:Bar(98476, leapingFlames, specialCD[specialCounter] or 3.7, 98476)
	elseif form == "scorpion" then
		self:Bar(100213, flameScythe, specialCD[specialCounter] or 3.7, 100213)
	end
end

do
	local function reset() leapWarned = nil end
	local function checkTarget()
		local mobId = mod:GetUnitIdByGUID(52571)
		if mobId then
			local player = UnitName(mobId.."target")
			if not player then return end
			leapWarned = true
			if UnitIsUnit("player", player) then
				mod:Say(98476, CL["say"]:format(leapingFlames))
				mod:FlashShake(98476)
			end
			mod:TargetMessage(98476, leapingFlames, player, "Urgent", 98476, "Long")
			mod:PrimaryIcon(98476, player)
		end
	end
	function mod:LeapingFlames(...)
		if leapWarned then return end
		leapWarned = true
		self:ScheduleTimer(reset, 2)
		self:ScheduleTimer(checkTarget, 0.2)
	end
end

function mod:CatForm(_, spellId, _, _, spellName)
	form = "cat"
	self:Message(98374, spellName, "Important", spellId, "Alert")
	self:OpenProximity(10, 98374)
	specialCounter = 1
	self:Bar(98476, leapingFlames, specialCD[specialCounter], 98476)
end

function mod:ScorpionForm(_, spellId, _, _, spellName)
	form = "scorpion"
	self:Message(98379, spellName, "Important", spellId, "Alert")
	self:CloseProximity(98374)
	specialCounter = 1
	self:Bar(100213, flameScythe, specialCD[specialCounter], 100213)
end

function mod:SearingSeedsRemoved(player)
	if not UnitIsUnit(player, "player") then return end
	self:CloseProximity(98450)
end

do
	local function searingSeed()
		mod:LocalMessage(98450, L["seed_explosion"], "Personal", 98450, "Alarm")
		mod:FlashShake(98450)
		mod:OpenProximity(12, 98450)
	end

	function mod:SearingSeeds(player, spellId, _, _, spellName)
		self:SendMessage("BigWigs_StopBar", self, leapingFlames)
		if not UnitIsUnit(player, "player") then return end
		local remaining = (select(7, UnitDebuff("player", spellName))) - GetTime()
		self:Bar(98450, L["seed_bar"], remaining, 98450)
		if remaining < 5 then
			searingSeed()
		else
			self:ScheduleTimer(searingSeed, remaining - 5)
		end
	end
end

