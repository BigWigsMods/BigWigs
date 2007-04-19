------------------------------
--      Are you local?    --
------------------------------

local lady = AceLibrary("Babble-Boss-2.2")["Grandmother"]
local boss = AceLibrary("Babble-Boss-2.2")["The Big Bad Wolf"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local playerName = nil

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "TheBigBadWolf",

	youriding = "You are Red Riding Hood alert",
	youriding_desc = "Warn when you are Red Riding Hood",

	elseriding = "Others Red Riding Hood alert",
	elseriding_desc = "Warn when others are Red Riding Hood",

	icon = "Place Icon",
	icon_desc = "Put a Raid Icon on the person who's Red Riding Hood. (Requires promoted or higher)",

	riding_trigger = "^([^%s]+) gain(.*) Red Riding Hood",

	riding_youwarn = "You are Red Riding Hood!",
	riding_otherwarn = "%s is Red Riding Hood!",
	riding_bar = "%s Running",
} end )

L:RegisterTranslations("deDE", function() return {
	youriding = "Du bist Rotk\195\164ppchen Warnung",
	youriding_desc = "Warnung wenn du Rotk\195\164ppchen bist",

	elseriding = "Andere sind Rotk\195\164ppchen Warnung",
	elseriding_desc = "Warnung wenn andere Rotk\195\164ppchen sind",

	icon = "Zeige Icon",
	icon_desc = "Setzt ein Raid Icon auf die Person die Rotk\195\164ppchen ist.",

	riding_trigger = "^([^%s]+) bekommt(.*) 'Rotk\195\164ppchen'",

	riding_youwarn = "Du bist Rotk\195\164ppchen!",
	riding_otherwarn = "%s ist Rotk\195\164ppchen!",
	riding_bar = "%s rennt",
} end )

L:RegisterTranslations("frFR", function() return {
	youriding = "Alerte Chaperon Rouge (soi)",
	youriding_desc = "Pr\195\169viens quand vous \195\170tes le Chaperon Rouge.",

	elseriding = "Alerte Chaperon Rouge (autres)",
	elseriding_desc = "Pr\195\169viens quand les autres sont le Chaperon Rouge.",

	icon = "Placer une ic\195\180ne",
	icon_desc = "Place une ic\195\180ne de raid sur la personne qui est le Chaperon Rouge (n\195\169cessite d'\195\170tre promu ou mieux).",

	riding_trigger = "^([^%s]+) gagne(.*) Chaperon Rouge",

	riding_youwarn = "Tu es le Chaperon Rouge !",
	riding_otherwarn = "%s est le Chaperon Rouge !",
	riding_bar = "%s court",
} end )

L:RegisterTranslations("koKR", function() return {
	youriding = "자신의 빨간 두건 알림",
	youriding_desc = "자신이 빨간 두건에 걸리면 알림",

	elseriding = "타인의 빨간 두건 알림",
	elseriding_desc = "타인이 빨간 두건에 걸리면 알림",

	icon = "아이콘 지정",
	icon_desc = "빨간 두건인 사람에게 공격대 아이콘 지정(승급자 이상의 권한 필요)",

	riding_trigger = "^([^|;%s]*)(.*)빨간 두건 효과를 얻었습니다%.$", -- "^([^%s]+) gain(.*) Red Riding Hood", -- check

	riding_youwarn = "당신은 빨간 두건입니다!",
	riding_otherwarn = "%s님이 빨간 두건입니다!",
	riding_bar = "빨간 두건 - %s",
} end )

----------------------------------
--   Module Declaration    --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
mod.enabletrigger = {lady, boss}
mod.toggleoptions = {"youriding", "elseriding", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization     --
------------------------------

function mod:OnEnable()
	playerName = UnitName("player")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS", "RidingEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS", "RidingEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS", "RidingEvent")
end

------------------------------
--     Event Handlers    --
------------------------------

function mod:RidingEvent(msg)
	local rplayer, rtype = select(3, msg:find(L["riding_trigger"]))
	if rplayer and rtype then
		if rplayer == L2["you"] then
			rplayer = playerName
		end
		if rplayer == playerName and self.db.profile.youriding then
			self:Message(L["riding_youwarn"], "Personal", true, "Long")
			self:Message(L["riding_otherwarn"]:format(rplayer), "Attention", nil, nil, true)
			self:Bar(L["riding_bar"]:format(rplayer), 20,"INV_Chest_Cloth_18")
		elseif self.db.profile.elseriding then
			self:Message(L["riding_otherwarn"]:format(rplayer), "Attention")
			self:Whisper(rplayer, L["riding_youwarn"])
			self:Bar(L["riding_bar"]:format(rplayer), 20,"INV_Chest_Cloth_18")
		end
		if self.db.profile.icon then 
			self:Icon(rplayer)
		end
	end
end
