--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Blood-Queen Lana'thel", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(37955)
mod.toggleOptions = {{71340, "FLASHSHAKE"}, 71265, {70877, "WHISPER"}, 71772, "proximity", "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local pactTargets = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
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
	self:Log("SPELL_AURA_APPLIED", "Shadows", 71265)
	-- XXX 71474 verified as 25man, is 70877 10man or what is it?
	self:Log("SPELL_AURA_APPLIED", "Feed", 70877, 71474)
	self:Log("SPELL_CAST_SUCCESS", "AirPhase", 73070)
	self:Death("Win", 37955)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	self:Berserk(330, true)
	self:OpenProximity(6)
	self:Bar(71772, L["phase2_bar"], 142, 71772)
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

function mod:Shadows(player, spellId)
	self:TargetMessage(71265, L["shadow_message"], player, "Attention", spellId)
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
	self:Bar(71772, L["phase2_bar"], 153, 71772)
end

