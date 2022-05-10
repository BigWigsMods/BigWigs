--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("M'uru", 580, 1595)
if not mod then return end
mod:RegisterEnableMob(25741, 25840) -- M'uru, Entropius
mod:SetAllowWin(true)
mod:SetEncounterID(728) -- No boss frame for M'uru, just Entropius
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local sentinelCount = 1
local humanoidCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.sentinel = "Void Sentinel"
	L.sentinel_desc = "Warn when the Void Sentinel spawns."
	L.sentinel_icon = "spell_shadow_summonvoidwalker"
	L.sentinel_next = "Sentinel (%d)"

	L.humanoid = "Humanoid Adds"
	L.humanoid_desc = "Warn when the Humanoid Adds spawn."
	L.humanoid_icon = "spell_holy_prayerofhealing"
	L.humanoid_next = "Humanoids (%d)"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		"berserk",
		45996, -- Darkness
		45934, -- Dark Fiend
		"sentinel",
		"humanoid",
		46282, -- Black Hole
	},{
		[45996] = CL.stage:format(1),
		[46282] = CL.stage:format(2),
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	-- Stage 1
	self:Log("SPELL_AURA_APPLIED", "Darkness", 45996)
	self:Log("SPELL_CAST_SUCCESS", "DarkFiend", 45934)

	-- Stage 2
	self:Log("SPELL_CAST_SUCCESS", "OpenAllPortals", 46177)
	self:Log("SPELL_CAST_SUCCESS", "BlackHole", 46282)

	self:Death("Win", 25840)
end

function mod:OnEngage()
	sentinelCount = 1
	humanoidCount = 1
	self:SetStage(1)

	self:Bar(45996, 45) -- Darkness
	self:Berserk(600)

	self:ScheduleTimer("RepeatSentinel", 30)
	self:CDBar("sentinel", 30, L.sentinel_next:format(sentinelCount), L.sentinel_icon)
	self:DelayedMessage("sentinel", 25, "yellow", CL.soon:format(L.sentinel_next:format(sentinelCount)), L.sentinel_icon)

	self:ScheduleTimer("RepeatHumanoid", 10)
	self:CDBar("humanoid", 10, L.humanoid_next:format(sentinelCount), L.humanoid_icon)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Darkness(args)
	if self:MobId(args.destGUID) == 25741 then -- M'uru
		self:Message(args.spellId, "orange", CL.casting:format(args.spellName))
		self:PlaySound(args.spellId, "long")
		self:CastBar(args.spellId, 20)
		self:Bar(args.spellId, 45)
	end
end

do
	local prev = 0
	function mod:DarkFiend(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			self:Message(args.spellId, "red", CL.spawning:format(args.spellName))
		end
	end
end

function mod:RepeatSentinel()
	sentinelCount = sentinelCount + 1
	self:CDBar("sentinel", 30, L.sentinel_next:format(sentinelCount), L.sentinel_icon)
	self:DelayedMessage("sentinel", 25, "yellow", CL.soon:format(L.sentinel_next:format(sentinelCount)), L.sentinel_icon)
	self:ScheduleTimer("RepeatSentinel", 30)
end

function mod:RepeatHumanoid()
	humanoidCount = humanoidCount + 1
	self:CDBar("humanoid", 60, L.humanoid_next:format(humanoidCount), L.humanoid_icon)
	self:DelayedMessage("humanoid", 55, "orange", CL.soon:format(L.humanoid_next:format(humanoidCount)), L.humanoid_icon)
	self:ScheduleTimer("RepeatHumanoid", 60)
end

function mod:OpenAllPortals()
	self:StopBar(45996) -- Darkness
	self:StopBar(L.sentinel_next:format(sentinelCount)) -- Void Sentinel
	self:StopBar(L.humanoid_next:format(humanoidCount)) -- Humanoid Adds
	self:CancelAllTimers()

	self:SetStage(2)
	local text = CL.stage:format(2)
	self:Message("stages", "cyan", text, false)
	self:Bar("stages", 10, text, "spell_shadow_summonvoidwalker")
	self:Bar(46282, 27, 46282, "spell_nature_unrelentingstorm") -- Black Hole
end

function mod:BlackHole(args)
	self:Bar(args.spellId, 10, CL.spawning:format(args.spellName), "spell_nature_unrelentingstorm")
	self:Bar(args.spellId, 15, args.spellName, "spell_nature_unrelentingstorm")
	self:DelayedMessage(args.spellId, 5, "orange", CL.spawning:format(args.spellName), false)
end
