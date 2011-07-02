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
	L.no_stacks_message = "Dunno if you care, but you have no feathers"
	L.moonkin_message = "Stop pretending and get some real feathers"

	L.worm_emote = "Fiery Lava Worms erupt from the ground!"
	L.phase2_soon_emote = "Alysrazor begins to fly in a rapid circle!"
	L.phase2_emote = "99794" -- Fiery Vortex spell ID used in the emote
	L.phase3_emote = "99432" -- Burns Out spell ID used in the emote
	L.phase4_emote = "99922" -- Re-Ignites spell ID used in the emote
	L.restart_emote = "99925" -- Full Power spell ID used in the emote
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		99362, 100723, 97128,
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

	self:Emote("BuffCheck", L["worm_emote"], L["phase2_soon_emote"])

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
	if diff > 2 then
		self:Bar(99816, fieryTornado, 250, 99816)
		self:Bar(100744, firestorm, 93, 100744)
	else
		self:Bar(99816, fieryTornado, 190, 99816)
		self:Bar(99464, (GetSpellInfo(99464)), 60, 99464) -- Molting
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local feather = GetSpellInfo(97128)
	local moonkin = GetSpellInfo(24858)
	function mod:BuffCheck()
		local name = UnitBuff("player", feather)
		if not name then
			if UnitBuff("player", moonkin) then
				self:Message(97128, L["moonkin_message"], "Personal", 97128)
			else
				self:Message(97128, L["no_stacks_message"], "Personal", 97128)
			end
		end
	end
end

do
	local scheduled = nil
	local function woundWarn(spellName)
		mod:TargetMessage(100723, spellName, woundTargets, "Personal", 100723)
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
	if sGUID ~= target then return end
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

--[[
In case we need to rebase this on emotes instead of unit power, here's a few noteworthy events
"<2329.1> RAID_BOSS_EMOTE#Fiery Lava Worms erupt from the ground!#Plump Lava Worm#0#false", -- [17]
"<2391.0> RAID_BOSS_EMOTE#Fiery Lava Worms erupt from the ground!#Plump Lava Worm#0#false", -- [18]
"<2454.5> RAID_BOSS_EMOTE#Alysrazor begins to fly in a rapid circle!  The harsh winds will remove Wings of Flame!#Alysrazor#0#false", -- [19]
"<2461.0> RAID_BOSS_EMOTE#|TInterface\\Icons\\ability_mage_firestarter.blp:20|t The harsh winds form a |cFFFF0000|Hspell:99794|h[Fiery Vortex]|h|r!#Fiery Vortex#0#false", -- [20]
"<2485.0> RAID_BOSS_EMOTE#|TInterface\\Icons\\spell_holiday_tow_spicecloud.blp:20|t Alysrazor's fire |cFFFF0000|Hspell:99432|h[Burns Out]|h|r!#Alysrazor#0#false", -- [21]
"<2515.6> RAID_BOSS_EMOTE#|TInterface\\Icons\\inv_elemental_primal_fire.blp:20|t Alysrazor's firey core |cFFFF0000|Hspell:99922|h[Re-Ignites]|h|r!#Alysrazor#0#false", -- [22]
"<2542.8> RAID_BOSS_EMOTE#|TInterface\\Icons\\spell_shaman_improvedfirenova.blp:20|t Alysrazor is at |cFFFF0000|Hspell:99925|h[Full Power]|h|r!#Alysrazor#0#false", -- [23]
]]

	function mod:UNIT_POWER(_, unit)
		local power = UnitPower("boss1", 0)
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

