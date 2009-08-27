----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Archavon the Stone Watcher"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Vault of Archavon"]
mod.otherMenu = "Northrend"
mod.enabletrigger = boss
mod.guid = 31125
mod.toggleOptions = {58663, "charge", 58678, 58965, -1, "icon", "berserk", "bosskill"}
mod.consoleCmd = "Archavon"

------------------------------
--      Are you local?      --
------------------------------

local started = nil
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	stomp_message = "Stomp - Charge Inc!",
	stomp_warning = "Possible Stomp in ~5sec!",
	stomp_bar = "~Stomp Cooldown",

	cloud_message = "Choking Cloud on YOU!",

	charge = "Charge",
	charge_desc = "Warn about Charge on players.",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Target Icon on the player targetted by Rock Shards. (requires promoted or higher)",
} end )

L:RegisterTranslations("koKR", function() return {
	stomp_message = "발 구르기 - 곧 돌진!",
	stomp_warning = "약 5초 후 발구르기 가능!",
	stomp_bar = "~발 구르기 대기시간",

	cloud_message = "당신은 숨막히는 구름!",

	charge = "돌진",
	charge_desc = "돌진의 대상인 플레이어를 알립니다.",

	icon = "전술 표시",
	icon_desc = "바위 조각 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("frFR", function() return {
	stomp_message = "Piétinement - Empaler imminent !",
	stomp_warning = "Piétinement probable dans ~5 sec. !",
	stomp_bar = "~Recharge Piétinement",

	cloud_message = "Nuage asphyxiant sur VOUS !",

	charge = "Empaler",
	charge_desc = "Prévient quand un joueur subit les effets d'un Empaler.",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur ciblé par les Eclats de pierre (nécessite d'être assistant ou mieux).",
} end )

L:RegisterTranslations("zhCN", function() return {
	stomp_message = "践踏 - 即将 冲锋！",
	stomp_warning = "约5秒后，可能践踏！",
	stomp_bar = "<践踏 冷却>",

	cloud_message = ">你< 窒息云雾！",

	charge = "冲锋",
	charge_desc = "当玩家中了冲锋时发出警报。",

	icon = "团队标记",
	icon_desc = "为中了岩石碎片的玩家打上团队标记。（需要权限）",
} end )

L:RegisterTranslations("zhTW", function() return {
	stomp_message = "踐踏 - 即將 衝鋒！",
	stomp_warning = "約5秒後，可能踐踏！",
	stomp_bar = "<踐踏 冷卻>",

	cloud_message = ">你< 窒息之雲！",

	charge = "衝鋒",
	charge_desc = "當玩家中了衝鋒時發出警報。",

	icon = "團隊標記",
	icon_desc = "為中了岩石裂片的玩家打上團隊標記。（需要權限）",
} end )

L:RegisterTranslations("ruRU", function() return {
	stomp_message = "Топот - близится Рывок!",
	stomp_warning = "Топот через ~5сек!",
	stomp_bar = "~Перезарядка топота",

	cloud_message = "ВЫ в Удушающем облаке!",

	charge = "Рывок",
	charge_desc = "Предупреждать о Рывках.",

	icon = "Отмечать иконкой",
	icon_desc = "Отмечать рейдовой иконой игрока, на которого нацелены каменные осколки. (необходимо быть лидером группы или рейда)",
} end )

L:RegisterTranslations("deDE", function() return {
	stomp_message = "Stampfen - Ansturm bald!",
	stomp_warning = "Mögliches Stampfen in ~5 sek!",
	stomp_bar = "~Stampfen",

	cloud_message = "Erstickende Wolke auf DIR!",

	charge = "Ansturm",
	charge_desc = "Warnt, wenn ein Spieler angestürmt wird.",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, auf die Felssplitter gewirkt wird (benötigt Assistent oder höher).",
} end )

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

local function ScanTarget(spellId, spellName)
	local target
	if UnitName("target") == boss then
		target = UnitName("targettarget")
	elseif UnitName("focus") == boss then
		target = UnitName("focustarget")
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			if UnitName(("%s%d%s"):format("raid", i, "target")) == boss then
				target = UnitName(("%s%d%s"):format("raid", i, "targettarget"))
				break
			end
		end
	end
	if target then
		mod:TargetMessage(spellName, target, "Important", spellId)
		if mod.db.profile.icon then
			mod:Icon(target)
		end
	end
end

function mod:Shards(_, spellId, _, _, spellName)
	self:ScheduleEvent("BWShardsToTScan", ScanTarget, 0.2, spellId, spellName)
	self:ScheduleEvent("BWRemoveAKIcon", "BigWigs_RemoveRaidIcon", 4, self)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, unit, _, _, player)
	if self.db.profile.charge and unit == boss then
		-- 11578, looks like a charge :)
		self:TargetMessage(L["charge"], player, "Attention", 11578)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self:GetOption(58663) then
			self:Bar(L["stomp_bar"], 47, 60880)
			self:DelayedMessage(42, L["stomp_warning"], "Attention")
		end
		if self.db.profile.berserk then
			self:Enrage(300, true)
		end
	end
end
