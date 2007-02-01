------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Attumen the Huntsman"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local horse = AceLibrary("Babble-Boss-2.2")["Midnight"]
local started

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Attumen",

	phase_cmd = "phase",
	phase_name = "Phase Alert",
	phase_desc = "Warn when entering a new Phase",

	phase1_message = "Phase 1 - Midnight",
	phase2_trigger = "%s calls for her master!",
	phase2_message = "Phase 2 - Midnight & Attumen",
	phase3_trigger = "Come Midnight, let's disperse this petty rabble!",
	phase3_message = "Phase 3 - Attumen the Huntsman",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsAttumen = BigWigs:NewModule(boss)
BigWigsAttumen.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsAttumen.enabletrigger = horse
BigWigsAttumen.toggleoptions = {"phase", "bosskill"}
BigWigsAttumen.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsAttumen:OnEnable()
	self.core:Print("Attumen mod by Funkydude, this mod is beta quality, at best! Please don't rely on it for anything!")
	started = nil

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsAttumen:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["phase3_trigger"] and self.db.profile.phase then
		self:TriggerEvent("BigWigs_Message", L["phase3_message"], "Important")
	end
end

function BigWigsAttumen:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L["phase2_trigger"] and self.db.profile.phase then
		self:TriggerEvent("BigWigs_Message", L["phase2_message"], "Urgent")
	end
end

function BigWigsAttumen:BigWigs_RecvSync( sync, rest, nick )
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["phase1_message"], "Attention")
		end
	end
end
