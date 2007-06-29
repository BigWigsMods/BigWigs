------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High Warlord Naj'entus"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Naj'entus",

	start_trigger = "You will die in the name of Lady Vashj!",

	spine = "Impaling Spine",
	spine_desc = "Tells you who gets impaled.",
	spine_trigger = "^([^%s]+) ([^%s]+) afflicted by Impaling Spine.$",
	spine_message = "Impaling Spine on %s!",

	shield = "Tidal Shield",
	shield_desc = "Timers for when Naj'entus will gain tidal shield.",
	shield_trigger = "High Warlord Naj'entus is afflicted by Tidal Shield.",
	shield_nextbar = "Next Tidal Shield",
	shield_warn = "Tidal Shield!",
	shield_soon_warn = "Tidal Shield in ~10sec!",

	icon = "Icon",
	icon_desc = "Put an icon on players with Impaling Spine.",
} end )

L:RegisterTranslations("deDE", function() return {
	start_trigger = "Im Namen Lady Vashjs werdet Ihr sterben!",

	spine = "Aufspießender Stachel",
	spine_desc = "Sagt euch, wer aufgespießt wird.",
	spine_trigger = "^([^%s]+) ([^%s]+) von Aufspießender Stachel betroffen.$",
	spine_message = "Aufspießender Stachel auf %s!",

	shield = "Gezeitenschild",
	shield_desc = "Timer f\195\188r Gezeigenschild von Naj'entus.",
	shield_trigger = "Oberster Kriegsf\195\188rst Naj'entus ist von Gezeitenschild betroffen.",
	shield_nextbar = "N\195\164chstes Gezeitenschild",
	shield_warn = "Gezeitenschild!",
	shield_soon_warn = "Gezeitenschild in ~10sec!",

	icon = "Icon",
	icon_desc = "Plaziert ein Icon auf Spielern mit Aufspießendem Stachel.",
} end )

L:RegisterTranslations("koKR", function() return {
	start_trigger = "여군주 바쉬의 이름으로 사형에 처하노라!",

	spine = "꿰뚫는 돌기",
	spine_desc = "꿰뚫는 돌기에 걸린 사람을 알림니다.",
	spine_trigger = "^([^|;%s]*)(.*)꿰뚫는 돌기에 걸렸습니다.$",
	spine_message = "%s에게 꿰뚫는 돌기!",

	shield = "해일의 보호막",
	shield_desc = "대장군 나젠투스가 해일의 보호막을 얻을 떄를 위한 타이머 입니다.",
	shield_trigger = "대장군 나젠투스|1이;가; 해일의 보호막에 걸렸습니다.",
	shield_nextbar = "다음 해일의 보호막",
	shield_warn = "해일의 보호막!",
	shield_soon_warn = "약 10초 후 해일의 보호막!",

	icon = "전술 표시",
	icon_desc = "꿰뚫는 돌기에 걸린 플레이어에게 전술 표시를 지정합니다.",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = {"enrage", "shield", "spine", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Spine")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Spine")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Spine")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "NajShieldOn", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "NajSpine", 2)
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["start_trigger"] then
		if self.db.profile.shield then
			self:DelayedMessage(50, L["shield_soon_warn"], "Positive")
			self:Bar(L["shield_nextbar"], 60, "Spell_Frost_FrostBolt02")
		end
		if self.db.profile.enrage then
			self:Message(L2["enrage_start"]:format(boss, 8), "Attention")
			self:DelayedMessage(180, L2["enrage_min"]:format(5), "Positive")
			self:DelayedMessage(300, L2["enrage_min"]:format(3), "Positive")
			self:DelayedMessage(420, L2["enrage_min"]:format(1), "Positive")
			self:DelayedMessage(450, L2["enrage_sec"]:format(30), "Positive")
			self:DelayedMessage(470, L2["enrage_sec"]:format(10), "Urgent")
			self:DelayedMessage(475, L2["enrage_sec"]:format(5), "Urgent")
			self:DelayedMessage(480, L2["enrage_end"]:format(boss), "Attention", nil, "Alarm")
			self:Bar(L2["enrage"], 480, "Spell_Shadow_UnholyFrenzy")
		end
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(msg)
	if msg == L["shield_trigger"] then
		self:Sync("NajShieldOn")
	end
end

function mod:Spine(msg)
	local splayer, stype = select(3, msg:find(L["spine_trigger"]))
	if splayer and stype then
		if splayer == L2["you"] and stype == L2["are"] then
			splayer = UnitName("player")
		end
		self:Sync("NajSpine " .. splayer)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "NajSpine" and rest and self.db.profile.spine then
		self:Message(L["spine_message"]:format(rest), "Important", nil, "Alert")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "NajShieldOn" and self.db.profile.shield then
		self:Message(L["shield_warn"], "Important", nil, "Alert")
		self:DelayedMessage(50, L["shield_soon_warn"], "Positive")
		self:Bar(L["shield_nextbar"], 60, "Spell_Frost_FrostBolt02")
		self:Bar(L["shield_warn"], 6, "Spell_Frost_FrostBolt02")
	end
end