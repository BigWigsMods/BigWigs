if not BigWigsLoader.isTestBuild then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The One-Armed Bandit", 2769, 2644)
if not mod then return end
mod:RegisterEnableMob(228458) -- One-Armed Bandit XXX Confirm on PTR
mod:SetEncounterID(3014)
mod:SetRespawnTime(30)
mod:SetStage(1)
mod:SetPrivateAuraSounds({
	465325, -- Hot Hot Heat
})

--------------------------------------------------------------------------------
-- Locals
--

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
		-- Stage One: That's RNG, Baby!
		461060, -- Spin To Win!
			461068, -- Fraud Detected!
			-- Fabulous Prizes
			"rewards", -- Rewards
			-- 464772, -- Reward: Shock and Flame
				474731, -- Traveling Flames
				-- 473009, -- Explosive Shrapnel
			-- 464801, -- Reward: Shock and Bomb
				{465009, "NAMEPLATE"}, -- Explosive Gaze
			-- 464804, -- Reward: Flame and Bomb
				-- 472178, -- Burning Blast
			-- 464806, -- Reward: Flame and Coin
			-- 464809, -- Reward: Coin and Shock
				474665, -- Coin Magnet
			-- 464810, -- Reward: Coin and Bomb
			-- Reel Assistant
			460582, -- Overload!
			471927, -- Withering Flames
			-- 460847, -- Electric Blast
			-- Golden Ticket
			464705, -- Golden Ticket
		460181, -- Pay-Line
			460444, -- High Roller!
			-- 460430, -- Crushed!
			-- 472718, -- Up the Ante
		469993, -- Foul Exhaust
		{460472, "TANK"}, -- The Big Hit
			460576, -- Shocking Field
		-- Stage Two: This Game Is Rigged!
		465309, -- Cheat to Win!
			465432, -- Linked Machines
				-- Hyper Coil
				473178, -- Voltaic Streak
			465322, -- Hot Hot Heat
			465580, -- Scattered Payout
			{465587, "CASTBAR"}, -- Explosive Jackpot
	},{ -- Sections

	},{ -- Renames
		[465009] = CL.fixate, -- Explosive Gaze (Fixate)
	}
end

function mod:OnRegister()
	self:SetSpellRename(465009, CL.fixate) -- Explosive Gaze (Fixate)
end

function mod:OnBossEnable()
	-- Stage One: That's RNG, Baby!
	self:Log("SPELL_CAST_START", "SpinToWin", 461060)
	self:Log("SPELL_AURA_APPLIED", "FraudDetected", 461068)

	-- Fabulous Prizes, all using 1 function for now - split up as needed
	self:Log("SPELL_CAST_START", "Rewards",
	464772, -- Shock and Flame
	464801, -- Shock and Bomb
	464804, -- Flame and Bomb
	464806, -- Flame and Coin
	464809, -- Coin and Shock
	464810 -- Coin and Bomb
	)

	-- Fabulous Prizes followups
	self:Log("SPELL_AURA_APPLIED", "ExplosiveGazeApplied", 465009)
	self:Log("SPELL_AURA_REMOVED", "ExplosiveGazeRemoved", 465009)
	self:Log("SPELL_CAST_SUCCESS", "CoinMagnet", 474665)

	-- Reel Assistant
	self:Log("SPELL_CAST_START", "Overload", 460582)
	self:Log("SPELL_CAST_SUCCESS", "WitheringFlames", 472197)
	self:Log("SPELL_AURA_APPLIED", "WitheringFlamesApplied", 471927)
	self:Log("SPELL_AURA_APPLIED", "GoldenTicketApplied", 464705)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GoldenTicketApplied", 464705)
	self:Log("SPELL_CAST_START", "PayLine", 460181)
	self:Log("SPELL_AURA_APPLIED", "HighRollerApplied", 460444)
	self:Log("SPELL_CAST_START", "FoulExhaust", 469993)
	self:Log("SPELL_CAST_START", "TheBigHit", 460472)
	self:Log("SPELL_AURA_APPLIED", "TheBigHitApplied", 460472)

	-- Dodgeable damage effects
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 460576) -- Shocking Field
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 460576)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 460576)
	self:Log("SPELL_DAMAGE", "GroundDamage", 474731, 473178) -- Traveling Flames, Voltaic Streak

	-- Stage Two: This Game Is Rigged!
	self:Log("SPELL_CAST_SUCCESS", "CheatToWin", 465309)
	self:Log("SPELL_CAST_START", "LinkedMachines", 465432)
	self:Log("SPELL_CAST_START", "HotHotHeat", 465322)
	self:Log("SPELL_CAST_START", "ScatteredPayout", 465580)
	self:Log("SPELL_CAST_START", "ExplosiveJackpot", 465587)
end

function mod:OnEngage()
	self:SetStage(1)
	-- self:Bar(461060, 10) -- Spin To Win!
	-- self:Bar(460181, 20) -- Pay-Line
	-- self:Bar(469993, 30) -- Foul Exhaust
	-- self:Bar(460472, 40) -- The Big Hit
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SpinToWin(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long") -- adds inc
	-- self:Bar(args.spellId, 45)
end

function mod:FraudDetected(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning") -- TILT TILT TILT!
end

function mod:Rewards(args)
	self:Message("rewards", "yellow", args.spellName, args.spellId)
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
		local t = args.time
		if t - prev > 2 then
			prev = t
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
	self:StackMessage(args.spellId, "cyan", args.destName, args.amount, 6) -- 6 rewards possible, then stage 2?
	self:PlaySound(args.spellId, "info") -- more attack speed on boss
end

function mod:PayLine(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert") -- Dodge coin path and get close
	-- self:Bar(args.spellId, 45)
end

function mod:HighRollerApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "info") --	buffed
	end
end

function mod:FoulExhaust(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert") -- debuffs inc
	-- self:Bar(args.spellId, 45)
end

function mod:TheBigHit(args)
	self:Message(args.spellId, "purple")
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:Tanking(unit) then
		self:PlaySound(args.spellId, "alarm") -- defensive
	end
	-- self:Bar(args.spellId, 45)
end

function mod:TheBigHitApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and not self:Tanking(unit) then -- XXX Confirm swap on 1
		self:PlaySound(args.spellId, "warning") -- tauntswap
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

-- Stage Two: This Game Is Rigged!
function mod:CheatToWin(args)
	self:SetStage(2)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning") -- last stage
end

function mod:LinkedMachines(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long") -- electric links inc
	-- self:Bar(args.spellId, 45)
end

function mod:HotHotHeat(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "long") -- fire lines inc
	-- self:Bar(args.spellId, 45)
end

function mod:ScatteredPayout(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long") -- ticking damage inc
end

function mod:ExplosiveJackpot(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning") -- instakill inc
	self:CastBar(args.spellId, 30)
end
