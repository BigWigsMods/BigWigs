--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Archavon the Stone Watcher", "Vault of Archavon")
if not mod then return end
mod.otherMenu = "Northrend"
mod:RegisterEnableMob(31125)
mod.toggleOptions = {58663, "charge", {58678, "MESSAGE", "ICON"}, {58965, "FLASHSHAKE"}, "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.stomp_message = "Stomp - Charge Inc!"
	L.stomp_warning = "Possible Stomp in ~5sec!"
	L.stomp_bar = "~Stomp Cooldown"

	L.cloud_message = "Choking Cloud on YOU!"

	L.charge = "Charge"
	L.charge_desc = "Warn about Charge on players."
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Stomp", 58663, 60880)
	self:Log("SPELL_CAST_START", "Shards", 58678)
	self:Log("SPELL_AURA_APPLIED", "Cloud", 58965, 61672)
	self:Death("Win", 31125)

	-- Need the actual emote for the charge to use :Emote
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	self:Bar(58663, L["stomp_bar"], 47, 60880)
	self:DelayedMessage(58663, 42, L["stomp_warning"], "Attention")
	self:Berserk(300)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Stomp(_, spellId)
	self:Message(58663, L["stomp_message"], "Positive", spellId)
	self:Bar(58663, L["stomp_bar"], 47, spellId)
	self:DelayedMessage(58663, 42, L["stomp_warning"], "Attention")
end

function mod:Cloud(player, spellId)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(58965, L["cloud_message"], "Personal", spellId, "Alarm")
		self:FlashShake(58965)
	end
end

do
	local id, name, handle = nil, nil, nil
	local function scanTarget(spellId, spellName)
		local bossId = mod:GetUnitIdByGUID(31125)
		if not bossId then return end
		local target = UnitName(bossId .. "target")
		if target then
			mod:TargetMessage(58965, name, target, "Important", id)
			mod:PrimaryIcon(58965, target)
		end
		handle = nil
	end

	function mod:Shards(_, spellId, _, _, spellName)
		id, name = spellId, spellName
		self:CancelTimer(handle, true)
		handle = self:ScheduleTimer(scanTarget, 0.2)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, _, unit, _, _, player)
	if unit == self.displayName then
		self:TargetMessage("charge", L["charge"], player, "Attention", 11578)
	end
end

