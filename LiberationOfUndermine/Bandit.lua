
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
local availableCombos
local comboColours

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.rewards = "Prizes" -- Fabulous Prizes
	L.rewards_desc = "When two Tokens are locked in, the \"Fabulous Prize\" is dispensed.\nMessages will let you know which one has been rewarded.\nThe infobox will show which prizes are still available."
	L.rewards_icon = "inv_111_vendingmachine_blackwater"
	L.deposit_time = "Deposit Time" -- Timer that indicates how long you have left to deposit the tokens.

	L.pay_line = "Coins"
	L.shock = "Shock"
	L.flame = "Flame"
	L.coin = "Coin"
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
			{"rewards", "INFOBOX"}, -- Rewards
			-- 464772, -- Reward: Shock and Flame
			-- 464801, -- Reward: Shock and Bomb
				{465009, "NAMEPLATE"}, -- Explosive Gaze
			-- 464804, -- Reward: Flame and Bomb
			-- 464806, -- Reward: Flame and Coin
			-- 464809, -- Reward: Coin and Shock
				474665, -- Coin Magnet
			-- 464810, -- Reward: Coin and Bomb
			{464705, "OFF"}, -- Golden Ticket
			-- Reel Assistant
				460582, -- Overload!
				{471927, "SAY", "NAMEPLATE"}, -- Withering Flames
				-- 460847, -- Electric Blast

		-- Stage Two: This Game Is Rigged
		465765, -- Maintenance Cycle
		465432, -- Linked Machines
		{465322, "PRIVATE"}, -- Hot Hot Hot
		465580, -- Scattered Payout
		{465587, "CASTBAR"}, -- Explosive Jackpot
	},{
		[461060] = -30083, -- Stage 1
		[465765] = -30086, -- Stage 2
	},{
		[460181] = L.pay_line, -- Pay-Line (Coins)
		[469993] = CL.heal_absorbs, -- Foul Exhaust (Heal Absorbs)
		[465009] = CL.fixate, -- Explosive Gaze (Fixate)
		[465765] = CL.stunned, -- Maintenance Cycle (Stunned)
	}
end

function mod:OnRegister()
	self:SetSpellRename(465009, CL.fixate) -- Explosive Gaze (Fixate)
	self:SetSpellRename(469993, CL.heal_absorbs) -- Foul Exhaust (Heal Absorbs)
	self:SetSpellRename(460181, L.pay_line) -- Pay-Line (Coins)

	availableCombos = {
		[1] = {L.shock, L.flame, 464772}, -- Blue + Red
		[2] = {L.shock, CL.bomb, 464801}, -- Blue + Purple
		[3] = {L.flame, CL.bomb, 464804}, -- Red + Purple
		[4] = {L.flame, L.coin, 464806}, -- Red + Yellow
		[5] = {L.coin, L.shock, 464809}, -- Yellow + Blue
		[6] = {L.coin, CL.bomb, 464810}, -- Yellow + Purple
	}
	comboColours = {
		[L.shock] = "00FFFF", -- cyan
		[L.flame] = "FF0000", -- red
		[CL.bomb] = "FF00FF", -- pink
		[L.coin] = "FFFF00", -- yellow
	}
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
	self:Log("SPELL_CAST_SUCCESS", "WitheringFlames", 471930)
	self:Log("SPELL_AURA_APPLIED", "WitheringFlamesApplied", 471927)
	self:Death("ReelAssistantDeath", 232599, 228463) -- Reel Assistants (on pull, spawned)

	-- Stage Two: This Game Is Rigged!
	self:Log("SPELL_CAST_SUCCESS", "MaintenanceCycle", 465765)
	self:Log("SPELL_CAST_START", "LinkedMachines", 465432)
	self:Log("SPELL_CAST_START", "HotHotHeat", 465322)
	self:Log("SPELL_CAST_START", "ScatteredPayout", 465580)
	self:Log("SPELL_CAST_START", "ExplosiveJackpot", 465587)
end

function mod:OnEngage()
	availableCombos = {
		[1] = {L.shock, L.flame, 464772}, -- Blue + Red
		[2] = {L.shock, CL.bomb, 464801}, -- Blue + Purple
		[3] = {L.flame, CL.bomb, 464804}, -- Red + Purple
		[4] = {L.flame, L.coin, 464806}, -- Red + Yellow
		[5] = {L.coin, L.shock, 464809}, -- Yellow + Blue
		[6] = {L.coin, CL.bomb, 464810}, -- Yellow + Purple
	}
	spinToWinCount = 1
	payLineCount = 1
	foulExhauntCount = 1
	theBigHitCount = 1
	self:SetStage(1)

	self:CDBar(460181, self:Mythic() and 3.5 or self:Easy() and 65.4 or 4.9, CL.count:format(L.pay_line, payLineCount)) -- Pay-Line
	self:CDBar(469993, self:Mythic() and 8.5 or self:Easy() and 8.4 or 9.9, CL.count:format(CL.heal_absorbs, foulExhauntCount)) -- Foul Exhaust
	self:CDBar(461060, self:Mythic() and 14.5 or self:Easy() and 18.2 or 16.1, CL.count:format(self:SpellName(461060), spinToWinCount)) -- Spin To Win!
	self:CDBar(460472, 17.9, CL.count:format(self:SpellName(460472), theBigHitCount)) -- The Big Hit
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
	self:StopBar(CL.count:format(L.pay_line, payLineCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.pay_line, payLineCount))
	self:PlaySound(args.spellId, "alert") -- Dodge coin path and get close
	payLineCount = payLineCount + 1
	if self:GetStage() == 2 then
		self:CDBar(args.spellId, 30, CL.count:format(L.pay_line, payLineCount))
	else
		self:CDBar(args.spellId, self:Mythic() and 26.1 or self:Easy() and 84 or 32, CL.count:format(L.pay_line, payLineCount))
	end
end

function mod:HighRollerApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "info") --	buffed
	end
end

function mod:FoulExhaust(args)
	self:StopBar(CL.count:format(CL.heal_absorbs, foulExhauntCount))
	self:Message(args.spellId, "orange", CL.count:format(CL.heal_absorbs, foulExhauntCount))
	self:PlaySound(args.spellId, "alert") -- debuffs inc
	foulExhauntCount = foulExhauntCount + 1
	if self:GetStage() == 2 then
		self:CDBar(args.spellId, 25.6, CL.count:format(CL.heal_absorbs, foulExhauntCount))
	else
		self:CDBar(args.spellId, 31.6, CL.count:format(CL.heal_absorbs, foulExhauntCount))
	end
end

function mod:TheBigHit(args)
	self:StopBar(CL.count:format(args.spellName, theBigHitCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, theBigHitCount))
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:Tanking(unit) then
		self:PlaySound(args.spellId, "alarm") -- defensive
	end
	theBigHitCount = theBigHitCount + 1
	local cd = 20.6
	if self:GetStage() == 2 then
		cd = 18.2
	end
	self:CDBar(args.spellId, 19.6, CL.count:format(args.spellName, theBigHitCount))
end

function mod:TheBigHitApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and not self:Tanking(unit) then -- XXX Confirm swap on 1
		self:PlaySound(args.spellId, "warning") -- tauntswap
	end
end

do
	local spinToWinTimer, startTime = 32, 0 -- from cast_start (2s) until the (30s) buff expires
	local red, yellow, green = {.6, 0, 0, .6}, {.7, .5, 0}, {0, .5, 0}

	local function updateInfoBoxBar(self)
		if self.isEngaged then
			self:SimpleTimer(function()
				updateInfoBoxBar(self)
			end, 0.1)
		else
			return
		end
		local timeLeft = spinToWinTimer - (GetTime() - startTime)
		if timeLeft > 0 then
			local percentLeft = timeLeft / spinToWinTimer
			local rgbColor = red
			if percentLeft > 0.6 then -- no rush
				rgbColor = green
			elseif percentLeft > 0.30  then -- should deposit soon
				rgbColor = yellow
			end

			self:SetInfoBar("rewards", 1, percentLeft, unpack(rgbColor))
			self:SetInfo("rewards", 2, format("%.1f", timeLeft))
		else
			self:CloseInfo("rewards")
		end
	end

	local function SetRewardsInfoBox(self)
		for i, combo in ipairs(availableCombos) do
			local leftText = "|r|cFF"..comboColours[combo[1]]..combo[1].."|r"
			local rightText = "|r|cFF"..comboColours[combo[2]]..combo[2].."|r"
			self:SetInfo("rewards", 1 + (i * 2),  CL.plus:format(leftText, rightText))
		end
		startTime = GetTime()
		self:SetInfo("rewards", 1, "Deposit Time:")
		updateInfoBoxBar(self)
	end

	function mod:SpinToWin(args)
		self:StopBar(CL.count:format(args.spellName, spinToWinCount))
		if spinToWinCount == 7 then
			self:Message(args.spellId, "cyan", CL.count:format(args.spellName, spinToWinCount)) -- skip the count_amount as it will stage into stage 2
		else
			self:Message(args.spellId, "cyan", CL.count_amount:format(args.spellName, spinToWinCount, 6))
		end
		self:PlaySound(args.spellId, "long") -- adds inc
		spinToWinCount = spinToWinCount + 1

		local cd = self:Mythic() and 51.1 or self:Easy() and 86 or 61.2
		if spinToWinCount <= 6 then
			self:Bar(args.spellId, cd, CL.count:format(args.spellName, spinToWinCount))
		elseif spinToWinCount == 7 then
			self:Bar(args.spellId, cd, CL.stage:format(2))
		end
		self:CDBar(471927, 15) -- Withering Flames

		-- Infobox stuff
		self:OpenInfo("rewards", L.rewards, #availableCombos + 1) -- Fabulous Prizes, First line is the castbar
		SetRewardsInfoBox(self)
	end
end

function mod:FraudDetected(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm") -- TILT TILT TILT!
	self:CloseInfo("rewards")
end

function mod:Rewards(args)
	self:Message("rewards", "cyan", args.spellName, args.spellId)
	self:PlaySound("rewards", "long") -- Rewards incoming

	-- Infobox Stuff
	self:CloseInfo("rewards")
	for i, combo in ipairs(availableCombos) do
		if combo[3] == args.spellId then
			table.remove(availableCombos, i)
			break
		end
	end
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
		self:StopBar(471927) -- Initial bar for all casts
		if args.time - prev > 2 then
			prev = args.time
			self:Message(471927, "yellow")
			self:PlaySound(471927, "alert") -- debuffs inc
		end
		self:Nameplate(471927, 20, args.sourceGUID)
	end
end

function mod:WitheringFlamesApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning") -- debuff
		self:Say(args.spellId, nil, nil, "Flames")
	end
end

function mod:ReelAssistantDeath(args)
	self:ClearNameplate(args.destGUID)
end

function mod:GoldenTicketApplied(args)
	self:Message(args.spellId, "green", CL.count:format(args.spellName, args.amount or 1))
	self:PlaySound(args.spellId, "info") -- more attack speed on boss
end

-- Stage Two: This Game Is Rigged!
function mod:MaintenanceCycle(args)
	self:StopBar(CL.count:format(L.pay_line, payLineCount)) -- Pay-Line
	self:StopBar(CL.count:format(CL.heal_absorbs, foulExhauntCount)) -- Foul Exhaust
	self:StopBar(CL.count:format(self:SpellName(461060), spinToWinCount)) -- Spin To Win!
	self:StopBar(CL.count:format(self:SpellName(460472), theBigHitCount)) -- The Big Hit
	self:StopBar(CL.stage:format(2)) -- Last Spin To Win!
	self:UnregisterUnitEvent("UNIT_HEALTH", "boss1")

	self:SetStage(2)
	self:Message("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long")

	payLineCount = 1
	foulExhauntCount = 1
	theBigHitCount = 1

	self:Bar(args.spellId, 6, CL.stunned) -- Stunned
	self:Bar(465432, 13.0) -- Cheat to Win - Linked Machines
	self:CDBar(469993, 17.0, CL.count:format(CL.heal_absorbs, foulExhauntCount)) -- Foul Exhaust
	self:CDBar(460181, 23.0, CL.count:format(L.pay_line, payLineCount)) -- Pay-Line
	self:CDBar(460472, 28.0, CL.count:format(self:SpellName(460472), theBigHitCount)) -- The Big Hit
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
