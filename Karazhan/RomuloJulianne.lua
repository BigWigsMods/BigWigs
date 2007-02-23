------------------------------
--     Are you local?     --
------------------------------

local boy = AceLibrary("Babble-Boss-2.2")["Romulo"]
local girl = AceLibrary("Babble-Boss-2.2")["Julianne"]
local boss = AceLibrary("Babble-Boss-2.2")["Romulo & Julianne"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "RomuloJulianne",

	phase_cmd = "phase",
	phase_name = "Phases",
	phase_desc = "Warn when entering a new Phase",

	poison_cmd = "poison",
	poison_name = "Poison",
	poison_desc = "Warn of a poisoned player",

	heal_cmd = "heal",
	heal_name = "Heal",
	heal_desc = ("Warn when %s casts Eternal Affection"):format(girl),

	buff_cmd = "buff",
	buff_name = "Self-Buff Alert",
	buff_desc = ("Warn when %s and %s gain a self-buff"):format(boy, girl),

	phase1_trigger = "What devil art thou, that dost torment me thus?",
	phase1_message = "Phase 1 - %s",
	phase2_trigger = "Wilt thou provoke me? Then have at thee, boy!",
	phase2_message = "Phase 2 - %s",
	phase3_trigger = "Come, gentle night; and give me back my Romulo!",
	phase3_message = "Phase 3 - Both",

	poison_trigger = "^([^%s]+) ([^%s]+) afflicted by Poisoned Thrust",
	poison_message = "Poisoned: %s",

	heal_trigger = "begins to cast Eternal Affection",
	heal_message = "%s casting Heal!",

	buff1_trigger = "gains Daring",
	buff1_message = "%s gains Daring!",
	buff2_trigger = "gains Devotion",
	buff2_message = "%s gains Devotion!",

	you = "You",
} end)

L:RegisterTranslations("deDE", function() return {
	phase_name = "Phase",
	phase_desc = "Warnt wenn eine neue Phase beginnt",

	poison_name = "Gift",
	poison_desc = "Warnt vor vergifteten Spielern",

	heal_name = "Heilen",
	heal_desc = ("Warnt wenn %s sich heilt"):format(girl),

	buff_name = "Selbst-Buff Alarm",
	buff_desc = ("Warnt wenn %s und %s sich selbst buffen"):format(boy, girl),

	phase1_trigger = "Welch' Teufel bist du, dass du mich so folterst?",
	phase1_message = "Phase 1 - %s",
	phase2_trigger = "Willst du mich zwingen? Knabe, sieh dich vor!",
	phase2_message = "Phase 2 - %s",
	phase3_trigger = "Komm, milde, liebevolle Nacht! Komm, gibt mir meinen Romulo zur\195\188ck!",
	phase3_message = "Phase 3 - Beide",

	poison_trigger = "^([^%s]+) ([^%s]+) von Vergifteter Sto\195\159 betroffen.",
	poison_message = "Vergiftet: %s",

	heal_trigger = "beginnt Ewige Zuneigung zu wirken.",
	heal_message = "%s casting Heal!",

	buff1_trigger = "bekommt 'Wagemutig'.",
	buff1_message = "%s bekommt Wagemut!",
	buff2_trigger = "bekommt 'Hingabe'.",
	buff2_message = "%s bekommt Hingabe!",

	you = "Ihr",
} end)

L:RegisterTranslations("frFR", function() return {
	phase_name = "Phases",
	phase_desc = "Avertir lors des changements de phase",

	poison_name = "Poison",
	poison_desc = "Avertir quand quelqu'un est empoisonn\195\169",

	heal_name = "Soin",
	heal_desc = ("Avertir quand %s lance Amour \195\169ternel"):format(girl),

	buff_name = "Buff",
	buff_desc = ("Avertir quand %s et %s gagne leurs buffs"):format(boy, girl),

	phase1_trigger = "Quel d\195\169mon es-tu pour me tourmenter ainsi?",
	phase1_message = "Phase 1 - %s",
	phase2_trigger = "Tu veux donc me provoquer ? Eh bien, \195\160 toi, enfant.",
	phase2_message = "Phase 2 - %s",
	phase3_trigger = "Viens, gentille nuit ; rends-moi mon Romulo !",
	phase3_message = "Phase 3 - Both",

	poison_trigger = "^([^%s]+) ([^%s]+) subit les effets DE Coup empoisonn\195\169",
	poison_message = "%s est empoisonn\195\169!!",

	heal_trigger = "commence \195\160 lancer Amour \195\169ternel.",
	heal_message = "Julianne lance un soin!",

	buff1_trigger = "gagne Hardiesse.",
	buff1_message = "Dispel - Romulo gagne Hardiesse!",
	buff2_trigger = "gagne D\195\169votion.",
	buff2_message = "Dispel - Julianne gagne D\195\169votion!",

	you = "Vous",
} end)

----------------------------------
--   Module Declaration    --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
mod.enabletrigger = {boy, girl}
mod.toggleoptions = {"phase", "heal", "buff", "poison"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "PoisonEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "PoisonEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "PoisonEvent")
end

------------------------------
--     Event Handlers    --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if not self.db.profile.phase then return end
	if msg == L["phase1_trigger"] then
		self:Message(L["phase1_message"]:format(girl), "Attention")
	elseif msg == L["phase2_trigger"] then
		self:Message(L["phase2_message"]:format(boy), "Attention")
	elseif msg == L["phase3_trigger"] then
		self:Message(L["phase3_message"], "Attention")
	end
end

function mod:PoisonEvent(msg)
	local pplayer, ptype = select(3, msg:find(L["poison_trigger"]))
	if pplayer then
		if pplayer == L["you"] then
			pplayer = UnitName("player")
		end
		if self.db.profile.poison then
			self:Message(L["poison_message"]:format(pplayer), "Important")
		end
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if self.db.profile.heal and msg:find(L["heal_trigger"]) then
		self:Message(L["heal_message"]:format(girl), "Urgent")
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if not self.db.profile.buff then return end
	if msg:find(L["buff1_trigger"]) then
		self:Message(L["buff1_message"]:format(boy), "Attention")
	elseif msg:find(L["buff2_trigger"]) then
		self:Message(L["buff2_message"]:format(girl), "Attention")
	end
end
