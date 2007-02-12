-- Netherspite for BW, by Arelenda

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Netherspite"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local started

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Netherspite",

	phase_cmd = "phase",
	phase_name = "Phases",
	phase_desc = "Warns when Netherspite changes from one phase to another"
	
	phase1_message = "Withdrawal!",
	phase1_trigger = "cries out in withdrawal",

	phase2_message = "Nether-Fed Rage!",
	phase2_trigger = "nether-fed rage",

	portals = "Portals open",

} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsNetherspite = BigWigs:NewModule(boss)
BigWigsNetherspite.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsNetherspite.enabletrigger = boss
BigWigsNetherspite.toggleoptions = {"phase", "bosskill"}
BigWigsNetherspite.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsNetherspite:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("BigWigs_RecvSync")
	started = nil
end

------------------------------
--      Event Handlers      --
------------------------------


function BigWigsNetherspite:BigWigs_RecvSync( sync, rest, nick )
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["phase1_message"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["phase2_message"], 60, "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["portals"], 10, "Interface\\Icons\\Spell_Arcane_TeleportStormWind")
		end

		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
	end
end

function BigWigsNetherspite:CHAT_MSG_RAID_BOSS_EMOTE(msg, bname)
	if not self.db.profile.phase then return end
	
	if msg:find(L["phase1_trigger"]) then
		self:TriggerEvent("BigWigs_Message", L["phase1_message"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["phase2_message"], 60, "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["portals"], 10, "Interface\\Icons\\Spell_Arcane_TeleportStormWind")
	elseif msg:find(L["phase2_trigger"]) then
		self:TriggerEvent("BigWigs_Message", L["phase2_message"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["phase1_message"], 30, "Important")
	end	
end
