------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High King Maulgar"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local started
local flurryannounced

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Maulgar",

	heal_cmd = "heal",
	heal_name = "Heal",
	heal_desc = "Warn when Blindeye the Seer begins to cast a Heal",

	shield_cmd = "shield",
	shield_name = "Shield",
	shield_desc = "Warn when Blindeye the Seer gains Greater Power Word: Shield",

	spellshield_cmd = "spellshield",
	spellshield_name = "Spell Shield",
	spellshield_desc = "Warn when Krosh Firehand gains Spell Shield",

	whirlwind_cmd = "whirlwind",
	whirlwind_name = "Whirldwind",
	whirlwind_desc = "Warn when Maulgar gains Whirlwind",

	flurry_cmd = "flurry",
	flurry_name = "Flurry",
	flurry_desc = "Warn when Maulgar is close to Flurry and gains Flurry",

	heal_trigger = "Blindeye the Seer begins to cast Prayer of Healing",
	heal_message = "Blindeye casting Prayer of Healing!",
	heal_bar = "Healing",

	shield_trigger = "gains Greater Power Word: Shield",
	shield_message = "Shield on Blindeye!",

	spellshield_trigger = "gains Spell Shield.",
	spellshield_message = "Spell Shield on Krosh!",

	flurry_trigger = "You will not defeat the hand of Gruul!",
	flurry_message = "50% - Flurry!",
	flurry_warning = "Flurry Soon!",

	whirlwind_trigger = "gains Whirlwind",
	whirlwind_message = "Maulgar - Whirldwind for 15sec!",
	whirlwind_bar = "Whirlwind",
	whirlwind_nextbar = "~Next WhirlWind",
	whirlwind_warning1 = "Maulgar Engaged - Whirldwind in ~50sec!",
	whirlwind_warning2 = "Whirldwind Soon!",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsMaulgar = BigWigs:NewModule(boss)
BigWigsMaulgar.zonename = AceLibrary("Babble-Zone-2.2")["Gruul's Lair"]
BigWigsMaulgar.otherMenu = "Outland"
BigWigsMaulgar.enabletrigger = boss
BigWigsMaulgar.toggleoptions = {"shield", "spellshield", "whirlwind", "heal", "flurry", "bosskill"}
BigWigsMaulgar.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsMaulgar:OnEnable()
	started = nil
	flurryannounced = nil

	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "BlindeyeHeal", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "BlindeyePOH", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "BlindeyeShield", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "KroshSpellShield", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MaulgarWhirldwind", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsMaulgar:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg:find(L["heal_trigger"]) and self.db.profile.heal then
		self:TriggerEvent("BigWigs_SendSync", "BlindeyePrayer")
	end
end

function BigWigsMaulgar:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg:find(L["shield_trigger"]) and self.db.profile.shield then
		self:TriggerEvent("BigWigs_SendSync", "BlindeyeShield")
	elseif msg:find(L["spellshield_trigger"]) and self.db.profile.spellshield then
		self:TriggerEvent("BigWigs_SendSync", "KroshSpellShield")
	elseif msg:find(L["whirlwind_trigger"]) and self.db.profile.whirlwind then
		self:TriggerEvent("BigWigs_SendSync", "MaulgarWhirldwind")
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
	elseif sync == "BlindeyePrayer" then
		self:TriggerEvent("BigWigs_Message", L["heal_message"], "Important", nil, "Alarm")
	elseif sync == "BlindeyeShield" then
		self:TriggerEvent("BigWigs_Message", L["shield_message"], "Important")
	elseif sync == "KroshSpellShield" then
		self:TriggerEvent("BigWigs_Message", L["spellshield_message"], "Attention", nil, "Info")
	elseif sync == "MaulgarWhirldwind" then
		self:TriggerEvent("BigWigs_Message", L["whirlwind_message"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["whirlwind_bar"], 15, "Interface\\Icons\\Ability_Whirlwind")
		self:Nextwhirldwind()
	end
end

function BigWigsMaulgar:Nextwhirldwind()
	self:ScheduleEvent("BigWigs_Message", 45, L["whirlwind_warning2"], "Urgent")
	self:TriggerEvent("BigWigs_StartBar", self, L["whirlwind_nextbar"], 50, "Interface\\Icons\\Ability_Whirlwind")
end

function BigWigsMaulgar:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["flurry_trigger"]) and self.db.profile.flurry then
		self:TriggerEvent("BigWigs_Message", L["flurry_message"], "Important")
	end
end

function BigWigsMaulgar:UNIT_HEALTH(msg)
	if not self.db.profile.flurry then return end
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 52 and health <= 56 and not flurryannounced then
			self:TriggerEvent("BigWigs_Message", L["flurry_warning"], "Positive")
			flurryannounced = true
		elseif health > 62 and flurryannounced then
			flurryannounced = false
		end
	end
end

