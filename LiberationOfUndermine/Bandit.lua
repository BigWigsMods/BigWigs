if not BigWigsLoader.isTestBuild then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The One-Armed Bandit", 2769, 2644)
if not mod then return end
mod:RegisterEnableMob(228458)
mod:SetEncounterID(3014)
mod:SetPrivateAuraSounds({
	465325, -- Hot Hot Heat
})
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local spinToWinCount = 1
local payLineCount = 1
local foulExhauntCount = 1
local theBigHitCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.rewards = "Fabulous Prizes"
	L.rewards_desc = "Messages and sounds to let you know which Fabulous Prizes have been won!"
	L.rewards_icon = "inv_111_vendingmachine_blackwater"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		460181, -- Pay-Line
			460444, -- High Roller!
		469993, -- Foul Exhaust
		{460472, "TANK"},-- The Big Hit

		-- Stage One: That's RNG, Baby!
		461060, -- Spin To Win!
			461068, -- Fraud Detected!
			-- Fabulous Prizes
			"rewards", -- Rewards
			-- 464772, -- Reward: Shock and Flame
			-- 464801, -- Reward: Shock and Bomb
				{465009, "NAMEPLATE"}, -- Explosive Gaze
			-- 464804, -- Reward: Flame and Bomb
			-- 464806, -- Reward: Flame and Coin
			-- 464809, -- Reward: Coin and Shock
				474665, -- Coin Magnet
			-- 464810, -- Reward: Coin and Bomb
			464705, -- Golden Ticket
			-- Reel Assistant
				460582, -- Overload!
				471927, -- Withering Flames
				-- 460847, -- Electric Blast

		-- Stage Two: This Game Is Rigged
		465765, -- Maintenance Cycle
		465761, -- Rig the Game!
		465432, -- Linked Machines
		465322, -- Hot Hot Hot
		465580, -- Scattered Payout
		{465587, "CASTBAR"}, -- Explosive Jackpot
	},{
		[461060] = -30083, -- Stage 1
		[465765] = -30086, -- Stage 2
	},{
		[465009] = CL.fixate, -- Explosive Gaze (Fixate)
	}
end

function mod:OnRegister()
	self:SetSpellRename(465009, CL.fixate) -- Explosive Gaze (Fixate)
end

function mod:OnBossEnable()
	-- Stage One: That's RNG, Baby!
	self:Log("SPELL_CAST_START", "PayLine", 460181)
	self:Log("SPELL_AURA_APPLIED", "HighRollerApplied", 460444)
	self:Log("SPELL_CAST_START", "FoulExhaust", 469993)
	self:Log("SPELL_CAST_START", "TheBigHit", 460472)
	self:Log("SPELL_AURA_APPLIED", "TheBigHitApplied", 460472)

	self:Log("SPELL_CAST_START", "SpinToWin", 461060)
	self:Log("SPELL_AURA_APPLIED", "FraudDetected", 461068)
	self:Log("SPELL_AURA_APPLIED", "GoldenTicketApplied", 464705)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GoldenTicketApplied", 464705)
	-- Fabulous Prizes, all using 1 function for now - split up as needed
	self:Log("SPELL_CAST_START", "Rewards",
		464772, -- Shock and Flame
		464801, -- Shock and Bomb
		464804, -- Flame and Bomb
		464806, -- Flame and Coin
		464809, -- Coin and Shock
		464810  -- Coin and Bomb
	)

	-- Fabulous Prizes followups
	self:Log("SPELL_AURA_APPLIED", "ExplosiveGazeApplied", 465009)
	self:Log("SPELL_AURA_REMOVED", "ExplosiveGazeRemoved", 465009)
	self:Log("SPELL_CAST_SUCCESS", "CoinMagnet", 474665)

	-- Reel Assistant
	self:Log("SPELL_CAST_START", "Overload", 460582)
	self:Log("SPELL_CAST_SUCCESS", "WitheringFlames", 472197)
	self:Log("SPELL_AURA_APPLIED", "WitheringFlamesApplied", 471927)

	-- Stage Two: This Game Is Rigged!
	self:Log("SPELL_CAST_SUCCESS", "MaintenanceCycle", 465765)
	self:Log("SPELL_CAST_START", "RigTheGame", 465761)
	self:Log("SPELL_CAST_START", "LinkedMachines", 465432)
	self:Log("SPELL_CAST_START", "HotHotHeat", 465322)
	self:Log("SPELL_CAST_START", "ScatteredPayout", 465580)
	self:Log("SPELL_CAST_START", "ExplosiveJackpot", 465587)
end

function mod:OnEngage()
	self:SetStage(1)

	spinToWinCount = 1
	payLineCount = 1
	foulExhauntCount = 1
	theBigHitCount = 1

	self:CDBar(460181, self:Easy() and 65.4 or 4.9, CL.count:format(self:SpellName(460181), payLineCount)) -- Pay-Line
	self:CDBar(469993, self:Easy() and 8.4 or 9.9, CL.count:format(self:SpellName(469993), foulExhauntCount)) -- Foul Exhaust
	self:Bar(461060, self:Easy() and 18.2 or 16.1, CL.count:format(self:SpellName(461060), spinToWinCount)) -- Spin To Win!
	-- self:CDBar(460472, self:Easy() and 14.9 or 19.8) -- The Big Hit

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 33 then -- Forced Stage 2 at 30%
		self:UnregisterUnitEvent(event, unit)
		self:Message("stages", "cyan", CL.soon:format(CL.stage:format(2)), false)
		self:PlaySound("stages", "info")
	end
end

-- Stage 1

function mod:PayLine(args)
	self:StopBar(CL.count:format(args.spellName, payLineCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, payLineCount))
	self:PlaySound(args.spellId, "alert") -- Dodge coin path and get close
	payLineCount = payLineCount + 1
	-- heroic: 4.9, 32.2, 31.7, 31.8, 31.8, 31.8, 31.8, 37.9, 36.7, 31.8 / 24.4, 31.6, 29.2
	-- normal: 65.4, 85.1, 83.9, 87.5 / 17.3, 29.3, 29.1
	if self:GetStage() == 2 then
		self:CDBar(args.spellId, 30, CL.count:format(args.spellName, payLineCount))
	else
		self:CDBar(args.spellId, self:Easy() and 84 or 32, CL.count:format(args.spellName, payLineCount))
	end
end

function mod:HighRollerApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "info") --	buffed
	end
end

function mod:FoulExhaust(args)
	self:StopBar(CL.count:format(args.spellName, foulExhauntCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, foulExhauntCount))
	self:PlaySound(args.spellId, "alert") -- debuffs inc
	foulExhauntCount = foulExhauntCount + 1
	-- heroic: 9.9, 32.0, 31.8, 35.4, 33.1, 37.9, 31.9, 34.2, 30.6, 30.7, 13.4 / 25.5, 26.8
	-- normal: 8.2, 45.0, 31.7, 47.4, 34.1, 49.9, 34.0, 53.4 / 11.2, 25.6, 25.6, 26.7
	if self:GetStage() == 2 then
		self:CDBar(args.spellId, 25.6, CL.count:format(args.spellName, foulExhauntCount))
	else
		self:CDBar(args.spellId, 31.8, CL.count:format(args.spellName, foulExhauntCount))
	end
end

function mod:TheBigHit(args)
	self:Message(args.spellId, "purple")
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:Tanking(unit) then
		self:PlaySound(args.spellId, "alarm") -- defensive
	end
	-- heroic: 19.8, 39.2, 22.1, 36.6, 30.8, 37.8, 19.6, 19.6, 14.6, 24.5, 19.7 / 47.7, 20.7, 14.6, 14.6, 14.6
	-- normal: 14.9, 41.0, 18.6, 19.1, 49.1, 19.4, 19.5, 45.9, 19.9, 19.1, 57.5 / 22.6, 28.3, 19.1, 14.5, 14.6
	-- self:CDBar(args.spellId, 19.6) -- XXX moving the boss seems to seriously mess with this?
end

function mod:TheBigHitApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and not self:Tanking(unit) then -- XXX Confirm swap on 1
		self:PlaySound(args.spellId, "warning") -- tauntswap
	end
end

function mod:SpinToWin(args)
	self:StopBar(CL.count:format(args.spellName, spinToWinCount))
	self:Message(args.spellId, "cyan", CL.count_amount:format(args.spellName, spinToWinCount, 6))
	self:PlaySound(args.spellId, "long") -- adds inc
	spinToWinCount = spinToWinCount + 1

	if spinToWinCount < 6 then
		self:Bar(args.spellId, self:Easy() and 86 or 61.2, CL.count:format(args.spellName, spinToWinCount))
	end
end

function mod:FraudDetected(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm") -- TILT TILT TILT!
end

function mod:Rewards(args)
	self:Message("rewards", "cyan", args.spellName, args.spellId)
	self:PlaySound("rewards", "long") -- Rewards incoming
end

function mod:ExplosiveGazeApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning") -- fixated
		self:Nameplate(args.spellId, 0, args.sourceGUID, ">"..CL.fixate.."<")
	end
end

function mod:ExplosiveGazeRemoved(args)
	if self:Me(args.destGUID) then
		self:StopNameplate(args.spellId, args.sourceGUID, ">"..CL.fixate.."<")
	end
end

function mod:CoinMagnet(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert") -- getting pulled in
end

function mod:Overload(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo and ready then
		self:Message(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alarm")
	end
end

do
	local prev = 0
	function mod:WitheringFlames(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Message(471927, "yellow")
			self:PlaySound(471927, "alert") -- debuffs inc
		end
		-- self:Nameplate(471927, 15, args.sourceGUID) -- XXX if they are always cast at the same time (or very close), prefer a bar.
	end
end

function mod:WitheringFlamesApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning") -- debuff
	end
end

function mod:GoldenTicketApplied(args)
	self:Message(args.spellId, "green", CL.count:format(args.spellId, args.amount or 1))
	self:PlaySound(args.spellId, "info") -- more attack speed on boss
end

-- Stage Two: This Game Is Rigged!

function mod:MaintenanceCycle(args)
	self:StopBar(CL.count:format(self:SpellName(460181), payLineCount)) -- Pay-Line
	self:StopBar(CL.count:format(self:SpellName(469993), foulExhauntCount)) -- Foul Exhaust
	self:StopBar(CL.count:format(self:SpellName(461060), spinToWinCount)) -- Spin To Win!
	self:StopBar(460472) -- The Big Hit
	self:UnregisterUnitEvent("UNIT_HEALTH", "boss1")

	self:SetStage(2)
	self:Message("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long")

	-- reset?
	-- payLineCount = 1
	-- foulExhauntCount = 1
	-- theBigHitCount = 1

	self:Bar(args.spellId, 6) -- Stunned
	self:Bar(469993, 11.6, CL.count:format(self:SpellName(469993), foulExhauntCount)) -- Foul Exhaust
	self:Bar(465432, 13.0) -- Cheat to Win - Linked Machines
	self:Bar(460181, 17.6, CL.count:format(self:SpellName(460181), payLineCount)) -- Pay-Line
	-- self:Bar(460472, 22.5) -- The Big Hit
end

function mod:RigTheGame(args)
	self:Message(args.spellId, "yellow")
end

function mod:LinkedMachines(args)
	self:StopBar(args.spellId)
	self:Message(args.spellId, "cyan", CL.count_amount:format(args.spellName, 1, 4))
	self:PlaySound(args.spellId, "long") -- electric links inc

	self:Bar(465322, self:Easy() and 29.6 or 25.5) -- Cheat to Win - Hot Hot Heat
end

function mod:HotHotHeat(args)
	self:Message(args.spellId, "cyan", CL.count_amount:format(args.spellName, 2, 4))
	self:PlaySound(args.spellId, "long") -- fire lines inc

	self:Bar(465580, self:Easy() and 30.8 or 26.7) -- Cheat to Win - Scattered Payout
end

function mod:ScatteredPayout(args)
	self:Message(args.spellId, "cyan", CL.count_amount:format(args.spellName, 3, 4))
	self:PlaySound(args.spellId, "long") -- ticking damage inc

	self:Bar(465587, self:Easy() and 29.9 or 25.1) -- Cheat to Win - Explosive Jackpot
end

function mod:ExplosiveJackpot(args)
	self:Message(args.spellId, "red", CL.count_amount:format(args.spellName, 4, 4))
	self:PlaySound(args.spellId, "alarm") -- enrage
	self:CastBar(args.spellId, 10)
end
