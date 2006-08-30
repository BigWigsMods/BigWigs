------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Shazzrah")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	trigger1 = "Shazzrah gains Blink",
	trigger2 = "Shazzrah gains Deaden Magic",

	warn1 = "Blink - ~45 seconds until next!",
	warn2 = "~5 seconds to Blink!",
	warn3 = "Self buff - Dispel Magic!",

	bar1text = "Blink",

	cmd = "Shazzrah",
	
	selfbuff_cmd = "selfbuff",
	selfbuff_name = "Self Buff Alert",
	selfbuff_desc = "Warn when Shazzrah casts a Self Buff",
	
	blink_cmd = "blink",
	blink_name = "Blink Alert",
	blink_desc = "Warn when Shazzrah Blinks",
} end)

L:RegisterTranslations("zhCN", function() return {
	trigger1 = "沙斯拉尔获得了闪现术的效果",
	trigger2 = "沙斯拉尔获得了衰减魔法的效果",

	warn1 = "闪现术 - ~45秒后再次发动",
	warn2 = "~5秒后发动闪现术！",
	warn3 = "自我Buff - 驱散魔法！",

	bar1text = "闪现术",
	
	selfbuff_name = "自我Buff警报",
	selfbuff_desc = "沙斯拉尔自我Buff时发出警报",
	
	blink_name = "闪现术警报",
	blink_desc = "沙斯拉尔发动闪现术时发出警报",
} end)

L:RegisterTranslations("koKR", function() return {
	trigger1 = "샤즈라|1이;가; 샤즈라의 문|1을;를; 시전합니다.",
	trigger2 = "샤즈라|1이;가; 마법 약화 효과를 얻었습니다.",

	warn1 = "점멸 - ~45초후 재점멸!",
	warn2 = "~5초후 점멸!",
	warn3 = "마법 약화 버프 - 마법 무효화를 사용하세요!",

	bar1text = "점멸",
} end)

L:RegisterTranslations("deDE", function() return {
	trigger1 = "Shazzrah wirkt Portal von Shazzrah",
	trigger2 = "Shazzrah bekommt 'Magie d\195\164mpfen'",

	warn1 = "Portal! N\195\164chstes in ~45 Sekunden!",
	warn2 = "~5 Sekunden bis Portal!",
	warn3 = "Magied\195\164mpfer auf Shazzrah! - Entfernen!",

	bar1text = "Portal",

	cmd = "Shazzrah",
	
	selfbuff_cmd = "selfbuff",
	selfbuff_name = "Selbstbuff",
	selfbuff_desc = "Warnung, wenn Shazzrah Magied\195\164mpfer hat.",
	
	blink_cmd = "blink",
	blink_name = "Portal",
	blink_desc = "Warnung, wenn Shazzrah Portal wirkt.",
} end)

L:RegisterTranslations("frFR", function() return {
	trigger1 = "Shazzrah gagne Porte de Shazzrah",
	trigger2 = "Shazzrah gagne Magie diminu\195\169e",

	warn1 = "Transfert - ~45 sec avant le prochain",
	warn2 = "~5 secondes avant Transfert !",
	warn3 = "Shazzrah se buff - Dispellez le !",

	bar1text = "Transfert",
} end)


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsShazzrah = BigWigs:NewModule(boss)
BigWigsShazzrah.zonename = AceLibrary("Babble-Zone-2.0")("Molten Core")
BigWigsShazzrah.enabletrigger = boss
BigWigsShazzrah.toggleoptions = {"selfbuff", "blink", "bosskill"}
BigWigsShazzrah.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsShazzrah:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ShazzrahBlink", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "ShazzrahDeadenMagic", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsShazzrah:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if (string.find(msg, L["trigger2"])) then
		self:TriggerEvent("BigWigs_SendSync", "ShazzrahDeadenMagic")
	end
end

function BigWigsShazzrah:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if (string.find(msg, L["trigger1"])) then
		self:TriggerEvent("BigWigs_SendSync", "ShazzrahBlink")
	end
end

function BigWigsShazzrah:BigWigs_RecvSync(sync)
	if (sync == "ShazzrahBlink" and self.db.profile.blink) then
		self:TriggerEvent("BigWigs_Message", L["warn1"], "Red")
		self:ScheduleEvent("BigWigs_Message", 40, L["warn2"], "Orange")
		self:TriggerEvent("BigWigs_StartBar", self, L["bar1text"], 45, "Interface\\Icons\\Spell_Arcane_Blink", "Yellow", "Orange", "Red")
	elseif (sync == "ShazzrahDeadenMagic" and self.db.profile.selfbuff) then
		self:TriggerEvent("BigWigs_Message", L["warn3"], "Red")
	end
end
