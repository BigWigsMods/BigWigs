--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Lord Marrowgar", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36612)
mod.toggleOptions = {69076, 69057, {69138, "FLASHSHAKE"}, "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local impaleTargets = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.impale_cd = "~Next Impale"

	L.bonestorm_cd = "~Next Bone Storm"
	L.bonestorm_warning = "Bone Storm in 5 sec!"

	L.coldflame_message = "Coldflame on YOU!"

	L.engage_trigger = "The Scourge will wash over this world as a swarm of death and destruction!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_SUMMON", "Impale", 69062, 72669, 72670) --25, ??, ??
	self:Log("SPELL_CAST_START", "BonestormCast", 69076)
	self:Log("SPELL_AURA_APPLIED", "Bonestorm", 69076)
	self:Log("SPELL_AURA_APPLIED", "Coldflame", 70823, 69146, 70824, 70825) --25, ??, ??, ??
	self:Death("Win", 36612)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Engage", L["engage_trigger"])
end

function mod:OnEngage()
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
			self:Bar(69057, L["impale_cd"], 15, 69057)
		end
	end
end

function mod:Coldflame(player, spellId)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(69138, L["coldflame_message"], "Personal", spellId, "Alarm")
		self:FlashShake(69138)
	end
end

local function afterTheStorm()
	if mod:GetInstanceDifficulty() > 2 then
		mod:Bar(69076, L["bonestorm_cd"], 55, 69076)
		mod:DelayedMessage(69076, 50, L["bonestorm_warning"], "Attention")
	else
		mod:Bar(69076, L["bonestorm_cd"], 40, 69076)
		mod:DelayedMessage(69076, 65, L["bonestorm_warning"], "Attention")
		mod:Bar(69057, L["impale_cd"], 18, 69057)
	end
end

function mod:Bonestorm(_, spellId, _, _, spellName)
	local time = 20
	if self:GetInstanceDifficulty() > 2 then
		time = 34
	else
		self:SendMessage("BigWigs_StopBar", self, L["impale_cd"])
	end
	self:Bar(69076, spellName, time, spellId)
	self:ScheduleTimer(afterTheStorm, time)
end

function mod:BonestormCast(_, spellId, _, _, spellName)
	self:Message(69076, spellName, "Attention", spellId)
end

