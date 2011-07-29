--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Alysrazor", 800, 194)
if not mod then return end
mod:RegisterEnableMob(52530, 53898, 54015) --Alysrazor, Voracious Hatchling, Majordomo Staghelm

local firestorm, cataclysm = (GetSpellInfo(101659)), (GetSpellInfo(100761))
local woundTargets = mod:NewTargetList()
local cataclysmCount, moltCount = 0, 0 -- So that Cataclysm knows when to create bars for the next Cataclysm

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.tornado_trigger = "These skies are MINE!"
	L.claw_message = "%2$dx Claw on %1$s"
	L.fullpower_soon_message = "Full power soon!"
	L.halfpower_soon_message = "Stage 4 soon!"
	L.encounter_restart = "Here we go again..."
	L.no_stacks_message = "Dunno if you care, but you have no feathers"
	L.moonkin_message = "Stop pretending and get some real feathers"
	L.molt_bar = "Next Molt"

	L.stage_message = "Stage %d"

	L.worm_emote = "Fiery Lava Worms erupt from the ground!"
	L.phase2_soon_emote = "Alysrazor begins to fly in a rapid circle!"
	L.phase2_emote = "99794" -- Fiery Vortex spell ID used in the emote
	L.phase3_emote = "99432" -- Burns Out spell ID used in the emote
	L.phase4_emote = "99922" -- Re-Ignites spell ID used in the emote
	L.restart_emote = "99925" -- Full Power spell ID used in the emote

	L.flight = "Flight Assist"
	L.flight_desc = "Show a bar with the duration of 'Wings of Flame' on you, ideally used with the Super Emphasize feature."
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		99362, 100723, 97128, "flight",
		99816, 99464,
		99432,
		99844, 99925,
		{100744, "FLASHSHAKE"}, 100761,
		"berserk", "bosskill"
	}, {
		[99362] = "ej:2820", --Stage 1: Flight
		[99816] = "ej:2821", --Stage 2: Tornadoes
		[99432] = "ej:2822", --Stage 3: Burnout
		[99844] = "ej:2823", --Stage 4: Re-Ignite
		[100744] = "heroic",
		berserk = "general"
	}
end

function mod:OnBossEnable()
	-- General
	self:Log("SPELL_AURA_APPLIED", "Molting", 99464, 99465, 100698)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlazingClaw", 99844, 101729, 101730, 101731)
	self:Log("SPELL_AURA_APPLIED", "StartFlying", 98619)
	self:Log("SPELL_AURA_REMOVED", "StopFlying", 98619)

	-- Stage 1: Flight
	self:Log("SPELL_AURA_APPLIED", "Wound", 100723, 100722, 100721, 100720, 100719, 100718, 100024, 99308)
	self:Log("SPELL_AURA_APPLIED", "Tantrum", 99362)

	self:Emote("BuffCheck", L["worm_emote"], L["phase2_soon_emote"])

	-- Stage 2: Tornadoes
	self:Yell("FieryTornado", L["tornado_trigger"])

	-- Stage 3: Burnout
	self:Log("SPELL_AURA_APPLIED", "Burnout", 99432)

	-- Stage 4: Re-Ignite
	self:Log("SPELL_AURA_REMOVED", "ReIgnite", 99432)

	-- Heroic only
	self:Log("SPELL_CAST_START", "Cataclysm", 100761, 102111)
	self:Log("SPELL_CAST_START", "Firestorm", 100744)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 52530)
end

function mod:OnEngage(diff)
	self:Berserk(900) -- assumed
	cataclysmCount, moltCount = 0, 0
	if diff > 2 then
		self:Bar(99816, L["stage_message"]:format(2), 250, 99816)
		self:Bar(100744, firestorm, 93, 100744)
		self:Bar(100761, cataclysm, 37, 100761)
	else
		self:Bar(99816, L["stage_message"]:format(2), 188.5, 99816)
		self:Bar(99464, L["molt_bar"], 12.5, 99464)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local flying = GetSpellInfo(98619)
	local lastCheck = 0
	function mod:UNIT_AURA(_, unit)
		if unit ~= "player" then return end
		local _, _, _, _, _, _, expires = UnitBuff("player", flying)
		if expires ~= lastCheck then
			lastCheck = expires
			self:Bar("flight", flying, expires-GetTime(), 98619)
		end
	end
	function mod:StartFlying(player)
		if UnitIsUnit(player, "player") then
			self:Bar("flight", flying, 20, 98619)
			self:RegisterEvent("UNIT_AURA")
		end
	end
	function mod:StopFlying(player)
		if UnitIsUnit(player, "player") then
			self:UnregisterEvent("UNIT_AURA")
		end
	end
end

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
		if not UnitIsPlayer(player) then return end --Avoid those shadowfiends
		woundTargets[#woundTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(woundWarn, 0.5, spellName)
		end
	end
end

function mod:Tantrum(_, spellId, _, _, spellName, _, _, _, _, _, sGUID)
	local target = UnitGUID("target")
	if not target or sGUID ~= target then return end
	-- Just warn for the tank
	self:Message(99362, spellName, "Important", spellId)
end

-- don't need molting warning for heroic because molting happens at every firestorm
function mod:Molting(_, spellId, _, _, spellName)
	if self:Difficulty() < 3 then
		moltCount = moltCount + 1
		self:Message(99464, spellName, "Positive", spellId)
		if moltCount < 3 then
			self:Bar(99464, L["molt_bar"], 60, spellId)
		end
	end
end

function mod:Firestorm(_, spellId, _, _, spellName)
	self:FlashShake(100744)
	self:Message(100744, spellName, "Urgent", spellId, "Alert")
	self:Bar(100744, spellName, 10, spellId)
	-- Only show a bar for next if we have seen less than 3 Cataclysms
	if cataclysmCount < 3 then
		self:Bar(100744, "~"..spellName, 82, spellId)
	end
	self:Bar(100761, cataclysm, 10, 100761)
end

function mod:Cataclysm(_, spellId, _, _, spellName)
	self:Message(100761, spellName, "Attention", spellId, "Alarm")
	-- Only show a bar if this is the first or third Cataclysm this phase
	cataclysmCount = cataclysmCount + 1
	if cataclysmCount == 1 or cataclysmCount == 3 then
		self:Bar(100761, spellName, 32, 100761)
	end
end

function mod:FieryTornado()
	local fieryTornado = GetSpellInfo(99816)
	local feather = GetSpellInfo(98619)
	self:SendMessage("BigWigs_StopBar", self, firestorm)
	self:SendMessage("BigWigs_StopBar", self, feather)
	self:Bar(99816, fieryTornado, 35, 99816)
	self:Message(99816, (L["stage_message"]:format(2))..": "..fieryTornado, "Important", 99816, "Alarm")
end

function mod:BlazingClaw(player, spellId, _, _, _, stack)
	if stack > 4 then -- 50% extra fire and physical damage taken on tank
		self:TargetMessage(99844, L["claw_message"], player, "Urgent", spellId, "Info", stack)
	end
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
do
	local halfWarned = false
	local fullWarned = false

	-- Alysrazor crashes to the ground
	function mod:Burnout(_, spellId, _, _, spellName)
		self:Message(99432, (L["stage_message"]:format(3))..": "..spellName, "Positive", spellId, "Alert")
		self:Bar(99432, "~"..spellName, 33, spellId)
		halfWarned, fullWarned = false, false
		self:RegisterEvent("UNIT_POWER")
	end

	function mod:UNIT_POWER(_, unit)
		local power = UnitPower("boss1", 0)
		if power > 40 and not halfWarned then
			self:Message(99925, L["halfpower_soon_message"], "Urgent", 99925)
			halfWarned = true
		elseif power > 80 and not fullWarned then
			self:Message(99925, L["fullpower_soon_message"], "Attention", 99925)
			fullWarned = true
		elseif power == 100 then
			self:Message(99925, (L["stage_message"]:format(1))..": "..(L["encounter_restart"]), "Positive", 99925, "Alert")
			self:UnregisterEvent("UNIT_POWER")
			if self:Difficulty() > 2 then
				cataclysmCount = 0
				self:Bar(100761, cataclysm, 18, 100761)
				self:Bar(100744, firestorm, 72, 100744)
				self:Bar(99816, L["stage_message"]:format(2), 225, 99816) -- Just adding 60s like OnEngage
			else
				self:Bar(99816, L["stage_message"]:format(2), 165, 99816)
				moltCount = 1
				self:Bar(99464, L["molt_bar"], 55, 99464)
			end
		end
	end
end

function mod:ReIgnite()
	self:Message(99925, (L["stage_message"]:format(4))..": "..(GetSpellInfo(99922)), "Positive", 99922, "Alert")
	self:Bar(99925, GetSpellInfo(99925), 25, 99925)
	self:SendMessage("BigWigs_StopBar", self, "~"..GetSpellInfo(99432))
end

