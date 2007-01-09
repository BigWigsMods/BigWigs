------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Ysondre"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

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

	trigger2 = "afflicted by Noxious Breath",

	warn3 = "5 seconds until Noxious Breath!",
	warn4 = "Noxious Breath - 30 seconds till next!",

	engage_message = "Ysondre Engaged! - Noxious Breath in ~10seconds",
	engage_trigger = "The strands of LIFE have been severed! The Dreamers must be avenged!",

	bar1text = "Noxious Breath",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsYsondre = BigWigs:NewModule(boss)
BigWigsYsondre.zonename = {
	AceLibrary("Babble-Zone-2.2")["Ashenvale"],
	AceLibrary("Babble-Zone-2.2")["Duskwood"],
	AceLibrary("Babble-Zone-2.2")["The Hinterlands"],
	AceLibrary("Babble-Zone-2.2")["Feralas"]
}
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
	if (not self.prior and string.find(msg, L["trigger2"])) then
		self.prior = true
		if self.db.profile.noxious then 
			self:TriggerEvent("BigWigs_Message", L["warn4"], "Important")
			self:ScheduleEvent("BigWigs_Message", 25, L["warn3"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["bar1text"], 30, "Interface\\Icons\\Spell_Shadow_LifeDrain02")
		end
	end
end

function BigWigsYsondre:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.engage and msg == L["engage_trigger"] then
		self:TriggerEvent("BigWigs_Message", L["engage_message"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["bar1text"], 10, "Interface\\Icons\\Spell_Shadow_LifeDrain02")
	end
end

function BigWigsYsondre:BigWigs_Message(text)
	if text == L["warn3"] then self.prior = nil end
end
