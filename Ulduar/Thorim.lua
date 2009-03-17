----------------------------------
--      Module Declaration      --
----------------------------------

local behemoth = BB["Jormungar Behemoth"]
local boss = BB["Thorim"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = {behemoth, boss}
mod.guid = 32865
mod.toggleoptions = {"phase", "summon", "hammer", "strike", "charge", -1, "p2berserk", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local started = nil
local chargeCount = 1
local strikeTime = 15

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Thorim",
	
	phase = "Phases",
	phase_desc = "Warn for phase changes.",
	phase1_message = "Entering Phase 1",
	phase2_trigger = "^Interlopers!",
	phase2_message = "Phase 2 - Berserk in 5min!",
	phase3_trigger = "^Impertinent wheips. I will crush you myself!",
	phase3_message = "Phase 3 - %s Engaged!",
		
	p2berserk = "Phase 2 - Berserk",
	p2berserk_desc = "Warn when the boss goes Berserk in Phase 2.",
	p2berserk_warn1 = "Berserk in 3 min",
	p2berserk_warn2 = "Berserk in 90 sec",
	p2berserk_warn3 = "Berserk in 60 sec",
	p2berserk_warn4 = "Berserk in 30 sec",
	p2berserk_warn5 = "Berserk in 10 sec",
	
	summon = "Summoned Lightning Orb",
	summon_desc = "Warn when Lightning Orb are summoned.",
	summon_message = "Lightning Orb Summoned!",
	
	hammer = "Stormhammer",
	hammer_desc = "Warns about Detonate Stormhammer soon.",
	hammer_message = "Stormhammer: %s",
	hammer_bar = "Next Stormhammer",
	
	strike = "Unbalancing Strike",
	strike_desc = "Warn when a player has Unbalancing Strike.",
	strike_message= "Unbalancing Strike: %s",
	
	charge = "Lightning Charge",
	charge_desc = "Count and warn for Thorim's Lightning Charge.",
	charge_message = "Charge: (%d)",
	charge_bar = "Charge (%d)",
	
	--end_trigger = "",	--check
	--end_message = "%s has been defeated!",
	
	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {
	phase = "단계",
	phase_desc = "단계 변화를 알립니다.",
	phase1_message = "1 단계 시작",
	--phase2_trigger = "^Interlopers!",
	phase2_message = "2 단계 - 5분 후 광폭화!",
	--phase3_trigger = "",	--check
	phase3_message = "3 단계 - %s 전투시작!",
	
	p2berserk = "2 단계 - 광폭화",
	p2berserk_desc = "1 단계의 보스 광폭화를 알립니다.",
	p2berserk_warn1 = "3분 후 광폭화",
	p2berserk_warn2 = "90초 후 광폭화",
	p2berserk_warn3 = "60초 후 광폭화",
	p2berserk_warn4 = "30초 후 광폭화",
	p2berserk_warn5 = "10초 후 광폭화",
	
	summon = "번개 구체 소환",
	summon_desc = "번개 구체 소환에 대해 알립니다.",
	summon_message = "번개 구체 소환!",
	
	hammer = "폭풍망치",
	hammer_desc = "폭풍망치를 알립니다.",
	hammer_message = "폭풍망치: %s",
	hammer_bar = "다음 폭풍망치",
	
	strike = "Unbalancing Strike",
	strike_desc = "Unbalancing Strike에 걸린 플레이어를 알립니다.",
	strike_message= "Unbalancing Strike: %s",
	
	charge = "번개 충전",
	charge_desc = "토림의 번개 충전과 횟수를 알립니다.",
	charge_message = "충전: (%d)",
	charge_bar = "충전 (%d)",
	
	--end_trigger = "",	--check
	--end_message = "%s 물리침!",
	
	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 /전투기록 , /대화기록 을 입력하여 기록된 데이터나 transcriptor로 저장된 데이터 보내주시기 바랍니다.",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Charge", 62279)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Hammer", 62042)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Strike", 62130)
	self:AddCombatListener("SPELL_SUMMON", "Summon", 62391)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")

	started = nil
	chargeCount = 1
	db = self.db.profile
	
	BigWigs:Print(L["log"])
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Charge(_, spellID)
	if db.charge then
		self:IfMessage(L["charge_message"]:format(chargeCount), "Important", spellID)
		chargeCount = chargeCount + 1
		if chargeCount < 61 then
			self:Bar(L["charge_bar"]:format(chargeCount), 15, spellID)
		else
			chargeCount = 1
			self:Bar(L["charge_bar"]:format(chargeCount), 150, spellID)
		end
	end
end

function mod:Hammer(player, spellID)
	if db.hammer then
		self:IfMessage(L["hammer_message"]:format(player), "Attention", spellID)
		self:Bar(L["hammer_bar"], 16, spellID)
	end
end

function mod:Strike(player, spellID)
	if db.strike then
		local msg = fmt(L["strike_message"], player)
		self:IfMessage(msg "Attention", spellID)
		self:Bar(msg, strikeTime, spellID)
	end
end

function mod:Summon()
	if db.summon then
		--62016, looks like a Lightning Orb :)
		self:IfMessage(L["summon_message"], "Important", 62016)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["phase2_trigger"]) then
		if db.phase then
			self:Message(L["phase2_message"], "Attention")
		end
		if db.p2berserk then
			self:Bar(L["p2berserk"], 300, 12880)
			self:ScheduleEvent("warn1", "BigWigs_Message", 120, L["p2berserk_warn1"], "Attention")
			self:ScheduleEvent("warn2", "BigWigs_Message", 210, L["p2berserk_warn2"], "Attention")
			self:ScheduleEvent("warn3", "BigWigs_Message", 240, L["p2berserk_warn3"], "Urgent")
			self:ScheduleEvent("warn4", "BigWigs_Message", 270, L["p2berserk_warn4"], "Important")
			self:ScheduleEvent("warn5", "BigWigs_Message", 290, L["p2berserk_warn5"], "Important")
		end
	elseif msg:find(L["phase3_trigger"]) then
		self:TriggerEvent("BigWigs_StopBar", self, L["p2berserk"])
		self:CancelScheduledEvent("warn1")
		self:CancelScheduledEvent("warn2")
		self:CancelScheduledEvent("warn3")
		self:CancelScheduledEvent("warn4")
		self:CancelScheduledEvent("warn5")
		if db.phase then
			self:Message(L["phase3_message"]:format(boss), "Attention")
		end
		if db.charge then
			self:Bar(L["charge_bar"]:format(chargeCount), 15, 62279)
		end
	--[[elseif msg == L["end_trigger"] then
		if db.bosskill then
			self:Message(L["end_message"]:format(boss), "Bosskill", nil, "Victory")
		end
		BigWigs:ToggleModuleActive(self, false)]]
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		chargeCount = 1
		strikeTime = GetCurrentDungeonDifficulty() == 1 and 6 or 15
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then 
			self:UnregisterEvent("PLAYER_REGEN_DISABLED") 
		end
		if db.phase then
			self:Message(L["phase1_message"], "Attention")
		end
	end
end

