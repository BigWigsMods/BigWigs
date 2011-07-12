--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Ragnaros", 800, 198)
if not mod then return end
mod:RegisterEnableMob(52409)

--------------------------------------------------------------------------------
-- Locals
--

local seedWarned = false
local blazingHeatTargets = mod:NewTargetList()
local sons = 8
local phase = 1
local smashCD = 30
local lastTransitionTime = nil
local moltenSeed, sulfurasSmash = (GetSpellInfo(98498)), (GetSpellInfo(98710))

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.seed_explosion = "Seed explosion!"
	L.intermission_bar = "Intermission!"
	L.intermission_message = "Intermission... Got cookies?"
	L.sons_left = "%d sons left"
	L.engulfing_close = "Close quarters Engulfed!"
	L.engulfing_middle = "Middle section Engulfed!"
	L.engulfing_far = "Far side Engulfed!"
	L.hand_bar = "Next knockback"
	L.ragnaros_back_message = "Raggy is back, party on!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		98237,
		98953, {100460, "ICON", "FLASHSHAKE", "SAY"},
		98498, 100178,
		99317,
		98710, "proximity", "berserk", "bosskill"
	}, {
		[98237] = "ej:2629",
		[98953] = L["intermission_bar"],
		[98498] = "ej:2640",
		[99317] = "ej:2655",
		[98710] = "general"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_DAMAGE", "MoltenSeed", 98498, 100579)
	self:Log("SPELL_CAST_START", "EngulfingFlames", 100175, 100171, 100178, 100181)
	self:Log("SPELL_CAST_SUCCESS", "HandofRagnaros", 98237, 100383)
	self:Log("SPELL_CAST_SUCCESS", "BlazingHeat", 100460)
	self:Log("SPELL_CAST_START", "SulfurasSmash", 98710, 100890)
	self:Log("SPELL_CAST_START", "SplittingBlow", 98953, 98952, 98951, 100880, 100883, 100877)
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus") -- Not yet implemented for the boss
	--self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:Death("Deaths", 52409, 53140) -- Ragnaros, Son of Flame
end

function mod:OnEngage(diff)
	self:Bar(98237, L["hand_bar"], 25, 98237)
	self:Bar(98710, sulfurasSmash, 30, 98710)
	self:OpenProximity(6)
	self:Berserk(600)
	smashCD = 30
	seedWarned = false
	sons = 8
	phase = 1
	lastTransitionTime = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function intermissionEnd()
	if lastTransitionTime and GetTime() < (lastTransitionTime + 30) then return end
	lastTransitionTime = GetTime()
	mod:CancelAllTimers()
	phase = phase + 1
	mod:SendMessage("BigWigs_StopBar", mod, L["intermission"])
	if phase == 2 then
		smashCD = 40 -- need to confirm
		mod:Bar(98498, moltenSeed, 24, 98498)
		mod:OpenProximity(6)
	elseif phase == 3 then
		mod:OpenProximity(5)
		-- this is just guesswork
		mod:Bar(99317, (GetSpellInfo(99317)), 15, 99317)
	end
	mod:Bar(98710, sulfurasSmash, 55, 98710) -- not sure if timer actually starts here
	mod:Message(98953, L["ragnaros_back_message"], "Positive", 98953) -- XXX should use raggy icon
end

function mod:HandofRagnaros(_, spellId, _, _, spellName)
	self:Bar(98237, L["hand_bar"], 25, spellId)
end

function mod:SplittingBlow(_, spellId)
	self:Message(98953, L["intermission_message"], "Positive", spellId, "Long")
	self:Bar(98953, L["intermission_bar"], 45, spellId)
	self:ScheduleTimer(intermissionEnd, 45)
	self:CloseProximity()
	sons = 8
	self:SendMessage("BigWigs_StopBar", self, sulfurasSmash)
	self:SendMessage("BigWigs_StopBar", self, moltenSeed)
end

function mod:SulfurasSmash(_, spellId, _, _, spellName)
	self:Message(98710, spellName, "Attention", spellId, "Info")
	self:Bar(98710, spellName, smashCD, spellId)
end

function mod:EngulfingFlames(_, spellId)
	if spellId == 100175 then -- correct
		self:Message(100178, L["engulfing_close"], "Important", spellId, "Alert")
	elseif spellId == 100171 or spellId == 100178 then -- Correct on 25man normal at least
		self:Message(100178, L["engulfing_middle"], "Important", spellId, "Alert")
	elseif spellId == 100181 then -- correct
		self:Message(100178, L["engulfing_far"], "Important", spellId, "Alert")
	end
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
			self:Bar(98498, L["seed_explosion"], 10, spellId)
			seedWarned = true
		end
	end
end

function mod:Deaths(mobId)
	if mobId == 53140 then
		sons = sons - 1
		if sons < 0 then return end
		if sons == 0 then
			intermissionEnd()
		elseif sons < 4 then
			self:Message(98953, L["sons_left"]:format(sons), "Positive", 100308) -- the speed buff icon on the sons
		end
	elseif mobId == 52409 then
		self:Win()
	end
end

