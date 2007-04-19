------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Maiden of Virtue"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Maiden",

	engage = "Engage",
	engage_desc = ("Alert when %s is engaged"):format(boss),

	repentance = "Repentance",
	repentance_desc = "Estimated timer of Repentance",

	holyfire = "Holy Fire",
	holyfire_desc = "Alert when people are afflicted by Holy Fire",

	icon = "Icon",
	icon_desc = "Place a Raid Icon on the player afflicted by Holy Fire(requires promoted or higher)",

	engage_trigger = "Your behavior will not be tolerated.",
	engage_message = "Maiden Engaged! Repentance in ~33sec",

	repentance_trigger1 = "Cast out your corrupt thoughts.",
	repentance_trigger2 = "Your impurity must be cleansed.",
	repentance_message = "Repentance! Next in ~33sec",
	repentance_warning = "Repentance Soon!",
	repentance_bar = "Repentance",
	repentance_nextbar = "Next Repentance",

	holyfire_trigger = "^([^%s]+) ([^%s]+) afflicted by Holy Fire",
	holyfire_message = "Holy Fire: %s",
} end)

L:RegisterTranslations("deDE", function() return {
	engage = "Engage",
	engage_desc = ("Warnt wenn %s w\195\188tend ist"):format(boss),

	repentance = "Bu\195\159e",
	repentance_desc = "Ungef\195\164re Zeitangabe von Bu\195\159e",

	holyfire = "Heiliges Feuer",
	holyfire_desc = "Warnt wenn Personen von Heiliges Feuer betroffen sind",

	icon = "Icon",
	icon_desc = "Place a Raid Icon on the player afflicted by Holy Fire(requires promoted or higher)",

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
	engage = "Engagement",
	engage_desc = ("Pr\195\169viens quand %s est engag\195\169e."):format(boss),

	repentance = "Repentir",
	repentance_desc = "Affiche le temps de recharge de Repentir.",

	holyfire = "Flammes sacr\195\169\es",
	holyfire_desc = "Pr\195\169viens quand quelqu'un est affect\195\169 par Flammes sacr\195\169es.",

	icon = "Ic\195\180ne",
	icon_desc = "Place une ic\195\180ne de raid sur le dernier joueur affect\195\169 par Flammes sacr\196\169es (n\196\169cessite d'\195\170tre promu ou mieux).",

	engage_trigger = "Votre comportement est inacceptable.",
	engage_message = "Damoiselle engag\195\169e ! Repentir dans ~33 sec.",

	repentance_trigger1 = "Chassez vos pens\195\169es corrompues.",
	repentance_trigger2 = "Il faut se d\195\169barrasser de votre impuret\195\169.",
	repentance_message = "Repentir ! Prochain dans ~33 sec.",
	repentance_warning = "Repentir imminent !",
	repentance_bar = "Repentir",
	repentance_nextbar = "Prochain Repentir",

	holyfire_trigger = "^(.+) (.+) les effets .* Flammes sacr\195\169es",
	holyfire_message = "Flammes sacr\195\169es : %s",
} end)

L:RegisterTranslations("koKR", function() return {
	engage = "전투 개시",
	engage_desc = ("%s 전투 개시 알림"):format(boss),

	repentance = "참회",
	repentance_desc = "참회 예상 시간",

	holyfire = "신성한 불꽃",
	holyfire_desc = "신성한 불꽃에 걸린 사람 경고",

	icon = "아이콘",
	icon_desc = "신성한 불꽃에 걸린 사람에게 공격대 아이콘 지정(승급자 이상의 권한 필요)",

	engage_trigger = "너희의 행동은 그냥 넘길 수가 없다.",
	engage_message = "고결의 여신 전투 개시! 약 33초 후 참회",

	repentance_trigger1 = "그 부정한 생각을 떨쳐버려라.",
	repentance_trigger2 = "너희의 불순함을 반드시 정화하겠다.",
	repentance_message = "참회! 다음은 약 33초 후!",
	repentance_warning = "잠시 후 참회!",
	repentance_bar = "참회",
	repentance_nextbar = "다음 참회",

	holyfire_trigger = "^([^|;%s]*)(.*)신성한 불꽃에 걸렸습니다%.$",
	holyfire_message = "신성한 불꽃: %s",
} end)

----------------------------------
--   Module Declaration    --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
mod.enabletrigger = boss
mod.toggleoptions = {"engage", "repentance", -1, "holyfire", "icon", "proximity", "bosskill"}
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
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		if self.db.profile.engage then
			self:Message(L["engage_message"], "Attention")
			self:NextRepentance()
		end

		self:TriggerEvent("BigWigs_ShowProximity", self)
	elseif self.db.profile.repentance and (msg == L["repentance_trigger1"] or msg == L["repentance_trigger2"]) then
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
	self:DelayedMessage(28, L["repentance_warning"], "Urgent", nil, "Alarm")
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
