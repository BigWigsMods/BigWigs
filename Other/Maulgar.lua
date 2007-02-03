------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High King Maulgar"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Maulgar",

	heal_cmd = "heal",
	heal_name = "Heal Alert",
	heal_desc = "Warn when Blindeye the Seer begins to cast Prayer of Healing",

	shield_cmd = "shield",
	shield_name = "Shield Alert",
	shield_desc = "Warn when Blindeye the Seer gains Greater Power Word: Shield",

	heal_trigger = "begins to cast Prayer of Healing",
	heal_message = "Prayer of Healing being Cast!",
	heal_bar = "Healing",

	shield_trigger = "gains Greater Power Word: Shield",
	shield2_trigger = "gains Spell Shield.",
	shield_message = "Blindeye gains a shield!",
	shield2_message = "Spell Shield on Krosh!",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsMaulgar = BigWigs:NewModule(boss)
BigWigsMaulgar.zonename = AceLibrary("Babble-Zone-2.2")["Gruul's Lair"]
BigWigsMaulgar.otherMenu = true
BigWigsMaulgar.enabletrigger = boss
BigWigsMaulgar.toggleoptions = {"shield", "heal", "bosskill"}
BigWigsMaulgar.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsMaulgar:OnEnable()
	self.core:Print("High King Maulgar mod by Funkydude, this mod is beta quality, at best! Please don't rely on it for anything!")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsMaulgar:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if (msg:find(L["heal_trigger"])) and self.db.profile.heal then
		self:TriggerEvent("BigWigs_Message", L["heal_message"], "Important")
	end
end

function BigWigsMaulgar:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if (msg:find(L["shield_trigger"])) and self.db.profile.shield then
		self:TriggerEvent("BigWigs_Message", L["shield_message"], "Important")
	elseif (msg:find(L["shield2_trigger"])) and self.db.profile.shield then
		self:TriggerEvent("BigWigs_Message", L["shield2_message"], "Important")
	end
end
