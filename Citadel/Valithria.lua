--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Valithria Dreamwalker", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36789, 37868, 36791, 37934, 37886, 37950, 37985)
mod.toggleOptions = {71730, {71741, "FLASHSHAKE"}, "suppresser", "blazing", "skull", "portal", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local blazingTimers = {60, 51.5, 53.5, 41, 41}
local blazingCount, blazingRepeater = 1, nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "Intruders have breached the inner sanctum. Hasten the destruction of the green dragon!"

	L.portal = "Nightmare Portals"
	L.portal_desc = "Warns when Valithria opens portals."
	L.portal_message = "Portals up!"
	L.portal_trigger = "I have opened a portal into the Dream. Your salvation lies within, heroes..."
	L.portal_bar = "Next Portal"

	L.manavoid_message = "Mana Void on YOU!"

	L.suppresser = "Suppressers spawn"
	L.suppresser_desc = "Warns when a pack of Suppressers spawn."
	L.suppresser_message = "~Suppressers"

	L.blazing = "Blazing Skeleton"
	L.blazing_desc = "Blazing Skeleton |cffff0000estimated|r respawn timer. This timer may be innacurate, use only as a rough guide."
	L.blazing_warning = "Blazing Skeleton Soon!"

	L.skull = "Skull on Blazing Skeleton"
	L.skull_desc = "Place a skull Raid Icon on the Blazing Skeletons that spawn (requires promoted or leader)."
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	if UnitPowerType("player") == 0 then
		self:Log("SPELL_DAMAGE", "ManaVoid", 71086, 71741, 71743) --10, ??, ??
	end
	self:Log("SPELL_AURA_APPLIED", "LayWaste", 69325, 71730) -- 10/25
	self:Log("SPELL_AURA_REMOVED", "LayWasteRemoved", 69325, 71730)
	self:Log("SPELL_CAST_START", "Win", 71189)
	self:Log("SPELL_CAST_START", "Fireball", 70754, 71748) --10/25

	self:Yell("Portal", L["portal_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Engage", L["engage_trigger"])
end

do
	local function suppresserSpawn()
		mod:Bar("suppresser", L["suppresser_message"], 58, 70588)
		mod:ScheduleTimer(suppresserSpawn, 58)
	end
	local function blazingSpawn()
		--XXX more testing, same on 10man?
		if not blazingTimers[blazingCount] then return end
		mod:Bar("blazing", L["blazing"], blazingTimers[blazingCount], 71730)
		mod:ScheduleTimer(blazingSpawn, blazingTimers[blazingCount])
		mod:DelayedMessage("blazing", blazingTimers[blazingCount] - 5, L["blazing_warning"], "Positive")
		blazingCount = blazingCount + 1
	end
	function mod:OnEngage()
		self:Bar("suppresser", L["suppresser_message"], 29, 70588)
		self:Bar("portal", L["portal_bar"], 46, 72482)
		self:ScheduleTimer(suppresserSpawn, 29)
		self:ScheduleTimer(blazingSpawn, 50)
		self:Bar("blazing", L["blazing"], 50, 71730)
		self:DelayedMessage("blazing", 45, L["blazing_warning"], "Positive")
		blazingCount = 1
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:LayWaste(_, spellId, _, _, spellName)
	self:Message(71730, spellName, "Attention", spellId)
	self:Bar(71730, spellName, 12, spellId)
end

function mod:LayWasteRemoved(_, _, _, _, spellName)
	self:SendMessage("BigWigs_StopBar", self, spellName)
end

function mod:Portal()
	self:Message("portal", L["portal_message"], "Important")
	self:Bar("portal", L["portal_bar"], 46, 72482)
end

do
	local t = 0
	function mod:ManaVoid(player, spellId)
		if (GetTime()-t > 2) and UnitIsUnit(player, "player") then
			t = GetTime()
			self:LocalMessage(71741, L["manavoid_message"], "Personal", spellId, "Alarm")
			self:FlashShake(71741)
		end
	end
end

do
	local function scanTarget()
		local unitId = mod:GetUnitIdByGUID(36791)
		if not unitId then return end
		SetRaidTarget(unitId, 8)
		mod:CancelTimer(blazingRepeater)
		blazingRepeater = nil
	end
	function mod:Fireball()
		if blazingRepeater or (not IsRaidLeader() and not IsRaidOfficer()) then return end
		if self.db.profile.skull then
			blazingRepeater = self:ScheduleRepeatingTimer(scanTarget, 0.5)
		end
	end
end

