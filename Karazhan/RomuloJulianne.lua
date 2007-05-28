------------------------------
--      Are you local?      --
------------------------------

local BB = AceLibrary("Babble-Boss-2.2")

local boss = BB["Romulo & Julianne"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local boy = BB["Romulo"]
local girl = BB["Julianne"]

BB = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "RomuloJulianne",

	phase = "Phases",
	phase_desc = "Warn when entering a new Phase.",
	phase1_trigger = "What devil art thou, that dost torment me thus?",
	phase1_message = "Act I - %s",
	phase2_trigger = "Wilt thou provoke me? Then have at thee, boy!",
	phase2_message = "Act II - %s",
	phase3_trigger = "Come, gentle night; and give me back my Romulo!",
	phase3_message = "Act III - Both",

	poison = "Poison",
	poison_desc = "Warn of a poisoned player.",
	poison_trigger = "^([^%s]+) ([^%s]+) afflicted by Poisoned Thrust.$",
	poison_message = "Poisoned: %s",

	heal = "Heal",
	heal_desc = ("Warn when %s casts Eternal Affection."):format(girl),
	heal_trigger = "begins to cast Eternal Affection",
	heal_message = "%s casting Heal!",

	buff = "Self-Buff Alert",
	buff_desc = ("Warn when %s and %s gain a self-buff."):format(boy, girl),
	buff1_trigger = "gains Daring",
	buff1_message = "%s gains Daring!",
	buff2_trigger = "gains Devotion",
	buff2_message = "%s gains Devotion!",
} end)

L:RegisterTranslations("deDE", function() return {
	phase = "Phase",
	phase_desc = "Warnt wenn eine neue Phase beginnt",

	poison = "Gift",
	poison_desc = "Warnt vor vergifteten Spielern",

	heal = "Heilen",
	heal_desc = ("Warnt wenn %s sich heilt"):format(girl),

	buff = "Selbst-Buff Alarm",
	buff_desc = ("Warnt wenn %s und %s sich selbst buffen"):format(boy, girl),

	phase1_trigger = "Welch' Teufel bist du, dass du mich so folterst?",
	phase1_message = "Akt 1 - %s",
	phase2_trigger = "Willst du mich zwingen? Knabe, sieh dich vor!",
	phase2_message = "Akt 2 - %s",
	phase3_trigger = "Komm, milde, liebevolle Nacht! Komm, gibt mir meinen Romulo zur\195\188ck!",
	phase3_message = "Akt 3 - Beide",

	poison_trigger = "^([^%s]+) ([^%s]+) von Vergifteter Sto\195\159 betroffen.",
	poison_message = "Vergiftet: %s",

	heal_trigger = "beginnt Ewige Zuneigung zu wirken.",
	heal_message = "%s wirkt Heilung!",

	buff1_trigger = "bekommt 'Wagemutig'.",
	buff1_message = "%s bekommt Wagemut!",
	buff2_trigger = "bekommt 'Hingabe'.",
	buff2_message = "%s bekommt Hingabe!",
} end)

L:RegisterTranslations("frFR", function() return {
	phase = "Phases",
	phase_desc = "Pr\195\169viens quand la rencontre entre dans une nouvelle phase.",

	poison = "Poison",
	poison_desc = "Pr\195\169viens quand un joueur est empoisonn\195\169.",

	heal = "Soin",
	heal_desc = ("Pr\195\169viens quand %s lance Amour \195\169ternel."):format(girl),

	buff = "Buff",
	buff_desc = ("Pr\195\169viens quand %s et %s gagnent leurs buffs."):format(boy, girl),

	phase1_trigger = "Quel d\195\169mon es-tu pour me tourmenter ainsi?",
 	phase1_message = "Acte I - %s",
	phase2_trigger = "Tu veux donc me provoquer ? Eh bien, \195\160 toi, enfant.",
 	phase2_message = "Acte II - %s",
	phase3_trigger = "Viens, gentille nuit ; rends-moi mon Romulo !",
	phase3_message = "Acte III - Ensemble",

	poison_trigger = "^([^%s]+) ([^%s]+) les effets .* Coup empoisonn\195\169",
	poison_message = "Empoisonn\195\169 : %s",

	heal_trigger = "commence \195\160 lancer Amour \195\169ternel%.",
	heal_message = "%s incante un soin !",

	buff1_trigger = "gagne Hardiesse",
	buff1_message = "Romulo gagne Hardiesse !",
	buff2_trigger = "gagne D\195\169votion",
	buff2_message = "Julianne gagne D\195\169votion !",
} end)

L:RegisterTranslations("koKR", function() return {
	phase = "단계",
	phase_desc = "새로운 단계 전입 시 알림",

	poison = "독",
	poison_desc = "독에 걸린 플레이어 알림",

	heal = "치유",
	heal_desc = ("%s|1이;가; 영원한 사랑 시전 시 경고"):format(girl),

	buff = "버프 알림",
	buff_desc = ("%s|1와;과; %s 버프 획득 시 알림"):format(boy, girl),

	phase1_trigger = "당신들은 대체 누구시기에 절 이리도 괴롭히나요?",
	phase1_message = "1 단계 - %s",
	phase2_trigger = "기어코 나를 화나게 하는구나. 그렇다면 받아라, 애송이!",
	phase2_message = "2 단계 - %s",
	phase3_trigger = "정다운 밤이시여, 어서 와서 나의 로밀로를 돌려주소서!",
	phase3_message = "3 단계 - 모두",

	poison_trigger = "^([^|;%s]*)(.*)독칼 찌르기에 걸렸습니다%.$", -- check
	poison_message = "중독: %s",

	heal_trigger = "영원한 사랑 시전을 시작합니다.",
	heal_message = "%s 힐 시전 중!",

	buff1_trigger = "사랑의 용기 효과를 얻었습니다.", -- check
	buff1_message = "%s 사랑의 용기 효과 얻음!",
	buff2_trigger = "헌신 효과를 얻었습니다.", -- check
	buff2_message = "%s 헌신 효과 얻음!",
} end)

L:RegisterTranslations("zhTW", function() return {
	phase = "階段警告",
	phase_desc = "當進入下一階段時警告",

	poison = "中毒警告",
	poison_desc = "當隊友中毒時警告",

	heal = "治療警告",
	heal_desc = ("當 %s 施放永恆的影響時警告"):format(girl),

	buff = "自身 Buff 警告",
	buff_desc = ("當 %s 與 %s 獲得狗男女強化時警告"):format(boy, girl),

	phase1_trigger = "你是什麼樣的惡魔，讓我這樣的痛苦?",
	phase1_message = "第一章 - %s 出現！",
	phase2_trigger = "你想挑釁我嗎?下一個就輪到你了，小子!",
	phase2_message = "第二章 - %s 出現！",
	phase3_trigger = "來吧，溫和的夜晚；把我的羅慕歐還給我!",
	phase3_message = "第三章 - 狗男女閃光！",

	poison_trigger = "^(.+)受到(.*)毒勁",
	poison_message = "中毒：[%s]",

	heal_trigger = "開始施放永恆的影響",
	heal_message = "%s 施放治療！",

	buff1_trigger = "獲得了虔誠的效果。",
	buff1_message = "%s 獲得虔誠效果！",
	buff2_trigger = "獲得了膽量的效果。",
	buff2_message = "%s 獲得膽量效果！",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
mod.enabletrigger = {boy, girl}
mod.toggleoptions = {"phase", "heal", "buff", "poison"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "PoisonEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "PoisonEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "PoisonEvent")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if not self.db.profile.phase then return end
	if msg == L["phase1_trigger"] then
		self:Message(L["phase1_message"]:format(girl), "Attention")
	elseif msg == L["phase2_trigger"] then
		self:Message(L["phase2_message"]:format(boy), "Attention")
	elseif msg == L["phase3_trigger"] then
		self:Message(L["phase3_message"], "Attention")
	end
end

function mod:PoisonEvent(msg)
	local pplayer, ptype = select(3, msg:find(L["poison_trigger"]))
	if pplayer and ptype then
		if pplayer == L2["you"] and ptype == L2["are"] then
			pplayer = UnitName("player")
		end
		if self.db.profile.poison then
			self:Message(L["poison_message"]:format(pplayer), "Important")
		end
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if self.db.profile.heal and msg:find(L["heal_trigger"]) then
		self:Message(L["heal_message"]:format(girl), "Urgent")
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if not self.db.profile.buff then return end
	if msg:find(L["buff1_trigger"]) then
		self:Message(L["buff1_message"]:format(boy), "Attention")
	elseif msg:find(L["buff2_trigger"]) then
		self:Message(L["buff2_message"]:format(girl), "Attention")
	end
end
