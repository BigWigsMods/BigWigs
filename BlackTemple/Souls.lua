------------------------------
--      Are you local?      --
------------------------------

local BB = AceLibrary("Babble-Boss-2.2")
local suffering = BB["Essence of Suffering"]
local desire = BB["Essence of Desire"]
local anger = BB["Essence of Anger"]
local boss = BB["Reliquary of Souls"]
BB = nil

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local death = AceLibrary("AceLocale-2.2"):new("BigWigs")["%s has been defeated"]:format(boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "ReliquaryOfSouls",

	engage_trigger = "Pain and suffering are all that await you!",

	enrage_start = "Enrage in ~47sec",
	enrage_trigger = "%s becomes enraged!",
	enrage_message = "Enraged for 15sec!",
	enrage_bar = "<Enraged>",
	enrage_next = "Enrage Over - Next in ~32sec",
	enrage_nextbar = "Next Enrage",
	enrage_warning = "Enrage in 5 sec!",

	-- Considering this part of enrage, since it is a soft enrage
	desire_trigger  = "You can have anything you desire... for a price.", 
	desire_start = "Essence of Desire - Zero mana in 160 sec", 
	desire_bar = "Zero Mana", 
	desire_warn = "Zero Mana in 30sec!",

	runeshield = "Rune Shield", 
	runeshield_desc = "Timers for when Essence of Desire will gain rune shield.",
	runeshield_trigger = "Essence of Desire gains Rune Shield.",
	runeshield_message = "Rune Shield!",
	runeshield_nextbar = "Next Rune Shield",
	runeshield_warn = "Rune Shield in ~3sec.",

	deaden = "Deaden",
	deaden_desc = "Warns you when Deaden is being cast.",
	deaden_trigger = "Essence of Desire begins to cast Deaden.",
	deaden_message = "Casting Deaden!",

} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = {boss, desire, suffering, anger}
mod.toggleoptions = {"enrage", "runeshield", "deaden", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] and self.db.profile.enrage then
		self:Message(L["enrage_start"], "Positive")
		self:Bar(L["enrage_nextbar"], 47, "Spell_Shadow_UnholyFrenzy")
		self:DelayedMessage(42, L["enrage_warning"], "Urgent")
	elseif msg == L["desire_trigger"] and self.db.profile.enrage then
		self:Message(L["desire_start"], "Positive")
		self:Bar(L["desire_bar"], 160, "Spell_Shadow_UnholyFrenzy")
		self:DelayedMessage(130, L["desire_warn"], "Urgent")
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["enrage_trigger"] and self.db.profile.enrage then
		self:Message(L["enrage_message"], "Attention", nil, "Alert")
		self:Bar(L["enrage_bar"], 15, "Spell_Shadow_UnholyFrenzy")
		self:DelayedMessage(15, L["enrage_next"], "Attention")
		self:DelayedMessage(42, L["enrage_warning"], "Urgent")
		self:Bar(L["enrage_nextbar"], 47, "Spell_Shadow_UnholyFrenzy")
	end
end

function mod:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if self.db.profile.bosskill and msg == UNITDIESOTHER:format(anger) then
		self:Message(death, "Bosskill", nil, "Victory")
		BigWigs:ToggleModuleActive(self, false)
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["runeshield_trigger"] and self.db.profile.runeshield then
		self:Message(L["runeshield_message"], "Attention")
		self:Bar(L["runeshield_nextbar"], 15, "Spell_Arcane_Blast")
		self:DelayedMessage(12, L["runeshield_warn"], "Urgent")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["deaden_trigger"] and self.db.profile.deaden then
		self:Message(L["deaden_message"], "Attention")
	end
end