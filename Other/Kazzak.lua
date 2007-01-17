------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Doom Lord Kazzak"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Kazzak",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsKazzak = BigWigs:NewModule(boss)
BigWigsKazzak.zonename = AceLibrary("Babble-Zone-2.2")["Hellfire Peninsula"]
BigWigsKazzak.enabletrigger = boss
BigWigsKazzak.toggleoptions = {"bosskill"}
BigWigsKazzak.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsKazzak:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end
