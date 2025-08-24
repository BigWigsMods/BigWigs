
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
local payLineTotalCount = 1
local foulExhauntCount = 1
local foulExhaustTotalCount = 1
local theBigHitCount = 1
local theBigHitTotalCount = 1
local linkedMachinesCount = 1
local hotHotHeatCount = 1
local mobCollector = {}
local mobMark = 1
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
	L.deposit_time = "Deposit Time:" -- Timer that indicates how long you have left to deposit the tokens.

	L.pay_line = "Coins"
	L.withering_flames = "Flames" -- Short for Withering Flames

	L.cheat = "Activate: %s" -- Cheat: Coils, Cheat: Debuffs, Cheat: Raid Damage, Cheat: Final Cast
	L.linked_machines = "Coils"
	L.linked_machine = "Coil" -- Singular of Coils
	L.hot_hot_heat = "Hot Debuffs"
	L.explosive_jackpot = "Final Cast"

	L.shock = "Shock"
	L.flame = "Flame"
	L.coin = "Coin"
end

--------------------------------------------------------------------------------
-- Initialization
--

local reelAssistantMarkerMapTable = {8, 7, 6, 5}
local reelAssistantMarker = mod:AddMarkerOption(false, "npc", reelAssistantMarkerMapTable[1], -30085, unpack(reelAssistantMarkerMapTable))
function mod:GetOptions()
	return {
		reelAssistantMarker,
		"stages",
		460181, -- Pay-Line
			460444, -- High Roller!
		469993, -- Foul Exhaust
		460472,-- The Big Hit

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
				{460582, "NAMEPLATE"}, -- Overload!
				{471927, "SAY", "NAMEPLATE"}, -- Withering Flames
				-- 460847, -- Electric Blast

		-- Stage Two: This Game Is Rigged
		{465309, "OFF"}, -- Cheat To Win!
		465765, -- Maintenance Cycle
		473195, -- Linked Machines (Coil spawning)
		{465432, "OFF"}, -- Linked Machines (Knockback)
		{465322, "PRIVATE"}, -- Hot Hot Heat (Debuffs)
		{465325, "OFF"}, -- Hot Hot Heat (Beams)
		{465587, "CASTBAR"}, -- Explosive Jackpot
	},{
		[461060] = -30083, -- Stage 1
		[465309] = -30086, -- Stage 2
	},{
		[460181] = L.pay_line, -- Pay-Line (Coins)
		[469993] = CL.heal_absorbs, -- Foul Exhaust (Heal Absorbs)
		[465009] = CL.fixate, -- Explosive Gaze (Fixate)
		[465765] = CL.stunned, -- Maintenance Cycle (Stunned)
		[473195] = L.linked_machine, -- Linked Machines (Coil)
		[465432] = CL.knockback, -- Linked Machines (Knockback)
		[465322] = L.hot_hot_heat, -- Hot Hot Heat (Debuffs)
		[465325] = CL.beams, -- Hot Hot Heat (Beams)
	}
end

function mod:OnRegister()
	self:SetSpellRename(460181, L.pay_line) -- Pay-Line (Coins)
	self:SetSpellRename(469993, CL.heal_absorbs) -- Foul Exhaust (Heal Absorbs)
	self:SetSpellRename(465009, CL.fixate) -- Explosive Gaze (Fixate)
	self:SetSpellRename(465765, CL.stunned) -- Maintenance Cycle (Stunned)
	self:SetSpellRename(473195, L.linked_machine) -- Linked Machines (Coil)
	self:SetSpellRename(465432, CL.knockback) -- Linked Machines (Knockback)
	self:SetSpellRename(465322, L.hot_hot_heat) -- Hot Hot Heat (Debuffs)
	self:SetSpellRename(465325, CL.beams) -- Hot Hot Heat (Beams)

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
	self:Log("SPELL_AURA_REFRESH", "HighRollerApplied", 460444)
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
	self:Log("SPELL_AURA_APPLIED", "SpinToWinApplied", 471720) -- Add spawn
	self:Log("SPELL_CAST_START", "Overload", 460582)
	self:Log("SPELL_INTERRUPT", "OverloadInterrupt", 460582)
	self:Log("SPELL_CAST_SUCCESS", "OverloadSuccess", 460582)
	self:Log("SPELL_CAST_SUCCESS", "WitheringFlames", 471930)
	self:Log("SPELL_AURA_APPLIED", "WitheringFlamesApplied", 471927)
	self:Death("ReelAssistantDeath", 232599, 228463) -- Reel Assistants (on pull, spawned)

	-- Stage Two: This Game Is Rigged!
	self:Log("SPELL_CAST_SUCCESS", "MaintenanceCycle", 465765)
	self:Log("SPELL_CAST_START", "LinkedMachines", 465432)
	self:Log("SPELL_AURA_APPLIED", "LinkedMachinesApplied", 473195)
	self:Log("SPELL_AURA_REFRESH", "LinkedMachinesApplied", 473195)
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
	payLineTotalCount = 1
	foulExhauntCount = 1
	foulExhaustTotalCount = 1
	theBigHitCount = 1
	theBigHitTotalCount = 1
	mobCollector = {}
	mobMark = 1
	self:SetStage(1)

	self:CDBar(460181, self:Mythic() and 3.5 or self:Easy() and 65.4 or 4.9, CL.count:format(L.pay_line, payLineTotalCount)) -- Pay-Line
	self:CDBar(469993, self:Mythic() and 8.5 or self:Easy() and 8.4 or 9.9, CL.count:format(CL.heal_absorbs, foulExhaustTotalCount)) -- Foul Exhaust
	self:CDBar(461060, self:Mythic() and 14.5 or self:Easy() and 18.2 or 16.1, CL.count:format(self:SpellName(461060), spinToWinCount)) -- Spin To Win!
	self:CDBar(460472, 17.9, CL.count:format(self:SpellName(460472), theBigHitTotalCount)) -- The Big Hit

	if self:GetOption(reelAssistantMarker) then
		self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	end
	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	for i = 1, 8 do
		local unit = ("boss%d"):format(i)
		local guid = self:UnitGUID(unit)
		if mobCollector[guid] then -- Reel Assistant
			local icon = reelAssistantMarkerMapTable[mobCollector[guid]]
			self:CustomIcon(reelAssistantMarker, unit, icon)
			mobCollector[guid] = false
		end
	end
end

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 33 then -- Forced Stage 2 at 30%
		self:UnregisterUnitEvent(event, unit)
		self:Message("stages", "cyan", CL.soon:format(CL.stage:format(2)), false)
		self:PlaySound("stages", "info")
	end
end

-- Stage 1

function mod:PayLine(args)
	self:StopBar(CL.count:format(L.pay_line, payLineTotalCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.pay_line, payLineTotalCount))
	self:PlaySound(args.spellId, "alert") -- Dodge coin path and get close
	payLineCount = payLineCount + 1
	payLineTotalCount = payLineTotalCount + 1
	local cd = self:Easy() and 84 or 41.5
	if self:Mythic() and self:GetStage() == 1 then
		cd = payLineCount == 2 and 26.7 or 0 -- 2 per rewards round
	elseif self:GetStage() == 2 then
		local stageTwoTimers = { 23.5, 36.5, 0 }
		if self:Easy() then -- 1 extra cast
			stageTwoTimers = { 23.5, 36.5, 36.4, 0 }
		end
		cd = stageTwoTimers[payLineCount]
	end
	self:CDBar(args.spellId, cd, CL.count:format(L.pay_line, payLineTotalCount))
end

do
	local prev = 0
	function mod:HighRollerApplied(args)
		if self:Me(args.destGUID) and args.time - prev > 3 then -- Throttle when coins are thrown at the same time
			prev = args.time
			self:Message(args.spellId, "green", CL.you:format(args.spellName))
			self:PlaySound(args.spellId, "info") --	buffed
		end
	end
end

function mod:FoulExhaust(args)
	self:StopBar(CL.count:format(CL.heal_absorbs, foulExhaustTotalCount))
	self:Message(args.spellId, "orange", CL.count:format(CL.heal_absorbs, foulExhaustTotalCount))
	self:PlaySound(args.spellId, "alert") -- debuffs inc
	foulExhauntCount = foulExhauntCount + 1
	foulExhaustTotalCount = foulExhaustTotalCount + 1
	local cd = foulExhauntCount == 2 and 31.5 or 0
	if self:Mythic() and self:GetStage() == 1 then
		cd = foulExhauntCount == 2 and 32.0 or 0 -- 2 per rewards round
	elseif self:GetStage() == 2 then
		local stageTwoTimers = { 17.45, 25.5, 30.4, 0 }
		if self:Easy() then -- 1 extra cast
			stageTwoTimers = { 17.45, 25.5, 30.4, 28.0, 0 }
		end
		cd = stageTwoTimers[foulExhauntCount]
	end
	self:CDBar(args.spellId, cd, CL.count:format(CL.heal_absorbs, foulExhaustTotalCount))
end

function mod:TheBigHit(args)
	self:StopBar(CL.count:format(args.spellName, theBigHitTotalCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, theBigHitTotalCount))
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:Tanking(unit) then
		self:PlaySound(args.spellId, "alarm") -- defensive
	elseif self:Mythic() and not self:Tank()  then -- Possibly getting debuffed soon, but no actual debuff :(
		self:PlaySound(args.spellId, "alert") -- watch yourself
	end
	theBigHitTotalCount = theBigHitTotalCount + 1
	theBigHitCount = theBigHitCount + 1
	local cd = 19.5 -- stage 1 non-mythic
	if self:Mythic() and self:GetStage() == 1 then
		if #availableCombos == 6 then -- before first deposit
			cd = 18.3
		else
			cd = theBigHitCount == 2 and 20.5 or 0 -- 2 per rewards round
		end
	elseif self:GetStage() == 2 then
		local stageTwoTimers = {28.5, 20.7, 18.25, 18.2, 0}
		cd = stageTwoTimers[theBigHitCount]
	end
	self:CDBar(args.spellId, cd, CL.count:format(args.spellName, theBigHitTotalCount))
end

function mod:TheBigHitApplied(args)
	if self:Tank() then
		self:TargetMessage(args.spellId, "purple", args.destName)
		local unit = self:UnitTokenFromGUID(args.sourceGUID)
		if unit and not self:Tanking(unit) then
			self:PlaySound(args.spellId, "warning") -- tauntswap
		end
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
		self:SetInfo("rewards", 1, L.deposit_time)
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
		mobMark = 1

		-- Infobox stuff
		self:OpenInfo("rewards", L.rewards, #availableCombos + 1) -- Fabulous Prizes, First line is the castbar
		SetRewardsInfoBox(self)
	end
end

function mod:RestartRewardTimers(flameAndCoin)
	-- Cooldowns Reset on rewards or fraud detected, restart the bars with new timers (Not Spin To Win)
	foulExhauntCount = 1
	theBigHitCount = 1
	payLineCount = 1

	local payLineCd = flameAndCoin and 11 or 5.2
	local foulExhaustCD = flameAndCoin and 15.5 or 10.5
	local bigHitCd = flameAndCoin and 20.5 or 16.5
	if self:Mythic() then
		local extraTime = flameAndCoin and 7 or 0 -- Extra time due to the channel of Flame and Coin
		payLineCd = 5.0 + extraTime
		foulExhaustCD = 10.0 + extraTime
		bigHitCd = 16.0 + extraTime
	end

	self:CDBar(460181, payLineCd, CL.count:format(L.pay_line, payLineTotalCount)) -- Pay-Line
	self:CDBar(469993, foulExhaustCD, CL.count:format(CL.heal_absorbs, foulExhaustTotalCount)) -- Foul Exhaust
	self:CDBar(460472, bigHitCd, CL.count:format(self:SpellName(460472), theBigHitTotalCount)) -- The Big Hit
end

function mod:FraudDetected(args)
	self:StopBar(471927) -- Withering Flames

	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm") -- TILT TILT TILT!
	self:CloseInfo("rewards")

	self:RestartRewardTimers()
end

function mod:Rewards(args)
	self:StopBar(471927) -- Withering Flames

	self:Message("rewards", "cyan", args.spellName, args.spellId)
	self:PlaySound("rewards", "long") -- Rewards incoming

	self:RestartRewardTimers(args.spellId == 464806)

	-- move left over add to backup kick mark
	local guid = self:UnitGUID("boss2")
	if guid and mobCollector[guid] == false then -- Reel Assistant
		self:CustomIcon(reelAssistantMarker, "boss2", reelAssistantMarkerMapTable[4])
	end

	-- Infobox Stuff
	self:CloseInfo("rewards")
	for i, combo in ipairs(availableCombos) do
		if combo[3] == args.spellId then
			table.remove(availableCombos, i)
			break
		end
	end
end

do
	local prev = 0
	function mod:ExplosiveGazeApplied(args)
		if self:Me(args.destGUID) then
			if args.time - prev > 1 then -- throttle for multiple fixates
				prev = args.time
				self:PersonalMessage(args.spellId, nil, CL.fixate)
				self:PlaySound(args.spellId, "warning") -- fixated
			end
			self:Nameplate(args.spellId, 0, args.sourceGUID, ">"..CL.fixate.."<")
		end
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

function mod:SpinToWinApplied(args) -- Add spawn
	if mobCollector[args.destGUID] == nil then
		mobCollector[args.destGUID] = mobMark
		mobMark = mobMark + 1
		self:Nameplate(460582, 16.2, args.destGUID) -- Overload!
	end
end

function mod:Overload(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo and ready then
		self:Message(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:OverloadInterrupt(args)
	self:Nameplate(460582, 21.9, args.destGUID)
end

function mod:OverloadSuccess(args)
	self:Nameplate(args.spellId, 21.9, args.sourceGUID)
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
		self:Nameplate(471927, 18.5, args.sourceGUID)
	end
end

function mod:WitheringFlamesApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning") -- debuff
		self:Say(args.spellId, L.withering_flames, nil, "Flames")
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
	self:StopBar(471927) -- Withering Flames
	self:StopBar(CL.count:format(L.pay_line, payLineTotalCount)) -- Pay-Line
	self:StopBar(CL.count:format(CL.heal_absorbs, foulExhaustTotalCount)) -- Foul Exhaust
	self:StopBar(CL.count:format(self:SpellName(461060), spinToWinCount)) -- Spin To Win!
	self:StopBar(CL.count:format(self:SpellName(460472), theBigHitTotalCount)) -- The Big Hit
	self:StopBar(CL.stage:format(2)) -- Last Spin To Win!
	self:UnregisterUnitEvent("UNIT_HEALTH", "boss1")

	self:SetStage(2)
	self:Message("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long")

	payLineCount = 1
	payLineTotalCount = 1
	foulExhauntCount = 1
	foulExhaustTotalCount = 1
	theBigHitCount = 1
	theBigHitTotalCount = 1
	linkedMachinesCount = 1
	hotHotHeatCount = 1

	self:Bar(args.spellId, 6, CL.stunned) -- Stunned
	local cheatCD = self:Mythic() and 12.8 or 13.0
	self:CDBar(465309, cheatCD, L.cheat:format(L.linked_machines)) -- Cheat to Win - Linked Machines
	self:CDBar(473195, cheatCD + 4.5, CL.count:format(L.linked_machine, linkedMachinesCount)) -- Coil Spawn
	self:CDBar(469993, 17.0, CL.count:format(CL.heal_absorbs, foulExhaustTotalCount)) -- Foul Exhaust
	self:CDBar(460181, 23.0, CL.count:format(L.pay_line, payLineTotalCount)) -- Pay-Line
	self:CDBar(460472, 28.5, CL.count:format(self:SpellName(460472), theBigHitTotalCount)) -- The Big Hit
end

function mod:LinkedMachines(args)
	self:StopBar(L.cheat:format(L.linked_machines)) -- Cheat to Win - Linked Machines
	self:Message(465309, "cyan", CL.count_amount:format(L.cheat:format(L.linked_machines), 1, 4))
	self:PlaySound(465309, "long") -- electric links inc

	local intialCheatCD = 13.0
	local nextPylon = 4.5
	local pylonLandingTime = 3
	self:Bar(473195, {nextPylon, intialCheatCD + nextPylon}, CL.count:format(L.linked_machine, linkedMachinesCount))
	self:ScheduleTimer("Bar", nextPylon, 465432, pylonLandingTime, CL.count:format(CL.knockback, linkedMachinesCount)) -- Scheduled to reduce bars on screen

	-- Next Cheat
	local initialHotHotHeatCD = self:Easy() and 29.6 or 25.5 -- Also adjust in HotHotHeat()
	self:Bar(465309, initialHotHotHeatCD, L.cheat:format(L.hot_hot_heat)) -- Cheat to Win - Hot Hot Heat
	self:Bar(465322, initialHotHotHeatCD + 3, CL.count:format(L.hot_hot_heat, hotHotHeatCount)) -- first debuffs on _success
end

function mod:LinkedMachinesApplied(args)
	linkedMachinesCount = linkedMachinesCount + 1
	local nextPylon = 15
	local pylonLandingTime = 3
	self:Bar(473195, nextPylon, CL.count:format(L.linked_machine, linkedMachinesCount))
	self:ScheduleTimer("Bar", nextPylon, 465432, pylonLandingTime, CL.count:format(CL.knockback, linkedMachinesCount)) -- Scheduled to reduce bars on screen
end

function mod:HotHotHeat(args)
	self:StopBar(L.cheat:format(L.hot_hot_heat)) -- Cheat to Win - Hot Hot Heat
	self:Message(465309, "cyan", CL.count_amount:format(L.cheat:format(L.hot_hot_heat), 2, 4))
	self:PlaySound(465309, "long") -- fire lines inc

	local cd = self:Easy() and 30.8 or 26.7
	self:Bar(465309, cd, L.cheat:format(CL.raid_damage)) -- Cheat to Win - Scattered Payout

	local initialHotHotHeatCD = self:Easy() and 29.6 or 25.5 -- Also Adjust in LinkedMachines()
	local castTime = 3
	self:Bar(465322, {castTime, initialHotHotHeatCD + castTime}, CL.count:format(L.hot_hot_heat, hotHotHeatCount)) -- first debuffs on _success
	self:ScheduleTimer("HotHotHeatApplied", 3)
end

function mod:HotHotHeatApplied() -- Private Aura, scheduled function, no events
	local debuffDuration = 5
	local cooldown = 12
	self:Bar(465325, debuffDuration, CL.count:format(CL.beams, hotHotHeatCount), "ability_evoker_firebreath") -- Beams // Different icon than Hot Hot Heat
	hotHotHeatCount = hotHotHeatCount + 1
	self:Bar(465322, cooldown, CL.count:format(L.hot_hot_heat, hotHotHeatCount)) -- first debuffs on _success
	self:ScheduleTimer("HotHotHeatApplied", debuffDuration + cooldown)
end

function mod:ScatteredPayout(args)
	self:StopBar(L.cheat:format(CL.raid_damage)) -- Cheat to Win - Scattered Payout
	self:Message(465309, "cyan", CL.count_amount:format(L.cheat:format(CL.raid_damage), 3, 4))
	self:PlaySound(465309, "long") -- ticking damage inc

	local cd = self:Easy() and 29.9 or 25.1
	self:Bar(465587, cd, L.cheat:format(L.explosive_jackpot)) -- Cheat to Win - Explosive Jackpot
end

function mod:ExplosiveJackpot(args)
	self:StopBar(CL.count:format(L.pay_line, payLineTotalCount)) -- Pay-Line
	self:StopBar(CL.count:format(CL.heal_absorbs, foulExhaustTotalCount)) -- Foul Exhaust
	self:StopBar(CL.count:format(self:SpellName(460472), theBigHitTotalCount)) -- The Big Hit
	self:StopBar(L.cheat:format(L.explosive_jackpot)) -- Cheat to Win - Explosive Jackpot

	self:Message(args.spellId, "red", CL.count_amount:format(args.spellName, 4, 4))
	self:PlaySound(args.spellId, "alarm") -- enrage
	self:CastBar(args.spellId, 10)
end
