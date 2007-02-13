------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Hyakiss the Lurker"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local times

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Hyakiss",

	web_cmd = "web",
	web_name = "Web",
	web_desc = "Alert when a player gets webbed.",

	web_trigger = "^([^%s]+) ([^%s]+) afflicted by Hyakiss' Web.",
	web_message = "%s has been webbed.",
	web_bar = "Web: %s",

	you = "You",
} end )

----------------------------------
--   Module Declaration    --
----------------------------------

BigWigsHyakiss = BigWigs:NewModule(boss)
BigWigsHyakiss.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsHyakiss.enabletrigger = boss
BigWigsHyakiss.toggleoptions = {"web", "bosskill"}
BigWigsHyakiss.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsHyakiss:OnEnable()
	times = {}

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Web")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Web")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Web")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "HyakissWeb", 3)
end

------------------------------
--    Event Handlers     --
------------------------------

function BigWigsHyakiss:Web(msg)
	if msg:find(L["web_trigger"]) then
		local webPlayer, webType = select(3, msg:find(L["web_trigger"]))
		if webPlayer and webType then
			if webPlayer == L["you"] then
				webPlayer = UnitName("player")
			end
			local t = GetTime()
			if not times[webPlayer] or (times[webPlayer] and (times[webPlayer] + 5) < t) then
				self:Sync("HyakissWeb "..webPlayer)
			end
		end
	end
end

function BigWigsHyakiss:BigWigs_RecvSync(sync, rest, nick)
	if sync == "HyakissWeb" and rest and self.db.profile.web then
		local t = GetTime()
		if not times[rest] or (times[rest] and (times[rest] + 5) < t) then
			if self.db.profile.web then
				self:Message(string.format(L["web_message"], rest), "Urgent")
				self:Bar( string.format(L["web_bar"], rest), 8, "Spell_Nature_Web")
			end
			times[rest] = t
		end
	end
end
