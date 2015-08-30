
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Iron Reaver", 1026, 1425)
if not mod then return end
mod:RegisterEnableMob(90284)
mod.engageId = 1785
mod.respawnTime = 35.5 -- 30s respawn & 5.5s activation

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local barrageCount = 1
--local artilleryCount = 1
local blitzCount = 1
local poundingCount = 1
local firebombCount = 1
local orbCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Ground Operation ]]--
		182020, -- Pounding
		185282, -- Barrage
		182001, -- Unstable Orb
		179889, -- Blitz
		182055, -- Full Charge
		--[[ Air Operation ]]--
		181999, -- Firebomb
		--182534, -- Volatile Firebomb
		--186667, -- Burning Firebomb
		--186676, -- Reactive Firebomb
		--186652, -- Quick-Fuse Firebomb
		182066, -- Falling Slam
		--[[ General ]]--
		{182280, "PROXIMITY", "FLASH", "SAY"}, -- Artillery
		182074, -- Immolation
		"proximity",
		"berserk",
	}, {
		[182020] = -11393, -- Ground Operation
		[181999] = -11394, -- Air Operation
		[182280] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Artillery", 182280)
	self:Log("SPELL_AURA_REFRESH", "Artillery", 182280) -- Very rarely casted on the same person, usually due to deaths
	self:Log("SPELL_AURA_REMOVED", "ArtilleryRemoved", 182280)
	self:Log("SPELL_AURA_APPLIED", "Pounding", 182020)
	self:Log("SPELL_CAST_START", "Barrage", 185282)
	self:Log("SPELL_CAST_START", "FallingSlam", 182066)
	self:Log("SPELL_CAST_SUCCESS", "FallingSlamSuccess", 182066)
	self:Log("SPELL_CAST_START", "Blitz", 179889)
	self:Log("SPELL_CAST_START", "FullCharge", 182055)
	self:Log("SPELL_CAST_START", "Firebomb", 181999)

	self:Log("SPELL_AURA_APPLIED", "UnstableOrb", 182001)
	self:Log("SPELL_AURA_APPLIED_DOSE", "UnstableOrb", 182001)
	self:Log("SPELL_AURA_APPLIED", "ImmolationDamage", 182074)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ImmolationDamage", 182074)
end

function mod:OnEngage()
	phase = 1
	barrageCount = 1
	--artilleryCount = 1
	blitzCount = 1
	poundingCount = 1
	firebombCount = 1
	orbCount = 1

	if not self:LFR() then -- LFR still only has two air phases
		self:Berserk(600)
	end
	--self:Bar(182280, self:Easy() and 23.3 or 10.3) -- Artillery APPLICATION
	self:Bar(182001, 8.5) -- Unstable Orb
	self:Bar(185282, 13.3, CL.count:format(self:SpellName(185282), barrageCount)) -- Barrage
	self:Bar(182020, 34.4, CL.count:format(self:SpellName(182020), poundingCount)) -- Pounding
	self:Bar(179889, 64.3) -- Blitz
	self:Bar(182055, 139) -- Full Charge
	if self:Ranged() and not self:LFR() then
		self:OpenProximity("proximity", 8)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	-- local timers = {0, 9, 30, 15, 9, 24, 15} -- 15s during p2
	-- local timersNormalLFR = {0, 39, 15, 33, 15} -- 15s during p2
	local playerList, proxList, isOnMe = mod:NewTargetList(), {}, nil
	function mod:Artillery(args)
		if self:Me(args.destGUID) then
			isOnMe = true
			self:Flash(args.spellId)
			self:Say(args.spellId)
			if not self:LFR() then
				self:ScheduleTimer("Say", 9, args.spellId, 4, true)
				self:ScheduleTimer("Say", 10, args.spellId, 3, true)
				self:ScheduleTimer("Say", 11, args.spellId, 2, true)
				self:ScheduleTimer("Say", 12, args.spellId, 1, true)
			end
			self:TargetBar(args.spellId, 13, args.destName)
			self:OpenProximity(args.spellId, 40)
			if phase == 2 then
				self:StopBar(args.spellName) -- Cancel non-personal bar if it's started, we start a personal one above
			end
		end

		if phase == 2 then
			proxList[#proxList+1] = args.destName
			if not isOnMe then
				self:OpenProximity(args.spellId, 40, proxList)
			end

			playerList[#playerList+1] = args.destName
			if #playerList == 1 then
				self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Urgent", "Warning")
				if not isOnMe then -- Personal bar when on you
					self:Bar(args.spellId, 13)
				end
			end
		else
			self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, self:Tank())
			if not self:Me(args.destGUID) then -- Check again as isOnMe can be true when this lands on someone else
				self:TargetBar(args.spellId, 13, args.destName)
				if self:Melee() then
					if not tContains(proxList, args.destName) then
						proxList[#proxList+1] = args.destName
					end
					if not isOnMe then -- Don't change proximity if it's on you and was applied to someone else also
						self:OpenProximity(args.spellId, 40, proxList)
					end
				end
			end
			-- Do we care about application timers?
			-- Expiry is the real concern, are application timers important enough
			-- to potentially distract/confuse from expiry timers?
			-- Commented out for now
			--artilleryCount = artilleryCount + 1
			--local timer = self:Easy() and timersNormalLFR[artilleryCount] or timers[artilleryCount]
			--if timer then
			--	self:Bar(args.spellId, timer)
			--end
		end
	end

	function mod:ArtilleryRemoved(args)
		if self:Me(args.destGUID) then
			isOnMe = nil
			self:StopBar(args.spellName, args.destName)
			self:CloseProximity(args.spellId)
			if phase == 1 and self:Ranged() and not self:LFR() then
				self:OpenProximity("proximity", 8)
			end
		elseif phase == 1 then
			self:StopBar(args.spellName, args.destName)
		end

		if (phase == 1 and self:Melee()) or phase == 2 then
			tDeleteItem(proxList, args.destName)
			if not isOnMe then -- Don't change proximity if it's on you and expired on someone else
				if #proxList == 0 then
					self:CloseProximity(args.spellId)
				else
					self:OpenProximity(args.spellId, 40, proxList)
				end
			end
		end
	end
end

do
	local timers = {0, 54, 24}
	function mod:Pounding(args)
		self:Message(args.spellId, "Attention", "Long", CL.count:format(args.spellName, poundingCount))
		poundingCount = poundingCount + 1
		if timers[poundingCount] then
			self:Bar(args.spellId, timers[poundingCount], CL.count:format(args.spellName, poundingCount))
		end
	end
end

do
	local timers = {0, 30, 12, 45}
	function mod:Barrage(args)
		self:Message(args.spellId, "Attention", "Long", CL.count:format(args.spellName, barrageCount))
		barrageCount = barrageCount + 1
		if timers[barrageCount] then
			self:Bar(args.spellId, timers[barrageCount], CL.count:format(args.spellName, barrageCount))
		end
	end
end

do
	local prev = 0
	function mod:UnstableOrb(args)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
		end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			orbCount = orbCount + 1
			local timer = 24
			if orbCount == 2 then
				timer = 18
			end
			self:Bar(args.spellId, timer)
		end
	end
end

do
	local prev = 0
	function mod:ImmolationDamage(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

function mod:FallingSlam(args)
	self:Message(args.spellId, "Important", "Info")
	self:Bar(args.spellId, self:Easy() and 9 or 6, CL.cast:format(args.spellName))
end

function mod:FallingSlamSuccess(args)
	phase = 1
	blitzCount = 1
	barrageCount = 1
	poundingCount = 1
	--artilleryCount = 1
	orbCount = 1

	self:CDBar(182001, 9) -- Unstable Orb 9-11
	self:Bar(179889, 65.8) -- Blitz
	self:Bar(185282, 14.8) -- Barrage
	self:Bar(182020, 35.8) -- Pounding
	--self:Bar(182280, self:Easy() and 11.7 or 9.3) -- Artillery APPLICATION
	self:Bar(182055, 140) -- Full Charge
	if self:Ranged() and not self:LFR() then
		self:OpenProximity("proximity", 8)
	end
end

function mod:Blitz(args)
	self:Message(args.spellId, "Important", "Info")
	if blitzCount == 2 then -- Blitz is casted twice each cooldown, show the bar after the second
		self:Bar(args.spellId, 58)
	end
	blitzCount = blitzCount + 1
end

function mod:FullCharge(args)
	self:StopBar(182001) -- Unstable Orb

	phase = 2
	firebombCount = 1
	self:Message(args.spellId, "Important", "Info")
	--self:Bar(182280, 9) -- Artillery APPLICATION
	self:Bar(181999, 11, CL.count:format(self:SpellName(181999), firebombCount)) -- Firebomb
	self:Bar(182066, 54) -- Falling Slam
	if self:Ranged() and not self:LFR() then
		self:CloseProximity("proximity")
	end
end

function mod:Firebomb(args)
	self:Message(args.spellId, "Important", "Alarm", CL.count:format(args.spellName, firebombCount))
	firebombCount = firebombCount + 1
	if firebombCount < 4 then
		self:Bar(args.spellId, 15, CL.count:format(args.spellName, firebombCount))
	end
end

