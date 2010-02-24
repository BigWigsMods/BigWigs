--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Sartharion", "The Obsidian Sanctum")
if not mod then return end
local shadron, tenebron, vesperon
mod.otherMenu = "Northrend"
--[[
	28860 = sartharion
	30452 = tenebron
	30451 = shadron
	30449 = vesperon
--]]
mod:RegisterEnableMob(28860, 30449, 30451, 30452)
mod.toggleOptions = {"tsunami", 56908, "drakes", {"twilight", "FLASHSHAKE"}, "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local shadronStarted, tenebronStarted, vesperonStarted = nil, nil, nil
local shadron, tenebron, vesperon = nil, nil, nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
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
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	shadron = BigWigs:Translate("Shadron")
	tenebron = BigWigs:Translate("Tenebron")
	vesperon = BigWigs:Translate("Vesperon")
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "DrakeCheck", 58105, 61248, 61251)
	self:Log("SPELL_CAST_START", "Breath", 56908, 58956)
	self:Death("Win", 28860)

	self:Emote("Tsunami", L["tsunami_trigger"])
	self:Emote("Tenebron", L["twilight_trigger_tenebron"])
	self:Emote("Shadron", L["twilight_trigger_shadron"])
	self:Emote("Vesperon", L["twilight_trigger_vesperon"])

	self:Yell("Engage", L["engage_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	shadronStarted, tenebronStarted, vesperonStarted = nil, nil, nil
end

function mod:OnEngage()
	self:Bar("tsunami", L["tsunami_cooldown"], 30, 57491)
	self:DelayedMessage("tsunami", 25, L["tsunami_warning"], "Attention")
	self:Berserk(900)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:DrakeCheck(_, spellId)
	-- Tenebron (61248) called in roughly 15s after engage
	-- Shadron (58105) called in roughly 60s after engage
	-- Vesperon (61251) called in roughly 105s after engage
	-- Each drake takes around 12 seconds to land
	if spellId == 58105 and not shadronStarted then
		self:Bar("drakes", shadron, 80, 58105)
		self:DelayedMessage("drakes", 75, L["drakes_incomingsoon"]:format(shadron), "Attention")
		shadronStarted = true
	elseif spellId == 61248 and not tenebronStarted then
		self:Bar("drakes", tenebron, 30, 61248)
		self:DelayedMessage("drakes", 25, L["drakes_incomingsoon"]:format(tenebron), "Attention")
		tenebronStarted = true
	elseif spellId == 61251 and not vesperonStarted then
		self:Bar("drakes", vesperon, 120, 61251)
		self:DelayedMessage("drakes", 115, L["drakes_incomingsoon"]:format(vesperon), "Attention")
		vesperonStarted = true
	end
end

function mod:Breath(_, spellId)
	self:Bar(56908, L["breath_cooldown"], 12, spellId)
end

function mod:Tsunami()
	self:Message("tsunami", L["tsunami_message"], "Important", 57491, "Alert")
	self:Bar("tsunami", L["tsunami_cooldown"], 30, 57491)
	self:DelayedMessage("tsunami", 25, L["tsunami_warning"], "Attention")
end

function mod:Tenebron(msg, mob)
	if mob ~= tenebron then return end
	self:Bar("twilight", L["twilight_message_tenebron"], 20, 23851)
	self:Message("twilight", L["twilight_message_tenebron"], "Attention", 23851)
end

function mod:Shadron(msg, mob)
	if mob ~= shadron then return end
	self:Message("twilight", L["twilight_message"]:format(mob), "Urgent", 59570)
end

function mod:Vesperon(msg, mob)
	if mob ~= vesperon then return end
	self:Message("twilight", L["twilight_message"]:format(mob), "Personal", 59569, "Alarm")
	self:FlashShake("twilight")
end

