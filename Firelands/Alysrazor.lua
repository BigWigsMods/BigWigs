--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Alysrazor", 800, 194)
if not mod then return end
mod:RegisterEnableMob(52530)

local fieryTornado, firestorm = (GetSpellInfo(99816)), (GetSpellInfo(101659))
local woundTargets = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.tornado_trigger = "These skies are MINE!"
	L.claw_message = "%2$dx Claw on %1$s"
	L.fullpower_soon_message = "Full power soon!"
	L.halfpower_soon_message = "Phase 4 soon!"
	L.encounter_restart = "Full power! Here we go again ..."
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		99362, 100723,
		99816, 99464,
		99844, 99925,
		{100744, "FLASHSHAKE"}, 100761,
		"berserk", "bosskill"
	}, {
		[99362] = "ej:2820",
		[99816] = "ej:2821",
		[99844] = "ej:2823",
		[100744] = "heroic",
		berserk = "general"
	}
end

function mod:OnBossEnable()
	-- General
	self:Log("SPELL_AURA_APPLIED", "Molting", 99464, 99465, 100698)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlazingClaw", 99844, 101729, 101730, 101731)

	-- Phase 1
	self:Log("SPELL_AURA_APPLIED", "Wound", 100723, 100722, 100721, 100720, 100719, 100718, 100024, 99308)
	self:Log("SPELL_AURA_APPLIED", "Tantrum", 99362)

	-- Phase 2
	self:Yell("FieryTornado", L["tornado_trigger"])

	-- Phase 3
	self:Log("SPELL_AURA_APPLIED", "Burnout", 99432)

	-- Heroic only
	self:Log("SPELL_CAST_START", "Cataclysm", 100761)
	self:Log("SPELL_CAST_START", "Firestorm", 100744)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 52530)
end

function mod:OnEngage(diff)
	self:Berserk(900) -- assumed
	self:Bar(99816, fieryTornado, 190, 99816)
	if diff > 2 then
		self:Bar(99816, fieryTornado, 250, 99816)
		self:Bar(100744, firestorm, 93, 100744)
	else
		self:Bar(99464, (GetSpellInfo(99464)), 60, 99464) -- Molting
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local scheduled = nil
	local function woundWarn(spellName)
		mod:TargetMessage(100723, spellName, woundTargets, "Personal", 100723, "Info")
		scheduled = nil
	end
	function mod:Wound(player, spellId, _, _, spellName)
		woundTargets[#woundTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(woundWarn, 0.5, spellName)
		end
	end
end

function mod:Tantrum(_, spellId, _, _, spellName, _, _, _, _, _, sGUID)
	local target = UnitGUID("target")
	if not target then return end
	-- Just warn for the tank
	if not UnitIsUnit(sGUID, target) then return end
	self:Message(99362, spellName, "Important", spellId)
end

-- don't need molting warning for heroic because molting happens at every firestorm
function mod:Molting(_, spellId, _, _, spellName)
	if self:Difficulty() < 3 then
		self:Message(99464, spellName, "Positive", spellId)
		self:Bar(99464, spellName, 60, spellId)
	end
end

function mod:Firestorm(_, spellId, _, _, spellName)
	self:FlashShake(100744)
	self:Message(100744, spellName, "Urgent", spellId, "Alert")
	self:Bar(100744, "~"..spellName, 86, spellId)
	self:Bar(100744, spellName, 15, spellId)
end

function mod:Cataclysm(_, spellId, _, _, spellName)
	self:Message(100761, spellName, "Attention", spellId, "Alarm")
end

function mod:FieryTornado()
	self:SendMessage("BigWigs_StopBar", self, firestorm)
	self:Bar(99816, fieryTornado, 35, 99816)
	self:Message(99816, fieryTornado, "Important", 99816, "Alarm")
end

function mod:BlazingClaw(player, spellId, _, _, _, stack)
	if stack > 4 then -- 50% extra fire and physical damage taken on tank
		self:TargetMessage(99844, L["claw_message"], player, "Urgent", spellId, "Info", stack)
	end
end

do
	local halfWarned = false
	local fullWarned = false

	-- Alysrazor crashes to the ground
	function mod:Burnout()
		halfWarned, fullWarned = false, false
		self:RegisterEvent("UNIT_POWER")
	end

	function mod:UNIT_POWER(_, unit)
		local t = UnitPowerType("boss1") -- I think it's SPELL_POWER_FOCUS
		local power = UnitPower("boss1", t)
		if t ~= SPELL_POWER_FOCUS then
			print("Power type is " .. tostring(t) .. "?!")
		end
		if power > 40 and not halfWarned then
			self:Message(99925, L["halfpower_soon_message"], "Urgent", 99925)
			halfWarned = true
		elseif power > 80 and not fullWarned then
			self:Message(99925, L["fullpower_soon_message"], "Attention", 99925)
			fullWarned = true
		elseif power == 100 then
			self:Message(99925, L["encounter_restart"], "Positive", 99925, "Alert")
			self:Bar(99816, fieryTornado, 165, 99816)
			self:UnregisterEvent("UNIT_POWER")
		end
	end
end

