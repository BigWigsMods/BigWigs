----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["General Vezax"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.guid = 33271
mod.toggleOptions = {"vaporstack", "vapor", "animus", -1, 62660, "crashsay", "crashicon", 63276, "icon", 62661, 62662, "berserk", "bosskill"}
mod.consoleCmd = "Vezax"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local vaporCount = 1
local surgeCount = 1
local pName = UnitName("player")
local fmt = string.format
local lastVapor = nil
local vapor = GetSpellInfo(63322)

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	["Vezax Bunny"] = true, -- For emote catching.

	engage_trigger = "^Your destruction will herald a new age of suffering!",

	surge_message = "Surge %d!",
	surge_cast = "Surge %d casting!",
	surge_bar = "Surge %d",

	animus = "Saronite Animus",
	animus_desc = "Warn when the Saronite Animus spawns.",
	animus_trigger = "The saronite vapors mass and swirl violently, merging into a monstrous form!",
	animus_message = "Animus spawns!",

	vapor = "Saronite Vapors",
	vapor_desc = "Warn when Saronite Vapors spawn.",
	vapor_message = "Saronite Vapor %d!",
	vapor_bar = "Vapor %d/6",
	vapor_trigger = "A cloud of saronite vapors coalesces nearby!",

	vaporstack = "Vapors Stack",
	vaporstack_desc = "Warn when you have 5 or more stacks of Saronite Vapors.",
	vaporstack_message = "Vapors x%d!",

	crash_say = "Crash on Me!",

	crashsay = "Crash Say",
	crashsay_desc = "Say when you are the target of Shadow Crash.",
	crashicon = "Crash Icon",
	crashicon_desc = "Place a Blue Square icon on the player targetted by Shadow Crash. (requires promoted or higher)",

	mark_message = "Mark",
	mark_message_other = "Mark on %s!",

	icon = "Mark Icon",
	icon_desc = "Place a raid target icon on the player targetted by Mark of the Faceless. (requires promoted or higher)",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "^너희의 파멸은 새로운 고통의 시대를 열 것이다!",

	surge_message = "어둠 쇄도 (%d)!",
	surge_cast = "쇄도 시전 (%d)!",
	surge_bar = "쇄도 %d",

	animus = "사로나이트 원혼",
	animus_desc = "사로나이트 원혼 소환을 알립니다.",
	animus_trigger = "사로나이트 증기가 한 덩어리가 되어 맹렬하게 소용돌이치며, 무시무시한 형상으로 변화합니다!",
	animus_message = "원혼 소환!",

	vapor = "사로나이트 증기",
	vapor_desc = "사로나이트 증기 소환을 알립니다.",
	vapor_message = "사로나이트 증기 (%d)!",
	vapor_bar = "다음 증기 %d/6",
	vapor_trigger = "가까운 사로나이트 증기 구름이 합쳐집니다!",

	vaporstack = "증기 중첩",
	vaporstack_desc = "사로나이트 증기 5중첩이상을 알립니다.",
	vaporstack_message = "증기 x%d 중첩!",

	crashsay = "붕괴 일반 대화",
	crashsay_desc = "어둠의 붕괴 대상시 일반 대화로 알립니다.",
	crash_say = "저 어둠 붕괴요!",

	crashicon = "붕괴 아이콘",
	crashicon_desc = "어둠 붕괴의 대상 플레이어에게 파란 네모 표시를 지정합니다. (승급자 이상 권한 필요)",

	mark_message = "Mark",
	mark_message_other = "얼굴 없는 자의 징표: %s",

	icon = "징표 아이콘",
	icon_desc = "얼굴 없는 자의 징표의 대상 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "^Votre destruction annoncera un nouvel âge de souffrance !",

	surge_message = "Vague de ténèbres %d !",
	surge_cast = "Vague %d en incantation !",
	surge_bar = "Vague %d",

	animus = "Animus de saronite",
	animus_desc = "Prévient quand l'Animus de saronite apparaît.",
	animus_trigger = "Les vapeurs saronitiques s'amassent et tourbillonnent violemment pour former un amas monstrueux !",
	animus_message = "Animus apparu !",

	vapor = "Vapeurs de saronite",
	vapor_desc = "Prévient quand des Vapeurs de saronite apparaissent.",
	vapor_message = "Vapeurs de saronite %d !",
	vapor_bar = "Vapeurs %d/6",
	vapor_trigger = "Un nuage de vapeurs saronitiques se forme non loin !",

	vaporstack = "Cumul des Vapeurs",
	vaporstack_desc = "Prévient quand vous avez 5 cumuls ou plus de Vapeurs de saronite.",
	vaporstack_message = "Vapeurs de saronite x%d !",

	crash_say = "Déferlante d'ombre sur moi !",

	crashsay = "Déferlante - Dire",
	crashsay_desc = "Fait dire à votre personnage qu'il est ciblé par une Déferlante d'ombre quand c'est le cas.",

	crashicon = "Déferlante - Icône",
	crashicon_desc = "Place une icône de raid (carré bleu) sur le dernier joueur ciblé par une Déferlante d'ombre (nécessite d'être assistant ou mieux).",

	mark_message = "Mark",
	mark_message_other = "Marque : %s",

	icon = "Marque - Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par une Marque du Sans-visage (nécessite d'être assistant ou mieux).",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Eure Vernichtung wird ein neues Zeitalter des Leids einläuten!",

	surge_message = "Sog %d!",
	surge_cast = "Wirkt Sog %d",
	surge_bar = "Sog %d",

	animus = "Saronitanimus",
	animus_desc = "Warnt, wenn ein Saronitanimus auftaucht.",
	animus_trigger = "Die Saronitdämpfe sammeln sich, wirbeln heftig herum und verschmelzen zu einer monströsen Form!",
	animus_message = "Saronitanimus kommt!",

	vapor = "Saronitdämpfe",
	vapor_desc = "Warnung und Timer für das Auftauchen von Saronitdämpfen.",
	vapor_message = "Saronitdämpfe %d!",
	vapor_bar = "Saronitdämpfe %d/6",
	vapor_trigger = "Eine Wolke Saronitdämpfe bildet sich in der Nähe!",

	vaporstack = "Saronitdämpfe Stapel",
	vaporstack_desc = "Warnt, wenn du 5 oder mehr Stapel der Saronitdämpfe hast.",
	vaporstack_message = "Saronitdämpfe x%d!",

	crash_say = "Schattengeschoss auf MIR!",

	crashsay = "Schattengeschoss Sagen",
	crashsay_desc = "Warnt im Sagen Chat, wenn du das Ziel eines Schattengeschosses bist.",

	crashicon = "Schattengeschoss: Schlachtzugs-Symbol",
	crashicon_desc = "Platziert ein blaues Quadrat auf Spielern, die von Schattengeschoss betroffen sind (benötigt Assistent oder höher).",

	mark_message = "Mark",
	mark_message_other = "Mal: %s!",

	icon = "Mal der Gesichtslosen: Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, die von Mal der Gesichtslosen betroffen sind (benötigt Assistent oder höher).",
} end )

L:RegisterTranslations("zhCN", function() return {
--	["Vezax Bunny"] = true, -- For emote catching.

--	engage_trigger = "^Your destruction will herald a new age of suffering!",

	surge_message = "黑暗涌动：>%d<！",
	surge_cast = "正在施放 黑暗涌动：>%d<！",
	surge_bar = "<黑暗涌动：%d>",

	animus = "萨隆邪铁畸体",
	animus_desc = "当萨隆邪铁畸体出现时发出警报。",
--	animus_trigger = "The saronite vapors mass and swirl violently, merging into a monstrous form!",
	animus_message = "萨隆邪铁畸体 出现！",

	vapor = "萨隆邪铁蒸汽",
	vapor_desc = "当萨隆邪铁蒸汽出现时发出警报。",
	vapor_message = "萨隆邪铁蒸汽：>%d<！",
	vapor_bar = "<萨隆邪铁蒸汽：%d/6>",
--	vapor_trigger = "A cloud of saronite vapors coalesces nearby!",

	vaporstack = "萨隆邪铁蒸汽堆叠",
	vaporstack_desc = "当玩家中了5层或更多萨隆邪铁蒸汽时发出警报。",
	vaporstack_message = "萨隆邪铁蒸汽：>x%d<！",

	crash_say = ">我< 暗影冲撞！",

	crashsay = "自身暗影冲撞",
	crashsay_desc = "当你中了暗影冲撞时发出说话警报。",

	crashicon = "暗影冲撞标记",
	crashicon_desc = "为中了暗影冲撞的队员打上蓝色方框团队标记。（需要权限）",

	mark_message = "Mark",
	mark_message_other = "无面者的印记：>%s<！",

	icon = "团队标记",
	icon_desc = "为中了暗影冲撞的队员打上团队标记。（需要权限）",
} end )

L:RegisterTranslations("zhTW", function() return {
--	["Vezax Bunny"] = true, -- For emote catching.

	engage_trigger = "你的毀滅將會預告一個嶄新苦難時代的來臨!",

	surge_message = "暗鬱奔騰：>%d<！",
	surge_cast = "正在施放 暗鬱奔騰：>%d<！",
	surge_bar = "<暗鬱奔騰：%d>",

	animus = "薩倫聚惡體",
	animus_desc = "當薩倫聚惡體出現時發出警報。",
	animus_trigger = "薩倫煙霧聚集起來并且劇烈地旋轉，形成一個怪物般的形體!",
	animus_message = "薩倫聚惡體 出現！",

	vapor = "薩倫煙霧",
	vapor_desc = "當薩倫煙霧出現時發出警報。",
	vapor_message = "薩倫煙霧：>%d<！",
	vapor_bar = "<薩倫煙霧：%d/6>",
	vapor_trigger = "一片薩倫煙霧在附近聚合!",

	vaporstack = "薩倫煙霧堆疊",
	vaporstack_desc = "當玩家中了5層或更多薩倫煙霧時發出警報。",
	vaporstack_message = "薩倫煙霧：>x%d<！",

	crash_say = ">我< 暗影暴擊！",

	crashsay = "自身暗影暴擊",
	crashsay_desc = "當你中了暗影暴擊時發出說話警報。",

	crashicon = "暗影暴擊標記",
	crashicon_desc = "為中了暗影暴擊的隊員打上藍色方框團隊標記。（需要權限）",

	mark_message = "Mark",
	mark_message_other = "無面者印記：>%s<！",

	icon = "團隊標記",
	icon_desc = "為中了暗影暴擊的隊員打上團隊標記。（需要權限）",
} end )

L:RegisterTranslations("ruRU", function() return {
	engage_trigger = "Ваша смерть возвестит новую эру страданий!",

	surge_message = "Наплыв %d!",
	surge_cast = "Применяется наплыв %d!",
	surge_bar = "Наплыв %d",

	animus = "Саронитовый враг",
	animus_desc = "Сообщать о появлении саронитового врага.",
	animus_trigger = "Саронитовые испарения яростно клубятся и струятся, принимая пугающую форму!",
	animus_message = "Появился саронитовый враг!",

	vapor = "Саронитовые пары",
	vapor_desc = "Сообщать о появлении саронитовых паров.",
	vapor_message = "Саронитовые пары (%d)!",
	vapor_bar = "Пары %d/6",
	vapor_trigger = "Поблизости начинают возникать саронитовые испарения!",

	vaporstack = "Стаки испарения",
	vaporstack_desc = "Сообщать, когда у вас уже 5 стаков саронитового испарения.",
	vaporstack_message = "Испарения x%d!",

	crash_say = "Сокрушение на мне!",

	crashsay = "Сказать о оокрушении",
	crashsay_desc = "Сказать, когда вы являетесь целью Темного сокрушения.",

	crashicon = "Иконка сокрушения",
	crashicon_desc = "Помечать рейдовой иконкой (синим квадратом) игрока, на которого наложено темное сокрушение (необходимо обладать промоутом).",

	mark_message = "Mark",
	mark_message_other = "Метка на: %s!",

	icon = "Иконка метки",
	icon_desc = "Помечать рейдовой иконкой игрока, на который попал под воздействие метки безликого (необходимо обладать промоутом)",
} end )

mod.enabletrigger = {boss, L["Vezax Bunny"]}

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	db = self.db.profile
	self:AddCombatListener("SPELL_CAST_START", "Flame", 62661)
	self:AddCombatListener("SPELL_CAST_START", "Surge", 62662)
	self:AddCombatListener("SPELL_AURA_APPLIED", "SurgeGain", 62662)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Target", 60835, 62660)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Mark", 63276)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:UNIT_AURA(unit)
	if unit and unit ~= "player" then return end
	local _, _, icon, stack = UnitDebuff("player", vapor)
	if stack and stack ~= lastVapor then
		if db.vaporstack and stack > 5 then
			self:LocalMessage(L["vaporstack_message"]:format(stack), "Personal", icon)
		end
		lastVapor = stack
	end
end

local function scanTarget(spellId, spellName)
	local target
	if UnitName("target") == boss then
		target = UnitName("targettarget")
	elseif UnitName("focus") == boss then
		target = UnitName("focustarget")
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			if UnitName(fmt("%s%d%s", "raid", i, "target")) == boss then
				target = UnitName(fmt("%s%d%s", "raid", i, "targettarget"))
				break
			end
		end
	end
	if target then
		if target == pName and db.crashsay then
			SendChatMessage(L["crash_say"], "SAY")
		end
		if mod:GetOption(spellId) then
			mod:TargetMessage(spellName, target, "Personal", spellId, "Alert")
			mod:Whisper(target, spellName)
		end
		if db.crashicon then
			SetRaidTarget(target, 6)
		end
		mod:CancelScheduledEvent("BWCrashToTScan")
	end
end

function mod:Mark(player, spellId)
	self:TargetMessage(L["mark_message"], player, "Personal", spellId, "Alert")
	self:Whisper(player, L["mark_message"])
	self:Bar(L["mark_message_other"]:format(player), 10, spellId)
	self:Icon(player, "icon")
end

function mod:Target(player, spellId, _, _, spellName)
	self:ScheduleEvent("BWCrashToTScan", scanTarget, 0.1, spellId, spellName)
end

function mod:Flame(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Urgent", spellId)
end

function mod:Surge(_, spellId)
	self:IfMessage(L["surge_message"]:format(surgeCount), "Important", spellId)
	self:Bar(L["surge_cast"]:format(surgeCount), 3, spellId)
	surgeCount = surgeCount + 1
	self:Bar(L["surge_bar"]:format(surgeCount), 60, spellId)
end

function mod:SurgeGain(_, spellId, _, _, spellName)
	self:Bar(spellName, 10, spellId)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["vapor_trigger"] and db.vapor then
		self:IfMessage(L["vapor_message"]:format(vaporCount), "Positive", 63323)
		vaporCount = vaporCount + 1
		if vaporCount < 7 then
			self:Bar(L["vapor_bar"]:format(vaporCount), 30, 63323)
		end
	elseif msg == L["animus_trigger"] and db.animus then
		self:IfMessage(L["animus_message"], "Important", 63319)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) then
		lastVapor = nil
		vaporCount = 1
		surgeCount = 1
		if db.berserk then
			self:Enrage(600, true, true)
		end
		if db.surge then
			self:Bar(L["surge_bar"]:format(surgeCount), 60, 62662)
		end
	end
end

