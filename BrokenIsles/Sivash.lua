
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Si'vash", -646, 1885)
if not mod then return end
mod:RegisterEnableMob(117470)
mod.otherMenu = -619
mod.worldBoss = 117470

--------------------------------------------------------------------------------
-- Locals
--

local castCollector = {} -- for all UNIT casts

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		233996, -- Tidal Wave
		241433, -- Submerge
		233968, -- Summon Honor Guard
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")

	self:Log("SPELL_CAST_SUCCESS", "TidalWave", 233996)
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

	self:Death("Win", 117470)
end

function mod:OnEngage()
	self:CheckForWipe()
	wipe(castCollector)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	--if id == XXX then
	--	self:Win()
	--end
end

function mod:TidalWave(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:CDBar(args.spellId, 22)
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, castGUID, spellId)
	if castCollector[castGUID] then return end -- Don't fire twice for the same cast

	if spellId == 241433 then -- Submerge
		castCollector[castGUID] = true
		self:Message(spellId, "Attention", "Alarm")
		self:CDBar(spellId, 13)
	elseif spellId == 233968 then -- Summon Honor Guard
		castCollector[castGUID] = true
		self:Message(spellId, "Urgent", "Long")
		self:CDBar(spellId, 24)
	end
end
