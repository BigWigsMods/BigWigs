------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Al'ar"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Alar",

	rebirth = "Rebirth",
	rebirth_desc = "Alert when Al'ar casts rebirth",

	rebirth_trigger = "Al'ar begins to cast Rebirth.",
	rebirth_message = "Rebirth! - Phase 2!",

	flamepatch = "Flame Patch on You",
	flamepatch_desc = "Warn for a Flame Patch on You",

	flamepatch_trigger = "You are afflicted by Flame Patch.",
	flamepatch_message = "Flame Patch on YOU!",

} end )

L:RegisterTranslations("frFR", function() return {
	rebirth = "Renaissance",
	rebirth_desc = "Pr\195\169viens quand Al'ar incante sa renaissance.",

	rebirth_trigger = "Al'ar commence \195\160 lancer Renaissance.",
	rebirth_message = "Renaissance ! - Phase 2 !",

	flamepatch = "Gerbe de flammes sur vous",
	flamepatch_desc = "Pr\195\169viens quand une Gerbe de flammes est sur vous.",

	flamepatch_trigger = "Vous subissez les effets de Gerbe de flammes.",
	flamepatch_message = "Gerbe de flammes sur VOUS !",

} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Tempest Keep"]
mod.otherMenu = "The Eye"
mod.enabletrigger = boss
mod.toggleoptions = {"rebirth", "flamepatch", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "AlArRebirth", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["rebirth_trigger"] then
		self:Sync("AlArRebirth")
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE(msg)
	if self.db.profile.flamepatch and msg == L["flamepatch_trigger"] then
		self:Message(L["flamepatch_message"], "Personal", true, "Alarm")
	end
end

function mod:BigWigs_RecvSync(sync)
	if sync == "AlArRebirth" and self.db.profile.rebirth then
		self:Message(L["rebirth_message"], "Urgent", nil, "Alarm")
		self:Bar(L["rebirth_message"], 2, "Spell_Fire_Burnout")
	end
end
