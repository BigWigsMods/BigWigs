------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Fathom-Lord Karathress"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Karathress",

	enrage_trigger = "Guards, attention! We have visitors....",

	totem = "Spitfire Totem",
	totem_desc = "Warn for Spitfire Totems and who cast them.",
	totem_trigger1 = "Fathom-Guard Tidalvess casts Spitfire Totem.",
	totem_trigger2 = "Fathom-Lord Karathress casts Spitfire Totem.",
	totem_message1 = "Tidalvess: Spitfire Totem",
	totem_message2 = "Karathress: Spitfire Totem",

	heal = "Heal",
	heal_desc = "Warn when Caribdis casts a heal.",
	heal_trigger = "Fathom-Guard Caribdis begins to cast Healing Wave.",
	heal_message = "Caribdis casting heal!",

	["Fathom-Guard Sharkkis"] = true, --hunter
	["Fathom-Guard Tidalvess"] = true, --shaman
	["Fathom-Guard Caribdis"] = true, --priest
} end )

L:RegisterTranslations("deDE", function() return {
	totem = "Feuerspuckendes Totem",
	totem_desc = "Warnt vor dem Feuerspuckenden Totem und wer es aufstellt.",

	heal = "Heilung",
	heal_desc = "Warnt, wenn Caribdis anf\195\164ngt zu heilen.",

	enrage_trigger = "Achtung, Wachen! Wir haben Besuch...",

	totem_trigger1 = "Tiefenw\195\164chter Flutvess wirkt Feuerspuckendes Totem.",
	totem_trigger2 = "Tiefenlord Karathress wirkt Feuerspuckendes Totem.",
	totem_message1 = "Flutvess: Feuerspuckendes Totem",
	totem_message2 = "Karathress: Feuerspuckendes Totem",

	heal_trigger = "Tiefenw\195\164chter Caribdis beginnt Welle der Heilung zu wirken.", --to verify
	heal_message = "Caribdis heilt!",

	["Fathom-Guard Sharkkis"] = "Tiefenw\195\164chter Haikis", --hunter
	["Fathom-Guard Tidalvess"] = "Tiefenw\195\164chter Flutvess", --shaman
	["Fathom-Guard Caribdis"] = "Tiefenw\195\164chter Caribdis", --priest
} end )

L:RegisterTranslations("koKR", function() return {
	enrage_trigger = "경비병! 여기 침입자들이 있다...",

	totem = "불 뿜는 토템",
	totem_desc = "불 뿜는 토템을 시전 시 경고합니다.",
	totem_trigger1 = "심연의 경비병 타이달베스|1이;가; 불 뿜는 토템|1을;를; 시전합니다.",
	totem_trigger2 = "심연의 군주 카라드레스|1이;가; 불 뿜는 토템|1을;를; 시전합니다.",
	totem_message1 = "타이달베스: 불뿜는 토템",
	totem_message2 = "카라드레스: 불뿜는 토템",

	heal = "치유",
	heal_desc = "카리브디스의 치유 시전을 경고합니다.",
	heal_trigger = "칼리브디스|1이;가; 치유의 물결 시전을 시작합니다.",
	heal_message = "칼리브디스 치유 시전!",

	["Fathom-Guard Sharkkis"] = "심연의 경비병 샤르키스", --hunter
	["Fathom-Guard Tidalvess"] = "심연의 경비병 타이달베스", --shaman
	["Fathom-Guard Caribdis"] = "심연의 경비병 카리브디스", --priest
} end )

L:RegisterTranslations("frFR", function() return {
	enrage_trigger = "Gardes, en position ! Nous avons de la visite…",

	totem = "Totem crache-feu",
	totem_desc = "Préviens quand un Totem crache-feu est posé et indique son possesseur.",
	totem_trigger1 = "Garde-fonds Marevess lance Totem crache-feu.",
	totem_trigger2 = "Seigneur des fonds Karathress lance Totem crache-feu.",
	totem_message1 = "Marevess : Totem crache-feu",
	totem_message2 = "Karathress : Totem crache-feu",

	heal = "Soins",
	heal_desc = "Préviens quand Caribdis incante un soin.",
	heal_trigger = "Garde-fonds Caribdis commence à lancer Vague de soins.",
	heal_message = "Caribdis incante un soin !",

	["Fathom-Guard Sharkkis"] = "Garde-fonds Squallis", --hunter
	["Fathom-Guard Tidalvess"] = "Garde-fonds Marevess", --shaman
	["Fathom-Guard Caribdis"] = "Garde-fonds Caribdis", --priest
} end )

L:RegisterTranslations("zhTW", function() return {
	enrage_trigger = "守衛，注意!我們有訪客了……",

	totem = "飛火圖騰",
	totem_desc = "飛火圖騰施放警示",
	totem_trigger1 = "深淵守衛提達費斯施放了飛火圖騰。",
	totem_trigger2 = "深淵之王卡拉薩瑞斯施放了飛火圖騰。",
	totem_message1 = "提達費斯：飛火圖騰",
	totem_message2 = "卡拉薩瑞斯：飛火圖騰",

	heal = "治療術",
	heal_desc = "當卡利迪斯施放治療術時警示",
	heal_trigger = "卡利迪斯開始施放治療波。",
	heal_message = "治療波 - 快中斷！",

	["Fathom-Guard Sharkkis"] = "深淵守衛沙卡奇斯",
	["Fathom-Guard Tidalvess"] = "深淵守衛提達費斯",
	["Fathom-Guard Caribdis"] = "深淵守衛卡利迪斯",
} end )

L:RegisterTranslations("zhCN", function() return {
	enrage_trigger = "卫兵！提高警惕！我们有客人来了……",

	totem = "溅火图腾",
	totem_desc = "当溅火图腾被施放发出警报。",
	totem_trigger1 = "深水卫士泰达维斯施放了溅火图腾。",
	totem_trigger2 = "深水领主卡拉瑟雷斯施放了溅火图腾。",
	totem_message1 = "泰达维斯：>溅火图腾<！",
	totem_message2 = "卡拉瑟雷斯：>溅火图腾<！",

	heal = "治疗",
	heal_desc = "当卡莉蒂丝施放治疗术发出警报。",
	heal_trigger = "深水卫士卡莉蒂丝开始施放治疗波。",
	heal_message = "卡莉蒂丝正在施放治疗！",

	["Fathom-Guard Sharkkis"] = "深水卫士沙克基斯", --hunter
	["Fathom-Guard Tidalvess"] = "深水卫士泰达维斯", --shaman
	["Fathom-Guard Caribdis"] = "深水卫士卡莉蒂丝", --priest
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Serpentshrine Cavern"]
mod.enabletrigger = {boss, L["Fathom-Guard Sharkkis"], L["Fathom-Guard Tidalvess"], L["Fathom-Guard Caribdis"]}
mod.toggleoptions = {"heal", "enrage", "totem", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "KaraTotem", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "TidaTotem", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "CariHeal", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.enrage and msg == L["enrage_trigger"] then
		self:Message(L2["enrage_start"]:format(boss, 10), "Attention")
		self:DelayedMessage(300, L2["enrage_min"]:format(5), "Positive")
		self:DelayedMessage(420, L2["enrage_min"]:format(3), "Positive")
		self:DelayedMessage(540, L2["enrage_sec"]:format(60), "Positive")
		self:DelayedMessage(570, L2["enrage_sec"]:format(30), "Positive")
		self:DelayedMessage(590, L2["enrage_sec"]:format(10), "Urgent")
		self:DelayedMessage(600, L2["enrage_end"]:format(boss), "Attention", nil, "Alarm")
		self:Bar(L2["enrage"], 600, "Spell_Shadow_UnholyFrenzy")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["totem_trigger1"] then
		self:Sync("TidaTotem")
	elseif msg == L["totem_trigger2"] then
		self:Sync("KaraTotem")
	elseif msg == L["heal_trigger"] then
		self:Sync("CariHeal")
	end
end

function mod:BigWigs_RecvSync(sync)
	if sync == "KaraTotem" and self.db.profile.totem then
		self:Message(L["totem_message2"], "Urgent", nil, "Alarm")
	elseif sync == "TidaTotem" and self.db.profile.totem then
		self:Message(L["totem_message1"], "Attention")
	elseif sync == "CariHeal" and self.db.profile.heal then
		self:Message(L["heal_message"], "Important", nil, "Long")
	end
end
