------------------------------
--     Are you local?     --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Moroes"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local enrageannounced

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Moroes",

	engage_cmd = "engage",
	engage_name = "Engage",
	engage_desc = "Warn when Moroes is pulled",

	vanish_cmd = "vanish",
	vanish_name = "Vanish",
	vanish_desc = "Warn when Moroes Vanishe's",

	garrote_cmd = "garrote",
	garrote_name = "Garrote",
	garrote_desc = "Notify of players afflicted by Garrote",

	enrage_cmd = "enrage",
	enrage_name = "Enrage",
	enrage_desc = "Warn when Moroes becomes enraged",

	icon_cmd = "icon",
	icon_name = "Icon",
	icon_desc = "Place a Raid Icon on the player afflicted by Garrote(requires promoted or higher)",

	vanish_trigger1 = "You rang?",
	vanish_trigger2 = "Now, where was I? Oh, yes...",
	vanish_message = "Vanished! Next in ~35sec!",
	vanish_warning = "Vanish Soon!",
	vanish_bar = "Next Vanish",

	garrote_trigger = "^([^%s]+) ([^%s]+) afflicted by Garrote",
	garrote_message = "Garrote: %s",

	engage_trigger = "Hm, unannounced visitors. Preparations must be made...",
	engage_message = "Moroes Engaged - Vanish in ~35sec!",

	enrage_trigger = "%s becomes enraged!",
	enrage_message = "Enrage!",
	enrage_warning = "Enrage Soon!",

	you = "You",
} end)

L:RegisterTranslations("deDE", function() return {
	engage_name = "Engage",
	engage_desc = "Warn when Moroes is pulled",

	vanish_name = "Vanish",
	vanish_desc = "Warn when Moroes Vanishe's",

	garrote_name = "Garrote",
	garrote_desc = "Notify of players afflicted by Garrote",

	enrage_name = "Enrage",
	enrage_desc = "Warn when Moroes becomes enraged",

	vanish_trigger1 = "Ihr habt gel\195\164utet?",
	vanish_trigger2 = "Nun, wo war ich? Ah, ja...",
	vanish_message = "Vanished! Next in ~35sec!",
	vanish_warning = "Vanish Soon!",
	vanish_bar = "Next Vanish",

	garrote_trigger = "^([^%s]+) ([^%s]+) afflicted by Garrote",
	garrote_message = "Garrote: %s",

	engage_trigger = "Hm, unangek\195\188ndigte Besucher.*",
	engage_message = "Moroes Engaged - Vanish in ~35sec!",

	enrage_trigger = "%s wird w\195\188tend!",
	enrage_message = "Enrage!",
	enrage_warning = "Enrage Soon!",

	you = "Ihr",
} end )

----------------------------------
--   Module Declaration    --
----------------------------------

BigWigsMoroes = BigWigs:NewModule(boss)
BigWigsMoroes.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsMoroes.enabletrigger = boss
BigWigsMoroes.toggleoptions = {"engage", "vanish", "enrage", -1, "garrote", "icon", "bosskill"}
BigWigsMoroes.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsMoroes:OnEnable()
	enrageannounced = nil

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "GarroteEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "GarroteEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "GarroteEvent")

	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MoroesGarrote", 5)
end

------------------------------
--    Event Handlers     --
------------------------------

function BigWigsMoroes:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.vanish and (msg == L["vanish_trigger1"] or msg == L["vanish_trigger2"]) then
		self:Message(L["vanish_message"], "Urgent", nil, "Alert")
		self:NextVanish()
	elseif self.db.profile.engage and msg == L["engage_trigger"] then
		self:Message(L["engage_message"], "Attention")
		self:NextVanish()
	end
end

function BigWigsMoroes:NextVanish()
	self:Bar(L["vanish_bar"], 35, "Ability_Vanish")
	self:DelayedMessage(30, L["vanish_warning"], "Attention")
end

function BigWigsMoroes:CHAT_MSG_MONSTER_EMOTE(msg)
	if self.db.profile.enrage and msg == L["enrage_trigger"] then
		self:Message(L["enrage_message"], "Important", nil, "Alarm")
	end
end

function BigWigsMoroes:UNIT_HEALTH(msg)
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 30 and health <= 34 and not enrageannounced then
			if self.db.profile.enrage then
				self:Message(L["enrage_warning"], "Positive", nil, "Info")
			end
			enrageannounced = true
		elseif health > 40 and enrageannounced then
			enrageannounced = nil
		end
	end
end

function BigWigsMoroes:GarroteEvent(msg)
	local gplayer, gtype = select(3, msg:find(L["garrote_trigger"]))
	if gplayer then
		if gplayer == L["you"] then
			gplayer = UnitName("player")
		end
		self:Sync("MoroesGarrote "..gplayer)
	end
end

function BigWigsMoroes:BigWigs_RecvSync( sync, rest, nick )
	if sync == "MoroesGarrote" and rest and self.db.profile.garrote then
		self:Message(L["garrote_message"]:format(rest), "Attention")
	end
	if self.db.profile.icon then
		self:SetRaidIcon(rest)
	end
end
