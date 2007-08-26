------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Mother Shahraz"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local pName = nil
local attracted = {}
local stop

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Shahraz",

	engage_trigger = "So... business or pleasure?",

	attraction = "Fatal Attraction",
	attraction_desc = "Warn who has Fatal Attraction.",
	attraction_trigger = "^([^%s]+) ([^%s]+) afflicted by Fatal Attraction%.$",
	attraction_message = "Attraction: %s",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "흥... 관광하러 온 거야?",

	attraction = "치명적인 매력",
	attraction_desc = "치명적인 매력에 걸린 사람을 알립니다.",
	attraction_trigger = "^([^|;%s]*)(.*)치명적인 매력에 걸렸습니다%.$",
	attraction_message = "매력: %s",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Alors… vous êtes en vacances ?", -- à vérifier

	attraction = "Liaison fatale",
	attraction_desc = "Préviens quand un joueur subit les effets de la Liaison fatale.",
	attraction_trigger = "^([^%s]+) ([^%s]+) les effets .* Liaison fatale%.$",
	attraction_message = "Liaison : %s",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = {"attraction", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "FatalAtt")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "FatalAtt")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "FatalAtt")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ShaAttra", 0)
	pName = UnitName("player")
	stop = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "ShaAttra" and rest then
		attracted[rest] = true
		self:ScheduleEvent("BWAttractionWarn", self.AttractionWarn, 0.5, self)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		for k in pairs(attracted) do attracted[k] = nil end
		if self.db.profile.enrage then
			self:Message(L2["enrage_start"]:format(boss, 10), "Attention")
			self:DelayedMessage(300, L2["enrage_min"]:format(5), "Positive")
			self:DelayedMessage(420, L2["enrage_min"]:format(3), "Positive")
			self:DelayedMessage(540, L2["enrage_min"]:format(1), "Positive")
			self:DelayedMessage(570, L2["enrage_sec"]:format(30), "Positive")
			self:DelayedMessage(590, L2["enrage_sec"]:format(10), "Urgent")
			self:DelayedMessage(595, L2["enrage_sec"]:format(5), "Urgent")
			self:DelayedMessage(600, L2["enrage_end"]:format(boss), "Attention", nil, "Alarm")
			self:Bar(L2["enrage"], 600, "Spell_Shadow_UnholyFrenzy")
		end
	end
end

function mod:FatalAtt(msg)
	local aplayer, atype = select(3, msg:find(L["attraction_trigger"]))
	if aplayer and atype then
		if aplayer == L2["you"] and atype == L2["are"] then
			aplayer = pName
		end
		self:Sync("ShaAttra "..aplayer)
	end
end

local function nilStop()
	stop = nil
	for k in pairs(attracted) do attracted[k] = nil end
end

function mod:AttractionWarn()
	if stop then return end
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
	stop = true
	self:ScheduleEvent("BWShahrazNilStop", nilStop, 4)
end
