----------------------------------
--      Module Declaration      --
----------------------------------

local boss = "Sartharion"
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
local shadron, tenebron, vesperon
mod.bossName = { boss, "Shadron", "Tenebron", "Vesperon" }
mod.displayName = boss
mod.zoneName = "The Obsidian Sanctum"
mod.otherMenu = "Northrend"
--[[
	28860 = sartharion
	30452 = tenebron
	30451 = shadron
	30449 = vesperon
--]]
mod.enabletrigger = { 28860, 30449, 30451, 30452 } 
mod.guid = 28860
mod.toggleOptions = {"tsunami", 56908, -1, "drakes", "twilight", "berserk", "bosskill"}
mod.consoleCmd = "Sartharion"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local fmt = string.format
local shadronStarted, tenebronStarted, vesperonStarted = nil, nil, nil

------------------------------
--      English Locale      --
------------------------------
L = LibStub("AceLocale-3.0"):NewLocale("BigWigsSartharion", "enUS", true)
if L then
	L.engage_trigger = "It is my charge to watch over these eggs. I will see you burn before any harm comes to them!"

	L.tsunami = "Flame Wave"
	L.tsunami_desc = "Warn for churning lava and show a bar."
	L.tsunami_warning = "Wave in ~5sec!"
	L.tsunami_message = "Flame Wave!"
	L.tsunami_cooldown = "Wave Cooldown"
	L.tsunami_trigger = "The lava surrounding %s churns!"

	L.breath_cooldown = "~Breath Cooldown"

	L.drakes = "Drake Adds"
	L.drakes_desc = "Warn when each drake add will join the fight."
	L.drakes_incomingsoon = "%s landing in ~5sec!"
	
	L.twilight = "Twilight Events"
	L.twilight_desc = "Warn what happens in the Twilight."
	L.twilight_trigger_tenebron = "Tenebron begins to hatch eggs in the Twilight!"
	L.twilight_trigger_vesperon = "A Vesperon Disciple appears in the Twilight!"
	L.twilight_trigger_shadron = "A Shadron Acolyte appears in the Twilight!"
	L.twilight_message_tenebron = "Eggs hatching"
	L.twilight_message = "%s add up!"
end
L = LibStub("AceLocale-3.0"):GetLocale("BigWigs"..boss)
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnRegister()
	shadron, tenebron, vesperon = mod.bossName[2], mod.bossName[3], mod.bossName[4]
	db = self.db.profile
end

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "DrakeCheck", 58105, 61248, 61251)
	self:AddCombatListener("SPELL_CAST_START", "Breath", 56908, 58956)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

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

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg, mob)
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

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
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

