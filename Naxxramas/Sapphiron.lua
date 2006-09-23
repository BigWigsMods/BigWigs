------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Sapphiron")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

local time

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Sapphiron",

	deepbreath_cmd = "deepbreath",
	deepbreath_name = "Deep Breath alert",
	deepbreath_desc = "Warn when Sapphiron begins to cast Deep Breath.",

	lifedrain_cmd = "lifedrain",
	lifedrain_name = "Life Drain",
	lifedrain_desc = "Warns about the Life Drain curse.",

	berserk_cmd = "berserk",
	berserk_name = "Berserk",
	berserk_desc = "Warn for berserk.",

	berserk_bar = "Berserk",
	berserk_warn_10min = "10min to berserk!",
	berserk_warn_5min = "5min to berserk!",
	berserk_warn_rest = "%s sec to berserk!",

	engage_message = "Sapphiron engaged! Berserk in 15min!",

	lifedrain_message = "Life Drain! Possibly new one ~24sec!",
	lifedrain_warn1 = "Life Drain in 5sec!",
	lifedrain_bar = "Life Drain",

	lifedrain_trigger = "afflicted by Life Drain",
	lifedrain_trigger2 = "Life Drain was resisted by",

	deepbreath_trigger = "%s takes in a deep breath...",
	deepbreath_warning = "Ice Bomb Incoming!",
	deepbreath_bar = "Ice Bomb Lands!",
} end )

L:RegisterTranslations("koKR", function() return {
	deepbreath_name = "딥브레스 경고",
	deepbreath_desc = "사피론 딥 브레스 시전 시 경고.",

	lifedrain_name = "생명력 흡수",
	lifedrain_desc = "생명력 흡수 저주에 대한 경고.",

	lifedrain_message = "생명력 흡수! 새로운 생명력 흡수 ~24초!",
	lifedrain_warn1 = "5초간 생명력 흡수!",
	lifedrain_bar = "생명력 흡수",

	berserk_name = "광폭화",
	berserk_desc = "광폭화에 대한 경고.",

	berserk_bar = "광폭화",
	berserk_warn_10min = "10분 후 광폭화!",
	berserk_warn_5min = "5분 후 광폭화!",
	berserk_warn_rest = "%s초 후 광폭화!",

	engage_message = "사피론 전투 개시! 광폭화 까지 15분!",

	lifedrain_trigger = "피의 착취에 걸렸습니다.",
	lifedrain_trigger2 = "피의 착취|1으로;로; (.+)|1을;를; 공격했지만 저항했습니다.",

	deepbreath_trigger = "%s|1이;가; 숨을 깊게 들이쉽니다.",
	deepbreath_warning = "얼음 폭탄 다가옴!",
	deepbreath_bar = "얼음 폭탄 떨어짐!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsSapphiron = BigWigs:NewModule(boss)
BigWigsSapphiron.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsSapphiron.enabletrigger = boss
BigWigsSapphiron.toggleoptions = { "berserk", "lifedrain", "deepbreath", "bosskill" }
BigWigsSapphiron.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsSapphiron:OnEnable()
	time = nil

    self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "LifeDrain")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "LifeDrain")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "LifeDrain")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "SapphironLifeDrain", 4)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsSapphiron:BigWigs_RecvSync( sync, rest, nick )
	if sync == self:GetEngageSync() and rest and rest == boss then
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.berserk then
			self:TriggerEvent("BigWigs_Message", L["engage_message"], "Yellow")
			self:TriggerEvent("BigWigs_StartBar", self, L["berserk_bar"], 900, "Interface\\Icons\\INV_Shield_01", "Red", "Orange", "Yellow", "Green")
			self:ScheduleEvent("bwsapphberserk1", "BigWigs_Message", 600, L["berserk_warn_10min"], "Yellow")
			self:ScheduleEvent("bwsapphberserk2", "BigWigs_Message", 300, L["berserk_warn_5min"], "Yellow")
			self:ScheduleEvent("bwsapphberserk3", "BigWigs_Message", 60, string.format(L["berserk_warn_rest"], 60), "Red")
			self:ScheduleEvent("bwsapphberserk4", "BigWigs_Message", 30, string.format(L["berserk_warn_rest"], 30), "Red")
			self:ScheduleEvent("bwsapphberserk5", "BigWigs_Message", 10, string.format(L["berserk_warn_rest"], 10), "Red")
			self:ScheduleEvent("bwsapphberserk6", "BigWigs_Message", 5, string.format(L["berserk_warn_rest"], 5), "Red")
		end
	elseif sync == "SapphironLifeDrain" and self.db.profile.lifedrain then
		self:TriggerEvent("BigWigs_Message", L["lifedrain_message"], "Orange")
		self:TriggerEvent("BigWigs_StartBar", self, L["lifedrain_bar"], 24, "Interface\\Icons\\Spell_Shadow_LifeDrain02", "Yellow", "Orange", "Red")
	end
end

function BigWigsSapphiron:LifeDrain(msg)
	if string.find(msg, L["lifedrain_trigger"]) or string.find(msg, L["lifedrain_trigger2"]) then
		if not time or (time + 2) < GetTime() then
			self:TriggerEvent("BigWigs_SendSync", "SapphironLifeDrain")
			time = GetTime()
		end
	end
end

function BigWigsSapphiron:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L["deepbreath_trigger"] then
		if self.db.profile.deepbreath then
			self:TriggerEvent("BigWigs_Message", L["deepbreath_warning"], "Red")
			self:TriggerEvent("BigWigs_StartBar", self, L["deepbreath_bar"], 8, "Interface\\Icons\\Spell_Frost_FrostShock", "Blue")
		end
	end
end

