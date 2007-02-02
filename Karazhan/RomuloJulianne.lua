------------------------------
--      Are you local?      --
------------------------------

local Romulo = AceLibrary("Babble-Boss-2.2")["Romulo"]
local Julianne = AceLibrary("Babble-Boss-2.2")["Julianne"]
local boss = AceLibrary("Babble-Boss-2.2")["Romulo & Julianne"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
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
	heal_desc = "Warn when Julianne casts Eternal Affection",

	buff_cmd = "buff",
	buff_name = "Self-Buff Alert",
	buff_desc = "Warn when Julianne and Romulo gain a self-buff",

	phase1_trigger = "What devil art thou, that dost torment me thus?",
	phase1_message = "Entering Phase 1 - Julianne",
	phase2_trigger = "Wilt thou provoke me? Then have at thee, boy!",
	phase2_message = "Entering Phase 2 - Romulo",
	phase3_trigger = "Come, gentle night; and give me back my Romulo!",
	phase3_message = "Entering Phase 3 - Both",

	poison_trigger = "^([^%s]+) ([^%s]+) afflicted by Poisoned Thrust",
	poison_message = "%s Poisoned!!",

	heal_trigger = "begins to cast Eternal Affection",
	heal_message = "Julianne casting Heal!",

	buff1_trigger = "gains Daring",
	buff1_message = "Romulo gains Daring!",
	buff2_trigger = "gains Devotion",
	buff2_message = "Julianne gains Devotion!",

	you = "you",
} end)

L:RegisterTranslations("deDE", function() return {
	phase_cmd = "phase",
	phase_name = "Phase",
	phase_desc = "Warnt wenn eine neue Phase beginnt",

	poison_cmd = "poison",
	poison_name = "Gift",
	poison_desc = "Warnt vor vergifteten Spielern",

	heal_cmd = "heal",
	heal_name = "Heilen",
	heal_desc = "Warnt wenn Julianne sich heilt",

	buff_cmd = "buff",
	buff_name = "Selbst-Buff Alarm",
	buff_desc = "Warnt wenn Julianne und Romulo sich selbst buffen",

	phase1_trigger = "Welch' Teufel bist du, dass du mich so folterst?",
	phase1_message = "Phase 1 - Julianne",
	phase2_trigger = "Willst du mich zwingen? Knabe, sieh dich vor!",
	phase2_message = "Phase 2 - Romulo",
	phase3_trigger = "Komm, milde, liebevolle Nacht! Komm, gibt mir meinen Romulo zur\195\188ck!",
	phase3_message = "Phase 3 - Beide",

	poison_trigger = "^([^%s]+) ([^%s]+) von Vergifteter Sto? betroffen.",
	poison_message = "%s ist vergiftet!",

	heal_trigger = "beginnt Ewige Zuneigung zu wirken.",
	heal_message = "Julianne casting Heal!",

	buff1_trigger = "bekommt 'Wagemutig'.",
	buff1_message = "Romulo bekommt Wagemut! - Magier Zauberraub!",
	buff2_trigger = "bekommt 'Hingabe'.",
	buff2_message = "Julianne bekommt Hingabe! - Magier Zauberraub!",

	you = "Ihr",
} end)


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsRomuloJulianne = BigWigs:NewModule(boss)
BigWigsRomuloJulianne.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsRomuloJulianne.enabletrigger = {Romulo, Julianne}
BigWigsRomuloJulianne.toggleoptions = {"phase", "buff", "poison"}
BigWigsRomuloJulianne.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsRomuloJulianne:OnEnable()
	self.core:Print("Romulo & Julianne mod by Funkydude, this mod is beta quality, at best! Please don't rely on it for anything!")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "PoisonEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "PoisonEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "PoisonEvent")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsRomuloJulianne:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["phase1_trigger"] and self.db.profile.phase then
		self:TriggerEvent("BigWigs_Message", L["phase1_message"], "Attention")
	elseif msg == L["phase2_trigger"] and self.db.profile.phase then
		self:TriggerEvent("BigWigs_Message", L["phase2_message"], "Attention")
	elseif msg == L["phase3_trigger"] and self.db.profile.phase then
		self:TriggerEvent("BigWigs_Message", L["phase3_message"], "Attention")
	end
end

function BigWigsRomuloJulianne:PoisonEvent(msg)
	local pplayer, ptype = select(3, msg:find(L["poison_trigger"]))
	if pplayer then
		if pplayer == L["you"] then
			pplayer = UnitName("player")
		end
		if self.db.profile.poison then
			self:TriggerEvent("BigWigs_Message", string.format(L["poison_message"], pplayer), "Important")
		end
	end
end

function BigWigsRomuloJulianne:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg:find(L["heal_trigger"]) then
		self:TriggerEvent("BigWigs_Message", L["heal_message"], "Urgent")
	end
end

function BigWigsRomuloJulianne:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if (msg:find(L["buff1_trigger"])) then
		self:TriggerEvent("BigWigs_Message", L["buff1_message"], "Attention")
	elseif (msg:find(L["buff2_trigger"])) then
		self:TriggerEvent("BigWigs_Message", L["buff2_message"], "Attention")
	end
end
