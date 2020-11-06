--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Sapphiron", 533)
if not mod then return end
mod:RegisterEnableMob(15989)
mod:SetAllowWin(true)
mod.engageId = 1119
mod.toggleOptions = {28542, 28524, {28522, "ICON", "SAY", "PING"}, "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local breath = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Sapphiron"

	L.airphase_trigger = "Sapphiron lifts off into the air!"
	L.deepbreath_incoming_message = "Ice Bomb casting in ~14sec!"
	L.deepbreath_incoming_soon_message = "Ice Bomb casting in ~5sec!"
	L.deepbreath_incoming_bar = "Ice Bomb Cast"
	L.deepbreath_trigger = "%s takes a deep breath."
	L.deepbreath_warning = "Ice Bomb Incoming!"
	L.deepbreath_bar = "Ice Bomb Lands!"

	L.lifedrain_message = "Life Drain! Next in ~24sec!"
	L.lifedrain_warn1 = "Life Drain in ~5sec!"
	L.lifedrain_bar = "~Possible Life Drain"

	L.icebolt_say = "I'm a Block!"

	L.ping_message = "Block - Pinging your location!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Drain", 28542, 55665)
	self:Log("SPELL_CAST_SUCCESS", "Breath", 28524, 29318)
	self:Log("SPELL_AURA_APPLIED", "Icebolt", 28522)

	self:Emote("Airphase", L["airphase_trigger"])
	self:Emote("Deepbreath", L["deepbreath_trigger"])

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:Death("Win", 15989)
end

function mod:OnEngage()
	breath = 1
	self:Berserk(900)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Airphase()
	self:CancelDelayedMessage(L["lifedrain_warn1"])
	self:SendMessage("BigWigs_StopBar", self, L["lifedrain_bar"])
	--43810 Frost Wyrm, looks like a dragon breathing 'deep breath' :)
	self:Message(28524, L["deepbreath_incoming_message"], "Attention")
	self:Bar(28524, L["deepbreath_incoming_bar"], 14, 43810)
	self:DelayedMessage(28524, 9, L["deepbreath_incoming_soon_message"], "Attention")
end

function mod:Deepbreath()
	self:Message(28524, L["deepbreath_warning"], "Attention")
	self:Bar(28524, L["deepbreath_bar"], 10, 29318)
end

function mod:Breath(_, spellId, _, _, spellName)
	breath = breath + 1
	if breath == 2 then
		self:Message(28524, spellName, "Important", spellId)
	end
end

function mod:Drain(_, spellId)
	self:Message(28542, L["lifedrain_message"], "Urgent", spellId)
	self:Bar(28542, L["lifedrain_bar"], 23, spellId)
	self:DelayedMessage(28542, 18, L["lifedrain_warn1"], "Important")
end

function mod:Icebolt(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:Say(28522, L["icebolt_say"])
		if bit.band(self.db.profile[(GetSpellInfo(28522))], BigWigs.C.PING) == BigWigs.C.PING then
			Minimap:PingLocation()
			BigWigs:Print(L["ping_message"])
		end
	else
		self:TargetMessage(28522, spellName, player, "Attention", spellId)
	end
	self:PrimaryIcon(28522, player)
end

