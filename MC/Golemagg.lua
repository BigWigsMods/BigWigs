------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Golemagg the Incinerator"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Golemagg",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsGarr = BigWigs:NewModule(boss)
BigWigsGarr.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
BigWigsGarr.enabletrigger = boss
BigWigsGarr.toggleoptions = {"bosskill"}
BigWigsGarr.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsGarr:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end
