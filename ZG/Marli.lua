------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High Priestess Mar'li"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local lastdrain = 0

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Marli",

	spider = "Spider Alert",
	spider_desc = "Warn when spiders spawn",

	drain = "Drain Alert",
	drain_desc = "Warn for life drain",

	spiders_trigger = "Aid me my brood!$",
	drainlife_trigger = "^High Priestess Mar'li's Drain Life heals High Priestess Mar'li for (.+).",

	spiders_message = "Spiders spawned!",
	drainlife_message = "High Priestess Mar'li is draining life!",
} end )

L:RegisterTranslations("deDE", function() return {
	spider = "Spinnen",
	spider_desc = "Warnung, wenn Hohepriesterin Mar'li Spinnen beschw\195\182rt.",

	drain = "Blutsauger",
	drain_desc = "Warnung, wenn Hohepriesterin Mar'li sich heilt.", 

	spiders_trigger = "Helft mir, meine Brut!$",
	drainlife_trigger = "^High Priestess Mar'li's Drain Life heals High Priestess Mar'li for (.+).", -- ?

	spiders_message = "Spinnen beschworen!",
	drainlife_message = "Mar'li heilt sich!",
} end )

L:RegisterTranslations("frFR", function() return {
	spider = "Alerte Araign\195\169e",
	spider_desc = "Pr\195\169viens du pop d'araign\195\169e.",

	drain = "Alerte Drain",
	drain_desc = "Pr\195\169viens d'un drain en cours.",

	spiders_trigger = "., mes enfants !$",
	drainlife_trigger = "^Drain de vie DE Grande pr\195\170tresse Mar'li gu\195\169rit Grande pr\195\170tresse Mar'li de (.+)%.$",

	spiders_message = "Araign\195\169e en approche !",
	drainlife_message = "Mar'li fait un drain de vie !",
} end )

L:RegisterTranslations("zhCN", function() return {
	spider = "蜘蛛警报",
	spider_desc = "小蜘蛛出现时发出警报",

	drain = "吸取警报",
	drain_desc = "高阶祭司玛尔里使用生命吸取时发出警报",

	spiders_trigger = "来为我作战吧，我的孩子们！$",
	drainlife_trigger = "^高阶祭司玛尔里的生命吸取治疗了高阶祭司玛尔里(.+)。",

	spiders_message = "蜘蛛出现！",
	drainlife_message = "高阶祭司玛尔里正在施放生命吸取，赶快打断她！",
} end )

L:RegisterTranslations("zhTW", function() return {
	spider = "蜘蛛警報",
	spider_desc = "當高階祭司瑪爾里召喚蜘蛛時發出警報。",

	drain = "生命吸取警報",
	drain_desc = "高階祭司瑪爾里使用生命吸取時發出警報",

	spiders_trigger = "來幫助我吧，我的孩子們！$",
	drainlife_trigger = "^高階祭司瑪爾里的生命吸取治療了高階祭司瑪爾里(.+)。",

	spiders_message = "小蜘蛛出現！",
	drainlife_message = "生命吸取！趕快打斷！",
} end )

L:RegisterTranslations("koKR", function() return {
	spider = "거미 경고",
	spider_desc = "거미 소환 시 경고",

	drain = "흡수 경고",
	drain_desc = "생명령 흡수에 대한 경고",

	spiders_trigger = "어미를 도와라!$",
	drainlife_trigger = "대여사제 말리의 생명력 흡수|1으로;로; 대여사제 말리의 생명력이 (.+)만큼 회복되었습니다.",

	spiders_message = "거미 소환!",
	drainlife_message = "말리가 생명력을 흡수합니다. 차단해 주세요!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Gurub"]
mod.enabletrigger = boss
mod.toggleoptions = {"spider", "drain", "bosskill"}
mod.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
end

------------------------------
--      Events              --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL( msg )
	if self.db.profile.spider and msg:find(L["spiders_trigger"]) then
		self:Message(L["spiders_message"], "Attention")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF( msg )
	if self.db.profile.drain and msg:find(L["drainlife_trigger"]) and lastdrain < (GetTime()-3) then
		lastdrain = GetTime()
		self:Message(L["drainlife_message"], "Urgent")
	end
end
