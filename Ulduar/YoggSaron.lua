--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Yogg-Saron", "Ulduar")
if not mod then return end
--Sara = 33134, Yogg brain = 33890
mod:RegisterEnableMob(33288, 33134, 33890)
mod.toggleOptions = {62979, {63138, "WHISPER", "FLASHSHAKE"}, "tentacle", {63830, "ICON"}, {63802, "FLASHSHAKE"}, 64125, "portal", "weakened", 64059, {64465, "ICON"}, 64163, 64189, "phase", {63050, "WHISPER", "FLASHSHAKE"}, 63120, "berserk", "bosskill"}

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
mod.optionHeaders = {
	[62979] = CL.phase:format(1),
	tentacle = CL.phase:format(2),
	[64465] = CL.phase:format(3),
	[64189] = "hard",
	phase = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

local guardianCount = 1
local crusherCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L["Crusher Tentacle"] = true
	L["The Observation Ring"] = true

	L.phase = "Phase"
	L.phase_desc = "Warn for phase changes."
	L.engage_warning = "Phase 1"
	L.engage_trigger = "^The time to"
	L.phase2_warning = "Phase 2"
	L.phase2_trigger = "^I am the lucid dream"
	L.phase3_warning = "Phase 3"
	L.phase3_trigger = "^Look upon the true face"

	L.portal = "Portal"
	L.portal_desc = "Warn for Portals."
	L.portal_trigger = "Portals open into %s's mind!"
	L.portal_message = "Portals open!"
	L.portal_bar = "Next portals"

	L.fervor_cast_message = "Casting Fervor on %s!"
	L.fervor_message = "Fervor on %s!"

	L.sanity_message = "You're going insane!"

	L.weakened = "Stunned"
	L.weakened_desc = "Warn when Yogg-saron becomes stunned."
	L.weakened_message = "%s is stunned!"
	L.weakened_trigger = "The illusion shatters and a path to the central chamber opens!"

	L.madness_warning = "Madness in 5sec!"
	L.malady_message = "Malady: %s"

	L.tentacle = "Crusher Tentacle"
	L.tentacle_desc = "Warn for Crusher Tentacle spawn."
	L.tentacle_message = "Crusher %d!"

	L.link_warning = "You are linked!"

	L.gaze_bar = "~Gaze Cooldown"
	L.empower_bar = "~Empower Cooldown"

	L.guardian_message = "Guardian %d!"

	L.empowericon_message = "Empower Faded!"

	L.roar_warning = "Roar in 5sec!"
	L.roar_bar = "Next Roar"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "FervorCast", 63138)
	self:Log("SPELL_AURA_APPLIED", "Fervor", 63138)
	self:Log("SPELL_CAST_START", "Roar", 64189)
	self:Log("SPELL_CAST_START", "Madness", 64059)
	self:Log("SPELL_CAST_SUCCESS", "Empower", 64465)
	self:Log("SPELL_AURA_APPLIED", "EmpowerIcon", 64465)
	self:Log("SPELL_AURA_REMOVED", "RemoveEmpower", 64465)
	self:Log("SPELL_CAST_SUCCESS", "Tentacle", 64144)
	self:Log("SPELL_AURA_APPLIED", "Squeeze", 64125, 64126)
	self:Log("SPELL_AURA_APPLIED", "Linked", 63802)
	self:Log("SPELL_AURA_REMOVED", "Gaze", 64163)
	self:Log("SPELL_AURA_APPLIED", "CastGaze", 64163)
	self:Log("SPELL_AURA_APPLIED", "Malady", 63830, 63881)
	self:Log("SPELL_AURA_REMOVED", "RemoveMalady", 63830, 63881)
	self:Log("SPELL_AURA_APPLIED", "Insane", 63120)
	self:Log("SPELL_AURA_REMOVED_DOSE", "SanityDecrease", 63050)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SanityIncrease", 63050)
	self:Log("SPELL_SUMMON", "Guardian", 62979)
	self:Death("Win", 33288)
	self:Emote("Portal", L["portal_trigger"])
	self:Emote("Weakened", L["weakened_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Engage", L["engage_trigger"])
	self:Yell("Yells", L["phase2_trigger"], L["phase3_trigger"])
	guid = nil
end

function mod:OnEngage()
	guardianCount = 1
	self:Message("phase", L["engage_warning"], "Attention")
	self:Berserk(900, true)
end

function mod:VerifyEnable()
	local z = GetSubZoneText()
	if z and z == L["The Observation Ring"] then return false end
	return true
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FervorCast(player, spellId, _, _, spellName)
	local bossId = self:GetUnitIdByGUID(33134)
	if bossId then
		local target = UnitName(bossId .. "target")
		if not target then return end
		self:TargetMessage(63138, L["fervor_cast_message"], target, "Personal", spellId)
	end
end

function mod:Fervor(player, spellId, _, _, spellName)
	self:Bar(63138, L["fervor_message"]:format(player), 15, spellId)
	self:Whisper(63138, player, spellName)
	if UnitIsUnit(player, "player") then
		self:FlashShake(63138)
	end
end

do
	local warned = {}
	function mod:SanityIncrease(player, _, _, _, _, stack)
		if not warned[player] then return end
		if stack > 70 then warned[player] = nil end
	end
	function mod:SanityDecrease(player, spellId, _, _, _, stack)
		if warned[player] then return end
		if UnitIsUnit(player, "player") then
			if stack > 40 then return end
			self:Message(63050, L["sanity_message"], "Personal", spellId)
			self:FlashShake(63050)
			warned[player] = true
		elseif stack < 31 then
			self:Whisper(63050, player, L["sanity_message"], true)
			warned[player] = true
		end
	end
end

function mod:Guardian(_, spellId)
	self:Message(62979, L["guardian_message"]:format(guardianCount), "Positive", spellId)
	guardianCount = guardianCount + 1
end

function mod:Insane(player, spellId, _, _, spellName)
	self:TargetMessage(63120, spellName, player, "Attention", spellId)
end

function mod:Tentacle(_, spellId, source, _, spellName)
	-- Crusher Tentacle (33966) 50 sec
	-- Corruptor Tentacle (33985) 25 sec
	-- Constrictor Tentacle (33983) 20 sec
	if source == L["Crusher Tentacle"] then
		self:Message("tentacle", L["tentacle_message"]:format(crusherCount), "Important", 64139)
		crusherCount = crusherCount + 1
		self:Bar("tentacle", L["tentacle_message"]:format(crusherCount), 55, 64139)
	end
end

function mod:Roar(_, spellId, _, _, spellName)
	self:Message(64189, spellName, "Attention", spellId)
	self:Bar(64189, L["roar_bar"], 60, spellId)
	self:DelayedMessage(64189, 55, L["roar_warning"], "Attention")
end

function mod:Malady(player)
	self:PrimaryIcon(63830, player)
end

function mod:RemoveMalady(player)
	self:PrimaryIcon(63830, false)
end

function mod:Squeeze(player, spellId, _, _, spellName)
	self:TargetMessage(64125, spellName, player, "Positive", spellId)
end

function mod:Linked(player, spellId)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(63802, L["link_warning"], "Personal", spellId, "Alarm")
		self:FlashShake(63802)
	end
end

function mod:Gaze(_, spellId, _, _, spellName)
	self:Bar(64163, L["gaze_bar"], 9, spellId)
end

function mod:CastGaze(_, spellId, _, _, spellName)
	self:Bar(64163, spellName, 4, spellId)
end

function mod:Madness(_, spellId, _, _, spellName)
	self:Bar(64059, spellName, 60, 64059)
	self:DelayedMessage(64059, 55, L["madness_warning"], "Urgent")
end

function mod:Empower(_, spellId, _, _, spellName)
	self:Message(64465, spellName, "Important", spellId)
	self:Bar(64465, L["empower_bar"], 46, spellId)
end

function mod:RemoveEmpower()
	self:Message(64465, L["empowericon_message"], "Positive", 64465)
	self:SendMessage("BigWigs_RemoveRaidIcon")
end

do
	local empowerscanner = nil
	local function scanTarget(dGuid)
		local unitId = mod:GetUnitIdByGUID(dGuid)
		if not unitId then return end
		SetRaidTarget(unitId, 8)
		mod:CancelTimer(empowerscanner)
		empowerscanner = nil
	end
	function mod:EmpowerIcon(...)
		if empowerscanner or (not IsRaidLeader() and not IsRaidOfficer()) then return end
		if bit.band(self.db.profile[(GetSpellInfo(64465))], BigWigs.C.ICON) ~= BigWigs.C.ICON then return end
		local dGuid = select(10, ...)
		empowerscanner = self:ScheduleRepeatingTimer(scanTarget, 0.3, dGuid)
	end
end

function mod:Portal()
	self:Message("portal", L["portal_message"], "Positive", 35717)
	self:Bar("portal", L["portal_bar"], 90, 35717)
end

function mod:Weakened(_, unit)
	self:Message("weakened", L["weakened_message"]:format(unit), "Positive", 50661)
end

function mod:Yells(msg)
	if msg:find(L["phase2_trigger"]) then
		crusherCount = 1
		self:Message("phase", L["phase2_warning"], "Attention")
		self:Bar("portal", L["portal_bar"], 78, 35717)
	elseif msg:find(L["phase3_trigger"]) then
		self:CancelDelayedMessage(L["madness_warning"])

		local madness = GetSpellInfo(64059)
		self:SendMessage("BigWigs_StopBar", self, madness)
		self:SendMessage("BigWigs_StopBar", self, L["tentacle_message"]:format(crusherCount))
		self:SendMessage("BigWigs_StopBar", self, L["portal_bar"])

		self:Message("phase", L["phase3_warning"], "Important", nil, "Alarm")
		self:Bar(64465, L["empower_bar"], 46, 64486)
	end
end

