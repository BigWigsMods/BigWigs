------------------------------
--      Are you local?      --
------------------------------

local BB = AceLibrary("Babble-Boss-2.2")
local suffering = BB["Essence of Suffering"]
local desire = BB["Essence of Desire"]
local anger = BB["Essence of Anger"]
local boss = BB["Reliquary of Souls"]
BB = nil

local spiteIt = {}
local pName = nil
local stop = nil

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local death = AceLibrary("AceLocale-2.2"):new("BigWigs")["%s has been defeated"]:format(boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "ReliquaryOfSouls",

	engage_trigger = "Pain and suffering are all that await you!",

	enrage_start = "Enrage in ~47sec",
	enrage_trigger = "%s becomes enraged!",
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
	runeshield_trigger = "Essence of Desire gains Rune Shield.",
	runeshield_message = "Rune Shield!",
	runeshield_nextbar = "Next Rune Shield",
	runeshield_warn = "Rune Shield in ~3sec.",

	deaden = "Deaden",
	deaden_desc = "Warns you when Deaden is being cast.",
	deaden_trigger = "Essence of Desire begins to cast Deaden.",
	deaden_message = "Casting Deaden!",
	deaden_warn = "Deaden in ~5sec.",
	deaden_nextbar = "Next Deaden.",

	spite = "Spite",
	spite_desc = "Warn who has Spite.",
	spite_message = "Spite: %s",

	scream = "Soul Scream",
	scream_desc = "Show a cooldown bar for Soul Scream.",
	scream_trigger = "^Essence of Anger 's Soul Scream ",
	scream_bar = "~Soul Scream Cooldown",

	afflict_trigger = "^(%S+) (%S+) afflicted by (.*).$",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "너희를 기다리는 건 고통과 슬픔뿐이야!",

	enrage_start = "약 47초 후 격노",
	enrage_trigger = "%s|1이;가; 분노에 휩싸입니다!",
	enrage_message = "15초 동안 격노!",
	enrage_bar = "<격노>",
	enrage_next = "격노 종료 - 다음은 약 32초 후",
	enrage_nextbar = "다음 격노",
	enrage_warning = "5초 후 격노!",

	desire_trigger  = "선택은 자유지만... 대가는 치러야 하는 법.",
	desire_cot = "Kanrethad Zennshinagas Zilthuras Teamanare Revola Asj", --Curse of Tongues trigger
	desire_start = "욕망의 정수 - 160초 후 마나 0",
	desire_bar = "마나 0",
	desire_warn = "30초 후 마나 0!",

	runeshield = "룬 보호막",
	runeshield_desc = "욕망의 정수가 룬 보호막을 얻을 떄에 대한 타이머 입니다.",
	runeshield_trigger = "욕망의 정수|1이;가; 룬 보호막 효과를 얻었습니다.",
	runeshield_message = "룬 보호막!",
	runeshield_nextbar = "다음 룬 보호막",
	runeshield_warn = "약 3초 후 룬 보호막",

	deaden = "쇠약",
	deaden_desc = "쇠약 시전 시 알립니다.",
	deaden_trigger = "욕망의 정수|1이;가; 쇠약 시전을 시작합니다.",
	deaden_message = "쇠약 시전!",
	deaden_warn = "약 5초 후 쇠약!",
	deaden_nextbar = "다음 쇠약",

	spite = "원한",
	spite_desc = "원한에 걸린 대상을 알립니다.",
	spite_message = "원한: %s",

	scream = "영혼의 절규",
	scream_desc = "영혼의 절규 재사용 시간을 표시합니다.",
	scream_trigger = "^격노의 정수|1이;가; 영혼의 절규|1으로;로;", -- check
	scream_bar = "~영혼의 절규 재사용 시간",

	afflict_trigger = "^([^|;%s]*)(%s+)(.*)에 걸렸습니다%.$", -- Check
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Douleur et souffrance, voilà tout ce qui vous attend !",

	enrage_start = "Enrager dans ~47 sec.",
	enrage_trigger = "%s devient fou furieux !",
	enrage_message = "Enragé pendant 15 sec. !",
	enrage_bar = "<Enragé>",
	enrage_next = "Fin de l'Enrager - Prochain dans ~32 sec.",
	enrage_nextbar = "Prochain Enrager",
	enrage_warning = "Enrager dans 5 sec. !",

	desire_trigger  = "Vous pouvez avoir tout ce que vous désirez... en y mettant le prix.",
	desire_cot = "Maev revola refir veni re daz maev azrathu il o kieldaz no veni ", --Curse of Tongues trigger
	desire_start = "Essence du désir - Zéro mana dans 160 sec.",
	desire_bar = "Zéro mana",
	desire_warn = "Zéro mana dans 30 sec. !",

	runeshield = "Bouclier runique",
	runeshield_desc = "Délais concernant le Bouclier runique de l'Essence du désir.",
	runeshield_trigger = "Essence du désir gagne Bouclier runique.",
	runeshield_message = "Bouclier runique !",
	runeshield_nextbar = "Prochain Bouclier runique",
	runeshield_warn = "Bouclier runique dans ~3 sec.",

	deaden = "Emousser",
	deaden_desc = "Préviens quand Emousser est incanté.",
	deaden_trigger = "Essence du désir commence à lancer Emousser.",
	deaden_message = "Emousser en incantation !",
	deaden_warn = "Emousser dans ~5 sec.",
	deaden_nextbar = "Prochain Emousser",

	spite = "Dépit",
	spite_desc = "Préviens quand un joueur subit les effets du Dépit.",
	spite_message = "Dépit : %s",

	scream = "Cri de l'âme",
	scream_desc = "Affiche une barre de cooldown pour le Cri de l'âme.",
	scream_trigger = "^Cri de l'âme .* Essence de la colère ",
	scream_bar = "~Cooldown Cri de l'âme",

	afflict_trigger = "^(%S+) (%S+) les effets [de|2]+ (.*).$",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Auf Euch warten nur Schmerz und Leid!",

	enrage_start = "Wutanfall in ~47sec",
	enrage_trigger = "%s wird wütend!",
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
	runeshield_trigger = "Essenz der Begierde bekommt Runenschild.",
	runeshield_message = "Runenschild!",
	runeshield_nextbar = "Nächstes Runenschild",
	runeshield_warn = "Runenschild in ~3sek.",

	deaden = "Abstumpfen",
	deaden_desc = "Warnt dich wenn Abstumpfen gezaubert wird.",
	deaden_trigger = "Essenz der Begierde beginnt Abstumpfen zu wirken.",
	deaden_message = "Zaubert Abstumpfen!",
	deaden_warn = "Abstumpfen in ~5sek.",
	deaden_nextbar = "Nächstes Abstumpfen.",

	spite = "Bosheit",
	spite_desc = "Warnt wer Bosheit hat.",
	spite_message = "Bosheit: %s",

	scream = "Seelenschrei",
	scream_desc = "Zeige eine Cooldownleiste für Seelenschrei.",
	scream_trigger = "^Essenz des Zorns 's Seelenschrei ",
	scream_bar = "~Seelenschrei Cooldown",

	afflict_trigger = "^([^%s]+) ([^%s]+) ist von (.*) betroffen.$",
} end )

--Reliquary of Souls check
L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "等待你们的只有痛苦与折磨！",

	enrage_start = "~47秒后 激怒",
	enrage_trigger = "%s变得愤怒了！",
	enrage_message = "愤怒 15秒!",
	enrage_bar = "<愤怒>",
	enrage_next = "愤怒结束 - ~32秒后再次发动",
	enrage_nextbar = "下一 愤怒",
	enrage_warning = "5秒后 愤怒!",

	desire_trigger  = "你可以获得任何你想要的东西……只要付得起代价。",
	desire_cot = "Shi shi rikk rukadare shi tichar kar x gular ", --Curse of Tongues trigger
	desire_start = "欲望精华 - 160秒后 零法力",
	desire_bar = "零法力",
	desire_warn = "30秒后 零法力!",

	runeshield = "符文护盾",
	runeshield_desc = "欲望精华获得了符文护盾计时",
	runeshield_trigger = "欲望精华获得了符文护盾的效果。",
	runeshield_message = "符文护盾!",
	runeshield_nextbar = "下个 符文护盾",
	runeshield_warn = "3秒后 符文护盾.",

	deaden = "衰减",
	deaden_desc = "当衰减施放时发出警报",
	deaden_trigger = "欲望精华开始施放衰减。",
	deaden_message = "正施放 衰减!",
	deaden_warn = "~5秒后 衰减.",
	deaden_nextbar = "下一 衰减.",

	spite = "敌意",
	spite_desc = "当谁中了敌意发出警报",
	spite_message = "敌意: %s",

	scream = "灵魂尖啸",
	scream_desc = "显示灵魂尖啸冷却记时条",
	scream_trigger = "^愤怒精华的灵魂尖啸",
	scream_bar = "~灵魂尖啸 冷却",

	afflict_trigger = "^(%S+)受(%S+)了(.*)效果的影响。$",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "等待你們的只有痛苦與折磨﹗",

	enrage_start = "憤怒在 ~47sec",
	enrage_trigger = "受難精華變得憤怒了!",
	enrage_message = "憤怒 15 秒!",
	enrage_bar = "<憤怒>",
	enrage_next = "憤怒結束 - 下一次 ~32秒",
	enrage_nextbar = "下一次憤怒",
	enrage_warning = "憤怒在 5 秒內!",

	desire_trigger  = "你可以得到任何你想要的東西……只要付得起代價。",
	desire_cot = "[惡魔語] Zennshinagas", -- 語言詛咒觸發
	desire_start = "慾望精華 - 160 秒內沒魔",
	desire_bar = "沒魔",
	desire_warn = "30 秒內沒魔!",

	runeshield = "符文護盾",
	runeshield_desc = "慾望精華將獲得符文護盾計時條",
	runeshield_trigger = "慾望精華獲得了符文護盾",
	runeshield_message = "符文護盾!",
	runeshield_nextbar = "下一次符文護盾",
	runeshield_warn = "符文護盾 ~3秒內.",

	deaden = "麻木",
	deaden_desc = "當麻木開始施放時警告",
	deaden_trigger = "慾望精華開始施放麻木。",
	deaden_message = "正在施放麻木!",
	deaden_warn = "麻木 ~5秒內.",
	deaden_nextbar = "下一次麻木",

	spite = "惡意",
	spite_desc = "警告誰有惡意",
	spite_message = "惡意: %s",

	scream = "靈魂尖嘯",
	scream_desc = "顯示靈魂尖嘯冷卻條",
	scream_trigger = "^憤怒精華的靈魂尖嘯",
	scream_bar = "~靈魂尖嘯冷卻",

	afflict_trigger = "^(.+)受([到了]*)(.*)效果的影響。$",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = {desire, suffering, anger}
mod.toggleoptions = {"enrage", "drain", -1, "runeshield", "deaden", -1, "spite", "scream", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "AfflictEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "AfflictEvent")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "RoSDrain", 300)
	self:TriggerEvent("BigWigs_ThrottleSync", "RoSSpite", 0)
	self:TriggerEvent("BigWigs_ThrottleSync", "RoSShield", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "RoSWin", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "RoSDeaden", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "RoSScream", 4)
	pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		for k in pairs(spiteIt) do spiteIt[k] = nil end
		stop = nil
		if self.db.profile.enrage then
			self:Message(L["enrage_start"], "Positive")
			self:Bar(L["enrage_nextbar"], 47, "Spell_Shadow_UnholyFrenzy")
			self:DelayedMessage(42, L["enrage_warning"], "Urgent")
		end
	elseif msg == L["desire_trigger"] or msg == L["desire_cot"] then
		if self.db.profile.enrage then
			self:Message(L["desire_start"], "Positive")
			self:Bar(L["desire_bar"], 160, "Spell_Shadow_UnholyFrenzy")
			self:DelayedMessage(130, L["desire_warn"], "Urgent")
		end
		if self.db.profile.deaden then
			self:Bar(L["deaden_nextbar"], 28, "Spell_Shadow_SoulLeech_1")
			self:DelayedMessage(23, L["deaden_warn"], "Urgent")
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["enrage_trigger"] and self.db.profile.enrage then
		self:Message(L["enrage_message"], "Attention", nil, "Alert")
		self:Bar(L["enrage_bar"], 15, "Spell_Shadow_UnholyFrenzy")
		self:DelayedMessage(15, L["enrage_next"], "Attention")
		self:DelayedMessage(42, L["enrage_warning"], "Urgent")
		self:Bar(L["enrage_nextbar"], 47, "Spell_Shadow_UnholyFrenzy")
	end
end

function mod:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == UNITDIESOTHER:format(anger) then
		self:Sync("RoSWin")
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["runeshield_trigger"] then
		self:Sync("RoSShield")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["deaden_trigger"] then
		self:Sync("RoSDeaden")
	elseif msg:find(L["scream_trigger"]) then
		self:Sync("RoSScream")
	end
end

function mod:AfflictEvent(msg)
	local aPlayer, aType, aSpell = select(3, msg:find(L["afflict_trigger"]))
	if aPlayer and aType then
		if aPlayer == L2["you"] and aType == L2["are"] then
			aPlayer = pName
		end
		if aSpell == L["spite"] then
			self:Sync("RoSSpite "..aPlayer)
		end
	end
end

local function nilStop()
	stop = nil
	for k in pairs(spiteIt) do spiteIt[k] = nil end
end

function mod:SpiteWarn()
	if stop then return end
	if self.db.profile.spite then
		local msg = nil
		for k in pairs(spiteIt) do
			if not msg then
				msg = k
			else
				msg = msg .. ", " .. k
			end
		end
		self:Message(L["spite_message"]:format(msg), "Important", nil, "Alert")
	end
	stop = true
	self:ScheduleEvent("BWRoSNilStop", nilStop, 4)
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "RoSSpite" and not stop and rest then
		spiteIt[rest] = true
		self:ScheduleEvent("BWSpiteWarn", self.SpiteWarn, 0.3, self)
	elseif sync == "RoSShield" and self.db.profile.runeshield then
		self:Message(L["runeshield_message"], "Attention")
		self:Bar(L["runeshield_nextbar"], 15, "Spell_Arcane_Blast")
		self:DelayedMessage(12, L["runeshield_warn"], "Urgent")
	elseif sync == "RoSWin" and self.db.profile.bosskill then
		self:Message(death, "Bosskill", nil, "Victory")
		BigWigs:ToggleModuleActive(self, false)
	elseif sync == "RoSDeaden" and self.db.profile.deaden then
		self:Message(L["deaden_message"], "Attention")
		self:Bar(L["deaden_nextbar"], 30, "Spell_Shadow_SoulLeech_1")
		self:DelayedMessage(25, L["deaden_warn"], "Urgent")
	elseif sync == "RoSScream" and self.db.profile.scream then
		self:Bar(L["scream_bar"], 10, "Spell_Shadow_ConeOfSilence")
	end
end
