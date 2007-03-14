------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High King Maulgar"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local started
local flurryannounced

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Maulgar",

	heal = "Heal",
	heal_desc = "Warn when Blindeye the Seer begins to cast a Heal",

	shield = "Shield",
	shield_desc = "Warn when Blindeye the Seer gains Greater Power Word: Shield",

	spellshield = "Spell Shield",
	spellshield_desc = "Warn when Krosh Firehand gains Spell Shield",

	summon = "Summon Wild Felhunter",
	summon_desc = "Warn when Olm the Summoner begins to cast Summon Wild Felhunter",

	whirlwind = "Whirldwind",
	whirlwind_desc = "Warn when Maulgar gains Whirlwind",

	flurry = "Flurry",
	flurry_desc = "Warn when Maulgar is close to Flurry and gains Flurry",

	heal_trigger = "Blindeye the Seer begins to cast Prayer of Healing",
	heal_message = "Blindeye casting Prayer of Healing!",
	heal_bar = "Healing",

	shield_trigger = "gains Greater Power Word: Shield",
	shield_message = "Shield on Blindeye!",

	spellshield_trigger = "gains Spell Shield.",
	spellshield_message = "Spell Shield on Krosh!",

	summon_trigger = "begins to cast Summon Wild Felhunter.",
	summon_message = "Felhunter being summoned!",

	flurry_trigger = "You will not defeat the hand of Gruul!",
	flurry_message = "50% - Flurry!",
	flurry_warning = "Flurry Soon!",

	whirlwind_trigger = "gains Whirlwind",
	whirlwind_message = "Maulgar - Whirlwind for 15sec!",
	whirlwind_bar = "Whirlwind",
	whirlwind_nextbar = "~Next Whirlwind",
	whirlwind_warning1 = "Maulgar Engaged - Whirldwind in ~50sec!",
	whirlwind_warning2 = "Whirlwind Soon!",
} end)

L:RegisterTranslations("frFR", function() return {
	heal = "Alerte soin",
	heal_desc = "Pr\195\169viens quand Oeillaveugle le Voyant commence \195\160 lancer un soin.",

	shield = "Alerte Bouclier",
	shield_desc = "Pr\195\169viens quand Oeillaveugle le Voyant se pose un bouclier.",

	spellshield = "Alerte Bouclier anti-sort",
	spellshield_desc = "Pr\195\169viens quand Krosh Brasemain se pose le bouclier anti-sort.",

	summon = "Invocation d'un chasseur corrompu",
	summon_desc = "Pr\195\169viens quand Olm l'Invocateur commence \195\160 lancer Invocation d'un chasseur corrompu sauvage",

	whirlwind = "Alerte Tourbillon",
	whirlwind_desc = "Pr\195\169viens quand Maulgar commence un Tourbillon.",

	flurry = "Alerte Rafale",
	flurry_desc = "Pr\195\169viens quand Maulgar est proche de Rafale et quand il gagne Rafale.",

	heal_trigger = "Oeillaveugle le Voyant commence \195\160 lancer Pri\195\168re de soins%.",
	heal_message = "Oeillaveugle lance une Pri\195\168re de soins !",
	heal_bar = "Soin",

	shield_trigger = "gagne Mot de pouvoir sup\195\169rieur\194\160: Bouclier",
	shield_message = "Bouclier sur Oeillaveugle !",

	spellshield_trigger = "gagne Bouclier anti-sort%.",
	spellshield_message = "Bouclier anti-sort sur Krosh !",

	summon_trigger = "commence \195\160 lancer Invocation d\226\128\153un chasseur corrompu sauvage.",
	summon_message = "Invocation d'un chasseur corrompu!",

	flurry_trigger = "Vous ne terrasserez pas la main de Gruul\194\160!",
	flurry_message = "50% - Rafale !",
	flurry_warning = "Rafale bient\195\180t !",

	whirlwind_trigger = "gagne Tourbillon%.",
	whirlwind_message = "Maulgar - Toubillon pour 15 secondes !",
	whirlwind_bar = "Tourbillon",
	whirlwind_nextbar = "Prochain Tourbillon",
	whirlwind_warning1 = "Maulgar Engag\195\169 - Tourbillon dans ~50 secondes !",
	whirlwind_warning2 = "Tourbillon bient\195\180t !",
} end)

L:RegisterTranslations("deDE", function() return {
	heal = "Heal",
	heal_desc = "Warn when Blindeye the Seer begins to cast a Heal",

	shield = "Schild",
	shield_desc = "Warnung wenn Blindauge der Seher Machtwort: Schild bekommt",

	spellshield = "Zauberschild",
	spellshield_desc = "Warnung wenn Krosh Feuerhand sein Zauberschild bekommt",

	--summon = "Summon Wild Felhunter",
	--summon_desc = "Warn when Olm the Summoner begins to cast Summon Wild Felhunter",

	whirlwind = "Wirbelwind",
	whirlwind_desc = "Warnung wenn Raufgar Wirbelwind bekommt",

	flurry = "Schlaghagel",
	flurry_desc = "Warnung wenn Raufgar kurz vor dem Schlaghagel steht und wenn er es bekommt",

	heal_trigger = "Blindauge der Seher beginnt Gebet der Heilung.*",
	heal_message = "Blindauge der Seher wirkt Gebet der Heilung!",
	heal_bar = "Heilung",

	shield_trigger = "bekommt 'Gro\195\159es Machtwort: Schild'.",
	shield_message = "Schild auf Blindauge!",

	spellshield_trigger = "bekommt 'Zauberschild'.",
	spellshield_message = "Zauberschild auf Krosh!",

	--summon_trigger = "begins to cast Summon Wild Felhunter.",
	--summon_message = "Felhunter being summoned!",

	flurry_trigger = "Ihr werdet die Hand von Gruul nicht besiegen!",
	flurry_message = "50% - Schlaghagel!",
	flurry_warning = "Schlaghagel bald!",

	whirlwind_trigger = "bekommt Wirbelwind",
	whirlwind_message = "Raufgar - Wirbelwind fuer 15sek!",
	whirlwind_bar = "Wirbelwind",
	whirlwind_nextbar = "~Naechster Wirbelwind",
	whirlwind_warning1 = "Raufgar angegriffen - Wirbelwind in ~50sek!",
	whirlwind_warning2 = "Wirbelwind bald!",
} end)

L:RegisterTranslations("koKR", function() return {
	heal = "치유",
	heal_desc = "블라인드아이가 치유 시전 시 경고",

	shield = "보호막",
	shield_desc = "블라인드아이가 상급 신의 권능: 보호막 효과를 얻었을 때 알림",

	spellshield = "주문 보호막",
	spellshield_desc = "크로쉬가 주문 보호막 효과를 얻었을 때 알림",

	summon = "사나운 지옥사냥개 소환",
	summon_desc = "울름이 지옥사냥개 소환 시전 시 경고",

	whirlwind = "소용돌이",
	whirlwind_desc = "마울가르가 소용돌이 효과를 얻었을 때 알림",

	flurry = "질풍",
	flurry_desc = "마울가르의 질풍 효과 근접 및 획득 시 경고",

	heal_trigger = "현자 블라인드아이|1이;가; 치유 시전을 시작합니다.",
	heal_message = "블라인드아이 치유 시전!",
	heal_bar = "치유",

	shield_trigger = "상급 신의 권능: 보호막 효과를 얻었습니다.", -- check
	shield_message = "블라인드아이 보호막!",

	spellshield_trigger = "크로쉬 파이어핸드|1이;가; 주문 보호막 효과를 얻었습니다.",
	spellshield_message = "크로쉬 주문 보호막!",

	summon_trigger = "소환사 올름|1이;가; 사나운 지옥사냥개 소환 시전을 시작합니다.",
	summon_message = "지옥사냥개 소환!",

	flurry_trigger = "그룰님의 손아귀에서 벗어나지 못해!",
	flurry_message = "50% - 질풍!",
	flurry_warning = "잠시 후 질풍!",

	whirlwind_trigger = "왕중왕 마울가르|1이;가; 소용돌이 효과를 얻었습니다.",
	whirlwind_message = "마울가르 - 15초간 소용돌이!",
	whirlwind_bar = "소용돌이",
	whirlwind_nextbar = "~다음 소용돌이",
	whirlwind_warning1 = "마울가르 전투 개시 - 약 50초 후 소용돌이!",
	whirlwind_warning2 = "잠시 후 소용돌이!",
} end)

----------------------------------
--   Module Declaration    --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Gruul's Lair"]
mod.otherMenu = "Outland"
mod.enabletrigger = boss
mod.toggleoptions = {"shield", "spellshield", "summon", "whirlwind", "heal", "flurry", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	started = nil
	flurryannounced = nil

	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "BlindeyeHeal", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "BlindeyePOH", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "BlindeyeShield", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "KroshSpellShield", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MaulgarWhirldwind", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "OlmSummon", 5)
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if self.db.profile.heal and msg:find(L["heal_trigger"]) then
		self:Sync("BlindeyePrayer")
	elseif self.db.profile.summon and msg:find(L["summon_trigger"]) then
		self:Sync("OlmSummon")
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if self.db.profile.shield and msg:find(L["shield_trigger"]) then
		self:Sync("BlindeyeShield")
	elseif self.db.profile.spellshield and msg:find(L["spellshield_trigger"]) then
		self:Sync("KroshSpellShield")
	elseif self.db.profile.whirlwind and msg:find(L["whirlwind_trigger"]) then
		self:Sync("MaulgarWhirldwind")
	end
end

function mod:BigWigs_RecvSync( sync, rest, nick )
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.whirlwind then
			self:Message(L["whirlwind_warning1"], "Attention")
			self:Nextwhirldwind()
		end
	elseif sync == "BlindeyePrayer" then
		self:Message(L["heal_message"], "Important", nil, "Alarm")
	elseif sync == "BlindeyeShield" then
		self:Message(L["shield_message"], "Important")
	elseif sync == "KroshSpellShield" then
		self:Message(L["spellshield_message"], "Attention", nil, "Info")
	elseif sync == "OlmSummon" then
		self:Message(L["summon_message"], "Attention", nil, "Long")
	elseif sync == "MaulgarWhirldwind" then
		self:Message(L["whirlwind_message"], "Important")
		self:Bar(L["whirlwind_bar"], 15, "Ability_Whirlwind")
		self:Nextwhirldwind()
	end
end

function mod:Nextwhirldwind()
	self:DelayedMessage(45, L["whirlwind_warning2"], "Urgent")
	self:Bar(L["whirlwind_nextbar"], 50, "Ability_Whirlwind")
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.flurry and msg:find(L["flurry_trigger"]) then
		self:Message(L["flurry_message"], "Important")
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
