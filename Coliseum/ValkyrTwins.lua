--------------------------------------------------------------------------------
-- Module Declaration
--

local boss = BB["The Twin Val'kyr"]
local edyis = BB["Edyis Darkbane"]
local fjola = BB["Fjola Lightbane"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Trial of the Crusader"]
mod.otherMenu = "The Argent Coliseum"
mod.enabletrigger = { edyis, fjola }
mod.guid = 34496
--34496 Darkbane
--34497 Lightbane
mod.toggleoptions = {"vortex", "shield", "berserk", "touch", "bosskill"}

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
	cmd = "ValkyrTwins",

	engage_trigger1 = "In the name of our dark master. For the Lich King. You. Will. Die.",	

	vortex_or_shield_cd = "Vortex/Shield Cooldown",

	vortex = "Vortex",
	vortex_desc = "Warn when the twins start casting Vortexes.",

	shield = "Shield of Darkness/Light",
	shield_desc = "Warn for Shield of Darkness/Light.",
	shield_light = "Shield of Light!",
	shield_darkness = "Shield of Darkness!",

	--vortex_same_message = "Vortex", -- If the player has the same affliction, we don't need to say anything really
	vortex_light_message = "Light vortex!",
	vortex_dark_message = "Dark vortex!",

	touch = "Touch of Darkness/Light",
	touch_desc = "Warn for Touch of Darkness/Light",
	touch_of_light_on_you = "Touch of Light on You!",
	touch_of_light_on_other = "Touch of Light on %s",
	touch_of_dark_on_you = "Touch of Darkness on You!",
	touch_of_dark_on_other = "Touch of Darkness on %s",
} end)
L:RegisterTranslations("koKR", function() return {
	engage_trigger1 = "어둠의 주인님을 받들어",	--check

	vortex_or_shield_cd = "소용돌이/방패 대기시간",

	vortex = "소용돌이",
	vortex_desc = "쌍둥이의 소용돌이 시전을 알립니다.",

	shield = "어둠/빛의 방패",
	shield_desc = "어둠/빛의 방패를 알립니다.",
	shield_light = "빛의 방패!",	
	shield_darkness = "어둠의 방패!",

	--vortex_same_message = "Vortex", -- If the player has the same affliction, we don't need to say anything really
	vortex_light_message = "빛의 소용돌이!",
	vortex_dark_message = "어둠의 소용돌이!",

	touch = "어둠/빛의 손길",
	touch_desc = "어둠/빛의 손길을 알립니다.",
	touch_of_light_on_you = "당신은 빛의 손길!",
	touch_of_light_on_other = "빛의 손길: %s",
	touch_of_dark_on_you = "당신은 어둠의 손길!",
	touch_of_dark_on_other = "어둠의 손길: %s",
} end)
L:RegisterTranslations("frFR", function() return {
	engage_trigger1 = "Au nom de notre ténébreux maître. Pour le roi-liche. Vous. Allez. Mourir.",

	vortex_or_shield_cd = "Recharge Vortex/Bouclier",

	vortex = "Vortex",
	vortex_desc = "Prévient quand les jumelles commencent à incanter des Vortex.",

	shield = "Bouclier des ténèbres/des lumières",
	shield_desc = "Prévient de l'arrivée des Boucliers des ténèbres/des lumières.",
	shield_light = "Bouclier des lumières !",
	shield_darkness = "Bouclier des ténèbres !",

	--vortex_same_message = "Vortex", -- If the player has the same affliction, we don't need to say anything really
	vortex_light_message = "Vortex lumineux !",
	vortex_dark_message = "Vortex sombre !",

	touch = "Toucher des ténèbres/de lumière",
	touch_desc = "Prévient quand un joueur subit les effets d'un Toucher des ténèbres ou de lumière.",
	touch_of_light_on_you = "Toucher de lumière sur VOUS !",
	touch_of_light_on_other = "Toucher de lumière sur %s",
	touch_of_dark_on_you = "Toucher des ténèbres sur VOUS !",
	touch_of_dark_on_other = "Toucher des ténèbres sur %s",
} end)
L:RegisterTranslations("deDE", function() return {
} end)
L:RegisterTranslations("zhCN", function() return {
} end)
L:RegisterTranslations("zhTW", function() return {
	engage_trigger1 = "In the name of our dark master. For the Lich King. You. Will. Die.",	

	vortex_or_shield_cd = "Vortex/Shield Cooldown",

	vortex = "Vortex",
	vortex_desc = "Warn when the twins start casting Vortexes.",

	shield = "Shield of Darkness/Light",
	shield_desc = "Warn for Shield of Darkness/Light.",
	shield_light = "Shield of Light!",
	shield_darkness = "Shield of Darkness!",

	--vortex_same_message = "Vortex", -- If the player has the same affliction, we don't need to say anything really
	vortex_light_message = "Light vortex!",
	vortex_dark_message = "Dark vortex!",

	touch = "Touch of Darkness/Light",
	touch_desc = "Warn for Touch of Darkness/Light",
	touch_of_light_on_you = "Touch of Light on You!",
	touch_of_light_on_other = "Touch of Light on %s",
	touch_of_dark_on_you = "Touch of Darkness on You!",
	touch_of_dark_on_other = "Touch of Darkness on %s",
} end)
L:RegisterTranslations("ruRU", function() return {
} end)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "LightVortex", 67206, 67208)
	self:AddCombatListener("SPELL_CAST_START", "DarkVortex", 67182, 67184)
	self:AddCombatListener("SPELL_AURA_APPLIED", "DarkShield", 67257, 67258)
	self:AddCombatListener("SPELL_AURA_APPLIED", "LightShield", 67260, 67261) 
	self:AddCombatListener("SPELL_AURA_APPLIED", "DarkTouch", 67283) 
	self:AddCombatListener("SPELL_AURA_APPLIED", "LightTouch", 67298) 
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	db = self.db.profile
	--self:RegisterEvent("")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:DarkTouch(_, spellID)
	if db.touch then
		if player == pName then
			self:LocalMessage(L["touch_of_dark_on_you"], "Personal", spellID, "Alarm")
			self:WideMessage(L["touch_of_dark_on_other"]:format(player))
		else
			self:TargetMessage(L["touch_of_dark_on_other"], player, "Attention", spellID)
			self:Whisper(player, L["touch_of_dark_on_you"])
		end	
	end
end

function mod:LightTouch(_, spellID)
	if db.touch then
		if player == pName then
			self:LocalMessage(L["touch_of_light_on_you"], "Personal", spellID, "Alarm")
			self:WideMessage(L["touch_of_light_on_other"]:format(player))
		else
			self:TargetMessage(L["touch_of_light_on_other"], player, "Attention", spellID)
			self:Whisper(player, L["touch_of_light_on_you"])
		end	
	end
end

function mod:DarkShield(_, spellID)
	if db.shield then
		self:Bar(L["vortex_or_shield_cd"], 45, 39089)
		self:IfMessage(L["shield_darkness"], "Attention", spellID)
		local d = UnitDebuff("player", essenceDark)
		if not d then return end
		self:LocalMessage(L["shield_darkness"], "Important", spellID, "Alert")
	end
end

function mod:LightShield(_, spellID)
	if db.shield then
		self:Bar(L["vortex_or_shield_cd"], 45, 39089)
		self:IfMessage(L["shield_light"], "Attention", spellID)
		local d = UnitDebuff("player", essenceLight)
		if not d then return end
		self:LocalMessage(L["shield_light"], "Important", spellID, "Alert")
	end
end

function mod:LightVortex(_, spellId)
	if vortex then
		self:Bar(L["vortex_or_shield_cd"], 45, 39089)
		local d = UnitDebuff("player", essenceDark)
		if not d then return end
		self:IfMessage(L["vortex_light_message"], "Personal", spellId, "Alarm")
	end
end

function mod:DarkVortex(_, spellId)
	if vortex then
		self:Bar(L["vortex_or_shield_cd"], 45, 39089)
		local d = UnitDebuff("player", essenceLight)
		if not d then return end
		self:IfMessage(L["vortex_dark_message"], "Personal", spellId, "Alarm")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg, sender)
	if msg == L["engage_trigger1"] and sender == edyis then
		if db.shield or db.vortex then
			self:Bar(L["vortex_or_shield_cd"], 45, 39089)
		end
		if db.berserk then
			self:Enrage(360, true)
		end
	end
end
