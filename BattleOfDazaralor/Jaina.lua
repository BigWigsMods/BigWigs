--------------------------------------------------------------------------------
-- TODO:
-- -- Stage 1:
-- -- Add timer
-- -- Avalance Say warnings/Countdown/Marked targets
-- -- Stage 2:
-- -- Warmth positive warning
-- -- Kegs killed/exploding timers?

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lady Jaina Proudmoore", 2070, 2343)
if not mod then return end
mod:RegisterEnableMob(146409) -- Lady Jaina Proudmoore
mod.engageId = 2281
--mod.respawnTime = 31

--------------------------------------------------------------------------------
-- Locals
--

local ringofIceCount = 1
local icefallCount = 1
local stage = 1
local nextStageWarning = 63
local chillingTouchList = {}
local broadsideCount = 0
local orbofFrostCount = 1
local crystallineDustCount = 1

--------------------------------------------------------------------------------
-- Localization
--

--local L = mod:GetLocale()
--if L then
--
--end

--------------------------------------------------------------------------------
-- Initialization
--

local broadsideMarker = mod:AddMarkerOption(false, "player", 1, 288212, 1, 2, 3) -- Broadside
function mod:GetOptions()
	return {
		-- General
		"stages",
		{285215, "INFOBOX"}, -- Chilling Touch
		287490, -- Frozen Solid
		-- Stage 1
		{288038, "FLASH"}, -- Marked Target
		285725, -- Set Charge
		285828, -- Bombard
		287365, -- Searing Pitch
		{285253, "TANK"}, -- Ice Shard
		287565, -- Avalanche
		287925, -- Time Warp
		287626, -- Grasp of Frost
		285177, -- Freezing Blast
		285459, -- Ring of Ice
		-- Stage 2
		288297, -- Arctic Ground
		{288212, "SAY", "SAY_COUNTDOWN"}, -- Broadside
		broadsideMarker,
		{288374, "ICON", "SAY", "SAY_COUNTDOWN"}, -- Siegebreaker Blast
		288345, -- Glacial Ray
		288441, -- Icefall
		-- Intermission
		289220, -- Heart of Frost
		289219, -- Frost Nova
		290084, -- Water Bolt Volley
		-- Stage 3
		289940, -- Crystalline Dust
		288619, -- Orb of Frost
		288747, -- Prismatic Image
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	-- General
	self:Log("SPELL_AURA_APPLIED", "ChillingTouch", 285215)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ChillingTouch", 285215)
	self:Log("SPELL_AURA_REMOVED", "ChillingTouch", 285215)
	self:Log("SPELL_AURA_APPLIED", "FrozenSolid", 287490)

	-- Stage 1
	self:Log("SPELL_AURA_APPLIED", "MarkedTargetApplied", 288038) -- XXX Fixate icon nameplates
	self:Log("SPELL_CAST_SUCCESS", "SetCharge", 285725)
	self:Log("SPELL_CAST_SUCCESS", "Bombard", 285828)
	self:Log("SPELL_AURA_APPLIED", "IceShard", 285253)
	self:Log("SPELL_AURA_APPLIED_DOSE", "IceShard", 285253)
	self:Log("SPELL_CAST_START", "Avalanche", 287565)
	self:Log("SPELL_CAST_SUCCESS", "TimeWarp", 287925)
	self:Log("SPELL_AURA_APPLIED", "GraspofFrost", 287626)
	self:Log("SPELL_CAST_START", "FreezingBlast", 285177)
	self:Log("SPELL_CAST_START", "RingofIce", 285459)

	-- Intermission
	self:Log("SPELL_AURA_REMOVED", "HowlingWindsRemoved", 288199)

	-- Stage 2
	self:Log("SPELL_CAST_SUCCESS", "BroadsideSucces", 288211)
	self:Log("SPELL_AURA_APPLIED", "BroadsideApplied", 288212)
	self:Log("SPELL_AURA_REMOVED", "BroadsideRemoved", 288212)
	self:Log("SPELL_CAST_SUCCESS", "SiegebreakerBlastSucces", 288374)
	self:Log("SPELL_AURA_APPLIED", "SiegebreakerBlastApplied", 288374)
	self:Log("SPELL_AURA_REMOVED", "SiegebreakerBlastRemoved", 288374)
	self:Log("SPELL_CAST_START", "GlacialRay", 288345)
	self:Log("SPELL_CAST_START", "Icefall", 288441)

	-- Intermission
	self:Log("SPELL_CAST_START", "FlashFreeze", 288719)
	self:Log("SPELL_CAST_SUCCESS", "ArcaneBarrage", 290001)
	self:Log("SPELL_AURA_REMOVED", "ArcaneBarrageRemoved", 290001)
	self:Log("SPELL_AURA_APPLIED", "HeartofFrost", 289220)
	self:Log("SPELL_CAST_START", "FrostNova", 289219)
	self:Log("SPELL_CAST_START", "WaterBoltVolley", 290084)

	-- Stage 3
	self:Log("SPELL_CAST_START", "CrystallineDust", 289940)
	self:Log("SPELL_CAST_START", "OrbofFrost", 288619)
	self:Log("SPELL_CAST_START", "PrismaticImage", 288747)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 287365, 288297) -- Searing Pitch,  Arctic Ground
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 287365, 288297)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 287365, 288297)
end

function mod:OnEngage()
	ringofIceCount = 1
	icefallCount = 1
	stage = 1
	nextStageWarning = 63
	chillingTouchList = {}
	broadsideCount = 0
	orbofFrostCount = 1
	crystallineDustCount = 1

	self:OpenInfo(285215, self:SpellName(285215)) -- Chilling Touch

	self:CDBar(287565, 8) -- Avalanche
	self:CDBar(285177, 17) -- Freezing Blast
	self:CDBar(285459, 60, CL.count:format(self:SpellName(285459), ringofIceCount)) -- Ring of Ice

	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH_FREQUENT(event, unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < nextStageWarning then -- Intermission at 60% & 30%
		self:Message2("stages", "green", CL.soon:format(CL.intermission), false)
		nextStageWarning = nextStageWarning - 30
		if nextStageWarning < 30 then
			self:UnregisterUnitEvent(event, unit)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellId)
	if spellId == 287282 then -- Arctic Armor // Intermission 1 Start
		self:PlaySound("stages", "long")
		self:Message2("stages", "green", CL.intermission, false)

		self:StopBar(287565) -- Avalanche
		self:StopBar(285177) -- Freezing Blast
		self:StopBar(CL.count:format(self:SpellName(285459), ringofIceCount)) -- Ring of Ice
	end
end

function mod:ChillingTouch(args)
	if self:Me(args.destGUID) then -- Check if we have to warn for high stacks in Mythic
		local amount = args.amount or 1
		if amount >= 18 or amount % 5 == 0 then
			self:StackMessage(args.spellId, args.destName, amount, "blue")
			self:PlaySound(args.spellId, "alarm")
		end
	end
	chillingTouchList[args.destName] = args.amount or 1
	self:SetInfoByTable(args.spellId, chillingTouchList)
end

do
	local playerList = mod:NewTargetList()
	function mod:FrozenSolid(args)
		playerList[#playerList+1] = args.destName
		self:PlaySound(args.spellId, "warning", nil, playerList)
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end
end

-- Stage 1
function mod:MarkedTargetApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
		self:Flash(args.spellId)
	end
end

function mod:SetCharge(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:Bombard(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

function mod:IceShard(args)
	local amount = args.amount or 1
	if amount % 3 == 1 then
		self:StackMessage(args.spellId, args.destName, args.amount, "purple")
		self:PlaySound(args.spellId, amount > 20 and "alarm" or "alert", nil, args.destName)
	end
end

function mod:Avalanche(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, stage > 1 and 75 or 60)
end

function mod:TimeWarp(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

do
	local playerList = mod:NewTargetList()
	function mod:GraspofFrost(args)
		playerList[#playerList+1] = args.destName
		self:PlaySound(args.spellId, "alert", nil, playerList)
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end
end

function mod:FreezingBlast(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, 10)
end

function mod:RingofIce(args)
	self:Message2(args.spellId, "orange", CL.count:format(args.spellName, ringofIceCount))
	self:PlaySound(args.spellId, "long")
	ringofIceCount = ringofIceCount + 1
	self:CDBar(args.spellId, 60, CL.count:format(args.spellName, ringofIceCount))
end

-- Intermission
function mod:HowlingWindsRemoved(args)
	stage = 2
	icefallCount = 1
	self:PlaySound("stages", "long")
	self:Message2("stages", "cyan", CL.stage:format(stage), false)

	self:CDBar(288212, 3) -- Broadside
	self:CDBar(288345, 7) -- Glacial Ray
	self:CDBar(287565, 17) -- Avalanche
	self:CDBar(288441, 31, CL.count:format(self:SpellName(288441), icefallCount)) -- Icefall
	self:CDBar(288374, 42) -- Siegebreaker Blast
end

-- Stage 2
function mod:BroadsideSucces(args)
	broadsideCount = 0
	self:CDBar(288212, 32) -- Broadside
end

do
	local playerList = mod:NewTargetList()
	function mod:BroadsideApplied(args)
		broadsideCount = broadsideCount + 1
		playerList[#playerList+1] = args.destName
		self:TargetsMessage(args.spellId, "yellow", playerList, 3)
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.count_rticon:format(args.spellName, broadsideCount, broadsideCount))
			self:SayCountdown(args.spellId, 6)
			self:PlaySound(args.spellId, "warning")
		end
		if self:GetOption(broadsideMarker) then
			SetRaidTarget(args.destName, broadsideCount)
		end
	end
end

function mod:BroadsideRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	if self:GetOption(broadsideMarker) then
		SetRaidTarget(args.destName, 0)
	end
end

function mod:SiegebreakerBlastSucces(args)
	self:Bar(args.spellId, 61)
end

function mod:SiegebreakerBlastApplied(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	self:PlaySound(args.spellId, "alert")
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetBar(args.spellId, 8, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 8)
	end
end

function mod:SiegebreakerBlastRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	self:PrimaryIcon(args.spellId, args.destName)
	self:StopBar(args.spellId, args.destName)
end

function mod:GlacialRay(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, stage == 3 and 60 or 51.1)
end

function mod:Icefall(args)
	if self:MobId(args.sourceGUID) == 146409 then -- Jaina
		self:Message2(args.spellId, "orange", CL.count:format(args.spellName, icefallCount))
		self:PlaySound(args.spellId, "long")
		icefallCount = icefallCount + 1
		self:CDBar(args.spellId, stage == 3 and 62 or 42, CL.count:format(args.spellName, icefallCount))
	else -- Prismatic Image
		self:Message2(args.spellId, "orange")
		self:PlaySound(args.spellId, "long")
	end
end

-- Intermission: Flash Freeze
function mod:FlashFreeze(args)
	self:PlaySound("stages", "long")
	self:Message2("stages", "green", CL.intermission, false)
	self:StopBar(288212) -- Broadside
	self:StopBar(288345) -- Glacial Ray
	self:StopBar(287565) -- Avalanche
	self:StopBar(CL.count:format(self:SpellName(288441), icefallCount)) -- Icefall
	self:StopBar(288374) -- Siegebreaker Blast
end

function mod:ArcaneBarrage(args)
	self:PlaySound("stages", "long")
	self:Message2("stages", "cyan", CL.interrupted:format(self:SpellName(288719)), false) -- Flash Freeze Interrupted
end

function mod:ArcaneBarrageRemoved(args)
	stage = 3
	orbofFrostCount = 1
	icefallCount = 1
	crystallineDustCount = 1
	self:PlaySound("stages", "long")
	self:Message2("stages", "cyan", CL.stage:format(stage), false)

	self:CDBar(288619, 11.5, CL.count:format(self:SpellName(288619), orbofFrostCount)) -- Orb of Frost
	self:CDBar(288212, 20) -- Broadside
	self:CDBar(288747, 23) -- Prismatic Image
	self:CDBar(289940, 26.5) -- Crystalline Dust
	self:CDBar(288345, 49.5) -- Glacial Ray
	self:CDBar(288374, 60.5) -- Siegebreaker Blast
	self:CDBar(288441, 61.5, CL.count:format(self:SpellName(288441), icefallCount)) -- Icefall
end

do
	local playerList = mod:NewTargetList()
	function mod:HeartofFrost(args)
		playerList[#playerList+1] = args.destName
		self:PlaySound(args.spellId, "alert", nil, playerList)
		self:TargetsMessage(args.spellId, "yellow", playerList)
		self:CDBar(args.spellId, 8)
	end
end

function mod:FrostNova(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

function mod:WaterBoltVolley(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 8)
end

-- Stage 3
function mod:CrystallineDust(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	crystallineDustCount = crystallineDustCount + 1
	self:CDBar(args.spellId, crystallineDustCount % 3 == 0 and 21.5 or 15.5)
end

function mod:OrbofFrost(args)
	self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, orbofFrostCount))
	self:PlaySound(args.spellId, "alert")
	orbofFrostCount = orbofFrostCount + 1
	self:Bar(args.spellId, 60, CL.count:format(args.spellName, orbofFrostCount))
end

function mod:PrismaticImage(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
	self:CDBar(args.spellId, 51)
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
