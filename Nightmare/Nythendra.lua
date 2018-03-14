
--------------------------------------------------------------------------------
-- TODO List:
-- - Get/Confirm timers for all difficulties on live
--   LFR (✘) - Normal (✘) - Heroic (✔) - Mythic (✘)
--
-- - Rot: CD is 15.8s - sometimes gets delayed, then its ~24s, no idea why

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nythendra", 1520, 1703)
if not mod then return end
mod:RegisterEnableMob(102672)
mod.engageId = 1853
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local rotCount = 1
local myInfestedStacks = 0
local infestedStacks = {}

--------------------------------------------------------------------------------
-- Initialization
--

local rotMarker = mod:AddMarkerOption(false, "player", 1, 203096, 1, 2, 3, 4, 5) -- Rot
function mod:GetOptions()
	return {
		--[[ General ]]--
		202977, -- Infested Breath
		{203096, "SAY", "FLASH", "PROXIMITY"}, -- Rot
		rotMarker,
		{204463, "SAY", "FLASH", "ICON"}, -- Volatile Rot
		203552, -- Heart of the Swarm
		203045, -- Infested Ground
		"berserk",

		--[[ Mythic ]]--
		{204504, "INFOBOX"}, -- Infested
		{225943, "SAY", "FLASH"}, -- Infested Mind
		205070, -- Spread Infestation
	},{
		[202977] = "general",
		[204504] = "mythic",
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterUnitEvent("UNIT_SPELLCAST_START", nil, "boss1")
	self:Log("SPELL_AURA_APPLIED", "Rot", 203096)
	self:Log("SPELL_AURA_REMOVED", "RotRemoved", 203096)
	self:Log("SPELL_AURA_APPLIED", "VolatileRot", 204463)
	self:Log("SPELL_AURA_REMOVED", "VolatileRotRemoved", 204463)
	self:Log("SPELL_CAST_START", "HeartOfTheSwarm", 203552)
	self:Log("SPELL_AURA_APPLIED", "InfestedGroundDamage", 203045)
	self:Log("SPELL_PERIODIC_DAMAGE", "InfestedGroundDamage", 203045)
	self:Log("SPELL_PERIODIC_MISSED", "InfestedGroundDamage", 203045)

	--[[ Mythic ]]--
	self:Log("SPELL_AURA_APPLIED_DOSE", "Infested", 204504) -- also on hc, but i don't think it's relevant there
	self:Log("SPELL_AURA_REMOVED", "InfestedRemoved", 204504)
	self:Log("SPELL_CAST_START", "InfestedMindCast", 225943)
end

function mod:OnEngage()
	rotCount = 1
	myInfestedStacks = 0
	wipe(infestedStacks)
	self:Berserk(self:Normal() and 600 or 480) -- Can be delayed by 2nd phase
	self:CDBar(203096, 5.8) -- Rot
	self:CDBar(204463, 22.8) -- Volatile Rot
	self:CDBar(202977, 37) -- Infested Breath
	self:CDBar(203552, 90) -- Heart of the Swarm
	if self:Mythic() then
		self:OpenInfo(204504, self:SpellName(204504)) -- Infested
		self:Bar(225943, 49) -- Infested Mind
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_START(_, spellName, _, _, spellId)
	if spellId == 202977 then -- Infested Breath
		self:Message(spellId, "Urgent", "Alarm", CL.casting:format(spellName))
		self:CastBar(spellId, 8) -- 3s cast time + 5s channel

		if self:BarTimeLeft(203552) > 37 then -- Heart of the Swarm
			self:CDBar(spellId, 37)
		end
	end
end

do
	local playerList, proxList, isOnMe = mod:NewTargetList(), {}, nil
	function mod:Rot(args)
		if self:Me(args.destGUID) then
			isOnMe = true
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:TargetBar(args.spellId, 9, args.destName)
			self:OpenProximity(args.spellId, 10)
			self:SayCountdown(args.spellId, 9)
		end

		proxList[#proxList+1] = args.destName
		if not isOnMe then
			self:OpenProximity(args.spellId, 10, proxList)
		end
		if self:GetOption(rotMarker) then
			SetRaidTarget(args.destName, #proxList)
		end

		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, playerList, "Important", "Warning")
			rotCount = rotCount + 1

			if self:BarTimeLeft(203552) > 15.9 then -- Heart of the Swarm
				self:Bar(args.spellId, 15.9)
			end
		end
	end

	function mod:RotRemoved(args)
		if self:Me(args.destGUID) then
			isOnMe = nil
			self:StopBar(args.spellName, args.destName)
			self:CloseProximity(args.spellId)
			self:CancelSayCountdown(args.spellId)
		end

		if self:GetOption(rotMarker) then
			SetRaidTarget(args.destName, 0)
		end
		tDeleteItem(proxList, args.destName)

		if not isOnMe then -- Don't change proximity if it's on you and expired on someone else
			if #proxList == 0 then
				self:CloseProximity(args.spellId)
			else
				self:OpenProximity(args.spellId, 10, proxList)
			end
		end
	end
end

function mod:VolatileRot(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:Flash(args.spellId)
	end
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, self:Tank())
	self:TargetBar(args.spellId, 8, args.destName)
	if self:BarTimeLeft(203552) > 23 then -- Heart of the Swarm
		self:CDBar(args.spellId, 23)
	end
end

function mod:VolatileRotRemoved(args)
	self:PrimaryIcon(args.spellId)
end

function mod:HeartOfTheSwarm(args)
	self:Message(args.spellId, "Neutral", "Info", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 23.7) -- 3.7s cast time + 20s channel
	-- This is basically a phase, so start timers for next "normal" phase here
	self:CDBar(args.spellId, 120)
	self:CDBar(203096, 36.5) -- Rot, 23.7 + 12.8
	self:CDBar(204463, 52.7) -- Volatile Rot, 23.7 + 29
	self:CDBar(202977, 68) -- Infested Breath, 23.7 + 44.3
	if self:Mythic() then
		self:CDBar(225943, 80) -- Infested Mind
	end
	rotCount = 1
end

do
	local prev = 0
	function mod:InfestedGroundDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

do
	local prev = 0
	function mod:Infested(args)
		if self:Mythic() then
			infestedStacks[args.destName] = args.amount
			if self:Me(args.destGUID) then
				if args.amount > 6 and args.amount < 11 then -- be careful at 7-9, at 10 you're getting mc'd
					self:StackMessage(args.spellId, args.destName, args.amount, "Personal", "Warning")
				end
				myInfestedStacks = args.amount
			end
			local t = GetTime()
			if t-prev > 2 then
				prev = t
				self:SetInfoByTable(args.spellId, infestedStacks)
			end
		end
	end
end

function mod:InfestedRemoved(args)
	if self:Mythic() then
		infestedStacks[args.destName] = nil
		if self:Me(args.destGUID) then
			myInfestedStacks = 0
		end
	end
end

function mod:InfestedMindCast(args)
	if myInfestedStacks > 9 then
		self:Message(args.spellId, "Personal", "Long", CL.you:format(args.spellName))
		self:Flash(args.spellId)
		self:Say(args.spellId)
	else
		self:Message(args.spellId, "Attention", "Long", CL.incoming:format(args.spellName))
	end

	self:CastBar(args.spellId, 3)

	if self:BarTimeLeft(203552) > 36 then -- Heart of the Swarm
		self:CDBar(args.spellId, 36)
	end
end
