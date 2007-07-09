------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Supremus"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local started = nil

local UnitName = UnitName
local UnitExists = UnitExists

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Supremus",

	phase = "Phases",
	phase_desc = "Warn about the different phases.",
	normal_phase_message = "Tank'n'spank!",
	normal_phase_trigger = "Supremus punches the ground in anger!",
	kite_phase_message = "%s loose!",
	kite_phase_trigger = "The ground begins to crack open!",
	next_phase_bar = "Next phase",
	next_phase_message = "Phase change in 10sec!",

	punch = "Molten Punch",
	punch_desc = "Alert when he does Molten Punch, and display a countdown bar.",
	punch_message = "Molten Punch!",
	punch_bar = "~Possible Punch!",
	punch_trigger = "Supremus casts Molten Punch.",

	target = "Target",
	target_desc = "Warn who he targets during the kite phase, and put a raid icon on them.",
	target_trigger = "Supremus acquires a new target!",
	target_message = "%s being chased!",
	target_message_nounit = "New target!",

	icon = "Raid Target Icon",
	icon_desc = "Place a Raid Target Icon on the player being chased(requires promoted or higher).",
} end )

L:RegisterTranslations("deDE", function() return {
	phase = "Phasen",
	phase_desc = "Warnt vor den verschiedenen Phasen.",

	punch = "Glühender Hieb",
	punch_desc = "Warnt, wenn Supremus Glühender Hieb benutzt und zeigt einen Countdown an.",

	target = "Verfolgtes Ziel",
	target_desc = "Warnt wer wärend der Kitephase verfolgt wird und markiert ihn mit einem Icon.",

	normal_phase_message = "Tank'n'spank!",
	normal_phase_trigger = "Supremus schlägt wütend auf den Boden!",

	kite_phase_message = "%s Kitephase!",
	kite_phase_trigger = "Der Boden beginnt aufzubrechen!",

	next_phase_bar = "Nächste Phase",
	next_phase_message = "Phasenwechsel in 10sec!",

	target_trigger = "Supremus wählt ein neues Ziel!",
	target_message = "%s wird verfolgt!",
	target_message_nounit = "Neues Ziel!",

	punch_message = "Hieb!",
	punch_trigger = "Supremus wirkt Glühender Hieb.",
} end )

L:RegisterTranslations("koKR", function() return {
	phase = "형상",
	phase_desc = "다른 형상에 대한 경고입니다.",

	punch = "화산 폭발",
	punch_desc = "화산 폭발 시 경고와 쿨다운 타이머바를 표시합니다.",

	target = "대상",
	target_desc = "솔개 형상에서 대상을 알리고 전술 표시를 지정합니다.",

	normal_phase_message = "탱킹'n'딜링!",
	normal_phase_trigger =  "궁극의 심연이 분노하여 땅을 내리찍습니다!",

	kite_phase_message = "%s 풀려남!",
	kite_phase_trigger = "땅이 갈라져서 열리기 시작합니다!",

	next_phase_bar = "다음 형상",
	next_phase_message = "10초 이내 형상 변경!",

	target_trigger = "궁극의 심연에게 새로운 대상이 필요합니다!",
	target_message = "%s 추적 중!",
	target_message_nounit = "새로운 대상!",

	punch_message = "폭발!",
	punch_trigger = "궁극의 심연|1이;가; 화산 폭발|1을;를; 시전합니다.",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = { "punch", "target", "icon", "phase", "enrage", "bosskill" }
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	started = nil

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "SupPunch", 5)
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["punch_trigger"] then
		self:Sync("SupPunch")
	end
end

function mod:TargetCheck()
	local target
	if UnitName("target") == boss then
		target = UnitName("targettarget")
	elseif UnitName("focus") == boss then
		target = UnitName("focustarget")
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			if UnitName("raid"..i.."target") == boss then
				target = UnitName("raid"..i.."targettarget")
				break
			end
		end
	end
	if target then
		self:Message(L["target_message"]:format(target), "Attention")
		if self.db.profile.icon then
			self:Icon(target)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["normal_phase_trigger"] and self.db.profile.phase then
		self:Message(L["normal_phase_message"], "Positive")
		self:Bar(L["next_phase_bar"], 60, "INV_Helmet_08")
		self:DelayedMessage(50, L["next_phase_message"], "Attention")
	elseif msg == L["kite_phase_trigger"] and self.db.profile.phase then
		self:Message(L["kite_phase_message"]:format(boss), "Positive")
		self:Bar(L["next_phase_bar"], 60, "Spell_Fire_MoltenBlood")
		self:DelayedMessage(50, L["next_phase_message"], "Attention")
	elseif msg == L["target_trigger"] and self.db.profile.target then
		self:ScheduleEvent("BWToTScan", self.TargetCheck, 0.5, self)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "SupPunch" then
		if not self.db.profile.punch then return end
		self:Message(L["punch_message"], "Attention")
		self:Bar(L["punch_bar"], 10, "Spell_Frost_FreezingBreath")
	elseif self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.phase then
			self:Bar(L["next_phase_bar"], 60, "Spell_Fire_MoltenBlood")
			self:DelayedMessage(50, L["next_phase_message"], "Attention")
		end
		if self.db.profile.enrage then
			self:Message(L2["enrage_start"]:format(boss, 15), "Attention")
			self:DelayedMessage(300, L2["enrage_min"]:format(10), "Positive")
			self:DelayedMessage(600, L2["enrage_min"]:format(5), "Positive")
			self:DelayedMessage(840, L2["enrage_min"]:format(1), "Positive")
			self:DelayedMessage(870, L2["enrage_sec"]:format(30), "Positive")
			self:DelayedMessage(890, L2["enrage_sec"]:format(10), "Urgent")
			self:DelayedMessage(895, L2["enrage_sec"]:format(5), "Urgent")
			self:DelayedMessage(900, L2["enrage_end"]:format(boss), "Attention", nil, "Alarm")
			self:Bar(L2["enrage"], 900, "Spell_Shadow_UnholyFrenzy")
		end
	end
end
