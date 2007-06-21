------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Archimonde"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Archimonde",

	engage_trigger = "Your resistance is insignificant.",

	grip = "Grip of the Legion",
	grip_desc = "Warn who has Grip of the Legion.",
	grip_trigger = "^([^%s]+) ([^%s]+) afflicted by Grip of the Legion.$",
	grip_you = "Grip of the Legion on YOU!",
	grip_other = "%s has Grip of the Legion!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player with Grip of the Legion.",

	fear = "Fear",
	fear_desc = "Fear Timers.",
	fear_message = "Fear! - Next in ~30sec",
	fear_bar = "~Fear Cooldown",
	fear_warning = "Fear Soon!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Hyjal Summit"]
mod.enabletrigger = boss
mod.toggleoptions = {"grip", "icon", "fear", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ArchGrip", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "ArchFear", 5)

	self:RegisterEvent("UNIT_SPELLCAST_START")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "GripEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "GripEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "GripEvent")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "ArchGrip" and rest and self.db.profile.grip then 
		local other = L["grip_other"]:format(rest)
		if rest == UnitName("player") then
			self:Message(L["grip_you"], "Personal", true, "Long")
			self:Message(other, "Attention", nil, nil, true)
			self:Bar(other, 10, "Spell_Shadow_SoulLeech_3")
		else
			self:Message(other, "Attention")
			self:Bar(other, 10, "Spell_Shadow_SoulLeech_3")
		end
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "ArchFear" and self.db.profile.fear then
		self:Bar(L["fear_bar"], 30, "Spell_Shadow_DeathScream")
		self:Message(L["fear_message"], "Important")
		self:DelayedMessage(25, L["fear_warning"], "Urgent")
	end
end

function mod:GripEvent(msg)
	local gplayer, gtype = select(3, msg:find(L["grip_trigger"]))
	if gplayer and gtype then
		if gplayer == L2["you"] and gtype == L2["are"] then
			gplayer = UnitName("player")
		end
		self:Sync("ArchGrip "..gplayer)
	end
end

function mod:UNIT_SPELLCAST_START(msg)
	if UnitName(msg) == boss and (UnitCastingInfo(msg)) == L["fear"] then
		self:Sync("ArchFear")
	end
end
