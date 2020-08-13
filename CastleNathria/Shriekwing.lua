if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- TODO:
-- -- Check how often we want to warm for Exsanguinated stacks
-- -- Delay Exsanguinating Bite timer when needed
-- -- Delay Sanguine Feast timer when needed
-- -- Replace Dark Descent debuff tracking with CLUE events when they are in
-- -- Check timers after intermission
-- -- Respawn timer (was very short on beta, will it stay?)

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Shriekwing", 2296, 2393)
if not mod then return end
mod:RegisterEnableMob(164406) -- Shriekwing
mod.engageId = 2398
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local ExsanguinatStacksOnMe = nil
local stageOver = nil
local shriekCount = 1
local echoCount = 1
local scentOfBloodCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		-- Stage One - Thirst for Blood
		328897, -- Exsanguinated
		{328857, "TANK"}, -- Exsanguinating Bite
		--340322, -- Sanguine Feast
		{342074, "SAY", "SAY_COUNTDOWN"}, -- Scent of Blood
		330711, -- Earsplitting Shriek
		340324, -- Sanguine Ichor
		336345, -- Echo Screech
		-- Stage Two - Terror of Castle Nathria
		328921, -- Bloodgorge
		329362, -- Dark Sonar
		340047, -- Sonar Shriek
	}, {
		["stages"] = "general",
		[328897] = -22101, -- Stage One - Thirst for Blood
		[328921] = -22102, -- Stage Two - Terror of Castle Nathria
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	-- Stage One - Thirst for Blood
	self:Log("SPELL_AURA_APPLIED", "ExsanguinatedApplied", 328897)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ExsanguinatedApplied", 328897)
	self:Log("SPELL_AURA_REMOVED", "ExsanguinatedRemoved", 328897)
	self:Log("SPELL_CAST_START", "ExsanguinatingBite", 328857)
	-- self:Log("SPELL_CAST_SUCCESS", "SanguineFeast", 340322)
	-- self:Log("SPELL_AURA_APPLIED", "DarkDescentApplied", 336235)
	-- self:Log("SPELL_AURA_REMOVED", "DarkDescentRemoved", 336235)
	self:Log("SPELL_CAST_START", "EarsplittingShriek", 330711)
	self:Log("SPELL_CAST_START", "EchoScreech", 336345)

	-- Stage Two - Terror of Castle Nathria
	self:Log("SPELL_CAST_START", "Bloodgorge", 328921)
	self:Log("SPELL_CAST_SUCCESS", "DarkSonar", 329362)
	self:Log("SPELL_CAST_START", "SonarShriek", 340047)
	self:Log("SPELL_AURA_REMOVED", "BloodgorgeRemoved", 328921)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 340324) -- Sanguine Ichor
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 340324)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 340324)
end

function mod:OnEngage()
	self:CDBar(328857, 6) -- Exsanguinating Bite
	--self:CDBar(340322, 11) -- Sanguine Feast
	self:CDBar(330711, 21, CL.count:format(self:SpellName(330711), shriekCount)) -- Earsplitting Shriek
	self:CDBar(336345, 31.1, CL.count:format(self:SpellName(336345), echoCount)) -- Echo Screech
	self:CDBar(342074, 42.5, CL.count:format(self:SpellName(342074), scentOfBloodCount)) -- Scent of Blood
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 336233 then -- Dark Descent
		self:RegisterEvent("UNIT_AURA")
		scentOfBloodCount = scentOfBloodCount + 1
		self:CDBar(342074, 42.5, CL.count:format(self:SpellName(342074), scentOfBloodCount)) -- Scent of Blood
	end
end

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
	self:CDBar(args.spellId, 11) -- Delay if Earsplitting Shriek will delay it?
end

-- function mod:SanguineFeast(args)
-- 	self:Message2(args.spellId, "red")
-- 	self:CDBar(args.spellId, 11) -- Delay if Earsplitting Shriek will delay it?
-- end

-- XXX Currently missing CLUE events, tracking with UNIT_AURA
-- 	function mod:DarkDescentApplied(args)
-- 		if self:Me(args.destGUID) then
-- 			self:Say(args.spellId)
-- 			self:SayCountdown(args.spellId, 8)
-- 			self:PlaySound(args.spellId, "warning")
-- 		end
-- 		self:TargetMessage2(args.spellId, "yellow", playerList)
-- 	end
--
-- 	function mod:DarkDescentRemoved(args)
-- 		if self:Me(args.destGUID) then
-- 			self:CancelSayCountdown(args.spellId)
-- 		end
-- 	end
-- end

do
	local guid = nil
	function mod:UNIT_AURA(_, unit)
		local debuffName = self:UnitDebuff(unit, self:SpellName(342074)) -- Dark Descent
		local unitName = self:UnitName(unit)
		if debuffName then
			guid = UnitGUID(unitName)

			if self:Me(guid) then
				self:Say(342074) -- Dark Descent
				self:SayCountdown(342074, 8) -- Dark Descent
				self:PlaySound(342074, "warning") -- Dark Descent
			end
			self:TargetMessage2(342074, "yellow", unitName, CL.count:format(self:SpellName(342074), scentOfBloodCount-1)) -- Dark Descent
			self:UnregisterEvent("UNIT_AURA")
		end
	end
end

function mod:EarsplittingShriek(args)
	self:Message2(args.spellId, "red", CL.count:format(args.spellName, shriekCount))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 4, CL.count:format(args.spellName, shriekCount))
	shriekCount = shriekCount + 1
	self:CDBar(args.spellId, 45, CL.count:format(args.spellName, shriekCount))
end

function mod:EchoScreech(args)
	self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, echoCount))
	self:PlaySound(args.spellId, "alert")
	echoCount = echoCount + 1
	self:CDBar(args.spellId, 42, CL.count:format(args.spellName, echoCount))
end

function mod:Bloodgorge(args)
	self:Message2(args.spellId, "green")
	self:PlaySound(args.spellId, "long")

	self:StopBar(328857) -- Exsanguinating Bite
	self:StopBar(340322) -- Sanguine Feast
	self:StopBar(336233) -- Dark Descent
	self:StopBar(330711) -- Earsplitting Shriek
	self:StopBar(336345) -- Echo Screech

	self:CDBar("stages", 45, CL.intermission) -- 5s Cast, 40s Intermission/Stage 2
	stageOver = args.time + 45
	self:CDBar(329362, 7.4) -- Dark Sonar
end

function mod:DarkSonar(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:SonarShriek(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
	if stageOver - args.time > 6.1 then
		self:CDBar(args.spellId, 6.1)
	end
end

function mod:BloodgorgeRemoved(args)
	self:Message2("stages", "green", CL.stage:format(1), nil)
	self:PlaySound("stages", "info")

	shriekCount = 1
	echoCount = 1
	scentOfBloodCount = 1

	self:CDBar(328857, 6) -- Exsanguinating Bite
	--self:CDBar(340322, 11) -- Sanguine Feast
	self:CDBar(330711, 21, CL.count:format(self:SpellName(330711), shriekCount)) -- Earsplitting Shriek
	self:CDBar(336345, 31.1, CL.count:format(self:SpellName(336345), echoCount)) -- Echo Screech
	self:CDBar(342074, 42.5, CL.count:format(self:SpellName(342074), scentOfBloodCount)) -- Scent of Blood
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and not ExsanguinatStacksOnMe then -- It's good to stand on blood when you have some stacks, bad if you lost them all
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
