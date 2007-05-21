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

	armor = "Melt Armor",
	armor_desc = "Warn who gets Melt Armor",
	armor_trigger = "^([^%s]+) ([^%s]+) afflicted by Melt Armor.$",
	armor_other = "Melt Armor: %s",
	armor_you = "Melt Amor on YOU!",
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
mod.toggleoptions = {"rebirth", "armor", "flamepatch", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "debuff")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "debuff")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "debuff")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "AlArRebirth", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "AlArArmor", 5)
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

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "AlArRebirth" and self.db.profile.rebirth then
		self:Message(L["rebirth_message"], "Urgent", nil, "Alarm")
		self:Bar(L["rebirth_message"], 2, "Spell_Fire_Burnout")
	elseif sync == "AlArArmor" and rest and self.db.profile.armor then
		if rest == UnitName("player") then
			self:Message(L["armor_you"], "Personal", true, "Long")
			self:Message(L["armor_other"]:format(rest), "Attention", nil, nil, true)
			self:Bar(L["armor_other"]:format(rest), 60, "Spell_Fire_Immolation")
		else
			self:Message(L["armor_other"]:format(rest), "Attention")
			self:Bar(L["armor_other"]:format(rest), 60, "Spell_Fire_Immolation")
		end
	end
end

function mod:debuff(msg)
	local aplayer, atype = select(3, msg:find(L["armor_trigger"]))
	if aplayer and atype then
		if aplayer == L2["you"] and atype == L2["are"] then
			aplayer = UnitName("player")
		end
		self:Sync("AlArArmor "..aplayer)
	end
end
