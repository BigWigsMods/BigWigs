--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Thorm'belan", -2413, 2829) -- World boss for the "Harandar" zone
if not mod then return end
mod:RegisterEnableMob(249776) -- Thorm'belan
mod.otherMenu = -2443
mod:SetWorldModule(true)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.ball = "Ball"
	L.ball_incoming = "Ball Incoming - Don't let it touch the ground"
	L.ball_fail = "FAIL - Ball touched the ground"
	L.tendrils = "Tendrils"
	L.tendrils_incoming = "RUN AWAY to snap tendrils"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		1257325, -- Radiant Mote
		1257825, -- Scintillating Shard
		{1258641, "ME_ONLY_EMPHASIZE"}, -- Shredding Tendrils
	},nil,{
		[1257325] = CL.bombs, -- Radiant Mote (Bombs)
		[1257825] = L.ball, -- Scintillating Shard (Ball)
		[1258641] = L.tendrils, -- Shredding Tendrils (Tendrils)
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer(function() self:CheckForEngage() end, 1)
	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEncounterStart()
	self:ScheduleTimer(function() self:CheckForWipe() end, 3)

	self:RegisterEvent("RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterWhisperEmoteComms("RaidBossWhisperSync")

	self:BlockBossEmotes()

	self:CDBar(1257825, 14.3, L.ball) -- Scintillating Shard
	self:CDBar(1257325, 20.5, CL.bombs) -- Radiant Mote
	self:CDBar(1258641, 44.8, L.tendrils) -- Shredding Tendrils
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 3459 then
		self:Win()
	end
end

function mod:RAID_BOSS_EMOTE(_, msg)
	if msg:find("1257325", nil, true) then -- Radiant Mote
		self:Message(1257325, "orange", CL.incoming:format(CL.bombs))
		self:CDBar(1257325, 33.6, CL.bombs)
	elseif msg:find("1257825", nil, true) then -- Scintillating Shard
		self:Message(1257825, "yellow", L.ball_incoming)
		self:CDBar(1257825, 59.1, L.ball)
		self:PlaySound(1257825, "long")
	elseif msg:find("1258641", nil, true) then -- Shredding Tendrils
		self:Message(1258641, "red", L.tendrils_incoming)
		self:CDBar(1258641, 69.1, L.tendrils)
		self:PlaySound(1258641, "info")
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(_, _, source)
	if source == self.displayName then -- The Scintillating Shard shatters on contact with the ground.#Thorm'belan
		self:Message(1257825, "red", L.ball_fail)
		self:PlaySound(1257825, "long")
	end
end

do
	local playerList, prev = {}, 0
	function mod:RaidBossWhisperSync(msg, player)
		if msg:find("spell:1258641", nil, true) then
			local t = GetTime()
			if t - prev > 10 then
				prev = t
				playerList = {}
			end

			playerList[#playerList+1] = player
			self:TargetsMessage(1258641, "orange", playerList, nil, L.tendrils)
			if player == self:UnitName("player") then
				self:PlaySound(1258641, "warning", nil, player)
			end
		end
	end
end
