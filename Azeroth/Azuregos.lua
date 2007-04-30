------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Azuregos"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Azuregos",

	engage = "Engage Alert",
	engage_desc = ("Warn when %s is engaged"):format(boss),

	teleport = "Teleport Alert",
	teleport_desc = "Warn for teleport",

	shield = "Shield Alert",
	shield_desc = "Warn for shield",

	engage_trigger = "^This place is under my protection",
	engage_message = "%s Engaged!",

	teleport_trigger = "^Come, little ones",
	teleport_message = "Teleport!",

	shield_trigger = "^Azuregos gains Reflection",
	shield_down = "Magic Shield down!",
	shield_up = "Magic Shield UP!",
	shield_bar = "Magic Shield",
} end )

L:RegisterTranslations("deDE", function() return {
	teleport = "Teleport",
	teleport_desc = "Warnung f\195\188r Azuregos Teleport.",

	shield = "Magieschild",
	shield_desc = "Warnung, wenn Magieschild aktiv.",

	teleport_trigger = "Tretet mir",
	teleport_message = "Teleport!",

	shield_trigger = "^Azuregos bekommt 'Reflexion'",
	shield_down = "Magieschild: Aus!",
	shield_up = "Magieschild: Aktiv!",
	shield_bar = "Magieschild",
} end )

L:RegisterTranslations("frFR", function() return {
	engage = "Alerte Engagement",
	engage_desc = ("Pr\195\169viens quand %s est engag\195\169."):format(boss),

	teleport = "Alerte T\195\169l\195\169portation",
	teleport_desc = "Pr\195\169viens quand Azuregos t\195\169l\195\169porte quelqu'un.",

	shield = "Alerte Bouclier",
	shield_desc = "Pr\195\169viens quand Azuregos est prot\195\169g\195\169 par un bouclier magique.",

	engage_trigger = "^Cet endroit est sous ma protection",
	engage_message = "%s engag\195\169 !",

	teleport_trigger = "^Venez m'affronter, mes petits\194\160!",
	teleport_message = "T\195\169l\195\169portation !",

	shield_trigger = "^Azuregos gagne Renvoi.",
	shield_down = "Bouclier magique dissip\195\169 !",
	shield_up = "Bouclier magique en place !",
	shield_bar = "Bouclier magique",
} end )

L:RegisterTranslations("zhCN", function() return {
	teleport = "传送警报",
	teleport_desc = "传送警报",

	shield = "护盾警报",
	shield_desc = "护盾警报",

	teleport_trigger = "来吧，小子。面对我！",
	teleport_message = "传送发动！",

	shield_trigger = "^艾索雷葛斯获得了反射",
	shield_down = "魔法护盾消失！",
	shield_up = "魔法护盾开启 - 不要施放法术！",
	shield_bar = "魔法护盾",
} end )

L:RegisterTranslations("zhTW", function() return {
	teleport = "傳送警報",
	teleport_desc = "傳送警報",

	shield = "護盾警報",
	shield_desc = "護盾警報",

	teleport_trigger = "來吧，小子。面對我！",
	teleport_message = "傳送發動！",

	shield_trigger = "^艾索雷葛斯獲得了反射",
	shield_down = "魔法護盾消失！",
	shield_up = "魔法護盾開啟 - 不要施放法術！",
	shield_bar = "魔法護盾",
} end )

L:RegisterTranslations("koKR", function() return {
	engage = "전투 시작 알림",
	engage_desc = ("%s 전투 시작 시 알림"):format(boss),

	teleport = "소환 경고",
	teleport_desc = "소환에 대한 경고",

	shield = "보호막 경고",
	shield_desc = "보호막에 대한 경고",

	engage_trigger = "^This place is under my protection", -- check
	engage_message = "%s 전투 시작!",

	teleport_trigger = "^오너라, 조무래기들아! 덤벼봐라!",
	teleport_message = "강제 소환!",

	shield_trigger = "아주어고스|1이;가; 반사 효과를",
	shield_down = "마법 보호막 소멸!",
	shield_up = "마법 보호막 동작 - 마법 공격 금지!",
	shield_bar = "마법 보호막",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Azshara"]
mod.otherMenu = "Azeroth"
mod.enabletrigger = boss
mod.toggleoptions = {"engage", "teleport", "shield", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "AzuShield", 3)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.teleport and msg:find(L["teleport_trigger"]) then
		self:Message(L["teleport_message"], "Important")
	elseif self.db.profile.engage and msg:find(L["engage_trigger"]) then
		self:Message(L["engage_message"]:format(boss), "Attention")
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg:find(L["shield_trigger"]) then
		self:Sync("AzuShield")
	end
end

function mod:BigWigs_RecvSync(sync)
	if sync == "AzuShield" and self.db.profile.shield then
		self:Message(L["shield_up"], "Attention")
		self:Bar(L["shield_bar"], 10, "Spell_Frost_FrostShock")
		self:DelayedMessage(10, L["shield_down"], "Positive")
	end
end
