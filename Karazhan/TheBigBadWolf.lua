------------------------------
--      Are you local?      --
------------------------------

local lady = AceLibrary("Babble-Boss-2.2")["Grandmother"]
local boss = AceLibrary("Babble-Boss-2.2")["The Big Bad Wolf"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local pName = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "TheBigBadWolf",

	riding_trigger = "^(%S+) (%S+) Red Riding Hood%.$",

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
	riding_trigger = "^([^%s]+) ([^%s]+) 'Rotk\195\164ppchen'%.$",

	youriding = "Du bist Rotk\195\164ppchen Warnung",
	youriding_desc = "Warnung wenn du Rotk\195\164ppchen bist",
	riding_youwarn = "Du bist Rotk\195\164ppchen!",

	elseriding = "Andere sind Rotk\195\164ppchen Warnung",
	elseriding_desc = "Warnung wenn andere Rotk\195\164ppchen sind",
	riding_otherwarn = "%s ist Rotk\195\164ppchen!",

	riding_bar = "%s rennt",

	icon = "Zeige Icon",
	icon_desc = "Setzt ein Raid Icon auf die Person die Rotk\195\164ppchen ist.",
} end )

L:RegisterTranslations("frFR", function() return {
	riding_trigger = "^(%S+) (%S+) Chaperon Rouge%.$",

	youriding = "Chaperon Rouge (vous)",
	youriding_desc = "Préviens quand vous êtes le Chaperon Rouge.",
	riding_youwarn = "Vous êtes le Chaperon Rouge !",

	elseriding = "Chaperon Rouge (les autres)",
	elseriding_desc = "Préviens quand les autres sont le Chaperon Rouge.",
	riding_otherwarn = "%s est le Chaperon Rouge !",

	riding_bar = "Chaperon : %s",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur la personne qui est le Chaperon Rouge (nécessite d'être promu ou mieux).",
} end )

L:RegisterTranslations("koKR", function() return {
	riding_trigger = "^([^|;%s]*)(.*)빨간 두건 효과를 얻었습니다%.$",

	youriding = "자신의 빨간 두건을 알립니다.",
	youriding_desc = "자신이 빨간 두건에 걸리면 알림",
	riding_youwarn = "당신은 빨간 두건입니다!",

	elseriding = "타인의 빨간 두건을 알립니다.",
	elseriding_desc = "타인이 빨간 두건에 걸리면 알림",
	riding_otherwarn = "%s님이 빨간 두건입니다!",

	riding_bar = "빨간 두건 - %s",

	icon = "전술 표시",
	icon_desc = "빨간 두건인 사람에게 전술 표시를 지정합니다 (승급자 이상의 권한 필요).",
} end )

L:RegisterTranslations("zhCN", function() return {
	riding_trigger = "^(%S+)获得了小红帽的效果。$",

	youriding = "小红帽(你)",
	youriding_desc = "当你变成小红帽 发出警报",
	riding_youwarn = "你变成小红帽!",

	elseriding = "小红帽(队友)",
	elseriding_desc = "当其他人变成小红帽发出警报!",
	riding_otherwarn = "%s 变成小红帽了!",

	riding_bar = "%s 快跑",

	icon = "团队标记",
	icon_desc = "给中了小红帽的打上团队标记(需要团队助理或更高的权利).",
} end )

L:RegisterTranslations("zhTW", function() return {
	riding_trigger = "^(.+)獲得了小紅帽的效果",

	riding_youwarn = "你變成小紅帽了！",
	riding_otherwarn ="小紅帽：[%s] ",
	riding_bar = "%s 快跑！",

	youriding = "你變成小紅帽時警告",
	youriding_desc = "當你變成小紅帽時警告",

	elseriding = "隊友變成小紅帽時警告",
	elseriding_desc = "當隊友變成小紅帽時警告",

	icon = "團隊標記",
	icon_desc = "對變成小紅帽的玩家設置團隊標記（需要權限）",
} end )

L:RegisterTranslations("esES", function() return {
	riding_trigger = "^([^%s]+) ([^%s]+) Caperucita Roja%.$",

	youriding = "Caperucita Roja (Tu)",
	youriding_desc = "Avisa cuando eres Caperucita Roja.",
	riding_youwarn = "Eres Caperucita Roja!",

	elseriding = "Caperucita Roja (Otros)",
	elseriding_desc = "Avisa cuando otros son Caperucita Roja.",
	riding_otherwarn = "%s es Caperucita Roja!",

	riding_bar = "%s Corriendo",

	icon = "Icono de Raid",
	icon_desc = "Pone un icono de raid en la persoan que es Caperucita Roja (Requiere promoted or mayor).",
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

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS", "OtherRiding")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS", "OtherRiding")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")

	pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:OtherRiding(msg)
	local rplayer = select(3, msg:find(L["riding_trigger"]))
	if rplayer then
		if self.db.profile.elseriding then
			self:Message(L["riding_otherwarn"]:format(rplayer), "Attention")
			self:Whisper(rplayer, L["riding_youwarn"])
			self:Bar(L["riding_bar"]:format(rplayer), 20,"INV_Chest_Cloth_18")
		end
		if self.db.profile.icon then 
			self:Icon(rplayer)
		end
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS(msg)
	if msg:find(L["riding_trigger"]) then
		if self.db.profile.youriding then
			self:Message(L["riding_youwarn"], "Personal", true, "Long")
			self:Message(L["riding_otherwarn"]:format(pName), "Attention", nil, nil, true)
			self:Bar(L["riding_bar"]:format(pName), 20,"INV_Chest_Cloth_18")
		end
		if self.db.profile.icon then 
			self:Icon(pName)
		end
	end
end

