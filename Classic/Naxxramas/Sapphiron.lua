--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Sapphiron", 533)
if not mod then return end
mod:RegisterEnableMob(15989)
mod:SetAllowWin(true)
mod:SetEncounterID(1119)

--------------------------------------------------------------------------------
-- Locals
--

local airTimer
local targetCheck = nil
local blockCount = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Sapphiron"

	L.deepbreath_trigger = "%s takes in a deep breath..."

	L.air_phase = "Air phase"
	L.ground_phase = "Ground phase"

	L.deepbreath = "Ice Bomb"
	L.deepbreath_icon = 3129 -- Frost Breath
	L.deepbreath_warning = "Ice Bomb Incoming!"
	L.deepbreath_bar = "Ice Bomb Lands!"

	L.icebolt_say = "I'm a Block!"

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		28542, -- Life Drain
		"deepbreath", -- Ice Bomb (Frost Breath)
		{28522, "SAY"}, -- Ice Bolt
		"stages",
		"berserk",
	}

end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "LifeDrain", 28542)
	self:Log("SPELL_AURA_APPLIED", "Icebolt", 28522)
	self:Log("SPELL_CAST_START", "DeepBreath", 28524)
	-- self:Emote("DeepBreath", L.deepbreath_trigger)
	self:Log("SPELL_CAST_SUCCESS", "IceBomb", 28524)

	self:Death("Win", 15989)
end

function mod:OnEngage()
	blockCount = 0
	targetCheck = nil
	self:Berserk(900)
	self:CDBar(28542, 10) -- Drain Life
	self:CDBar("stages", 32, L.air_phase, 3129)
	self:SimpleTimer(function()
		airTimer = self:ScheduleRepeatingTimer("CheckAirPhase", 0.5)
	end, 20)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:LifeDrain(args)
	self:Message(28542, "yellow")
	self:CDBar(28542, 23)
	if self:Dispeller("curse") then
		self:PlaySound(28542, "alert")
	end
end

function mod:CheckAirPhase()
	-- No air phase emote in Classic, but Sapphiron drops his target
	-- Find someone targeting him to get a unit token
	local boss = self:GetBossId(15989)
	if not boss then
		-- No one is targeting the boss? Just reset and bail
		targetCheck = nil
		return
	end

	if UnitExists(boss.."target") then
		-- Boss still has a target, reset
		targetCheck = nil
	elseif targetCheck then
		-- Boss has had no target for two iterations, fire the air phase trigger
		-- (The original module had a 1s delay between scans, not sure if that matters)
		self:CancelTimer(airTimer)
		targetCheck = nil
		self:AirPhase()
	else
		-- Boss has no target, check one more time to make sure
		targetCheck = true
	end
end

function mod:AirPhase()
	self:StopBar(28542)
	self:StopBar(L.air_phase)

	self:Message("stages", "cyan", L.air_phase, L.deepbreath_icon)
	self:PlaySound("stages", "info")
	self:Bar("deepbreath", 28.5, L.deepbreath_bar, L.deepbreath_icon) -- 28~33, updated on cast
end

function mod:DeepBreath(args)
	self:Message("deepbreath", "red", L.deepbreath_warning, L.deepbreath_icon)
	self:PlaySound("deepbreath", "alarm")
	self:Bar("deepbreath", 7, L.deepbreath_bar, L.deepbreath_icon)

	self:CDBar("stages", 13, L.ground_phase, 15847) -- 15847 = Tail Sweep
	self:CDBar(28542, 14.5) -- Drain Life
	self:ScheduleTimer("CDBar", 13, "stages", 66, L.air_phase, L.deepbreath_icon) -- 65~67
end

function mod:IceBomb(args)
	blockCount = 0
	self:SimpleTimer(function()
		airTimer = self:ScheduleRepeatingTimer("CheckAirPhase", 0.5)
	end, 50) -- ~74 until next
end

function mod:Icebolt(args)
	blockCount = blockCount + 1
	self:TargetMessage(28522, "yellow", args.destName, CL.count:format(args.spellName, blockCount))
	if self:Me(args.destGUID) then
		self:Say(28522, L.icebolt_say, true)
	end
end
