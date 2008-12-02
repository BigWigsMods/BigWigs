------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Patchwerk"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Patchwerk",

	enragewarn = "5% - Enrage!",
	starttrigger1 = "Patchwerk want to play!",
	starttrigger2 = "Kel'thuzad make Patchwerk his avatar of war!",
} end )

L:RegisterTranslations("deDE", function() return {
	enragewarn = "5% - Enrage!",
	starttrigger1 = "Flickwerk spielen m\195\182chte!",
	starttrigger2 = "Kel’thuzad macht Flickwerk zu seinem Abgesandten von Krieg!",
} end )

L:RegisterTranslations("koKR", function() return {
	enragewarn = "5% - 격노!",
	starttrigger1 = "패치워크랑 놀아줘!",
	starttrigger2 = "켈투자드님이 패치워크 싸움꾼으로 만들었다.",
} end )

L:RegisterTranslations("zhCN", function() return {
	enragewarn = "5% - 狂暴！",
	starttrigger1 = "帕奇维克要跟你玩！",
	starttrigger2 = "帕奇维克是克尔苏加德的战神！",
} end )

L:RegisterTranslations("zhTW", function() return {
	enragewarn = "5 % - 狂怒！",
	starttrigger1 = "縫補者要跟你玩！",
	starttrigger2 = "縫補者是科爾蘇加德的戰神！",
} end )

L:RegisterTranslations("frFR", function() return {
	enragewarn = "5% - Enrager !",
	starttrigger1 = "R'cousu veut jouer !",
	starttrigger2 = "R'cousu avatar de guerre pour Kel'Thuzad !",
} end )

L:RegisterTranslations("ruRU", function() return {
	enragewarn = "5% - Ярость!",
	starttrigger1 = "Лоскутик входит в игру",  --correct this
	starttrigger2 = "Кел'Тузад создаёт Лоскутика аватара войны!!", --correct this
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 16028
mod.toggleoptions = {"enrage", "berserk", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Enraged", 28131)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Enraged(_, spellID)
	if self.db.profile.enrage then
		self:IfMessage(L["enragewarn"], "Attention", spellID, "Alarm")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.berserk and (msg == L["starttrigger1"] or msg == L["starttrigger2"]) then
		self:Enrage(360, true)
	end
end

