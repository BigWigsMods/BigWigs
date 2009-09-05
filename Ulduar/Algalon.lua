----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Algalon the Observer"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.zoneName = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 32871
mod.toggleOptions = {"phase", 64412, 62301, 64122, 64443, "berserk", "bosskill"}
mod.consoleCmd = "Algalon"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local p2 = nil
local phase = nil
local blackholes = 0

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Algalon", "enUS", true)
if L then
	L.phase = "Phases"
	L.phase_desc = "Warn for phase changes."
	L.engage_warning = "Phase 1"
	L.phase2_warning = "Phase 2 incoming"
	L.phase_bar = "Phase %d"
	L.engage_trigger = "Your actions are illogical. All possible results for this encounter have been calculated. The Pantheon will receive the Observer's message regardless of outcome."

	L.punch_message = "%dx Phase Punch on %s"
	L.smash_message = "Incoming Cosmic Smash!"
	L.blackhole_message = "Black Hole %d!"
	L.bigbang_soon = "Big Bang soon!"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Algalon")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Punch", 64412)
	self:AddCombatListener("SPELL_AURA_APPLIED_DOSE", "PunchCount", 64412)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Smash", 62301, 64598)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "BlackHole", 64122, 65108)
	self:AddCombatListener("SPELL_CAST_START","BigBang", 64443, 64584)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:UNIT_HEALTH(msg)
	if not db.phase then return end
	if UnitName(msg) == boss then
		local hp = UnitHealth(msg)
		if hp <= 20 and not p2 then
			self:IfMessage(L["phase2_warning"], "Positive")
			p2 = true
		elseif hp > 20 and p2 then
			p2 = nil
		end
	end
end

function mod:Punch(_, spellId, _, _, spellName)
	self:Bar(spellName, 15, spellId)
end

function mod:PunchCount(player, spellId, _, _, spellName)
	local _, _, icon, stack = UnitDebuff(player, spellName)
	if stack >= 4 then
		self:IfMessage(L["punch_message"]:format(stack, player), "Urgent", icon)
	end
end

function mod:Smash(_, _, _, _, spellName)
	self:IfMessage(L["smash_message"], "Attention", 64597, "Info")
	self:Bar(L["smash_message"], 5, 64597)
	self:Bar(spellName, 25, 64597)
end

function mod:BlackHole(_, spellId)
	blackholes = blackholes + 1
	self:IfMessage(L["blackhole_message"]:format(blackholes), "Positive", spellId)
end

function mod:BigBang(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", 64443, "Alarm")
	self:Bar(spellName, 8, 64443)
	self:Bar(spellName, 90, 64443)
	self:DelayedMessage(85, L["bigbang_soon"], "Attention")
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) then
		blackholes = 0
		phase = 1
		self:Bar(L["phase_bar"]:format(phase), 8, "INV_Gizmo_01")
		if self:GetOption(64443) then
			local sn = GetSpellInfo(64443)
			self:Bar(sn, 98, 64443)
			self:DelayedMessage(93, L["bigbang_soon"], "Attention")
		end
		if self:GetOption(62301) then
			local sn = GetSpellInfo(62301)
			self:Bar(sn, 33, 64597)
		end
		if db.berserk then
			self:Enrage(360, true, true)
		end
	end
end

