------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Teron Gorefiend"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Teron",

	start_trigger = "Vengeance is mine!",

	shadow = "Shadow of Death",
	shadow_desc = "Tells you who has Shadow of Death.",
	shadow_trigger = "^([^%s]+) ([^%s]+) afflicted by Shadow of Death.$",
	shadow_other = "Shadow of Death: %s!",
	shadow_you = "Shadow of Death on YOU!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on players with Shadow of Death.",
} end )

L:RegisterTranslations("deDE", function() return {
	start_trigger = "Die Rache ist mein!",

	shadow = "Schatten des Todes",
	shadow_desc = "Informiert Euch, wer Schatten des Todes bekommt.",
	shadow_trigger = "^([^%s]+) ([^%s]+) von Schatten des Todes betroffen.$",
	shadow_other = "Schatten des Todes: %s!",
	shadow_you = "Schatten des Todes auf DIR!",

	icon = "Icon",
	icon_desc = "Plaziert ein Schlachtzug Icon auf dem Spieler mit Schatten des Todes.",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = {"shadow", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "death")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "death")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "death")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "TeronShadow", 3)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:death(msg)
	local splayer, stype = select(3, msg:find(L["shadow_trigger"]))
	if splayer and stype then
		if splayer == L2["you"] and stype == L2["are"] then
			splayer = UnitName("player")
		end
		self:Sync("TeronShadow " .. splayer)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "TeronShadow" and rest and self.db.profile.shadow then
		local other = L["shadow_other"]:format(rest)
		if rest == UnitName("player") then
			self:Message(L["shadow_you"], "Personal", true, "Long")
			self:Message(other, "Attention", nil, nil, true)
			self:Bar(other, 55, "Spell_Arcane_PrismaticCloak")
		else
			self:Message(other, "Attention")
			self:Bar(other, 55, "Spell_Arcane_PrismaticCloak")
		end
		if self.db.profile.icon then
			self:Icon(rest)
		end
	end
end