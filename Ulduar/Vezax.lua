--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("General Vezax", "Ulduar")
if not mod then return end
mod:RegisterEnableMob(33271)
mod.toggleOptions = {"vapor", {"vaporstack", "FLASHSHAKE"}, {62660, "WHISPER", "ICON", "SAY", "FLASHSHAKE"}, {63276, "WHISPER", "ICON", "FLASHSHAKE"}, 62661, 62662, "animus", "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local vaporCount = 1
local surgeCount = 1
local lastVapor = nil
local vapor = GetSpellInfo(63322)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L["Vezax Bunny"] = true -- For emote catching.

	L.engage_trigger = "^Your destruction will herald a new age of suffering!"

	L.surge_message = "Surge %d!"
	L.surge_cast = "Surge %d casting!"
	L.surge_bar = "Surge %d"

	L.animus = "Saronite Animus"
	L.animus_desc = "Warn when the Saronite Animus spawns."
	L.animus_trigger = "The saronite vapors mass and swirl violently, merging into a monstrous form!"
	L.animus_message = "Animus spawns!"

	L.vapor = "Saronite Vapors"
	L.vapor_desc = "Warn when Saronite Vapors spawn."
	L.vapor_message = "Saronite Vapor %d!"
	L.vapor_bar = "Vapor %d/6"
	L.vapor_trigger = "A cloud of saronite vapors coalesces nearby!"

	L.vaporstack = "Vapors Stack"
	L.vaporstack_desc = "Warn when you have 5 or more stacks of Saronite Vapors."
	L.vaporstack_message = "Vapors x%d!"

	L.crash_say = "Crash on me!"

	L.mark_message = "Mark"
	L.mark_message_other = "Mark on %s!"
end
L = mod:GetLocale()

mod.optionHeaders = {
	vapor = L.vapor,
	[62660] = 62660,
	[63276] = 63276,
	[62661] = "normal",
	animus = "hard",
	berserk = "general",
}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Flame", 62661)
	self:Log("SPELL_CAST_START", "Surge", 62662)
	self:Log("SPELL_AURA_APPLIED", "SurgeGain", 62662)
	self:Log("SPELL_CAST_SUCCESS", "Crash", 60835, 62660)
	self:Log("SPELL_CAST_SUCCESS", "Mark", 63276)
	self:Death("Win", 33271)

	self:Emote("Vapor", L["vapor_trigger"])
	self:Emote("Animus", L["animus_trigger"])

	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Engage", L["engage_trigger"])
end

function mod:OnEngage()
	lastVapor = nil
	vaporCount = 1
	surgeCount = 1
	self:Berserk(600)
	self:Bar(62662, L["surge_bar"]:format(surgeCount), 60, 62662)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Vapor()
	self:Message("vapor", L["vapor_message"]:format(vaporCount), "Positive", 63323)
	vaporCount = vaporCount + 1
	if vaporCount < 7 then
		self:Bar("vapor", L["vapor_bar"]:format(vaporCount), 30, 63323)
	end
end

function mod:Animus()
	self:Message("animus", L["animus_message"], "Important", 63319)
end

function mod:UNIT_AURA(event, unit)
	if unit and unit ~= "player" then return end
	local _, _, icon, stack = UnitDebuff("player", vapor)
	if stack and stack ~= lastVapor then
		if stack > 5 then
			self:LocalMessage("vaporstack", L["vaporstack_message"]:format(stack), "Personal", icon)
			self:FlashShake("vaporstack")
		end
		lastVapor = stack
	end
end

do
	local id, name, handle = nil, nil, nil
	local function scanTarget()
		local bossId = mod:GetUnitIdByGUID(33271)
		if not bossId then return end
		local target = UnitName(bossId .. "target")
		if target then
			if UnitIsUnit(target, "player") then
				mod:FlashShake(62660)
				mod:Say(62660, L["crash_say"])
			end
			mod:TargetMessage(62660, name, target, "Personal", id, "Alert")
			mod:Whisper(62660, target, name)
			mod:SecondaryIcon(62660, target)
		end
		handle = nil
	end

	function mod:Crash(player, spellId, _, _, spellName)
		id, name = spellId, spellName
		self:CancelTimer(handle, true)
		handle = self:ScheduleTimer(scanTarget, 0.1)
	end
end

function mod:Mark(player, spellId)
	self:TargetMessage(63276, L["mark_message"], player, "Personal", spellId, "Alert")
	if UnitIsUnit(player, "player") then self:FlashShake(63276) end
	self:Whisper(63276, player, L["mark_message"])
	self:Bar(63276, L["mark_message_other"]:format(player), 10, spellId)
	self:PrimaryIcon(63276, player)
end

function mod:Flame(_, spellId, _, _, spellName)
	self:Message(62661, spellName, "Urgent", spellId)
end

function mod:Surge(_, spellId)
	self:Message(62662, L["surge_message"]:format(surgeCount), "Important", spellId)
	self:Bar(62662, L["surge_cast"]:format(surgeCount), 3, spellId)
	surgeCount = surgeCount + 1
	self:Bar(62662, L["surge_bar"]:format(surgeCount), 60, spellId)
end

function mod:SurgeGain(_, spellId, _, _, spellName)
	self:Bar(62662, spellName, 10, spellId)
end

