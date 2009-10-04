----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewBoss("Archavon the Stone Watcher", "Vault of Archavon")
if not mod then return end
mod.otherMenu = "Northrend"
mod:RegisterEnableMob(31125)
mod.toggleOptions = {58663, "charge", {58678, "MESSAGE", "ICON"}, {58965, "FLASHSHAKE"}, "berserk", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local pName = UnitName("player")

------------------------------
--      English Locale      --
------------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Archavon the Stone Watcher", "enUS", true)
if L then
	L.stomp_message = "Stomp - Charge Inc!"
	L.stomp_warning = "Possible Stomp in ~5sec!"
	L.stomp_bar = "~Stomp Cooldown"

	L.cloud_message = "Choking Cloud on YOU!"

	L.charge = "Charge"
	L.charge_desc = "Warn about Charge on players."

	L.icon = "Raid Icon"
	L.icon_desc = "Place a Raid Target Icon on the player targetted by Rock Shards. (requires promoted or higher)"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Archavon the Stone Watcher")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Stomp", 58663, 60880)
	self:Log("SPELL_CAST_START", "Shards", 58678)
	self:Log("SPELL_AURA_APPLIED", "Cloud", 58965, 61672)
	self:Death("Win", 31125)

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	self:Bar(58663, L["stomp_bar"], 47, 60880)
	self:DelayedMessage(58663, 42, L["stomp_warning"], "Attention")
	self:Berserk(300)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Stomp(_, spellId)
	self:IfMessage(58663, L["stomp_message"], "Attention", spellId)
	self:Bar(58663, L["stomp_bar"], 47, spellId)
	self:DelayedMessage(58663, 42, L["stomp_warning"], "Attention")
end

function mod:Cloud(player, spellId)
	if player == pName then
		self:LocalMessage(58965, L["cloud_message"], "Personal", spellId, "Alarm")
		self:FlashShake(58965)
	end
end

local function scanTarget(spellId, spellName)
	local bossId = mod:GetUnitIdByGUID(31125)
	if not bossId then return end
	local target = UnitName(bossId .. "target")
	if target then
		mod:TargetMessage(58965, spellName, target, "Important", spellId)
		mod:PrimaryIcon(58965, target, "icon")
	end
end

function mod:Shards(_, spellId, _, _, spellName)
	self:ScheduleEvent("BWShardsToTScan", scanTarget, 0.2, spellId, spellName)
	self:ScheduleEvent("BWRemoveAKIcon", "SendMessage", 4, "BigWigs_RemoveRaidIcon", 1)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, _, unit, _, _, player)
	-- XXX can we get the actual emote here, and not just assume that every time
	-- the boss emotes, he does a charge? heh.
	if unit == self.displayName then
		self:TargetMessage("charge", L["charge"], player, "Attention", 11578)
	end
end


