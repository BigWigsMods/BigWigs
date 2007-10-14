------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Nalorakk"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Nalorakk",

	engage_trigger = "You be dead soon enough!",
	engage_message = "%s Engaged - Bear Form in 45sec!",

	phase = "Phases",
	phase_desc = "Warn for phase changes.",
	phase_bear = "You call on da beast, you gonna get more dan you bargain for!",
	phase_normal = "Make way for Nalorakk!",
	normal_message = "Normal Phase!",
	bear_message = "Bear Phase!",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Vous s'rez mort bien vite !",
	engage_message = "%s engagé - Forme d'ours dans 45 sec. !",

	phase = "Phase",
	phase_desc = "Préviens quand la rencontre entre dans une nouvelle phase.",
	phase_bear = "Vous d'mandez la bête, j'vais vous donner la bête !",
	phase_normal = "Place, voilà le Nalorakk !",
	normal_message = "Phase normale !",
	bear_message = "Phase ours !",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Aman"]
mod.enabletrigger = boss
mod.toggleoptions = {"phase", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if not self.db.profile.phase then return end
	local normal = L["normal_message"]
	local show = L["bear_message"]

	if msg == L["phase_bear"] then
		self:Message(show, "Attention")
		self:Bar(show, 30, "Ability_Racial_BearForm")
	elseif msg == L["phase_normal"] then
		self:Message(normal, "Positive")
		self:Bar(normal, 45, "INV_Misc_Head_Troll_01")
	elseif msg == L["engage_trigger"] then
		self:Message(L["engage_message"]:format(boss), "Positive")
		self:Bar(normal, 45, "INV_Misc_Head_Troll_01")
	end
end
