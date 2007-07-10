------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Mother Shahraz"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local attracted = {}

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Shahraz",

	engage_trigger = "So... business or pleasure?",
	engage_message = "%s engaged",

	attraction = "Fatal Attraction",
	attraction_desc = "Warn who has Fatal Attraction.",
	attraction_trigger = "^([^%s]+) ([^%s]+) afflicted by Fatal Attraction%.$",
	attraction_message = "Attraction: %s",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = {"attraction", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "fatal")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "fatal")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "fatal")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ShaAttra", 0)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "ShaAttra" and rest then
		attracted[rest] = true
		self:ScheduleEvent("BWAttractionWarn", self.AttractionWarn, 1.5, self)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		for k in pairs(attracted) do attracted[k] = nil end
		self:Message(L["engage_message"]:format(boss), "Positive")
	end
end

function mod:fatal(msg)
	local aplayer, atype = select(3, msg:find(L["attraction_trigger"]))
	if aplayer and atype then
		if aplayer == L2["you"] and atype == L2["are"] then
			aplayer = UnitName("player")
		end
		self:Sync("ShaAttra "..aplayer)
	end
end

function mod:AttractionWarn()
	if self.db.profile.attraction then
		local msg = nil
		for k in pairs(attracted) do
			if not msg then
				msg = k
			else
				msg = msg .. ", " .. k
			end
		end
		self:Message(L["attraction_message"]:format(msg), "Important", nil, "Alert")
	end
	for k in pairs(attracted) do attracted[k] = nil end
end
