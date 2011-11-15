--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Argaloth", 752, 139)
if not mod then return end
mod:RegisterEnableMob(47120)

--------------------------------------------------------------------------------
-- Locals
--

local fireStorm, consumingTargets = 100, mod:NewTargetList()

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

function mod:GetOptions()
	return {88942, 88954, {88972, "FLASHSHAKE"}, "berserk", "bosskill"}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "MeteorSlash", 88942, 95172)
	self:Log("SPELL_AURA_APPLIED", "ConsumingDarkness", 88954, 95173)
	self:Log("SPELL_CAST_START", "FelFirestorm", 88972)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 47120)
end

function mod:OnEngage()
	self:Berserk(300)
	self:Bar(88942, "~"..GetSpellInfo(95172), 10, 88942)
	fireStorm = 100
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MeteorSlash(_, spellId, _, _, spellName)
	self:Message(88942, spellName, "Important", spellId)
	self:Bar(88942, "~"..spellName, 17, spellId)
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
			self:ScheduleTimer(consumingWarn, 0.5)
		end
	end
end

function mod:FelFirestorm(_, spellId, _, _, spellName)
	self:SendMessage("BigWigs_StopBar", self, L["meteor_bar"])
	self:Message(88972, fireStorm.."% - "..spellName, "Urgent", spellId, "Alert")
	self:FlashShake(88972)
	self:Bar(88942, "~"..GetSpellInfo(95172), 32, 88942)
end

function mod:UNIT_HEALTH_FREQUENT(_, unit)
	if unit ~= "boss1" then return end
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < 69 and fireStorm > 70 then
		self:Message(88972, L["firestorm_message"], "Attention")
		fireStorm = 66
	elseif hp < 36 and fireStorm > 50 then
		self:Message(88972, L["firestorm_message"], "Attention")
		fireStorm = 33
		self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
	end
end

