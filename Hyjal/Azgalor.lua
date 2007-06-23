------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Azgalor"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Azgalor",

	doom = "Doom",
	doom_desc = "Warn for Doom.",
	doom_trigger = "^([^%s]+) ([^%s]+) afflicted by Doom.$",
	doom_other = "Doom on %s",
	doom_you = "Doom on YOU!",

	icon = "Icon",
	icon_desc = "Place a Raid Icon on the player afflicted by Doom (requires promoted or higher).",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Hyjal Summit"]
mod.enabletrigger = boss
mod.toggleoptions = {"doom", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "DoomEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "DoomEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "DoomEvent")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "AzDoom", 2)

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:DoomEvent(msg)
	local dplayer, dtype = select(3, msg:find(L["doom_trigger"]))
	if dplayer and dtype then
		if dplayer == L2["you"] and dtype == L2["are"] then
			dplayer = UnitName("player")
		end
		self:Sync("AzDoom "..dplayer)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "AzDoom" and rest and self.db.profile.doom then
		local other = L["doom_other"]:format(rest)
		if rest == UnitName("player") then
			self:Message(L["doom_you"], "Personal", true, "Long")
			self:Message(other, "Attention", nil, nil, true)
			self:Bar(other, 19 "Ability_Creature_Cursed_02")
		else
			self:Message(other, "Attention")
			self:Bar(other, 19, "Ability_Creature_Cursed_02")
		end
		if self.db.profile.icon then
			self:Icon(rest)
		end
	end
end
