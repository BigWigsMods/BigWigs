--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Assault of the Zaqali", 2569, 2524)
if not mod then return end
mod:RegisterEnableMob(199659, 199703, 202791) -- Warlord Kagni, Magma Mystic, Ignara
mod:SetEncounterID(2682)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local cudgelCount = 1
local devastatingLeapCount = 1
local phoenixRushCount = 1
local vigorousGaleCount = 1
local zaqaliAideCount = 1
local magmaMysticCount = 1
local blazingFocusCount = 0
local myFlamingCudgelStacks = 0
local tempBlockBigAddMsg = false
local hasFixate, hasBeam = false, false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	-- These are in-game emotes and need to match the text shown in-game
	-- You should also replace the comment (--) with the full emote as it shows in-game
	L.zaqali_aide_north_emote_trigger = "northern battlement" -- |TInterface\\ICONS\\Ability_Hunter_KillCommand.blp:20|t Commanders ascend the northern battlement!
	L.zaqali_aide_south_emote_trigger = "southern battlement" -- |TInterface\\ICONS\\Ability_Hunter_KillCommand.blp:20|t Commanders ascend the southern battlement!

	L.both = "Both"
	L.zaqali_aide_message = "%s Climbing %s" -- Big Adds Climbing North
	L.add_bartext = "%s: %s (%d)"
	L.boss_returns = "Boss Lands: North"

	L.molten_barrier = "Barrier"
	L.catastrophic_slam = "Door Slam"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- General
		"stages",
		404382, -- Zaqali Aide
		404687, -- Barrier Backfire
		-- Warlord Kagni
		408959, -- Devastating Leap
		401258, -- Heavy Cudgel
		-- Magma Mystic
		397383, -- Molten Barrier
		409275, -- Magma Flow
		397386, -- Lava Bolt
		-- Flamebound Huntsman
		{401401, "SAY", "ME_ONLY_EMPHASIZE"}, -- Blazing Spear
		-- Obsidian Guard
		408620, -- Scorching Roar
		{401867, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Volcanic Shield
		-- Ignara (Mythic)
		401108, -- Phoenix Rush
		401381, -- Blazing Focus
		407009, -- Vigorous Gale
		-- Stage 2
		406585, -- Ignara's Fury
		410516, -- Catastrophic Slam
		410351, -- Flaming Cudgel
	}, {
		["stages"] = "general",
		[408959] = -26209, -- Warlord Kagni
		[397383] = -26217, -- Magma Mystic
		[401401] = -26213, -- Flamebound Huntsman
		[408620] = -26210, -- Obsidian Guard
		[401108] = ("%s (%s)"):format(self:SpellName(-26737), CL.mythic), -- Ignara (Mythic)
		[406585] = -26683, -- Stage 2
	}, {
		[404382] = CL.big_adds, -- Zaqali Aide (Big Adds)
		[397383] = L.molten_barrier, -- Molten Barrier (Barrier)
		[408959] = CL.leap, -- Devastating Leap (Leap)
		[401867] = CL.beam, -- Volcanic Shield (Beam)
		[401381] = CL.fixate, -- Blazing Focus (Fixate)
		[407009] = CL.pushback, -- Vigorous Gale (Pushback)
		[410516] = L.catastrophic_slam, -- Catastrophic Slam (Door Slam)
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("RAID_BOSS_EMOTE")
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_CAST_SUCCESS", "ZaqaliAide", 412818, 412820) -- North, South || XXX still not in, being investigated

	self:Log("SPELL_AURA_APPLIED", "BarrierBackfireApplied", 404687)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BarrierBackfireApplied", 404687)
	-- Ignara
	self:Log("SPELL_CAST_SUCCESS", "PhoenixRush", 401108)
	self:Log("SPELL_AURA_APPLIED", "BlazingFocusApplied", 401381)
	self:Log("SPELL_AURA_REMOVED", "BlazingFocusRemoved", 401381)
	self:Log("SPELL_CAST_START", "VigorousGale", 407009)
	-- Warlord Kagni
	self:Log("SPELL_AURA_APPLIED", "IgnaraFlameApplied", 411230)
	self:Log("SPELL_AURA_REMOVED", "IgnaraFlameRemoved", 411230)
	self:Log("SPELL_CAST_START", "DevastatingLeap", 408959)
	self:Log("SPELL_CAST_START", "HeavyCudgel", 401258)
	self:Log("SPELL_AURA_APPLIED", "HeavyCudgelApplied", 408873)
	self:Log("SPELL_AURA_APPLIED_DOSE", "HeavyCudgelApplied", 408873)
	-- Magma Mystic
	self:Log("SPELL_CAST_START", "MoltenBarrier", 397383)
	self:Log("SPELL_CAST_START", "MagmaFlow", 409271)
	self:Log("SPELL_AURA_APPLIED", "MagmaFlowApplied", 409275)
	self:Log("SPELL_CAST_START", "LavaBolt", 397386)
	-- Flamebound Huntsman
	self:Log("SPELL_AURA_APPLIED", "BlazingSpearApplied", 401452)
	-- Obsidian Guard
	self:Log("SPELL_CAST_START", "ScorchingRoar", 408620)
	self:Log("SPELL_AURA_APPLIED", "VolcanicShieldApplied", 401867)
	self:Log("SPELL_AURA_REMOVED", "VolcanicShieldRemoved", 401867)
	-- Stage 2
	self:Log("SPELL_CAST_START", "DesperateImmolation", 397514)
	self:Log("SPELL_CAST_SUCCESS", "DesperateImmolationSuccess", 397514)
	self:Log("SPELL_AURA_APPLIED", "IgnarasFury", 406585)
	self:Log("SPELL_CAST_START", "CatastrophicSlam", 410516)
	self:Log("SPELL_CAST_START", "FlamingCudgel", 410351)
	self:Log("SPELL_AURA_APPLIED", "FlamingCudgelApplied", 410353)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FlamingCudgelApplied", 410353)
	self:Log("SPELL_AURA_REMOVED", "FlamingCudgelRemoved", 410353)
end

function mod:OnEngage()
	self:SetStage(1)
	cudgelCount = 1
	devastatingLeapCount = 1
	magmaMysticCount = 1
	zaqaliAideCount = 1
	vigorousGaleCount = 1
	phoenixRushCount = 1
	blazingFocusCount = 0
	myFlamingCudgelStacks = 0
	tempBlockBigAddMsg = false
	hasFixate, hasBeam = false, false

	self:Bar(401258, 12) -- Heavy Cudgel
	self:Bar(397383, self:Easy() and 26.5 or 28, L.add_bartext:format(L.molten_barrier, L.both, magmaMysticCount)) -- Molten Barrier
	self:Bar("stages", 28, self:SpellName(406591), "artifactability_firemage_phoenixbolt") -- Call Ignara
	self:Bar(404382, 41, L.add_bartext:format(CL.big_adds, CL.south, zaqaliAideCount)) -- Zaqali Aide

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 28 then -- Stage 2 at 25% hp
		self:UnregisterUnitEvent(event, unit)
		self:Message("stages", "cyan", CL.soon:format(CL.stage:format(2)), false)
		self:PlaySound("stages", "info")
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 406591 then -- Call Ignara (2s earlier than Ignara's Flame _APPLIED)
		self:Message("stages", "green", self:SpellName(spellId), "artifactability_firemage_phoenixbolt")
		-- self:PlaySound("stages", "alert")
	elseif spellId == 410207 or spellId == 411767 then -- south, north
		tempBlockBigAddMsg = true -- Temp workaround for new emotes added in 10.1.5
		self:SimpleTimer(function() tempBlockBigAddMsg = false end, 2)
	end
end

do
	local timer = { 5.0, 21.8, 29.2, 22.9, 21.1 } -- 40.3, 33.5, 22.9, 21.1, 5.0, 21.8, 29.2, 23.0
	local side = { "south", "south", "north", "north", "north" }
	local newIDs = false
	function mod:ZaqaliAide(args)
		if not newIDs then
			newIDs = true
			self:UnregisterEvent("RAID_BOSS_EMOTE")
			self:Error("New IDs are active.")
		end
		if args.spellId == 412820 then -- South
			self:StopBar(L.add_bartext:format(CL.big_adds, CL.south, zaqaliAideCount))
			self:Message(404382, "cyan", L.zaqali_aide_message:format(CL.big_adds, CL.south))
		else -- North
			self:StopBar(L.add_bartext:format(CL.big_adds, CL.north, zaqaliAideCount))
			self:Message(404382, "cyan", L.zaqali_aide_message:format(CL.big_adds, CL.north))
		end
		self:PlaySound(404382, "info")
		zaqaliAideCount = zaqaliAideCount + 1

		if self:GetStage() == 1 then
			local index = (zaqaliAideCount % 5) + 1
			local cd = zaqaliAideCount == 2 and 33.5 or timer[index]
			self:Bar(404382, cd, L.add_bartext:format(CL.big_adds, CL[side[index]], zaqaliAideCount))
		end
	end

	function mod:RAID_BOSS_EMOTE(_, msg)
		if msg:find(L.zaqali_aide_south_emote_trigger, nil, true) then
			if tempBlockBigAddMsg then -- Temp workaround for new mystic north/south emotes added in 10.1.5 that are detected by our basic trigger
				tempBlockBigAddMsg = false -- Hopefully the new CLEU spells will be hotfixed in soon and we can drop emote detection
				return
			else
				self:StopBar(L.add_bartext:format(CL.big_adds, CL.south, zaqaliAideCount))
				self:Message(404382, "cyan", L.zaqali_aide_message:format(CL.big_adds, CL.south))
			end
		elseif msg:find(L.zaqali_aide_north_emote_trigger, nil, true) then
			if tempBlockBigAddMsg then
				tempBlockBigAddMsg = false
				return
			else
				self:StopBar(L.add_bartext:format(CL.big_adds, CL.north, zaqaliAideCount))
				self:Message(404382, "cyan", L.zaqali_aide_message:format(CL.big_adds, CL.north))
			end
		else
			return
		end
		self:PlaySound(404382, "info")
		zaqaliAideCount = zaqaliAideCount + 1

		if self:GetStage() == 1 then
			local index = (zaqaliAideCount % 5) + 1
			local cd = zaqaliAideCount == 2 and 33.5 or timer[index]
			self:Bar(404382, cd, L.add_bartext:format(CL.big_adds, CL[side[index]], zaqaliAideCount))
		end
	end
end

do
	local prev = 0
	function mod:BarrierBackfireApplied(args)
		if args.time - prev > 3 then
			prev = args.time
			self:Message(args.spellId, "red")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

-- Ignara: casts Gale (S), Rush (S), Rush (N), Gale (N), repeat
function mod:PhoenixRush(args)
	local side = phoenixRushCount % 2 == 0 and "north" or "south"
	local msg = L.add_bartext:format(args.spellName, CL[side], phoenixRushCount)
	self:StopBar(msg)
	self:Message(args.spellId, "yellow", msg)
	self:PlaySound(args.spellId, "long")
	phoenixRushCount = phoenixRushCount + 1

	local cd = phoenixRushCount % 2 == 0 and 25 or 72 -- 25~27 / 72~74
	side = phoenixRushCount % 2 == 0 and "north" or "south"
	self:CDBar(args.spellId, cd, L.add_bartext:format(args.spellName, CL[side], phoenixRushCount))
end

function mod:BlazingFocusApplied(args)
	if self:Me(args.destGUID) then
		blazingFocusCount = blazingFocusCount + 1
		if blazingFocusCount == 1 then -- Don't spam warn when multiple are hunting you
			self:PersonalMessage(args.spellId, nil, CL.fixate)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:BlazingFocusRemoved(args)
	if self:Me(args.destGUID) then
		blazingFocusCount = blazingFocusCount - 1
	end
end

function mod:VigorousGale(args)
	local side = vigorousGaleCount % 2 == 0 and "north" or "south"
	local msg = L.add_bartext:format(CL.pushback, CL[side], vigorousGaleCount)
	self:StopBar(msg)
	self:Message(args.spellId, "red", msg)
	self:PlaySound(args.spellId, "warning")
	vigorousGaleCount = vigorousGaleCount + 1

	local cd = vigorousGaleCount % 2 == 0 and 66 or 32 -- 66~68, 32~??
	side = vigorousGaleCount % 2 == 0 and "north" or "south"
	self:CDBar(args.spellId, cd, L.add_bartext:format(CL.pushback, CL[side], vigorousGaleCount))
end

-- Warlord Kagni
function mod:IgnaraFlameApplied()
	self:Bar("stages", 23, L.boss_returns, "artifactability_firemage_phoenixbolt")
end

function mod:IgnaraFlameRemoved()
	self:StopBar(L.boss_returns)
	self:Message("stages", "green", L.boss_returns, "artifactability_firemage_phoenixbolt")
	self:PlaySound("stages", "info")

	self:Bar(401258, self:Mythic() and 18 or 12) -- Heavy Cudgel
	self:Bar(408959, 44, L.add_bartext:format(CL.leap, CL.south, devastatingLeapCount)) -- Leap: South (1)
	if self:Mythic() then
		self:CDBar(407009, 19, L.add_bartext:format(CL.pushback, CL.south, vigorousGaleCount)) -- Pushback: South (1)
		self:CDBar(401108, 40, L.add_bartext:format(self:SpellName(401108), CL.south, phoenixRushCount)) -- Phoenix Rush: South (1)
	end
end

function mod:DevastatingLeap(args)
	local side = devastatingLeapCount % 2 == 0 and "north" or "south"
	local msg = L.add_bartext:format(CL.leap, CL[side], devastatingLeapCount)
	self:StopBar(msg)
	self:Message(args.spellId, "orange", msg)
	self:PlaySound(args.spellId, "alarm")
	devastatingLeapCount = devastatingLeapCount + 1

	local cd = devastatingLeapCount % 2 == 0 and 47.5 or 53
	side = devastatingLeapCount % 2 == 0 and "north" or "south"
	self:Bar(args.spellId, cd, L.add_bartext:format(CL.leap, CL[side], devastatingLeapCount))
end

do
	local timer = { 26.0, 22.0, 31.0, 21.0 } -- 22.0, 31.0, 21.0, 26.0 repeating
	function mod:HeavyCudgel(args)
		local unit = self:UnitTokenFromGUID(args.sourceGUID)
		if not unit or self:UnitWithinRange(unit, 60) then
			self:Message(args.spellId, "purple")
			self:PlaySound(args.spellId, "alert") -- frontal
		end
		cudgelCount = cudgelCount + 1
		if cudgelCount > 2 then -- 2nd cast fired when he lands
			self:Bar(args.spellId, timer[(cudgelCount % 4) + 1])
		end
	end
end

function mod:HeavyCudgelApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(401258, "purple", args.destName, args.amount, 2)
		self:PlaySound(401258, "alarm")
	elseif self:Tank() or self:Healer() then
		local unit = self:UnitTokenFromGUID(args.sourceGUID)
		if unit and self:Tank(args.destName) and self:UnitWithinRange(unit, 45) then
			self:StackMessage(401258, "purple", args.destName, args.amount, 2)
		end
	end
end

-- Magma Mystic
do
	local prev = 0
	function mod:MoltenBarrier(args)
		if args.time - prev > 5 then
			prev = args.time
			if magmaMysticCount > 1 then
				local side = magmaMysticCount % 2 == 0 and "south" or "north"
				local msg = L.add_bartext:format(L.molten_barrier, CL[side], magmaMysticCount)
				self:StopBar(msg)
				self:Message(args.spellId, "cyan", msg)
			else -- first is on both sides
				self:StopBar(L.add_bartext:format(L.molten_barrier, L.both, magmaMysticCount))
				self:Message(args.spellId, "cyan", CL.count:format(args.spellName, magmaMysticCount))
			end
			self:PlaySound(args.spellId, "info")
			magmaMysticCount = magmaMysticCount + 1

			if self:GetStage() == 1 then
				-- local timer = { 25, 55, 55, 45, 55, 45 }
				local cd = magmaMysticCount == 2 and 55 or magmaMysticCount % 2 == 0 and 45 or 55
				local side = magmaMysticCount % 2 == 0 and "south" or "north"
				self:CDBar(args.spellId, cd, L.add_bartext:format(L.molten_barrier, CL[side], magmaMysticCount))
			end
		end
	end
end

do
	local prev = 0
	function mod:MagmaFlow(args)
		if args.time - prev > 2 then
			local unit = self:UnitTokenFromGUID(args.sourceGUID)
			if not unit or self:UnitWithinRange(unit, 45) then
				prev = args.time
				self:Message(409275, "orange")
				self:PlaySound(409275, "alert")
			end
		end
	end
end

function mod:MagmaFlowApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:LavaBolt(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "orange")
		if ready then
			self:PlaySound(args.spellId, "alert") -- interrupt
		end
	end
end

-- Flamebound Huntsman
function mod:BlazingSpearApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(401401)
		self:PlaySound(401401, "alarm") -- spread
		self:Say(401401, nil, nil, "Blazing Spear")
	end
end

-- Obsidian Guard
do
	local prev = 0
	function mod:ScorchingRoar(args)
		if args.time - prev > 2 then
			local unit = self:UnitTokenFromGUID(args.sourceGUID)
			if not unit or self:UnitWithinRange(unit, 45) then
				prev = args.time
				self:Message(args.spellId, "yellow")
				self:PlaySound(args.spellId, "alert")
			end
		end
	end
end

function mod:VolcanicShieldApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.beam)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId, CL.beam, nil, "Beam")
		self:SayCountdown(args.spellId, 5)
	end
end

function mod:VolcanicShieldRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

-- Stage 2
function mod:DesperateImmolation()
	self:SetStage(2)
	self:Message("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long")

	-- XXX boss abilities stop, but add waves can still happen?
	self:StopBar(401258) -- Heavy Cudgel
	self:StopBar(L.add_bartext:format(CL.leap, CL.south, devastatingLeapCount)) -- Devastating Leap
	self:StopBar(L.add_bartext:format(CL.leap, CL.north, devastatingLeapCount))
	self:StopBar(L.add_bartext:format(CL.pushback, CL.south, vigorousGaleCount)) -- Vigorous Gale
	self:StopBar(L.add_bartext:format(CL.pushback, CL.north, vigorousGaleCount))
	self:StopBar(L.add_bartext:format(self:SpellName(401108), CL.south, phoenixRushCount)) -- Phoenix Rush
	self:StopBar(L.add_bartext:format(self:SpellName(401108), CL.north, phoenixRushCount))

	cudgelCount = 1
	devastatingLeapCount = 1

	self:Bar(410351, 22.3, CL.count:format(self:SpellName(410351), cudgelCount)) -- Flaming Cudgel
	self:Bar(410516, 29.2, CL.count:format(L.catastrophic_slam, devastatingLeapCount)) -- Catastrophic Slam
end

function mod:DesperateImmolationSuccess()
	self:StopBar(L.add_bartext:format(CL.big_adds, CL.south, zaqaliAideCount)) -- Zaqali Aide
	self:StopBar(L.add_bartext:format(CL.big_adds, CL.north, zaqaliAideCount))
	self:StopBar(L.add_bartext:format(L.molten_barrier, CL.south, magmaMysticCount)) -- Molten Barrier
	self:StopBar(L.add_bartext:format(L.molten_barrier, CL.north, magmaMysticCount))
end

function mod:IgnarasFury(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

function mod:CatastrophicSlam(args)
	local msg = CL.count:format(L.catastrophic_slam, devastatingLeapCount)
	self:StopBar(msg)
	self:Message(args.spellId, "orange", msg)
	self:PlaySound(args.spellId, "alert") -- stack
	devastatingLeapCount = devastatingLeapCount + 1
	self:CDBar(args.spellId, 26.7, CL.count:format(L.catastrophic_slam, devastatingLeapCount))
end

do
	local timer = { 19.0, 12.0, 23.0 } -- 12.0, 23.0, 19.0 repeating
	function mod:FlamingCudgel(args)
		local msg = CL.count:format(args.spellName, cudgelCount)
		self:StopBar(msg)
		self:Message(args.spellId, "purple", msg)
		self:PlaySound(args.spellId, "alert")
		cudgelCount = cudgelCount + 1

		local cd = timer[(cudgelCount % 3) + 1]
		self:Bar(args.spellId, cd, CL.count:format(args.spellName, cudgelCount))
	end
end

function mod:FlamingCudgelApplied(args)
	local amount = args.amount or 1
	if self:Me(args.destGUID) then
		myFlamingCudgelStacks = amount
		self:StackMessage(410351, "purple", args.destName, amount, 2)
		self:PlaySound(410351, "alarm")
	elseif self:Tank() or self:Healer() then
		local playerUnit = self:UnitTokenFromGUID(args.destGUID)
		if playerUnit and self:Tank(playerUnit) then -- Applied to a tank
			self:StackMessage(410351, "purple", args.destName, args.amount, 2)
			if myFlamingCudgelStacks == 0 and amount >= 2 and self:Tank() then -- No stacks on me, 2+ stacks on other tank
				self:PlaySound(410351, "warning") -- Maybe swap?
			end
		end
	end
end

function mod:FlamingCudgelRemoved(args)
	if self:Me(args.destGUID) then
		myFlamingCudgelStacks = 0
	end
end
