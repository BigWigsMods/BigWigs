------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Hakkar"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	-- Chat message triggers
	engage_trigger = "FACE THE WRATH OF THE SOULFLAYER!",
	drain_trigger = "^Hakkar suffers (.+) from (.+) Blood Siphon",
	mindcontrol_trigger = "(.*) (.*) afflicted by Cause Insanity",

	you = "You",
	are = "are",

	flee = "Fleeing will do you no good, mortals!",

	-- Warnings and bar texts
	start_message = "Hakkar engaged - 90sec to drain - 10min to enrage!",
	drain_warning = "%d sec to Life Drain!",
	drain_message = "Life Drain - 90 sec to next!",

	mindcontrol_message = "%s is mindcontrolled!",
	mindcontrol_bar = "MC: %s",

	["Enrage"] = true,
	["Life Drain"] = true,

	cmd = "Hakkar",

	drain_name = "Drain Alerts",
	drain_desc = "Warn for Drains",

	enrage_name = "Enrage Alerts",
	enrage_desc = "Warn for Enrage",

	mc_name = "Mind Control",
	mc_desc = "Alert when someone is mind controlled.",

	icon_name = "Place Icon",
	icon_desc = "Place a skull icon on the mind controlled person (requires promoted or higher)",
} end)

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "^EURE \195\156BERHEBLICHKEIT K\195\156NDET BEREITS VOM ENDE DIESER WELT!",
	drain_trigger = "^Hakkar erleidet (.+) Naturschaden von (.+) %(durch Bluttrinker%).",
	mindcontrol_trigger = "(.*) (.*) von Wahnsinn verursachen betroffen.",

	you = "Ihr",
	are = "seid",

	flee = "Es ist sinnlos zu fl\195\188chten, Sterbliche!",

	start_message = "Hakkar angegriffen! Bluttrinker in 90 Sekunden! Wutanfall in 10 Minuten!",
	drain_warning = "Bluttrinker in %d Sekunden!",
	drain_message = "Bluttrinker! N\195\164chster in 90 Sekunden!",

	mindcontrol_message = "%s steht unter Gedankenkontrolle!",
	mindcontrol_bar = "MC: %s",

	["Enrage"] = "Wutanfall",
	["Life Drain"] = "Bluttrinker",

	drain_name = "Bluttrinker",
	drain_desc = "Warnung, wenn Hakkar Bluttrinker wirkt.",

	enrage_name = "Wutanfall",
	enrage_desc = "Warnung, wenn Hakkar w\195\188tend wird.",

	mc_name = "Gedankenkontrolle",
	mc_desc = "Warnung wenn jemand unter Gedankenkontrolle steht.",

	icon_name = "Symbol",
	icon_desc = "Platziert ein Symbol \195\188ber dem Spieler, der unter Gedankenkontrolle steht. (Ben\195\182tigt Anf\195\188hrer oder Bef\195\182rdert Status.)",
} end)

L:RegisterTranslations("frFR", function() return {
	-- Chat message triggers
	engage_trigger = "ANNONCE LA FIN DE VOTRE MONDE",
	drain_trigger = "^Siphon de sang .+ (.+) inflige \195\160 Hakkar (.+).",
	mindcontrol_trigger = "(.*) (.*) les effets de Rendre fou.",

	you = "Vous",
	are = "subissez",

	flee = "Fuir ne vous servira \195\160 rien, mortels !",

-- Warnings and bar texts
	start_message = "Hakkar engag\195\169 - 90 sec. avant Drain - 10 min. avant Enrager",
	drain_warning = "%d sec. avant le Drain de vie !",	
	drain_message = "Drain de vie - 90 sec. avant le prochain !",

	mindcontrol_message = "%s est devenu fou !",
	mindcontrol_bar = "CM: %s",

	["Enrage"] = "Enrager",
	["Life Drain"] = "Drain de vie",

	drain_name = "Alerte Drain",
	drain_desc = "Pr\195\169viens quand Hakkar fait ses drains de vie.",

	enrage_name = "Alerte Enrager",
	enrage_desc = "Pr\195\169viens quand Hakkar devient enrag\195\169.",

	mc_name = "Alerte Contr\195\180le Mental",
	mc_desc = "Pr\195\169viens quand quelqu'un est sous le contr\195\180le d'Hakkar.",

	icon_name = "Placer une ic\195\180ne",
	icon_desc = "Place une ic\195\180ne de raid sur la personne sous contr\195\180le mental (n\195\169cessite d'\195\170tre promu ou mieux).",	
} end)

L:RegisterTranslations("koKR", function() return {
	-- Chat message triggers
	engage_trigger = "자만심은 세상의 종말을 불러올 뿐이다. 오너라! 건방진 피조물들이여! 와서 신의 진노에 맞서 보아라!",
	drain_trigger = "학카르|1이;가; (.+)의 피의 착취에 의해 (.+)의 자연 피해를 입었습니다.",
	mindcontrol_trigger = "^([^|;%s]*)(.*)정신 착란에 걸렸습니다%.$", -- "(.*) (.*) afflicted by Cause Insanity", -- CHECK

	you = "",
	are = "",

	flee = "도망쳐 봐야 소용없다, 어리석은 생명체여!", -- by turtl

	-- Warnings and bar texts
	start_message = "학카르 시작 - 90초후 생명력 흡수 - 10분후 격노",
	drain_warning = "생명력 흡수 %d초전",
	drain_message = "생명력 흡수 - 다음 시전은 90초후",

	mindcontrol_message = "%s|1이;가; 정신 지배되었습니다!",
	mindcontrol_bar = "정신지배: %s",

	["Enrage"] = "격노",
	["Life Drain"] = "생명력 흡수",

	drain_name = "흡수 경고",
	drain_desc = "흡수에 대한 경고",

	enrage_name = "격노 경고",
	enrage_desc = "격노에 대한 경고",

	mc_name = "정신 지배",
	mc_desc = "정신 지배 되었을 때 경고",

	icon_name = "아이콘 지정",
	icon_desc = "정신 지배된 사람에게 해골 아이콘 지정 (승급자 이상 필요)",
} end)


L:RegisterTranslations("zhCN", function() return {
	-- Chat message triggers
	engage_trigger = "^骄傲会将你送上绝路",
	drain_trigger = "^(.+)的酸性血液虹吸使哈卡受到了(.+)",
	mindcontrol_trigger = "^(.+)受(.+)疯狂效果的影响",

	you = "你",
	are = "到",

	flee = "逃跑",

	-- Warnings and bar texts
	start_message = "哈卡已经激活 - 90秒后开始生命吸取 - 10分钟后进入激怒状态",
	drain_warning = "%d秒后发动生命吸取",
	drain_message = "血液虹吸 - 90秒后再次发动",

	mindcontrol_message = "%s 被控制了",
	mindcontrol_bar = "MC: %s",

	["Enrage"] = "激怒",
	["Life Drain"] = "生命吸取",

	drain_name = "生命吸取警报",
	drain_desc = "生命吸取警报",

	enrage_name = "激怒警报",
	enrage_desc = "激怒警报",

	mc_name = "精神控制警报",
	mc_desc = "哈卡使用精神控制时警报。",

	icon_name = "标记精神控制",
	icon_desc = "团队标记被精神控制者 (需要助力或更高权限)",
} end)

L:RegisterTranslations("zhTW", function() return {
	-- Chat message triggers
	engage_trigger = "^驕傲會將你送上絕路",
	drain_trigger = "^(.+)的血液虹吸使哈卡受到了(.+)點自然傷害。$",
	mindcontrol_trigger = "^(.+)受到(.*)導致瘋狂",

	you = "你",
	are = "了",
	
	flee = "逃跑",

	-- Warnings and bar texts
	start_message = "哈卡已經進入戰鬥 - 90秒後開始血液虹吸 - 10分鐘後進入狂怒狀態",
	drain_warning = "%d 秒後開始生命吸取",
	drain_message = "血液虹吸 - 90秒後再次發動",

	mindcontrol_message = "%s 被控制了，法師快羊",
	mindcontrol_bar = "MC: %s",

	["Enrage"] = "狂怒",
	["Life Drain"] = "血液虹吸",

	drain_name = "血液虹吸警報",
	drain_desc = "血液虹吸警報",

	enrage_name = "狂怒警報",
	enrage_desc = "狂怒警報",

	mc_name = "精神控制警報",
	mc_desc = "哈卡使用精神控制時警報。",

	icon_name = "標記被精神控制的隊友",
	icon_desc = "在被精神控制的隊友頭上設置標記 (需要助手或領隊權限)",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Gurub"]
mod.enabletrigger = boss
mod.toggleoptions = { "drain", "enrage", -1, "mc", "icon", "bosskill" }
mod.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self.prior = nil
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_Message")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) then
		self:TriggerEvent("BigWigs_Message", L["start_message"], "Important")
		if self.db.profile.enrage then self:TriggerEvent("BigWigs_StartBar", self, L["Enrage"], 600, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy") end
		self:BeginTimers(true)
	elseif msg:find(L["flee"]) then
		self:TriggerEvent("BigWigs_RebootModule", self)
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(msg)
	if not self.prior and msg:find(L["drain_trigger"]) then
		self.prior = true
		self:BeginTimers()
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE(msg)
	local mcplayer, mctype = select(3, msg:find(L["mindcontrol_trigger"]))
	if mcplayer then
		if mcplayer == L["you"] then
			mcplayer = UnitName("player")
		end
		if self.db.profile.mc then
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["mindcontrol_bar"], mcplayer), 9.5, "Interface\\Icons\\Spell_Shadow_ShadowWordDominate")
			self:TriggerEvent("BigWigs_Message", string.format(L["mindcontrol_message"], mcplayer), "Urgent")
		end
		if self.db.profile.icon then
			self:TriggerEvent("BigWigs_SetRaidIcon", mcplayer)
		end
	end
end

function mod:BigWigs_Message(text)
	if text == string.format(L["drain_warning"], 60) then self.prior = nil end
end

function mod:BeginTimers(first)
	if self.db.profile.drain then
		if not first then self:TriggerEvent("BigWigs_Message", L["drain_message"], "Attention") end
		self:ScheduleEvent("bwhakkarld60", "BigWigs_Message", 30, string.format(L["drain_warning"], 60), "Attention")
		self:ScheduleEvent("bwhakkarld45", "BigWigs_Message", 45, string.format(L["drain_warning"], 45), "Attention")
		self:ScheduleEvent("bwhakkarld30", "BigWigs_Message", 60, string.format(L["drain_warning"], 30), "Urgent")
		self:ScheduleEvent("bwhakkarld15", "BigWigs_Message", 75, string.format(L["drain_warning"], 15), "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["Life Drain"], 90, "Interface\\Icons\\Spell_Shadow_LifeDrain")
	end
end
