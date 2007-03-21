------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Al'ar"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local buffet

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Alar",

	rebirth = "Rebirth",
	rebirth_desc = "Alern when Al'ar casts rebirth",

	buffet = "Flame Buffet",
	buffet_desc = "Approximate Flame Buffet Timers",

	rebirth_trigger = "Al'ar begins to cast Rebirth.",
	rebirth_message = "Rebirth!",

	buffet_trigger = "afflicted by Flame Buffet",
	buffet_message = "Flame Buffet! Next in ~40sec",
	buffet_warning = "Flame Buffet Soon",
	buffet_bar = "Flame Buffet",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Tempest Keep"]
mod.otherMenu = "The Eye"
mod.enabletrigger = boss
mod.toggleoptions = {"rebirth", "buffet", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("BigWigs_Message")
	buffet = nil
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if self.db.profile.rebirth and msg == L["rebirth_trigger"] then
		self:Message(L["rebirth_message"], "Urgent", nil, "Alarm")
		self:Bar(L["rebirth_message"], 2, "Spell_Fire_Burnout")
	end
end

function mod:Event(msg)
	if not buffet and self.db.profile.buffet and msg:find(L["buffet_trigger"]) then
		self:Message(L["buffet_message"], "Attention")
		self:DelayedMessage(36, L["buffet_warning"], "Positive")
		self:Bar(L["buffet_bar"], 40, "Spell_Fire_Fireball")
		buffet = true
	end
end

function mod:BigWigs_Message(text)
	if text == L["buffet_warning"] then
		buffet = nil
	end
end
