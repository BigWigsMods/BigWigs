------------------------------
--      Are you local?      --
------------------------------

local BB = AceLibrary("Babble-Boss-2.2")
local boss = BB["Magtheridon"]
local channeler = BB["Hellfire Channeler"]

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local abycount
local debwarn
BB = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Magtheridon",

	escape = "Escape",
	escape_desc = "Countdown until Magtheridon breaks free.",
	escape_trigger1 = "%%s's bonds begin to weaken!",
	escape_trigger2 = "I... am... unleashed!",
	escape_warning1 = "%s Engaged - Breaks free in 2min!",
	escape_warning2 = "Breaks free in 1min!",
	escape_warning3 = "Breaks free in 30sec!",
	escape_warning4 = "Breaks free in 10sec!",
	escape_warning5 = "Breaks free in 3sec!",
	escape_bar = "Released...",
	escape_message = "%s Released!",

	abyssal = "Burning Abyssal",
	abyssal_desc = "Warn when a Burning Abyssal is created.",
	abyssal_trigger = "^Hellfire Channeler's Burning Abyssal hits",
	abyssal_message = "Burning Abyssal Created (%d)",

	heal = "Heal",
	heal_desc = "Warn when a Hellfire Channeler starts to heal.",
	heal_trigger = "begins to cast Dark Mending%.$",
	heal_message = "Healing!",

	nova = "Blast Nova",
	nova_desc = "Estimated Blast Nova timers.",
	nova_ = "Blast Nova!",
	nova_bar = "~Blast Nova Cooldown",
	nova_warning = "Blast Nova Soon",
	nova_cast = "Casting Blast Nova!",

	banish = "Banish",
	banish_desc = "Warn when you Banish Magtheridon.",
	banish_trigger = "Not again! Not again...",
	banish_message = "Banished for ~10sec",
	banish_over_trigger = "^Shadow Cage fades",
	banish_over_message = "Banish Fades!",
	banish_bar = "Banished",

	exhaust = "Disable Exhaustion Bars",
	exhaust_desc = "Timer bars for Mind Exhaustion on players.",
	exhaust_trigger = "^(%S+) (%S+) afflicted by Mind Exhaustion%.$",
	exhaust_bar = "[%s] Exhausted",

	debris = "Debris on You",
	debris_desc = "Warn for Debris on You.",
	debris_trigger = "You are afflicted by Debris.",
	debris_message = "Debris on YOU!",

	debrisinc = "Debris",
	debrisinc_desc = "Warn for incoming debris at 30%.",
	debrisinc_trigger = "Let the walls of this prison tremble",
	debrisinc_message = "30% - Incoming Debris!",
	debrisinc_warning = "Debris Soon!",
} end)

L:RegisterTranslations("deDE", function() return {
	escape = "Ausbruch",
	escape_desc = "Countdown bis Magtheridon ausbricht",

	abyssal = "Brennender Schlund",
	abyssal_desc = "Warnt, wenn ein Brennender Schlund gespawned wird",

	heal = "Heilung",
	heal_desc = "Warnt, wenn ein Kanalisierer anf\195\164ngt zu heilen",

	nova = "Drucknova",
	nova_desc = "Gesch\195\164tzte Drucknova Timer",

	banish = "Verbannung",
	banish_desc = "Warnt, wenn ihr Magtheridon verbannt",

	exhaust = "Ersch\195\182pfung",
	exhaust_desc = "Timer f\195\188r Gedankenersch\195\182pfung",

	escape_trigger1 = "Die Fesseln von %%s werden schw\195\164cher!",
	escape_trigger2 = " Ich... bin... frei!",
	escape_warning1 = "%s angegriffen - Ausbruch in 2min!",
	escape_warning2 = "Ausbruch in 1min!",
	escape_warning3 = "Ausbruch in 30sec!",
	escape_warning4 = "Ausbruch in 10sec!",
	escape_warning5 = "Ausbruch in 3sec!",
	escape_bar = "Frei...",
	escape_message = "%s frei!",

	abyssal_trigger = "Kanalisierer des H\195\182llenfeuers wirkt Brennender Schlund",
	abyssal_message = "Brennender Schlund gespawned (%d)",

	heal_trigger = "beginnt Dunkle Besserung zu wirken",
	heal_message = "Heilung!",

	nova_ = "Drucknova",
	nova_warning = "Drucknova bald",

	banish_trigger = "Nicht schon wieder! Nicht schon wieder...",
	banish_message = "Verbannt f\195\188r ~10sec",
	banish_bar = "Verbannt",

	exhaust_trigger = "^([^%s]+) ([^%s]+) von Gedankenersch\195\182pfung betroffen%.$",
	exhaust_bar = "[%s] ersch\195\182pft",
} end)

L:RegisterTranslations("frFR", function() return {
	escape = "Evasion",
	escape_desc = "Compte à rebours avant que Magtheridon ne soit libre.",
	escape_trigger1 = "Les liens de %%s commencent à se relâcher !",
	escape_trigger2 = "Me... voilà... déchaîné !",
	escape_warning1 = "%s engagé - Libre dans 2 min. !",
	escape_warning2 = "Libre dans 1 min. !",
	escape_warning3 = "Libre dans 30 sec. !",
	escape_warning4 = "Libre dans 10 sec. !",
	escape_warning5 = "Libre dans 3 sec. !",
	escape_bar = "Libération…",
	escape_message = "%s libéré !",

	abyssal = "Abyssal ardent",
	abyssal_desc = "Préviens quand un Abyssal ardent est créé.",
	abyssal_trigger = "Canaliste des Flammes infernales lance Abyssal ardent",
	abyssal_message = "Abyssal ardent créé (%d)",

	heal = "Soin",
	heal_desc = "Préviens quand un Canaliste des Flammes infernales commence à soigner.",
	heal_trigger = "commence à lancer Guérison ténébreuse%.$",
	heal_message = "Se soigne !",

	nova = "Nova explosive",
	nova_desc = "Estimation du temps de la Nova explosive.",
	nova_ = "nova explosive",
	nova_bar = "~Cooldown Nova explosive",
	nova_warning = "Nova explosive imminente",
	nova_cast = "Incante une Nova explosive !",

	banish = "Bannir",
	banish_desc = "Préviens quand vous bannissez Magtheridon.",
	banish_trigger = "Pas encore ! Pas encore...",
	banish_message = "Banni pendant ~10 sec.",
	banish_over_trigger = "Cage d'ombre sur Magtheridon vient de se dissiper.",
	banish_over_message = "Fin du ban !",
	banish_bar = "Banni",

	exhaust = "Désactiver les barres d'Epuisement",
	exhaust_desc = "Barre temporelles pour l'Epuisement d'esprit des joueurs",
	exhaust_trigger = "^(%S+) (%S+) les effets .* Epuisement de l'esprit%.$",
	exhaust_bar = "[%s] épuisé",

	debris = "Débris sur vous",
	debris_desc = "Préviens quand les Débris tombent sur vous.",
	debris_trigger = "Vous subissez les effets de Débris.",
	debris_message = "Débris sur VOUS !",

	debrisinc = "Débris",
	debrisinc_desc = "Préviens quand les Débris tombent à 30%.",
	debrisinc_trigger = "Que les murs de cette prison tremblent",
	debrisinc_message = "30% - Arrivée des Débris !",
	debrisinc_warning = "Débris imminent !",
} end)

L:RegisterTranslations("koKR", function() return {
	escape = "탈출",
	escape_desc = "마그테리돈 속박 해제까지 카운트다운합니다.",
	escape_trigger1 = "%%s의 속박이 약해지기 시작합니다",
	escape_trigger2 = "내가... 풀려났도다!",
	escape_warning1 = "%s 전투 개시 - 2분 이내 속박 해제!",
	escape_warning2 = "속박 해제 1분 전!",
	escape_warning3 = "속박 해제 30초 전!",
	escape_warning4 = "속박 해제 10초 전!",
	escape_warning5 = "속박 해제 3초 전!",
	escape_bar = "풀려남...",
	escape_message = "%s 풀려남!",

	abyssal = "불타는 심연",
	abyssal_desc = "불타는 심연 생성 시 경고합니다.",
	abyssal_trigger = "지옥불 역술사|1이;가; 불타는 심연|1으로;로;",
	abyssal_message = "불타는 심연 생성 (%d)",

	heal = "치유",
	heal_desc = "지옥불 역술사 치유 시전 시 경고합니다.",
	heal_trigger = "암흑의 치유 시전을 시작합니다%.$",
	heal_message = "치유 시전!",

	nova = "파열의 회오리",
	nova_desc = "파열의 회오리 지속시간에 대한 바입니다.",
	nova_ = "파열의 회오리",
	nova_bar = "~파열의 회오리 대기시간",
	nova_warning = "곧 파열의 회오리",
	nova_cast = "파열의 회오리 시전!",

	banish = "추방",
	banish_desc = "마그테리돈 추방 시 알립니다.",
	banish_trigger = "안 돼, 다시 그럴 수는 없다!",
	banish_message = "약 10초 동안 추방됨",
	banish_over_trigger = "^어둠의 우리 효과가 사라졌습니다.",
	banish_over_message = "추방 종료!",
	banish_bar = "추방됨",

	exhaust = "방출 바 비활성화",
	exhaust_desc = "정신 방출에 걸린 플레이어에 대한 타이머 바입니다.",
	exhaust_trigger = "^([^|;%s]*)(.*)정신 방출에 걸렸습니다%.$",
	exhaust_bar = "[%s] 정신 방출",

	debris = "당신에 파편",
	debris_desc = "당신이 파편에 걸렸을때 알립니다.",
	debris_trigger = "당신은 파편에 걸렸습니다.",
	debris_message = "당신에 파편!",

	debrisinc = "파편",
	debrisinc_desc = "30%일 때 파편에 대한 경고입니다.",
	debrisinc_trigger = "그렇게 쉽게 당할 내가 아니다! 이 감옥의 벽이 흔들리고... 무너지라라!",
	debrisinc_message = "30% - 잠시 후 파편!",
	debrisinc_warning = "곧 파편!",
} end)

--玛瑟里顿
L:RegisterTranslations("zhCN", function() return {
	escape = "释放",
	escape_desc = "玛瑟里顿获得自由倒计时",
	escape_trigger1 = "%s的禁锢开始变弱！",
	escape_trigger2 = "我……自由了！",
	escape_warning1 = "%s 激活- 2分钟后获得自由",
	escape_warning2 = "1分后 自由!",
	escape_warning3 = "30秒后 自由",
	escape_warning4 = "10秒后 自由!",
	escape_warning5 = "3秒后 自由!",
	escape_bar = "已释放",
	escape_message = "%s 已释放!",

	abyssal = "深渊燃魔",
	abyssal_desc = "当创建一个深渊燃魔时发出警报",
	abyssal_trigger = "^地狱火导魔者的深渊燃魔击中",
	abyssal_message = "深渊燃魔创建 (%d)",

	heal = "治疗",
	heal_desc = "当地狱火导魔者施放治疗发出警报",
	heal_trigger = "开始施放黑暗治愈。$",
	heal_message = "治疗!",

	nova = "冲击新星",
	nova_desc = "冲击新星计时",
	nova_ = "冲击新星!",
	nova_bar = "~冲击新星 CD",
	nova_warning = "即将 冲击新星",
	nova_cast = "开始施放冲击新星！",

	banish = "放逐术",
	banish_desc = ("当你放逐%s发出警报."):format(boss),
	banish_trigger = "Not again! Not again...",
	banish_message = "放逐成功 - 10秒 ",
	banish_over_trigger = "^暗影牢笼从",
	banish_over_message = "放逐消失!",
	banish_bar = "放逐中",

	exhaust = "禁用心灵疲倦计时",
	exhaust_desc = "心灵疲倦记时条",
	exhaust_trigger = "^(%S+)受(%S+)了心灵疲倦效果的影响。",
	exhaust_bar = "[%s] 心灵疲倦",

	debris = "碎片(你)",
	debris_desc = "当你中了碎片发出警报",
	debris_trigger = "你受到了碎片效果的影响。",
	debris_message = "碎片 >你<!",

	debrisinc = "碎片",
	debrisinc_desc = "当首领30%血量时发出警报.",
	debrisinc_trigger = "Let the walls of this prison tremble",
	debrisinc_message = "30% - 碎片来临!",
	debrisinc_warning = "即将 碎片!",
} end)

L:RegisterTranslations("zhTW", function() return {
	escape = "釋放",
	escape_desc = "倒數計時，直到 瑪瑟里頓 獲得自由",
	escape_trigger1 = "束縛開始變弱",
	escape_trigger2 = "我……被……釋放了!",
	escape_warning1 = "與 %s 進入戰鬥 - 2 分鐘後獲得自由！",
	escape_warning2 = "1 分鐘後獲得自由！",
	escape_warning3 = "30 秒後獲得自由！",
	escape_warning4 = "10 秒後獲得自由！",
	escape_warning5 = "3 秒後獲得自由！",
	escape_bar = "被釋放...",
	escape_message = "%s 被釋放了！",

	abyssal = "燃燒的冥淵火", --智缺迪偷改了名字
	abyssal_desc = "當地獄火導魔師創造燃燒的冥淵火時發出警報",
	abyssal_trigger = "地獄火導魔師施放了燃燒的冥淵火。",
	abyssal_message = "燃燒的冥淵火已創造 (%d)",

	heal = "黑暗治療",
	heal_desc = "當地獄火導魔師開始治療時發出警報",
	heal_trigger = "開始施放黑暗治療。",
	heal_message = "黑暗治療 - 快中斷!",

	nova = "衝擊新星",
	nova_desc = "衝擊新星計時",
	nova_ = "衝擊新星!", --！改成!
	nova_bar = "衝擊新星冷卻",
	nova_warning = "即將施放衝擊新星！",
	nova_cast = "開始施放衝擊新星!",

	banish = "驅逐",
	banish_desc = "當你驅逐 瑪瑟里頓.",
	banish_trigger = "別再來了!別再來了……",
	banish_message = "驅逐成功 - 衝擊新星巳中斷",
	banish_over_trigger = "暗影之握效果從瑪瑟里頓身上消失",
	banish_over_message = "驅逐效果消失!",
	banish_bar = "驅逐中",

	exhaust = "關閉心靈耗損計時條",
	exhaust_desc = "玩家中心靈耗損時計時器",
	exhaust_trigger = "^(.+)受到([了]*)心靈耗損",
	exhaust_bar = "[%s] 心靈耗損",

	debris = "你中了殘骸",
	debris_desc = "當你中了殘骸時發出警報",
	debris_trigger = "你受到了殘骸效果的影響。",
	debris_message = "你中了殘骸!",

	debrisinc = "殘骸",
	debrisinc_desc = "當王血量30%時殘骸即將開始警報",
	debrisinc_trigger = "我不會這麼輕易就被擊敗!讓這座監獄的牆壁震顫……然後崩塌!",
	debrisinc_message = "30% - 殘骸來臨!",
	debrisinc_warning = "殘骸即將來臨!",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Magtheridon's Lair"]
mod.otherMenu = "Outland"
mod.enabletrigger = {channeler, boss}
mod.toggleoptions = {"escape", "abyssal", "heal", -1, "nova", "banish", -1, "debris", "debrisinc", -1, "exhaust", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "ExhaustEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "ExhaustEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "ExhaustEvent")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "Exhaustion", 0)
	self:TriggerEvent("BigWigs_ThrottleSync", "MagHFHeal", 0.5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MagHFAbyssal", 0.8)
	self:TriggerEvent("BigWigs_ThrottleSync", "MagUnbanish", 5)
	abycount = 1
	debwarn = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg:find(L["escape_trigger1"]) then
		abycount = 1
		debwarn = nil

		if self.db.profile.escape then
			self:Message(L["escape_warning1"]:format(boss), "Attention")
			self:Bar(L["escape_bar"], 120, "Ability_Rogue_Trip")
			self:DelayedMessage(60, L["escape_warning2"], "Positive")
			self:DelayedMessage(90, L["escape_warning3"], "Attention")
			self:DelayedMessage(110, L["escape_warning4"], "Urgent")
			self:DelayedMessage(117, L["escape_warning5"], "Urgent", nil, "Long")
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["escape_trigger2"] then
		if self.db.profile.escape then
			self:Message(L["escape_message"]:format(boss), "Important", nil, "Alert")
		end
		if self.db.profile.nova then
			self:Bar(L["nova_bar"], 58, "Spell_Fire_SealOfFire")
			self:DelayedMessage(56, L["nova_warning"], "Urgent")
		end
	elseif msg == L["banish_trigger"] then
		if self.db.profile.banish then
			self:Message(L["banish_message"], "Important", nil, "Info")
			self:Bar(L["banish_bar"], 10, "Spell_Shadow_Cripple")
		end
		self:TriggerEvent("BigWigs_StopBar", self, L["nova_cast"])
	elseif self.db.profile.debrisinc and msg:find(L["debrisinc_trigger"]) then
		self:Message(L["debrisinc_message"], "Positive")
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if self.db.profile.nova and msg:find(L["nova_"]) then
		self:Message(L["nova_"], "Positive")
		self:Bar(L["nova_bar"], 51, "Spell_Fire_SealOfFire")
		self:Bar(L["nova_cast"], 12, "Spell_Fire_SealOfFire")
		self:DelayedMessage(48, L["nova_warning"], "Urgent")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["abyssal_trigger"]) then
		self:Sync("MagHFAbyssal")
	end
end

function mod:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if msg:find(L["banish_over_trigger"]) then
		self:Sync("MagUnbanish")
	end
end

--hellfire channelers sometimes heal
function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg:find(L["heal_trigger"]) then
		self:Sync("MagHFHeal")
	end
end

--mind exhastion bars can get spammy, so off by default
function mod:ExhaustEvent(msg)
	if self.db.profile.debris and msg == L["debris_trigger"] then
		self:Message(L["debris_message"], "Important", nil, "Alert")
	end
	local eplayer, etype = select(3, msg:find(L["exhaust_trigger"]))
	if eplayer and etype then
		if eplayer == L2["you"] and etype == L2["are"] then
			eplayer = UnitName("player")
		end
		self:Sync("Exhaustion "..eplayer)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "Exhaustion" and rest and not self.db.profile.exhaust then
		self:Bar(L["exhaust_bar"]:format(rest), 75, "Spell_Shadow_Teleport")
	elseif sync == "MagHFHeal" and self.db.profile.heal then
		self:Message(L["heal_message"], "Urgent", nil, "Alarm")
		self:Bar(L["heal_message"], 2, "Spell_Shadow_ChillTouch")
	elseif sync == "MagHFAbyssal" and self.db.profile.abyssal then
		self:Message(L["abyssal_message"]:format(abycount), "Attention")
		abycount = abycount + 1
	elseif sync == "MagUnbanish" and self.db.profile.banish then
		self:Message(L["banish_over_message"], "Attention")
		self:TriggerEvent("BigWigs_StopBar", self, L["banish_bar"])
	end
end

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.debrisinc then return end
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 31 and health <= 35 and not debwarn then
			self:Message(L["debrisinc_warning"], "Positive")
			debwarn = true
		elseif health > 60 and debwarn then
			debwarn = false
		end
	end
end
