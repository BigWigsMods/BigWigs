------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Fathom-Lord Karathress"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Karathress",

	enrage = "Enrage",
	enrage_desc = "Enrage timer.",

	totem = "Spitfire Totem",
	totem_desc = "Warn for Spitfire Totems and who cast them.",

	heal = "Heal",
	heal_desc = "Warn when Caribdis casts a heal.",

	enrage_trigger = "Guards, attention!",
	enrage_message = "%s engaged, Enrage in 10min",
	enrage_min = "Enrage in %dmin",
	enrage_sec = "Enrage in %dsec!",

	totem_trigger1 = "Guard Tidalvess casts Spitfire Totem",
	totem_trigger2 = "Lord Karathress casts Spitfire Totem",
	totem_message1 = "Tidalvess: Spitfire Totem",
	totem_message2 = "Karathress: Spitfire Totem",

	heal_trigger = "Caribdis begins to cast Healing Wave",
	heal_message = "Caribdis casting heal!",

	["Fathom-Guard Sharkkis"] = true, --hunter
	["Fathom-Guard Tidalvess"] = true, --shaman
	["Fathom-Guard Caribdis"] = true, --priest
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Coilfang Reservoir"]
mod.otherMenu = "Serpentshrine Cavern"
mod.enabletrigger = boss
mod.wipemobs = {L["Fathom-Guard Sharkkis"], L["Fathom-Guard Tidalvess"], L["Fathom-Guard Caribdis"]}
mod.toggleoptions = {"heal", "enrage", "totem", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "KaraTotem", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "TidaTotem", 5)
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.enrage and msg:find(L["enrage_trigger"]) then
		self:Message(L["enrage_message"]:format(boss), "Important")
		self:DelayedMessage(300, L["enrage_min"]:format(5), "Positive")
		self:DelayedMessage(420, L["enrage_min"]:format(3), "Positive")
		self:DelayedMessage(540, L["enrage_sec"]:format(60), "Positive")
		self:DelayedMessage(570, L["enrage_sec"]:format(30), "Positive")
		self:DelayedMessage(590, L["enrage_sec"]:format(10), "Urgent")
		self:DelayedMessage(600, L["enrage"], "Attention", nil, "Alarm")
		self:Bar(L["enrage"], 600, "Spell_Shadow_UnholyFrenzy")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["heal_trigger"]) and self.db.profile.heal then
		self:Message(L["heal_message"], "Important", nil, "Long")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg:find(L["totem_trigger1"]) then
		self:Sync("TidaTotem")
	elseif msg:find(L["totem_trigger2"]) then
		self:Sync("KaraTotem")
	end
end

function mod:BigWigs_RecvSync(sync)
	if sync == "KaraTotem" and self.db.profile.totem then
		self:Message(L["totem_message2"], "Urgent", nil, "Alarm")
	elseif sync == "TidaTotem" and self.db.profile.totem then
		self:Message(L["totem_message1"], "Attention")
	end
end
