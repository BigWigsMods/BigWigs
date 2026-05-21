--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Cragpine", -2437, 2782) -- World boss for the "Zul'Aman" zone
if not mod then return end
mod:RegisterEnableMob(244424) -- Cragpine
mod.otherMenu = -2443
mod:SetWorldModule(true)

--------------------------------------------------------------------------------
-- Renames
--

mod:SetRenames({
	[1235131] = {CL.dodge, CL.extra:format(mod:SpellName(1235131), CL.dodge), notes = {CL.timerNote, CL.messageNote}}, -- Rootquake (Dodge)
	[1243594] = {CL.fixate}, -- Fixate (Fixate)
	[1235144] = {1235144}, -- War Club
})

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		1235131, -- Rootquake
		{1243594, "ME_ONLY_EMPHASIZE"}, -- Fixate
		1235144, -- War Club
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer(function() self:CheckForEngage() end, 1)
	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEncounterStart()
	self:ScheduleTimer(function() self:CheckForWipe() end, 3)

	self:RegisterEvent("RAID_BOSS_WHISPER")
	self:RegisterEvent("UNIT_SPELLCAST_START")

	self:BlockBossEmotes()

	self:CDBar(1235131, 11) -- Rootquake
	self:CDBar(1235144, 38) -- War Club
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 3436 then
		self:Win()
	end
end

function mod:RAID_BOSS_WHISPER()
	self:PersonalMessage(1243594)
	self:PlaySound(1243594, "warning")
end

do
	local prev = 0
	function mod:UNIT_SPELLCAST_START(_, unit)
		local t = GetTime()
		if t - prev > 2 and self:MobId(self:UnitGUID(unit)) == 244424 then
			prev = t
			if self:UnitGUID(unit.."target") then
				self:Message(1235131, "yellow", self:GetRename(1235131, 2))
				self:CDBar(1235131, 35.6)
				self:PlaySound(1235131, "long")
			else
				self:Message(1235144, "purple")
				self:CDBar(1235144, 32)
				self:PlaySound(1235144, "info")
			end
		end
	end
end
