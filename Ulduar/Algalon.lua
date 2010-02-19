--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Algalon the Observer", "Ulduar")
if not mod then return end
mod:RegisterEnableMob(32871)
mod.toggleOptions = {"phase", 64412, 62301, 64122, 64443, "berserk", "bosskill" }

--------------------------------------------------------------------------------
-- Locals
--

local p2 = nil
local phase = nil
local blackholes = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phase = "Phases"
	L.phase_desc = "Warn for phase changes."
	L.engage_warning = "Phase 1"
	L.phase2_warning = "Phase 2 incoming"
	L.phase_bar = "Phase %d"
	L.engage_trigger = "Your actions are illogical. All possible results for this encounter have been calculated. The Pantheon will receive the Observer's message regardless of outcome."

	L.punch_message = "%2$dx Phase Punch on %1$s"
	L.smash_message = "Incoming Cosmic Smash!"
	L.blackhole_message = "Black Hole %d!"
	L.bigbang_bar = "Next Big Bang"
	L.bigbang_soon = "Big Bang soon!"

	L.end_trigger = "I have seen worlds bathed in the Makers' flames."
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Punch", 64412)
	self:Log("SPELL_AURA_APPLIED_DOSE", "PunchCount", 64412)
	self:Log("SPELL_CAST_SUCCESS", "Smash", 62301, 64598)
	self:Log("SPELL_CAST_SUCCESS", "BlackHole", 64122, 65108)
	self:Log("SPELL_CAST_START","BigBang", 64443, 64584)
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Yell("Engage", L["engage_trigger"])
	self:Yell("Win", L["end_trigger"])
end

function mod:OnEngage()
	blackholes = 0
	phase = 1
	local offset = 0
	local text = select(3, GetWorldStateUIInfo(1))
	local num = tonumber((text or ""):match("(%d+)") or nil)
	if num == 60 then offset = 19 end
	self:Bar("phase", L["phase_bar"]:format(phase), 8+offset, "INV_Gizmo_01")
	local sn = GetSpellInfo(64443)
	self:Bar(64443, sn, 98+offset, 64443)
	self:DelayedMessage(64443, 93+offset, L["bigbang_soon"], "Attention")
	local sn = GetSpellInfo(62301)
	self:Bar(62301, sn, 33+offset, 64597)
	self:Berserk(360+offset)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, msg)
	if UnitName(msg) == self.displayName then
		local hp = UnitHealth(msg) / UnitHealthMax(msg) * 100
		if hp <= 20 and not p2 then
			self:Message("phase", L["phase2_warning"], "Positive")
			p2 = true
		elseif hp > 20 and p2 then
			p2 = nil
		end
	end
end

function mod:Punch(_, spellId, _, _, spellName)
	self:Bar(64412, spellName, 15, spellId)
end

function mod:PunchCount(player, spellId, _, _, _, stack)
	if stack >= 4 then
		self:TargetMessage(64412, L["punch_message"], player, "Urgent", spellId, "Alert", stack)
	end
end

function mod:Smash(_, _, _, _, spellName)
	self:Message(62301, L["smash_message"], "Attention", 64597, "Info")
	self:Bar(62301, L["smash_message"], 5, 64597)
	self:Bar(62301, spellName, 25, 64597)
end

function mod:BlackHole(_, spellId)
	blackholes = blackholes + 1
	self:Message(64122, L["blackhole_message"]:format(blackholes), "Positive", spellId)
end

function mod:BigBang(_, spellId, _, _, spellName)
	self:Message(64443, spellName, "Important", 64443, "Alarm")
	self:Bar(64443, spellName, 8, 64443)
	self:Bar(64443, L["bigbang_bar"], 90, 64443)
	self:DelayedMessage(64443, 85, L["bigbang_soon"], "Attention")
end

