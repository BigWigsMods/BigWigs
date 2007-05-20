------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Gurtogg Bloodboil"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Gurtogg",

	phase = "Phase Timers",
	phase_desc = "Timers for switching between normal and Fel Rage phases.",
	phase_rage_warning = "Fel Rage Phase in ~5 sec",
	phase_normal_warning = "Fel Rage over in ~5 sec",
	phase_normal = "Fel Rage Phase Over",
	phase_normal_trigger = "Fel Rage fades from Gurtogg Bloodboil.",
	phase_normal_bar = "Next Rage Phase",
	phase_rage_bar = "Next Normal Phase",

	rage = "Fel Rage",
	rage_desc = "Warn who gets Fel Rage.",
	rage_trigger = "^([^%s]+) ([^%s]+) afflicted by Fel Rage.$",
	rage_you = "You have Fel Rage!!",
	rage_other = "%s has Fel Rage!",

	whisper = "Whisper",
	whisper_desc = "Whisper the player with Fel Rage (requires promoted or higher).",

	acid = "Fel-Acid Breath",
	acid_desc = "Warn who Fel-Acid Breath is being cast on.",
	acid_trigger = "cast Fel-Acid Breath.$",
	acid_message = "Fel-Acid Casting on: %s",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on who Fel-Acid Breath is being cast on (requires promoted or higher).",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = {"phase", -1, "rage", "whisper", -1, "acid", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "debuff")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "debuff")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "debuff")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "GurRage", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "GurAcid", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "GurNormal", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "GurRage" and rest and self.db.profile.rage then
		if rest == UnitName("player") then
			self:Message(L["rage_you"], "Personal", true, "Long")
			self:Message(L["rage_other"]:format(rest), "Attention", nil, nil, true)
		else
			self:Message(L["rage_other"]:format(rest), "Attention")
		end
		if self.db.profile.whisper then
			self:Whisper(rest, L["rage_you"])
		end
	elseif sync == "GurAcid" and self.db.profile.acid then
		self:Bar(L["acid"], 2, "Spell_Nature_Acid_01")
		self:ScheduleEvent("BWAcidToTScan", self.AcidCheck, 0.2, self)
	elseif sync == "GurNormal" and self.db.profile.phase then
		self:Bar(L["phase_normal_bar"], 60, "Spell_Fire_ElementalDevastation")
		self:DelayedMessage(55, L["phase_rage_warning"], "Important")
		self:Message(L["phase_normal"], "Attention")
	end
end

function mod:debuff(msg)
	local rplayer, rtype = select(3, msg:find(L["rage_trigger"]))
	if rplayer and rtype then
		if rplayer == L2["you"] and rtype == L2["are"] then
			rplayer = UnitName("player")
		end
		self:Sync("GurRage "..rplayer)
		if self.db.profile.phase then
			self:NormalPhase()
		end
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["acid_trigger"]) then
		self:Sync("GurAcid")
	end
end

function mod:AcidCheck()
	local target
	if UnitName("target") == boss then
		target = UnitName("targettarget")
	else
		for i = 1, GetNumRaidMembers() do
			if UnitName("raid"..i.."target") == boss then
				target = UnitName("raid"..i.."targettarget")
				break
			end
		end
	end
	if target then
		self:Message(L["acid_message"]:format(target), "Attention")
		if self.db.profile.icon then
			self:Icon(target)
		end
	end
end

function mod:NormalPhase()
	self:Bar(L["phase_rage_bar"], 28, "Spell_Fire_ElementalDevastation")
	self:DelayedMessage(23, L["phase_normal_warning"], "Important")
end

function mod:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if msg:find(L["phase_normal_trigger"]) then
		self:Sync("GurNormal")
	end
end
