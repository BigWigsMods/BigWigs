----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewBoss("Sapphiron", "Naxxramas")
if not mod then return end
mod:RegisterEnableMob(15989)
mod.toggleOptions = {28542, 28524, {28522, "ICON", "SAY", "PING"}, "berserk", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local breath = 1
local pName = UnitName("player")
local iceboltName = GetSpellInfo(28522)

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Sapphiron", "enUS", true)
if L then
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

	L.ping = "Ping"
	L.ping_desc = "Ping your current location if you are afflicted by Icebolt."
	L.ping_message = "Block - Pinging your location!"

	L.icon = "Raid Icon"
	L.icon_desc = "Place a Raid Target Icon on the player with Icebolt. (requires promoted or higher)"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Sapphiron")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Drain", 28542, 55665)
	self:Log("SPELL_CAST_SUCCESS", "Breath", 28524, 29318)
	self:Log("SPELL_AURA_APPLIED", "Icebolt", 28522)
	self:Log("SPELL_AURA_REMOVED", "RemoveIcon", 28522)
	self:Death("Win", 15989)

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	breath = 1
	self:Berserk(900)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg)
	if msg == L["airphase_trigger"] then
		self:CancelScheduledEvent(L["lifedrain_warn1"])
		self:SendMessage("BigWigs_StopBar", self, L["lifedrain_bar"])
		--43810 Frost Wyrm, looks like a dragon breathing 'deep breath' :)
		self:IfMessage(28524, L["deepbreath_incoming_message"], "Attention")
		self:Bar(28524, L["deepbreath_incoming_bar"], 14, 43810)
		self:DelayedMessage(28524, 9, L["deepbreath_incoming_soon_message"], "Attention")
	elseif msg == L["deepbreath_trigger"] then
		self:IfMessage(28524, L["deepbreath_warning"], "Attention")
		self:Bar(28524, L["deepbreath_bar"], 10, 29318)
	end
end

function mod:Breath(_, spellId, _, _, spellName)
	breath = breath + 1
	if breath == 2 then
		self:IfMessage(28524, spellName, "Important", spellId)
	end
end

function mod:Drain(_, spellId)
	self:IfMessage(28542, L["lifedrain_message"], "Urgent", spellId)
	self:Bar(28542, L["lifedrain_bar"], 23, spellId)
	self:DelayedMessage(28542, 18, L["lifedrain_warn1"], "Important")
end

function mod:Icebolt(player, spellId, _, _, spellName)
	if player == pName then
		if bit.band(self.db.profile[iceboltName], BigWigs.C.SAY) == BigWigs.C.SAY then
			SendChatMessage(L["icebolt_say"], "SAY")
		end
		if bit.band(self.db.profile[iceboltName], BigWigs.C.PING) == BigWigs.C.PING then
			Minimap:PingLocation()
			BigWigs:Print(L["ping_message"])
		end
	else
		self:TargetMessage(28522, spellName, player, "Attention", spellId)
	end
	self:PrimaryIcon(28522, player)
end

function mod:RemoveIcon()
	self:PrimaryIcon(28522, false)
end

