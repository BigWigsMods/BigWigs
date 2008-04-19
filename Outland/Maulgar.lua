------------------------------
--      Are you local?      --
------------------------------

local boss = BB["High King Maulgar"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local mage = BB["Krosh Firehand"]
local lock = BB["Olm the Summoner"]
local priest = BB["Blindeye the Seer"]
local shaman = BB["Kiggler the Crazed"]

local flurryannounced = nil
local db = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Maulgar",

	engage_trigger = "Gronn are the real power in Outland!",

	heal = "Heal",
	heal_desc = "Warn when Blindeye the Seer begins to cast a Heal.",
	heal_message = "Blindeye casting Prayer of Healing!",
	heal_bar = "Healing",

	shield = "Shield",
	shield_desc = "Warn when Blindeye the Seer gains Greater Power Word: Shield.",
	shield_message = "Shield on Blindeye!",

	spellshield = "Spell Shield",
	spellshield_desc = "Warn when Krosh Firehand gains Spell Shield.",
	spellshield_message = "Spell Shield on Krosh!",
	spellshield_bar = "Next Spell Shield",

	summon = "Summon Wild Felhunter",
	summon_desc = "Warn when Olm the Summoner begins to cast Summon Wild Felhunter.",
	summon_message = "Felhunter being summoned!",
	summon_bar = "~Felhunter Cooldown",

	whirlwind = "Whirlwind",
	whirlwind_desc = "Warn when Maulgar gains Whirlwind.",
	whirlwind_message = "Maulgar - Whirlwind for 15sec!",
	whirlwind_bar = "Whirlwind",
	whirlwind_nextbar = "~Whirlwind Cooldown",
	whirlwind_warning1 = "Maulgar Engaged - Whirlwind in ~50sec!",
	whirlwind_warning2 = "Whirlwind Soon!",

	flurry = "Flurry",
	flurry_desc = "Warn when Maulgar is close to Flurry and gains Flurry.",
	flurry_message = "50% - Flurry!",
	flurry_warning = "Flurry Soon!",

	smash = "Arcing Smash",
	smash_desc = "Show a bar for estimated Arcing Smash.",
	smash_bar = "~Arcing Smash",
} end)

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Les gronns sont la seule vraie puissance de l'Outreterre !",

	heal = "Soin",
	heal_desc = "Préviens quand Oeillaveugle le Voyant commence à lancer un soin.",
	heal_message = "Oeillaveugle incante une Prière de soins !",
	heal_bar = "Soin en cours",

	shield = "Bouclier",
	shield_desc = "Préviens quand Oeillaveugle le Voyant gagne Mot de pouvoir : Bouclier.",
	shield_message = "Bouclier sur Oeillaveugle !",

	spellshield = "Bouclier anti-sort",
	spellshield_desc = "Préviens quand Krosh Brasemain gagne Bouclier anti-sort.",
	spellshield_message = "Bouclier anti-sort sur Krosh !",
	spellshield_bar = "Prochain Bouclier",

	summon = "Chasseur corrompu sauvage",
	summon_desc = "Préviens quand Olm l'Invocateur commence à lancer Invocation d'un chasseur corrompu sauvage.",
	summon_message = "Chasseur corrompu en cours d'invocation !",
	summon_bar = "~Cooldown Chasseur corrompu",

	whirlwind = "Tourbillon",
	whirlwind_desc = "Préviens quand Maulgar gagne Tourbillon.",
	whirlwind_message = "Maulgar - Toubillon pendant 15 sec. !",
	whirlwind_bar = "Tourbillon",
	whirlwind_nextbar = "~Cooldown Tourbillon",
	whirlwind_warning1 = "Maulgar engagé - Tourbillon dans ~50 sec. !",
	whirlwind_warning2 = "Tourbillon imminent !",

	flurry = "Rafale",
	flurry_desc = "Préviens quand Maulgar est proche de Rafale et quand il gagne Rafale.",
	flurry_message = "50% - Rafale !",
	flurry_warning = "Rafale imminente !",

	smash = "Frappe en arc de cercle",
	smash_desc = "Affiche une barre pour Frappe en arc de cercle.",
	smash_bar = "~Frappe en arc de cercle",
} end)

L:RegisterTranslations("deDE", function() return {
	heal = "Heilung",
	heal_desc = "Warnt wenn Blindauge der Seher beginnt Heilung zu wirken",
	heal_message = "Blindauge der Seher wirkt Gebet der Heilung!",
	heal_bar = "Heilung",

	shield = "Schild",
	shield_desc = "Warnung wenn Blindauge der Seher Machtwort: Schild bekommt",
	shield_message = "Schild auf Blindauge!",

	spellshield = "Zauberschild",
	spellshield_desc = "Warnung wenn Krosh Feuerhand sein Zauberschild bekommt",
	spellshield_message = "Zauberschild auf Krosh!",
	--spellshield_bar = "Next Spell Shield",

	summon = "Wilder Teufelsj\195\164ger",
	summon_desc = "Warnt wenn Olm der Beschw\195\182rer beginnt Wilden Teufelsj\195\164ger beschw\195\182ren zu wirken",
	summon_message = "Teufelsj\195\164ger wurde beschworen!",

	whirlwind = "Wirbelwind",
	whirlwind_desc = "Warnung wenn Maulgar Wirbelwind bekommt",
	whirlwind_message = "Maulgar - Wirbelwind f\195\188r 15sek!",
	whirlwind_bar = "Wirbelwind",
	whirlwind_nextbar = "~N\195\164chster Wirbelwind",
	whirlwind_warning1 = "Maulgar angegriffen - Wirbelwind in ~50sek!",
	whirlwind_warning2 = "Wirbelwind bald!",

	flurry = "Schlaghagel",
	flurry_desc = "Warnt wenn Maulgar kurz vor dem Schlaghagel steht und wenn er es bekommt",
	flurry_message = "50% - Schlaghagel!",
	flurry_warning = "Schlaghagel bald!",

	smash = "Bogenzerkracher",
	smash_desc = "Zeigt eine Bar f\195\188r den gesch\195\164tzten Bogenzerkracher",
	smash_bar = "~Bogenzerkracher",
} end)

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "그론이 아웃랜드의 진정한 강자다!",

	heal = "치유",
	heal_desc = "블라인드아이가 치유 시전 시 경고합니다.",
	heal_message = "블라인드아이 치유 시전!",
	heal_bar = "치유",

	shield = "보호막",
	shield_desc = "블라인드아이가 상급 신의 권능: 보호막 효과를 얻었을 때 알립니다.",
	shield_message = "블라인드아이 보호막!",

	spellshield = "주문 보호막",
	spellshield_desc = "크로쉬가 주문 보호막 효과를 얻었을 때 알립니다.",
	spellshield_message = "크로쉬 주문 보호막!",
	spellshield_bar = "다음 주문 보호막",

	summon = "사나운 지옥사냥개 소환",
	summon_desc = "울름이 지옥사냥개 소환 시전 시 경고합니다.",
	summon_message = "지옥사냥개 소환!",
	summon_bar = "~지옥사냥개 대기시간",

	whirlwind = "소용돌이",
	whirlwind_desc = "마울가르가 소용돌이 효과를 얻었을 때 알립니다.",
	whirlwind_message = "마울가르 - 15초간 소용돌이!",
	whirlwind_bar = "소용돌이",
	whirlwind_nextbar = "~소용돌이 대기시간",
	whirlwind_warning1 = "마울가르 전투 개시 - 약 50초 후 소용돌이!",
	whirlwind_warning2 = "잠시 후 소용돌이!",

	flurry = "질풍",
	flurry_desc = "마울가르의 질풍 효과 근접 및 획득 시 경고합니다.",
	flurry_message = "50% - 질풍!",
	flurry_warning = "잠시 후 질풍!",

	smash = "회전베기",
	smash_desc = "회전베기 예측 바를 표시합니다.",
	smash_bar = "~회전베기",
} end)

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "戈隆才是外域的主宰！",

	heal = "治疗",
	heal_desc = "当开始施放治疗时发出警报。",
	heal_message = "盲眼先知 - 治疗祷言！",
	heal_bar = "<治疗>",

	shield = "真言术：盾",
	shield_desc = "当获得强效真言术：盾时发出警报。",
	shield_message = "盲眼先知 真言术：盾！",

	spellshield = "法术护盾",
	spellshield_desc = "当克洛什·火拳获得法术护盾时发出警报。",
	spellshield_message = "克洛什 法术护盾！",
	spellshield_bar = "<下一法术护盾>",

	summon = "召唤地狱犬",
	summon_desc = "当召唤者沃尔姆施放召唤地狱犬时发出警报。",
	summon_message = "开始召唤 地狱犬！",
	summon_bar = "<地狱犬 计时>",

	whirlwind = "旋风斩",
	whirlwind_desc = "当莫加尔获得旋风斩时发出警报。",
	whirlwind_message = "莫加尔 - 旋风斩！15秒。",
	whirlwind_bar = "<旋风斩>",
	whirlwind_nextbar = "<旋风斩 冷却>",
	whirlwind_warning1 = "莫加尔 激活！约50秒后，旋风斩！",
	whirlwind_warning2 = "即将 旋风斩！",

	flurry = "乱舞",
	flurry_desc = "当莫加尔乱舞消失及获得乱舞发出警报。",
	flurry_message = "50% - 乱舞！",
	flurry_warning = "即将 乱舞！",

	smash = "圆弧斩",
	smash_desc = "显示一个圆弧斩大约时间条。",
	smash_bar = "<圆弧斩>",
} end)

L:RegisterTranslations("zhTW", function() return {
	heal = "治療警告",
	heal_desc = "當先知盲眼開始施放治療時發送警告",
	heal_message = "先知盲眼施放群體治療 - 請中斷",
	heal_bar = "治療",

	shield = "真言術:盾警告",
	shield_desc = "當先知盲眼開始施放強效真言術:盾時發送警告",
	shield_message = "先知盲眼施放強效真言術:盾 - 請快速擊破",

	spellshield = "法術護盾警告",
	spellshield_desc = "當克羅斯·火手施放法術護盾時發送警告",
	spellshield_message = "火手施放法術護盾 - 法師偷取！",
	spellshield_bar = "法術護盾",

	summon = "召喚警告",
	summon_desc = "當召喚者歐莫開始施放召喚野生地獄獵犬時發送警告",
	summon_message = "野生地獄獵犬要出來咬人嚕",
	summon_bar = "召喚倒數",

	whirlwind = "旋風斬警告",
	whirlwind_desc = "當大君王莫卡爾獲得旋風斬時發送警告",
	whirlwind_message = "大君王莫卡爾 - 旋風斬 15 秒",
	whirlwind_bar = "旋風斬",
	whirlwind_nextbar = "旋風斬倒數",
	whirlwind_warning1 = "進入戰鬥 - 50 秒後施放旋風斬",
	whirlwind_warning2 = "大君王莫卡爾即將施放旋風斬",

	flurry = "亂舞警告",
	flurry_desc = "當大君王莫卡爾即將亂舞及獲得亂舞時發送警告",
	flurry_message = "50% - 亂舞",
	flurry_warning = "大君王莫卡爾即將施放亂舞",

	smash = "圓弧斬提示",
	smash_desc = "顯示圓弧斬倒數計時條",
	smash_bar = "圓弧斬",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Gruul's Lair"]
mod.otherMenu = "Outland"
mod.enabletrigger = {boss, mage, lock, priest, shaman}
mod.toggleoptions = {"shield", "spellshield", "heal", -1, "summon", -1, "whirlwind", "flurry", "smash", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Shield", 33147)
	self:AddCombatListener("SPELL_AURA_APPLIED", "SpellShield", 33054)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Whirlwind", 33238)
	self:AddCombatListener("SPELL_CAST_START", "Summon", 33131)
	self:AddCombatListener("SPELL_CAST_START", "Prayer", 33152)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Smash", 39144)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Flurry", 33232)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Shield(_, spellID)
	if db.shield then
		self:IfMessage(L["shield_message"], "Important", spellID)
	end
end

function mod:SpellShield(unit, spellID)
	if unit == mage and db.spellshield then
		self:IfMessage(L["spellshield_message"], "Attention", spellID, "Info")
		self:Bar(L["spellshield_bar"], 30, spellID)
	end
end

function mod:Whirlwind(_, spellID)
	if db.whirlwind then
		self:IfMessage(L["whirlwind_message"], "Important", spellID)
		self:Bar(L["whirlwind_bar"], 15, spellID)
		self:DelayedMessage(45, L["whirlwind_warning2"], "Urgent")
		self:Bar(L["whirlwind_nextbar"], 50, spellID)
	end
end

function mod:Summon(_, spellID)
	if db.summon then
		self:IfMessage(L["summon_message"], "Attention", spellID, "Long")
		self:Bar(L["summon_bar"], 50, spellID)
	end
end

function mod:Prayer(_, spellID)
	if db.heal then
		self:IfMessage(L["heal_message"], "Important", spellID, "Alarm")
	end
end

function mod:Smash(_, spellID)
	if db.smash then
		self:Bar(L["smash_bar"], 10, spellID)
	end
end

function mod:Flurry(_, spellID)
	if db.flurry then
		self:IfMessage(L["flurry_message"], "Important", spellID)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		flurryannounced = nil

		if db.whirlwind then
			self:Message(L["whirlwind_warning1"], "Attention")
			self:DelayedMessage(45, L["whirlwind_warning2"], "Urgent")
			self:Bar(L["whirlwind_nextbar"], 50, 33238)
		end
		if db.spellshield then
			self:Bar(L["spellshield_bar"], 30, 33054)
		end
	end
end

function mod:UNIT_HEALTH(msg)
	if not db.flurry then return end
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 52 and health <= 56 and not flurryannounced then
			self:Message(L["flurry_warning"], "Positive")
			flurryannounced = true
		elseif health > 62 and flurryannounced then
			flurryannounced = false
		end
	end
end

