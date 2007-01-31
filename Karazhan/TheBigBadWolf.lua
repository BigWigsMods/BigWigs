--[[Little Red Riding Hood

    * Description: Marks the target as Little Red Riding Hood. This increases the likelihood that the Big Bad Wolf will chase them and try to gobble them up!
    * Effect: Reduces the target's armor and resistances to 0. Increases speed 50% to flee the Big Bad Wolf. Pacifies and Silences. 

* Grandmother
* The Big Bad Wolf
* every 30 seconds

TODO: figure out how long the riding lasts...

]]

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

	ridingbar_cmd = "ridingbar",
	ridingbar_name = "Red Riding Hood bar",
	ridingbar_desc = "Shows a timer bar for Red Riding hood",

	icon_cmd = "icon",
	icon_name = "Raid Icon on bomb",
	icon_desc = "Put a Raid Icon on the person who's Red Riding Hood. (Requires promoted or higher)",


	riding_trigger = "^([^%s]+) gain(.*) Red Riding Hood",
	you = "You",

	riding_youwarn = "You are Red Riding Hood!",
	riding_otherwarn = " is Red Riding Hood!",
	riding_bar = "Next Red Riding Hood",
	riding_warn5 = "Next Red Riding Hood in ~5 sec!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsTheBigBadWolf = BigWigs:NewModule(boss)
BigWigsTheBigBadWolf.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsTheBigBadWolf.enabletrigger = {Grandmother, boss}
BigWigsTheBigBadWolf.toggleoptions = { "riding", "bosskill" }
BigWigsTheBigBadWolf.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsTheBigBadWolf:OnEnable()
	playerName = UnitName("player")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	-- drycoding the events
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS", "RidingEvent")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "BigBadWolfRiding", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsTheBigBadWolf:RidingEvent( msg )
	local ridingplayer = select(3, msg:find(L["riding_trigger"]))
	if ridingplayer then
		if ridingplayer == L["you"] then
			ridingplayer = playerName
		end
		self:TriggerEvent("BigWigs_SendSync", "BigBadWolfRiding "..ridingplayer)
	end	
end

function BigWigsTheBigBadWolf:BigWigs_RecvSync( sync, rest, nick )
	if sync ~= "BigBadWolfRiding" then return end
	local player = rest

	if player == playerName and self.db.profile.youriding then
		self:TriggerEvent("BigWigs_Message", L["riding_youwarn"], "Personal", true)
		self:TriggerEvent("BigWigs_Message", playerName .. L["riding_otherwarn"], "Attention", nil, nil, true)
	elseif self.db.profile.elseriding then
		self:TriggerEvent("BigWigs_Message", player .. L["riding_otherwarn"], "Attention")
		self:TriggerEvent("BigWigs_SendTell", player, L["riding_youwarn"])
	end

	if self.db.profile.icon then 
		self:TriggerEvent("BigWigs_SetRaidIcon", player)
	end
	if self.db.profile.ridingbar then
		self:ScheduleEvent("bwbigbadwolfwarn5", "BigWigs_Message", 25, L["riding_warn5"], "Urgent") 
		self:TriggerEvent("BigWigs_StartBar", self, L["riding_bar"], 30, "Interface\\Icons\\INV_Gauntlets_03")
	end
end
