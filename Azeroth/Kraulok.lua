
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Dunegorger Kraulok", -864, 2210)
if not mod then return end
mod:RegisterEnableMob(138794)
mod.otherMenu = -947
mod.worldBoss = 138794

--------------------------------------------------------------------------------
-- Locals
--

--local castCollector = {} -- for all UNIT casts

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		276046, -- Shake Loose
		275200, -- Primal Rage
		--275194, -- Earth Spike
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	--self:RegisterEvent("BOSS_KILL") -- No event

	self:Log("SPELL_CAST_START", "ShakeLoose", 276046)
	self:Log("SPELL_CAST_START", "PrimalRage", 275200)
	--self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED") -- Seems to only fire once

	self:Death("Win", 138794)
end

function mod:OnEngage()
	--castCollector = {}
	self:CheckForWipe()
	self:CDBar(276046, 25) -- Shake Loose
	self:CDBar(275200, 39) -- Primal Rage
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--function mod:BOSS_KILL(_, id)
--	if id == XXX then
--		self:Win()
--	end
--end

function mod:ShakeLoose(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
	self:CDBar(args.spellId, 28)
end

function mod:PrimalRage(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "info")
	self:CDBar(args.spellId, 33)
end

--do
--	local prev = 0
--	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, castGUID, spellId)
--		if castCollector[castGUID] then return end -- don't fire twice for the same cast
--
--		if spellId == 275194 then -- Earth Spike
--			castCollector[castGUID] = true
--			local t = GetTime()
--			if t-prev > 0.5 then
--				prev = t
--				self:Message(spellId, "orange")
--				self:PlaySound(spellId, "warning")
--				self:CDBar(spellId, 12)
--			end
--		end
--	end
--end
