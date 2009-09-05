--------------------------------------------------------------------------------
-- Module Declaration
--
local boss = BB["Faction Champions"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.zoneName = BZ["Trial of the Crusader"]
mod.toggleOptions = {65960, 65801, 65877, 66010, 65947, 67514, 67777, 65983, 65980, "bosskill"}
mod.consoleCmd = "Champions"

--------------------------------------------------------------------------------
-- Localization
--

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	enable_trigger = "The next battle will be against the Argent Crusade's most powerful knights! Only by defeating them will you be deemed worthy...",
	defeat_trigger = "A shallow and tragic victory.",

	["Shield on %s!"] = true,
	["Bladestorming!"] = true,
	["Hunter pet up!"] = true,
	["Felhunter up!"] = true,
	["Heroism on champions!"] = true,
	["Bloodlust on champions!"] = true,
} end)
L:RegisterTranslations("koKR", function() return {
	enable_trigger = "다음 전투는 은빛십자군에서 가장 센 기사들을 상대해야 하네... 그들을 이겨야만 자신의 가치를 인정받을 걸세.",
	defeat_trigger = "상처뿐인 승리로군.",

	["Shield on %s!"] = "기사무적: %s!",
	["Bladestorming!"] = "칼날폭풍!",
	["Hunter pet up!"] = "냥꾼 야수 소환!",
	["Felhunter up!"] = "지옥사냥개 소환!",
	["Heroism on champions!"] = "용사 영웅심!",
	["Bloodlust on champions!"] = "용사 피의 욕망!",
} end)
L:RegisterTranslations("frFR", function() return {
	enable_trigger = "La prochaine bataille sera contre les chevaliers les plus puissants de la Croisade d'argent ! Ce n'est qu'après les avoir vaincus que vous serez déclarés dignes…",
	defeat_trigger = "Une victoire tragique et dépourvue de sens.",

	["Shield on %s!"] = "Bouclier sur %s !",
	["Bladestorming!"] = "Tempête de lames !",
	["Hunter pet up!"] = "Familier du chasseur revenu !",
	["Felhunter up!"] = "Chasseur corrompu réinvoqué !",
	["Heroism on champions!"] = "Héroïsme sur les champions !",
	["Bloodlust on champions!"] = "Furie sanguinaire sur les champions !",
} end)
L:RegisterTranslations("deDE", function() return {
	enable_trigger = "Der nächste Kampf wird gegen die stärksten Ritter des Argentumkreuzzugs ausgefochten! Nur der Sieg wird Euren...",
	--defeat_trigger = "A shallow and tragic victory. We are weaker as a whole from the losses suffered today. Who but the Lich King could benefit from such foolishness? Great warriors have lost their lives. And for what? The true threat looms ahead - the Lich King awaits us all in death.",

	["Shield on %s!"] = "Schild: %s!",
	["Bladestorming!"] = "Klingensturm!",
	["Hunter pet up!"] = "Jäger Pet da!",
	["Felhunter up!"] = "Teufelsjäger da!",
	["Heroism on champions!"] = "Heldentum auf Champions!",
	["Bloodlust on champions!"] = "Kampfrausch auf Champions!",
} end)
L:RegisterTranslations("zhCN", function() return {
--	enable_trigger = "The next battle will be against the Argent Crusade's most powerful knights! Only by defeating them will you be deemed worthy...",
--	defeat_trigger = "A shallow and tragic victory. We are weaker as a whole from the losses suffered today. Who but the Lich King could benefit from such foolishness? Great warriors have lost their lives. And for what? The true threat looms ahead - the Lich King awaits us all in death.",

	["Shield on %s!"] = "圣盾术：>%s<！",
	["Bladestorming!"] = "剑刃风暴！",
	["Hunter pet up!"] = "召唤宠物！",
	["Felhunter up!"] = "召唤地狱猎犬！",
	["Heroism on champions!"] = "英勇！",
	["Bloodlust on champions!"] = "嗜血！",
} end)
L:RegisterTranslations("zhTW", function() return {
	enable_trigger = "The next battle will be against the Argent Crusade's most powerful knights! Only by defeating them will you be deemed worthy...",
	defeat_trigger = "膚淺而悲痛的勝利。今天痛失的生命反而令我們更加的頹弱。除了巫妖王之外，誰還能從中獲利?偉大的戰士失去了寶貴生命。為了什麼?真正的威脅就在前方 - 巫妖王在死亡的領域中等著我們。",

	["Shield on %s!"] = "聖盾術：>%s<！",
	["Bladestorming!"] = "劍刃風暴！",
	["Hunter pet up!"] = "呼喚寵物！",
	["Felhunter up!"] = "召喚惡魔獵犬！",
	["Heroism on champions!"] = "英勇氣概！",
	["Bloodlust on champions!"] = "嗜血術！",
} end)
L:RegisterTranslations("ruRU", function() return {
	enable_trigger = "В следующем бою вы встретитесь с могучими рыцарями Серебряного Авангарда! Лишь победив их, вы заслужите достойную награду.",
	defeat_trigger = "Пустая и горькая победа. После сегодняшних потерь мы стали слабее как целое. Кто еще, кроме Короля-лича, выиграет от подобной глупости? Пали великие воины. И ради чего? Истинная опасность еще впереди – нас ждет битва с  Королем-личом.",

	["Shield on %s!"] = "Щит на %s",
	["Bladestorming!"] = "Вихрь клинков!",
	["Hunter pet up!"] = "Охотник воскресил питомца!",
	["Felhunter up!"] = "Чернокнижник воскресил питомца!",
	["Heroism on champions!"] = "Героизм на чемпионах!",
	["Bloodlust on champions!"] = "Жажда крови на чемпионах!",
} end)

mod.enabletrigger = function() return L["enable_trigger"] end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Blind", 65960)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Polymorph", 65801)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Wyvern", 65877)
	self:AddCombatListener("SPELL_AURA_APPLIED", "DivineShield", 66010)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Bladestorm", 65947)
	self:AddCombatListener("SPELL_SUMMON", "Felhunter", 67514)
	self:AddCombatListener("SPELL_SUMMON", "Cat", 67777)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Heroism", 65983)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Bloodlust", 65980)

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Wyvern(player, spellId, _, _, spellName)
	self:TargetMessage(spellName, player, "Attention", spellId)
end

function mod:Blind(player, spellId, _, _, spellName)
	self:TargetMessage(spellName, player, "Attention", spellId)
end

function mod:Polymorph(player, spellId, _, _, spellName)
	self:TargetMessage(spellName, player, "Attention", spellId)
end

function mod:DivineShield(player, spellId)
	self:IfMessage(L["Shield on %s!"]:format(player), "Urgent", spellId)
end

function mod:Bladestorm(player, spellId)
	self:IfMessage(L["Bladestorming!"], "Important", spellId)
end

function mod:Cat(player, spellId)
	self:IfMessage(L["Hunter pet up!"], "Urgent", spellId)
end

function mod:Felhunter(player, spellId)
	self:IfMessage(L["Felhunter up!"], "Urgent", spellId)
end

function mod:Heroism(player, spellId)
	self:IfMessage(L["Heroism on champions!"], "Important", spellId)
end

function mod:Bloodlust(player, spellId)
	self:IfMessage(L["Bloodlust on champions!"], "Important", spellId)
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["defeat_trigger"]) then
		self:Sync("MultiDeath " .. self:ToString())
	end
end

