----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Patchwerk"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.zoneName = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 16028
mod.toggleOptions = {"enrage", "berserk", "bosskill"}
mod.consoleCmd = "Patchwerk"

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Patchwerk", "enUS", true)
if L then
	L.enragewarn = "5% - Enrage!"
	L.starttrigger1 = "Patchwerk want to play!"
	L.starttrigger2 = "Kel'thuzad make Patchwerk his avatar of war!"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Patchwerk")
mod.locale = L

L:RegisterTranslations("deDE", function() return {
	enragewarn = "5% - Raserei!",
	starttrigger1 = "Flickwerk spielen möchte!",
	starttrigger2 = "Kel’Thuzad macht Flickwerk zu seinem Abgesandten von Krieg!", -- Yes, that's really a ´ instead of a '
} end )

L:RegisterTranslations("koKR", function() return {
	enragewarn = "5% - 광기!",
	starttrigger1 = "패치워크랑 놀아줘!",
	starttrigger2 = "켈투자드님이 패치워크 싸움꾼으로 만들었다.",
} end )

L:RegisterTranslations("zhCN", function() return {
	enragewarn = "5% - 狂乱！",
	starttrigger1 = "帕奇维克要跟你玩！",
	starttrigger2 = "帕奇维克是克尔苏加德的战神！",
} end )

L:RegisterTranslations("zhTW", function() return {
	enragewarn = "5 % - 狂亂！",
	starttrigger1 = "縫補者要跟你玩!",
	starttrigger2 = "科爾蘇加德讓縫補者成為戰爭的化身!",
} end )

L:RegisterTranslations("frFR", function() return {
	enragewarn = "5% - Frénésie !",
	starttrigger1 = "R'cousu veut jouer !",
	starttrigger2 = "R'cousu avatar de guerre pour Kel'Thuzad !",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Enraged", 28131)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Enraged(_, spellId)
	if self.db.profile.enrage then
		self:IfMessage(L["enragewarn"], "Attention", spellId, "Alarm")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.berserk and (msg == L["starttrigger1"] or msg == L["starttrigger2"]) then
		self:Enrage(360, true)
	end
end

