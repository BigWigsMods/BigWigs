--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Huntsman Altimor", 2296, 2429)
if not mod then return end
mod:RegisterEnableMob(
	165066, -- Huntsman Altimor
	165067, -- Margore
	169457, -- Bargast
	169458) -- Hecutis
mod.engageId = 2418
mod.respawnTime = 30
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local sinseekerCount = 1
local bloodyThrashCount = 1
local ripSoulCount = 1
local shadesOfBargastCount = 1
local petrifyingHowlCount = 1
local mobCollector = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.killed = "%s Killed"
end

--------------------------------------------------------------------------------
-- Initialization
--

local sinseekerMarker = mod:AddMarkerOption(false, "player", 1, 335114, 1, 2, 3) -- Sinseeker
local shadesofBargastMarker = mod:AddMarkerOption(false, "npc", 4, 334757, 4, 5) -- Shades of Bargast
function mod:GetOptions()
	return {
		"stages",
		--[[ Huntsman Altimor ]]--
		{335114, "SAY", "SAY_COUNTDOWN", "FLASH", "ME_ONLY_EMPHASIZE"}, -- Sinseeker
		sinseekerMarker,
		334404, -- Spreadshot

		--[[ Margore ]]--
		{334971, "TANK"}, -- Jagged Claws
		{334945, "SAY", "SAY_COUNTDOWN", "ICON"}, -- Vicious Lunge

		--[[ Bargast ]]--
		{334797, "TANK_HEALER"}, -- Rip Soul
		334884, -- Devour Soul
		334757, -- Shades of Bargast
		shadesofBargastMarker,
		-- 334708, -- Deathly Roar

		--[[ Hecutis ]]--
		{334860, "TANK_HEALER"}, -- Crushing Stone
		{334852, "SAY", "SAY_COUNTDOWN", "FLASH"}, -- Petrifying Howl
		334893, -- Stone Shards
	}, {
		[335114] = -22309, -- Huntsman Altimor
		[334971] = -22312, -- Margore
		[334797] = -22311, -- Bargast
		[334860] = -22310, -- Hecutis
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	--[[ Huntsman Altimor ]]--
	self:Log("SPELL_CAST_START", "Sinseeker", 335114)
	self:Log("SPELL_AURA_APPLIED", "HuntsmansMarkApplied", 335111, 335112, 335113) -- Targets 1 -> 2 -> 3
	self:Log("SPELL_AURA_REMOVED", "HuntsmansMarkRemoved", 335111, 335112, 335113)
	self:Log("SPELL_CAST_START", "Spreadshot", 334404)

	--[[ Margore ]]--
	self:Log("SPELL_CAST_SUCCESS", "JaggedClaws", 334971)
	self:Log("SPELL_AURA_APPLIED", "JaggedClawsApplied", 334971)
	self:Log("SPELL_AURA_APPLIED_DOSE", "JaggedClawsApplied", 334971)
	self:Log("SPELL_AURA_APPLIED", "ViciousLungeApplied", 334945)
	self:Log("SPELL_AURA_REMOVED", "ViciousLungeRemoved", 334945)
	self:Death("MargoreDeath", 165067)

	--[[ Bargast ]]--
	self:Log("SPELL_CAST_START", "RipSoulStart", 334797)
	self:Log("SPELL_CAST_SUCCESS", "RipSoul", 334797)
	self:Log("SPELL_AURA_APPLIED", "DevourSoul", 334884)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DevourSoul", 334884)
	self:Log("SPELL_CAST_START", "ShadesOfBargast", 334757)
	-- self:Log("SPELL_CAST_START", "DeathlyRoar", 334708)
	-- self:Death("ShadeOfBargastDeath", 171557)
	self:Death("BargastDeath", 169457)

	--[[ Hecutis ]]--
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrushingStone", 334860)
	self:Log("SPELL_CAST_SUCCESS", "PetrifyingHowl", 334852)
	self:Log("SPELL_AURA_APPLIED", "PetrifyingHowlApplied", 334852)
	self:Log("SPELL_AURA_REMOVED", "PetrifyingHowlRemoved", 334852)
	self:Death("HecutisDeath", 169458)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 334893) -- Stone Shards
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 334893)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 334893)
end

function mod:OnEngage()
	sinseekerCount = 1
	bloodyThrashCount = 1
	ripSoulCount = 1
	shadesOfBargastCount = 1
	petrifyingHowlCount = 1
	mobCollector = {}
	self:SetStage(1)

	self:Bar(334404, 6.5) -- Spreadshot
	self:Bar(334971, 10) -- Jagged Claws
	self:Bar(334945, 23.5, CL.count:format(self:SpellName(334945), bloodyThrashCount)) -- Vicious Lunge
	self:Bar(335114, 28.5, CL.count:format(self:SpellName(335114), sinseekerCount)) -- Sinseeker
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellId)
	if spellId == 334504 then -- Huntsman's Bond
		local sourceGUID = self:UnitGUID(unit)
		if self:MobId(sourceGUID) == 165066 then -- Huntsman Altimor
			local stage = self:GetStage() + 1
			self:SetStage(stage)
			if stage == 2 then -- Bargast up
				ripSoulCount = 1
				shadesOfBargastCount = 1

				self:Bar(334797, 9.5, CL.count:format(self:SpellName(334797), ripSoulCount)) -- Rip Soul
				self:Bar(334757, 17.5, CL.count:format(self:SpellName(334757), shadesOfBargastCount)) -- Shades Of Bargast
			elseif stage == 3 then -- Hecutis up
				petrifyingHowlCount = 1

				self:Bar(334852, 16.2, CL.count:format(self:SpellName(334852), petrifyingHowlCount)) -- Petrifying Howl
			end
		end
	end
end

--[[ Huntsman Altimor ]]--

do
	local timers = {51, 60, 64, 24}
	function mod:Sinseeker(args)
		self:StopBar(CL.count:format(args.spellName, sinseekerCount))
		self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(args.spellName, sinseekerCount)))
		sinseekerCount = sinseekerCount + 1
		local cd = timers[self:GetStage()]
		self:Bar(args.spellId, cd, CL.count:format(args.spellName, sinseekerCount))
	end
end

do
	local playerList, playerIcons = mod:NewTargetList(), {}
	function mod:HuntsmansMarkApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerIcons[count] = count
		if self:Me(args.destGUID) then
			self:Say(335114, CL.count_rticon:format(self:SpellName(335114), count, count))
			self:SayCountdown(335114, 5.7, count) -- _applied to damage, varys with distance
			self:PlaySound(335114, "warning")
			self:Flash(335114)
		end
		self:CustomIcon(sinseekerMarker, args.destName, count)
		self:TargetsMessage(335114, "orange", playerList, 3, CL.count:format(self:SpellName(335114), sinseekerCount-1), nil, 2, playerIcons) -- Debuffs are very delayed
	end
end

function mod:HuntsmansMarkRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(335114)
	end

	self:CustomIcon(sinseekerMarker, args.destName)
end

function mod:Spreadshot(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	if self:GetStage() < 4 then -- spams in p4 every few seconds
		self:Bar(args.spellId, 12.2)
	end
end

--[[ Margore ]]--

function mod:JaggedClaws(args)
	self:CDBar(args.spellId, 20) -- _SUCCESS to _START
end

function mod:JaggedClawsApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	if amount > 1 then
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:ViciousLungeApplied(args)
	self:TargetMessage(args.spellId, "orange", args.destName, CL.count:format(args.spellName, bloodyThrashCount))
	self:PrimaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Yell(args.spellId)
		self:YellCountdown(args.spellId, 6)
	end
	bloodyThrashCount = bloodyThrashCount + 1
	self:Bar(args.spellId, 25, CL.count:format(args.spellName, bloodyThrashCount))
end

function mod:ViciousLungeRemoved(args)
	self:PrimaryIcon(args.spellId)
	if self:Me(args.destGUID) then
		self:CancelYellCountdown(args.spellId)
	end
end

function mod:MargoreDeath()
	self:Message("stages", "cyan", L.killed:format(self:SpellName(-22312)), false) -- Margore

	self:StopBar(334971) -- Jagged Claws
	self:StopBar(CL.count:format(self:SpellName(334945), bloodyThrashCount)) -- Bloody Thrash

	self:Bar("stages", 6, -22311, 334797) -- Bargast, Rip Soul icon
	self:Bar(335114, 38.5, CL.count:format(self:SpellName(335114), sinseekerCount)) -- Sinseeker
end

--[[ Bargast ]]--

function mod:RipSoulStart(args)
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(args.spellName, ripSoulCount)))
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, 2.5, CL.count:format(args.spellName, ripSoulCount))
	ripSoulCount = ripSoulCount + 1
	self:Bar(args.spellId, 31, CL.count:format(args.spellName, ripSoulCount))
end

function mod:RipSoul(args)
	if self:Healer() then
		self:Message(args.spellId, "green", CL.spawned:format(args.spellName)) -- probably need a better name
		self:PlaySound(args.spellId, "info")
	end
end

function mod:DevourSoul(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

do
	local shadesofBargastMarked = 0
	function mod:shadesofBargastMarking(event, unit, guid)
		if self:MobId(guid) == 171557 and not mobCollector[guid] then
			shadesofBargastMarked = shadesofBargastMarked + 1
			self:CustomIcon(shadesofBargastMarker, unit, shadesofBargastMarked+3)
			mobCollector[guid] = true
			if shadesofBargastMarked == 2 then
				self:UnregisterTargetEvents()
			end
		end
	end

	function mod:ShadesOfBargast(args)
		self:Message(args.spellId, "green", CL.incoming:format(CL.count:format(args.spellName, shadesOfBargastCount)))
		self:PlaySound(args.spellId, "long")
		shadesOfBargastCount = shadesOfBargastCount + 1
		self:Bar(args.spellId, 61, CL.count:format(args.spellName, shadesOfBargastCount))
		if self:GetOption(shadesofBargastMarker) then
			shadesofBargastMarked = 0
			self:RegisterTargetEvents("shadesofBargastMarking")
			self:ScheduleTimer("UnregisterTargetEvents", 10)
		end
	end
end

-- do
-- 	local prev = 0
-- 	function mod:DeathlyRoar(args)
-- 		local t = args.time
-- 		if t-prev > 10 then
-- 			prev = t
-- 			self:Message(args.spellId, "red")
-- 			self:PlaySound(args.spellId, "info")
-- 			self:CastBar(args.spellId, 6)
-- 			self:Bar(args.spellId, 36.5)
-- 		end
-- 	end
-- end

-- function mod:ShadeOfBargastDeath(args)
-- 	self:StopBar(CL.cast:format(self:SpellName(334708)))
-- end

function mod:BargastDeath()
	self:Message("stages", "cyan", L.killed:format(self:SpellName(-22311)), false) -- Bargast

	self:StopBar(CL.count:format(self:SpellName(334797), ripSoulCount)) -- Rip Soul
	self:StopBar(CL.count:format(self:SpellName(334757), shadesOfBargastCount)) -- Shades Of Bargast

	self:Bar("stages", 6, -22310, 334852) -- Hecutis, Petrifying Howl icon
	self:Bar(335114, 34, CL.count:format(self:SpellName(335114), sinseekerCount)) -- Sinseeker
end

--[[ Hecutis ]]--

function mod:CrushingStone(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	if args.amount > 2 then
		self:PlaySound(args.spellId, "info")
	end
end

function mod:PetrifyingHowl(args)
	petrifyingHowlCount = petrifyingHowlCount + 1
	self:Bar(args.spellId, self:Mythic() and 30 or 20.5, CL.count:format(args.spellName, petrifyingHowlCount))
end

do
	local playerList = mod:NewTargetList()
	function mod:PetrifyingHowlApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 8)
			self:Flash(args.spellId)
			self:TargetBar(args.spellId, 8, args.destName)
		end
		self:TargetsMessage(args.spellId, "orange", playerList, 3, CL.count:format(args.spellName, petrifyingHowlCount-1), nil, 1) -- Travel time on debuffs?
	end

	function mod:PetrifyingHowlRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
			self:StopBar(args.spellId, args.destName)
		end
	end
end

function mod:HecutisDeath()
	self:Message("stages", "cyan", L.killed:format(self:SpellName(-22310)), false) -- Hecutis

	self:StopBar(CL.count:format(self:SpellName(334852), petrifyingHowlCount)) -- Petrifying Howl

	self:SetStage(4)
	self:Bar(335114, 6.5, CL.count:format(self:SpellName(335114), sinseekerCount)) -- Sinseeker
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
