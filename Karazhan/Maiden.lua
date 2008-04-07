------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Maiden of Virtue"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local CheckInteractDistance = CheckInteractDistance

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Maiden",

	engage_trigger = "Your behavior will not be tolerated.",
	engage_message = "Maiden Engaged! Repentance in ~33sec",

	repentance = "Repentance",
	repentance_desc = "Estimated timer of Repentance.",
	repentance_message = "Repentance! Next in ~33sec",
	repentance_warning = "Repentance Cooldown Over - Inc Soon!",
	repentance_bar = "Repentance",
	repentance_nextbar = "Repentance Cooldown",

	holyfire = "Holy Fire",
	holyfire_desc = "Alert when people are afflicted by Holy Fire.",
	holyfire_message = "Holy Fire: %s",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player afflicted by Holy Fire(requires promoted or higher).",
} end)

L:RegisterTranslations("deDE", function() return {
	repentance = "Bu\195\159e",
	repentance_desc = "Ungef\195\164re Zeitangabe von Bu\195\159e",

	holyfire = "Heiliges Feuer",
	holyfire_desc = "Warnt wenn Personen von Heiliges Feuer betroffen sind",

	icon = "Icon",
	icon_desc = "Platziert ein Schlachtzugssymbol bei dem Spieler, welcher vom Heiligen Feuer betroffen ist (ben\195\182tigt 'bef\195\182rdert' oder h\195\182her)",

	engage_trigger = "Euer Verhalten wird nicht toleriert.",
	engage_message = "Maid Engaged! Bu\195\159e in ~33 Sek!",

	repentance_message = "Bu\195\159e! N\195\164chste in ~33 Sek!",
	repentance_warning = "Bu\195\159e bald!",
	repentance_bar = "Bu\195\159e",
	repentance_nextbar = "N\195\164chste Bu\195\159e",

	holyfire_message = "Heiliges Feuer: %s",
} end)

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Votre comportement est inacceptable.",
	engage_message = "Damoiselle engagée ! Repentir dans ~33 sec.",

	repentance = "Repentir",
	repentance_desc = "Préviens quand la Damoiselle de vertu est susceptible d'utiliser son Repentir.",
	repentance_message = "Repentir ! Prochain pas avant ~33 sec.",
	repentance_warning = "Fin du cooldown Repentir - Imminent !",
	repentance_bar = "Repentir",
	repentance_nextbar = "~Cooldown Repentir",

	holyfire = "Flammes sacrées",
	holyfire_desc = "Préviens quand un joueur subit les effets des Flammes sacrées.",
	holyfire_message = "Flammes sacrées : %s",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par les Flammes sacrées (nécessite d'être promu ou mieux).",
} end)

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "너희의 행동은 그냥 넘길 수가 없다.",
	engage_message = "고결의 여신 전투 개시! 약 33초 후 참회",

	repentance = "참회",
	repentance_desc = "참회 예상 시간입니다.",
	repentance_message = "참회! 다음은 약 33초 후!",
	repentance_warning = "참회 쿨다운 종료 - 잠시후 시전!",
	repentance_bar = "참회",
	repentance_nextbar = "참회 쿨다운",

	holyfire = "신성한 불꽃",
	holyfire_desc = "신성한 불꽃에 걸린 사람에 대한 경고입니다.",
	holyfire_message = "신성한 불꽃: %s",

	icon = "전술 표시",
	icon_desc = "신성한 불꽃에 걸린 사람에게 전술 표시를 지정합니다 (승급자 이상의 권한 필요).",
} end)

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "你们的行为是不可饶恕的。",
	engage_message = "战斗开始！ 约33秒释放 悔改！",

	repentance = "悔改",
	repentance_desc = "悔改冷却时间提醒。",
	repentance_message = "悔改！约33秒后发动",
	repentance_warning = "悔改 冷却结束 - 即将发动！",
	repentance_bar = "<悔改>",
	repentance_nextbar = "悔改 冷却！",

	holyfire = "神圣之火",
	holyfire_desc = "当受到神圣之火影响时发出警报。",
	holyfire_message = "神圣之火：>%s<！",

	icon = "团队标记",
	icon_desc = "标记受到神圣之火的队员。(需要权限)",
} end)

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "你的行為不能被容忍。",
	engage_message = "戰鬥開始！33 秒後懺悔！",

	repentance = "懺悔",
	repentance_message = "懺悔！33 秒後下一次懺悔！",
	repentance_warning = "懺悔即將來臨！",
	repentance_bar = "懺悔計時",
	repentance_nextbar = "懺悔預備！治療群補上 HoT！",

	holyfire = "神聖之火",
	holyfire_desc = "當隊友受到神聖之火時發出警報",
	holyfire_message = "神聖之火：[%s]",

	icon = "團隊標記",
	icon_desc = "為受到神聖之火的玩家設置團隊標記（需要權限）",
} end)

L:RegisterTranslations("esES", function() return {
	engage_trigger = "No se tolerar\195\161 tu comportamiento.",
	engage_message = "Doncella Activa! Arrepentimiento en ~33sec",

	repentance = "Arrepentimiento",
	repentance_desc = "Tiempo estimado al Arrepentimiento.",
	repentance_message = "Pr\195\179ximo Arrepentimiento! en ~33sec",
	repentance_warning = "Fin del Enfriamiento de Arrepentimiento - Lanzamiento pr\195\179ximo!",
	repentance_bar = "Arrepentimiento",
	repentance_nextbar = "Enfriamiento de Arrepentimiento",

	holyfire = "Fuego Sagrado",
	holyfire_desc = "Avisa cuando alguien sufre Fuego Sagrado.",
	holyfire_message = "Fuego Sagrado: %s",

	icon = "Icono de Raid",
	icon_desc = "Pone un icono de raid en el jugador afectado por Fuego Sagrado(requiere promoted o mayor).",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Karazhan"]
mod.enabletrigger = boss
mod.toggleoptions = {"repentance", -1, "holyfire", "icon", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")
	self:AddCombatListener("SPELL_AURA_APPLIED", "HolyFire", 29522)
	self:AddCombatListener("SPELL_CAST_START", "Repentance", 29511)

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:HolyFire(player, spellID)
	if self.db.profile.holyfire then
		self:IfMessage(L["holyfire_message"]:format(player), "Important", spellID)
		self:Icon(player, "icon")
	end
end

function mod:Repentance(_, spellID)
	if self.db.profile.repentance then
		self:CancelScheduledEvent("rep1")
		self:TriggerEvent("BigWigs_StopBar", self, L["repentance_nextbar"])
		self:IfMessage(L["repentance_message"], "Important", spellID)
		self:Bar(L["repentance_bar"], 12, spellID)
		self:ScheduleEvent("rep1", "BigWigs_Message", 33, L["repentance_warning"], "Urgent", nil, "Alarm")
		self:Bar(L["repentance_nextbar"], 33, spellID)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		if self.db.profile.repentance then
			self:Message(L["engage_message"], "Attention")
			self:ScheduleEvent("rep1", "BigWigs_Message", 33, L["repentance_warning"], "Urgent", nil, "Alarm")
			self:Bar(L["repentance_nextbar"], 33, 29511)
		end

		self:TriggerEvent("BigWigs_ShowProximity", self)
	end
end

