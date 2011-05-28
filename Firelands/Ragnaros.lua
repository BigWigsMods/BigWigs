if tonumber((select(4, GetBuildInfo()))) < 40200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Ragnaros", 800)
if not mod then return end
mod:RegisterEnableMob(52409)

--------------------------------------------------------------------------------
-- Locals
--

seedWarned = false
local blazingHeatTargets = mod:NewTargetList()
local sons = 8
local phase = 1

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.stage_one = "Stage 1: By Fire Be Purged!"
	L.intermission = "Intermission"
	L.stage_two = "Stage 2: Sulfuras Will Be Your End!"
	L.stage_three = "Stage 3: Begon From My Realm!"
	L.sons_dead = "Sons Dead!"
	L.sons_left = "%d Sons Left"

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		98237,
		98953, {100460, "ICON", "FLASHSHAKE", "SAY"},
		98498,
		99317,
		98710, "proximity", "bosskill"
	}, {
		[98237] = L["stage_one"],
		[98953] = L["intermission"],
		[98498] = L["stage_two"],
		[99317] = L["stage_three"],
		[98710] = "general"
	}
end

function mod:OnBossEnable()

	self:Log("SPELL_DAMAGE", "MoltenSeed", 98498)

	self:Log("SPELL_CAST_SUCCESS", "HandofRagnaros", 98237)
	self:Log("SPELL_CAST_SUCCESS", "BlazingHeat", 100460)
	self:Log("SPELL_CAST_START", "SulfurasSmash", 98710)
	self:Log("SPELL_CAST_START", "SplittingBlow", 98953, 98952, 98951)
	--self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus") -- Not yet implemented for the boss
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:Death("Deaths", 52409, 53140) -- Ragnaros, Son of Flame
end

function mod:OnEngage(diff)
	self:Bar(98237, (GetSpellInfo(98237)), 25, 98237)
	self:OpenProximity(6)
	seedWarned = false
	sons = 8
	phase = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:HandofRagnaros(_, spellId, _, _, spellName)
	self:Message(98237, spellName, "Attention", spellId)
	self:Bar(98237, spellName, 25, spellId)
end

function mod:SplittingBlow(_, spellId, _, _, spellName)
	self:Message(98953, spellName, "Urgent", spellId, "Alarm")
	self:Bar(98953, spellName, 7, spellId)
	self:Bar(98953, L["intermission"], 45, spellId)
	self:CloseProximity()
	sons = 8
	self:SendMessage("BigWigs_StopBar", self, (GetSpellInfo(98237))) -- HandofRagnaros
	self:SendMessage("BigWigs_StopBar", self, (GetSpellInfo(98710))) -- SulfurasSmash
end

function mod:SulfurasSmash(_, spellId, _, _, spellName)
	self:Message(98710, spellName, "Urgent", spellId, "Alarm")
	self:Bar(98710, spellName, 41, spellId)
end

do
	local scheduled = nil
	local iconCounter = 1
	local function blazingHeatWarn(spellName)
		mod:TargetMessage(100460, spellName, blazingHeatTargets, "Attention", 100460, "Info")
		scheduled = nil
	end

	function mod:BlazingHeat(player, spellID, _, _, spellName)
		blazingHeatTargets[#blazingHeatTargets + 1] = player
		if UnitIsUnit(player, "player") then
			self:Say(100460, CL["say"]:format(spellName)) -- not 100% sure if we need a say
			self:FlashShake(100460)
		end
		if iconCounter == 1 then
			self:PrimaryIcon(100460, player)
			iconCounter = 2
		else
			self:SecondaryIcon(100460, player)
			iconCounter = 1
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(blazingHeatWarn, 0.3, spellName)
		end
	end
end

do
	local function moltenSeedWarned()
		seedWarned = false
	end
	function mod:MoltenSeed(_, spellId, _, _, spellName)
		if not seedWarned then
			self:ScheduleTimer(moltenSeedWarned, 5)
			self:Message(98498, spellName, "Urgent", spellId, "Alarm")
			self:Bar(98498, spellName, 60, spellId)
			seedWarned = true
		end
	end
end

function mod:Deaths(mobId)
	if mobId == 53140 then
		sons = sons - 1
		if sons < 3 then
			self:Message(98953, L["sons_left"]:format(sons), "Positive", 100308) -- the speed buff icon on the sons
		elseif sons == 0 then
			phase = phase + 1
			if phase == 2 then
				self:Bar(98498, (GetSpellInfo(98498)), 15, 98498) -- Molten Seed
			else
				-- this is just guesswork
				self:Bar(99317, (GetSpellInfo(99317)), 15, 99317) -- Living Meteor
			end
			self:Message(98953, CL["phase"]:format(phase), "Positive", 98953)
		end
	elseif mobId == 52409 then
		self:Win()
	end
end

