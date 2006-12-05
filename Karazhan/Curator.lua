------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["The Curator"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local enrageannounced
local started

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Curator",

	adds_cmd = "adds",
	adds_name = "Adds",
	adds_desc = "Warn when The Curator spawns his mana adds.",

	berserk_cmd = "berserk",
	berserk_name = "Berserk",
	berserk_desc = "Warn for berserk after 12min.",

	enrage_cmd = "enrage",
	enrage_name = "Enrage",
	enrage_desc = "Warn for enrage at 10%.",

	weaken_cmd = "weaken",
	weaken_name = "Weaken",
	weaken_desc = "Alert when The Curator is weakened.",

	adds_message = "Adds incoming!",
	adds_bar = "Adds despawn",

	weakened_message = "Curator is weakened for 20sec!",
	weakened_bar = "Weakened",

	engage_message = "Curator engaged, 12min to berserk!",
	berserk_bar = "Berserk",
	enrage_soon_alert = "Enrage soon!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsCurator = BigWigs:NewModule(boss)
BigWigsCurator.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsCurator.enabletrigger = boss
BigWigsCurator.toggleoptions = {"weaken", "adds", "berserk", "enrage", "bosskill"}
BigWigsCurator.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsCurator:OnEnable()
	self.core:Print("The Curator boss mod is beta quality, at best! Please don't rely on it for anything!")

	enrageannounced = nil
	started = nil

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "EventBucket")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "EventBucket")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_BUFF", "EventBucket")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "EventBucket")

	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

-- Event bucket until we know what's really going on.
function BigWigsCurator:EventBucket(msg)
	if string.find(msg, "Summon Flare") and self.db.profile.adds then
		self:TriggerEvent("BigWigs_Message", L["adds_message"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["adds_bar"], 30, "Interface\\Icons\\Spell_Arcane_Arcane04")
	elseif string.find(msg, "Weakened") and not string.find(msg, "Weakened Soul") and self.db.profile.weaken then
		self:TriggerEvent("BigWigs_Message", L["weakened_message"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["weakened_bar"], 20, "Interface\\Icons\\Spell_Nature_Purge")
	end
end

function BigWigsCurator:BigWigs_RecvSync(sync, rest, nick)
	if sync == self:GetEngageSync() and rest and rest == boss and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.berserk then
			self:TriggerEvent("BigWigs_Message", L["engage_message"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["berserk_bar"], 720, "Interface\\Icons\\INV_Shield_01")
		end
	end
end

function BigWigsCurator:UNIT_HEALTH(msg)
	if not self.db.profile.enrage then return end
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 10 and health <= 13 and not enrageannounced then
			self:TriggerEvent("BigWigs_Message", L["enrage_soon_alert"], "Important")
			enrageannounced = true
		elseif health > 50 and enrageannounced then
			enrageannounced = false
		end
	end
end

