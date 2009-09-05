----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Thorim"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
local CL = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Common")
local behemoth = BB["Jormungar Behemoth"]
mod.zoneName = BZ["Ulduar"]
mod.guid = 32865	--Sif(33196)
mod.toggleOptions = {62042, 62331, 62017, 62338, 62526, "icon", 62279, 62130, "proximity", "hardmode", "phase", "berserk", "bosskill"}
mod.optionHeaders = {
	[62042] = CL.phase:format(2),
	[62279] = CL.phase:format(3),
	hardmode = CL.hard,
	phase = CL.general,
}
mod.proximityCheck = function(unit) return CheckInteractDistance(unit, 3) end
mod.proximitySilent = true
mod.consoleCmd = "Thorim"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local started = nil
local chargeCount = 1
local fmt = string.format
local pName = UnitName("player")

local hardModeMessageID = "" -- AceEvent flips out if not passed a string for :CancelScheduledEvent

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Thorim", "enUS", true)
if L then
	L["Runic Colossus"] = true -- For the runic barrier emote.

	L.phase = "Phases"
	L.phase_desc = "Warn for phase changes."
	L.phase1_message = "Phase 1"
	L.phase2_trigger = "Interlopers! You mortals who dare to interfere with my sport will pay.... Wait--you..."
	L.phase2_message = "Phase 2, berserk in 6:15!"
	L.phase3_trigger = "Impertinent whelps, you dare challenge me atop my pedestal? I will crush you myself!"
	L.phase3_message = "Phase 3 - %s engaged!"

	L.hardmode = "Hard mode timer"
	L.hardmode_desc = "Show timer for when you have to reach Thorim in order to enter hard mode in phase 3."
	L.hardmode_warning = "Hard mode expires"

	L.shock_message = "You're getting shocked!"
	L.barrier_message = "Barrier up!"

	L.detonation_say = "I'm a bomb!"

	L.charge_message = "Charged x%d!"
	L.charge_bar = "Charge %d"

	L.strike_bar = "Unbalancing Strike CD"

	L.end_trigger = "Stay your arms! I yield!"

	L.icon = "Raid Icon"
	L.icon_desc = "Place a Raid Icon on the player with Runic Detonation or Stormhammer. (requires promoted or higher)"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Thorim")
mod.locale = L

mod.enabletrigger = {behemoth, boss, L["Runic Colossus"]}

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Hammer", 62042)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Charge", 62279)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "StrikeCooldown", 62130)
	self:AddCombatListener("SPELL_MISSED", "StrikeCooldown", 62130)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Strike", 62130)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Detonation", 62526)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Orb", 62016)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Impale", 62331, 62418)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Barrier", 62338)
	self:AddCombatListener("SPELL_DAMAGE", "Shock", 62017)
	self:AddCombatListener("SPELL_MISSED", "Shock", 62017)
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
	db = self.db.profile
	started = nil
end

function mod:VerifyEnable(unit)
	return (UnitIsEnemy(unit, "player") and UnitCanAttack(unit, "player")) and true or false
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Barrier(_, spellId, _, _, spellName)
	self:IfMessage(L["barrier_message"], "Urgent", spellId, "Alarm")
	self:Bar(spellName, 20, spellId)
end

function mod:Charge(_, spellId)
	self:IfMessage(L["charge_message"]:format(chargeCount), "Attention", spellId)
	chargeCount = chargeCount + 1
	self:Bar(L["charge_bar"]:format(chargeCount), 15, spellId)
end

function mod:Hammer(player, spellId, _, _, spellName)
	self:TargetMessage(spellName, player, "Urgent", spellId)
	self:Bar(spellName, 16, spellId)
	self:PrimaryIcon(player, "icon")
end

function mod:Strike(player, spellId, _, _, spellName)
	self:TargetMessage(spellName, player, "Attention", spellId)
	self:Bar(spellName..": "..player, 15, spellId)
end

function mod:StrikeCooldown(player, spellId)
	self:Bar(L["strike_bar"], 25, spellId)
end

function mod:Orb(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Urgent", spellId)
	self:Bar(spellName, 15, spellId)
end

local last = 0
function mod:Shock(player, spellId)
	local time = GetTime()
	if (time - last) > 5 then
		last = time
		if player == pName then
			self:LocalMessage(L["shock_message"], "Personal", spellId, "Info")
		end
	end
end

function mod:Impale(player, spellId, _, _, spellName)
	self:TargetMessage(spellName, player, "Important", spellId)
end

function mod:Detonation(player, spellId, _, _, spellName)
	if player == pName then
		SendChatMessage(L["detonation_say"], "SAY")
	else
		self:TargetMessage(spellName, player, "Important", spellId)
	end
	self:Bar(spellName..": "..player, 4, spellId)
	self:PrimaryIcon(player, "icon")
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["phase2_trigger"] then
		if db.phase then
			self:IfMessage(L["phase2_message"], "Attention")
		end
		if db.berserk then
			self:Bar(CL["berserk"], 375, 20484)
		end
		if db.hardmode then
			self:Bar(L["hardmode"], 173, "Ability_Warrior_Innerrage")
			hardModeMessageID = self:DelayedMessage(173, L["hardmode_warning"], "Attention")
		end
	elseif msg == L["phase3_trigger"] then
		self:CancelScheduledEvent(hardModeMessageID)
		self:TriggerEvent("BigWigs_StopBar", L["hardmode"])
		self:TriggerEvent("BigWigs_StopBar", CL["berserk"])
		if db.phase then
			self:IfMessage(L["phase3_message"]:format(boss), "Attention")
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
	elseif msg == L["end_trigger"] then
		self:BossDeath(nil, self.guid)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		chargeCount = 1
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if db.phase then
			self:IfMessage(L["phase1_message"], "Attention")
		end
		self:TriggerEvent("BigWigs_HideProximity", self)
	end
end

