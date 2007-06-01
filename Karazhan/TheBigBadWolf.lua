------------------------------
--      Are you local?      --
------------------------------

local lady = AceLibrary("Babble-Boss-2.2")["Grandmother"]
local boss = AceLibrary("Babble-Boss-2.2")["The Big Bad Wolf"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "TheBigBadWolf",

	riding_trigger = "^([^%s]+) (.*) Red Riding Hood.$",
	gain = "gain",

	youriding = "Red Riding Hood(You)",
	youriding_desc = "Warn when you are Red Riding Hood.",
	riding_youwarn = "You are Red Riding Hood!",

	elseriding = "Red Riding Hood(Other)",
	elseriding_desc = "Warn when others are Red Riding Hood.",
	riding_otherwarn = "%s is Red Riding Hood!",

	riding_bar = "%s Running",

	icon = "Raid Icon",
	icon_desc = "Put a Raid Icon on the person who's Red Riding Hood. (Requires promoted or higher).",
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
	riding_trigger = "^([^%s]+) gagne(.*) Chaperon Rouge",

	youriding = "Chaperon Rouge (soi)",
	youriding_desc = "Préviens quand vous êtes le Chaperon Rouge.",
	riding_youwarn = "Vous êtes le Chaperon Rouge !",

	elseriding = "Chaperon Rouge (autres)",
	elseriding_desc = "Préviens quand les autres sont le Chaperon Rouge.",
	riding_otherwarn = "%s est le Chaperon Rouge !",

	riding_bar = "%s court",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur la personne qui est le Chaperon Rouge (nécessite d'être promu ou mieux).",
} end )

L:RegisterTranslations("koKR", function() return {
	riding_trigger = "^([^|;%s]*)(.*)빨간 두건 효과를 얻었습니다%.$", -- "^([^%s]+) gain(.*) Red Riding Hood", -- check
	gain = " ",

	youriding = "자신의 빨간 두건 알림.",
	youriding_desc = "자신이 빨간 두건에 걸리면 알림",
	riding_youwarn = "당신은 빨간 두건입니다!",

	elseriding = "타인의 빨간 두건 알림.",
	elseriding_desc = "타인이 빨간 두건에 걸리면 알림",
	riding_otherwarn = "%s님이 빨간 두건입니다!",

	riding_bar = "빨간 두건 - %s",

	icon = "공격대 아이콘",
	icon_desc = "빨간 두건인 사람에게 공격대 아이콘 지정(승급자 이상의 권한 필요)",
} end )

L:RegisterTranslations("zhTW", function() return {
	riding_trigger = "^(.+)獲得了(.*)小紅帽的效果",
	gain = "獲得",

	riding_youwarn = "你變成小紅帽了！",
	riding_otherwarn ="[%s] 變成小紅帽了！",
	riding_bar = "%s 快跑！",

	youriding = "你變成小紅帽時警告",
	youriding_desc = "當你變成小紅帽時警告",

	elseriding = "隊友變成小紅帽時警告",
	elseriding_desc = "當隊友變成小紅帽時警告",

	icon = "團隊標記",
	icon_desc = "對變成小紅帽的玩家設置團隊標記（需要權限）",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
mod.enabletrigger = {lady, boss}
mod.toggleoptions = {"youriding", "elseriding", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS", "RidingEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS", "RidingEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS", "RidingEvent")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:RidingEvent(msg)
	local rplayer, rtype = select(3, msg:find(L["riding_trigger"]))
	if rplayer and rtype then
		if rplayer == L2["you"] and rtype == L["gain"] then
			rplayer = UnitName("player")
		end

		if rplayer == UnitName("player") and self.db.profile.youriding then
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
