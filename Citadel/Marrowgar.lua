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

function mod:OnBossEnable()
	self:Log("SPELL_SUMMON", "Impale", 69062, 72669, 72670)
	self:Log("SPELL_CAST_START", "ImpaleCD", 69057, 70826)
	self:Log("SPELL_AURA_APPLIED", "Bonestorm", 69076)
	self:Log("SPELL_AURA_APPLIED", "Coldflame", 69146, 70823, 70824, 70825)

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
	local function impaleWarn(spellName)
		mod:TargetMessage(69057, spellName, impaleTargets, "Urgent", 69062)
		scheduled = nil
	end
	function mod:Impale(_, spellId, player, _, spellName)
		impaleTargets[#impaleTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(impaleWarn, 0.3, spellName)
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

function mod:Bonestorm(_, spellId, _, _, spellName)
	self:Bar(69076, spellName, 20, spellId)
	self:Bar(69076, L["bonestorm_cd"], 90, spellId)
	self:DelayedMessage(69076, 85, L["bonestorm_warning"], "Attention")
	self:SendMessage("BigWigs_StopBar", self, L["impale_cd"])
end

