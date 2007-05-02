------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High Astromancer Solarian"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local p1
local p2

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Solarian",

	phase = "Phase",
	phase_desc = "Warn when Phase 2 is near",

	wrath = "Wrath Debuff",
	wrath_desc = "Warn who has Wrath of the Astromancer",

	icon = "Icon",
	icon_desc = "Place a Raid Icon on the player with Wrath of the Astromancer",
--[[
	port = "Port",
	port_desc "Warn for teleport & add spawn",

	port_trigger = "??",	wtb a trigger..
	port_mesage = "Ported! - Adds Incoming",
]]

	phase1_message = "Phase 1", --adds in 50sec?

	phase2_warning = "Phase 2 Soon!",
	--phase2_message = "20% - Phase 2",	some kind of yell or emote surely

	wrath_trigger = "^([^%s]+) ([^%s]+) afflicted by Wrath of the Astromancer",
	wrath_message = "Wrath: %s",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Tempest Keep"]
mod.otherMenu = "The Eye"
mod.enabletrigger = boss
mod.toggleoptions = {"phase", "wrath", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "debuff")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "debuff")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "debuff")

	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "SolaWrath", 3)

	p1 = nil
	p2 = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not p1 then
		p1 = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.phase then
			self:Message(L["phase1_message"], "Attention")
		end
	elseif sync == "SolaWrath" and rest and self.db.profile.wrath then
		self:Message(L["wrath_message"]:format(rest), "Attention")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	end
end

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.phase then return end
	if UnitName(msg) == boss then
		local hp = UnitHealth(msg)
		if hp > 21 and hp <= 24 and not p2 then
			self:Message(L["phase2_warning"], "Positive")
			p2 = true
		elseif hp > 40 and p2 then
			p2 = false
		end
	end
end

function mod:debuff(msg)
	local wplayer, wtype = select(3, msg:find(L["wrath_trigger"]))
	if wplayer and wtype then
		if wplayer == L2["you"] and wtype == L2["are"] then
			wplayer = UnitName("player")
		end
		self:Sync("SolaWrath "..wplayer)
	end
end
