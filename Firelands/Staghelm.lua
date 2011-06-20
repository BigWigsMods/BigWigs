if tonumber((select(4, GetBuildInfo()))) < 40200 then return end
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
local adrenaline = "%s %s x%d"
local catForm, scorpionForm = (GetSpellInfo(98374)), (GetSpellInfo(98379))
-- got data up to 15 stacks, after 11 its 3.7
local specialCD = {17.5, 13.4, 10.9, 8.6, 7.4, 7.3, 6.1, 6.1, 4.9, 4.9, 4.9}
local specialCounter = 1

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.seed_explosion = "Seed explosion soon!"
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
		[98379] = scorpionForm,
		[98374] = catForm,
		[98450] = (EJ_GetSectionInfo(2922)),
		[97238] = "general"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED_DOSE", "Adrenaline", 97238)
	self:Log("SPELL_AURA_APPLIED", "CatForm", 98374)
	self:Log("SPELL_AURA_APPLIED", "ScorpionForm", 98379)
	self:Log("SPELL_CAST_SUCCESS", "LeapingFlames", 98476)
	self:Log("SPELL_AURA_APPLIED", "SearingSeeds", 98450)
	self:Log("SPELL_AURA_REMOVED", "SearingSeedsRemoved", 98450)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 52571)
end

function mod:OnEngage(diff)
	self:Berserk(600) -- assumed
	specialCounter = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Adrenaline(_, spellId, _, _, spellName, stack)
	local form = (UnitDebuff("boss1", catForm)) or (UnitDebuff("boss1", scorpionForm)) or ""
	self:Message(97238, adrenaline:format(form, spellName, stack), "Attention", spellId)
	 -- this is power based, not time. Power regen is affected by adrenaline
	 -- adrenaline gets stacked every special
	specialCounter = specialCounter + 1
	if form == catForm then
		self:Bar(98476, leapingFlames, specialCD[specialCounter] or 3.7, 98476)
	elseif form == scorpionForm then
		self:Bar(100213, flameScythe, specialCD[specialCounter] or 3.7, 100213)
	end
end

do
	local function checkTarget()
		local mobId = mod:GetUnitIdByGUID(52571)
		if mobId then
			local player = UnitName(mobId.."target")
			if not player then return end
			if UnitIsUnit("player", player) then
				mod:Say(98476, CL["say"]:format(leapingFlames))
				mod:FlashShake(98476)
			end
			mod:TargetMessage(98476, leapingFlames, player, "Urgent", 98476, "Long")
			mod:PrimaryIcon(98476, player)
		end
	end
	function mod:LeapingFlames(...)
		self:ScheduleTimer(checkTarget, 0.1)
	end
end

function mod:CatForm(_, spellId, _, _, spellName)
	self:Message(98374, spellName, "Important", spellId, "Alert")
	self:OpenProximity(10, 98374)
	specialCounter = 1
	self:Bar(98476, leapingFlames, specialCD[specialCounter], 98476)
end

function mod:ScorpionForm(_, spellId, _, _, spellName)
	self:Message(98379, spellName, "Important", spellId, "Alert")
	self:CloseProximity(98374)
	specialCounter = 1
	self:Bar(100213, flameScythe, specialCD[specialCounter], 100213)
end

function mod:SearingSeedsRemoved()
	self:CloseProximity(98450)
end

do
	local function searingSeed()
		mod:LocalMessage(98450, L["seed_explosion"], "Personal", 98450, "Info")
		mod:FlashShake(98450)
		mod:OpenProximity(10, 98450)
	end

	function mod:SearingSeeds(player, spellId, _, _, spellName)
		self:SendMessage("BigWigs_StopBar", self, leapingFlames)
		if not UnitIsUnit(player, "player") then return end
		local remaining = (select(7,UnitDebuff("player", spellName)) - GetTime())
		self:Bar(98450, spellName, remaining, 98450)
		if remaining < 5 then
			searingSeed()
		else
			self:ScheduleTimer(searingSeed, remaining - 5)
		end
	end
end

