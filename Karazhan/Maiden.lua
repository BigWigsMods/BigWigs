------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Maiden of Virtue"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Maiden",

	engage_trigger = "Your behavior will not be tolerated.",
	engage_message = "Maiden Engaged! Repentance in ~33sec",

	repentance = "Repentance",
	repentance_desc = "Estimated timer of Repentance.",
	repentance_trigger1 = "Cast out your corrupt thoughts.",
	repentance_trigger2 = "Your impurity must be cleansed.",
	repentance_message = "Repentance! Next in ~33sec",
	repentance_warning = "Repentance Cooldown Over - Inc Soon!",
	repentance_bar = "Repentance",
	repentance_nextbar = "Repentance Cooldown",

	holyfire = "Holy Fire",
	holyfire_desc = "Alert when people are afflicted by Holy Fire.",
	holyfire_trigger = "^([^%s]+) ([^%s]+) afflicted by Holy Fire.$",
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

	repentance_trigger1 = "L\195\182st Euch von Euren verdorbenen Gedanken!",
	repentance_trigger2 = "Eure Unreinheit muss gel\195\164utert werden.",
	repentance_message = "Bu\195\159e! N\195\164chste in ~33 Sek!",
	repentance_warning = "Bu\195\159e bald!",
	repentance_bar = "Bu\195\159e",
	repentance_nextbar = "N\195\164chste Bu\195\159e",

	holyfire_trigger = "^([^%s]+) ([^%s]+) von Heiliges Feuer betroffen",
	holyfire_message = "Heiliges Feuer: %s",
} end)

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Votre comportement est inacceptable.",
	engage_message = "Damoiselle engagée ! Repentir dans ~33 sec.",

	repentance = "Repentir",
	repentance_desc = "Préviens quand la Damoiselle de vertu est suceptible d'utiliser son Repentir.",
	repentance_trigger1 = "Chassez vos pensées corrompues.",
	repentance_trigger2 = "Il faut se débarrasser de votre impureté.",
	repentance_message = "Repentir ! Prochain dans ~33 sec.",
	repentance_warning = "Fin du cooldown Repentir - Imminent !",
	repentance_bar = "Repentir",
	repentance_nextbar = "~Cooldown Repentir",

	holyfire = "Flammes sacrées",
	holyfire_desc = "Préviens quand un joueur subit les effets des Flammes sacrées.",
	holyfire_trigger = "^([^%s]+) ([^%s]+) les effets .* Flammes sacrées.$",
	holyfire_message = "Flammes sacrées : %s",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par les Flammes sacrées (nécessite d'être promu ou mieux).",
} end)

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "너희의 행동은 그냥 넘길 수가 없다.",
	engage_message = "고결의 여신 전투 개시! 약 33초 후 참회",

	repentance = "참회",
	repentance_desc = "참회 예상 시간입니다.",
	repentance_trigger1 = "그 부정한 생각을 떨쳐버려라.",
	repentance_trigger2 = "너희의 불순함을 반드시 정화하겠다.",
	repentance_message = "참회! 다음은 약 33초 후!",
	repentance_warning = "참회 쿨다운 종료 - Inc Soon!",
	repentance_bar = "참회",
	repentance_nextbar = "참회 쿨다운",

	holyfire = "신성한 불꽃",
	holyfire_desc = "신성한 불꽃에 걸린 사람에 대한 경고입니다.",
	holyfire_trigger = "^([^|;%s]*)(.*)신성한 불꽃에 걸렸습니다%.$",
	holyfire_message = "신성한 불꽃: %s",

	icon = "전술 표시",
	icon_desc = "신성한 불꽃에 걸린 사람에게 전술 표시를 지정합니다 (승급자 이상의 권한 필요).",
} end)

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "你的行為不能被容忍。",
	engage_message = "戰鬥開始！33 秒後懺悔！",

	repentance = "懺悔",
	repentance_trigger1 = "逐出你的腐敗思想。",
	repentance_trigger2 = "你的不潔必須被淨化。",
	repentance_message = "懺悔！33 秒後下一次懺悔！",
	repentance_warning = "懺悔即將來臨！",
	repentance_bar = "懺悔計時",
	repentance_nextbar = "懺悔預備！治療群補上 HoT！",

	holyfire = "神聖之火",
	holyfire_desc = "當隊友受到神聖之火時發出警報",
	holyfire_trigger = "^(.+)受到(.*)神聖之火",
	holyfire_message = "神聖之火：[%s]",

	icon = "團隊標記",
	icon_desc = "為受到神聖之火的玩家設置團隊標記（需要權限）",
} end)

L:RegisterTranslations("esES", function() return {
	engage_trigger = "Tu comportamiento no será tolerado.",
	engage_message = "Doncella Activa! Arrepentimiento en ~33sec",

	repentance = "Arrepentimiento",
	repentance_desc = "Tiempo estimado al Arrepentimiento.",
	repentance_trigger1 = "Expulsa tus pensamientos corruptos.",
	repentance_trigger2 = "Tu impureza debe purificarse.",
	repentance_message = "Proximo Arrepentimiento! en ~33sec",
	repentance_warning = "Fin del Enfriamiento de Arrepentimiento - Lanzamiento proximo!",
	repentance_bar = "Arrepentimiento",
	repentance_nextbar = "Enfriamiento de Arrepentimiento",

	holyfire = "Fuego Sagrado",
	holyfire_desc = "Avisa cuando alguien sufre Fuego Sagrado.",
	holyfire_trigger = "^([^%s]+) ([^%s]+) sufre Fuego Sagrado.$",
	holyfire_message = "Fuego Sagrado: %s",

	icon = "Icono de Raid",
	icon_desc = "Pone un icono de raid en el juegador afectado por Fuego Sagrado(requiere promoted o mayor).",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
mod.enabletrigger = boss
mod.toggleoptions = {"repentance", -1, "holyfire", "icon", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "HolyFireEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "HolyFireEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "HolyFireEvent")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MaidenHolyFire", 3)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		if self.db.profile.repentance then
			self:Message(L["engage_message"], "Attention")
			self:NextRepentance()
		end

		self:TriggerEvent("BigWigs_ShowProximity", self)
	elseif self.db.profile.repentance and (msg == L["repentance_trigger1"] or msg == L["repentance_trigger2"]) then
		self:CancelScheduledEvent("rep1")
		self:TriggerEvent("BigWigs_StopBar", self, L["repentance_nextbar"])
		self:Message(L["repentance_message"], "Important")
		self:Bar(L["repentance_bar"], 12, "Spell_Holy_PrayerOfHealing")
		self:NextRepentance()
	end
end

function mod:HolyFireEvent(msg)
	local bplayer, btype = select(3, msg:find(L["holyfire_trigger"]))
	if bplayer and btype then
		if bplayer == L2["you"] and btype == L2["are"] then
			bplayer = UnitName("player")
		end
		self:Sync("MaidenHolyFire "..bplayer)
	end
end

function mod:NextRepentance()
	self:ScheduleEvent("rep1", "BigWigs_Message", 33, L["repentance_warning"], "Urgent", nil, "Alarm")
	self:Bar(L["repentance_nextbar"], 33, "Spell_Holy_PrayerOfHealing")
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "MaidenHolyFire" and rest and self.db.profile.holyfire then
		self:Message(L["holyfire_message"]:format(rest), "Important")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	end
end
