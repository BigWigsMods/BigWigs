------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Prince Malchezaar"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local afflict

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Malchezaar",

	phase_cmd = "engage",
	phase_name = "Engage",
	phase_desc = "Alert when changing phases",

	enfeeble_cmd = "enfeeble",
	enfeeble_name = "Enfeeble",
	enfeeble_desc = "Show cooldown timer for enfeeble",

	infernals_cmd = "infernals",
	infernals_name = "Infernals",
	infernals_desc = "Show cooldown timer for Infernal summons.",

	nova_cmd = "nova",
	nova_name = "Shadow Nova",
	nova_desc = "Estimated Shadow Nova timers",

	phase1_trigger = "Madness has brought you here to me. I shall be your undoing!",
	phase2_trigger = "Simple fools! Time is the fire in which you'll burn!",
	phase3_trigger = "How can you hope to stand against such overwhelming power?",
	phase1_message = "Phase 1 - Infernal in ~40sec!",
	phase2_message = "60% - Phase 2",
	phase3_message = "30% - Phase 3 ",

	enfeeble_trigger = "afflicted by Enfeeble",
	enfeeble_message = "Enfeeble! next in ~30sec",
	enfeeble_warning = "Enfeeble in ~5sec!",
	enfeeble_bar = "Enfeeble",
	enfeeble_nextbar = "Next Enfeeble",

	infernal_trigger1 = "You face not Malchezzar alone, but the legions I command!",
	infernal_trigger2 = "All realities, all dimensions are open to me!",
	infernal_bar = "Incoming Infernal",
	infernal_warning = "Infernal incoming in ~20sec!",
	infernal_message = "Infernal in ~5sec!",

	nova_trigger = "Prince Malchezaar begins to cast Shadow Nova",
	nova_message = "Shadow Nova!",
	nova_bar = "~Incoming Nova",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

BigWigsMalchezaar = BigWigs:NewModule(boss)
BigWigsMalchezaar.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsMalchezaar.enabletrigger = boss
BigWigsMalchezaar.toggleoptions = {"phase", "enfeeble", "nova", "infernals", "bosskill"}
BigWigsMalchezaar.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsMalchezaar:OnEnable()
	afflict = nil
	self:RegisterEvent("BigWigs_Message")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "EnfeebleEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "EnfeebleEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "EnfeebleEvent")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MalchezaarEnfeeble", 20)
	self:TriggerEvent("BigWigs_ThrottleSync", "MalchezaarNova", 20)
end

------------------------------
--     Event Handlers    --
------------------------------

function BigWigsMalchezaar:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.infernals and (msg == L["infernal_trigger1"] or msg == L["infernal_trigger2"]) then
		self:Message(L["infernal_warning"], "Positive")
		self:NextInfernal()
	elseif self.db.profile.phase and msg == L["phase1_trigger"] then
		self:Message(L["phase1_message"], "Positive")
	elseif self.db.profile.phase and msg == L["phase2_trigger"] then
		self:Message(L["phase2_message"], "Positive")
	elseif self.db.profile.phase and msg == L["phase3_trigger"] then
		self:Message(L["phase3_message"], "Positive")
	end
end

function BigWigsMalchezaar:NextInfernal()
	self:DelayedMessage(15, L["infernal_message"], "Urgent", nil, "Alert")
	self:Bar(L["infernal_bar"], 20, "INV_Stone_05")
end

function BigWigsMalchezaar:EnfeebleEvent(msg)
	if not afflict and msg:find(L["enfeeble_trigger"]) then
		self:Sync("MalchezaarEnfeeble")
	end
end

function BigWigsMalchezaar:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["nova_trigger"]) then
		self:Sync("MalchezaarNova")
	end
end

function BigWigsMalchezaar:BigWigs_RecvSync(sync, rest, nick)
	if sync == "MalchezaarEnfeeble" and self.db.profile.enfeeble then
		afflict = true
		self:Message(L["enfeeble_message"], "Important", nil, "Alarm")
		self:DelayedMessage(25, L["enfeeble_warning"], "Attention")
		self:Bar(L["enfeeble_bar"], 7, "Spell_Shadow_LifeDrain02")
		self:Bar(L["enfeeble_nextbar"], 30, "Spell_Shadow_LifeDrain02")
	elseif sync == "MalchezaarEnfeeble" and self.db.profile.nova then
		self:Bar(L["nova_bar"], 5, "Spell_Shadow_Shadowfury")
	elseif sync == "MalchezaarNova" and self.db.profile.nova then
		self:Message(L["nova_message"], "Attention", nil, "Info")
		self:Bar(L["nova_message"], 2, "Spell_Shadow_Shadowfury")
	end
end

function BigWigsMalchezaar:BigWigs_Message(text)
	if text == L["enfeeble_warning"] then
		afflict = nil
	end
end
