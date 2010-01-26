--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Blood-Queen Lana'thel", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(37955)
mod.toggleOptions = {{71340, "FLASHSHAKE"}, {71265, "FLASHSHAKE"}, {70877, "WHISPER"}, 71772, 71623, "proximity", "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local pactTargets = mod:NewTargetList()
local airPhaseTimers = {
	{124, 120}, -- 10man Normal
	{137, 100}, -- 25man Normal
	{124, 120}, -- 10man Heroic
	{137, 100}, -- 25man Heroic
}
local currentDifficulty = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.shadow = "Shadows"
	L.shadow_message = "Shadows"

	L.feed_message = "Time to feed soon!"

	L.pact_message = "Pact"

	L.phase_message = "Air phase incoming!"
	L.phase1_bar = "Back on floor"
	L.phase2_bar = "Air phase"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Pact", 71340)
	self:Log("SPELL_AURA_APPLIED", "Feed", 70877, 71474)
	self:Log("SPELL_CAST_SUCCESS", "AirPhase", 73070)
	-- 71623. 72264 are 10 man (and so on)
	self:Log("SPELL_AURA_APPLIED", "Slash", 71623, 71624, 71625, 71626, 72264, 72265, 72266, 72267)
	self:Death("Win", 37955)

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	currentDifficulty = GetInstanceDifficulty()
	self:Berserk(320, true)
	self:OpenProximity(6)
	self:Bar(71772, L["phase2_bar"], airPhaseTimers[currentDifficulty][1], 71772)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local handle = nil
	local function pact()
		mod:TargetMessage(71340, L["pact_message"], pactTargets, "Important", 71340)
		handle = nil
	end
	function mod:Pact(player)
		if UnitIsUnit(player, "player") then
			self:FlashShake(71340)
		end
		pactTargets[#pactTargets + 1] = player
		self:CancelTimer(handle, true)
		handle = self:ScheduleTimer(pact, 0.2)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg, _, _, _, player)
	if msg:find(L["shadow"]) then
		if UnitIsUnit(player, "player") then
			self:FlashShake(71265)
		end
		self:TargetMessage(71265, L["shadow_message"], player, "Attention", 71265)
	end
end

function mod:Feed(player, spellId)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(70877, L["feed_message"], "Urgent", spellId, "Alert")
		self:Bar(70877, L["feed_message"], 15, spellId)
	else
		self:Whisper(70877, player, L["feed_message"], true)
	end
end

function mod:AirPhase(player, spellId)
	self:Message(71772, L["phase_message"], "Important", spellId, "Alarm")
	self:Bar(71772, L["phase1_bar"], 11, spellId)
	self:Bar(71772, L["phase2_bar"], airPhaseTimers[currentDifficulty][2], 71772)
end

function mod:Slash(player, spellId, _, _, spellName)
	self:TargetMessage(71623, spellName, player, "Attention", spellId)
end

