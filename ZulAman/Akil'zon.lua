------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Akil'zon"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local pName = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Akil'zon",

	engage_trigger = "I be da predator! You da prey...",
	engage_message = "%s Engaged - Storm in ~55sec!",

	elec = "Electrical Storm",
	elec_desc = "Warn who has Electrical Storm.",
	elec_trigger = "^(%S+) (%S+) afflicted by Electrical Storm%.$",
	elec_bar = "~Storm Cooldown",
	elec_message = "Storm on %s!",

	ping = "Ping",
	ping_desc = "Ping your current location if you are afflicted by Electrical Storm.",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Target Icon on the player with Electrical Storm. (requires promoted or higher)",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Aman"]
mod.enabletrigger = boss
mod.toggleoptions = {"elec", "ping", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Storm")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Storm")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Storm")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "AkilElec", 10)

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Storm(msg)
	if not self.db.profile.elec then return end

	local eplayer, etype = select(3, msg:find(L["elec_trigger"]))
	if eplayer and etype then
		if eplayer == L2["you"] and etype == L2["are"] then
			eplayer = pName
			if self.db.profile.ping then
				Minimap:PingLocation(CURSOR_OFFSET_X, CURSOR_OFFSET_Y)
			end
		end
		self:Sync("AkilElec ", eplayer)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if not self.db.profile.elec then return end

	if msg == L["engage_trigger"] then
		self:Message(L["engage_message"]:format(boss), "Positive")
		self:Bar(L["elec_bar"], 55, "Spell_Lightning_LightningBolt01")
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "AkilElec" and rest and self.db.profile.elec then
		local show = L["elec_message"]:format(rest)
		self:Message(show, "Attention")
		self:Bar(show, 8, "Spell_Nature_EyeOfTheStorm")
		self:Bar(L["elec_bar"], 55, "Spell_Lightning_LightningBolt01")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	end
end
