------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Ysondre"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local BZ = AceLibrary("Babble-Zone-2.2")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Ysondre",

	engage_cmd = "engage",
	engage_name = "Engage Alert",
	engage_desc = "Warn when Ysondre is engaged",

	noxious_cmd = "noxious",
	noxious_name = "Noxious breath alert",
	noxious_desc = "Warn for noxious breath",

	engage_message = "Ysondre Engaged! - Noxious Breath in ~10seconds",
	engage_trigger = "The strands of LIFE have been severed! The Dreamers must be avenged!",

	noxious_trigger = "afflicted by Noxious Breath",
	noxious_warn = "5 seconds until Noxious Breath!",
	noxious_message = "Noxious Breath - 30 seconds till next!",
	noxious_bar = "Noxious Breath",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsYsondre = BigWigs:NewModule(boss)
BigWigsYsondre.zonename = {BZ["Ashenvale"], BZ["Duskwood"], BZ["The Hinterlands"], BZ["Feralas"]}
BigWigsYsondre.otherMenu = "Azeroth"
BigWigsYsondre.enabletrigger = boss
BigWigsYsondre.toggleoptions = {"engage", -1, "noxious", "bosskill"}
BigWigsYsondre.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsYsondre:OnEnable()
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

function BigWigsYsondre:Event( msg )
	if (not self.prior and msg:find(L["noxious_trigger"])) then
		self.prior = true
		if self.db.profile.noxious then 
			self:Message( L["noxious_message"], "Important")
			self:DelayedMessage( 25, L["noxious_warn"], "Important")
			self:Bar(L["noxious_bar"], 30, "Spell_Shadow_LifeDrain02")
		end
	end
end

function BigWigsYsondre:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.engage and msg == L["engage_trigger"] then
		self:Message(L["engage_message"], "Important")
		self:Bar( L["noxious_bar"], 10, "Spell_Shadow_LifeDrain02")
	end
end

function BigWigsYsondre:BigWigs_Message(text)
	if text == L["noxious_warn"] then self.prior = nil end
end
