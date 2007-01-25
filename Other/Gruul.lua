------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Gruul"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Gruul",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsGruul = BigWigs:NewModule(boss)
BigWigsGruul.zonename = AceLibrary("Babble-Zone-2.2")["Gruul's Lair"]
BigWigsGruul.enabletrigger = boss
BigWigsGruul.toggleoptions = {"bosskill"}
BigWigsGruul.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsGruul:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end
