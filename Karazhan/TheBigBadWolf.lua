------------------------------
--      Are you local?      --
------------------------------

local lady = BB["Grandmother"]
local boss = BB["The Big Bad Wolf"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "TheBigBadWolf",

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
	riding_youwarn = "Du bist Rotk\195\164ppchen!",

	elseriding = "Andere sind Rotk\195\164ppchen Warnung",
	elseriding_desc = "Warnung wenn andere Rotk\195\164ppchen sind",
	riding_otherwarn = "%s ist Rotk\195\164ppchen!",

	riding_bar = "%s rennt",

	icon = "Zeige Icon",
	icon_desc = "Setzt ein Raid Icon auf die Person die Rotk\195\164ppchen ist.",
} end )

L:RegisterTranslations("frFR", function() return {
	youriding = "Chaperon Rouge (vous)",
	youriding_desc = "Prévient quand vous êtes le Chaperon Rouge.",
	riding_youwarn = "Vous êtes le Chaperon Rouge !",

	elseriding = "Chaperon Rouge (les autres)",
	elseriding_desc = "Prévient quand les autres sont le Chaperon Rouge.",
	riding_otherwarn = "%s est le Chaperon Rouge !",

	riding_bar = "Chaperon : %s",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur la personne qui est le Chaperon Rouge (nécessite d'être promu ou mieux).",
} end )

L:RegisterTranslations("koKR", function() return {
	youriding = "자신의 빨간 두건",
	youriding_desc = "자신이 빨간 두건에 걸리면 알립니다.",
	riding_youwarn = "당신은 빨간 두건입니다!",

	elseriding = "타인의 빨간 두건",
	elseriding_desc = "타인이 빨간 두건에 걸리면 알립니다.",
	riding_otherwarn = "%s|1이;가; 빨간 두건입니다!",

	riding_bar = "빨간 두건 - %s",

	icon = "전술 표시",
	icon_desc = "빨간 두건인 플레이어에게 전술 표시를 지정합니다. (승급자 이상의 권한 필요)",
} end )

L:RegisterTranslations("zhCN", function() return {
	youriding = "小红帽（你）",
	youriding_desc = "当你变成小红帽时发出警报。",
	riding_youwarn = "你变成小红帽！",

	elseriding = "小红帽（队友）",
	elseriding_desc = "当其他玩家变成小红帽时发出警报。",
	riding_otherwarn = "小红帽：>%s<！快跑！",

	riding_bar = "<快跑：%s>",

	icon = "团队标记",
	icon_desc = "给中了小红帽的打上团队标记。（需要权限）",
} end )

L:RegisterTranslations("zhTW", function() return {
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
	youriding = "Caperucita Roja (Tú)",
	youriding_desc = "Avisa cuando eres Caperucita Roja.",
	riding_youwarn = "¡Eres Caperucita Roja!",

	elseriding = "Caperucita Roja (Otros)",
	elseriding_desc = "Avisa cuando otros son Caperucita Roja.",
	riding_otherwarn = "¡%s es Caperucita Roja!",

	riding_bar = "%s Corriendo",

	icon = "Icono de banda",
	icon_desc = "Pone un icono de banda en la persoan que es Caperucita Roja. (Requiere derechos de banda)",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Karazhan"]
mod.enabletrigger = {lady, boss}
mod.toggleoptions = {"youriding", "elseriding", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Riding", 30753)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Riding(player, spellID)
	if player == pName then
		if self.db.profile.youriding then
			self:LocalMessage(L["riding_youwarn"], "Personal", spellID, "Long")
			self:WideMessage(L["riding_otherwarn"]:format(player))
		end
	elseif self.db.profile.elseriding then
		self:IfMessage(L["riding_otherwarn"]:format(player), "Attention", spellID)
		self:Whisper(player, L["riding_youwarn"])
	end
	self:Icon(player, "icon")
	self:Bar(L["riding_bar"]:format(player), 20, spellID)
end

