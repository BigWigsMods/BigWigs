------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Azuregos")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "azuregos",
	
	teleport_cmd = "teleport",
	teleport_name = "Teleport Alert",
	teleport_desc = "Warn for teleport",
	
	shield_cmd = "shield",
	shield_name = "Shield Alert",
	shield_desc = "Warn for shield",
	
	trigger1 = "Come, little ones",
	trigger2 = "^Reflection fades from Azuregos",
	trigger3 = "^Azuregos gains Reflection",

	warn1 = "Teleport!",
	warn2 = "Magic Shield down!",
	warn3 = "Magic Shield UP!",

	shieldbar = "Magic Shield",
} end )

L:RegisterTranslations("deDE", function() return {
	cmd = "azuregos",
	
	teleport_cmd = "teleport",
	teleport_name = "Teleport",
	teleport_desc = "Warnung f\195\188r Azuregos Teleport.",
	
	shield_cmd = "shield",
	shield_name = "Magieschild",
	shield_desc = "Warnung, wenn Magieschild aktiv.",
	
	trigger1 = "Tretet mir",
	trigger2 = "Reflexion schwindet von Azuregos",
	trigger3 = "^Azuregos bekommt 'Reflexion'",

	warn1 = "Teleport!",
	warn2 = "Magieschild: Aus!",
	warn3 = "Magieschild: Aktiv!",	

	shieldbar = "Magieschild",
} end )

L:RegisterTranslations("zhCN", function() return {
	teleport_name = "传送警报",
	teleport_desc = "传送警报",
	
	shield_name = "护盾警报",
	shield_desc = "护盾警报",
	
	trigger1 = "来吧，小子。面对我！",
	trigger2 = "^反射效果从艾索雷葛斯身上消失",
	trigger3 = "^艾索雷葛斯获得了反射",

	warn1 = "传送发动！",
	warn2 = "魔法护盾消失！",
	warn3 = "魔法护盾开启 - 不要施放法术！",
	
	shieldbar = "魔法护盾",
} end )

L:RegisterTranslations("koKR", function() return {
	
	teleport_name = "소환 경고",
	teleport_desc = "소환에 대한 경고",
	
	shield_name = "보호막 경고",
	shield_desc = "보호막에 대한 경고",
	
	trigger1 = "오너라, 조무래기들아! 덤벼봐라!",
	trigger2 = "아주어고스의 몸에서 반사 효과가 사라졌습니다.",
	trigger3 = "아주어고스|1이;가; 반사 효과를",

	warn1 = "강제 소환!",
	warn2 = "마법 보호막 소멸!",
	warn3 = "마법 보호막 동작 - 마법 공격 금지!",

	shieldbar = "마법 보호막",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsAzuregos = BigWigs:NewModule(boss)
BigWigsAzuregos.zonename = { AceLibrary("AceLocale-2.0"):new("BigWigs")("Outdoor Raid Bosses Zone"), AceLibrary("Babble-Zone-2.0")("Azshara") }
BigWigsAzuregos.enabletrigger = boss
BigWigsAzuregos.toggleoptions = {"teleport", "shield", "bosskill"}
BigWigsAzuregos.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsAzuregos:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

function BigWigsAzuregos:CHAT_MSG_MONSTER_YELL( msg )
	if self.db.profile.teleport and string.find(msg, L["trigger1"]) then
		self:TriggerEvent("BigWigs_Message", L["warn1"], "Red")
	end
end

function BigWigsAzuregos:CHAT_MSG_SPELL_AURA_GONE_OTHER( msg )
	if self.db.profile.shield and string.find(msg, L["trigger2"]) then
		self:TriggerEvent("BigWigs_Message", L["warn2"], "White")
	end
end

function BigWigsAzuregos:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if self.db.profile.shield and string.find(arg1, L["trigger3"]) then
		self:TriggerEvent("BigWigs_Message", L["warn3"], "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L["shieldbar"], 10, "Interface\\Icons\\Spell_Frost_FrostShock", "Orange", "Red")
	end
end
