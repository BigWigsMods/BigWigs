------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Netherspite"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local started
local voidcount
local p1Duration = 60
local p2Duration = 30
local voidDuration = 90
local netherDuration = 1.5

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Netherspite",

	phase_cmd = "phase",
	phase_name = "Phases",
	phase_desc = "Warns when Netherspite changes from one phase to another",

	voidzone_cmd = "voidzone",
	voidzone_name = "Voidzones",
	voidzone_desc = "Warn for Voidzones",

	netherbreath_cmd = "netherbreath",
	netherbreath_name = "Netherbreath",
	netherbreath_desc = "Warn for Netherbreath",

	phase1_message = "Withdrawal!",
	phase1_trigger = "%s cries out in withdrawal, opening gates to the nether.",
	phase2_message = "Nether-Fed Rage!",
	phase2_trigger = "%s goes into a nether-fed rage!",

	voidzone_trigger = "casts Void Zone.",
	voidzone_warn = "Void Zone (%d)!",
	voidzone_bar = "Void Zone (%d)",

	netherbreath_trigger = "casts Face Random Target.",
	netherbreath_warn = "Incoming Netherbreath!",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

BigWigsNetherspite = BigWigs:NewModule(boss)
BigWigsNetherspite.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsNetherspite.enabletrigger = boss
BigWigsNetherspite.toggleoptions = {"voidzone", "netherbreath", "phase", "bosskill"}
BigWigsNetherspite.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsNetherspite:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("BigWigs_RecvSync")
	started = nil
	voidcount = 1
end

------------------------------
--    Event Handlers     --
------------------------------


function BigWigsNetherspite:BigWigs_RecvSync( sync, rest, nick )
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		self:CHAT_MSG_RAID_BOSS_EMOTE( L["phase1_trigger"] )
	end
end

function BigWigsNetherspite:CHAT_MSG_RAID_BOSS_EMOTE(msg, bname)
	if not self.db.profile.phase then return end
	if msg:find(L["phase1_trigger"]) then
		self:Message(L["phase1_message"], "Important")
		self:Bar(L["phase2_message"], p1Duration, "Spell_ChargePositive")
	elseif msg:find(L["phase2_trigger"]) then
		self:Message(L["phase2_message"], "Important")
		self:Bar(L["phase1_message"], p2Duration, "Spell_ChargeNegative")
	end	
end

function BigWigsNetherspite:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE( msg )
	if self.db.profile.voidzone and msg:find( L["voidzone_trigger"] ) then
		self:Bar( L["voidzone_bar"]:format( voidcount ), voidDuration, "Spell_Shadow_GatherShadows" )
		self:Message( L["voidzone_warn"]:format(voidcount), "Attention")
		voidcount = voidcount + 1
	elseif self.db.profile.netherbreath and msg:find( L["netherbreath_trigger"] ) then
		self:Message( L["netherbreath_warn"], "Urgent")
		self:Bar( L["netherbreath_warn"], netherDuration, "Spell_Arcane_MassDispel" ) 
	end
end