------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High Astromancer Solarian"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local p1
local p2
local wrath
local split

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Solarian",

	phase = "Phase",
	phase_desc = "Warn for phase changes",

	wrath = "Wrath Debuff",
	wrath_desc = "Warn who has Wrath of the Astromancer",

	icon = "Icon",
	icon_desc = "Place a Raid Icon on the player with Wrath of the Astromancer",

	split = "Split",
	split_desc = "Warn for split & add spawn",

	split_trigger = "casts Astromancer Split",

	phase1_message = "Phase 1", --adds in 50sec?

	phase2_warning = "Phase 2 Soon!",
	--phase2_message = "20% - Phase 2",	some kind of yell or emote to detect this surely

	wrath_trigger = "^([^%s]+) ([^%s]+) afflicted by Wrath of the Astromancer",
	wrath_message = "Wrath: %s",

	agent_warning = "Split! - Agents in 6 sec",
	agent_bar = "Agents",

	priest_warning = "Priests/Solarian in 3 sec",
	priest_bar = "Priests/Solarian",

	["Solarium Priest"] = true,
	["Solarium Agent"] = true,
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Tempest Keep"]
mod.otherMenu = "The Eye"
mod.enabletrigger = boss
mod.wipemobs = {L["Solarium Priest"], L["Solarium Agent"]}
mod.toggleoptions = {"phase", "split", -1, "wrath", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "debuff")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "debuff")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "debuff")

	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "SolaWrath", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "SolaSplit", 6)

	p1 = nil
	p2 = nil
	split = 0
	wrath = 0
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
		self:Bar(L["wrath_message"]:format(rest), 8, "Spell_Arcane_Arcane02")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "SolaSplit" and self.db.profile.split then
		-- Agents 5 seconds after the Split
		self:Message(L["agent_warning"], "Important")
		self:Bar(L["agent_bar"], 6, "Ability_Creature_Cursed_01")

		-- Priests 15 seconds after Agents
		self:DelayedMessage(19, L["priest_warning"], "Important")
		self:Bar(L["priest_bar"], 22, "Spell_Holy_HolyBolt")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg:find(L["split_trigger"]) and (GetTime() - split > 1) then
		split = GetTime()
		self:Sync("SolaSplit")
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
	if wplayer and wtype and (GetTime() - wrath > 1) then
		if wplayer == L2["you"] and wtype == L2["are"] then
			wplayer = UnitName("player")
		end
		self:Sync("SolaWrath "..wplayer)
	end
end
