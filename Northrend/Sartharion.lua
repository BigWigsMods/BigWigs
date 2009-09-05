----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Sartharion"]
local shadron, tenebron, vesperon = BB["Shadron"], BB["Tenebron"], BB["Vesperon"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.zoneName = BZ["The Obsidian Sanctum"]
mod.otherMenu = "Northrend"
mod.enabletrigger = {boss, shadron, tenebron, vesperon}
mod.guid = 28860
mod.toggleOptions = {"tsunami", 56908, -1, "drakes", "twilight", "berserk", "bosskill"}
mod.consoleCmd = "Sartharion"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local fmt = string.format
local shadronStarted, tenebronStarted, vesperonStarted = nil, nil, nil
local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs"..boss)

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "DrakeCheck", 58105, 61248, 61251)
	self:AddCombatListener("SPELL_CAST_START", "Breath", 56908, 58956)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	db = self.db.profile
	shadronStarted, tenebronStarted, vesperonStarted = nil, nil, nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:DrakeCheck(_, spellId)
	-- Tenebron (61248) called in roughly 15s after engage
	-- Shadron (58105) called in roughly 60s after engage
	-- Vesperon (61251) called in roughly 105s after engage
	-- Each drake takes around 12 seconds to land
	if not db.drakes then return end
	if spellId == 58105 and not shadronStarted then
		self:Bar(shadron, 80, 58105)
		self:DelayedMessage(75, fmt(L["drakes_incomingsoon"], shadron), "Attention")
		shadronStarted = true
	elseif spellId == 61248 and not tenebronStarted then
		self:Bar(tenebron, 30, 61248)
		self:DelayedMessage(25, fmt(L["drakes_incomingsoon"], tenebron), "Attention")
		tenebronStarted = true
	elseif spellId == 61251 and not vesperonStarted then
		self:Bar(vesperon, 120, 61251)
		self:DelayedMessage(115, fmt(L["drakes_incomingsoon"], vesperon), "Attention")
		vesperonStarted = true
	end
end

function mod:Breath(_, spellId)
	self:Bar(L["breath_cooldown"], 12, spellId)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, mob)
	if msg == L["tsunami_trigger"] and db.tsunami then
		self:Message(L["tsunami_message"], "Important", 57491, "Alert")
		self:Bar(L["tsunami_cooldown"], 30, 57491)
		self:DelayedMessage(25, L["tsunami_warning"], "Attention")
	elseif db.twilight then
		if mob == tenebron and msg == L["twilight_trigger_tenebron"] then
			self:Bar(L["twilight_message_tenebron"], 20, 23851)
			self:Message(L["twilight_message_tenebron"], "Attention", 23851)
		elseif mob == shadron and msg == L["twilight_trigger_shadron"] then
			self:Message(L["twilight_message"]:format(mob), "Urgent", 59570)
		elseif mob == vesperon and msg == L["twilight_trigger_vesperon"] then
			self:Message(L["twilight_message"]:format(mob), "Personal", 59569, "Alarm")
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		if db.tsunami then
			self:Bar(L["tsunami_cooldown"], 30, 57491)
			self:DelayedMessage(25, L["tsunami_warning"], "Attention")
		end
		if db.berserk then
			self:Enrage(900, true)
		end
	end
end

