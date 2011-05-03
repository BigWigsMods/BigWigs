--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Atramedes", 754)
if not mod then return end
mod:RegisterEnableMob(41442)

--------------------------------------------------------------------------------
-- Locals
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local searingFlame = GetSpellInfo(77840)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.ground_phase = "Ground Phase"
	L.ground_phase_desc = "Warning for when Atramedes lands."
	L.air_phase = "Air Phase"
	L.air_phase_desc = "Warning for when Atramedes takes off."

	L.air_phase_trigger = "Yes, run! With every step your heart quickens."

	L.obnoxious_soon = "Obnoxious Fiend soon!"

	L.searing_soon = "Searing Flame in 10sec!"
	L.sonicbreath_cooldown = "~Sonic Breath"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		"ground_phase", 78075, 77840,
		"air_phase",
		{92702, "ICON", "SAY"},
		{78092, "FLASHSHAKE", "ICON", "SAY"}, "berserk", "bosskill"
	}, {
		ground_phase = L["ground_phase"],
		air_phase = L["air_phase"],
		[92702] = "heroic",
		[78092] = "general"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "SonicBreath", 78075)
	self:Log("SPELL_AURA_APPLIED", "Tracking", 78092)
	self:Log("SPELL_AURA_APPLIED", "SearingFlame", 77840)
	self:Yell("AirPhase", L["air_phase_trigger"])

	self:Log("SPELL_AURA_APPLIED", "ObnoxiousPhaseShift", 92681)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 41442)
end

function mod:OnEngage(diff)
	self:Bar(78075, L["sonicbreath_cooldown"], 23, 78075)
	self:Bar(77840, searingFlame, 45, 77840)
	self:DelayedMessage(77840, 35, L["searing_soon"], "Attention", 77840)
	self:Bar("air_phase", L["air_phase"], 92, 5740) -- Rain of Fire Icon
	if diff > 2 then
		self:RegisterEvent("UNIT_AURA")
		self:Berserk(600)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function FiendCheck(dGUID)
	local fiend = mod:GetUnitIdByGUID(dGUID)
	if not fiend then
		mod:ScheduleTimer(FiendCheck, 0.1, dGUID)
	else
		mod:SecondaryIcon(92702, fiend)
	end
end

function mod:ObnoxiousPhaseShift(...)
	self:Message(92677, L["obnoxious_soon"], "Attention", 92677) -- do we really need this?
	local dGUID = select(10, ...)
	FiendCheck(dGUID)
	self:RegisterEvent("UNIT_AURA")
end

do
	local pestered = GetSpellInfo(92685)
	local obnoxious = GetSpellInfo(92702)
	function mod:UNIT_AURA(_, unit)
		if UnitDebuff(unit, pestered) then
			if unit == "player" then
				self:Say(92677, CL["say"]:format(obnoxious))
			end
			self:TargetMessage(92677, obnoxious, UnitName(unit), "Attention", 92677, "Long")
			self:UnregisterEvent("UNIT_AURA")
		end
	end
end

function mod:Tracking(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:Say(78092, CL["say"]:format((GetSpellInfo(78092))))
		self:FlashShake(78092)
	end
	self:TargetMessage(78092, spellName, player, "Personal", spellId, "Alarm")
	self:PrimaryIcon(78092, player)
end

function mod:SonicBreath(_, spellId, _, _, spellName)
	self:Bar(78075, L["sonicbreath_cooldown"], 42, spellId)
end

function mod:SearingFlame(_, spellId, _, _, spellName)
	self:Message(77840, spellName, "Important", spellId, "Alert")
end

do
	local function groundPhase()
		mod:Message("ground_phase", L["ground_phase"], "Attention", 61882) -- Earthquake Icon
		mod:Bar("air_phase", L["air_phase"], 90, 5740) -- Rain of Fire Icon
		mod:Bar(78075, L["sonicbreath_cooldown"], 25, 78075)
		-- XXX need a good trigger for ground phase start to make this even more accurate
		mod:Bar(77840, searingFlame, 48.5, 77840)
		mod:DelayedMessage(77840, 38.5, L["searing_soon"], "Attention", 77840)
	end
	function mod:AirPhase()
		self:SendMessage("BigWigs_StopBar", self, L["sonicbreath_cooldown"])
		self:Message("air_phase", L["air_phase"], "Attention", 5740) -- Rain of Fire Icon
		self:Bar("ground_phase", L["ground_phase"], 30, 61882) -- Earthquake Icon
		self:ScheduleTimer(groundPhase, 30)
	end
end

