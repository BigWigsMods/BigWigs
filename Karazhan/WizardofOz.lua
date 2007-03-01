------------------------------
--     Are you local?     --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["The Crone"]
local roar = AceLibrary("Babble-Boss-2.2")["Roar"]
local tinhead = AceLibrary("Babble-Boss-2.2")["Tinhead"]
local strawman = AceLibrary("Babble-Boss-2.2")["Strawman"]
local dorothee = AceLibrary("Babble-Boss-2.2")["Dorothee"]
local tito = AceLibrary("Babble-Boss-2.2")["Tito"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "WizardofOz",

	spawns_cmd = "spawns",
	spawns_name = "Spawn Timers",
	spawns_desc = "Timers for when the characters become active",

	light_cmd = "chainlightning",
	light_name = "Chain Lightning",
	light_desc = "Warn for Chain Lightning being cast",

	spawns_roar = "%s attacks!",
	warning_roar = "%s in 5 sec",
	spawns_strawman = "%s attacks!",
	warning_strawman = "%s in 5 sec",
	spawns_tinhead = "%s attacks!",
	warning_tinhead = "%s in 5 sec",
	spawns_tito = "%s summoned!",
	warning_tito = "%s in 5 sec",

	light_trigger = "The Crone begins to cast Chain Lightning",
	light_message = "Chain Lightning!",

	engage_trigger = "Oh Tito, we simply must find a way home!",
} end)

L:RegisterTranslations("deDE", function() return {
	spawns_name = "Spawn Timer",
	--spawns_desc = "Timers for when the characters become active",

	--light_name = "Chain Lightning",
	--light_desc = "Warn for Chain Lightning being cast",

	spawns_roar = "%s greift an!",
	--warning_roar = "%s in 5 sec",
	spawns_strawman = "%s greift an!",
	--warning_strawman = "%s in 5 sec",
	spawns_tinhead = "%s greift an!",
	--warning_tinhead = "%s in 5 sec",
	spawns_tito = "%s gerufen!",
	--warning_tito = "%s in 5 sec",

	--light_trigger = "The Crone begins to cast Chain Lightning",
	--light_message = "Chain Lightning!",

	engage_trigger = "Oh Tito, wir m\195\188ssen einfach einen Weg nach Hause finden!",
} end)

L:RegisterTranslations("frFR", function() return {
	spawns_name = "Alerte Hostilit\195\169",
	--spawns_desc = "Timers for when the characters become active",

	--light_name = "Chain Lightning",
	--light_desc = "Warn for Chain Lightning being cast",

	spawns_roar = "%s attaque !",
	--warning_roar = "%s in 5 sec",
	spawns_strawman = "%s attaque !",
	--warning_strawman = "%s in 5 sec",
	spawns_tinhead = "%s attaque !",
	--warning_tinhead = "%s in 5 sec",
	spawns_tito = "%s invoqu\195\169 !",
	--warning_tito = "%s in 5 sec",

	--light_trigger = "The Crone begins to cast Chain Lightning",
	--light_message = "Chain Lightning!",

	engage_trigger = "Oh, Tito, nous devons trouver le moyen de rentrer \195\160 la maison\194\160! Le vieux sorcier est notre dernier espoir\194\160!",
} end)

L:RegisterTranslations("koKR", function() return {
	spawns_name = "등장 타이머",
	--spawns_desc = "Timers for when the characters become active",

	--light_name = "Chain Lightning",
	--light_desc = "Warn for Chain Lightning being cast",

	spawns_roar = "%s 공격!",
	--warning_roar = "%s in 5 sec",
	spawns_strawman = "%s 공격!",
	--warning_strawman = "%s in 5 sec",
	spawns_tinhead = "%s 공격!",
	--warning_tinhead = "%s in 5 sec",
	spawns_tito = "%s 소환!",
	--warning_tito = "%s in 5 sec",

	--light_trigger = "The Crone begins to cast Chain Lightning",
	--light_message = "Chain Lightning!",

	engage_trigger = "티토야, 우린 집으로 갈 방법을 찾아야 해!",
} end)

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
mod.enabletrigger = {roar, tinhead, strawman, dorothee}
mod.toggleoptions = {"spawns", "light", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) and self.db.profile.spawns then
		self:Bar(L["spawns_roar"]:format(roar), 15, "INV_Staff_08")
		self:DelayedMessage(10, L["warning_roar"]:format(roar), "Attention")
		self:Bar(L["spawns_strawman"]:format(strawman), 25, "Ability_Druid_ChallangingRoar")
		self:DelayedMessage(20, L["warning_strawman"]:format(strawman), "Attention")
		self:Bar(L["spawns_tinhead"]:format(tinhead), 35, "INV_Chest_Plate06")
		self:DelayedMessage(30, L["warning_tinhead"]:format(tinhead), "Attention")
		self:Bar(L["spawns_tito"]:format(tito), 48, "Ability_Hunter_Pet_Wolf")
		self:DelayedMessage(43, L["warning_tito"]:format(tito), "Attention")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["light_trigger"]) and self.db.profile.light then
		self:Message(L["light_message"], "Urgent")
		self:Bar(L["light_message"], 2.5, "Spell_Nature_ChainLightning")
	end
end
