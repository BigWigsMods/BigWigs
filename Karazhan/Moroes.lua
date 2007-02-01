------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Moroes"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local enrageannounced

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Moroes",

	engage_cmd = "engage",
	engage_name = "Engage Alert",
	engage_desc = "Warn when Moroes is pulled",

	vanish_cmd = "vanish",
	vanish_name = "Vanish Alert",
	vanish_desc = "Warn when Moroes Vanishe's",

	blind_cmd = "blind",
	blind_name = "Blind Warning",
	blind_desc = "Notify of Blinde'd players",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn when Moroes becomes enraged",

	vanish_trigger1 = "You rang?",
	vanish_trigger2 = "Now, where was I? Oh, yes...",
	vanish_message = "Vanished!",

	blind_trigger = "^([^%s]+) ([^%s]+) afflicted by Blind",
	blind_message = "%s is Blinded!",

	engage_trigger = "Hm, unannounced visitors. Preparations must be made...",
	engage_message = "Moroes Engaged!",

	enrage_trigger = "%s becomes enraged!",
	enrage_message = "Enrage!",
	enrage_warning = "Enrage Soon!",

	you = "you",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsMoroes = BigWigs:NewModule(boss)
BigWigsMoroes.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsMoroes.enabletrigger = boss
BigWigsMoroes.toggleoptions = {"engage", -1, "vanish", "blind", -1, "enrage", "bosskill"}
BigWigsMoroes.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsMoroes:OnEnable()
	self.core:Print("Moroes mod by Funkydude, this mod is beta quality, at best! Please don't rely on it for anything!")
	enrageannounced = nil

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "BlindEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "BlindEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "BlindEvent")

	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsMoroes:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["vanish_trigger1"] and self.db.profile.vanish then
		self:TriggerEvent("BigWigs_Message", L["vanish_message"], "Urgent", mil, "Alert")
	elseif msg == L["vanish_trigger2"] and self.db.profile.vanish then
		self:TriggerEvent("BigWigs_Message", L["vanish_message"], "Urgent", nil, "Alert")
	elseif msg == L["engage_trigger"] and self.db.profile.engage then
		self:TriggerEvent("BigWigs_Message", L["engage_message"], "Attention")
	end
end

function BigWigsMoroes:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L["enrage_trigger"] and self.db.profile.enrage then
		self:TriggerEvent("BigWigs_Message", L["enrage_message"], "Important", nil, "Alarm")
	end
end

function BigWigsMoroes:UNIT_HEALTH(msg)
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 30 and health <= 34 and not enrageannounced then
			if self.db.profile.enrage then
				self:TriggerEvent("BigWigs_Message", L["enrage_warning"], "Positive", nil, "Info")
			end
			enrageannounced = true
		elseif health > 40 and enrageannounced then
			enrageannounced = nil
		end
	end
end

function BigWigsMoroes:BlindEvent(msg)
	local bplayer, btype = select(3, msg:find(L["blind_trigger"]))
	if bplayer then
		if bplayer == L["you"] then
			bplayer = UnitName("player")
		end
		if self.db.profile.blind then
			self:TriggerEvent("BigWigs_Message", string.format(L["blind_message"], bplayer), "Attention")
		end
	end
end
