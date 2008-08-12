------------------------------
--      Are you local?      --
------------------------------

local suffering = BB["Essence of Suffering"]
local desire = BB["Essence of Desire"]
local anger = BB["Essence of Anger"]
local boss = BB["Reliquary of Souls"]

local spiteIt = {}
local db = nil
local pName = UnitName("player")
local stop = nil

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "ReliquaryOfSouls",

	engage_trigger = "Pain and suffering are all that await you!",

	enrage_start = "Enrage in ~47sec",
	enrage_message = "Enraged for 15sec!",
	enrage_bar = "<Enraged>",
	enrage_next = "Enrage Over - Next in ~32sec",
	enrage_nextbar = "Next Enrage",
	enrage_warning = "Enrage in 5 sec!",

	desire_trigger  = "You can have anything you desire... for a price.",
	desire_cot = "Shi shi rikk rukadare shi tichar kar x gular ", --Curse of Tongues trigger
	desire_start = "Essence of Desire - Zero mana in 160 sec",
	desire_bar = "Zero Mana",
	desire_warn = "Zero Mana in 30sec!",

	runeshield = "Rune Shield",
	runeshield_desc = "Timers for when Essence of Desire will gain rune shield.",
	runeshield_message = "Rune Shield!",
	runeshield_nextbar = "Next Rune Shield",
	runeshield_warn = "Rune Shield in ~3sec.",

	deaden = "Deaden",
	deaden_desc = "Warns you when Deaden is being cast.",
	deaden_message = "Casting Deaden!",
	deaden_warn = "Deaden in ~5sec.",
	deaden_nextbar = "Next Deaden.",

	spite = "Spite",
	spite_desc = "Warn who has Spite.",
	spite_message = "Spite on %s",

	scream = "Soul Scream",
	scream_desc = "Show a cooldown bar for Soul Scream.",
	scream_bar = "~Soul Scream Cooldown",
} end )

L:RegisterTranslations("esES", function() return {
	engage_trigger = "¡Solo os esperan dolor y sufrimiento!",

	enrage_start = "Enfurecer en ~47 seg",
	enrage_message = "¡Enfurecido durante 15 seg!",
	enrage_bar = "<Enfurecido>",
	enrage_next = "Fin Enfurecer - Sig. en ~32 seg",
	enrage_nextbar = "Siguiente Enfurecer",
	enrage_warning = "¡Enfurecer en 5 seg!",

	desire_trigger  = "Puedes tener todo lo que desees... pagando su precio.",
	desire_cot = "Shi shi rikk rukadare shi tichar kar x gular ", --Curse of Tongues trigger
	desire_start = "Esencia de Deseo - Sin maná en 160 seg",
	desire_bar = "Sin maná",
	desire_warn = "¡Sin maná en 30 seg!",

	runeshield = "Escudo de runa (Rune Shield)",
	runeshield_desc = "Contadores para saber cuándo Esencia de Deseo ganará Escudo de runa.",
	runeshield_message = "¡Escudo de runa!",
	runeshield_nextbar = "~Escudo de runa",
	runeshield_warn = "Escudo de runa en ~3 seg",

	deaden = "Embotado (Deaden)",
	deaden_desc = "Avisar cuando se va a lanzar Embotado.",
	deaden_message = "¡Lanzando Embotado!",
	deaden_warn = "Embotado en ~5 seg.",
	deaden_nextbar = "~Embotado.",

	spite = "Maldad (Spite)",
	spite_desc = "Avisar quién tiene Maldad.",
	spite_message = "Maldad en %s",

	scream = "Alarido del alma (Soul Scream)",
	scream_desc = "Mostrar una barra de reutilización de Alarido del alma.",
	scream_bar = "~Alarido del alma",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "너희를 기다리는 건 고통과 슬픔뿐이야!",

	enrage_start = "고뇌의 정수 - 약 47초 후 격노",
	enrage_message = "15초 동안 격노!",
	enrage_bar = "<격노>",
	enrage_next = "격노 종료 - 다음은 약 32초 후",
	enrage_nextbar = "다음 격노",
	enrage_warning = "5초 후 격노!",

	desire_trigger  = "선택은 자유지만... 대가는 치러야 하는 법.",
	desire_cot = "[악마어] Kanrethad Zennshinagas Zilthuras Teamanare Revola Asj", --Curse of Tongues trigger
	desire_start = "욕망의 정수 - 160초 후 마나 0",
	desire_bar = "마나 0",
	desire_warn = "30초 후 마나 0!",

	runeshield = "룬 보호막",
	runeshield_desc = "욕망의 정수가 룬 보호막 획득에 대한 타이머 입니다.",
	runeshield_message = "룬 보호막!",
	runeshield_nextbar = "다음 룬 보호막",
	runeshield_warn = "약 3초 후 룬 보호막",

	deaden = "쇠약",
	deaden_desc = "쇠약 시전 시 알립니다.",
	deaden_message = "쇠약 시전!",
	deaden_warn = "약 5초 후 쇠약!",
	deaden_nextbar = "다음 쇠약",

	spite = "원한",
	spite_desc = "원한에 걸린 대상을 알립니다.",
	spite_message = "원한: [%s]",

	scream = "영혼의 절규",
	scream_desc = "영혼의 절규 재사용 시간을 표시합니다.",
	scream_bar = "~영혼의 절규 재사용 시간",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Douleur et souffrance, voilà tout ce qui vous attend !",

	enrage_start = "Enrager dans ~47 sec.",
	enrage_message = "Enragé pendant 15 sec. !",
	enrage_bar = "<Enragé>",
	enrage_next = "Fin de l'Enrager - Prochain dans ~32 sec.",
	enrage_nextbar = "Prochain Enrager",
	enrage_warning = "Enrager dans 5 sec. !",

	desire_trigger = "Vous pouvez avoir tout ce que vous désirez... en y mettant le prix.",
	desire_cot = "Maev revola refir veni re daz maev azrathu il o kieldaz no veni ", --Curse of Tongues trigger
	desire_start = "Essence du désir - Zéro mana dans 160 sec.",
	desire_bar = "Zéro mana",
	desire_warn = "Zéro mana dans 30 sec. !",

	runeshield = "Bouclier runique",
	runeshield_desc = "Délais concernant le Bouclier runique de l'Essence du désir.",
	runeshield_message = "Bouclier runique !",
	runeshield_nextbar = "Prochain Bouclier runique",
	runeshield_warn = "Bouclier runique dans ~3 sec.",

	deaden = "Emousser",
	deaden_desc = "Prévient quand Emousser est incanté.",
	deaden_message = "Emousser en incantation !",
	deaden_warn = "Emousser dans ~5 sec.",
	deaden_nextbar = "Prochain Emousser",

	spite = "Dépit",
	spite_desc = "Prévient quand un joueur subit les effets du Dépit.",
	spite_message = "Dépit sur %s",

	scream = "Cri de l'âme",
	scream_desc = "Affiche une barre pour le temps de recharge du Cri de l'âme.",
	scream_bar = "~Recharge Cri de l'âme",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Auf Euch warten nur Schmerz und Leid!",

	enrage_start = "Wutanfall in ~47sec",
	enrage_message = "Wutanfall für 15sek!",
	enrage_bar = "<Wutanfall>",
	enrage_next = "Wutanfall Vorbei - Nächster in ~32sec",
	enrage_nextbar = "Nächster Wutanfall",
	enrage_warning = "Wutanfall in 5 sek!",

	desire_trigger  = "Ihr könnt alles haben, was Ihr wollt... doch es hat einen Preis.",
	desire_cot = "Maz archim zekul refir daz Maz soran maez me ruk buras Zekul", --Curse of Tongues trigger
	desire_start = "Essenz der Begierde - Null Mana in 160 sek",
	desire_bar = "Null Mana",
	desire_warn = "Null Mana in 30sek!",

	runeshield = "Runenschild",
	runeshield_desc = "Timer wann Essenz der Begierde das Runenschild bekommen wird.",
	runeshield_message = "Runenschild!",
	runeshield_nextbar = "Nächstes Runenschild",
	runeshield_warn = "Runenschild in ~3sek.",

	deaden = "Abstumpfen",
	deaden_desc = "Warnt dich wenn Abstumpfen gezaubert wird.",
	deaden_message = "Zaubert Abstumpfen!",
	deaden_warn = "Abstumpfen in ~5sek.",
	deaden_nextbar = "Nächstes Abstumpfen.",

	spite = "Bosheit",
	spite_desc = "Warnt wer Bosheit hat.",
	spite_message = "Bosheit: [%s]",

	scream = "Seelenschrei",
	scream_desc = "Zeige eine Cooldownleiste für Seelenschrei.",
	scream_bar = "~Seelenschrei Cooldown",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "等待你们的只有痛苦与折磨！",

	enrage_start = "约47秒后，激怒！",
	enrage_message = "愤怒 15秒！",
	enrage_bar = "<愤怒>",
	enrage_next = "愤怒结束，约32秒后再次发动。",
	enrage_nextbar = "<下一愤怒>",
	enrage_warning = "5秒后，愤怒！",

	desire_trigger  = "你可以获得任何你想要的东西……只要付得起代价。",
	desire_cot = "Shi shi rikk rukadare shi tichar kar x gular", --Curse of Tongues trigger
	desire_start = "欲望精华！160秒后零法力。",
	desire_bar = "<零法力>",
	desire_warn = "30秒后，零法力！",

	runeshield = "符文护盾",
	runeshield_desc = "欲望精华获得了符文护盾计时。",
	runeshield_message = "符文护盾！",
	runeshield_nextbar = "<下一符文护盾>",
	runeshield_warn = "3秒后，符文护盾！",

	deaden = "衰减",
	deaden_desc = "当施放衰减施放时发出警报。",
	deaden_message = "正在施放 衰减！",
	deaden_warn = "约5秒后，衰减！",
	deaden_nextbar = "<下一衰减>",

	spite = "敌意",
	spite_desc = "当玩家受到敌意时发出警报。",
	spite_message = "敌意：>%s<！",

	scream = "灵魂尖啸",
	scream_desc = "显示灵魂尖啸冷却记时条。",
	scream_bar = "<灵魂尖啸 冷却>",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "等待你們的只有痛苦與折磨﹗",

	enrage_start = "約 47 秒後憤怒!",
	enrage_message = "憤怒! 持續 15 秒!",
	enrage_bar = "<憤怒>",
	enrage_next = "憤怒結束 - 約 32 秒後下一次!",
	enrage_nextbar = "<下一次憤怒>",
	enrage_warning = "約 5 秒內憤怒!",

	desire_trigger  = "你可以得到任何你想要的東西……只要付得起代價。",
	desire_cot = "[惡魔語] Zennshinagas", -- 語言詛咒觸發
	desire_start = "慾望精華 - 160 秒內沒魔",
	desire_bar = "<沒魔>",
	desire_warn = "30 秒內沒魔!",

	runeshield = "符文護盾",
	runeshield_desc = "慾望精華將獲得符文護盾計時條",
	runeshield_message = "符文護盾!",
	runeshield_nextbar = "下一次符文護盾",
	runeshield_warn = "3 秒內符文護盾",

	deaden = "麻木",
	deaden_desc = "當麻木開始施放時警報",
	deaden_message = "正在施放麻木!",
	deaden_warn = "約 5 秒內施放麻木",
	deaden_nextbar = "<下一次麻木>",

	spite = "惡意",
	spite_desc = "警告誰中了惡意",
	spite_message = "惡意: [%s]",

	scream = "靈魂尖嘯",
	scream_desc = "顯示靈魂尖嘯冷卻條",
	scream_bar = "<靈魂尖嘯冷卻>",
} end )

L:RegisterTranslations("ruRU", function() return {
	engage_trigger = "Лишь боль и страдания ждут тебя!",

	enrage_start = "Enrage in ~47sec",
	enrage_message = "Enraged for 15sec!",
	enrage_bar = "<Enraged>",
	enrage_next = "Enrage Over - Next in ~32sec",
	enrage_nextbar = "Next Enrage",
	enrage_warning = "Enrage in 5 sec!",

	desire_trigger  = "Можешь взять все, что желаешь… но не даром.",
	desire_cot = "Zennshinagas r buras zennshin ", --Curse of Tongues trigger
	desire_start = "Essence of Desire - Zero mana in 160 sec",
	desire_bar = "Zero Mana",
	desire_warn = "Zero Mana in 30sec!",

	runeshield = "Rune Shield",
	runeshield_desc = "Timers for when Essence of Desire will gain rune shield.",
	runeshield_message = "Rune Shield!",
	runeshield_nextbar = "Next Rune Shield",
	runeshield_warn = "Rune Shield in ~3sec.",

	deaden = "Deaden",
	deaden_desc = "Warns you when Deaden is being cast.",
	deaden_message = "Casting Deaden!",
	deaden_warn = "Deaden in ~5sec.",
	deaden_nextbar = "Next Deaden.",

	spite = "Spite",
	spite_desc = "Warn who has Spite.",
	spite_message = "Spite on %s",

	scream = "Soul Scream",
	scream_desc = "Show a cooldown bar for Soul Scream.",
	scream_bar = "~Soul Scream Cooldown",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Black Temple"]
mod.enabletrigger = {desire, suffering, anger}
mod.guid = 23420
mod.toggleoptions = {"enrage", "runeshield", "deaden", -1, "spite", "scream", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Spite", 41376, 41377)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Enrage", 41305)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Shield", 41431)
	self:AddCombatListener("SPELL_CAST_START", "Deaden", 41410)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Scream", 41545)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Spite(player)
	if db.spite then
		spiteIt[player] = true
		self:ScheduleEvent("BWSpiteWarn", self.SpiteWarn, 0.3, self)
	end
end

function mod:Enrage(_, spellID)
	if db.enrage then
		self:IfMessage(L["enrage_message"], "Attention", spellID, "Alert")
		self:Bar(L["enrage_bar"], 15, spellID)
		self:DelayedMessage(15, L["enrage_next"], "Attention")
		self:DelayedMessage(42, L["enrage_warning"], "Urgent")
		self:Bar(L["enrage_nextbar"], 47, spellID)
	end
end

function mod:Shield(_, spellID)
	if db.runeshield then
		self:IfMessage(L["runeshield_message"], "Attention", spellID)
		self:Bar(L["runeshield_nextbar"], 15, spellID)
		self:DelayedMessage(12, L["runeshield_warn"], "Urgent")
	end
end

function mod:Deaden(_, spellID)
	if db.deaden then
		self:Message(L["deaden_message"], "Attention", spellID)
		self:Bar(L["deaden_nextbar"], 30, spellID)
		self:DelayedMessage(25, L["deaden_warn"], "Urgent")
	end
end

function mod:Scream()
	if db.scream then
		self:Bar(L["scream_bar"], 10, 41545)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		for k in pairs(spiteIt) do spiteIt[k] = nil end
		stop = nil
		if db.enrage then
			self:Message(L["enrage_start"], "Positive")
			self:Bar(L["enrage_nextbar"], 47, "Spell_Shadow_UnholyFrenzy")
			self:DelayedMessage(42, L["enrage_warning"], "Urgent")
		end
	elseif msg == L["desire_trigger"] or msg == L["desire_cot"] then
		if db.enrage then
			self:Message(L["desire_start"], "Positive")
			self:Bar(L["desire_bar"], 160, "Spell_Shadow_UnholyFrenzy")
			self:DelayedMessage(130, L["desire_warn"], "Urgent")
		end
		if db.deaden then
			self:Bar(L["deaden_nextbar"], 28, "Spell_Shadow_SoulLeech_1")
			self:DelayedMessage(23, L["deaden_warn"], "Urgent")
		end
	end
end

function mod:SpiteWarn()
	local msg = nil
	for k in pairs(spiteIt) do
		if not msg then
			msg = k
		else
			msg = msg .. ", " .. k
		end
	end
	self:IfMessage(L["spite_message"]:format(msg), "Important", 41377, "Alert")
	for k in pairs(spiteIt) do spiteIt[k] = nil end
end

