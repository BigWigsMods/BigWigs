----------------------------------
--      Module Declaration      --
----------------------------------
local mod = BigWigs:NewBoss("Patchwerk", "Naxxramas")
if not mod then return end
mod.enabletrigger = 16028
mod.guid = 16028
mod.toggleOptions = {28131, "berserk", "bosskill"}

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Patchwerk", "enUS", true)
if L then
	L.enragewarn = "5% - Frezied!"
	L.starttrigger1 = "Patchwerk want to play!"
	L.starttrigger2 = "Kel'thuzad make Patchwerk his avatar of war!"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Patchwerk")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Frenzy", 28131)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Frenzy(_, spellId)
	self:IfMessage(L["enragewarn"], "Attention", spellId, "Alarm")
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if self.db.profile.berserk and (msg == L["starttrigger1"] or msg == L["starttrigger2"]) then
		self:Berserk(360)
	end
end

