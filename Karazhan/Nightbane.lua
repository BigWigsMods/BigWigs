------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Nightbane"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

--[[
n phase1 (on the ground) he has a fear and sometimes at a random player the ground is burning and do aoe dmg to ppl on it.
fear cooldown seems to be 30-40seconds, at least enough that one warrior can tank it without fearward.
every 25% he going into the air. one person will get "rain of bones" debuff and will damage nearby people. 
5 skeletons spawn and nightbane will cast some damage spell on some people. after some time he will come back.
]]--

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Nightbane",


	fear_trigger = "afflicted by Bellowing Roar",
	
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

BigWigsNightbane = BigWigs:NewModule(boss)
BigWigsNightbane.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsNightbane.enabletrigger = boss
BigWigsNightbane.toggleoptions = {"bosskill"}
BigWigsNightbane.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsNightbane:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--     Event Handlers    --
------------------------------

function BigWigsNightbane:BigWigs_RecvSync( sync, rest, nick )
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
	end
end
