------------------------------
--      Are you local?    --
------------------------------

local lady = AceLibrary("Babble-Boss-2.2")["Grandmother"]
local boss = AceLibrary("Babble-Boss-2.2")["The Big Bad Wolf"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local playerName = nil

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "TheBigBadWolf",

	youriding_cmd = "youriding",
	youriding_name = "You are Red Riding Hood alert",
	youriding_desc = "Warn when you are Red Riding Hood",

	elseriding_cmd = "elseriding",
	elseriding_name = "Others Red Riding Hood alert",
	elseriding_desc = "Warn when others are Red Riding Hood",

	icon_cmd = "icon",
	icon_name = "Place Icon",
	icon_desc = "Put a Raid Icon on the person who's Red Riding Hood. (Requires promoted or higher)",

	riding_trigger = "^([^%s]+) gain(.*) Red Riding Hood",
	you = "You",

	riding_youwarn = "You are Red Riding Hood!",
	riding_otherwarn = "%s is Red Riding Hood!",
	riding_bar = "%s Running",
} end )

L:RegisterTranslations("deDE", function() return {
	youriding_name = "Du bist Rotk\195\164ppchen Warnung",
	youriding_desc = "Warnung wenn du Rotk\195\164ppchen bist",

	elseriding_name = "Andere sind Rotk\195\164ppchen Warnung",
	elseriding_desc = "Warnung wenn andere Rotk\195\164ppchen sind",

	icon_name = "Zeige Icon",
	icon_desc = "Setzt ein Raid Icon auf die Person die Rotk\195\164ppchen ist.",

	riding_trigger = "^([^%s]+) bekommt(.*) 'Rotk\195\164ppchen'",
	you = "Ihr",

	riding_youwarn = "Du bist Rotk\195\164ppchen!",
	riding_otherwarn = "%s ist Rotk\195\164ppchen!",
	riding_bar = "%s rennt",
} end )

L:RegisterTranslations("frFR", function() return {
	youriding_name = "Tu es le Chaperon Rouge",
	youriding_desc = "Avertir quand vous \195\170tes le Chaperon Rouge",

	elseriding_name = "Alerte des autres Chaperon Rouge",
	elseriding_desc = "Avertir quand les autres sont Chaperon Rouge",

	icon_name = "Ic\195\180ne",
	icon_desc = "Place une ic\195\180 sur la personne qui est Chaperon Rouge.(Requiert promotion ou sup\195\169rieur)",

	riding_trigger = "^([^%s]+) gagne(.*) Chaperon Rouge",
	you = "Vous",

	riding_youwarn = "Tu es le Chaperon Rouge!",
	riding_otherwarn = "%s est le Chaperon Rouge!",
	riding_bar = "%s Court",
} end )

----------------------------------
--   Module Declaration    --
----------------------------------

BigWigsTheBigBadWolf = BigWigs:NewModule(boss)
BigWigsTheBigBadWolf.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsTheBigBadWolf.enabletrigger = {lady, boss}
BigWigsTheBigBadWolf.toggleoptions = {"youriding", "elseriding", "icon", "bosskill"}
BigWigsTheBigBadWolf.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization     --
------------------------------

function BigWigsTheBigBadWolf:OnEnable()
	playerName = UnitName("player")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS", "RidingEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS", "RidingEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS", "RidingEvent")
end

------------------------------
--     Event Handlers    --
------------------------------

function BigWigsTheBigBadWolf:RidingEvent(msg)
	local rplayer, rtype = select(3, msg:find(L["riding_trigger"]))
	if rplayer then
		if rplayer == L["you"] then
			rplayer = playerName
		end
		if rplayer == playerName and self.db.profile.youriding then
			self:Message(L["riding_youwarn"], "Personal", true, "Long")
			self:Message(string.format(L["riding_otherwarn"], rplayer), "Attention", nil, nil, true)
			self:Bar(string.format(L["riding_bar"], rplayer), 20,"INV_Chest_Cloth_18")
		elseif self.db.profile.elseriding then
			self:Message(string.format(L["riding_otherwarn"], rplayer), "Attention")
			self:Whisper(rplayer, L["riding_youwarn"])
			self:Bar(string.format(L["riding_bar"], rplayer), 20,"INV_Chest_Cloth_18")
		end
		if self.db.profile.icon then 
			self:SetRaidIcon(rplayer)
		end
	end
end

