------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Magtheridon"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local abycount

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Magtheridon",

	escape = "Escape",
	escape_desc = ("Countdown untill %s breaks free"):format(boss),

	abyssal = "Burning Abyssal",
	abyssal_desc = "Warn when a Burning Abyssal is created",

	heal = "Heal",
	heal_desc = "Warn when a Hellfire Channeler starts to heal",

	nova = "Blast Nova",
	nova_desc = "Estimated Blast Nova timers",

	banish = "Banish",
	banish_desc = ("Warn when you Banish %s"):format(boss),

	exhaust = "Disable Exhaustion Bars",
	exhaust_desc = "Timer bars for Mind Exhaustion on players",

	escape_trigger1 = "%%s's bonds begin to weaken!",
	escape_trigger2 = "I... am... unleashed!",
	escape_warning1 = "%s Engaged - Breaks free in 2min!",
	escape_warning2 = "Breaks free in 1min!",
	escape_warning3 = "Breaks free in 30sec!",
	escape_warning4 = "Breaks free in 10sec!",
	escape_warning5 = "Breaks free in 3sec!",
	escape_bar = "Released...",
	escape_message = "%s Released!",

	abyssal_trigger = "Hellfire Channeler's Burning Abyssal hits",
	abyssal_message = "Burning Abyssal Created (%d)",

	heal_trigger = "begins to cast Dark Mending",
	heal_message = "Healing!",

	nova_ = "Blast Nova!",
	nova_warning = "Blast Nova Soon",

	banish_trigger = "Not again! Not again...",
	banish_message = "Banished for ~10sec",
	banish_bar = "Banished",

	exhaust_trigger = "^([^%s]+) ([^%s]+) afflicted by Mind Exhaustion",
	exhaust_bar = "[%s] Exhausted",

	you = "You",
	["Hellfire Channeler"] = true,
} end)

L:RegisterTranslations("deDE", function() return {
	escape = "Ausbruch",
	escape_desc = ("Countdown bis %s ausbricht"):format(boss),

	abyssal = "Brennender Schlund",
	abyssal_desc = "Warnt, wenn ein Brennender Schlund gespawned wird",

	heal = "Heilung",
	heal_desc = "Warnt, wenn ein Kanalisierer anf\195\164ngt zu heilen",

	nova = "Drucknova",
	nova_desc = "Gesch\195\164tzte Drucknova Timer",

	banish = "Verbannung",
	banish_desc = ("Warnt, wenn ihr %s verbannt"):format(boss),

	exhaust = "Ersch\195\182pfung",
	exhaust_desc = "Timer f\195\188r Gedankenersch\195\182pfung",

	escape_trigger1 = "Die Fesseln von %%s werden schw\195\164cher!",
	escape_trigger2 = "Ich... bin... frei!",
	escape_warning1 = "%s angegriffen - Ausbruch in 2min!",
	escape_warning2 = "Ausbruch in 1min!",
	escape_warning3 = "Ausbruch in 30sec!",
	escape_warning4 = "Ausbruch in 10sec!",
	escape_warning5 = "Ausbruch in 3sec!",
	escape_bar = "Frei...",
	escape_message = "%s frei!",

	abyssal_trigger = "Kanalisierer des H\195\182llenfeuers wirkt Brennender Schlund",
	abyssal_message = "Brennender Schlund gespawned (%d)",

	heal_trigger = "beginnt Dunkle Besserung zu wirken",
	heal_message = "Heilung!",

	nova_ = "Drucknova",
	nova_warning = "Drucknova bald",

	banish_trigger = "Not again! Not again...", -- to translate
	banish_message = "Verbannt f\195\188r ~10sec",
	banish_bar = "Verbannt",

	exhaust_trigger = "^([^%s]+) ([^%s]+) von Gedankenersch\195\182pfung betroffen",
	exhaust_bar = "[%s] ersch\195\182pft",

	you = "Ihr",
	["Hellfire Channeler"] = "Kanalisierer des H\195\182llenfeuers",
} end)

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Magtheridon's Lair"]
mod.otherMenu = "Outland"
mod.enabletrigger = {L["Hellfire Channeler"], boss}
mod.toggleoptions = {"escape", -1, "abyssal", "heal", -1, "nova", "banish", -1, "exhaust", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "ExhaustEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "ExhaustEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "ExhaustEvent")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "Exhaustion", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MagHFHeal", 0.5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MagHFAbyssal", 0.5)
	abycount = 1
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if self.db.profile.escape and msg:find(L["escape_trigger1"]) then
		self:Message(L["escape_warning1"]:format(boss), "Attention")
		self:Bar(L["escape_bar"], 120, "Ability_Rogue_Trip")
		self:DelayedMessage(60, L["escape_warning2"], "Positive")
		self:DelayedMessage(90, L["escape_warning3"], "Attention")
		self:DelayedMessage(110, L["escape_warning4"], "Urgent")
		self:DelayedMessage(117, L["escape_warning5"], "Urgent", nil, "Long")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.escape and msg == L["escape_trigger2"] then
		self:Message(L["escape_message"]:format(boss), "Important", nil, "Alert")
		self:Bar(L["nova_"], 52, "Spell_Fire_SealOfFire")
		self:DelayedMessage(50, L["nova_warning"], "Urgent")
	elseif self.db.profile.banish and msg == L["banish_trigger"] then
		self:Message(L["banish_message"], "Important", nil, "Info")
		self:Bar(L["banish_bar"], 10, "Spell_Shadow_Cripple")
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if self.db.profile.nova and msg:find(L["nova_"]) then
		self:Message(L["nova_"], "Positive")
		self:Bar(L["nova_"], 54, "Spell_Fire_SealOfFire")
		self:DelayedMessage(50, L["nova_warning"], "Urgent")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["abyssal_trigger"]) then
		self:Sync("MagHFAbyssal")
	end
end

--hellfire channelers sometimes heal
function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg:find(L["heal_trigger"]) then
		self:Sync("MagHFHeal")
	end
end

--mind exhastion bars can get spammy, so off by default
function mod:ExhaustEvent(msg)
	local eplayer, etype = select(3, msg:find(L["exhaust_trigger"]))
	if eplayer then
		if eplayer == L["you"] then
			eplayer = UnitName("player")
		end
		self:Sync("Exhaustion "..eplayer)
	end
end

function mod:BigWigs_RecvSync( sync, rest, nick )
	if sync == "Exhaustion" and rest and not self.db.profile.exhaust then
		self:Bar(L["exhaust_bar"]:format(rest), 90, "Spell_Shadow_Teleport")
	elseif sync == "MagHFHeal" and self.db.profile.heal then
		self:Message(L["heal_message"], "Urgent", nil, "Alarm")
		self:Bar(L["heal_message"], 2, "Spell_Shadow_ChillTouch")
	elseif sync == "MagHFAbyssal" and self.db.profile.abyssal then
		self:Message(L["abyssal_message"]:format(abycount), "Attention")
		abycount = abycount + 1
	end
end
