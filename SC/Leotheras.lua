------------------------------
--      Are you local?    --
------------------------------
local boss = AceLibrary("Babble-Boss-2.2")["Leotheras the Blind"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local BZ = AceLibrary("Babble-Zone-2.2")
local imagewarn
local wwhelp
local beDemon = {}

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Leotheras",

	enrage = "Enrage",
	enrage_desc = "Time untill enrage",

	whirlwind = "Whirlwind",
	whirlwind_desc = "Whirlwind Timers",

	phase = "Demon Phase",
	phase_desc = "Estimated demon phase timers",

	image = "Image",
	image_desc = "15% Image Split Alerts",

	whisper = "Insidious Whisper",
	whisper_desc = "Alert what players have Insidious Whisper",

	enrage_trigger = "Finally, my banishment ends!",

	whirlwind_trigger = "Leotheras the Blind gains Whirlwind",
	whirlwind_gain = "Whirlwind for 12 sec",
	whirlwind_fade = "Whirlwind Over",
	whirlwind_bar = "Whirlwind",
	whirlwind_bar2 = "~Whirlwind Cooldown",
	whirlwind_warn = "Whirlwind Cooldown Over - Inc Soon",

	phase_trigger = "I am in control now",
	phase_demon = "Demon Phase for 60sec",
	phase_demonsoon = "Demon Phase in 5sec!",
	phase_normalsoon = "Normal Phase in 5sec",
	phase_normal = "Normal Phase!",
	demon_bar = "Demon Phase",
	demon_nextbar = "Next Demon Phase",

	image_trigger = "I am the master! Do you hear?",
	image_message = "15% - Image Created!",
	image_warning = "Image Soon!",

	whisper_trigger = "^([^%s]+) ([^%s]+) afflicted by Insidious Whisper",
	whisper_message = "Demon: %s",
	whisper_bar = "Demons",
} end )

L:RegisterTranslations("koKR", function() return {
	enrage = "격노",
	enrage_desc = "격노까지 시간",

	whirlwind = "소용돌이",
	whirlwind_desc = "소용돌이 타이머",

	phase = "악마 형상",
	phase_desc = "악마 형상 예측 타이머",

	image = "이미지",
	image_desc = "15% 이미지 분리 경고",

	whisper = "음흉한 속삭임",
	whisper_desc = "음흉한 속삭임에 걸린 플레이어 알림",

	enrage_trigger = "드디어, 내가 풀려났도다!", -- check

	whirlwind_trigger = "눈먼 레오테라스|1이;가; 소용돌이 효과를 얻었습니다.", -- check
	whirlwind_gain = "12초간 소용돌이",
	whirlwind_fade = "소용돌이 종료",
	whirlwind_bar = "소용돌이",
	whirlwind_bar2 = "~소용돌이 대기시간",
	whirlwind_warn = "소용돌이 대기시간 종료 - 잠시 후",

	phase_trigger = "지금부터는 내가 주인이다", -- check
	phase_demon = "60초간 악마 형상",
	phase_demonsoon = "악마 형상 5초 전!",
	phase_normalsoon = "보통 형상 5초 전",
	phase_normal = "보통 형상!",
	demon_bar = "악마 형상",
	demon_nextbar = "다음 악마 형상",

	image_trigger = "누구나 마음속에 악마를 품고 살지...", -- check
	image_message = "15% - 이미지 생성!",
	image_warning = "곧 이미지!",

	whisper_trigger = "^([^|;%s]*)(.*)음흉한 속삭임에 걸렸습니다%.$", -- check
	whisper_message = "악마: %s",
	whisper_bar = "악마",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = {BZ["Coilfang Reservoir"], BZ["Serpentshrine Cavern"]}
mod.otherMenu = "Serpentshrine Cavern"
mod.enabletrigger = boss
mod.toggleoptions = {"enrage", "whirlwind", "phase", "image", "whisper", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	for k in pairs(beDemon) do beDemon[k] = nil end
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")


	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "LeoWhisp", 0)
	self:TriggerEvent("BigWigs_ThrottleSync", "LeoWW", 4)

	self:RegisterEvent("UNIT_HEALTH")
	imagewarn = nil
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["enrage_trigger"] then
		wwhelp = 0
		if self.db.profile.phase then
			self:Engage()
		end
		if self.db.profile.enrage then
			self:Message(L2["enrage_start"]:format(boss, 10), "Attention")
			self:DelayedMessage(300, L2["enrage_min"]:format(5), "Positive")
			self:DelayedMessage(420, L2["enrage_min"]:format(3), "Positive")
			self:DelayedMessage(540, L2["enrage_min"]:format(1), "Positive")
			self:DelayedMessage(570, L2["enrage_sec"]:format(30), "Positive")
			self:DelayedMessage(590, L2["enrage_sec"]:format(10), "Urgent")
			self:DelayedMessage(600, L2["enrage_end"]:format(boss), "Attention", nil, "Alarm")
			self:Bar(L2["enrage"], 600, "Spell_Shadow_UnholyFrenzy")
		end
		if self.db.profile.whirlwind then
			self:WhirlwindBar()
		end
	elseif msg:find(L["phase_trigger"]) then
		wwhelp = 0
		if self.db.profile.phase then
			self:Message(L["phase_demon"], "Attention")
			self:ScheduleEvent("normal1", "BigWigs_Message", 55, L["phase_normalsoon"], "Important")
			self:ScheduleEvent("normal2", "BigWigs_Message", 60, L["phase_normal"], "Important")
			self:Bar(L["demon_bar"], 60, "Spell_Shadow_Metamorphosis")
			self:ScheduleEvent("bwdemon", self.DemonSoon, 60, self)
		end
		if self.db.profile.whirlwind then
			self:CancelScheduledEvent("ww1")
			self:TriggerEvent("BigWigs_StopBar", self, L["whirlwind_bar2"])
			self:DelayedMessage(61, L["whirlwind_warn"], "Attention")
		end
	elseif msg:find(L["image_trigger"]) then
		self:CancelScheduledEvent("bwdemon")
		self:CancelScheduledEvent("normal1")
		self:CancelScheduledEvent("normal2")
		self:CancelScheduledEvent("demon1")
		self:TriggerEvent("BigWigs_StopBar", self, L["demon_bar"])
		self:TriggerEvent("BigWigs_StopBar", self, L["demonnext_bar"])
		if self.db.profile.image then
			self:Message(L["phase_demon"], "Important")
		end
	end
end

function mod:Engage()
	self:DelayedMessage(70, L["phase_demonsoon"], "Urgent")
	self:Bar(L["demon_nextbar"], 75, "Spell_Shadow_Metamorphosis")
end

function mod:DemonSoon()
	self:ScheduleEvent("demon1", "BigWigs_Message", 55, L["phase_demonsoon"], "Urgent")
	self:Bar(L["demon_nextbar"], 60, "Spell_Shadow_Metamorphosis")
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg:find(L["whirlwind_trigger"]) then
		self:Sync("LeoWW")
	end
end

function mod:WhirlwindBar()
	self:Bar(L["whirlwind_bar2"], 16, "Ability_Whirlwind")
	self:ScheduleEvent("ww1", "BigWigs_Message", 16, L["whirlwind_warn"], "Attention")
end

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.image then return end
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 16 and health <= 19 and not imagewarn then
			self:Message(L["image_warning"], "Urgent")
			imagewarn = true
		elseif health > 25 and imagewarn then
			imagewarn = false
		end
	end
end

function mod:Event(msg)
	local wplayer, wtype = select(3, msg:find(L["whisper_trigger"]))
	if wplayer and wtype then
		if wplayer == L2["you"] and wtype == L2["are"] then
			wplayer = UnitName("player")
		end
		self:Sync("LeoWhisp "..wplayer)
	end
end

function mod:DemonWarn()
	if self.db.profile.whisper then
		local msg = nil
		for k in pairs(beDemon) do
			if not msg then
				msg = k
			else
				msg = msg .. ", " .. k
			end
		end
		self:Message(L["whisper_message"]:format(msg), "Attention")
	end
	for k in pairs(beDemon) do beDemon[k] = nil end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "LeoWhisp" and rest then
		beDemon[rest] = true
		self:ScheduleEvent("ScanDemons", self.DemonWarn, 2, self)
		self:Bar(L["whisper_bar"], 30, "Spell_Shadow_ManaFeed")
	elseif sync == "LeoWW" and self.db.profile.whirlwind then
		self:Message(L["whirlwind_gain"], "Important", nil, "Alert")
		self:DelayedMessage(12, L["whirlwind_fade"], "Attention")
		self:Bar(L["whirlwind_bar"], 12, "Ability_Whirlwind")
		if wwhelp == 0 or imagewarn then
			self:ScheduleEvent("bwwhirlwind", self.WhirlwindBar, 12, self)
		end
		wwhelp = 1
	end
end
