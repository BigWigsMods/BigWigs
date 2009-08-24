--------------------------------------------------------------------------------
-- Module Declaration
--
local boss = BB["Faction Champions"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Trial of the Crusader"]
mod.toggleOptions = {65960, 65801, 65877, 66010, 65947, 67514, 67777, 65983, 65980, "bosskill"}
mod.consoleCmd = "Champions"

--------------------------------------------------------------------------------
-- Localization
--

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	enable_trigger = "The next battle will be against the Argent Crusade's most powerful knights! Only by defeating them will you be deemed worthy...",
	defeat_trigger = "A shallow and tragic victory. We are weaker as a whole from the losses suffered today. Who but the Lich King could benefit from such foolishness? Great warriors have lost their lives. And for what? The true threat looms ahead - the Lich King awaits us all in death.",

	["Wyvern Sting on %s!"] = true,
	["Blind on %s!"] = true,
	["%s is sheeped!"] = true,
	["Shield on %s!"] = true,
	["Bladestorming!"] = true,
	["Hunter pet up!"] = true,
	["Felhunter up!"] = true,
	["Heroism on champions!"] = true,
	["Bloodlust on champions!"] = true,
} end)
L:RegisterTranslations("koKR", function() return {
	enable_trigger = "다음 전투는 은빛 십자군에서 가장 쌘 기사들을 상대해야 하네! 그들을 이겨야만 자신의 가치를 인정받을걸세...",	--check
	defeat_trigger = "상처뿐인 승리로군. 오늘 받은 손해로 우리 전력은 약해졌네. 이런 어리석은 짓으로 리치 왕 말고 또 누가 이득을 보겠나? 위대한 용사들이 목숨을 잃었네. 무엇을 위해서였나? 진짜 위협은 저 앞에 있네. 리치 왕이 우리 모두를 죽음 안에서 기다린다네.",
} end)
L:RegisterTranslations("frFR", function() return {
	enable_trigger = "La prochaine bataille sera contre les chevaliers les plus puissants de la Croisade d'argent ! Ce n'est qu'après les avoir vaincus que vous serez déclarés dignes...", -- à vérifier
	defeat_trigger = "Une victoire tragique et dépourvue de sens. La perte subie aujourd'hui nous affaiblira tous. Car qui d'autre que le roi-liche pourrait bénéficier d'une telle folie ? De grands guerriers ont perdus la vie. Et pour quoi ? La vraie menace plane à l'horizon - le roi-liche nous attend tous dans la mort.", -- à vérifier

	["Wyvern Sting on %s!"] = "Piqûre de wyverne sur %s !",
	["Blind on %s!"] = "Cécité sur %s !",
	["%s is sheeped!"] = "%s est métamorphosé !",
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
	
	["Wyvern Sting on %s!"] = "Stich des Flügeldrachen: %s!",
	["Blind on %s!"] = "Blenden: %s!",
	["%s is sheeped!"] = "Verwandlung: %s!",
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
} end)
L:RegisterTranslations("zhTW", function() return {
	enable_trigger = "The next battle will be against the Argent Crusade's most powerful knights! Only by defeating them will you be deemed worthy...",
	defeat_trigger = "A shallow and tragic victory. We are weaker as a whole from the losses suffered today. Who but the Lich King could benefit from such foolishness? Great warriors have lost their lives. And for what? The true threat looms ahead - the Lich King awaits us all in death.",
} end)
L:RegisterTranslations("ruRU", function() return {
} end)

mod.enabletrigger = function() return L["enable_trigger"] end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnEnable()
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

function mod:Wyvern(player, spellId)
	self:TargetMessage(L["Wyvern Sting on %s!"], player, "Attention", spellId)
end

function mod:Blind(player, spellId)
	self:TargetMessage(L["Blind on %s!"], player, "Attention", spellId)
end

function mod:Polymorph(player, spellId)
	self:TargetMessage(L["%s is sheeped!"], player, "Attention", spellId)
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
	if msg == L["defeat_trigger"] then
		self:Sync("BossDeath " .. self:ToString())
	end
end

