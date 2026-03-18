--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lu'ashal", -2395, 2827)
if not mod then return end
mod:RegisterEnableMob(244762) -- Lu'ashal
mod.otherMenu = -2443
mod.worldBoss = 244762

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{1258427, "EMPHASIZE"}, -- Radiant Flare
		1276427, -- Dawncrazed Halo
		1276247, -- Dawnfire Breath
	},nil,{
		[1258427] = CL.orbs, -- Radiant Flare (Orbs)
		[1276427] = CL.bombs, -- Dawncrazed Halo (Bombs)
		[1276247] = CL.frontal_cone, -- Dawnfire Breath (Frontal Cone)
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEncounterStart()
	self:CheckForWipe()

	self:RegisterEvent("RAID_BOSS_EMOTE")
	self:RegisterWhisperEmoteComms("RaidBossWhisperSync")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")

	self:CDBar(1276247, 23, CL.frontal_cone)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 3454 then
		self:Win()
	end
end

function mod:RAID_BOSS_EMOTE(_, msg)
	if msg:find("1258427", nil, true) then
		self:Message(1258427, "red", CL.incoming:format(CL.orbs))
		self:PlaySound(1258427, "warning")
	end
end

do
	local playerList, prev = {}, 0
	function mod:RaidBossWhisperSync(msg, player)
		if msg:find("spell:1276427", nil, true) then
			local t = GetTime()
			if t - prev > 10 then
				prev = t
				playerList = {}
				self:CDBar(1276427, 29.5, CL.bombs)
				self:PlaySound(1276427, "alarm")
			end

			playerList[#playerList+1] = player
			self:TargetsMessage(1276427, "yellow", playerList, nil, CL.bomb)
		end
	end
end

do
	local prev = 0
	function mod:UNIT_SPELLCAST_CHANNEL_START(_, unit)
		local t = GetTime()
		if t - prev > 15 and self:MobId(self:UnitGUID(unit)) == 244762 then
			prev = t
			self:Message(1276247, "purple", CL.extra:format(self:SpellName(1276247), CL.frontal_cone))
			self:CDBar(1276247, 20.8, CL.frontal_cone)
			self:PlaySound(1276247, "long")
		end
	end
end
