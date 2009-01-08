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

L:RegisterTranslations("zhCN", function() return {
	stomp = "践踏",
	stomp_desc = "当施放践踏时发出警报及显示计时条。",
	stomp_message = "践踏 - 即将 冲锋！",
	stomp_warning = "约5秒后，可能践踏！",
	stomp_bar = "<践踏 冷却>",

	cloud = "自身窒息云雾",
	cloud_desc = "当你中了窒息云雾时发出警报。",
	cloud_message = ">你< 窒息云雾！",

	charge = "冲锋",
	charge_desc = "当玩家中了冲锋时发出警报。",
	charge_message = "冲锋：>%s<！",

	shards = "岩石碎片",
	shards_desc = "当阿尔卡冯施放岩石碎片时发出警报。",
	shards_message = "岩石碎片：>%s<！",

	icon = "团队标记",
	icon_desc = "为中了岩石碎片的玩家打上团队标记。（需要权限）",
} end )

L:RegisterTranslations("zhTW", function() return {
	stomp = "踐踏",
	stomp_desc = "當施放踐踏時發出警報及顯示計時條。",
	stomp_message = "踐踏 - 即將 沖鋒！",
	stomp_warning = "約5秒后，可能踐踏！",
	stomp_bar = "<踐踏 冷卻>",

	cloud = "自身窒息之雲",
	cloud_desc = "當你中了窒息之雲時發出警報。",
	cloud_message = ">你< 窒息之雲！",

	charge = "沖鋒",
	charge_desc = "當玩家中了沖鋒時發出警報。",
	charge_message = "沖鋒：>%s<！",

	shards = "岩石裂片",
	shards_desc = "當亞夏梵施放岩石裂片時發出警報。",
	shards_message = "岩石裂片：>%s<！",

	icon = "團隊標記",
	icon_desc = "為中了岩石裂片的玩家打上團隊標記。（需要權限）",
} end )

L:RegisterTranslations("ruRU", function() return {
	stomp = "Топот",
	stomp_desc = "Предупреждения топота и таймеры.",
	stomp_message = "Топот - близится Рывок!",
	stomp_warning = "Топот через ~5сек!",
	stomp_bar = "~Перезарядка топота",

	cloud = "Удушающее облако на вас",
	cloud_desc = "Предупреждать если вы поподаете в Удушающее облако.",
	cloud_message = "На ВАС Удушающее облако!",

	charge = "Рывок",
	charge_desc = "Предупреждать о Рывках.",
	charge_message = "Рывок на %s",

	shards = "Каменные осколки",
	shards_desc = "Предупреждать о применении Каменных осколков.",
	shards_message = "Каменные осколки: %s!",

	icon = "Отмечать иконкой",
	icon_desc = "Отмечать рейдовой иконой игрока, на которого нацелены каменные осколки. (необходимо быть лидером группы или рейда)",
} end )

L:RegisterTranslations("deDE", function() return {
	stomp = "Stampfen",
	stomp_desc = "Warnungen und Timer für Stampfen.",
	stomp_message = "Stampfen - Ansturm bald!",
	stomp_warning = "Mögliches Stampfen in ~5 Sekunden!",
	stomp_bar = "~Stampfen Cooldown",

	cloud = "Erstickende Wolke",
	cloud_desc = "Warnen, wenn du in der Erstickenden Wolke bist.",
	cloud_message = "Erstickende Wolke auf DIR!",

	charge = "Ansturm",
	charge_desc = "Warnen, wenn ein Spieler angestürmt wird.",
	charge_message = "Ansturm auf %s.",

	shards = "Felssplitter",
	shards_desc = "Warnen, wenn auf einen Spieler Felssplitter gewirkt wird.",
	shards_message = "Felssplitter auf %s!",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, auf die Felssplitter gewirkt wird (benötigt Assistent oder höher).",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Vault of Archavon"]
mod.otherMenu = "Northrend"
mod.enabletrigger = boss
mod.guid = 31125
mod.toggleoptions = {"stomp", "charge", "shards", "cloud", -1, "icon", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Stomp", 58663, 60880)
	self:AddCombatListener("SPELL_CAST_START", "Shards", 58678)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Cloud", 58965, 61672)
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
