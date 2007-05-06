------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High Warlord Naj'entus"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Naj'entus",

	start_trigger = "You will die in the name of Lady Vashj!",

	spine = "Impaling Spine",
	spine_desc = "Tells you who gets impaled",
	spine_trigger = "^([^%s]+) ([^%s]+) afflicted by Impaling Spine.$",
	spine_message = "Impaling Spine on %s!",

	shield = "Tidal Shield",
	shield_desc = "Timers for when Naj'entus will gain tidal shield.",
	shield_trigger  = "High Warlord Naj'entus is afflicted by Tidal Shield.", 
	shield_fade_trigger = "Tidal Shield fades from High Warlord Naj'entus.",
	shield_bar = "Tidal Shield",
	shield_nextbar = "Next Tidal Shield",
	shield_warn = "Tidal Shield!",
	shield_soon_warn = "Tidal Shield in 10sec!", 

	icon = "Icon",
	icon_desc = "Put an icon on players with Impaling Spine.",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = {"shield", "spine", "icon",  "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Spine")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Spine")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Spine")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "NajShieldOn", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "NajShieldGone", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "NajSpine", 2)
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.shield and msg == L["start_trigger"] then
		self:DelayedMessage(50, L["shield_soon_warn"], "Positive")
		self:Bar(L["shield_bar"], 60, "Spell_Frost_FrostBolt02")
	end
end

function mod:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if self.db.profile.shield and msg == L["shield_fade_trigger"] then
		self:Sync("NajShieldGone")
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(msg)
	if msg == L["shield_trigger"] then
		self:Sync("NajShieldOn")
	end
end

function mod:Spine(msg)
	local splayer, stype = select(3, msg:find(L["spine_trigger"]))
	if splayer and stype then
		if splayer == L2["you"] and stype == L2["are"] then
			splayer = UnitName("player")
		end
		self:Sync("NajSpine " .. splayer)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "NajSpine" and rest and self.db.profile.spine then
		self:Message(L["spine_message"]:format(rest), "Important", nil, "Alert")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "NajShieldGone" and self.db.profile.shield then
		self:DelayedMessage(50, L["shield_soon_warn"], "Positive")
		self:Bar(L["shield_nextbar"], 60, "Spell_Frost_FrostBolt02")
	elseif sync == "NajShieldOn" and self.db.profile.shield then
		self:Message(L["shield_warn"], "Important", nil, "Alert")
	end
end
