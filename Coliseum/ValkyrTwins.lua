--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("The Twin Val'kyr", "Trial of the Crusader")
if not mod then return end
-- 34496 Darkbane, 34497 Lightbane
mod:RegisterEnableMob(34496, 34497)
mod.toggleOptions = {{"vortex", "FLASHSHAKE"}, "shield", "next", {"touch", "WHISPER", "FLASHSHAKE"}, "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local essenceLight = GetSpellInfo(67223)
local essenceDark = GetSpellInfo(67176)
local started = nil
local difficulty = nil
local pName = UnitName("player")

--------------------------------------------------------------------------------
-- Localization
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Twin Val'kyr", "enUS", true)
if L then
	L.engage_trigger1 = "In the name of our dark master. For the Lich King. You. Will. Die."

	L.vortex_or_shield_cd = "Next Vortex or Shield"
	L.next = "Next Vortex or Shield"
	L.next_desc = "Warn for next Vortex or Shield"
	
	L.vortex = "Vortex"
	L.vortex_desc = "Warn when the twins start casting vortexes."

	L.shield = "Shield of Darkness/Light"
	L.shield_desc = "Warn for Shield of Darkness/Light."

	L.touch = "Touch of Darkness/Light"
	L.touch_desc = "Warn for Touch of Darkness/Light"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Twin Val'kyr")
mod.locale = L

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "LightVortex", 66046, 67206, 67207, 67208)
	self:Log("SPELL_CAST_START", "DarkVortex", 66058, 67182, 67183, 67184)
	self:Log("SPELL_AURA_APPLIED", "DarkShield", 65874, 67256, 67257, 67258)
	self:Log("SPELL_AURA_APPLIED", "LightShield", 65858, 67259, 67260, 67261)
	-- First 3 are dark, last 3 are light.
	self:Log("SPELL_AURA_APPLIED", "Touch", 67281, 67282, 67283, 67296, 67297, 67298)
	
	self:Yell("Engage", L["engage_trigger1"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 34496)

	difficulty = GetRaidDifficulty()
	started = nil
end

function mod:OnEngage()
	if started then return end
	started = true
	self:Bar("next", L["vortex_or_shield_cd"], 45, 39089)
	self:Berserk(difficulty > 2 and 360 or 540)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Touch(player, spellId, _, _, spellName)
	self:TargetMessage("touch", spellName, player, "Personal", spellId, "Info")
	if pName == player then self:FlashShake("touch") end
	self:Whisper("touch", player, spellName)
end

function mod:DarkShield(_, spellId, _, _, spellName)
	self:Bar("shield", L["vortex_or_shield_cd"], 45, 39089)
	local d = UnitDebuff("player", essenceDark)
	if d then
		self:IfMessage("shield", spellName, "Important", spellId, "Alert")
	else
		self:IfMessage("shield", spellName, "Urgent", spellId)
	end
end

function mod:LightShield(_, spellId, _, _, spellName)
	self:Bar("shield", L["vortex_or_shield_cd"], 45, 39089)
	local d = UnitDebuff("player", essenceLight)
	if d then
		self:IfMessage("shield", spellName, "Important", spellId, "Alert")
	else
		self:IfMessage("shield", spellName, "Urgent", spellId)
	end
end

function mod:LightVortex(_, spellId, _, _, spellName)
	self:Bar("vortex", L["vortex_or_shield_cd"], 45, 39089)
	local d = UnitDebuff("player", essenceLight)
	if d then
		self:IfMessage("vortex", spellName, "Positive", spellId)
	else
		self:IfMessage("vortex", spellName, "Personal", spellId, "Alarm")
		self:FlashShake("vortex")
	end
end

function mod:DarkVortex(_, spellId, _, _, spellName)
	self:Bar("vortex", L["vortex_or_shield_cd"], 45, 39089)
	local d = UnitDebuff("player", essenceDark)
	if d then
		self:IfMessage("vortex", spellName, "Positive", spellId)
	else
		self:IfMessage("vortex", spellName, "Personal", spellId, "Alarm")
		self:FlashShake("vortex")
	end
end

