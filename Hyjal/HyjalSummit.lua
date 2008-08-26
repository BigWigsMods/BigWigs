------------------------------
--      Are you local?      --
------------------------------

local name = BZ["Hyjal Summit"]
local allianceBase = BZ["Alliance Base"]
local hordeEncampment = BZ["Horde Encampment"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..name)

local winterchill = BB["Rage Winterchill"]
local anetheron = BB["Anetheron"]
local kazrogal = BB["Kaz'rogal"]
local azgalor = BB["Azgalor"]

local fmt = string.format
local match = string.match
local GetRealZoneText = GetRealZoneText
local GetSubZoneText = GetSubZoneText
local select = select
local tonumber = tonumber

local nextBoss = nil
local currentWave = 0
local waveBar = nil
local store = nil
local allianceWaveTimes = {127.5, 127.5, 127.5, 127.5, 127.5, 127.5, 127.5, 140}
local RWCwaveTimes = allianceWaveTimes --need more accurate times
local KRwaveTimes = {135, 160, 190, 165, 140, 130, 195, 225} --need more accurate times
local hordeWaveTimes = {135, 190, 190, 195, 140, 165, 195, 225}

--[[		Wave details thanks to shieldb, Arta & Thunderheart		]]--

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "summit",

	waves = "Wave Warnings",
	waves_desc = "Announce approximate warning messages for the next wave.",

	detail = "Detailed Warnings",
	detail_desc = "Show detailed warnings of what mobs are incoming.",

	["~%s spawn"] = true,
	["~Wave %d spawn"] = true,
	["Wave %d incoming!"] = true,
	["Wave %d! %d %s"] = true, --1 set of mobs
	["Wave %d! %d %s, %d %s"] = true, --2 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s"] = true, --3 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s"] = true, --4 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s, %d %s"] = true, --5 sets of mobs
	["%s in ~%d sec!"] = true,
	["Wave %d in ~%d sec!"] = true,

	["Boss"] = true,
	["Thrall"] = true,
	["Lady Jaina Proudmoore"] = true,

	["My companions and I are with you, Lady Proudmoore."] = true, -- Rage Winterchill
	["We are ready for whatever Archimonde might send our way, Lady Proudmoore."] = true, -- Anatheron
	["I am with you, Thrall."] = true, -- Kaz'Rogal
	["We have nothing to fear."] = true, -- Az'Galor

	["Please remove BigWigs_WaveTimers, it is deprecated."] = true,

	["Ghouls"] = true,
	["Crypt Fiends"] = true,
	["Abominations"] = true,
	["Necromancers"] = true,
	["Banshees"] = true,
	["Gargoyles"] = true,
	["Frost Wyrm"] = true,
	["Fel Stalkers"] = true,
	["Infernals"] = true,

	["Ghoul"] = true,
} end )

L:RegisterTranslations("esES", function() return {
	waves = "Oleadas",
	waves_desc = "Avisos aproximados para cada oleada.",

	detail = "Avisos detallados",
	detail_desc = "Mostrar avisos detallados sobre los enemigos que vienen.",

	["~%s spawn"] = "~%s aparece",
	["~Wave %d spawn"] = "~Oleada %d aparece",
	["Wave %d incoming!"] = "¡Oleada %d viene!",
	["Wave %d! %d %s"] = "¡Oleada %d! %d %s", --1 set of mobs
	["Wave %d! %d %s, %d %s"] = "¡Oleada %d! %d %s, %d %s", --2 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s"] = "¡Oleada %d! %d %s, %d %s, %d %s", --3 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s"] = "¡Oleada %d! %d %s, %d %s, %d %s, %d %s", --4 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s, %d %s"] = "¡Oleada %d! %d %s, %d %s, %d %s, %d %s, %d %s", --5 sets of mobs
	["%s in ~%d sec!"] = "¡%s en ~%d seg!",
	["Wave %d in ~%d sec!"] = "¡Oleada %d en ~%d seg!",

	["Boss"] = "Jefe",
	["Thrall"] = "Thrall",
	["Lady Jaina Proudmoore"] = "Lady Jaina Valiente",

	["My companions and I are with you, Lady Proudmoore."] = "Mis compañeros y yo estamos contigo, Lady Valiente.", -- Rage Winterchill
	["We are ready for whatever Archimonde might send our way, Lady Proudmoore."] = "Estamos listos para cualquier cosa que Archimonde nos mande, lady Valiente.", -- Anatheron
	["I am with you, Thrall."] = "Estoy contigo, Thrall.", -- Kaz'Rogal
	["We have nothing to fear."] = "No tenemos nada que temer.", -- Az'Galor

	["Please remove BigWigs_WaveTimers, it is deprecated."] = "Por favor, elimina BigWigs_WaveTimers, es obsoleto.",

	["Ghouls"] = "Necrófagos",
	["Crypt Fiends"] = "Malignos de cripta",
	["Abominations"] = "Abominación",
	["Necromancers"] = "Nigromantes",
	["Banshees"] = "Almas en pena",
	["Gargoyles"] = "Gárgolas",
	["Frost Wyrm"] = "Vermis de escarcha",
	["Fel Stalkers"] = "Acechador vil",
	["Infernals"] = "Infernales",

	["Ghoul"] = "Necrófago",
} end )

L:RegisterTranslations("koKR", function() return {
	waves = "공격 경고",
	waves_desc = "다음 공격에 대한 접근 경고 메세지를 알립니다.",

	detail = "상세한 경고",
	detail_desc = "어떤 몹이 공격해올지 상세한 경고를 보여줍니다.",

	["~%s spawn"] = "~%s 등장",
	["~Wave %d spawn"] = "%d번째 공격 등장",
	["Wave %d incoming!"] = "%d번째 공격 시작!",
	["Wave %d! %d %s"] = "%d번째 공격! %d %s", --1 set of mobs
	["Wave %d! %d %s, %d %s"] = "%d번째 공격! %d %s, %d %s", --2 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s"] = "%d번째 공격! %d %s, %d %s, %d %s", --3 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s"] = "%d번째 공격! %d %s, %d %s, %d %s, %d %s", --4 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s, %d %s"] = "%d번째 공격! %d %s, %d %s, %d %s, %d %s, %d %s", --5 sets of mobs
	["%s in ~%d sec!"] = "%s 약 %d초 이내!",
	["Wave %d in ~%d sec!"] = "%d번째 공격! 약 %d초 이내",

	["Boss"] = "보스",
	["Thrall"] = "스랄",
	["Lady Jaina Proudmoore"] = "여군주 제이나 프라우드무어",

	["My companions and I are with you, Lady Proudmoore."] = "제 동료와 저는 프라우드무어님, 당신과 함께"..(UnitSex("player") == 3 and "" or " ").."하겠습니다.", -- Rage Winterchill
	["We are ready for whatever Archimonde might send our way, Lady Proudmoore."] = "아키몬드가 어떤 군대를 보내던 우리는 준비가 되어 있습니다, 프라우드무어 님.", -- Anatheron
	["I am with you, Thrall."] = "당신과 함께 하겠"..(UnitSex("player") == 3 and "어요" or "습니다")..", 대족장님.", -- Kaz'Rogal
	["We have nothing to fear."] = "두려워할 것은 아무것도 없"..(UnitSex("player") == 3 and "어요" or "습니다")..".", -- Az'Galor
	
	["Please remove BigWigs_WaveTimers, it is deprecated."] = "BigWigs_WaveTimers를 반대하므로, 이것을 제거하십시요.",

	["Ghouls"] = "구울",
	["Crypt Fiends"] = "지하마귀",
	["Abominations"] = "누더기골렘",
	["Necromancers"] = "어둠의 강령술사",
	["Banshees"] = "밴시",
	["Gargoyles"] = "가고일",
	["Frost Wyrm"] = "서리고룡",
	["Fel Stalkers"] = "지옥사냥개",
	["Infernals"] = "거대한 지옥불정령",
	
	["Ghoul"] = "구울",
} end )

L:RegisterTranslations("frFR", function() return {
	waves = "Avertissements des vagues",
	waves_desc = "Prévient quand la prochaine vague est susceptible d'arriver.",

	detail = "Avertissements détaillés",
	detail_desc = "Affiche des avertissements détaillés indiquant les monstres en approche.",

	["~%s spawn"] = "~Arrivée %s",
	["~Wave %d spawn"] = "~Arrivée %d|4ère:ème; vague",
	["Wave %d incoming!"] = "Arrivée de la %d|4ère:ème; vague !",
	["Wave %d! %d %s"] = "%d|4ère:ème; vague ! %d %s", --1 set of mobs
	["Wave %d! %d %s, %d %s"] = "%d|4ère:ème; vague ! %d %s, %d %s", --2 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s"] = "%d|4ère:ème; vague ! %d %s, %d %s, %d %s", --3 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s"] = "%d|4ère:ème; vague ! %d %s, %d %s, %d %s, %d %s", --4 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s, %d %s"] = "%d|4ère:ème; vague ! %d %s, %d %s, %d %s, %d %s, %d %s", --5 sets of mobs
	["%s in ~%d sec!"] = "%s dans ~%d sec. !",
	["Wave %d in ~%d sec!"] = "%d|4ère:ème; vague dans ~%d sec. !",

	["Boss"] = "Boss",
	["Thrall"] = "Thrall",
	["Lady Jaina Proudmoore"] = "Dame Jaina Portvaillant",

	["My companions and I are with you, Lady Proudmoore."] = "Mes compagnons et moi sommes à vos côtés, dame Portvaillant.", -- Rage Winterchill
	["We are ready for whatever Archimonde might send our way, Lady Proudmoore."] = "Nous sommes prêts à affronter tout ce qu'Archimonde pourra mettre sur notre chemin, dame Portvaillant.", -- Anatheron
	["I am with you, Thrall."] = "Je suis avec vous, Thrall.", -- Kaz'Rogal
	["We have nothing to fear."] = "Nous n'avons rien à craindre.", -- Az'Galor

	["Please remove BigWigs_WaveTimers, it is deprecated."] = "Veuillez enlever BigWigs_WaveTimers, qui est obsolète.",

	["Ghouls"] = "goules",
	["Crypt Fiends"] = "démons des cryptes",
	["Abominations"] = "abominations",
	["Necromancers"] = "nécromanciens",
	["Banshees"] = "banshees",
	["Gargoyles"] = "gargouilles",
	["Frost Wyrm"] = "wyrm de givre",
	["Fel Stalkers"] = "traqueurs gangrenés",
	["Infernals"] = "infernaux",

	["Ghoul"] = "Goule",
} end )

L:RegisterTranslations("deDE", function() return {
	waves = "Wellen",
	waves_desc = "Zeigt Warnungen für die nächste Welle an.",

	detail = "Detaillierte Wellen",
	detail_desc = "Zeigt detaillierte Warnungen, welche Monster als nächstes kommen.",

	["~%s spawn"] = "~%s spawnt.",
	["~Wave %d spawn"] = "~Welle %d spawnt.",
	["Wave %d incoming!"] = "Welle %d kommt!",
	["Wave %d! %d %s"] = "Welle %d! %d %s", --1 set of mobs
	["Wave %d! %d %s, %d %s"] = "Welle %d! %d %s, %d %s", --2 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s"] = "Welle %d! %d %s, %d %s, %d %s", --3 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s"] = "Welle %d! %d %s, %d %s, %d %s, %d %s", --4 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s, %d %s"] = "Welle %d! %d %s, %d %s, %d %s, %d %s, %d %s", --5 sets of mobs
	["%s in ~%d sec!"] = "%s in ~%d sek!",
	["Wave %d in ~%d sec!"] = "Welle %d in ~%d sek!",

	["Boss"] = "Boss",
	["Thrall"] = "Thrall",
	["Lady Jaina Proudmoore"] = "Lady Jaina Prachtmeer",

	["My companions and I are with you, Lady Proudmoore."] = "Meine Gefährten und ich werden Euch zur Seite stehen, Lady Prachtmeer.", -- Rage Winterchill
	["We are ready for whatever Archimonde might send our way, Lady Proudmoore."] = "Was auch immer Archimonde gegen uns ins Feld schicken mag, wir sind bereit, Lady Prachtmeer.", -- Anatheron
	["I am with you, Thrall."] = "Ich werde Euch zur Seite stehen, Thrall!", -- Kaz'Rogal
	["We have nothing to fear."] = "Wir haben nichts zu befürchten.", -- Az'Galor

	["Please remove BigWigs_WaveTimers, it is deprecated."] = "Bitte entferne BigWigs_WaveTimers, es ist veraltet.",

	["Ghouls"] = "Ghule",
	["Crypt Fiends"] = "Gruftscheusale",
	["Abominations"] = "Monstrositäten",
	["Necromancers"] = "Nekromanten",
	["Banshees"] = "Banshees",
	["Gargoyles"] = "Gargoyles",
	["Frost Wyrm"] = "Frostwyrm",
	["Fel Stalkers"] = "Teufelshunde",
	["Infernals"] = "Höllenbestien",
} end )

L:RegisterTranslations("zhCN", function() return {
	waves = "阶段警报",
	waves_desc = "通告下一波来临警报信息。",

	detail = "详细警报",
	detail_desc = "怪物到来时显示详细警报。",

	["~%s spawn"] = "%s 出现！",
	["~Wave %d spawn"] = "第%d波 出现！",
	["Wave %d incoming!"] = "第%d波 来临！",
	["Wave %d! %d %s"] = "第%d波：%d个%s！", --1 set of mobs
	["Wave %d! %d %s, %d %s"] = "第%d波：%d个%s，%d个%s！", --2 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s"] = "第%d波：%d个%s，%d个%s，%d个%s！", --3 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s"] = "第%d波：%d个%s，%d个%s，%d个%s，%d个%s！", --4 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s, %d %s"] = "第%d波：%d个%s，%d个%s，%d个%s，%d个%s，%d个%s！", --5 sets of mobs
	["%s in ~%d sec!"] = "%s 在约%d秒后来临！",
	["Wave %d in ~%d sec!"] = "第%d波！将在约%d秒后来临！",

	["Boss"] = "首领",
	["Thrall"] = "萨尔",
	["Lady Jaina Proudmoore"] = "吉安娜·普罗德摩尔",

	["My companions and I are with you, Lady Proudmoore."] = "我和我的伙伴们将与您并肩作战，普罗德摩尔女士。", -- Rage Winterchill
	["We are ready for whatever Archimonde might send our way, Lady Proudmoore."] = "我们已经准备好对付阿克蒙德的任何爪牙了，普罗德摩尔女士。", -- Anatheron
	["I am with you, Thrall."] = "我与你并肩作战，萨尔。", -- Kaz'Rogal
	["We have nothing to fear."] = "我们无所畏惧。", -- Az'Galor

	["Please remove BigWigs_WaveTimers, it is deprecated."] = "请移除 BigWigs_WaveTimers， 此插件已经失效了。",

	["Ghouls"] = "食尸鬼",
	["Crypt Fiends"] = "地穴恶魔",
	["Abominations"] = "憎恶",
	["Necromancers"] = "阴暗通灵师",
	["Banshees"] = "女妖",
	["Gargoyles"] = "石像鬼",
	["Frost Wyrm"] = "冰霜巨龙",
	["Fel Stalkers"] = "恶魔猎犬",
	["Infernals"] = "地狱火",

	["Ghoul"] = "食尸鬼",
} end )

L:RegisterTranslations("zhTW", function() return {
	waves = "階段警報",
	waves_desc = "通報下一波小怪來臨訊息",

	detail = "詳細警報",
	detail_desc = "通告各波次怪物詳細訊息。",

	["~%s spawn"] = "~%s 出現！",
	["~Wave %d spawn"] = "第 %d 波出現！",
	["Wave %d incoming!"] = "第 %d 波即將來臨！",
	["Wave %d! %d %s"] = "第 %d 波：%d %s！", --1 set of mobs
	["Wave %d! %d %s, %d %s"] = "第 %d 波：%d %s、%d %s！", --2 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s"] = "第 %d 波：%d %s、%d %s、%d %s！", --3 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s"] = "第 %d 波：%d %s、%d %s、%d %s、%d %s！", --4 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s, %d %s"] = "第 %d 波：%d %s、%d %s、%d %s、%d %s、%d %s！", --5 sets of mobs
	["%s in ~%d sec!"] = "%s 約 %d 秒後來臨!",
	["Wave %d in ~%d sec!"] = "第 %d 波約 %d 秒後來臨!",

	["Boss"] = "首領",
	["Thrall"] = "索爾",
	["Lady Jaina Proudmoore"] = "珍娜·普勞德摩爾女士",

	["My companions and I are with you, Lady Proudmoore."] = "我和我的同伴都與你同在，普勞德摩爾女士。", -- Rage Winterchill
	["We are ready for whatever Archimonde might send our way, Lady Proudmoore."] = "不管阿克蒙德要派誰來對付我們，我們都已經準備好了，普勞德摩爾女士。", -- Anatheron
	["I am with you, Thrall."] = "我與你同在，索爾。", -- Kaz'Rogal
	["We have nothing to fear."] = "我們無所畏懼。", -- Az'Galor
	["Please remove BigWigs_WaveTimers, it is deprecated."] = "請移除 BigWigs_WaveTimer，他已經過期了。",

	["Ghouls"] = "食屍鬼",
	["Crypt Fiends"] = "地穴捕獵者",
	["Abominations"] = "憎惡",
	["Necromancers"] = "幽暗的死靈法師",--is from combatlog,is true
	["Banshees"] = "女妖",
	["Gargoyles"] = "石像鬼",
	["Frost Wyrm"] = "冰龍",
	["Fel Stalkers"] = "惡魔捕獵者",
	["Infernals"] = "巨型地獄火",

} end )
-- Translated by wow.playhard.ru translators
L:RegisterTranslations("ruRU", function() return {
	waves = "Wave Warnings",
	waves_desc = "Announce approximate warning messages for the next wave.",

	detail = "Detailed Warnings",
	detail_desc = "Show detailed warnings of what mobs are incoming.",

	["~%s spawn"] = "~до прихода %s",
	["~Wave %d spawn"] = "~до прихода %d волны",
	["Wave %d incoming!"] = "Идет %d волна!",
	["Wave %d! %d %s"] = "%d волна! %d %s", --1 set of mobs
	["Wave %d! %d %s, %d %s"] = "%d волна! %d %s, %d %s", --2 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s"] = "%d волна! %d %s, %d %s, %d %s", --3 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s"] = "%d волна! %d %s, %d %s, %d %s, %d %s", --4 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s, %d %s"] = "%d волна! %d %s, %d %s, %d %s, %d %s, %d %s", --5 sets of mobs
	["%s in ~%d sec!"] = "%s через ~%d сек!",
	["Wave %d in ~%d sec!"] = "%d волна через ~%d сек!",

	["Boss"] = "Босс",
	["Thrall"] = "Тралл",
	["Lady Jaina Proudmoore"] = "Леди Джайна Праудмур",

	["My companions and I are with you, Lady Proudmoore."] = "Мои спутники и я – с вами, леди Праудмур.", -- Rage Winterchill
	["We are ready for whatever Archimonde might send our way, Lady Proudmoore."] = "Мы готовы встретить любого, кого пошлет Архимонд, леди Праудмур.", -- Anatheron
	["I am with you, Thrall."] = "Я с тобой, Тралл.", -- Kaz'Rogal
	["We have nothing to fear."] = "Нам нечего бояться.", -- Az'Galor

	["Please remove BigWigs_WaveTimers, it is deprecated."] = "Please remove BigWigs_WaveTimers, it is deprecated.",

	["Ghouls"] = "Вурдалаков",
	["Crypt Fiends"] = "Некрорахнидов",
	["Abominations"] = "Поганищ",
	["Necromancers"] = "Мрачных некроманта", -- 6 некромантов, но 2 некроманта
	["Banshees"] = "Банши",
	["Gargoyles"] = "Горгулии", -- не используем "и" краткую, а потому без разницы, 10 гаргулии или 2 гаргулии
	["Frost Wyrm"] = "Ледяная змея", -- она всегда одна!
	["Fel Stalkers"] = "Ловчих Скверны", -- 2,4,6 ловчих скверны
	["Infernals"] = "Инферналов", -- в 3,4,7 волнах по 8 инферналов

	["Ghoul"] = "Вурдалак",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local thrall = L["Thrall"]
local proudmoore = L["Lady Jaina Proudmoore"]

local mod = BigWigs:NewModule(name)
mod.zonename = name
mod.enabletrigger = { thrall, proudmoore, L["Ghoul"] }
mod.toggleoptions = {"waves", "detail"}
mod.revision = tonumber(match("$Revision$", "%d+"))
mod.synctoken = "Hyjal Summit"

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	currentWave = 0
	nextBoss = L["Boss"]
	waveBar = ""
	self:RegisterEvent("UPDATE_WORLD_STATES")
	self:RegisterEvent("GOSSIP_SHOW")
	self:RegisterEvent("QUEST_PROGRESS", "GOSSIP_SHOW")

	self:AddCombatListener("UNIT_DIED", "Deaths")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "HSWave", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "SummitNext", 2)
--~ 	throttling these 2 will cause an errant 'wave 1' message when thrall/jaina die
--~ 	self:TriggerEvent("BigWigs_ThrottleSync", "SummitReset", 2)
--~ 	self:TriggerEvent("BigWigs_ThrottleSync", "SummitClear", 2)
	if IsAddOnLoaded("BigWigs_WaveTimers") then
		BigWigs:Print(L["Please remove BigWigs_WaveTimers, it is deprecated."])
	end
end

function mod:GOSSIP_SHOW()
	local target = UnitName("target")
	local gossip = GetGossipOptions()
	if gossip and (target == thrall or target == proudmoore) then
		if gossip == L["My companions and I are with you, Lady Proudmoore."] then
			self:Sync("SummitNext RWC") -- Rage Winterchill is next
		elseif gossip == L["We are ready for whatever Archimonde might send our way, Lady Proudmoore."] then
			self:Sync("SummitNext Anatheron") -- Anetheron is next
		elseif gossip == L["I am with you, Thrall."] then
			self:Sync("SummitNext KazRogal") -- Kaz'Rogal is next
		elseif gossip == L["We have nothing to fear."] then
			self:Sync("SummitNext AzGalor") -- Az'Galor is next
		end
	end
end

function mod:UPDATE_WORLD_STATES()
	if self.zonename ~= GetRealZoneText() then return end -- bail out in case we were left running in another zone
	local text = select(3, GetWorldStateUIInfo(3))
	local num = tonumber(match(text or "", "(%d)") or nil)
	if num == 0 then 
		self:Sync("SummitClear") --reseting wave here will clear nextBoss, clear instead
	elseif num and num > currentWave then 
		local zone = GetSubZoneText()
		if zone == allianceBase then zone = "alliance"
		elseif zone == hordeEncampment then zone = "horde"
		else return end
		self:Sync(fmt("%s%d %s", "HSWave ", num, zone))
		if nextBoss then
			if nextBoss == winterchill then
				self:Sync("SummitNext RWC")
			elseif nextBoss == anetheron then
				self:Sync("SummitNext Anatheron")
			elseif nextBoss == kazrogal then
				self:Sync("SummitNext KazRogal")
			elseif nextBoss == azgalor then
				self:Sync("SummitNext AzGalor")
			end
		end
	end
end

function mod:Deaths(unit)
	if unit == L["Thrall"] or unit == L["Lady Jaina Proudmoore"] then
		self:Sync("SummitReset")
	end
end

local ghoul, fiend, abom, necro, banshee, garg, wyrm, fel, infernal, one, two, three, four, five
function mod:BigWigs_RecvSync( sync, rest )
	if not self.db.profile.waves then return end

	if sync == "SummitNext" and rest then
		if rest == "RWC" then
			nextBoss = winterchill
		elseif rest == "Anatheron" then
			nextBoss = anetheron
		elseif rest == "KazRogal" then
			nextBoss = kazrogal
		elseif rest == "AzGalor" then
			nextBoss = azgalor
		end
	elseif sync == "BWBossDeath" and rest then
		if rest == "Rage Winterchill" then
			nextBoss = anetheron
		elseif rest == "Anetheron" then
			nextBoss = kazrogal
		elseif rest == "Kaz'rogal" then
			nextBoss = azgalor
		elseif rest == "Archimonde" then
			BigWigs:ToggleModuleActive(self, false)
		end
	elseif sync == "HSWave" and rest then
		local wave, zone = match(rest, "(%d+) (.*)")
		if not wave or not zone then return end
		local waveTimes
		if zone == "alliance" then
			if nextBoss == winterchill then
				waveTimes = RWCwaveTimes
			else
				waveTimes = allianceWaveTimes
			end
		elseif zone == "horde" then
			if nextBoss == kazrogal then
				waveTimes = KRwaveTimes
			else
				waveTimes = hordeWaveTimes
			end
		else
			return
		end
		wave = tonumber(wave)
		if wave and wave > currentWave and waveTimes[wave] then
			currentWave = wave

			if self.db.profile.detail then
				if not store then
					ghoul = L["Ghouls"]
					fiend = L["Crypt Fiends"]
					abom = L["Abominations"]
					necro = L["Necromancers"]
					banshee = L["Banshees"]
					garg = L["Gargoyles"]
					wyrm = L["Frost Wyrm"]
					fel = L["Fel Stalkers"]
					infernal = L["Infernals"]
					one = L["Wave %d! %d %s"]
					two = L["Wave %d! %d %s, %d %s"]
					three = L["Wave %d! %d %s, %d %s, %d %s"]
					four = L["Wave %d! %d %s, %d %s, %d %s, %d %s"]
					five = L["Wave %d! %d %s, %d %s, %d %s, %d %s, %d %s"]

					store = true
				end

				if nextBoss == winterchill then
					if wave == 1 then
						self:Message(fmt(one, wave, 10, ghoul), "Important")
					elseif wave == 2 then
						self:Message(fmt(two, wave, 10, ghoul, 2, fiend), "Important")
					elseif wave == 3 then
						self:Message(fmt(two, wave, 6, ghoul, 6, fiend), "Important")
					elseif wave == 4 then
						self:Message(fmt(three, wave, 6, ghoul, 4, fiend, 2, necro), "Important")
					elseif wave == 5 then
						self:Message(fmt(three, wave, 2, ghoul, 6, fiend, 4, necro), "Important")
					elseif wave == 6 then
						self:Message(fmt(two, wave, 6, ghoul, 6, abom), "Important")
					elseif wave == 7 then
						self:Message(fmt(three, wave, 4, ghoul, 4, necro, 4, abom), "Important")
					elseif wave == 8 then
						self:Message(fmt(four, wave, 6, ghoul, 4, fiend, 2, abom, 2, necro), "Important")
					end
				elseif nextBoss == anetheron then
					if wave == 1 then
						self:Message(fmt(one, wave, 10, ghoul), "Important")
					elseif wave == 2 then
						self:Message(fmt(two, wave, 4, abom, 8, ghoul), "Important")
					elseif wave == 3 then
						self:Message(fmt(three, wave, 4, necro, 4, fiend, 4, ghoul), "Important")
					elseif wave == 4 then
						self:Message(fmt(three, wave, 2, banshee, 6, fiend, 4, necro), "Important")
					elseif wave == 5 then
						self:Message(fmt(three, wave, 6, ghoul, 2, necro, 4, banshee), "Important")
					elseif wave == 6 then
						self:Message(fmt(three, wave, 2, abom, 4, necro, 6, ghoul), "Important")
					elseif wave == 7 then
						self:Message(fmt(four, wave, 4, abom, 4, fiend, 2, banshee, 2, ghoul), "Important")
					elseif wave == 8 then
						self:Message(fmt(five, wave, 4, abom, 3, fiend, 2, banshee, 2, necro, 3, ghoul), "Important")
					end
				elseif nextBoss == kazrogal then
					if wave == 1 then
						self:Message(fmt(four, wave, 4, abom, 2, banshee, 4, ghoul, 2, necro), "Important")
					elseif wave == 2 then
						self:Message(fmt(two, wave, 4, ghoul, 10, garg), "Important")
					elseif wave == 3 then
						self:Message(fmt(three, wave, 6, fiend, 2, necro, 6, ghoul), "Important")
					elseif wave == 4 then
						self:Message(fmt(three, wave, 6, garg, 6, fiend, 2, necro), "Important")
					elseif wave == 5 then
						self:Message(fmt(three, wave, 4, ghoul, 4, necro, 6, abom), "Important")
					elseif wave == 6 then
						self:Message(fmt(two, wave, 8, garg, 1, wyrm), "Important")
					elseif wave == 7 then
						self:Message(fmt(three, wave, 6, ghoul, 4, abom, 1, wyrm), "Important")
					elseif wave == 8 then
						self:Message(fmt(five, wave, 6, ghoul, 2, fiend, 2, necro, 4, abom, 2, banshee), "Important")
					end
				elseif nextBoss == azgalor then
					if wave == 1 then
						self:Message(fmt(two, wave, 6, abom, 6, necro), "Important")
					elseif wave == 2 then
						self:Message(fmt(three, wave, 5, ghoul, 8, garg, 1, wyrm), "Important")
					elseif wave == 3 then
						self:Message(fmt(two, wave, 6, ghoul, 8, infernal), "Important")
					elseif wave == 4 then
						self:Message(fmt(two, wave, 6, fel, 8, infernal), "Important")
					elseif wave == 5 then
						self:Message(fmt(three, wave, 4, abom, 6, fel, 4, necro), "Important")
					elseif wave == 6 then
						self:Message(fmt(two, wave, 6, necro, 6, banshee), "Important")
					elseif wave == 7 then
						self:Message(fmt(four, wave, 2, ghoul, 2, fiend, 2, fel, 8, infernal), "Important")
					elseif wave == 8 then
						self:Message(fmt(five, wave, 4, fiend, 2, necro, 4, abom, 2, banshee, 4, fel), "Important")
					end
				else
					self:Message(fmt(L["Wave %d incoming!"], wave), "Important")
				end
			else
				self:Message(fmt(L["Wave %d incoming!"], wave), "Important")
			end

			self:CancelScheduledEvent("BigWigsSummitTimersDM90")
			self:CancelScheduledEvent("BigWigsSummitTimersDM60")
			self:CancelScheduledEvent("BigWigsSummitTimersDM30")
			self:TriggerEvent("BigWigs_StopBar", self, waveBar )
			-- self:TriggerEvent("BigWigs_StopBar", self, fmt(L["~Wave %d spawn"], currentWave))

			local wtime = waveTimes[wave]
			if wave == 8 then
				local msg = L["%s in ~%d sec!"]
				self:ScheduleEvent("BigWigsSummitTimersDM90", "BigWigs_Message", wtime - 90, fmt(msg, nextBoss, 90), "Attention")
				self:ScheduleEvent("BigWigsSummitTimersDM60", "BigWigs_Message", wtime - 60, fmt(msg, nextBoss, 60), "Attention")
				self:ScheduleEvent("BigWigsSummitTimersDM30", "BigWigs_Message", wtime - 30, fmt(msg, nextBoss, 30), "Urgent")
				waveBar = fmt(L["~%s spawn"], nextBoss)
				self:Bar(waveBar, wtime, "Spell_Fire_FelImmolation")
			else
				local msg = L["Wave %d in ~%d sec!"]
				self:ScheduleEvent("BigWigsSummitTimersDM90", "BigWigs_Message", wtime - 90, fmt(msg, wave + 1, 90), "Attention")
				self:ScheduleEvent("BigWigsSummitTimersDM60", "BigWigs_Message", wtime - 60, fmt(msg, wave + 1, 60), "Attention")
				self:ScheduleEvent("BigWigsSummitTimersDM30", "BigWigs_Message", wtime - 30, fmt(msg, wave + 1, 30), "Urgent")
				waveBar = fmt(L["~Wave %d spawn"], wave + 1)
				self:Bar(waveBar, wtime, "Spell_Holy_Crusade")
			end
		end
	elseif sync == "SummitReset" then
		self:TriggerEvent("BigWigs_RebootModule", self)
	elseif sync == "SummitClear" then
		--not sure how to cancel bars since they have different names
		self:TriggerEvent("BigWigs_StopBar", self, waveBar)
		currentWave = 0
		self:CancelScheduledEvent("BigWigsSummitTimersDM90")
		self:CancelScheduledEvent("BigWigsSummitTimersDM60")
		self:CancelScheduledEvent("BigWigsSummitTimersDM30")
	end
end

