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

	engage_cmd = "engage",
	engage_name = "Engage Alert",
	engage_desc = "Warn when Kazzak is pulled",

	engage_trigger = "For the Legion! For Kil'Jaeden!",
	engage_message = "Kazzak Engaged - Have a fun Death!",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsKazzak = BigWigs:NewModule(boss)
BigWigsKazzak.zonename = AceLibrary("Babble-Zone-2.2")["Hellfire Peninsula"]
BigWigsKazzak.otherMenu = true
BigWigsKazzak.enabletrigger = boss
BigWigsKazzak.toggleoptions = {"engage", "bosskill"}
BigWigsKazzak.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsKazzak:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsKazzak:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.engage and msg == L["engage_trigger"] then
		self:TriggerEvent("BigWigs_Message", L["engage_message"], "Attention")
	end
end
