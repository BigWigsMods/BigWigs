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

local shriekCount = 1
local echoingScreechCount = 1
local echolocationCount = 1
local blindSwipeCount = 1
local waveofBloodCount = 1

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
		345397, -- Wave of Blood
		343005, -- Blind Swipe
		{328857, "TANK"}, -- Exsanguinating Bite
		{328897, "TANK"}, -- Exsanguinated
		-- Stage Two - Terror of Castle Nathria
		345936, -- Earsplitting Shriek (Intermission)
		328921, -- Blood Shroud
		329362, -- Echoing Sonar
		-- Mythic
		341684, -- The Blood Lantern
		341489, -- Bloodlight
	}, {
		["stages"] = "general",
		[330711] = -22101, -- Stage One - Thirst for Blood
		[345936] = -22102, -- Stage Two - Terror of Castle Nathria
		[341684] = "mythic", -- Mythic
	}
end

function mod:OnBossEnable()
	-- Stage One - Thirst for Blood
	self:Log("SPELL_CAST_START", "EarsplittingShriek", 330711, 345936) -- Stage 1, Stage 2
	self:Log("SPELL_AURA_APPLIED", "EcholocationApplied", 342077)
	self:Log("SPELL_AURA_REMOVED", "EcholocationRemoved", 342077)
	self:Log("SPELL_CAST_START", "EchoingScreech", 342863)
	self:Log("SPELL_CAST_START", "WaveofBlood", 345397)
	self:Log("SPELL_CAST_START", "BlindSwipe", 343005)
	self:Log("SPELL_CAST_START", "ExsanguinatingBite", 328857)
	self:Log("SPELL_AURA_APPLIED", "ExsanguinatedApplied", 328897)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ExsanguinatedApplied", 328897)
	self:Log("SPELL_AURA_REMOVED", "ExsanguinatedRemoved", 328897)

	-- Stage Two - Terror of Castle Nathria
	self:Log("SPELL_CAST_START", "EarsplittingShriekIntermission", 345936)
	self:Log("SPELL_CAST_SUCCESS", "BloodShroud", 328921)
	self:Log("SPELL_CAST_SUCCESS", "EchoingSonar", 329362)
	self:Log("SPELL_AURA_REMOVED", "BloodShroudRemoved", 328921)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "TheBloodLanternApplied", 341684)
	self:Log("SPELL_AURA_REMOVED", "TheBloodLanternRemoved", 341684)
	self:Log("SPELL_AURA_APPLIED", "BloodlightApplied", 341489)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BloodlightApplied", 341489)
	self:Log("SPELL_AURA_REMOVED", "BloodlightRemoved", 341489)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 340324) -- Sanguine Ichor
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 340324)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 340324)
end

function mod:OnEngage()
	shriekCount = 1
	echoingScreechCount = 1
	echolocationCount = 1
	blindSwipeCount = 1
	waveofBloodCount = 1

	self:CDBar(328857, 8) -- Exsanguinating Bite
	self:CDBar(345397, 13, CL.count:format(self:SpellName(345397), waveofBloodCount)) -- Wave of Blood
	self:CDBar(342074, 14.5, CL.count:format(self:SpellName(342074), echolocationCount)) -- Echolocation
	self:CDBar(343005, 20.5,  CL.count:format(self:SpellName(343005), blindSwipeCount)) -- Blind Swipe
	self:CDBar(342863, 28.5, CL.count:format(self:SpellName(342863), echoingScreechCount)) -- Echoing Screech
	self:CDBar(330711, 48.5, CL.count:format(self:SpellName(330711), shriekCount)) -- Earsplitting Shriek
	self:CDBar(328921, 105) -- Blood Shroud
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:EarsplittingShriek(args)
	self:Message(330711, "red", CL.count:format(args.spellName, shriekCount))
	self:PlaySound(330711, "long")
	shriekCount = shriekCount + 1
	if shriekCount < 3 then -- 2 in stage 1
		self:CastBar(330711, 6, CL.count:format(args.spellName, shriekCount))
		self:Bar(330711, 47, CL.count:format(args.spellName, shriekCount))
	else
		self:CastBar(330711, 4, CL.count:format(args.spellName, shriekCount))
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
			echolocationCount = echolocationCount + 1
			if echolocationCount < 5 then -- 4 in stage 1
				self:Bar(342074, 23, CL.count:format(self:SpellName(342074), echolocationCount))
			end
		end
		self:TargetsMessage(342074, "yellow", playerList, nil, CL.count:format(self:SpellName(342074), echolocationCount-1), nil, 2)
	end
end

function mod:EcholocationRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(342074)
	end
end

function mod:EchoingScreech(args)
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, echoingScreechCount))
	self:PlaySound(args.spellId, "alert")
	echoingScreechCount = echoingScreechCount + 1
	if echoingScreechCount < 3 then -- 2 in stage 1
		self:CDBar(args.spellId, 48.5, CL.count:format(args.spellName, echoingScreechCount))
	end
end

function mod:WaveofBlood(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, waveofBloodCount))
	self:PlaySound(args.spellId, "alarm")
	waveofBloodCount = waveofBloodCount + 1
	if waveofBloodCount < 5 then -- 4 in stage 1
		self:Bar(args.spellId, 25, CL.count:format(args.spellName, waveofBloodCount))
	end
end

function mod:BlindSwipe(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, blindSwipeCount))
	self:PlaySound(args.spellId, "alert")
	blindSwipeCount = blindSwipeCount + 1
	if blindSwipeCount < 3 then -- 2 in stage 1
		self:CDBar(args.spellId, 45, CL.count:format(args.spellName, blindSwipeCount))
	end
end

function mod:ExsanguinatingBite(args)
	self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "info")
	self:CDBar(args.spellId, 17)
end

function mod:ExsanguinatedApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 0 then
			self:StackMessage(args.spellId, args.destName, amount, "blue")
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:ExsanguinatedRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

-- Stage Two - Terror of Castle Nathria
function mod:BloodShroud(args)
	self:Message(args.spellId, "green")
	self:PlaySound(args.spellId, "long")

	self:StopBar(328857) -- Exsanguinating Bite
	self:StopBar(CL.count:format(self:SpellName(343005), blindSwipeCount)) -- Blind Swipe
	self:StopBar(CL.count:format(self:SpellName(342074), echolocationCount)) -- Echolocation
	self:StopBar(CL.count:format(self:SpellName(330711), shriekCount)) -- Earsplitting Shriek
	self:StopBar(CL.count:format(self:SpellName(342863), echoingScreechCount)) -- Echoing Screech
	self:StopBar(CL.count:format(self:SpellName(345397), waveofBloodCount)) -- Wave of Blood

	shriekCount = shriekCount + 1 -- Reused for intermission Shriek

	self:CDBar("stages", 39, CL.intermission, args.spellId) -- 5s Cast, 40s Intermission/Stage 2
	self:CDBar(329362, 7.3) -- Echoing Sonar
	self:CDBar(345936, 17, CL.count:format(self:SpellName(345936), shriekCount))
end

function mod:EarsplittingShriekIntermission(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, shriekCount))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 4, CL.count:format(args.spellName, shriekCount))
	shriekCount = shriekCount + 1
	if shriekCount < 4 then -- 3 in stage 2
		self:CDBar(args.spellId, 8.5, CL.count:format(args.spellName, shriekCount))
	end
end

function mod:EchoingSonar(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:BloodShroudRemoved(args)
	self:Message("stages", "green", CL.stage:format(1), false)
	self:PlaySound("stages", "info")

	shriekCount = 1
	echoingScreechCount = 1
	echolocationCount = 1
	blindSwipeCount = 1
	waveofBloodCount = 1

	self:CDBar(328857, 8.5) -- Exsanguinating Bite
	self:CDBar(342074, 15.5, CL.count:format(self:SpellName(342074), echolocationCount)) -- Echolocation
	self:CDBar(345397, 12.2, CL.count:format(self:SpellName(345397), waveofBloodCount)) -- Wave of Blood
	self:CDBar(343005, 20.5, CL.count:format(self:SpellName(343005), blindSwipeCount)) -- Blind Swipe
	self:CDBar(342863, 28.5, CL.count:format(self:SpellName(342863), echoingScreechCount)) -- Echoing Screech
	self:CDBar(330711, 48.5, CL.count:format(self:SpellName(330711), shriekCount)) -- Earsplitting Shriek
	self:CDBar(328921, 106) -- Blood Shroud
end

-- Mythic
function mod:TheBloodLanternApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
	else
		self:Message(args.spellId, "green", L.pickup_lantern:format(args.destName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:TheBloodLanternRemoved(args)
	self:Message(args.spellId, "red", L.dropped_lantern:format(args.destName))
	self:PlaySound(args.spellId, "info")
end

function mod:BloodlightApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 5 == 0 or amount == 1 then -- 1, 5, 10, 15...
			self:Message(args.spellId, "green", CL.stackyou:format(amount, args.spellName))
			self:PlaySound(args.spellId, "info")
		end
	end
end

function mod:BloodlightRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "cyan", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
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
