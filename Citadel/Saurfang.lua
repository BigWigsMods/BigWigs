--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Deathbringer Saurfang", "Icecrown Citadel")
if not mod then return end
--Saurfang, Muradin, Marine, Overlord Saurfang, ???
mod:RegisterEnableMob(37813, 37200, 37830, 37187) --???, ???
mod.toggleOptions = {"adds", 72408, 72385, 72378, {72293, "WHISPER", "ICON", "FLASHSHAKE"}, 72737, "proximity", "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local bbTargets = mod:NewTargetList()
local killed = nil
local count = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.adds = "Blood Beasts"
	L.adds_desc = "Shows a timer and messages for when Blood Beasts spawn."
	L.adds_warning = "Blood Beasts in 5 sec!"
	L.adds_message = "Blood Beasts!"
	L.adds_bar = "Next Blood Beasts"

	L.rune_bar = "~Next Rune"

	L.nova_bar = "~Next Nova"

	L.mark = "Mark %d"

	L.engage_trigger = "BY THE MIGHT OF THE LICH KING!"
	L.warmup_alliance = "Let's get a move on then! Move ou..."
	L.warmup_horde = "Kor'kron, move out! Champions, watch your backs. The Scourge have been..."
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Adds", 72172, 72173, 72356, 72357, 72358)
	self:Log("SPELL_AURA_APPLIED", "RuneofBlood", 72408, 72409, 72410, 72447, 72448, 72449)
	self:Log("SPELL_AURA_APPLIED", "BoilingBlood", 72385, 72441, 72442, 72443)
	self:Log("SPELL_CAST_START", "BloodNova", 72378, 72379, 72380, 72438, 72439, 72440, 73058)
	self:Log("SPELL_AURA_APPLIED", "Mark", 72293)
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 72737)
	self:Death("Deaths", 37813)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Engage", L["engage_trigger"])
	self:Yell("Warmup", L["warmup_alliance"], L["warmup_horde"])
end

function mod:OnEngage()
	self:OpenProximity(11)
	self:Berserk(480)
	self:DelayedMessage("adds", 32, L["adds_warning"], "Attention")
	self:Bar("adds", L["adds_bar"], 37, 72172)
	self:Bar(72378, L["nova_bar"], 20, 72378)
	count = 1
end

function mod:Warmup(msg)
	self:OpenProximity(11)
	if msg == L["warmup_alliance"] then
		self:Bar("adds", self.displayName, 48, "achievement_boss_saurfang")
	else
		self:Bar("adds", self.displayName, 99, "achievement_boss_saurfang")
	end
end

function mod:VerifyEnable()
	if not killed then return true end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local t = 0
function mod:Adds(_, spellId)
	local time = GetTime()
	if (time - t) > 2 then
		t = time
		self:Message("adds", L["adds_message"], "Attention", spellId, "Alarm")
		self:DelayedMessage("adds", 35, L["adds_warning"], "Attention")
		self:Bar("adds", L["adds_bar"], 40, spellId)
	end
end

function mod:RuneofBlood(player, spellId, _, _, spellName)
	self:TargetMessage(72408, spellName, player, "Important", spellId, "Info")
	self:Bar(72408, L["rune_bar"], 20, spellId)
end

do
	local scheduled = nil
	local boilBlood = GetSpellInfo(72385)
	local function boilingWarn(spellId)
		mod:TargetMessage(72385, boilBlood, bbTargets, "Urgent", spellId, "Alert")
		scheduled = nil
	end
	function mod:BoilingBlood(player, spellId)
		bbTargets[#bbTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(boilingWarn, 0.3, spellId)
		end
	end
end

function mod:BloodNova(_, spellId, _, _, spellName)
	self:Message(72378, spellName, "Attention", spellId, "Info")
	self:Bar(72378, L["nova_bar"], 18, spellId)
end

function mod:Mark(player, spellId, _, _, spellName)
	self:TargetMessage(72293, L["mark"]:format(count), player, "Urgent", spellId, "Alert")
	count = count + 1
	self:Whisper(72293, player, spellName)
	self:PrimaryIcon(72293, player)
	if UnitIsUnit(player, "player") then self:FlashShake(72293) end
end

function mod:Frenzy(_, spellId, _, _, spellName)
	self:Message(72737, spellName, "Attention", spellId, "Long")
end

function mod:Deaths()
	killed = true
	self:Win()
end

