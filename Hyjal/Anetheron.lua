------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Anetheron"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Anetheron",

	engage_trigger = "You are defenders of a doomed world! Flee here, and perhaps you will prolong your pathetic lives!",

	inferno = "Inferno",
	inferno_desc = "Approximate Inferno cooldown timers.",
	inferno_trigger = "begins to perform Inferno.$",
	inferno_message = "Casting Inferno!",
	inferno_warning = "Inferno Soon!",
	inferno_bar = "~Inferno Cooldown",

	swarm = "Carrion Swarm",
	swarm_desc = "Approximate Carrion Swarm cooldown timers.",
	swarm_trigger1 = "Pestilence upon you!",
	swarm_trigger2 = "The swarm is eager to feed.",
	swarm_message = "Swarm! - Next in ~11sec",
	swarm_bar = "~Swarm Cooldown",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Hyjal Summit"]
mod.enabletrigger = boss
mod.toggleoptions = {"inferno", "swarm", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "AnethInf", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync)
	if sync == "AnethInf" and self.db.profile.inferno then
		self:Message(L["inferno_message"], "Important", nil, "Alert")
		self:DelayedMessage(45, L["inferno_warning"], "Positive")
		self:Bar(L["inferno_bar"], 50, "Spell_Fire_Incinerate")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.swarm and (msg == L["swarm_trigger1"] or msg == L["swarm_trigger2"]) then
		self:Message(L["swarm_message"], "Attention")
		self:Bar(L["swarm_bar"], 11, "Spell_Shadow_CarrionSwarm")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["inferno_trigger"]) then
		self:Sync("AnethInf")
	end
end
