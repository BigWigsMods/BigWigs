------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Shazzrah"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	trigger1 = "casts Gate of Shazzrah",
	trigger2 = "Shazzrah gains Deaden Magic",

	warn1 = "Blink - ~45 seconds until next!",
	warn2 = "~5 seconds to Blink!",
	warn3 = "Shazzrah buffed himself!",

	bar1text = "Blink",

	cmd = "Shazzrah",

	selfbuff = "Self Buff Alert",
	selfbuff_desc = "Warn when Shazzrah casts a Self Buff",

	blink = "Blink Alert",
	blink_desc = "Warn when Shazzrah Blinks",
} end)

L:RegisterTranslations("zhCN", function() return {
	trigger1 = "沙斯拉尔施放了沙斯拉尔之门。",
	trigger2 = "沙斯拉尔获得了衰减魔法的效果",

	warn1 = "闪现术 - ~45秒后再次发动",
	warn2 = "~5秒后发动闪现术！",
	warn3 = "自我Buff - 驱散魔法！",

	bar1text = "闪现术",

	selfbuff = "自我Buff警报",
	selfbuff_desc = "沙斯拉尔自我Buff时发出警报",

	blink = "闪现术警报",
	blink_desc = "沙斯拉尔发动闪现术时发出警报",
} end)

L:RegisterTranslations("zhTW", function() return {
	trigger1 = "沙斯拉爾施放了沙斯拉爾之門。",
	trigger2 = "沙斯拉爾獲得了衰減魔法的效果。",

	warn1 = "閃現術 - 45 秒後再次發動！",
	warn2 = "5 秒後發動閃現術！",
	warn3 = "自我 Buff - 驅散魔法",

	bar1text = "閃現術",

	selfbuff = "自我Buff警報",
	selfbuff_desc = "沙斯拉爾自我Buff時發出警報",

	blink = "閃現術警報",
	blink_desc = "沙斯拉爾發動閃現術時發出警報",
} end)

L:RegisterTranslations("koKR", function() return {
	trigger1 = "샤즈라|1이;가; 샤즈라의 문|1을;를; 시전합니다.",
	trigger2 = "샤즈라|1이;가; 마법 약화 효과를 얻었습니다.",

	warn1 = "점멸 - ~45초후 재점멸!",
	warn2 = "~5초후 점멸!",
	warn3 = "마법 약화 버프 - 마법 무효화를 사용하세요!",

	bar1text = "점멸",

	selfbuff = "약화 디버프 경고",
	selfbuff_desc = "샤즈라가 약화 디버프 시전시 경고",

	blink = "점멸 경고",
	blink_desc = "샤즈라 점멸 시 경고",
} end)

L:RegisterTranslations("deDE", function() return {
	trigger1 = "Shazzrah wirkt Portal von Shazzrah",
	trigger2 = "Shazzrah bekommt 'Magie d\195\164mpfen'",

	warn1 = "Portal! N\195\164chstes in ~45 Sekunden!",
	warn2 = "Portal in ~5 Sekunden!",
	warn3 = "Magied\195\164mpfer auf Shazzrah!",

	bar1text = "Portal",

	selfbuff = "Selbstbuff",
	selfbuff_desc = "Warnung, wenn Magied\195\164mpfer auf Shazzrah.",

	blink = "Portal",
	blink_desc = "Warnung, wenn Shazzrah Portal wirkt.",
} end)

L:RegisterTranslations("frFR", function() return {
	trigger1 = "Shazzrah lance Porte de Shazzrah.",
	trigger2 = "Shazzrah gagne Amortissement de la magie.",

	warn1 = "Transfert ! - ~45 secondes avant le prochain",
	warn2 = "~5 secondes avant Transfert !",
	warn3 = "Shazzrah se buff ! - Dispellez le",

	bar1text = "Transfert",

	selfbuff = "Alerte Buff",
	selfbuff_desc = "Pr\195\169viens quand Shazzrah se buff.",

	blink = "Alerte Transfert",
	blink_desc = "Pr\195\169viens quand Shazzrah se t\195\169l\195\169porte.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
mod.enabletrigger = boss
mod.toggleoptions = {"selfbuff", "blink", "bosskill"}
mod.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
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

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if (msg:find(L["trigger2"])) then
		self:TriggerEvent("BigWigs_SendSync", "ShazzrahDeadenMagic")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if (msg:find(L["trigger1"])) then
		self:TriggerEvent("BigWigs_SendSync", "ShazzrahBlink")
	end
end

function mod:BigWigs_RecvSync(sync)
	if (sync == "ShazzrahBlink" and self.db.profile.blink) then
		self:TriggerEvent("BigWigs_Message", L["warn1"], "Important")
		self:ScheduleEvent("BigWigs_Message", 40, L["warn2"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, L["bar1text"], 45, "Interface\\Icons\\Spell_Arcane_Blink")
	elseif (sync == "ShazzrahDeadenMagic" and self.db.profile.selfbuff) then
		self:TriggerEvent("BigWigs_Message", L["warn3"], "Important")
	end
end
