------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Doomwalker"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local started = nil
local enrageAnnounced = nil

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Doomwalker",

	overrun = "Overrun",
	overrun_desc = "Alert when Doomwalker uses his Overrun ability.",

	earthquake = "Earthquake",
	earthquake_desc = "Alert when Doomwalker uses his Earthquake ability.",

	enrage = "Enrage",
	enrage_desc = "Warn about enrage around 20% hitpoints.",

	engage_message = "Doomwalker engaged, Earthquake in ~30sec!",
	enrage_soon_message = "Enrage soon!",

	earthquake_trigger = "You are afflicted by Earthquake.",

	earthquake_message = "Earthquake! ~70sec to next!",
	earthquake_bar = "Earthquake",

	overrun_trigger = "^Doomwalker.-Overrun",
	overrun_message = "Overrun!",
	overrun_soon_message = "Possible Overrun soon!",
	overrun_bar = "Overrun Cooldown",
} end)

----------------------------------
--   Module Declaration    --
----------------------------------

local mod = BigWigs:NewModule(boss, "AceHook-2.1")
mod.zonename = AceLibrary("Babble-Zone-2.2")["Shadowmoon Valley"]
mod.otherMenu = "Outland"
mod.enabletrigger = boss
mod.toggleoptions = {"overrun", "earthquake", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	started = nil
	enrageAnnounced = nil

	self:Hook("ChatFrame_MessageEventHandler", "ChatFrame_MessageEventHandler", true)

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "DoomwalkerEarthquake", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "DoomwalkerOverrun", 10)
end

------------------------------
--         Hooks               --
------------------------------

function mod:ChatFrame_MessageEventHandler(event, ...)
	if event:find("EMOTE") and (type(arg2) == "nil" or not arg2) then
		arg2 = boss
	end
	return self.hooks["ChatFrame_MessageEventHandler"](event, ...)
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:BigWigs_RecvSync( sync, rest, nick )
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.earthquake then
			self:Message(L["engage_message"], "Attention")
			self:Bar(L["earthquake_bar"], 30, "Spell_Nature_Earthquake")
		end
		if self.db.profile.overrun then
			self:Bar(L["overrun_bar"], 30, "Ability_BullRush")
			self:DelayedMessage(28, L["overrun_soon_message"], "Attention")
		end
	elseif sync == "DoomwalkerEarthquake" and self.db.profile.earthquake then
		self:Message(L["earthquake_message"], "Important")
		self:Bar(L["earthquake_bar"], 70, "Spell_Nature_Earthquake")
	elseif sync == "DoomwalkerOverrun" and self.db.profile.overrun then
		self:Message(L["overrun_message"], "Important")
		self:Bar(L["overrun_bar"], 30, "Ability_BullRush")
		self:DelayedMessage(28, L["overrun_soon_message"], "Attention")
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE(msg)
	if msg:find(L["earthquake_trigger"]) then
		self:Sync("DoomwalkerEarthquake")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["overrun_trigger"]) then
		self:Sync("DoomwalkerOverrun")
	end
end

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.enrage then return end
	if UnitName(msg) == boss then
		local health = UnitHealth(arg1)
		if health > 20 and health <= 25 and not enrageAnnounced then
			self:Message(L["enrage_soon_message"], "Urgent")
			enrageAnnounced = true
		elseif health > 40 and enrageAnnounced then
			enrageAnnounced = false
		end
	end
end
