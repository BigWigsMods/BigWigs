------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Hex Lord Malacrass"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local pName = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Malacrass",

	engage_trigger = "Da shadow gonna fall on you....",

	bolts = "Spirit Bolts",
	bolts_desc = "Warn when Malacrass starts channelling Spirit Bolts.",
	bolts_trigger = "Your soul gonna bleed!",
	bolts_message = "Incoming Spirit Bolts!",

	soul = "Siphon Soul",
	soul_desc = "Warn who is afflicted by Siphon Soul.",
	soul_trigger = "^(%S+) (%S+) afflicted by Siphon Soul%.$",
	soul_message = "Siphon: %s",

	totem = "Totem",
	totem_desc = "Warn when a Fire Nova Totem is casted.",
	totem_trigger = "Hex Lord Malacrass casts Fire Nova Totem.",
	totem_message = "Fire Nova Totem!",

	heal = "Heal",
	heal_desc = "Warn when Malacrass casts a heal.",
	heal_flash = "Hex Lord Malacrass begins to cast Flash Heal.",
	heal_light = "Hex Lord Malacrass begins to cast Holy Light.",
	heal_wave = "Hex Lord Malacrass begins to cast Healing Wave.",
	heal_message = "Casting Heal!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Aman"]
mod.enabletrigger = boss
mod.toggleoptions = {"bolts", "soul", "totem", "heal", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Siphon")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Siphon")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Siphon")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	pName = UnitName("player")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MalaHeal", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "MalaTotem", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.bolts and msg == L["bolts_trigger"] then
		self:Message(L["bolts_message"], "Important")
		self:Bar(L["bolts"], 10, "Spell_Shadow_ShadowBolt")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["totem_trigger"] then
		self:Sync("MalaTotem")
	elseif msg == L["heal_flash"] or msg == L["heal_wave"] or msg == L["heal_light"]) then
		self:Sync("MalaHeal")
	end
end

function mod:Siphon(msg)
	if not self.db.profile.soul then return end

	local splayer, stype = select(3, msg:find(L["soul_trigger"]))
	if splayer and stype then
		if splayer == L2["you"] and stype == L2["are"] then
			splayer = pName
		end
		self:Message(L["soul_message"]:format(splayer), "Urgent")
	end
end

function mod:BigWigs_RecvSync(sync)
	if sync == "MalaHeal" and self.db.profile.heal then
		local show = L["heal_message"]
		self:Message(show, "Positive")
		self:Bar(show, 2, "Spell_Nature_MagicImmunity")
	elseif sync == "MalaTotem" and self.db.profile.totem then
		self:Message(L["totem_message"], "Urgent")
	end
end
