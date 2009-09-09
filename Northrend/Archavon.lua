----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewBoss("Archavon the Stone Watcher", "Vault of Archavon")
if not mod then return end
mod.otherMenu = "Northrend"
mod.enabletrigger = 31125
mod.guid = 31125
mod.toggleOptions = {58663, "charge", 58678, 58965, -1, "icon", "berserk", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local started = nil
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
	self:AddCombatListener("SPELL_CAST_START", "Stomp", 58663, 60880)
	self:AddCombatListener("SPELL_CAST_START", "Shards", 58678)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Cloud", 58965, 61672)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterMessage("BigWigs_RecvSync")

	started = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Stomp(_, spellId)
	self:IfMessage(L["stomp_message"], "Attention", spellId)
	self:Bar(L["stomp_bar"], 47, spellId)
	self:DelayedMessage(42, L["stomp_warning"], "Attention")
end

function mod:Cloud(player, spellId)
	if player == pName then
		self:LocalMessage(L["cloud_message"], "Personal", spellId, "Alarm")
	end
end

local function scanTarget(spellId, spellName)
	local bossId = mod:GetUnitIdByGUID(31125)
	if not bossId then return end
	local target = UnitName(bossId .. "target")
	if target then
		mod:TargetMessage(spellName, target, "Important", spellId)
		mod:PrimaryIcon(target, "icon")
	end
end

function mod:Shards(_, spellId, _, _, spellName)
	self:ScheduleEvent("BWShardsToTScan", scanTarget, 0.2, spellId, spellName)
	self:ScheduleEvent("BWRemoveAKIcon", "SendMessage", 4, "BigWigs_RemoveRaidIcon", 1)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, _, unit, _, _, player)
	if self.db.profile.charge and unit == self.bossName then
		-- 11578, looks like a charge :)
		self:TargetMessage(L["charge"], player, "Attention", 11578)
	end
end

function mod:BigWigs_RecvSync(event, sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		if self:GetOption(58663) then
			self:Bar(L["stomp_bar"], 47, 60880)
			self:DelayedMessage(42, L["stomp_warning"], "Attention")
		end
		if self.db.profile.berserk then
			self:Berserk(300)
		end
	end
end
