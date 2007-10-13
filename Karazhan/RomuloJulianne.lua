------------------------------
--      Are you local?      --
------------------------------

local BB = AceLibrary("Babble-Boss-2.2")

local boss = BB["Romulo & Julianne"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local boy = BB["Romulo"]
local girl = BB["Julianne"]
local fmt = string.format

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
	poison_trigger = "^(%S+) (%S+) afflicted by Poisoned Thrust%.$",
	poison_message = "Poisoned: %s",

	heal = "Heal",
	heal_desc = "Warn when Julianne casts Eternal Affection.",
	heal_trigger = "begins to cast Eternal Affection%.$",
	heal_message = "%s casting Heal!",

	buff = "Self-Buff Alert",
	buff_desc = "Warn when Romulo & Julianne gain a self-buff.",
	buff1_trigger = "gains Daring%.$",
	buff1_message = "%s gains Daring!",
	buff2_trigger = "gains Devotion%.$",
	buff2_message = "%s gains Devotion!",
} end)

L:RegisterTranslations("deDE", function() return {
	phase = "Phase",
	phase_desc = "Warnt wenn eine neue Phase beginnt",

	poison = "Gift",
	poison_desc = "Warnt vor vergifteten Spielern",

	heal = "Heilen",
	heal_desc = "Warnt wenn Julianne sich heilt",

	buff = "Selbst-Buff Alarm",
	buff_desc = "Warnt wenn Romulo und Julianne sich selbst buffen",

	phase1_trigger = "Welch' Teufel bist du, dass du mich so folterst?",
	phase1_message = "Akt 1 - %s",
	phase2_trigger = "Willst du mich zwingen? Knabe, sieh dich vor!",
	phase2_message = "Akt 2 - %s",
	phase3_trigger = "Komm, milde, liebevolle Nacht! Komm, gibt mir meinen Romulo zur\195\188ck!",
	phase3_message = "Akt 3 - Beide",

	poison_trigger = "^([^%s]+) ([^%s]+) von Vergifteter Sto\195\159 betroffen%.$",
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
	phase_desc = "Préviens quand la rencontre entre dans une nouvelle phase.",
	phase1_trigger = "Quel démon es-tu pour me tourmenter ainsi ?",
 	phase1_message = "Acte I - %s",
	phase2_trigger = "Tu veux donc me provoquer ? Eh bien, à toi, enfant.",
 	phase2_message = "Acte II - %s",
	phase3_trigger = "Viens, gentille nuit ; rends-moi mon Romulo !",
	phase3_message = "Acte III - Les deux",

	poison = "Poison",
	poison_desc = "Préviens quand un joueur est empoisonné.",
	poison_trigger = "^(%S+) (%S+) les effets .* Coup empoisonné%.$",
	poison_message = "Empoisonné : %s",

	heal = "Soin",
	heal_desc = "Préviens quand Julianne lance Amour éternel.",
	heal_trigger = "commence à lancer Amour éternel%.$",
	heal_message = "%s incante un soin !",

	buff = "Buff",
	buff_desc = "Préviens quand Romulo et Julianne gagnent leurs buffs.",
	buff1_trigger = "gagne Hardiesse%.$",
	buff1_message = "Romulo gagne Hardiesse !",
	buff2_trigger = "gagne Dévotion%.$",
	buff2_message = "Julianne gagne Dévotion !",
} end)

L:RegisterTranslations("koKR", function() return {
	phase = "단계",
	phase_desc = "새로운 단계 진입 시 알립니다.",
	phase1_trigger = "당신들은 대체 누구시기에 절 이리도 괴롭히나요?",
	phase1_message = "1 단계 - %s",
	phase2_trigger = "기어코 나를 화나게 하는구나. 그렇다면 받아라, 애송이!",
	phase2_message = "2 단계 - %s",
	phase3_trigger = "정다운 밤이시여, 어서 와서 나의 로밀로를 돌려주소서!",
	phase3_message = "3 단계 - 모두",

	poison = "독",
	poison_desc = "독에 걸린 플레이어를 알립니다.",
	poison_trigger = "^([^|;%s]*)(.*)독칼 찌르기에 걸렸습니다%.$", -- check
	poison_message = "중독: %s",

	heal = "치유",
	heal_desc = "줄리엔이 영원한 사랑 시전 시 경고합니다.",
	heal_trigger = "영원한 사랑 시전을 시작합니다%.$",
	heal_message = "%s 치유 시전 중!",

	buff = "버프 알림",
	buff_desc = "로밀로와 줄리엔이 버프 획득 시 알립니다.",
	buff1_trigger = "사랑의 용기 효과를 얻었습니다%.$", -- check
	buff1_message = "%s 사랑의 용기 효과 얻음!",
	buff2_trigger = "헌신 효과를 얻었습니다%.$", -- check
	buff2_message = "%s 헌신 효과 얻음!",
} end)

--罗密欧&朱丽叶
L:RegisterTranslations("zhCN", function() return {
	phase = "阶段警报",
	phase_desc = "当进入下阶段发出警报",
	phase1_trigger = "What devil art thou, that dost torment me thus?",
	phase1_message = "第 I 幕 - %s",
	phase2_trigger = "Wilt thou provoke me? Then have at thee, boy!",
	phase2_message = "第 II 幕 - %s",
	phase3_trigger = "来吧，可爱的黑颜的夜，把我的罗密欧给我！",
	phase3_message = "第 III 幕 - 同时出场",

	poison = "中毒",
	poison_desc = "当有玩家中毒时发出警报",
	poison_trigger = "^(%S+)受(%S+)了浸毒之刺效果的影响。$",
	poison_message = "浸毒之刺: %s",

	heal = "治疗",
	heal_desc = "当朱丽叶施放",
	heal_trigger = "开始施放永恒之爱。$",
	heal_message = "%s 施放治疗",

	buff = "自身BUFF警报",
	buff_desc = "当罗密欧与朱丽叶获得BUFF发出警报",
	buff1_trigger = "获得了卤莽的效果。$",
	buff1_message = "%s 获得 卤莽!",
	buff2_trigger = "获得了虔诚光环的效果。$",
	buff2_message = "%s 获得 虔诚光环!",
} end)

L:RegisterTranslations("zhTW", function() return {
	phase = "階段提示",
	phase_desc = "當戰鬥進入下一個階段時發送警告",
	phase1_trigger = "你是什麼樣的惡魔，讓我這樣的痛苦?",
	phase1_message = "Act I - %s",
	phase2_trigger = "你想挑釁我嗎?下一個就輪到你了，小子!",
	phase2_message = "Act II - %s",
	phase3_trigger = "來吧，溫和的夜晚；把我的羅慕歐還給我!",
	phase3_message = "Act III - 羅慕歐與茱麗葉",

	poison = "中毒警告",
	poison_desc = "當有玩家中毒時發送警告",
	poison_trigger = "^(.+)受到(.*)毒刺",
	poison_message = "%s 中毒 - 請解毒",

	heal = "治療警告",
	heal_desc = "當 茱麗葉 施放永恆的影響時發送警告",
	heal_trigger = "開始施放永恆的影響",
	heal_message = "%s 正在施放治療術 - 請中斷",

	buff = "狀態警告",
	buff_desc = "當 羅慕歐 和 茱麗葉 施放狀態時發送警告",
	buff1_trigger = "獲得了膽量的效果。",
	buff1_message = "%s 在施放增益狀態 - 請偷取",
	buff2_trigger = "獲得了虔誠的效果。",
	buff2_message = "%s 在施放增益狀態 - 請偷取",
} end)

L:RegisterTranslations("esES", function() return {
	phase = "Fases",
	phase_desc = "Avisa cuando entra en una nueva fase.",
	phase1_trigger = "Qué demonio sois que os atrevéis a atormentarme de esta guisa?",
	phase1_message = "Acto I - %s",
	phase2_trigger = "Qué bien resurge mi consuelo esto!",
	phase2_message = "Acto II - %s",
	phase3_trigger = "Ven, dulce noche; y devuélveme a mi Romulo!",
	phase3_message = "Acto III - Ambos",

	poison = "Veneno",
	poison_desc = "Avisa del jugador envenenado.",
	poison_trigger = "^([^%s]+) ([^%s]+) sufre Empujón envenenado%.$",
	poison_message = "Envenenado: %s",

	heal = "Curacion",
	heal_desc = "Avisa cuando Julianne lanza Afección eterna.",
	heal_trigger = "comienza a lanzar Afección eterna",
	heal_message = "%s Lanzando Curacion!",

	buff = "Alerta de Auto-Buff",
	buff_desc = "Avisa cuando Romulo y Julianne reciben un self-buff.",
	buff1_trigger = "gana Arrojo",
	buff1_message = "%s gana Arrojo!",
	buff2_trigger = "gana Devoción",
	buff2_message = "%s gana Devoción.",
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
		self:Message(fmt(L["phase1_message"], girl), "Attention")
	elseif msg == L["phase2_trigger"] then
		self:Message(fmt(L["phase2_message"], boy), "Attention")
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
			self:Message(fmt(L["poison_message"], pplayer), "Important")
		end
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if self.db.profile.heal and msg:find(L["heal_trigger"]) then
		self:Message(fmt(L["heal_message"], girl), "Urgent")
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if not self.db.profile.buff then return end
	if msg:find(L["buff1_trigger"]) then
		self:Message(fmt(L["buff1_message"], boy), "Attention")
	elseif msg:find(L["buff2_trigger"]) then
		self:Message(fmt(L["buff2_message"], girl), "Attention")
	end
end
