------------------------------
--      Are you local?      --
------------------------------

local BB = AceLibrary("Babble-Boss-2.2")
local suffering = BB["Essence of Suffering"]
local desire = BB["Essence of Desire"]
local anger = BB["Essence of Anger"]
local boss = BB["Reliquary of Souls"]
BB = nil

local drained = {}
local spiteIt = {}

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
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
	deaden_warn = "Deaden in ~5sec.",
	deaden_nextbar = "Next Deaden.",

	drain = "Soul Drain",
	drain_desc = "Warn who has Soul Drain.",
	drain_message = "Soul Drain: %s",

	spite = "Spite",
	spite_desc = "Warn who has Spite.",
	spite_message = "Spite: %s",

	afflict_trigger = "^([^%s]+) ([^%s]+) afflicted by ([^%s]+)%.$",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = {boss, desire, suffering, anger}
mod.toggleoptions = {"enrage", "runeshield", "deaden", "drain", "spite", "bosskill"}
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

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "AfflictEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "AfflictEvent")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "RoSDrain", 0)
	self:TriggerEvent("BigWigs_ThrottleSync", "RoSSpite", 0)
	self:TriggerEvent("BigWigs_ThrottleSync", "RoSShield", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "RoSWin", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "RoSDeaden", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		for k in pairs(drained) do drained[k] = nil end
		for k in pairs(spiteIt) do spiteIt[k] = nil end
		if self.db.profile.enrage then
			self:Message(L["enrage_start"], "Positive")
			self:Bar(L["enrage_nextbar"], 47, "Spell_Shadow_UnholyFrenzy")
			self:DelayedMessage(42, L["enrage_warning"], "Urgent")
		end
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
	if msg == UNITDIESOTHER:format(anger) then
		self:Sync("RoSWin")
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["runeshield_trigger"] then
		self:Sync("RoSShield")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["deaden_trigger"] then
		self:Sync("RoSDeaden")
	end
end

function mod:AfflictEvent(msg)
	local Aplayer, Atype, Aspell = select(3, msg:find(L["afflict_trigger"]))
	if Aplayer and Atype then
		if Aplayer == L2["you"] and Atype == L2["are"] then
			Aplayer = UnitName("player")
		end
		if Aspell == L["drain"] then
			self:Sync("RoSDrain "..Aplayer)
		elseif Aspell == L["spite"] then
			self:Sync("RoSSpite "..Aplayer)
		end
	end
end

function mod:DrainWarn()
	if self.db.profile.drain then
		local msg = nil
		for k in pairs(drained) do
			if not msg then
				msg = k
			else
				msg = msg .. ", " .. k
			end
		end
		self:Message(L["drain_message"]:format(msg), "Important", nil, "Alert")
	end
	for k in pairs(drained) do drained[k] = nil end
end

function mod:SpiteWarn()
	if self.db.profile.spite then
		local msg = nil
		for k in pairs(spiteIt) do
			if not msg then
				msg = k
			else
				msg = msg .. ", " .. k
			end
		end
		self:Message(L["spite_message"]:format(msg), "Important", nil, "Alert")
	end
	for k in pairs(spiteIt) do spiteIt[k] = nil end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "RoSDrain" and rest then
		drained[rest] = true
		self:ScheduleEvent("BWDrainWarn", self.DrainWarn, 1.5, self)
	elseif sync == "RoSSpite" and rest then
		spiteIt[rest] = true
		self:ScheduleEvent("BWSpiteWarn", self.SpiteWarn, 0.5, self) --I very much doubt latency will allow this small a timer in 1 message
	elseif sync == "RoSShield" and self.db.profile.runeshield then
		self:Message(L["runeshield_message"], "Attention")
		self:Bar(L["runeshield_nextbar"], 15, "Spell_Arcane_Blast")
		self:DelayedMessage(12, L["runeshield_warn"], "Urgent")
	elseif sync == "RoSWin" and self.db.profile.bosskill then
		self:Message(death, "Bosskill", nil, "Victory")
		BigWigs:ToggleModuleActive(self, false)
	elseif sync == "RoSDeaden" and self.db.profile.deaden then
		self:Message(L["deaden_message"], "Attention")
		self:Bar(L["deaden_nextbar"], 30, "Spell_Shadow_SoulLeech_1")
		self:DelayedMessage(25, L["deaden_warn"], "Urgent")
	end
end
