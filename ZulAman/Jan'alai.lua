------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Jan'alai"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local fmt = string.format
local UnitName = UnitName

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Jan'alai",

	engage_trigger = "Spirits of da wind be your doom!",

	flame = "Flame Breath",
	flame_desc = "Warn who Jan'alai casts Flame Strike on.",
	flame_trigger = "Jan'alai begins to cast Flame Breath.",
	flame_message = "Flame Breath on %s!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Target Icon on the player targetted by Flame Breath. (requires promoted or higher)",

	bomb = "Fire Bomb",
	bomb_desc = "Show timers for Fire Bomb.",
	bomb_trigger = "I burn ya now!",
	bomb_message = "Incoming Fire Bombs!",

	adds = "Adds",
	adds_desc = "Warn for Incoming Adds.",
	adds_trigger = "Where ma hatcha? Get to work on dem eggs!",
	adds_message = "Incoming Adds!",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Les esprits du vent, ils vont être votre fin !",

	flame = "Souffle de flammes",
	flame_desc = "Préviens sur qui Jan'alai incante son Souffle de flammes.",
	flame_trigger = "Jan'alai commence à lancer Souffle de flammes.",
	flame_message = "Souffle de flammes sur %s !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par le Souffle de flammes (nécessite d'être promu ou mieux).",

	bomb = "Bombes incendiaires",
	bomb_desc = "Affiche les délais concernant les bombes incendiaires.",
	bomb_trigger = "J'vais vous cramer !",
	bomb_message = "Arrivée des bombes incendiaires !",

	adds = "Adds",
	adds_desc = "Préviens de l'arrivée des adds.",
	adds_trigger = "Où sont mes perce-coque ? Au boulot ! Faut qu'ça éclose !",
	adds_message = "Arrivée des adds !",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Aman"]
mod.enabletrigger = boss
mod.toggleoptions = {"bomb", "adds", -1, "flame", "icon", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

local function ScanTarget()
	local target
	if UnitName("target") == boss then
		target = UnitName("targettarget")
	elseif UnitName("focus") == boss then
		target = UnitName("focustarget")
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			if UnitName(fmt("%s%d%s", "raid", i, "target")) == boss then
				target = UnitName(fmt("%s%d%s", "raid", i, "targettarget"))
				break
			end
		end
	end
	if target then
		self:Message(fmt(L["flame_message"], target), "Important")
		if self.db.profile.icon then
			self:Icon(target)
		end
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if self.db.profile.flame and msg == L["flame_trigger"] then
		self:ScheduleEvent("BWFlameToTScan", ScanTarget, 0.2)
	end
end


function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.bomb and msg == L["bomb_trigger"] then
		self:Message(L["bomb_message"], "Urgent")
		self:Bar(L["bomb"], 12, "Spell_Fire_Fire")
	elseif self.db.profile.adds and msg == L["adds_trigger"] then
		self:Message(L["adds_message"], "Positive")
	elseif self.db.profile.enrage and msg == L["engage_trigger"] then
		self:Message(fmt(L2["enrage_start"], boss, 5), "Attention")
		self:DelayedMessage(120, fmt(L2["enrage_min"], 3), "Positive")
		self:DelayedMessage(240, fmt(L2["enrage_min"], 1), "Positive")
		self:DelayedMessage(270, fmt(L2["enrage_sec"], 30), "Positive")
		self:DelayedMessage(290, fmt(L2["enrage_sec"], 10), "Urgent")
		self:DelayedMessage(295, fmt(L2["enrage_sec"], 5), "Urgent")
		self:DelayedMessage(300, fmt(L2["enrage_end"], boss), "Attention", nil, "Alarm")
		self:Bar(L2["enrage"], 300, "Spell_Shadow_UnholyFrenzy")
	end
end

