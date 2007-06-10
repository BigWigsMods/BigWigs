------------------------------
--      Are you local?      --
------------------------------

local BB = AceLibrary("Babble-Boss-2.2")

local boss = BB["High King Maulgar"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local mage = BB["Krosh Firehand"]
local lock = BB["Olm the Summoner"]
local priest = BB["Blindeye the Seer"]
local shaman = BB["Kiggler the Crazed"]

BB = nil
local flurryannounced = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Maulgar",

	engage_trigger = "Gronn are the real power in Outland!",

	heal = "Heal",
	heal_desc = "Warn when Blindeye the Seer begins to cast a Heal.",
	heal_trigger = "Blindeye the Seer begins to cast Prayer of Healing",
	heal_message = "Blindeye casting Prayer of Healing!",
	heal_bar = "Healing",

	shield = "Shield",
	shield_desc = "Warn when Blindeye the Seer gains Greater Power Word: Shield.",
	shield_trigger = "gains Greater Power Word: Shield",
	shield_message = "Shield on Blindeye!",

	spellshield = "Spell Shield",
	spellshield_desc = "Warn when Krosh Firehand gains Spell Shield.",
	spellshield_trigger = "gains Spell Shield.",
	spellshield_message = "Spell Shield on Krosh!",

	summon = "Summon Wild Felhunter",
	summon_desc = "Warn when Olm the Summoner begins to cast Summon Wild Felhunter.",
	summon_trigger = "begins to cast Summon Wild Felhunter.",
	summon_message = "Felhunter being summoned!",
	summon_bar = "~Felhunter Cooldown",

	whirlwind = "Whirlwind",
	whirlwind_desc = "Warn when Maulgar gains Whirlwind.",
	whirlwind_trigger = "gains Whirlwind",
	whirlwind_message = "Maulgar - Whirlwind for 15sec!",
	whirlwind_bar = "Whirlwind",
	whirlwind_nextbar = "~Whirlwind Cooldown",
	whirlwind_warning1 = "Maulgar Engaged - Whirlwind in ~50sec!",
	whirlwind_warning2 = "Whirlwind Soon!",

	flurry = "Flurry",
	flurry_desc = "Warn when Maulgar is close to Flurry and gains Flurry.",
	flurry_trigger = "You will not defeat the hand of Gruul!",
	flurry_message = "50% - Flurry!",
	flurry_warning = "Flurry Soon!",

	smash = "Arcing Smash",
	smash_desc = "Show a bar for estimated Arcing Smash.",
	smash_bar = "~Arcing Smash",
} end)

L:RegisterTranslations("frFR", function() return {
	heal = "Soin",
	heal_desc = "Préviens quand Oeillaveugle le Voyant commence à lancer un soin.",
	heal_trigger = "Oeillaveugle le Voyant commence à lancer Prière de soins",
	heal_message = "Oeillaveugle incante une Prière de soins !",
	heal_bar = "Soin",

	shield = "Bouclier",
	shield_desc = "Préviens quand Oeillaveugle le Voyant gagne Mot de pouvoir : Bouclier.",
	shield_trigger = "gagne Mot de pouvoir supérieur : Bouclier",
	shield_message = "Bouclier sur Oeillaveugle !",

	spellshield = "Bouclier anti-sort",
	spellshield_desc = "Préviens quand Krosh Brasemain gagne Bouclier anti-sort.",
	spellshield_trigger = "gagne Bouclier anti-sort.",
	spellshield_message = "Bouclier anti-sort sur Krosh !",

	summon = "Chasseur corrompu sauvage",
	summon_desc = "Préviens quand Olm l'Invocateur commence à lancer Invocation d'un chasseur corrompu sauvage.",
	summon_trigger = "commence à lancer Invocation d'un chasseur corrompu sauvage.",
	summon_message = "Chasseur corrompu en cours d'invocation !",
	summon_bar = "~Cooldown Chasseur corrompu",

	whirlwind = "Tourbillon",
	whirlwind_desc = "Préviens quand Maulgar gagne Tourbillon.",
	whirlwind_trigger = "gagne Tourbillon",
	whirlwind_message = "Maulgar - Toubillon pendant 15 sec. !",
	whirlwind_bar = "Tourbillon",
	whirlwind_nextbar = "~Cooldown Tourbillon",
	whirlwind_warning1 = "Maulgar engagé - Tourbillon dans ~50 sec. !",
	whirlwind_warning2 = "Tourbillon imminent !",

	flurry = "Rafale",
	flurry_desc = "Préviens quand Maulgar est proche de Rafale et quand il gagne Rafale.",
	flurry_trigger = "Vous ne terrasserez pas la main de Gruul !",
	flurry_message = "50% - Rafale !",
	flurry_warning = "Rafale imminente !",

	smash = "Frappe en arc",
	smash_desc = "Affiche une barre pour Frappe en arc.",
	smash_bar = "~Frappe en arc",
} end)

L:RegisterTranslations("deDE", function() return {
	heal = "Heilung",
	heal_desc = "Warnt wenn Blindauge der Seher beginnt Heilung zu wirken",
	heal_trigger = "Blindauge der Seher beginnt Gebet der Heilung",
	heal_message = "Blindauge der Seher wirkt Gebet der Heilung!",
	heal_bar = "Heilung",

	shield = "Schild",
	shield_desc = "Warnung wenn Blindauge der Seher Machtwort: Schild bekommt",
	shield_trigger = "bekommt 'Gro\195\159es Machtwort: Schild'.",
	shield_message = "Schild auf Blindauge!",

	spellshield = "Zauberschild",
	spellshield_desc = "Warnung wenn Krosh Feuerhand sein Zauberschild bekommt",
	spellshield_trigger = "bekommt 'Zauberschild'.",
	spellshield_message = "Zauberschild auf Krosh!",

	summon = "Wilder Teufelsj\195\164ger",
	summon_desc = "Warnt wenn Olm der Beschw\195\182rer beginnt Wilden Teufelsj\195\164ger beschw\195\182ren zu wirken",
	summon_trigger = "beginnt Wilden Teufelsj\195\164ger beschw\195\182ren zu wirken",
	summon_message = "Teufelsj\195\164ger wurde beschworen!",

	whirlwind = "Wirbelwind",
	whirlwind_desc = "Warnung wenn Maulgar Wirbelwind bekommt",
	whirlwind_trigger = "bekommt Wirbelwind",
	whirlwind_message = "Maulgar - Wirbelwind f\195\188r 15sek!",
	whirlwind_bar = "Wirbelwind",
	whirlwind_nextbar = "~N\195\164chster Wirbelwind",
	whirlwind_warning1 = "Maulgar angegriffen - Wirbelwind in ~50sek!",
	whirlwind_warning2 = "Wirbelwind bald!",

	flurry = "Schlaghagel",
	flurry_desc = "Warnt wenn Maulgar kurz vor dem Schlaghagel steht und wenn er es bekommt",
	flurry_trigger = "Ihr werdet die Hand von Gruul nicht besiegen!",
	flurry_message = "50% - Schlaghagel!",
	flurry_warning = "Schlaghagel bald!",

	smash = "Bogenzerkracher",
	smash_desc = "Zeigt eine Bar f\195\188r den gesch\195\164tzten Bogenzerkracher",  
	smash_bar = "~Bogenzerkracher",
} end)

L:RegisterTranslations("koKR", function() return {
	heal = "치유",
	heal_desc = "블라인드아이가 치유 시전 시 경고.",
	heal_trigger = "현자 블라인드아이|1이;가; 치유 시전을 시작합니다.",
	heal_message = "블라인드아이 치유 시전!",
	heal_bar = "치유",

	shield = "보호막",
	shield_desc = "블라인드아이가 상급 신의 권능: 보호막 효과를 얻었을 때 알림.",
	shield_trigger = "상급 신의 권능: 보호막 효과를 얻었습니다.", -- check
	shield_message = "블라인드아이 보호막!",

	spellshield = "주문 보호막",
	spellshield_desc = "크로쉬가 주문 보호막 효과를 얻었을 때 알림.",
	spellshield_trigger = "크로쉬 파이어핸드|1이;가; 주문 보호막 효과를 얻었습니다.",
	spellshield_message = "크로쉬 주문 보호막!",

	summon = "사나운 지옥사냥개 소환",
	summon_desc = "울름이 지옥사냥개 소환 시전 시 경고.",
	summon_trigger = "소환사 올름|1이;가; 사나운 지옥사냥개 소환 시전을 시작합니다.",
	summon_message = "지옥사냥개 소환!",
	summon_bar = "~지옥사냥개 대기시간",

	whirlwind = "소용돌이",
	whirlwind_desc = "마울가르가 소용돌이 효과를 얻었을 때 알림.",
	whirlwind_trigger = "왕중왕 마울가르|1이;가; 소용돌이 효과를 얻었습니다.",
	whirlwind_message = "마울가르 - 15초간 소용돌이!",
	whirlwind_bar = "소용돌이",
	whirlwind_nextbar = "~소용돌이 대기시간",
	whirlwind_warning1 = "마울가르 전투 개시 - 약 50초 후 소용돌이!",
	whirlwind_warning2 = "잠시 후 소용돌이!",

	flurry = "질풍",
	flurry_desc = "마울가르의 질풍 효과 근접 및 획득 시 경고.",
	flurry_trigger = "그룰님의 손아귀에서 벗어나지 못할 것이다!",
	flurry_message = "50% - 질풍!",
	flurry_warning = "잠시 후 질풍!",

	smash = "회전베기",
	smash_desc = "회전베기 예측 바를 표시",
	smash_bar = "~회전베기",
} end)

L:RegisterTranslations("zhTW", function() return {
	heal = "治療警告",
	heal_desc = "當先知盲眼開始施放治療時發送警告",
	heal_trigger = "先知盲眼開始施放治療禱言。",
	heal_message = "先知盲眼施放群體治療 - 請中斷",
	heal_bar = "治療",

	shield = "真言術:盾警告",
	shield_desc = "當先知盲眼開始施放強效真言術:盾時發送警告",
	shield_trigger = "先知盲眼獲得了強效真言術:盾的效果。",
	shield_message = "先知盲眼施放強效真言術:盾 - 請快速擊破",

	spellshield = "法術護盾警告",
	spellshield_desc = "當克羅斯·火手施放法術護盾時發送警告",
	spellshield_trigger = "克羅斯·火手獲得了法術護盾的效果。",
	spellshield_message = "克羅斯·火手施放法術護盾 - 請偷取",

	summon = "召喚警告",
	summon_desc = "當召喚者歐莫開始施放召喚野生地獄獵犬時發送警告",
	summon_trigger = "召喚者歐莫開始施放召喚野生地獄獵犬。",
	summon_message = "野生地獄獵犬要出來咬人嚕",
	summon_bar = "召喚倒數",

	whirlwind = "旋風斬警告",
	whirlwind_desc = "當大君王莫卡爾獲得旋風斬時發送警告",
	whirlwind_trigger = "大君王莫卡爾獲得了旋風斬的效果。",
	whirlwind_message = "大君王莫卡爾 - 旋風斬 15 秒",
	whirlwind_bar = "旋風斬",
	whirlwind_nextbar = "旋風斬倒數",
	whirlwind_warning1 = "進入戰鬥 - 50 秒後施放旋風斬",
	whirlwind_warning2 = "大君王莫卡爾即將施放旋風斬",

	flurry = "亂舞警告",
	flurry_desc = "當大君王莫卡爾即將亂舞及獲得亂舞時發送警告",
	flurry_trigger = "你擊敗不了戈魯爾之手!",
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
mod.zonename = AceLibrary("Babble-Zone-2.2")["Gruul's Lair"]
mod.otherMenu = "Outland"
mod.enabletrigger = {boss, mage, lock, priest, shaman}
mod.toggleoptions = {"shield", "spellshield", "heal", -1, "summon", -1, "whirlwind", "flurry", "smash", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Event")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "BlindeyePrayer", 4)
	self:TriggerEvent("BigWigs_ThrottleSync", "BlindeyeShield", 4)
	self:TriggerEvent("BigWigs_ThrottleSync", "KroshSpellShield", 4)
	self:TriggerEvent("BigWigs_ThrottleSync", "MaulgarWhirldwind", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "OlmSummon", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MaulgarSmash", 3)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg:find(L["heal_trigger"]) then
		self:Sync("BlindeyePrayer")
	elseif msg:find(L["summon_trigger"]) then
		self:Sync("OlmSummon")
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg:find(L["shield_trigger"]) then
		self:Sync("BlindeyeShield")
	elseif msg:find(L["spellshield_trigger"]) then
		self:Sync("KroshSpellShield")
	elseif msg:find(L["whirlwind_trigger"]) then
		self:Sync("MaulgarWhirldwind")
	end
end

function mod:Event(msg)
	if msg:find(L["smash"]) then
		self:Sync("MaulgarSmash")
	end
end

function mod:BigWigs_RecvSync(sync)
	if sync == "BlindeyePrayer" and self.db.profile.heal then
		self:Message(L["heal_message"], "Important", nil, "Alarm")
	elseif sync == "BlindeyeShield" and self.db.profile.shield then
		self:Message(L["shield_message"], "Important")
	elseif sync == "KroshSpellShield" and self.db.profile.spellshield then
		self:Message(L["spellshield_message"], "Attention", nil, "Info")
	elseif sync == "OlmSummon" and self.db.profile.summon then
		self:Message(L["summon_message"], "Attention", nil, "Long")
		self:Bar(L["summon_bar"], 50, "Spell_Shadow_SummonFelGuard")
	elseif sync == "MaulgarWhirldwind" and self.db.profile.whirlwind then
		self:Message(L["whirlwind_message"], "Important")
		self:Bar(L["whirlwind_bar"], 15, "Ability_Whirlwind")
		self:Nextwhirldwind()
	elseif sync == "MaulgarSmash" and self.db.profile.smash then
		self:Bar(L["smash_bar"], 10, "Ability_Warrior_Cleave")
	end
end

function mod:Nextwhirldwind()
	self:DelayedMessage(45, L["whirlwind_warning2"], "Urgent")
	self:Bar(L["whirlwind_nextbar"], 50, "Ability_Whirlwind")
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.flurry and msg:find(L["flurry_trigger"]) then
		self:Message(L["flurry_message"], "Important")
	elseif msg == L["engage_trigger"] then
		flurryannounced = nil

		if self.db.profile.whirlwind then
			self:Message(L["whirlwind_warning1"], "Attention")
			self:Nextwhirldwind()
		end
	end
end

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.flurry then return end
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
