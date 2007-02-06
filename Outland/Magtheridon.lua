------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Magtheridon"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Magtheridon",

	escape_cmd = "escape",
	escape_name = "Escape",
	escape_desc = "Countdown untill Magtheridon breaks free",

	abyssal_cmd = "abyssal",
	abyssal_name = "Burning Abyssal",
	abyssal_desc = "Warn when a Burning Abyssal is created",

	heal_cmd = "heal",
	heal_name = "Heal",
	heal_desc = "Warn when a Hellfire Channeler starts to heal",

	escape_trigger1 = "%s's bonds begin to weaken!",
	escape_trigger2 = "I... am... unleashed!",
	escape_warning1 = "Magtheridon Engaged - Breaks free in 2min!",
	escape_warning2 = "Breaks free in 1min!",
	escape_warning3 = "Breaks free in 30sec!",
	escape_warning4 = "Breaks free in 10sec!",
	escape_bar = "Released...",
	escape_message = "Magtheridon Released!",

	abyssal_trigger = "Hellfire Channeler 's Burning Abyssal hits",
	abyssal_message = "Burning Abyssal Created",

	heal_trigger = "begins to cast Dark Mending",
	heal_message = "Healing!",
} end)

----------------------------------
--    Module Declaration   --
----------------------------------

BigWigsMagtheridon = BigWigs:NewModule(boss)
BigWigsMagtheridon.zonename = AceLibrary("Babble-Zone-2.2")["Magtheridon's Lair"]
BigWigsMagtheridon.otherMenu = "Outland"
BigWigsMagtheridon.enabletrigger = boss
BigWigsMagtheridon.toggleoptions = {"escape", "abyssal", "heal", "bosskill"}
BigWigsMagtheridon.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsMagtheridon:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

------------------------------
--    Event Handlers     --
------------------------------

function BigWigsMagtheridon:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg:find(L["escape_trigger1"]) and self.db.profile.escape then
		self:TriggerEvent("BigWigs_Message", L["escape_warning1"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["escape_bar"], 120, "Interface\\Icons\\Ability_Rogue_Trip")
		self:ScheduleEvent("BigWigs_Message", 60, L["escape_warning2"], "Positive")
		self:ScheduleEvent("BigWigs_Message", 90, L["escape_warning3"], "Attention")
		self:ScheduleEvent("BigWigs_Message", 110, L["escape_warning4"], "Urgent", nil, "Long")
	end
end

function BigWigsMagtheridon:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["escape_trigger2"]) and self.db.profile.escape then
		self:TriggerEvent("BigWigs_Message", L["escape_message"], "Important", nil, "Alert")
	end
end

function BigWigsMagtheridon:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["abyssal_trigger"]) and self.db.profile.abyssal then
		self:TriggerEvent("BigWigs_Message", L["abyssal_message"], "Attention")
	end
end

function BigWigsMagtheridon:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg:find(L["heal_trigger"]) and self.db.profile.heal then
		self:TriggerEvent("BigWigs_Message", L["heal_message"], "Urgent", nil, "Alarm")
		self:TriggerEvent("BigWigs_StartBar", self, L["heal_message"], 2, "Interface\\Icons\\Spell_Shadow_ChillTouch")
	end
end
