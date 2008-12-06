------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Archavon the Stone Watcher"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local db = nil
local started = nil
local pName = UnitName("player")
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Archavon",

	stomp = "Stomp",
	stomp_desc = "Stomp warnings and timers.",
	stomp_message = "Stomp - Charge Inc!",
	stomp_warning = "Possible Stomp in ~5sec!",
	stomp_bar = "~Stomp Cooldown",

	cloud = "Choking Cloud on You",
	cloud_desc = "Warn when you are in a Choking Cloud.",
	cloud_message = "Choking Cloud on YOU!",

	charge = "Charge",
	charge_desc = "Warn about Charge on players.",
	charge_message = "Charge on %s",

	shards = "Rock Shards",
	shards_desc = "Warn who Archavon casts Rock Shards on.",
	shards_message = "Rock Shards on %s!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Target Icon on the player targetted by Rock Shards. (requires promoted or higher)",
} end )

L:RegisterTranslations("koKR", function() return {
	stomp = "발 구르기",
	stomp_desc = "발구르기 타이머와 사용을 알립니다.",
	stomp_message = "발 구르기 - 곧 돌진!",
	stomp_warning = "약 5초 후 발구르기 가능!",
	stomp_bar = "~발 구르기 대기시간",

	cloud = "자신의 숨막히는 구름",
	cloud_desc = "자신이 숨막히는 구름에 걸렸을 때 알립니다.",
	cloud_message = "당신은 숨막히는 구름!",

	charge = "돌진",
	charge_desc = "돌진의 대상인 플레이어를 알립니다.",
	charge_message = "돌진: %s",

	shards = "바위 조각",
	shards_desc = "아카본의 바위 조각 시전이 어떤 플레이어 방향인지 알립니다.",
	shards_message = "%s에게 바위 조각!",

	icon = "전술 표시",
	icon_desc = "바위 조각 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("frFR", function() return {
	stomp = "Piétinement",
	stomp_desc = "Prévient de l'arrivée des Piétinements.",
	stomp_message = "Piétinement - Charge imminente !",
	stomp_warning = "Piétinement probable dans ~5 sec. !",
	stomp_bar = "~Recharge Piétinement",

	cloud = "Nuage asphyxiant sur vous",
	cloud_desc = "Prévient quand vous vous trouvez dans un Nuage asphyxiant.",
	cloud_message = "Nuage asphyxiant sur VOUS !",

	charge = "Charge",
	charge_desc = "Prévient quand Archavon charge un joueur.",
	charge_message = "Charge sur %s",

	shards = "Eclats de pierre",
	shards_desc = "Prévient sur qui Archavon incante ses Eclats de pierre.",
	shards_message = "Eclats de pierre sur %s !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur ciblé par les Eclats de pierre (nécessite d'être promu ou mieux).",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Vault of Archavon"]
mod.otherMenu = "Northrend"
mod.enabletrigger = boss
mod.guid = 31125
mod.toggleoptions = {"stomp", "charge", "shards", -1, "icon", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Stomp", 60880)
	self:AddCombatListener("SPELL_CAST_START", "Shards", 58678)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Cloud", 61672)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")

	started = nil
	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Stomp()
	if db.stomp then
		self:CancelScheduledEvent("StompWarn")
		self:TriggerEvent("BigWigs_StopBar", self, L["stomp_bar"])
		self:IfMessage(L["stomp_message"], "Attention", 60880)
		self:Bar(L["stomp_bar"], 47, 60880)
		self:ScheduleEvent("StompWarn", "BigWigs_Message", 42, L["stomp_warning"], "Attention")
	end
end

function mod:Cloud(player)
	if player == pName and db.cloud then
		self:LocalMessage(L["cloud_message"], "Personal", 61672, "Alarm")
	end
end

local function ScanTarget()
	local target
	if UnitName("target") == boss then
		target = UnitName("targettarget")
	elseif UnitName("focus") == boss then
		target = UnitName("focustarget")
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			if UnitName(fmt("%s%d%s", "raid", i, "target")) == boss then
				target = UnitName(fmt("%s%d%s", "raid", i, "targettarget"))
				break
			end
		end
	end
	if target then
		mod:IfMessage(fmt(L["shards_message"], target), "Important", 58678)
		if mod.db.profile.icon then
			mod:Icon(target)
		end
	end
end

function mod:Shards()
	if db.shards then
		self:ScheduleEvent("BWShardsToTScan", ScanTarget, 0.2)
		self:ScheduleEvent("BWRemoveAKIcon", "BigWigs_RemoveRaidIcon", 4, self)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, _, _, _, player)
	if db.charge then
		-- 11578, looks like a charge :)
		self:IfMessage(L["charge_message"]:format(player), "Attention", 11578)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if db.stomp then
			self:Bar(L["stomp_bar"], 47, 60880)
			self:ScheduleEvent("StompWarn", "BigWigs_Message", 42, L["stomp_warning"], "Attention")
		end
		if db.enrage then
			self:Enrage(300)
		end
	end
end
