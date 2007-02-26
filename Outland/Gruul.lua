------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Gruul the Dragonkiller"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local grasp
local slam
local growcount

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Gruul",

	engage_cmd = "engage",
	engage_name = "Engage",
	engage_desc = "Warn when Grull is pulled",

	grow_cmd = "grow",
	grow_name = "Grow",
	grow_desc = "Count and warn for Grull's grow",

	grasp_cmd = "grasp",
	grasp_name = "Grasp",
	grasp_desc = "Grasp warnings and timers",

	cavein_cmd = "cavein",
	cavein_name = "Cave In on You",
	cavein_desc = "Warn for a Cave In on You",

	engage_trigger = "Come.... and die.",
	engage_message = "%s Engaged!",

	grow_trigger = "%s grows in size!",
	grow_message = "Grows: (%d)",
	grow_bar = "Grow (%d)",

	grasp_trigger1 = "afflicted by Ground Slam",
	grasp_trigger2 = "afflicted by Gronn Lord's Grasp",
	grasp_message1 = "Ground Slam - Grasp Incoming",
	grasp_message2 = "Grasp Stacking - Shatter in ~5sec",
	grasp_warning = "Ground Slam Soon",

	shatter_trigger = "%s roars!",
	shatter_message = "Shatter!",

	cavein_trigger = "You are afflicted by Cave In.",
	cavein_message = "Cave In on YOU!",
} end)

L:RegisterTranslations("frFR", function() return {
	engage_name = "Alerte Engagement",
	engage_desc = "Pr\195\169viens du d\195\169but du combat.",

	grow_name = "Alerte Croissance",
	grow_desc = "Compte et avertis les croissances de Grull.",

	grasp_name = "Alerte Emprise",
	grasp_desc = "Avertissement et d\195\169lais pour Emprise du seigneur gronn.",

	cavein_name = "Alerte Eboulement sur vous",
	cavein_desc = "Pr\195\169viens quand vous \195\170tes sous un \195\169boulement.",

	engage_trigger = "Venez\226\128\166 mourir.",
	engage_message = "%s Engag\195\169 !",

	grow_trigger = "%s grandit\194\160!",
	grow_message = "Croissance: (%d)",
	grow_bar = "Croissance (%d)",

	grasp_trigger1 = " les effets .* Heurt terrestre",
	grasp_trigger2 = " les effets .* Emprise du seigneur gronn",
	grasp_message1 = "Heurt terrestre - Emprise Imminente !",
	grasp_message2 = "Emprise - Fracasser dans ~5sec",
	--grasp_warning = "Emprise", --enUS changed

	shatter_trigger = "%s rugit\194\160!",
	shatter_message = "Fracasser !",

	cavein_trigger = "Vous subissez les effets de Eboulement.",
	cavein_message = "Eboulement !",
} end)

L:RegisterTranslations("deDE", function() return {
	engage_name = "Pull Warnung",
	engage_desc = "Warnt, wenn Gruul gepulled wird",

	--grow_name = "Wachstum Warnung", --enUS changed
	--grow_desc = "Warnt, wenn Gruul w\195\164chst", --enUS changed

	grasp_name = "Griff Warnung",
	--grasp_desc = "Warnt, wenn Gruul Griff des Gronnlords zaubert", --enUS changed

	cavein_name = "H\195\182hleneinst\195\188rz auf dich",
	cavein_desc = "Warnt bei H\195\182hleneinst\195\188rz auf dir",

	engage_trigger = "Kommt und sterbt.",
	engage_message = "%s gepullt!",

	grow_trigger = "%s wird gr\195\182\195\159er!",
	--grow_message = "Gruul w\195\164chst!", --enUS changed
	--grow_bar = "Grow (%d)",

	grasp_trigger1 = "von Erde ersch\195\188ttern betroffen",
	grasp_trigger2 = "von Griff des Gronnlords betroffen",
	--grasp_message1 = "Griff kommt!", --enUS changed
	--grasp_message2 = "Griff des Gronnlords!", --enUS changed
	--grasp_warning = "Griff bald!", --enUS changed

	--shatter_trigger = "%s roars!",
	--shatter_message = "Shatter!",

	cavein_trigger = "Ihr seid von H\195\182hleneinst\195\188rz betroffen.",
	cavein_message = "H\195\182hleneinst\195\188rz auf dich!",
} end)

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Gruul's Lair"]
mod.otherMenu = "Outland"
mod.enabletrigger = boss
mod.toggleoptions = {"engage", "grasp", "grow", -1, "cavein", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	slam = nil
	grasp = nil
	growcount = 1

	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("CHAT_MSG_MONSTER_SAY")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_MONSTER_SAY(msg)
	if self.db.profile.engage and msg == L["engage_trigger"] then
		self:Message(L["engage_message"]:format(boss), "Attention")
		self:DelayedMessage(35, L["grasp_warning"], "Urgent")
		self:Bar(L["grasp_warning"], 40, "Ability_ThunderClap")
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if self.db.profile.grow and msg == L["grow_trigger"] then
		self:Message(L["grow_message"]:format(growcount), "Important")
		growcount = growcount + 1
		self:Bar(L["grow_bar"]:format(growcount), 30, "Spell_Shadow_Charm")
	elseif self.db.profile.grasp and msg == L["shatter_trigger"] then
		self:Message(L["shatter_message"], "Positive")
	end
end

function mod:Event(msg)
	if not slam and self.db.profile.grasp and msg:find(L["grasp_trigger1"]) then
		self:Message(L["grasp_message1"], "Attention")
		self:DelayedMessage(67, L["grasp_warning"], "Urgent")
		self:Bar(L["grasp_warning"], 72, "Ability_ThunderClap")
		slam = true
	elseif not grasp and self.db.profile.grasp and msg:find(L["grasp_trigger2"]) then
		self:Message(L["grasp_message2"], "Urgent")
		self:Bar(L["shatter_message"], 5, "Ability_ThunderClap")
		grasp = true
	elseif self.db.profile.cavein and msg == L["cavein_trigger"] then
		self:Message(L["cavein_message"], "Personal", true, "Alarm")
	end
end

function mod:BigWigs_Message(text)
	if text == L["grasp_warning"] then
		slam = nil
		grasp = nil
	end
end
