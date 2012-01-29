--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Hagara the Stormbinder", 824, 317)
if not mod then return end
mod:RegisterEnableMob(55689)

--------------------------------------------------------------------------------
-- Locales
--

local playerTbl = mod:NewTargetList()
local nextPhase, nextPhaseIcon

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "You cross the Stormbinder! I'll slaughter you all."

	L.lightning_or_frost = "Lightning or Frost"
	L.ice_next = "Ice phase"
	L.lightning_next = "Lightning phase"

	L.assault = EJ_GetSectionInfo(4159)
	L.assault_desc = "Tank & Healer alert only. "..select(2, EJ_GetSectionInfo(4159))
	L.assault_icon = 107851

	L.nextphase = "Next Phase"
	L.nextphase_desc = "Warnings for next phase"
	L.nextphase_icon = 2139 -- random icon (counterspell)
end
L = mod:GetLocale()
L.assault = L.assault.." "..INLINE_TANK_ICON..INLINE_HEALER_ICON

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{104448, "FLASHSHAKE"}, 109553, {105316, "PROXIMITY"}, {109325, "ICON", "FLASHSHAKE", "PROXIMITY", "SAY"},
		109561,
		"assault", 108934, "nextphase", "berserk", "bosskill",
	}, {
		[104448] = L["ice_next"],
		[109561] = L["lightning_next"],
		assault = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "IceTombStart", 104448)
	self:Log("SPELL_AURA_APPLIED", "Assault", 107851, 110898, 110899, 110900)
	self:Log("SPELL_AURA_APPLIED", "IceTombApplied", 104451)
	self:Log("SPELL_AURA_APPLIED", "IceLanceApplied", 105285)
	self:Log("SPELL_AURA_REMOVED", "IceLanceRemoved", 105285)
	self:Log("SPELL_AURA_APPLIED", "Feedback", 108934)
	self:Log("SPELL_CAST_START", "FrozenTempest", 109553, 109554, 105256, 109552)
	self:Log("SPELL_CAST_START", "WaterShield", 109561, 109562, 105409, 109560)
	self:Log("SPELL_AURA_APPLIED", "FrostFlakeApplied", 109325)
	self:Log("SPELL_AURA_REMOVED", "FrostFlakeRemoved", 109325)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 55689)
end

function mod:OnEngage(diff)
	self:Berserk(480) -- 10 man heroic confirmed
	-- need to find a way to determine which one is at first after engage
	-- apart from looking at her weapon enchants
	self:Bar("nextphase", L["lightning_or_frost"], 30, L["nextphase_icon"])
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Assault(_, spellId, _, _, spellName)
	if self:Tank() or self:Healer() then
		self:LocalMessage("assault", spellName, "Urgent", spellId)
		self:Bar("assault", "~"..spellName, 15, spellId)
		self:Bar("assault", "<"..spellName..">", 5, spellId)
	end
end

function mod:FrostFlakeApplied(player, spellId, _, _, spellName)
	self:PrimaryIcon(109325, player)
	if UnitIsUnit("player", player) then
		self:LocalMessage(109325, CL["you"]:format(spellName), "Personal", spellId, Long)
		self:Say(109325, CL["say"]:format(spellName))
		self:FlashShake(109325)
		self:OpenProximity(10, 109325)
	end
end

function mod:FrostFlakeRemoved(player)
	self:PrimaryIcon(109325)
	if UnitIsUnit("player", player) then
		self:CloseProximity(109325)
	end
end

function mod:WaterShield(_, spellId)
	self:SendMessage("BigWigs_StopBar", self, "~"..(GetSpellInfo(107851))) -- Focused Assault
	self:Message(109561, L["lightning_next"], "Attention", spellId)
	nextPhase = L["ice_next"]
	nextPhaseIcon = 105409
end

function mod:FrozenTempest(_, spellId)
	self:SendMessage("BigWigs_StopBar", self, "~"..(GetSpellInfo(107851))) -- Focused Assault
	self:Message(109553, L["ice_next"], "Attention", spellId)
	nextPhase = L["lightning_next"]
	nextPhaseIcon = 109561
end

function mod:Feedback(_, spellId, _, _, spellName)
	self:Message(108934, spellName, "Attention", spellId)
	self:Bar(108934, spellName, 15, spellId)
	self:Bar("nextphase", nextPhase, 63, nextPhaseIcon)
	if self:Tank() then
		self:Bar("assault", GetSpellInfo(107851), 20, 107851) -- Focused Assault
	end
end

function mod:IceTombStart(_, spellId, _, _, spellName)
	self:Message(104448, spellName, "Attention", spellId)
	self:Bar(104448, spellName, 8, spellId)
	self:FlashShake(104448)
end

do
	local scheduled = nil
	local function iceTomb(spellName)
		mod:TargetMessage(104448, spellName, playerTbl, "Important", 104448)
		scheduled = nil
	end
	function mod:IceTombApplied(player, _, _, _, spellName)
		playerTbl[#playerTbl + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(iceTomb, 0.1, spellName)
		end
	end
end

do
	local scheduled = nil
	local function iceLance()
		mod:TargetMessage(105316, GetSpellInfo(105316), playerTbl, "Urgent", 105316, "Info")
		scheduled = nil
	end
	function mod:IceLanceApplied(player)
		playerTbl[#playerTbl + 1] = player
		if UnitIsUnit(player, "player") then
			self:OpenProximity(3, 105316)
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(iceLance, 0.2)
		end
	end
end

function mod:IceLanceRemoved(player)
	if UnitIsUnit(player, "player") then
		self:CloseProximity(105316)
	end
end

