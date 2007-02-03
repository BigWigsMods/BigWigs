------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High King Maulgar"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local started

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Maulgar",

	heal_cmd = "heal",
	heal_name = "Heal",
	heal_desc = "Warn when Blindeye the Seer begins to cast Prayer of Healing",

	shield_cmd = "shield",
	shield_name = "Shield",
	shield_desc = "Warn when Blindeye the Seer gains Greater Power Word: Shield",

	spellshield_cmd = "spellshield",
	spellshield_name = "Spell Shield",
	spellshield_desc = "Warn when Krosh Firehand gains Spell Shield",

	whirlwind_cmd = "whirlwind",
	whirlwind_name = "Whirldwind",
	whirlwind_desc = "Warn when Maulgar gains Whirlwind",

	heal_trigger = "begins to cast Prayer of Healing",
	heal_message = "Blindeye casting Prayer of Healing!",
	heal_bar = "Healing",

	shield_trigger = "gains Greater Power Word: Shield",
	shield_message = "Interupt Shield on Blindeye!",

	spellshield_trigger = "gains Spell Shield.",
	spellshield_message = "Spell Shield on Krosh!",

	whirlwind_trigger = "gains Whirlwind",
	whirlwind_message = "Maulgar - Whirldwind for 15sec!",
	whirlwind_bar = "Whirlwind",
	whirlwind_nextbar = "Next WhirlWind",
	whirlwind_warning1 = "Maulgar Engaged - Whirldwind in ~50sec!",
	whirlwind_warning2 = "Whirldwind in ~30sec",
	whirlwind_warning3 = "Whirldwind in ~10sec",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsMaulgar = BigWigs:NewModule(boss)
BigWigsMaulgar.zonename = AceLibrary("Babble-Zone-2.2")["Gruul's Lair"]
BigWigsMaulgar.otherMenu = true
BigWigsMaulgar.enabletrigger = boss
BigWigsMaulgar.toggleoptions = {"shield", "spellshield", -1, "whirlwind", "heal", "bosskill"}
BigWigsMaulgar.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsMaulgar:OnEnable()
	started = nil

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsMaulgar:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if (msg:find(L["heal_trigger"])) and self.db.profile.heal then
		self:TriggerEvent("BigWigs_Message", L["heal_message"], "Important", nil, "Alarm")
	end
end

function BigWigsMaulgar:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg:find(L["shield_trigger"]) and self.db.profile.shield then
		self:TriggerEvent("BigWigs_Message", L["shield_message"], "Important")
	elseif msg:find(L["spellshield_trigger"]) and self.db.profile.spellshield then
		self:TriggerEvent("BigWigs_Message", L["spellshield_message"], "Attention", nil, "Info")
	elseif msg:find(L["whirlwind_trigger"]) and self.db.profile.whirlwind then
		self:TriggerEvent("BigWigs_Message", L["whirlwind_message"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["whirlwind_bar"], 15, "Interface\\Icons\\Ability_Whirlwind")
		self:Nextwhirldwind()
	end
end

function BigWigsMaulgar:BigWigs_RecvSync( sync, rest, nick )
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.whirlwind then
			self:TriggerEvent("BigWigs_Message", L["whirlwind_warning1"], "Attention")
			self:Nextwhirldwind()
		end
	end
end

function BigWigsMaulgar:Nextwhirldwind()
	self:ScheduleEvent("BigWigs_Message", 20, L["whirlwind_warning2"], "Positive")
	self:ScheduleEvent("BigWigs_Message", 40, L["whirlwind_warning3"], "Urgent")
	self:TriggerEvent("BigWigs_StartBar", self, L["whirlwind_nextbar"], 50, "Interface\\Icons\\Ability_Whirlwind")
end
