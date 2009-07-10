--------------------------------------------------------------------------------
-- Module Declaration
--

local boss = BB["The Twin Val'kyr"]
local edyis = BB["Edyis Darkbane"]
local fjola = BB["Fjola Lightbane"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["The Argent Coliseum"]
mod.enabletrigger = { edyis, fjola }
mod.guid = 34496
--34496 Darkbane
--34497 Lightbane
mod.toggleoptions = {"vortex", "pact", "shield", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local essenceLight = GetSpellInfo(67223)
local essenceDark = GetSpellInfo(67176)

--------------------------------------------------------------------------------
-- Localization
--

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	cmd = "ValkyrTwins",

	engage_trigger1 = "In the name of our dark master. For the Lich King. You. Will. Die.",	
	
	vortex = "Vortex",
	vortex_desc = "Warn when the twins start casting Vortexes.",
	
	pact = "Twin's Pact",
	pact_desc = "Warn when the twins heal eachother.",
	
	pact_dark_message = "Darkbane healing!",
	pact_light_message = "Lightbane healing!",
	
	shield = "Shield of Darkness/Light",
	shield_desc = "Warn for Shield of Darkness/Light.",
	shield_light = "Shield of Light!",	
	shield_darkness = "Shield of Darkness!",
	
	--vortex_same_message = "Vortex", -- If the player has the same affliction, we don't need to say anything really
	vortex_light_message = "Light vortex!",
	vortex_dark_message = "Dark vortex!",
} end)
L:RegisterTranslations("koKR", function() return {
	engage_trigger1 = "In the name of our dark master. For the Lich King. You. Will. Die.",	--check
	
	vortex = "소용돌이",
	vortex_desc = "쌍둥이의 소용돌이 시전을 알립니다.",
	
	pact = "쌍둥이의 서약",
	pact_desc = "쌍둥이가 서로 치유시 알립니다.",
	
	pact_dark_message = "파멸의 암흑 치유!",	--check
	pact_light_message = "파멸의 빛 치유!",	--check
	
	shield = "어둠/빛의 방패",
	shield_desc = "어둠/빛의 방패를 알립니다.",
	shield_light = "빛의 방패!",	
	shield_darkness = "어둠의 방패!",
	
	--vortex_same_message = "Vortex", -- If the player has the same affliction, we don't need to say anything really
	vortex_light_message = "빛의 소용돌이!",
	vortex_dark_message = "어둠의 소용돌이!",
} end)
L:RegisterTranslations("frFR", function() return {
} end)
L:RegisterTranslations("deDE", function() return {
} end)
L:RegisterTranslations("zhCN", function() return {
} end)
L:RegisterTranslations("zhTW", function() return {
} end)
L:RegisterTranslations("ruRU", function() return {
} end)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "DarkPact", 67303)
	self:AddCombatListener("SPELL_CAST_START", "LightPact", 67306)
	self:AddCombatListener("SPELL_CAST_START", "LightVortex", 67206)
	self:AddCombatListener("SPELL_CAST_START", "DarkVortex", 67182)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Shield", 67257, 67260)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	--self:RegisterEvent("")
end
--[[
7/9 21:32:04.937  SPELL_CAST_SUCCESS,0x0100000000069322,"Zkygge",0x40514,0xF1300086C1001F13,"Fjola Lightbane",0x110a48,56222,"Dark Command",0x1
7/9 21:32:50.765  SPELL_CAST_START,0xF1300086C0001F14,"Eydis Darkbane",0x8000a48,0x0000000000000000,nil,0x80000000,67303,"Twin's Pact",0x20
7/9 21:34:20.312  SPELL_CAST_START,0xF1300086C1001F13,"Fjola Lightbane",0x100a48,0x0000000000000000,nil,0x80000000,67306,"Twin's Pact",0x40
7/9 21:36:35.562  SPELL_CAST_START,0xF1300086C0001F14,"Eydis Darkbane",0x8010a48,0x0000000000000000,nil,0x80000000,67303,"Twin's Pact",0x20
7/9 21:40:49.671  SPELL_CAST_START,0xF1300086C10032E2,"Fjola Lightbane",0x110a48,0x0000000000000000,nil,0x80000000,67306,"Twin's Pact",0x40
7/9 21:43:04.859  SPELL_CAST_START,0xF1300086C00032E3,"Eydis Darkbane",0xa48,0x0000000000000000,nil,0x80000000,67303,"Twin's Pact",0x20
2 minute CD on heal? Perhaps 1min from engage. Need transcript logs to verify.
]]

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Shield(_, spellID)
	if db.shield then
		if spellID == 67257 then
			self:IfMessage(L["shield_darkness"], "Attention", spellID)
		elseif spellID == 67260 then
			self:IfMessage(L["shield_light"], "Attention", spellID)
		end
	end
end

function mod:DarkPact(_, spellId)
	if not db.pact then return end
	self:IfMessage(L["pact_dark_message"], "Important", spellId)
end
function mod:LightPact(_, spellId)
	if not db.pact then return end
	self:IfMessage(L["pact_light_message"], "Important", spellId)
end

function mod:LightVortex(_, spellId)
	local d = UnitDebuff("player", essenceDark)
	if not d then return end
	self:IfMessage(L["vortex_light_message"], "Personal", spellId)
end

function mod:DarkVortex(_, spellId)
	local d = UnitDebuff("player", essenceLight)
	if not d then return end
	self:IfMessage(L["vortex_dark_message"], "Personal", spellId)
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger1"]) then

	end
end

