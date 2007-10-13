------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Akil'zon"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Akil'zon",

	engage_trigger = "I be da predator! You da prey...",

	elec = "Electrical Storm",
	elec_desc = "Warn who has Electrical Storm.",
	elec_trigger = "An electrical storm appears!",
	elec_message = "Storm on %s!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Aman"]
mod.enabletrigger = boss
mod.toggleoptions = {"elec", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, b, player) --test
	if self.db.profile.elec and msg == L["elec_trigger"] then
		local show = L["elec_message"]:format(player)
		self:Message(show, "Attention")
		self:Bar(show, 8, "Spell_Nature_EyeOfTheStorm")
	end
end
