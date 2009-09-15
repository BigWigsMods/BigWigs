--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("The Twin Val'kyr", "Trial of the Crusader")
if not mod then return end
-- 34496 Darkbane, 34497 Lightbane
mod.enabletrigger = { 34496, 34497 }
mod.toggleOptions = {"vortex", "shield", "touch", "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local essenceLight = GetSpellInfo(67223)
local essenceDark = GetSpellInfo(67176)
local started = nil
local difficulty = nil

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
	self:Death("Win", 34496, 34497)
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	
	difficulty = GetRaidDifficulty()
	started = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Touch(player, spellId, _, _, spellName)
	if not self.db.profile.touch then return end
	self:TargetMessage(spellName, player, "Personal", spellId, "Info")
	self:Whisper(player, spellName)
end

function mod:DarkShield(_, spellId, _, _, spellName)
	if self.db.profile.shield then
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
	if self.db.profile.shield then
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
	if self.db.profile.vortex then
		self:Bar(L["vortex_or_shield_cd"], 45, 39089)
		local d = UnitDebuff("player", essenceLight)
		if d then
			self:IfMessage(spellName, "Positive", spellId)
		else
			self:IfMessage(spellName, "Personal", spellId, "Alarm")
		end
	end
end

function mod:DarkVortex(_, spellId, _, _, spellName)
	if self.db.profile.vortex then
		self:Bar(L["vortex_or_shield_cd"], 45, 39089)
		local d = UnitDebuff("player", essenceDark)
		if d then
			self:IfMessage(spellName, "Positive", spellId)
		else
			self:IfMessage(spellName, "Personal", spellId, "Alarm")
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg, sender)
	if msg == L["engage_trigger1"] and not started then
		started = true
		if self.db.profile.shield or self.db.profile.vortex then
			self:Bar(L["vortex_or_shield_cd"], 45, 39089)
		end
		if self.db.profile.berserk then
			self:Berserk(difficulty > 2 and 360 or 540)
		end
	end
end

