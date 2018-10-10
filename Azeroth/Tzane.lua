
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("T'zane", -863, 2139)
if not mod then return end
mod:RegisterEnableMob(132701)
mod.otherMenu = -947
mod.worldBoss = 132701

--------------------------------------------------------------------------------
-- Locals
--

local playerList = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{262004, "TANK"}, -- Crushing Slam
		261552, -- Terror Wail
		261600, -- Coalesced Essence
		{261605, "SAY", "PROXIMITY"}, -- Consuming Spirits
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")

	self:Log("SPELL_CAST_START", "CrushingSlam", 262004)
	self:Log("SPELL_CAST_SUCCESS", "CrushingSlamSuccess", 262004)
	self:Log("SPELL_CAST_START", "TerrorWail", 261552)
	self:Log("SPELL_CAST_SUCCESS", "CoalescedEssence", 261600)
	self:Log("SPELL_AURA_APPLIED", "ConsumingSpirits", 261605)
	self:Log("SPELL_AURA_REMOVED", "ConsumingSpiritsRemoved", 261605)
end

function mod:OnEngage()
	playerList = self:NewTargetList()
	self:CheckForWipe()
	self:CDBar(262004, 22) -- Crushing Slam
	self:CDBar(261552, 11) -- Terror Wail
	self:CDBar(261600, 8.5) -- Coalesced Essence
	self:CDBar(261605, 19) -- Consuming Spirits
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 2121 then
		self:Win()
	end
end

function mod:CrushingSlam(args)
	self:Message2(args.spellId, "purple", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "warning")
	self:CDBar(args.spellId, 23) -- pull:22.7, 23.0, 30.1, 22.8, 26.1
end

function mod:CrushingSlamSuccess(args)
	self:TargetMessage2(args.spellId, "purple", args.destName)
	self:PlaySound(args.spellId, "warning")
end

function mod:TerrorWail(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
	self:CDBar(args.spellId, 23) -- pull:11.9, 26.5, 26.1, 22.6, 26.3, 24.3
end

function mod:CoalescedEssence(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "info")
	self:CDBar(args.spellId, 24) -- pull:8.7, 23.7, 24.9, 26.5, 24.5, 24.3
end

function mod:ConsumingSpirits(args)
	playerList[#playerList+1] = args.destName
	self:TargetsMessage(args.spellId, "orange", playerList, 2)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm")
		self:Say(args.spellId)
		self:OpenProximity(args.spellId, 8)
	end
	if #playerList == 1 then -- No SUCCESS event
		self:CDBar(args.spellId, 21) -- pull:19.5, 0.0, 33.6, 0.0, 18.8, 0.0, 22.7, 0.0, 26.3, 0.0, 24.3, 0.0
	end
end

function mod:ConsumingSpiritsRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end
