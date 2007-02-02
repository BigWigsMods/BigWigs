------------------------------
--      Are you local?      --
------------------------------

local Grandmother = AceLibrary("Babble-Boss-2.2")["Grandmother"]
local boss = AceLibrary("Babble-Boss-2.2")["The Big Bad Wolf"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local playerName = nil

----------------------------
--      Localization      --
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

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsTheBigBadWolf = BigWigs:NewModule(boss)
BigWigsTheBigBadWolf.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsTheBigBadWolf.enabletrigger = {Grandmother, boss}
BigWigsTheBigBadWolf.toggleoptions = {"youriding", "elseriding", "icon", "bosskill"}
BigWigsTheBigBadWolf.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsTheBigBadWolf:OnEnable()
	self.core:Print("The Big Bad Wolf boss mod is beta quality, at best! Please don't rely on it for anything!")

	playerName = UnitName("player")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS", "RidingEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS", "RidingEvent")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsTheBigBadWolf:RidingEvent(msg)
	local rplayer, rtype = select(3, msg:find(L["riding_trigger"]))
	if rplayer then
		if rplayer == L["you"] then
			rplayer = playerName
		end
		if rplayer == playerName and self.db.profile.youriding then
			self:TriggerEvent("BigWigs_Message", L["riding_youwarn"], "Personal", true, "Long")
			self:TriggerEvent("BigWigs_Message", string.format(L["riding_otherwarn"], rplayer), "Attention", nil, nil, true)
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["riding_bar"], rplayer), 20,"Interface\\Icons\\INV_Chest_Cloth_18")
		elseif self.db.profile.elseriding then
			self:TriggerEvent("BigWigs_Message", string.format(L["riding_otherwarn"], rplayer), "Attention")
			self:TriggerEvent("BigWigs_SendTell", rplayer, L["riding_youwarn"])
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["riding_bar"], rplayer), 20,"Interface\\Icons\\INV_Chest_Cloth_18")
		end
		if self.db.profile.icon then 
			self:TriggerEvent("BigWigs_SetRaidIcon", rplayer)
		end
	end
end
