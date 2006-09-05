------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Kel'Thuzad")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Kelthuzad",

    phase2_trigger = "Minions, servants, soldiers of the cold dark! Obey the call of Ke'Thuzad!",
	phase2_warning = "Phase 2, Kel'Thuzad active!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsKelThuzad = BigWigs:NewModule(boss)
BigWigsKelThuzad.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsKelThuzad.enabletrigger = boss
BigWigsKelThuzad.toggleoptions = { "bosskill" }
BigWigsKelThuzad.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

--[[

you enter room, Kel'Thuzad says bla blah blah
	<N-NmE>	and phase 1 begins
	<N-NmE>	you cant target Kel at this phase
	<N-NmE>	adds from the surrounding rooms move towards you
	<N-NmE>	and you have to stop em before they do
	<N-NmE>	after approx 5 minutes of waves
	<N-NmE>	phase 2 begins
	<N-NmE>	and Kel "spawns"
	<N-NmE>	hes got ALOT of abilities
	<vhaarr>	:S
	<N-NmE>	http://www.thottbot.com/?sp=28410 - Mind control ability
	<N-NmE>	http://thottbot.com/?sp=28478 > his interruptable frost 9k frost bolt
	<N-NmE>	http://thottbot.com/?sp=28479 this is propably his aoe frostbolt that you gotta eat
	<N-NmE>	http://www.thottbot.com/?sp=27820
	<N-NmE>	got that as well
	<N-NmE>	or atleast we think its those spells


--]]

function BigWigsKelThuzad:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsKelThuzad:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["phase2_trigger"] then
		if self.db.profile.deepbreath then self:TriggerEvent("BigWigs_Message", L["phase2_warning"], "Red") end
	end
end


