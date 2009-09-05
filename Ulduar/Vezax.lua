----------------------------------
--      Module Declaration      --
----------------------------------

local boss = "General Vezax"
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
local CL = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Common")
-- mod.bossName set after locale
mod.displayName = boss
mod.enabletrigger = 33271
mod.zoneName = "Ulduar"
mod.guid = 33271
mod.toggleOptions = {"vapor", "vaporstack", 62660, "crashsay", "crashicon", 63276, "icon", 62661, 62662, "animus", "berserk", "bosskill"}
mod.consoleCmd = "Vezax"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local vaporCount = 1
local surgeCount = 1
local pName = UnitName("player")
local fmt = string.format
local lastVapor = nil
local vapor = GetSpellInfo(63322)

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: General Vezax", "enUS", true)
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

	L.crashsay = "Crash Say"
	L.crashsay_desc = "Say when you are the target of Shadow Crash."
	L.crashicon = "Crash Icon"
	L.crashicon_desc = "Place a secondary icon on the player targetted by Shadow Crash. (requires promoted or higher)"

	L.mark_message = "Mark"
	L.mark_message_other = "Mark on %s!"

	L.icon = "Mark Icon"
	L.icon_desc = "Place a primary icon on the player targetted by Mark of the Faceless. (requires promoted or higher)"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: General Vezax")
mod.locale = L

mod.bossName = {boss, L["Vezax Bunny"]}

mod.optionHeaders = {
	vapor = L.vapor,
	[62660] = 62660,
	[63276] = 63276,
	[62661] = CL.normal,
	animus = CL.hard,
	berserk = CL.general,
}

------------------------------
--      Initialization      --
------------------------------

function mod:OnRegister()
	boss = mod.bossName[1]
end

function mod:OnBossEnable()
	db = self.db.profile
	self:AddCombatListener("SPELL_CAST_START", "Flame", 62661)
	self:AddCombatListener("SPELL_CAST_START", "Surge", 62662)
	self:AddCombatListener("SPELL_AURA_APPLIED", "SurgeGain", 62662)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Target", 60835, 62660)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Mark", 63276)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:UNIT_AURA(event, unit)
	if unit and unit ~= "player" then return end
	local _, _, icon, stack = UnitDebuff("player", vapor)
	if stack and stack ~= lastVapor then
		if db.vaporstack and stack > 5 then
			self:LocalMessage(L["vaporstack_message"]:format(stack), "Personal", icon)
		end
		lastVapor = stack
	end
end

local function scanTarget(spellId, spellName)
	local target
	if UnitName("target") == boss then
		target = UnitName("targettarget")
	elseif UnitName("focus") == boss then
		target = UnitName("focustarget")
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			if UnitName(fmt("%s%d%s", "raid", i, "target")) == boss then
				target = UnitName(fmt("%s%d%s", "raid", i, "targettarget"))
				break
			end
		end
	end
	if target then
		if target == pName and db.crashsay then
			SendChatMessage(L["crash_say"], "SAY")
		end
		if mod:GetOption(spellId) then
			mod:TargetMessage(spellName, target, "Personal", spellId, "Alert")
			mod:Whisper(target, spellName)
		end
		mod:SecondaryIcon(target, "crashicon")
		mod:CancelScheduledEvent("BWCrashToTScan")
	end
end

function mod:Mark(player, spellId)
	self:TargetMessage(L["mark_message"], player, "Personal", spellId, "Alert")
	self:Whisper(player, L["mark_message"])
	self:Bar(L["mark_message_other"]:format(player), 10, spellId)
	self:PrimaryIcon(player, "icon")
end

function mod:Target(player, spellId, _, _, spellName)
	self:ScheduleEvent("BWCrashToTScan", scanTarget, 0.1, spellId, spellName)
end

function mod:Flame(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Urgent", spellId)
end

function mod:Surge(_, spellId)
	self:IfMessage(L["surge_message"]:format(surgeCount), "Important", spellId)
	self:Bar(L["surge_cast"]:format(surgeCount), 3, spellId)
	surgeCount = surgeCount + 1
	self:Bar(L["surge_bar"]:format(surgeCount), 60, spellId)
end

function mod:SurgeGain(_, spellId, _, _, spellName)
	self:Bar(spellName, 10, spellId)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg)
	if msg == L["vapor_trigger"] and db.vapor then
		self:IfMessage(L["vapor_message"]:format(vaporCount), "Positive", 63323)
		vaporCount = vaporCount + 1
		if vaporCount < 7 then
			self:Bar(L["vapor_bar"]:format(vaporCount), 30, 63323)
		end
	elseif msg == L["animus_trigger"] and db.animus then
		self:IfMessage(L["animus_message"], "Important", 63319)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if msg:find(L["engage_trigger"]) then
		lastVapor = nil
		vaporCount = 1
		surgeCount = 1
		if db.berserk then
			self:Enrage(600, true, true)
		end
		if db.surge then
			self:Bar(L["surge_bar"]:format(surgeCount), 60, 62662)
		end
	end
end

