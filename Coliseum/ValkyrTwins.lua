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
local currentShieldStrength = nil
local shieldStrengthMap = {
	[67261] = 1200000,
	[67258] = 1200000,
	[67256] = 700000,
	[67259] = 700000,
	[67257] = 300000,
	[67260] = 300000,
	[65858] = 175000,
	[65874] = 175000,
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger1 = "In the name of our dark master. For the Lich King. You. Will. Die."

	L.vortex_or_shield_cd = "Next Vortex or Shield"
	L.next = "Next Vortex or Shield"
	L.next_desc = "Warn for next Vortex or Shield"

	L.vortex = "Vortex"
	L.vortex_desc = "Warn when the twins start casting vortexes."

	L.shield = "Shield of Darkness/Light"
	L.shield_desc = "Warn for Shield of Darkness/Light."
	L.shield_half_message = "Shield at 50% strength!"
	L.shield_left_message = "%d%% shield strength left"

	L.touch = "Touch of Darkness/Light"
	L.touch_desc = "Warn for Touch of Darkness/Light"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "LightVortex", 66046, 67206, 67207, 67208)
	self:Log("SPELL_CAST_START", "DarkVortex", 66058, 67182, 67183, 67184)
	self:Log("SPELL_AURA_APPLIED", "DarkShield", 65874, 67256, 67257, 67258)
	self:Log("SPELL_AURA_APPLIED", "LightShield", 65858, 67259, 67260, 67261)
	self:Log("SPELL_CAST_START", "HealStarted", 67303, 65875, 65876, 67304, 67305, 67306, 67307, 67308)
	self:Log("SPELL_HEAL", "Healed", 67303, 65875, 65876, 67304, 67305, 67306, 67307, 67308)
	-- First 3 are dark, last 3 are light.
	self:Log("SPELL_AURA_APPLIED", "Touch", 67281, 67282, 67283, 67296, 67297, 67298)

	self:Yell("Engage", L["engage_trigger1"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 34496)

	started = nil
end

function mod:OnEngage(diff)
	if started then return end
	started = true
	self:Bar("next", L["vortex_or_shield_cd"], 45, 39089)
	self:Berserk(diff > 2 and 360 or 480)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local damageDone = nil
	local halfWarning = nil
	local twin = nil
	local f = nil
	local heals = {
		[67303] = true,
		[65875] = true,
		[65876] = true,
		[67304] = true,
		[67305] = true,
		[67306] = true,
		[67307] = true,
		[67308] = true,
	}

	local function stop()
		if f then f:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED") end
		twin = nil
		damageDone = nil
		currentShieldStrength = nil
		halfWarning = nil
	end
	function mod:HealStarted(player, spellId, source)
		if not f then
			f = CreateFrame("Frame")
			f:SetScript("OnEvent", function(_, _, _, event, _, _, _, _, dName, _, _, swingDamage, _, healId, damage)
				if healId == "ABSORB" and dName == twin then
					if event == "SWING_MISSED" then -- SWING_MISSED probably happens more often than the others, so catch it first
						damageDone = damageDone + swingDamage
					elseif event == "SPELL_PERIODIC_MISSED" or event == "SPELL_MISSED" or event == "RANGE_MISSED" then
						damageDone = damageDone + damage
					end
					if currentShieldStrength and not halfWarning and damageDone >= (currentShieldStrength / 2) then
						mod:Message("shield", L["shield_half_message"], "Positive")
						halfWarning = true
					end
				elseif event == "SPELL_INTERRUPT" and heals[healId] then
					stop()
				end
			end)
		end
		damageDone = 0
		twin = source
		f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
	function mod:Healed()
		if not currentShieldStrength then return end
		local missing = math.ceil(100 - (100 * damageDone / currentShieldStrength))
		self:Message("shield", L["shield_left_message"]:format(missing), "Important")
		stop()
	end
end

function mod:Touch(player, spellId, _, _, spellName)
	self:TargetMessage("touch", spellName, player, "Personal", spellId, "Info")
	if UnitIsUnit(player, "player") then self:FlashShake("touch") end
	self:Whisper("touch", player, spellName)
end

function mod:DarkShield(_, spellId, _, _, spellName)
	currentShieldStrength = shieldStrengthMap[spellId]
	self:Bar("shield", L["vortex_or_shield_cd"], 45, 39089)
	local d = UnitDebuff("player", essenceDark)
	if d then
		self:Message("shield", spellName, "Important", spellId, "Alert")
	else
		self:Message("shield", spellName, "Urgent", spellId)
	end
end

function mod:LightShield(_, spellId, _, _, spellName)
	currentShieldStrength = shieldStrengthMap[spellId]
	self:Bar("shield", L["vortex_or_shield_cd"], 45, 39089)
	local d = UnitDebuff("player", essenceLight)
	if d then
		self:Message("shield", spellName, "Important", spellId, "Alert")
	else
		self:Message("shield", spellName, "Urgent", spellId)
	end
end

function mod:LightVortex(_, spellId, _, _, spellName)
	self:Bar("vortex", L["vortex_or_shield_cd"], 45, 39089)
	local d = UnitDebuff("player", essenceLight)
	if d then
		self:Message("vortex", spellName, "Positive", spellId)
	else
		self:Message("vortex", spellName, "Personal", spellId, "Alarm")
		self:FlashShake("vortex")
	end
end

function mod:DarkVortex(_, spellId, _, _, spellName)
	self:Bar("vortex", L["vortex_or_shield_cd"], 45, 39089)
	local d = UnitDebuff("player", essenceDark)
	if d then
		self:Message("vortex", spellName, "Positive", spellId)
	else
		self:Message("vortex", spellName, "Personal", spellId, "Alarm")
		self:FlashShake("vortex")
	end
end

