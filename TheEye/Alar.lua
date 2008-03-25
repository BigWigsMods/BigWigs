------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Al'ar"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local started = nil
local db = nil
local prior = nil
local fireball = nil
local occured = true
local pName = UnitName("player")
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Alar",

	--Renamed from Meteor to Dive Bomb as of Patch 2.3.0
	meteor = "Dive Bomb",
	meteor_desc = "Estimated Dive Bomb timers.",
	meteor_warning = "Possible Dive Bomb in ~5sec",
	meteor_message = "Dive Bomb! Next in ~52sec",
	meteor_nextbar = "~Next Dive Bomb",

	flamepatch = "Flame Patch on You",
	flamepatch_desc = "Warn for a Flame Patch on You.",
	flamepatch_message = "Flame Patch on YOU!",

	armor = "Melt Armor",
	armor_desc = "Warn who gets Melt Armor.",
	armor_other = "Melt Armor: %s",
	armor_you = "Melt Armor on YOU!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player with Melt Armor(requires promoted or higher).",
} end )

L:RegisterTranslations("frFR", function() return {
	meteor = "Bombardement en piqué",
	meteor_desc = "Délais estimés entre les Bombardements en piqué.",
	meteor_warning = "Bombardement en piqué probable dans ~5 sec.",
	meteor_message = "Bombardement en piqué ! Prochain dans ~52 sec.",
	meteor_nextbar = "Prochain Bombardement",

	flamepatch = "Gerbe de flammes sur vous",
	flamepatch_desc = "Préviens quand une Gerbe de flammes est sur vous.",
	flamepatch_message = "Gerbe de flammes sur VOUS !",

	armor = "Fondre armure",
	armor_desc = "Préviens quand un joueur est affecté par Fondre armure.",
	armor_other = "Fondre armure : %s",
	armor_you = "Fondre armure sur VOUS !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur la personne affectée par Fondre armure (nécessite d'être promu ou mieux).",
} end )

L:RegisterTranslations("koKR", function() return {
	meteor = "급강하 폭격",  -- By patch, spell name is changed
	meteor_desc = "대략적인 급강하 폭격 타이머입니다.",
	meteor_warning = "약 5초 이내 급강하 폭격 주의",
	meteor_message = "급강하 폭격! 다음은 약 52초 이내",
	meteor_nextbar = "다음 급강하 폭격",

	flamepatch = "당신에 화염 파편",
	flamepatch_desc = "당신에 화염 파편에 대한 경고입니다.",
	flamepatch_message = "당신에 화염 파편!",

	armor = "방어구 녹이기",
	armor_desc = "방어구 녹이기에 걸린 사람에 대한 경고입니다.",
	armor_other = "방어구 녹이기: %s",
	armor_you = "당신에 방어구 녹이기!",

	icon = "전술 표시",
	icon_desc = "방어구 녹이기에 걸린 플레이어에에게 전술 표시를 지정합니다 (승급자 이상 권한 요구).",
} end )

L:RegisterTranslations("zhTW", function() return {
	meteor = "隕石術",
	meteor_desc = "隕石計時",
	meteor_warning = "隕石術可能在 5 秒內施放。",
	meteor_message = "隕石術！- 下一次約 52 秒。",
	meteor_nextbar = "下一次隕石術",

	flamepatch = "烈焰助長",
	flamepatch_desc = "當你受到烈焰助長時警告",
	flamepatch_message = "烈焰助長：[你]",

	armor = "熔化護甲",
	armor_desc = "當某人受到熔化護甲時提示",
	armor_other = "熔化護甲：[%s]",
	armor_you = "熔化護甲：[你]",

	icon = "團隊標記",
	icon_desc = "對受到熔化護甲的目標設置團隊標記（需要權限）",
} end )

L:RegisterTranslations("zhCN", function() return {
	meteor = "俯冲轰炸",
	meteor_desc = "俯冲轰炸记时条。",
	meteor_warning = "5秒后 可能 俯冲轰炸",
	meteor_message = "俯冲轰炸！ ~52秒后再次发动",
	meteor_nextbar = "<下一俯冲轰炸>",

	flamepatch = "烈焰之地(你)",
	flamepatch_desc = "烈焰之地于你警报。",
	flamepatch_message = ">你< 烈焰之地！",

	armor = "熔化护甲",
	armor_desc = "当队友获得熔化护甲发出警报。",
	armor_other = "熔化护甲：>%s<！",
	armor_you = ">你< 熔化护甲！",

	icon = "团队标记",
	icon_desc = "给中了熔化护甲的队员打上团队标记。(需要权限)",
} end )

L:RegisterTranslations("deDE", function() return {
	meteor = "Meteor",
	meteor_desc = "Geschätzte Meteor Timer.",
	meteor_warning = "Möglicher Meteor in ~5sek",
	meteor_message = "Meteor! Nächster in ~52sek",
	meteor_nextbar = "Nächster Meteor",

	flamepatch = "Flammenfeld auf Dir",
	flamepatch_desc = "Warnt vor Flammenfeld auf Dir.",
	flamepatch_message = "Flammenfeld auf DIR!",

	armor = "Rüstungsschmelze",
	armor_desc = "Warnt wer von Rüstungsschmelze betroffen ist.",
	armor_other = "Rüstungsschmelze: %s",
	armor_you = "Rüstungsschmelze auf DIR!",

	icon = "Schlachtzug Symbol",
	icon_desc = "Plaziert ein Schlachtzug Symbol auf Spielern mit Rüstungsschmelze(benötigt Assistent oder höher).",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Tempest Keep"]
mod.otherMenu = "The Eye"
mod.enabletrigger = boss
mod.toggleoptions = {"meteor", "flamepatch", -1, "armor", "icon", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "FlamePatch", 35383)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Armor", 35410)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")

	started = nil
	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:FlamePatch(player)
	if player == pName and db.flamepatch then
		self:IfMessage(L["flamepatch_message"], "Personal", 35383, "Alarm")
	end
end

function mod:Armor(player, spellID)
	if db.armor then
		local other = fmt(L["armor_other"], player)
		if player == pName then
			self:LocalMessage(L["armor_you"], "Important", spellID, "Long")
			self:WideMessage(other)
		else
			self:IfMessage(other, "Attention", spellID)
		end
		self:Bar(other, 60, spellID)
		self:Icon(player, "icon")
	end
end

local function nilOccured()
	occured = nil
end

local function resetMe()
	mod:CheckForWipe()
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		prior = nil
		fireball = nil
		occured = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		self:ScheduleRepeatingEvent("BWAlarTargetSeek", self.AlarCheck, 1, self)
		self:ScheduleEvent("BWAlarNilOccured", nilOccured, 25) --this is here to prevent target problems
	end
end

function mod:AlarCheck()
	if not self:Scan() and not occured then
		occured = true
		if not prior and db.enrage then
			self:Enrage(620)
			prior = true
		end
		if fireball and db.meteor then
			self:IfMessage(L["meteor_message"], "Urgent", 35181, "Alarm")
			self:DelayedMessage(47, L["meteor_warning"], "Important")
			self:Bar(L["meteor_nextbar"], 52, 35181)
		end
		fireball = true

		--re-start target scanning after 25 seconds, this should be enough time for the meteor to land
		self:ScheduleEvent("BWAlarNilOccured", nilOccured, 25)

		--If 120 seconds pass with no meteor, we must have wiped, allow CheckForEngage
		--This timer should overwrite itself every meteor, starting from the start
		self:ScheduleEvent("BWAlarReset", resetMe, 120)
	end
end

