--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Argaloth", "Baradin Hold")
if not mod then return end
mod.otherMenu = "Baradin Hold"
mod:RegisterEnableMob(47120)
mod.toggleOptions = {88942, 88954, {88972, "FLASHSHAKE"}, "berserk", "bosskill"}
mod.optionHeaders = {
	[88942] = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

local consumingTargets = mod:NewTargetList()
local firestorm1, firestorm2 = true, true

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.darkness_message = "Darkness"
	L.firestorm_message = "Firestorm soon!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "MeteorSlash", 88942, 95172)
	self:Log("SPELL_AURA_APPLIED", "ConsumingDarkness", 88954, 95173)
	self:Log("SPELL_CAST_START", "FelFirestorm", 88972)
	self:Death("Win", 47120)

	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	self:Berserk(300)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MeteorSlash(_, spellId, _, _, spellName)
	self:Message(88942, spellName, "Important", spellId)
end

do
	local scheduled = nil
	local function consumingWarn()
		mod:TargetMessage(88954, L["darkness_message"], consumingTargets, "Personal", 88954)
		scheduled = nil
	end
	function mod:ConsumingDarkness(player)
		consumingTargets[#consumingTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(consumingWarn, 0.2)
		end
	end
end

function mod:FelFirestorm(_, spellId, _, _, spellName)
	self:Message(88972, spellName, "Attention", spellId, "Alert")
	self:FlashShake(88972)
end

function mod:UNIT_HEALTH(_, unit)
	local guid = UnitGUID(unit)
	if not guid then return end
	guid = tonumber((guid):sub(-12, -9), 16)
	if guid == 47120 then
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
		if hp <= 69 and firestorm1 then
			self:Message(88972, L["firestorm_message"], "Attention")
			firestorm1 = false
		elseif hp <= 36 and firestorm2 then
			self:Message(88972, L["firestorm_message"], "Attention")
			firestorm2 = false
		end
	end
end

