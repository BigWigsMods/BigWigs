--------------------------------------------------------------------------------
-- Module Declaration
--

local boss = BB["The Twin Val'kyr"]
local eydis = BB["Eydis Darkbane"]
local fjola = BB["Fjola Lightbane"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.zoneName = BZ["Trial of the Crusader"]
mod.enabletrigger = { eydis, fjola }
mod.guid = 34496
--34496 Darkbane
--34497 Lightbane
mod.toggleOptions = {"vortex", "shield", "touch", "berserk", "bosskill"}
mod.consoleCmd = "Twins"

--------------------------------------------------------------------------------
-- Locals
--

local db = nil
local essenceLight = GetSpellInfo(67223)
local essenceDark = GetSpellInfo(67176)

--------------------------------------------------------------------------------
-- Localization
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Twin Val'kyr", "enUS", true)
if L then
	L.engage_trigger1 = "In the name of our dark master. For the Lich King. You. Will. Die."

	L.vortex_or_shield_cd = "Next Vortex or Shield"

	L.vortex = "Vortex"
	L.vortex_desc = "Warn when the twins start casting vortexes."

	L.shield = "Shield of Darkness/Light"
	L.shield_desc = "Warn for Shield of Darkness/Light."

	L.touch = "Touch of Darkness/Light"
	L.touch_desc = "Warn for Touch of Darkness/Light"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Twin Val'kyr")

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_CAST_START", "LightVortex", 66046, 67206, 67207, 67208)
	self:AddCombatListener("SPELL_CAST_START", "DarkVortex", 66058, 67182, 67183, 67184)
	self:AddCombatListener("SPELL_AURA_APPLIED", "DarkShield", 65874, 67256, 67257, 67258)
	self:AddCombatListener("SPELL_AURA_APPLIED", "LightShield", 65858, 67259, 67260, 67261)
	-- First 3 are dark, last 3 are light.
	self:AddCombatListener("SPELL_AURA_APPLIED", "Touch", 67281, 67282, 67283, 67296, 67297, 67298)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	db = self.db.profile
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Touch(player, spellId, _, _, spellName)
	if not db.touch then return end
	self:TargetMessage(spellName, player, "Personal", spellId, "Info")
	self:Whisper(player, spellName)
end

function mod:DarkShield(_, spellId, _, _, spellName)
	if db.shield then
		self:Bar(L["vortex_or_shield_cd"], 45, 39089)
		local d = UnitDebuff("player", essenceDark)
		if d then
			self:IfMessage(spellName, "Important", spellId, "Alert")
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
			self:IfMessage(spellName, "Important", spellId, "Alert")
		else
			self:IfMessage(spellName, "Urgent", spellId)
		end
	end
end

function mod:LightVortex(_, spellId, _, _, spellName)
	if db.vortex then
		self:Bar(L["vortex_or_shield_cd"], 45, 39089)
		local d = UnitDebuff("player", essenceDark)
		if d then
			self:IfMessage(spellName, "Positive", spellId)
		else
			self:IfMessage(spellName, "Personal", spellId, "Alarm")
		end
	end
end

function mod:DarkVortex(_, spellId, _, _, spellName)
	if db.vortex then
		self:Bar(L["vortex_or_shield_cd"], 45, 39089)
		local d = UnitDebuff("player", essenceLight)
		if d then
			self:IfMessage(spellName, "Positive", spellId)
		else
			self:IfMessage(spellName, "Personal", spellId, "Alarm")
		end
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

