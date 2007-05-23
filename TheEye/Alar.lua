------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Al'ar"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Alar",

	meteor = "Meteor",
	meteor_desc = "Estimated Meteor Timers.",
	meteor_warning = "Possible Meteor in ~5sec",
	meteor_message = "Rebirth! - Meteor in ~47sec",
	meteor_trigger = "Al'ar begins to cast Rebirth.",
	meteor_bar = "Rebirth",
	meteor_nextbar = "Next Meteor",

	flamepatch = "Flame Patch on You",
	flamepatch_desc = "Warn for a Flame Patch on You.",
	flamepatch_trigger = "You are afflicted by Flame Patch.",
	flamepatch_message = "Flame Patch on YOU!",

	armor = "Melt Armor",
	armor_desc = "Warn who gets Melt Armor.",
	armor_trigger = "^([^%s]+) ([^%s]+) afflicted by Melt Armor.$",
	armor_other = "Melt Armor: %s",
	armor_you = "Melt Amor on YOU!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player with Melt Armor".,

	enrage = "Enrage",
	enrage_desc = "Enrage Timers, may be innacurate, depends on catching the first Rebirth message.",
} end )

L:RegisterTranslations("frFR", function() return {
	meteor_trigger = "Al'ar commence \195\160 lancer Renaissance.",

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
mod.toggleoptions = {"meteor", "flamepatch", -1, "armor", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "debuff")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "debuff")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "debuff")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "AlArRebirth", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "AlArArmor", 5)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self.prior = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["meteor_trigger"] then
		self:Sync("AlArRebirth")
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE(msg)
	if self.db.profile.flamepatch and msg == L["flamepatch_trigger"] then
		self:Message(L["flamepatch_message"], "Personal", true, "Alarm")
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "AlArRebirth" then
		if self.db.profile.meteor then
			self:Message(L["meteor_message"], "Urgent", nil, "Alarm")
			self:DelayedMessage(42, L["meteor_warning"], "Important")
			self:Bar(L["meteor_bar"], 2, "Spell_Fire_Burnout")
			self:Bar(L["meteor_nextbar"], 47, "Spell_Fire_Burnout")
		end
		if self.db.profile.enrage and not self.prior then
			self:DelayedMessage(300, L2["enrage_min"]:format(5), "Positive")
			self:DelayedMessage(420, L2["enrage_min"]:format(3), "Positive")
			self:DelayedMessage(540, L2["enrage_min"]:format(1), "Positive")
			self:DelayedMessage(570, L2["enrage_sec"]:format(30), "Positive")
			self:DelayedMessage(590, L2["enrage_sec"]:format(10), "Urgent")
			self:DelayedMessage(600, L2["enrage_end"]:format(boss), "Attention", nil, "Alarm")
			self:Bar(L2["enrage"], 600, "Spell_Shadow_UnholyFrenzy")
			self.prior = true
		end
	elseif sync == "AlArArmor" and rest and self.db.profile.armor then
		if rest == UnitName("player") then
			self:Message(L["armor_you"], "Personal", true, "Long")
			self:Message(L["armor_other"]:format(rest), "Attention", nil, nil, true)
			self:Bar(L["armor_other"]:format(rest), 60, "Spell_Fire_Immolation")
		else
			self:Message(L["armor_other"]:format(rest), "Attention")
			self:Bar(L["armor_other"]:format(rest), 60, "Spell_Fire_Immolation")
		end
		if self.db.profile.icon then
			self:Icon(rest)
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
