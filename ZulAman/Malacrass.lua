------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Hex Lord Malacrass"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Malacrass",

	engage_trigger = "Da shadow gonna fall on you....",

	bolts = "Spirit Bolts",
	bolts_desc = "Warn when Malacrass starts channelling Spirit Bolts.",
	bolts_trigger = "Your soul gonna bleed!",
	bolts_message = "Incoming Spirit Bolts!",

	soul = "Siphon Soul",
	soul_desc = "Warn who is afflicted by Siphon Soul.",
	soul_trigger = "^(%S+) (%S+) afflicted by Siphon Soul%.$",
	soul_message = "Siphon: %s",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Aman"]
mod.enabletrigger = boss
mod.toggleoptions = {"bolts", "soul", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Siphon")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Siphon")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Siphon")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.bolts and msg == L["bolts_message"] then
		self:Message(L["bolts_message"], "Important")
		self:Bar(L["bolts"], 10, "Spell_Shadow_ShadowBolt")
	end
end

function mod:Siphon(msg)
	local splayer, stype = select(3, msg:find(L["soul_trigger"]))
	if splayer and stype then
		if splayer == L2["you"] and stype == L2["are"] then
			splayer = pName
		end
		local show = L["soul_message"]:format(splayer)
		self:Message(show, "Urgent")
		self:Bar(show, 30, "Spell_Shadow_SoulLeech_2")
	end
end
