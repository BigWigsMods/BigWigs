------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Shadikith the Glider"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local started

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Shadikith",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

BigWigsShadikith = BigWigs:NewModule(boss)
BigWigsShadikith.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsShadikith.enabletrigger = boss
BigWigsShadikith.toggleoptions = {"bosskill"}
BigWigsShadikith.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsShadikith:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("BigWigs_RecvSync")
	started = nil
end

------------------------------
--    Event Handlers     --
------------------------------


function BigWigsShadikith:BigWigs_RecvSync( sync, rest, nick )
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
	end
end

