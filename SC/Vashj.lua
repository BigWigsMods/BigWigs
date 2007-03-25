------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Lady Vashj"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Vashj",

	lightning = "Forked Lightning",
	lighting_desc = ("Warn when %s casts Forked Lightning"):format(boss),

	multishot = "Multi-Shot",
	multishot_desc = "Warn on Incoming Multi-Shot",

	lightning_trigger = "Lady Vashj begins to cast Forked Lightning",
	lightning_message = "Casting Forked Lightning!",

	multishot_trigger = "Lady Vashj begins to cast Multi-Shot",
	multishot_message = "Incoming Multi-Shot!",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Coilfang Reservoir"]
mod.otherMenu = "Serpentshrine Cavern"
mod.enabletrigger = boss
mod.toggleoptions = {"lightning", "multishot", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "VashjLight", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "VashjMulti", 2)
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["lightning_trigger"]) then
		self:Sync("VashjLight")
	elseif msg:find(L["multishot_trigger"]) then
		self:Sync("VashjMulti")
	end
end

function mod:BigWigs_RecvSync( sync, rest, nick )
	if sync == "VashjLight" and self.db.profile.lightning then
		self:Message(L["lightning_message"], "Urgent")
		self:Bar(L["lighning_message"], 2, "Spell_Nature_ChainLightning")
	elseif sync == "VashjMulti" and self.db.profile.multishot then
		self:Message(L["multishot_message"], "Attention")
		self:Bar(L["multishot_message"], 1, "Ability_UpgradeMoonGlaive")
	end
end
