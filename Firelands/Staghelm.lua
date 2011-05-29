if tonumber((select(4, GetBuildInfo()))) < 40200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Majordomo Staghelm", 800)
if not mod then return end
mod:RegisterEnableMob(52571)

--------------------------------------------------------------------------------
-- Locales
--

local leapingFlames = GetSpellInfo(98476)
local adenaline = "%s %s x%d"
local catForm, scorpionForm = (GetSpellInfo(98374)), (GetSpellInfo(98379))
local leapCD = {17.5, 13, 11, 8.5, 7} -- need more data to go down to 5 sec
local leapCounter = 1

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.seed_explosion = "Seed explosion soon!"
	L.human_form = "Human Form" -- Shouls use EJ here
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		98379,
		{98374, "PROXIMITY"}, {98476, "FLASHSHAKE", "ICON", "SAY"},
		{98450, "FLASHSHAKE", "PROXIMITY"},
		97238, "berserk", "bosskill"
	}, {
		[98379] = scorpionForm,
		[98374] = catForm,
		[98450] = L["human_form"],
		[97238] = "general"
	}
end

function mod:OnBossEnable()

	self:Log("SPELL_AURA_APPLIED_DOSE", "Adrenaline", 97238)
	self:Log("SPELL_AURA_APPLIED", "CatForm", 98374)
	self:Log("SPELL_AURA_APPLIED", "ScorpionForm", 98379)
	self:Log("SPELL_CAST_SUCCESS", "LaepingFlames", 98476)
	self:Log("SPELL_AURA_APPLIED", "SearingSeedsApplied", 98450)
	self:Log("SPELL_AURA_REMOVED", "SearingSeedsRemoved", 98450)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 52571)
end

function mod:OnEngage(diff)
	self:Berserk(600) -- assumed
	leapCounter = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Adrenaline(_, spellId, _, _, spellName, stack)
	local message = (UnitDebuff("boss1", catForm)) or (UnitDebuff("boss1", scorpionForm)) or ""
	self:Message(97238, adenaline:format(message, spellName, stack), "Attention", spellId)
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
	function mod:LaepingFlames(...)
		leapCounter = leapCounter + 1
		 -- this is power based, not time. Power regen is affected by adrenaline
		 -- adrenaline gets stacked every jump
		 -- also if its faster than 5 sec you will probably wipe anyways
		self:Bar(98476, leapingFlames, leapCD[leapCounter] or 5, 98476)
		self:ScheduleTimer(checkTarget, 0.1)
	end
end

function mod:CatForm(_, spellId, _, _, spellName)
	self:Message(98374, spellName, "Important", spellId, "Alert")
	self:OpenProximity(10, 98374)
	leapCounter = 1
	self:Bar(98476, leapingFlames, leapCD[leapCounter], 98476)
end

function mod:ScorpionForm(_, spellId, _, _, spellName)
	self:Message(98379, spellName, "Important", spellId, "Alert")
	self:CloseProximity(98374)
end

function mod:SearingSeedsRemoved()
	self:CloseProximity(98450)
end

do
	local function searingSeed()
		mod:LocalMessage(98450, L["seed_explosion"], "Personal", 98450, "Info")
		mod:FlahShake(98450)
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


