--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Lord Marrowgar", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36612)
mod.toggleOptions = {69076, 69057, {69146, "FLASHSHAKE"}, "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local impaleTargets = mod:NewTargetList()
local difficulty = GetRaidDifficulty()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.impale_cd = "~Next Impale"

	L.bonestorm_cd = "~Next Bonestorm"
	L.bonestorm_warning = "Bonestorm in 5 sec!"

	L.coldflame_message = "Coldflame on YOU!"

	L.engage_trigger = "The Scourge will wash over this world as a swarm of death and destruction!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

-- XXX verify bone storm cooldown on 10man

function mod:OnBossEnable()
	self:Log("SPELL_SUMMON", "Impale", 69062, 72669, 72670)
	self:Log("SPELL_CAST_START", "ImpaleCD", 69057, 70826, 72088, 72089)
	self:Log("SPELL_CAST_START", "BonestormCast", 69076)
	self:Log("SPELL_AURA_APPLIED", "Bonestorm", 69076)
	self:Log("SPELL_AURA_APPLIED", "Coldflame", 69146, 70823, 70824, 70825)

	self:Death("Win", 36612)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Engage", L["engage_trigger"])
end

function mod:OnEngage()
	difficulty = GetRaidDifficulty()
	self:Bar(69076, L["bonestorm_cd"], 45, 69076)
	self:DelayedMessage(69076, 40, L["bonestorm_warning"], "Attention")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local scheduled = nil
	local _, achievName = GetAchievementInfo(4534)
	--Remove the (25/10 player) text from name
	achievName = (achievName):gsub("%(.*%)", "")
	local function impaleWarn(spellName)
		mod:TargetMessage(69057, spellName, impaleTargets, "Urgent", 69062, "Alert")
		scheduled = nil
	end
	function mod:Impale(_, spellId, player, _, spellName)
		impaleTargets[#impaleTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(impaleWarn, 0.3, spellName)
			self:Bar(69057, achievName, 8, "achievement_boss_lordmarrowgar")
		end
	end
end

function mod:ImpaleCD(_, spellId, _, _, spellName)
	self:Bar(69057, L["impale_cd"], 18, spellId)
end

function mod:Coldflame(player, spellId)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(69146, L["coldflame_message"], "Personal", spellId, "Alarm")
		self:FlashShake(69146)
	end
end

local function afterTheStorm()
	if difficulty > 2 then
		mod:Bar(69076, L["bonestorm_cd"], 35, 69076)
		mod:DelayedMessage(69076, 30, L["bonestorm_warning"], "Attention")
	else
		mod:Bar(69076, L["bonestorm_cd"], 70, 69076)
		mod:DelayedMessage(69076, 65, L["bonestorm_warning"], "Attention")
	end
	mod:Bar(69057, L["impale_cd"], 18, 69057)
end

function mod:Bonestorm(_, spellId, _, _, spellName)
	self:Bar(69076, spellName, 20, spellId)
	self:ScheduleTimer(afterTheStorm, 20)
	if difficulty < 3 then
		self:SendMessage("BigWigs_StopBar", self, L["impale_cd"])
	end
end

function mod:BonestormCast(_, spellId, _, _, spellName)
	self:Message(69076, spellName, "Attention", spellId)
end

