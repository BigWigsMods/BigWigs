----------------------------------
--      Module Declaration      --
----------------------------------

local behemoth = BB["Jormungar Behemoth"]
local boss = BB["Thorim"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = {behemoth, boss}
mod.guid = 32865	--Sif(33196)
mod.toggleoptions = {"phase", "hammer", "shock", "detonation", "charge", "strike", -1, "p2berserk", "icon", "proximity", "bosskill"}
mod.proximityCheck = function(unit) return CheckInteractDistance(unit, 3) end

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local started = nil
local chargeCount = 1
local strikeTime = 15
local fmt = string.format
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Thorim",

	phase = "Phases",
	phase_desc = "Warn for phase changes.",
	phase1_message = "Entering Phase 1",
	phase2_trigger1 = "Interlopers! You mortals who dare to interfere with my sport will pay! Wait...you...?",
	phase2_trigger2 = "I remember you. In the mountains. But you! What is this? Where am-!?",
	phase2_message = "Phase 2 - Berserk in 5min!",
	phase3_trigger = "Impertinent whelps! You dare challenge me atop my pedestal! I will crush you myself!",
	phase3_message = "Phase 3 - %s Engaged!",

	p2berserk = "Phase 2 - Berserk",
	p2berserk_desc = "Warn when the boss goes Berserk in Phase 2.",
	p2berserk_warn1 = "Berserk in 3 min",
	p2berserk_warn2 = "Berserk in 90 sec",
	p2berserk_warn3 = "Berserk in 60 sec",
	p2berserk_warn4 = "Berserk in 30 sec",
	p2berserk_warn5 = "Berserk in 10 sec",

	hammer = "Stormhammer",
	hammer_desc = "Warns for Stormhammer.",
	hammer_bar = "Next Stormhammer",

	shock = "Lightning Shock",
	shock_desc = "Warn for Charge Orb and Lightning Shock.",
	shock_message = "Lightning Shock on You! Move!",
	shock_warning = "Charge Orb!",
	shock_bar = "Next Charge Orb",
	
	detonation = "Runic Detonation",
	detonation_desc = "Tells you who has been hit by Runic Detonation.",
	detonation_message = "Runic Detonation: %s",
	detonation_yell = "I'm a Bomb!",
	
	charge = "Lightning Charge",
	charge_desc = "Count and warn for Thorim's Lightning Charge.",
	charge_message = "Charge: (%d)",
	charge_bar = "Charge (%d)",
	
	strike = "Unbalancing Strike",
	strike_desc = "Warn when a player has Unbalancing Strike.",
	strike_message= "Unbalancing Strike: %s",

	end_trigger = "Stay your arms! I yield!",
	end_message = "%s has been defeated!",
	
	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player with Runic Detonation. (requires promoted or higher)",

	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {
	phase = "단계",
	phase_desc = "단계 변화를 알립니다.",
	phase1_message = "1 단계 시작",
	phase2_trigger1 = "침입자라니! 감히 내 취미생활을 방해하는 놈들은 쓴맛을 단단히! 잠깐...너는...?",	--check
	phase2_trigger2 = "니가 기억난다. 산속에서. 하지만! 뭐지? 난 대체!?",	--check
	phase2_message = "2 단계 - 5분 후 광폭화!",
	phase3_trigger = "건방진 젖먹이 같으니! 감히 여기까지 기어올라와 내게 도전해! 내 손으로 쓸어버리겠다!",	--check
	phase3_message = "3 단계 - %s 전투시작!",

	p2berserk = "2 단계 - 광폭화",
	p2berserk_desc = "1 단계의 보스 광폭화를 알립니다.",
	p2berserk_warn1 = "3분 후 광폭화",
	p2berserk_warn2 = "90초 후 광폭화",
	p2berserk_warn3 = "60초 후 광폭화",
	p2berserk_warn4 = "30초 후 광폭화",
	p2berserk_warn5 = "10초 후 광폭화",

	hammer = "폭풍망치",
	hammer_desc = "폭풍망치를 알립니다.",
	hammer_bar = "다음 폭풍망치",
	
	shock = "번개 충격",
	shock_desc = "번개구 충전과 번개 충격을 알립니다.",
	shock_message = "당신은 번개 충격! 이동!",
	shock_warning = "번개구 충전!",
	shock_bar = "다음 번개구 충전",

	detonation = "룬 폭발",
	detonation_desc = "룬 폭발에 걸린 플레이어를 알립니다.",
	detonation_message = "룬 폭발: %s",
	detonation_yell = "저 푹탄이에요! 피하세요!",
	
	charge = "번개 충전",
	charge_desc = "토림의 번개 충전과 횟수를 알립니다.",
	charge_message = "충전: (%d)",
	charge_bar = "충전 (%d)",
	
	strike = "혼란의 일격",
	strike_desc = "혼란의 일격에 걸린 플레이어를 알립니다.",
	strike_message= "혼란의 일격: %s",

	end_trigger = "무기를 거둬라! 내가 졌다!",
	end_message = "%s 물리침!",
	
	icon = "전술 표시",
	icon_desc = "룬 폭발에 걸린 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 /전투기록 , /대화기록 을 입력하여 기록된 데이터나 transcriptor로 저장된 데이터 보내주시기 바랍니다.",
} end )

L:RegisterTranslations("frFR", function() return {
	phase = "Phases",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",
	phase1_message = "Début de la phase 1",
	phase2_trigger1 = "Des intrus ! Mortels, vous qui osez me déranger en plein divertissement, allez payer ! Attendez... vous ?", -- à vérifier
	phase2_trigger2 = "Je me souviens de vous. Les montagnes. Mais vous ! Qu'est-ce qui se passe ? Où suis-je !?", -- à vérifier
	phase2_message = "Phase 2 - Berserk dans 5 min. !",
	phase3_trigger = "Avortons impertinents. Vous osez me défier sur mon piédestal ! Je vais vous écraser moi-même !", -- à vérifier
	phase3_message = "Phase 3 - %s engagé !",

	p2berserk = "Phase 2 - Berserk",
	p2berserk_desc = "Prévient quand le boss devient fou furieux en phase 2.",
	p2berserk_warn1 = "Berserk dans 3 min.",
	p2berserk_warn2 = "Berserk dans 90 sec.",
	p2berserk_warn3 = "Berserk dans 60 sec.",
	p2berserk_warn4 = "Berserk dans 30 sec.",
	p2berserk_warn5 = "Berserk dans 10 sec.",

	hammer = "Marteau-tempête",
	hammer_desc = "Warns about Detonate Stormhammer soon.",
	hammer_bar = "Prochain Marteau-tempête",
	
	--shock = "Lightning Shock",
	--shock_desc = "Warn for Charge Orb and Lightning Shock.",
	--shock_message = "Lightning Shock on You! Move!",
	--shock_warning = "Charge Orb!",
	--shock_bar = "Next Charge Orb",

	--detonation = "Runic Detonation",
	--detonation_desc = "Tells you who has been hit by Runic Detonation.",
	--detonation_message = "Runic Detonation: %s",
	--detonation_yell = "I'm a Bomb!",
	
	charge = "Charge de foudre",
	charge_desc = "Compte et prévient de l'arrivée des Charges de foudre de Thorim.",
	charge_message = "Charge : (%d)",
	charge_bar = "Charge (%d)",
	
	strike = "Frappe déséquilibrante",
	strike_desc = "Prévient quand un joueur subit les effets de la Frappe déséquilibrante.",
	strike_message= "Frappe déséquilibrante : %s",

	end_trigger = "Retenez vos coups ! Je me rends !", -- à vérifier
	end_message = "%s a été vaincu !",
	
	--icon = "Raid Icon",
	--icon_desc = "Place a Raid Icon on the player with Runic Detonation.  (requires promoted or higher)",

	log = "|cffff0000"..boss.."|r : ce boss a besoin de données, merci d'activer votre /combatlog ou Transcriptor et de nous transmettre les logs.",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Hammer", 62042)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Charge", 62279)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Strike", 62130)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Detonation", 62526)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Orb", 62016)
	self:AddCombatListener("SPELL_DAMAGE", "Shock", 62017)
	self:AddCombatListener("SPELL_MISSED", "Shock", 62017)
		
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
		self:Bar(L["charge_bar"]:format(chargeCount), 15, spellID)
	end
end

function mod:Hammer(_, spellID)
	if db.hammer then
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

function mod:Orb(_, spellID)
	if db.shock then
		self:IfMessage(L["shock_warning"], "Urgent", spellID)
		self:Bar(L["shock_bar"], 14, spellID)
	end
end

local last = 0
function mod:Shock(player, spellID)
	local time = GetTime()
	if (time - last) > 5 then
		last = time
		if player == pName and db.shock then
			self:LocalMessage(L["shock_message"], "Personal", spellID, "Alarm")
		end
	end
end

function mod:Detonation(player, spellID)
	if db.detonation then
		local other = L["detonation_message"]:format(player)
		if player == pName then
			self:Message(other, "Attention", nil, nil, true)
			SendChatMessage(L["detonation_yell"], "YELL")
		else
			self:Message(other, "Attention", nil, nil, nil, spellID)
		end
		self:Bar(other, 4, spellID)
		self:Icon(player, "icon")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["phase2_trigger1"] or msg == L["phase2_trigger2"] then
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
		self:TriggerEvent("BigWigs_ShowProximity", self)
	elseif msg == L["phase3_trigger"] then
		self:TriggerEvent("BigWigs_StopBar", self, L["p2berserk"])
		self:CancelScheduledEvent("warn1")
		self:CancelScheduledEvent("warn2")
		self:CancelScheduledEvent("warn3")
		self:CancelScheduledEvent("warn4")
		self:CancelScheduledEvent("warn5")
		if db.phase then
			self:Message(L["phase3_message"]:format(boss), "Attention")
		end
	elseif msg == L["end_trigger"] then
		if db.bosskill then
			self:Message(L["end_message"]:format(boss), "Bosskill", nil, "Victory")
		end
		BigWigs:ToggleModuleActive(self, false)
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
		self:TriggerEvent("BigWigs_HideProximity", self)
	end
end

