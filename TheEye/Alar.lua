------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Al'ar"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local started = nil
local prior = nil
local fireball = nil
local occured = true
local pName = nil
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Alar",

	engage_message = "%s engaged - Phase 1",

	meteor = "Meteor",
	meteor_desc = "Estimated Meteor Timers.",
	meteor_warning = "Possible Meteor in ~5sec",
	meteor_message = "Meteor! Next in ~52sec",
	meteor_nextbar = "Next Meteor",

	flamepatch = "Flame Patch on You",
	flamepatch_desc = "Warn for a Flame Patch on You.",
	flamepatch_trigger = "You are afflicted by Flame Patch.",
	flamepatch_message = "Flame Patch on YOU!",

	armor = "Melt Armor",
	armor_desc = "Warn who gets Melt Armor.",
	armor_trigger = "^(%S+) (%S+) afflicted by Melt Armor%.$",
	armor_other = "Melt Armor: %s",
	armor_you = "Melt Armor on YOU!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player with Melt Armor(requires promoted or higher).",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_message = "%s engagé - Phase 1",

	meteor = "Météore",
	meteor_desc = "Délais estimés entre les météores.",
	meteor_warning = "Météore probable dans ~5 sec.",
	meteor_message = "Météore ! Prochain dans ~52 sec.",
	meteor_nextbar = "Prochain météore",

	flamepatch = "Gerbe de flammes sur vous",
	flamepatch_desc = "Préviens quand une Gerbe de flammes est sur vous.",
	flamepatch_trigger = "Vous subissez les effets de Gerbe de flammes.",
	flamepatch_message = "Gerbe de flammes sur VOUS !",

	armor = "Fondre armure",
	armor_desc = "Préviens quand un joueur est affecté par Fondre armure.",
	armor_trigger = "^([^%s]+) ([^%s]+) les effets .* Fondre armure%.$",
	armor_other = "Fondre armure : %s",
	armor_you = "Fondre armure sur VOUS !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur la personne affectée par Fondre armure (nécessite d'être promu ou mieux).",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_message = "%s 전투 개시 - 1 단계",

	meteor = "유성",
	meteor_desc = "대략적인 유성 타이머입니다.",
	meteor_warning = "약 5초 이내 유성 주의",
	meteor_message = "유성! 다음은 약 52초 이내",
	meteor_nextbar = "다음 유성",

	flamepatch = "당신에 화염 파편",
	flamepatch_desc = "당신에 화염 파편에 대한 경고입니다.",
	flamepatch_trigger = "당신은 화염 파편에 걸렸습니다.",
	flamepatch_message = "당신에 화염 파편!",

	armor = "방어구 녹이기",
	armor_desc = "방어구 녹이기에 걸린 사람에 대한 경고입니다.",
	armor_trigger =  "^([^|;%s]*)(.*)방어구 녹이기에 걸렸습니다%.$",
	armor_other = "방어구 녹이기: %s",
	armor_you = "당신에 방어구 녹이기!",

	icon = "전술 표시",
	icon_desc = "방어구 녹이기에 걸린 플레이어에에게 전술 표시를 지정합니다 (승급자 이상 권한 요구).",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_message = "%s 開戰 - 第一階段！",

	meteor = "隕石術",
	meteor_desc = "隕石計時",
	meteor_warning = "隕石術可能在 5 秒內施放。",
	meteor_message = "隕石術！- 下一次約 52 秒。",
	meteor_nextbar = "下一次隕石術",

	flamepatch = "烈焰助長",
	flamepatch_desc = "當你受到烈焰助長時警告",
	flamepatch_trigger = "你受到了烈焰助長效果的影響。",
	flamepatch_message = "你中了烈焰助長！",

	armor = "熔化護甲",
	armor_desc = "當某人受到熔化護甲時提示",
	armor_trigger = "^(.+)受([到了]*)熔化護甲效果的影響。",
	armor_other = "熔化護甲：%s",
	armor_you = "你受到熔化護甲！",

	icon = "團隊標記",
	icon_desc = "對受到熔化護甲的目標設置團隊標記（需要權限）",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage_message = "%s 激活 - 阶段 1",

	meteor = "流星",
	meteor_desc = "流星记时条",
	meteor_warning = "5秒后 可能 流星",
	meteor_message = "流星! ~52秒后再次发动",
	meteor_nextbar = "下次 流星",

	flamepatch = "烈焰之地(你)",
	flamepatch_desc = "烈焰之地于你警报",
	flamepatch_trigger = "你受到了烈焰之地效果的影响。",
	flamepatch_message = "烈焰之地 >你<!",

	armor = "熔化护甲",
	armor_desc = "当队友获得熔化护甲发出警报",
	armor_trigger = "^(%S+)受(%S+)了熔化护甲效果的影响。$",
	armor_other = "熔化护甲: %s",
	armor_you = "熔化护甲 >你<!",

	icon = "团队标记",
	icon_desc = "给中了熔化护甲的队员打上团队标记(需要助理或更高权限).",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_message = "%s angegriffen - Phase 1",

	meteor = "Meteor",
	meteor_desc = "Geschätzte Meteor Timer.",
	meteor_warning = "Möglicher Meteor in ~5sek",
	meteor_message = "Meteor! Nächster in ~52sek",
	meteor_nextbar = "Nächster Meteor",

	flamepatch = "Flammenfeld auf Dir",
	flamepatch_desc = "Warnt vor Flammenfeld auf Dir.",
	flamepatch_trigger = "Ihr seid von Flammenfeld betroffen.",
	flamepatch_message = "Flammenfeld auf DIR!",

	armor = "Rüstungsschmelze",
	armor_desc = "Warnt wer von Rüstungsschmelze betroffen ist.",
	armor_trigger = "^(%S+) (%S+) ist von Rüstungsschmelze betroffen%.$",
	armor_other = "Rüstungsschmelze: %s",
	armor_you = "Rüstungsschmelze auf DIR!",

	icon = "Schlachtzug Symbol",
	icon_desc = "Plaziert ein Schlachtzug Symbol auf Spielern mit Rüstungsschmelze(benötigt Assistent oder höher).",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Tempest Keep"]
mod.otherMenu = "The Eye"
mod.enabletrigger = boss
mod.toggleoptions = {"meteor", "flamepatch", -1, "armor", "icon", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "DebuffEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "DebuffEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "DebuffEvent")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "AlArArmor", 5)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	started = nil
	pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------

local function nilOccured()
	occured = nil
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
		self:Message(fmt(L["engage_message"], boss), "Attention")
		self:ScheduleRepeatingEvent("BWAlarTargetSeek", self.AlarCheck, 1, self)
		self:ScheduleEvent("BWAlarNilOccured", nilOccured, 25) --this is here to prevent target problems
	elseif sync == "AlArArmor" and rest and self.db.profile.armor then
		local other = fmt(L["armor_other"], rest)
		if rest == UnitName("player") then
			self:Message(L["armor_you"], "Personal", true, "Long")
			self:Message(other, "Attention", nil, nil, true)
		else
			self:Message(other, "Attention")
		end
		self:Bar(other, 60, "Spell_Fire_Immolation")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	end
end

function mod:AlarCheck()
	if not self:Scan() and not occured then
		occured = true
		if not prior and self.db.profile.enrage then
			self:DelayedMessage(320, fmt(L2["enrage_min"], 5), "Positive")
			self:DelayedMessage(440, fmt(L2["enrage_min"], 3), "Positive")
			self:DelayedMessage(560, fmt(L2["enrage_min"], 1), "Positive")
			self:DelayedMessage(590, fmt(L2["enrage_sec"], 30), "Positive")
			self:DelayedMessage(610, fmt(L2["enrage_sec"], 10), "Urgent")
			self:DelayedMessage(615, fmt(L2["enrage_sec"], 5), "Urgent")
			self:DelayedMessage(620, fmt(L2["enrage_end"], boss), "Attention", nil, "Alarm")
			self:Bar(L2["enrage"], 620, "Spell_Shadow_UnholyFrenzy")
			prior = true
		end
		if fireball and self.db.profile.meteor then
			self:Message(L["meteor_message"], "Urgent", nil, "Alarm")
			self:DelayedMessage(47, L["meteor_warning"], "Important")
			self:Bar(L["meteor_nextbar"], 52, "Spell_Fire_Burnout")
		end
		fireball = true
		self:ScheduleEvent("BWAlarNilOccured", nilOccured, 25)
	end
end

function mod:DebuffEvent(msg)
	if self.db.profile.flamepatch and msg == L["flamepatch_trigger"] then
		self:Message(L["flamepatch_message"], "Personal", true, "Alarm")
	end

	local aplayer, atype = select(3, msg:find(L["armor_trigger"]))
	if aplayer and atype then
		if aplayer == L2["you"] and atype == L2["are"] then
			aplayer = pName
		end
		self:Sync("AlArArmor "..aplayer)
	end
end
