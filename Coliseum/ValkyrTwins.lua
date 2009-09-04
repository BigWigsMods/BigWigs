--------------------------------------------------------------------------------
-- Module Declaration
--

local boss = BB["The Twin Val'kyr"]
local eydis = BB["Eydis Darkbane"]
local fjola = BB["Fjola Lightbane"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Trial of the Crusader"]
mod.enabletrigger = { eydis, fjola }
mod.guid = 34496
--34496 Darkbane
--34497 Lightbane
mod.toggleOptions = {"vortex", "shield", "berserk", "touch", "bosskill"}
mod.consoleCmd = "Twins"

--------------------------------------------------------------------------------
-- Locals
--

local db = nil
local pName = UnitName("player")
local essenceLight = GetSpellInfo(67223)
local essenceDark = GetSpellInfo(67176)

--------------------------------------------------------------------------------
-- Localization
--

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	engage_trigger1 = "In the name of our dark master. For the Lich King. You. Will. Die.",	

	vortex_or_shield_cd = "Next Vortex or Shield",

	vortex = "Vortex",
	vortex_desc = "Warn when the twins start casting vortexes.",

	shield = "Shield of Darkness/Light",
	shield_desc = "Warn for Shield of Darkness/Light.",

	touch = "Touch of Darkness/Light",
	touch_desc = "Warn for Touch of Darkness/Light",
	touch_of_light_on_you = "Light on YOU",
	touch_of_light_on_other = "Light on %s",
	touch_of_dark_on_you = "Darkness on YOU",
	touch_of_dark_on_other = "Darkness on %s",
} end)
L:RegisterTranslations("koKR", function() return {
	engage_trigger1 = "어둠의 주인님을 받들어. 리치 왕을 위하여.",	--check

	vortex_or_shield_cd = "소용돌이/방패 대기시간",

	vortex = "소용돌이",
	vortex_desc = "쌍둥이의 소용돌이 시전을 알립니다.",

	shield = "어둠/빛의 방패",
	shield_desc = "어둠/빛의 방패를 알립니다.",

	touch = "어둠/빛의 손길",
	touch_desc = "어둠/빛의 손길을 알립니다.",
	touch_of_light_on_you = "당신은 빛의 손길!",
	touch_of_light_on_other = "빛의 손길: %s",
	touch_of_dark_on_you = "당신은 어둠의 손길!",
	touch_of_dark_on_other = "어둠의 손길: %s",
} end)
L:RegisterTranslations("frFR", function() return {
	engage_trigger1 = "Au nom de notre ténébreux maître. Pour le roi-liche. Vous. Allez. Mourir.",

	vortex_or_shield_cd = "Prochain Vortex ou Bouclier",

	vortex = "Vortex",
	vortex_desc = "Prévient quand les jumelles commencent à incanter des Vortex.",

	shield = "Bouclier des ténèbres/des lumières",
	shield_desc = "Prévient de l'arrivée des Boucliers des ténèbres/des lumières.",

	touch = "Toucher des ténèbres/de lumière",
	touch_desc = "Prévient quand un joueur subit les effets d'un Toucher des ténèbres ou de lumière.",
	touch_of_light_on_you = "Lumière sur VOUS !",
	touch_of_light_on_other = "Lumière sur %s",
	touch_of_dark_on_you = "Ténèbres sur VOUS !",
	touch_of_dark_on_other = "Ténèbres sur %s",
} end)
L:RegisterTranslations("deDE", function() return {
	engage_trigger1 = "Im Namen unseres dunklen Meisters. Für den Lichkönig. Ihr. Werdet. Sterben.",	

	vortex_or_shield_cd = "~Vortex/Schild",

	vortex = "Vortex",
	vortex_desc = "Warnt, wenn die Zwillinge anfangen Vortex zu wirken.",

	shield = "Schild der Nacht/Licht",
	shield_desc = "Warnt bei Schild der Nacht/Licht.",

	touch = "Berührung der Nacht/Licht",
	touch_desc = "Warnt bei Berührung der Nacht/Licht.",
	touch_of_light_on_you = "Berührung des Lichts auf DIR!",
	touch_of_light_on_other = "Berührung des Lichts: %s!",
	touch_of_dark_on_you = "Berührung der Nacht auf DIR!",
	touch_of_dark_on_other = "Berührung der Nacht: %s!",
	
} end)
L:RegisterTranslations("zhCN", function() return {
--	engage_trigger1 = "In the name of our dark master. For the Lich King. You. Will. Die.",	

	vortex_or_shield_cd = "<Vortex/Shield 冷却>",

	vortex = "Vortex",
	vortex_desc = "当双子开始施放Vortexes时发出警报。",

	shield = "Shield of Darkness/Light",
	shield_desc = "当施放Shield of Darkness/Light时发出警报。",

	touch = "Touch of Darkness/Light",
	touch_desc = "当玩家中了Touch of Darkness/Light时发出警报。",
	touch_of_light_on_you = ">你< Touch of Light！",
	touch_of_light_on_other = "Touch of Light：>%s<！",
	touch_of_dark_on_you = ">你< Touch of Darkness！",
	touch_of_dark_on_other = "Touch of Darkness：>%s<！",
} end)
L:RegisterTranslations("zhTW", function() return {
	engage_trigger1 = "以我們的黑暗君王之名。為了巫妖王。你‧得‧死。",	

	vortex_or_shield_cd = "<漩渦/盾 冷卻>",

	vortex = "漩渦",
	vortex_desc = "當華爾琪雙子開始施放漩渦時發出警報。",

	shield = "黑暗/光明之盾",
	shield_desc = "當施放黑暗/光明之盾時發出警報。",

	touch = "黑暗/光明之觸",
	touch_desc = "當玩家中了黑暗/光明之觸時發出警報。",
	touch_of_light_on_you = ">你< 光明之觸！",
	touch_of_light_on_other = "光明之觸：>%s<！",
	touch_of_dark_on_you = ">你< 黑暗之觸！",
	touch_of_dark_on_other = "黑暗之觸：>%s<！",
} end)
L:RegisterTranslations("ruRU", function() return {
} end)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "LightVortex", 66046, 67206, 67207, 67208)
	self:AddCombatListener("SPELL_CAST_START", "DarkVortex", 66058, 67182, 67183, 67184)
	self:AddCombatListener("SPELL_AURA_APPLIED", "DarkShield", 65874, 67256, 67257, 67258)
	self:AddCombatListener("SPELL_AURA_APPLIED", "LightShield", 65858, 67259, 67260, 67261)
	self:AddCombatListener("SPELL_AURA_APPLIED", "DarkTouch", 67281, 67282, 67283)
	self:AddCombatListener("SPELL_AURA_APPLIED", "LightTouch", 67296, 67297, 67298) 
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	db = self.db.profile
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:DarkTouch(_, spellId)
	if not db.touch then return end
	if player == pName then
		self:LocalMessage(L["touch_of_dark_on_you"], "Personal", spellId, "Info")
		self:WideMessage(L["touch_of_dark_on_other"]:format(player))
	else
		self:TargetMessage(L["touch_of_dark_on_other"], player, "Attention", spellId)
		self:Whisper(player, L["touch_of_dark_on_you"])
	end
end

function mod:LightTouch(_, spellId)
	if not db.touch then return end
	if player == pName then
		self:LocalMessage(L["touch_of_light_on_you"], "Personal", spellId, "Info")
		self:WideMessage(L["touch_of_light_on_other"]:format(player))
	else
		self:TargetMessage(L["touch_of_light_on_other"], player, "Attention", spellId)
		self:Whisper(player, L["touch_of_light_on_you"])
	end
end

function mod:DarkShield(_, spellId, _, _, spellName)
	if db.shield then
		self:Bar(L["vortex_or_shield_cd"], 45, 39089)
		local d = UnitDebuff("player", essenceDark)
		if d then
			self:LocalMessage(spellName, "Important", spellId, "Alert")
		else
			self:IfMessage(spellName, "Urgent", spellId)
		end
	end
end

function mod:LightShield(_, spellId, _, _, spellName)
	if db.shield then
		self:Bar(L["vortex_or_shield_cd"], 45, 39089)
		local d = UnitDebuff("player", essenceLight)
		if d then
			self:LocalMessage(spellName, "Important", spellId, "Alert")
		else
			self:IfMessage(spellName, "Urgent", spellId)
		end
	end
end

function mod:LightVortex(_, spellId, _, _, spellName)
	if db.vortex then
		self:Bar(L["vortex_or_shield_cd"], 45, 39089)
		local d = UnitDebuff("player", essenceDark)
		if not d then return end
		self:IfMessage(spellName, "Personal", spellId, "Alarm")
	end
end

function mod:DarkVortex(_, spellId, _, _, spellName)
	if db.vortex then
		self:Bar(L["vortex_or_shield_cd"], 45, 39089)
		local d = UnitDebuff("player", essenceLight)
		if not d then return end
		self:IfMessage(spellName, "Personal", spellId, "Alarm")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg, sender)
	if msg == L["engage_trigger1"] and sender == eydis then
		if db.shield or db.vortex then
			self:Bar(L["vortex_or_shield_cd"], 45, 39089)
		end
		if db.berserk then
			self:Enrage(540, true)
		end
	end
end

