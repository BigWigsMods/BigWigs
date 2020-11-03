
--------------------------------------------------------------------------------
-- TODO:
-- -- Deadly Descent warnings?
-- -- Stack warnings for Bloodlight

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Shriekwing", 2296, 2393)
if not mod then return end
mod:RegisterEnableMob(164406) -- Shriekwing
mod.engageId = 2398
mod.respawnTime = 5

--------------------------------------------------------------------------------
-- Locals
--

local ExsanguinatStacksOnMe = nil
local shriekCount = 1
local echoCount = 1
local scentOfBloodCount = 1
local sonarShriekCount = 1
local blindSwipeCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.pickup_lantern = "%s picked up the lantern!" -- Blood Lantern
	L.dropped_lantern = "Lantern dropped by %s!"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		-- Stage One - Thirst for Blood
		330711, -- Earsplitting Shriek
		340324, -- Sanguine Ichor
		{342074, "SAY", "SAY_COUNTDOWN"}, -- Echolocation
		342863, -- Echoing Screech
		{328857, "TANK"}, -- Exsanguinating Bite
		328897, -- Exsanguinated
		343005, -- Blind Swipe
		-- Stage Two - Terror of Castle Nathria
		328921, -- Bloodgorge
		329362, -- Dark Sonar
		340047, -- Sonar Shriek
		341684, -- The Blood Lantern
		341489, -- Bloodlight
	}, {
		["stages"] = "general",
		[328897] = -22101, -- Stage One - Thirst for Blood
		[328921] = -22102, -- Stage Two - Terror of Castle Nathria
		[341684] = "mythic", -- Mythic
	}
end

function mod:OnBossEnable()
	-- Stage One - Thirst for Blood
	self:Log("SPELL_AURA_APPLIED", "ExsanguinatedApplied", 328897)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ExsanguinatedApplied", 328897)
	self:Log("SPELL_AURA_REMOVED", "ExsanguinatedRemoved", 328897)
	self:Log("SPELL_CAST_START", "ExsanguinatingBite", 328857)
	self:Log("SPELL_CAST_START", "EarsplittingShriek", 330711)
	self:Log("SPELL_AURA_APPLIED", "EcholocationApplied", 342077)
	self:Log("SPELL_AURA_REMOVED", "EcholocationRemoved", 342077)
	self:Log("SPELL_CAST_START", "EchoingScreech", 342863)
	self:Log("SPELL_CAST_START", "BlindSwipe", 343005)

	-- Stage Two - Terror of Castle Nathria
	self:Log("SPELL_CAST_START", "Bloodgorge", 328921)
	self:Log("SPELL_CAST_SUCCESS", "DarkSonar", 329362)
	self:Log("SPELL_CAST_START", "SonarShriek", 340047)
	self:Log("SPELL_AURA_REMOVED", "BloodgorgeRemoved", 328921)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "TheBloodLanternApplied", 341684)
	self:Log("SPELL_AURA_REMOVED", "TheBloodLanternRemoved", 341684)
	self:Log("SPELL_AURA_APPLIED", "BloodlightApplied", 341489)
	self:Log("SPELL_AURA_REMOVED", "BloodlightRemoved", 341489)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 340324) -- Sanguine Ichor
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 340324)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 340324)
end

function mod:OnEngage()
	shriekCount = 1
	echoCount = 1
	scentOfBloodCount = 1
	sonarShriekCount = 1
	blindSwipeCount = 1

	self:CDBar(328857, 8) -- Exsanguinating Bite
	self:CDBar(330711, 13, CL.count:format(self:SpellName(330711), shriekCount)) -- Earsplitting Shriek
	self:CDBar(342074, 19.5, CL.count:format(self:SpellName(342074), scentOfBloodCount)) -- Echolocation
	self:CDBar(343005, 20.5,  CL.count:format(self:SpellName(343005), blindSwipeCount)) -- Blind Swipe
	self:CDBar(342863, 29.5, CL.count:format(self:SpellName(342863), echoCount)) -- Echoing Screech
	self:CDBar(328921, 101) -- Bloodgorge
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ExsanguinatedApplied(args)
	if self:Me(args.destGUID) then
		ExsanguinatStacksOnMe = true
		local amount = args.amount or 1
		if amount % 2 == 0 then
			self:StackMessage(args.spellId, args.destName, amount, "blue")
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:ExsanguinatedRemoved(args)
	if self:Me(args.destGUID) then
		self:Message2(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
		ExsanguinatStacksOnMe = nil
	end
end

function mod:ExsanguinatingBite(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "info")
	self:CDBar(args.spellId, 17)
end

function mod:EarsplittingShriek(args)
	self:Message2(args.spellId, "red", CL.count:format(args.spellName, shriekCount))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 4, CL.count:format(args.spellName, shriekCount))
	shriekCount = shriekCount + 1
	if shriekCount < 4 then -- Only 3 each stage 1
		self:Bar(args.spellId, 34.2, CL.count:format(args.spellName, shriekCount))
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:EcholocationApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(342074)
			self:SayCountdown(342074, 8)
			self:PlaySound(342074, "warning")
		end
		if #playerList == 1 then
			scentOfBloodCount = scentOfBloodCount + 1
			if scentOfBloodCount < 3 then -- Only 2 each stage 1
				self:Bar(342074, 42.5, CL.count:format(self:SpellName(342074), scentOfBloodCount))
			end
		end
		self:TargetsMessage(342074, "yellow", playerList, nil, CL.count:format(self:SpellName(342074), scentOfBloodCount-1))
	end
end

function mod:EcholocationRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(342074)
	end
end

function mod:EchoingScreech(args)
	self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, echoCount))
	self:PlaySound(args.spellId, "alert")
	echoCount = echoCount + 1
	if echoCount < 3 then -- Only 2 each stage 1
		self:CDBar(args.spellId, 42.5, CL.count:format(args.spellName, echoCount))
	end
end

function mod:BlindSwipe(args)
	self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, blindSwipeCount))
	self:PlaySound(args.spellId, "alert")
	blindSwipeCount = blindSwipeCount + 1
	if blindSwipeCount < 3 then -- Only 2 each stage 1
		self:CDBar(args.spellId, 42.5, CL.count:format(args.spellName, blindSwipeCount))
	end
end

-- Stage Two - Terror of Castle Nathria
function mod:Bloodgorge(args)
	self:Message2(args.spellId, "green")
	self:PlaySound(args.spellId, "long")

	self:StopBar(328857) -- Exsanguinating Bite
	self:StopBar(CL.count:format(self:SpellName(343005), blindSwipeCount)) -- Blind Swipe
	self:StopBar(CL.count:format(self:SpellName(342074), scentOfBloodCount)) -- Echolocation
	self:StopBar(CL.count:format(self:SpellName(330711), shriekCount)) -- Earsplitting Shriek
	self:StopBar(CL.count:format(self:SpellName(342863), echoCount)) -- Echoing Screech

	sonarShriekCount = 1

	self:CDBar("stages", 45, CL.intermission, args.spellId) -- 5s Cast, 40s Intermission/Stage 2
	self:CDBar(329362, 7.3) -- Dark Sonar
	self:CDBar(340047, 18.3, CL.count:format(self:SpellName(340047), sonarShriekCount)) -- Sonar Shriek
end

function mod:DarkSonar(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:SonarShriek(args)
	self:Message2(args.spellId, "orange", CL.count:format(args.spellName, sonarShriekCount))
	self:PlaySound(args.spellId, "warning")
	sonarShriekCount = sonarShriekCount + 1
	if sonarShriekCount > 4 then -- cast 3 times in intermission
		self:CDBar(args.spellId, 9.7, CL.count:format(args.spellName, sonarShriekCount))
	end
end

function mod:BloodgorgeRemoved(args)
	self:Message2("stages", "green", CL.stage:format(1), false)
	self:PlaySound("stages", "info")

	self:StopBar(CL.count:format(self:SpellName(340047), sonarShriekCount)) -- Earsplitting Shriek

	shriekCount = 1
	echoCount = 1
	scentOfBloodCount = 1
	blindSwipeCount = 1

	self:CDBar(328857, 8.5) -- Exsanguinating Bite
	self:CDBar(330711, 12.2, CL.count:format(self:SpellName(330711), shriekCount)) -- Earsplitting Shriek
	self:CDBar(342074, 18.4, CL.count:format(self:SpellName(342074), scentOfBloodCount)) -- Echolocation
	self:CDBar(343005, 19.5, CL.count:format(self:SpellName(343005), blindSwipeCount)) -- Blind Swipe
	self:CDBar(342863, 28.5, CL.count:format(self:SpellName(342863), echoCount)) -- Echoing Screech
	self:CDBar(328921, 101) -- Bloodgorge
end

-- Mythic
function mod:TheBloodLanternApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
	else
		self:Message2(args.spellId, "green", L.pickup_lantern:format(args.destName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:TheBloodLanternRemoved(args)
	self:Message2(args.spellId, "red", L.dropped_lantern:format(args.destName))
	self:PlaySound(args.spellId, "info")
end

function mod:BloodlightApplied(args)
	if self:Me(args.destGUID) then
		self:Message2(args.spellId, "green", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:BloodlightRemoved(args)
	if self:Me(args.destGUID) then
		self:Message2(args.spellId, "cyan", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and not ExsanguinatStacksOnMe then -- It's good to stand on blood when you have stacks, bad if you lost them all
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
