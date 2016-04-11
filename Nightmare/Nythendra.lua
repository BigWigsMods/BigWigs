--------------------------------------------------------------------------------
-- TODO List:
-- - difficulties other than heroic
-- - fix mythic stuff after testing
-- - timers are from alpha, some did highly vary

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nythendra", 1520)
if not mod then return end
mod:RegisterEnableMob(102672)
mod.engageId = 1853
mod.respawnTime = 30 -- might not be accurate

--------------------------------------------------------------------------------
-- Locals
--

local rotCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ General ]]--
		202977, -- Infested Breath
		{203096, "SAY", "FLASH", "PROXIMITY"}, -- Rot
		{204463, "SAY", "FLASH"}, -- Volatile Rot
		203552, -- Heart of the Swarm
		203045, -- Infested Ground
		"berserk",

		--[[ Mythic ]]--
		204504, -- Infested
		205043, -- Infested Mind
	},{
		[202977] = "general",
		[204504] = "mythic",
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:Log("SPELL_CAST_START", "InfestedBreath", 202977)
	self:Log("SPELL_AURA_APPLIED", "Rot", 203096)
	self:Log("SPELL_AURA_REMOVED", "RotRemoved", 203096)
	self:Log("SPELL_AURA_APPLIED", "VolatileRot", 204463)
	self:Log("SPELL_CAST_START", "HeartOfTheSwarm", 203552)
	self:Log("SPELL_AURA_APPLIED", "InfestedGroundDamage", 203045)
	self:Log("SPELL_PERIODIC_DAMAGE", "InfestedGroundDamage", 203045)
	self:Log("SPELL_PERIODIC_MISSED", "InfestedGroundDamage", 203045)

	--[[ Mythic ]]--
	self:Log("SPELL_AURA_APPLIED_DOSE", "Infested", 204504) -- also on hc, but i don't think it's relevant
	self:Log("SPELL_AURA_APPLIED", "InfestedMind", 205043) -- pre alpha mythic testing spell id
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Nythendra (Alpha) Engaged (Post Alpha Test Mod)", 23074) -- some red dragon icon
	rotCount = 1
	self:Berserk(720) -- 12 minutes on heroic, not kidding
	self:CDBar(203096, 10.5) -- Rot
	self:CDBar(204463, 22) -- Volatile Rot
	self:CDBar(202977, 38) -- Infested Breath
	self:CDBar(203552, 90) -- Heart of the Swarm
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:InfestedBreath(args)
	self:Message(args.spellId, "Urgent", "Alarm", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 7, CL.cast:format(args.spellName)) -- 2s cast time + 5s channel
	self:CDBar(args.spellId, 37)  -- alpha heroic timing, did vary between 37-41, sometimes skipped (bug most likely)
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
			self:ScheduleTimer("Say", 6, args.spellId, 3, true)
			self:ScheduleTimer("Say", 7, args.spellId, 2, true)
			self:ScheduleTimer("Say", 8, args.spellId, 1, true)
		end

		proxList[#proxList+1] = args.destName
		if not isOnMe then
			self:OpenProximity(args.spellId, 10, proxList)
		end

		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, playerList, "Important", "Alert")
			rotCount = rotCount + 1
			self:CDBar(args.spellId, rotCount == 2 and 34 or 21)  -- alpha heroic timing, 2. did vary between 34-37, 3. between 20-23
		end
	end

	function mod:RotRemoved(args)
		if self:Me(args.destGUID) then
			isOnMe = nil
			self:StopBar(args.spellName, args.destName)
			self:CloseProximity(args.spellId)
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
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Info", nil, nil, self:Tank())
	self:TargetBar(args.spellId, 8, args.destName)
	self:CDBar(args.spellId, 23) -- alpha heroic timing, did vary between 23-28
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:Flash(args.spellId)
	end
end

function mod:HeartOfTheSwarm(args)
	self:Message(args.spellId, "Attention", "Long", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 22.5, CL.cast:format(args.spellName)) -- 2.5s cast time + 20s channel
	-- This is basically a phase, so start timers for next "normal" phase here
	self:CDBar(args.spellId, 115) -- alpha heroic timing, did vary between 114-118
	self:CDBar(203096, 37.5) -- Rot				22.5 + 15, alpha heroic timing
	self:CDBar(204463, 47.5) -- Volatile Rot	22.5 + 25, alpha heroic timing, did vary between 22-30 (+22.5)
	self:CDBar(202977, 61.5) -- Infested Breath	22.5 + 39, alpha heroic timing, did vary between 39-42 (+22.5)
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

function mod:Infested(args)
	if self:Mythic() and self:Me(args.destGUID) and args.amount > 6 then
		self:StackMessage(args.spellId, args.destName, amount, "Personal", "Warning")
	end
end

function mod:InfestedMind(args)
	self:TargetMessage(args.spellId, args.destName, "Important", "Alert")
end

