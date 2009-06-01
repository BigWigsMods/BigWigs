----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Algalon the Observer"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 32871
mod.toggleoptions = {"bosskill", "phase", "punch", "berserk", "smash", "blackhole", "bigbang", "stars", "constellation" }

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local p2 = nil
local phase = nil
local punch = GetSpellInfo(64412)
local blackholes = 0

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Algalon",

	phase = "Phases",
	phase_desc = "Warn for phase changes.",
	engage_warning = "Phase 1",
	phase2_warning = "Phase 2 incoming",
	phase_bar = "Phase %d",
	
	engage = "Engage",
	engage_trigger = "Your actions are illogical. All possible results for this encounter have been calculated. The Pantheon will receive the Observer's message regardless of outcome.",
	first_engage_trigger = "See your world through my eyes",
	
	punch = "Phase Punch",
	punch_desc = "Warn when someone has 4 stacks of Phase Punch",
	punch_message = "%dx Phase Punch on %s",

	smash = "Cosmic Smash",
	smash_desc = "Warn when Cosmic Smash is incoming",
	smash_message = "Incoming Cosmic Smash!",

	blackhole = "Black Hole",
	blackhole_desc = "Warn when Black Holes spawn",
	blackhole_message = "Black Hole %dx spawned",

	bigbang = "Big Bang",
	bigbang_desc = "Warn when Big Bang starts to cast",
	bigbang_message = "Big Bang!",
	bigbang_soon = "Big Bang soon!",

	stars = "Collapsing Stars",
	stars_desc = "Warn when Collapsing Stars spawn",

	constellation = "Living Constellations",
	constellation_desc = "Warn when Living Constellations spawn",
} end )

L:RegisterTranslations("koKR", function() return {
	phase = "단계",
	phase_desc = "단계 변경을 알립니다.",
	engage_warning = "1 단계",
	phase2_warning = "곧 2단계",
	phase_bar = "%d 단계",
	
	engage = "전투 시작",
	engage_trigger = "^너희 행동은 비논리적이다.",
	first_engage_trigger = "^내 눈을 통해 너희 세상을 보아라.",

	punch = "위상의 주먹",
	punch_desc = "위상의 주먹 4중첩 이상을 알립니다.",
	punch_message = "위상의 주먹 %dx: %s",

	smash = "우주의 강타",
	smash_desc = "우주의 강타를 알립니다.",
	smash_message = "곧 우주의 강타!",
	
	blackhole = "검은 구멍 폭발",
	blackhole_desc = "검은 구멍 폭발 소환을 알립니다.",
	blackhole_message = "검은 구멍 폭발 %dx 소환",

	bigbang = "대폭발",
	bigbang_desc = "대폭발 시전 시작을 알립니다.",
	bigbang_message = "대폭발!",
	bigbang_soon = "곧 대폭발!",
	
	stars = "붕괴의 별",
	stars_desc = "붕괴의 별 소환을 알립니다.",

	constellation = "살아있는 별자리",
	constellation_desc = "살아있는 별자리 소환을 알립니다.",
	
} end )

L:RegisterTranslations("frFR", function() return {
	engage = "Engagement",
	engage_trigger = "Vos actions sont illogiques. Tous les résultats possibles de cette rencontre ont été calculés. Le panthéon recevra le message de l'Observateur quelque soit l'issue.", -- à vérifier

	punch = "Coup de poing phasique",
	punch_desc = "Prévient quand un joueur a 4 cumuls de Coup de poing phasique.",
	punch_message = "%2$dx Coups de poing phasiques sur %1$s",

	smash = "Choc cosmique",
	smash_desc = "Prévient quand un Choc cosmique est sur le point d'arriver.",
	smash_message = "Arrivée d'un Choc cosmique !",

	blackhole = "Trou noir",
	blackhole_desc = "Prévient quand un Trou noir apparaît.",
	blackhole_message = "Trou noir %dx apparu",

	bigbang = "Big Bang",
	bigbang_desc = "Prévient quand un Big Bang est incanté.",
	bigbang_message = "Big Bang !",
	bigbang_soon = "Big Bang imminent !",

	stars = "Collapsing Stars",
	stars_desc = "Warn when Collapsing Stars spawn",

	constellation = "Living Constellations",
	constellation_desc = "Warn when Living Constellations spawn",

	
} end )

L:RegisterTranslations("deDE", function() return {

	phase = "Phasen",
	phase_desc = "Warnt vor Phasenwechsel.",
	engage_warning = "Phase 1",
	phase2_warning = "Phase 2 bald!",
	phase_bar = "Phase %d",

	engage = "Engage",
	engage_trigger = "^Euer Handeln ist unlogisch. ",-- needs check
	first_engage_trigger = "^Seht Eure Welt durch meine Augen",-- needs check

	punch = "Phasenschlag",
	punch_desc = "Warnt, wenn jemand 4 Stapel von Phasenschlag hat.",
	punch_message = "%dx Phasenschlag: %s!",

	smash = "Kosmischer Schlag",
	smash_desc = "Warnt, wenn Kosmischer Schlag bevorsteht.",
	smash_message = "Kosmischer Schlag kommt!",

	blackhole = "Schwarzes Loch",
	blackhole_desc = "Warnt, wenn ein Schwarzes Loch spawnt.",
	blackhole_message = "Schwarzes Loch %dx!",

	bigbang = "Großer Knall",
	bigbang_desc = "Warnt, wenn Großer Knall kanalisiert wird.",
	bigbang_message = "Großer Knall!",
	bigbang_soon = "Großer Knall bald!",
	
	--[[stars = "Collapsing Stars",
	stars_desc = "Warn when Collapsing Stars spawn",

	constellation = "Living Constellations",
	constellation_desc = "Warn when Living Constellations spawn", ]]--
} end )

L:RegisterTranslations("zhCN", function() return {
	engage = "激活",
--	engage_trigger = "Your actions are illogical. All possible results for this encounter have been calculated. The Pantheon will receive the Observer's message regardless of outcome.",

	punch = "Phase Punch",
	punch_desc = "当玩家中了4层Phase Punch时发出警报。",
	punch_message = "Phase Punch%2$d层：>%1$s<！",

	smash = "Cosmic Smash",
	smash_desc = "当施放Cosmic Smash时发出警报。",
	smash_message = "即将 Cosmic Smash！",

	blackhole = "黑洞爆炸",
	blackhole_desc = "当黑洞爆炸出现时发出警报。",
	blackhole_message = "黑洞爆炸：>%dx< 出现！",

	bigbang = "Big Bang",
	bigbang_desc = "当开始施放 Big Bang 时发出警报。",
	bigbang_message = "Big Bang！",
	bigbang_soon = "即将 Big Bang！",

	stars = "Collapsing Stars",
	stars_desc = "当Collapsing Star出现时发出警报。",

	constellation = "Living Constellations",
	constellation_desc = "当Living Constellation出现时发出警报。",

	
} end )

L:RegisterTranslations("zhTW", function() return {
	engage = "開戰",
--	engage_trigger = "Your actions are illogical. All possible results for this encounter have been calculated. The Pantheon will receive the Observer's message regardless of outcome.",

	punch = "相位拳擊",
	punch_desc = "當玩家中了4層相位拳擊時發出警報。",
	punch_message = "相位拳擊%2$d層： >%1$s<！",

	smash = "宇宙潰擊",
	smash_desc = "當施放宇宙潰擊時發出警報。",
	smash_message = "即將 宇宙潰擊！",

	blackhole = "黑洞爆炸",
	blackhole_desc = "當黑洞爆炸出現時發出警報。",
	blackhole_message = "黑洞爆炸：>%dx< 出現！",

	bigbang = "大爆炸",
	bigbang_desc = "當開始施放大爆炸時發出警報。",
	bigbang_message = "大爆炸！",
	bigbang_soon = "即將 大爆炸！",

	stars = "Collapsing Stars",
	stars_desc = "當Collapsing Star出現時發出警報。",

	constellation = "Living Constellations",
	constellation_desc = "當Living Constellation出現時發出警報。",
	
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Punch", 64412)
	self:AddCombatListener("SPELL_AURA_APPLIED_DOSE", "PunchCount", 64412)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Smash", 62301, 64598)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "BlackHole", 64122, 65108)
	self:AddCombatListener("SPELL_CAST_START","BigBang",64443, 64584)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:UNIT_HEALTH(msg)
	if not db.phase then return end
	if UnitName(msg) == boss then
		local hp = UnitHealth(msg)
		if hp <= 20 and not p2 then
			self:IfMessage(L["phase2_warning"], "Positive")
			p2 = true
		elseif hp > 20 and p2 then
			p2 = nil
		end
	end
end

function mod:Punch()
	if db.punch then
		self:Bar(L["punch"], 15, 64412)
	end
end

function mod:PunchCount(player)
	if db.punch then
		local _, _, icon, stack = UnitDebuff(player, punch)
		if stack >= 4 then
			self:IfMessage(L["punch_message"]:format(stack, player), "Urgent", icon, "Info")
		end
	end
end

function mod:Smash()
	if db.smash then
		self:IfMessage(L["smash_message"], "Attention", 64597, "Info"  )
		self:Bar(L["smash"], 5, 64597)
		self:Bar(L["smash"], 25, 64597)
	end
end

function mod:BlackHole()
	if db.blackhole then
		blackholes = blackholes + 1
		self:IfMessage(L["blackhole_message"]:format(blackholes), "Attention") 
	end
end

function mod:BigBang()
	if db.bigbang then
		self:IfMessage(L["bigbang_message"], "Attention", 64443, "Urgent" )
		self:Bar(L["bigbang"], 8, 64443)
		self:Bar(L["bigbang"], 90, 64443)
		self:ScheduleEvent("bigbangWarning", "BigWigs_Message", 85, L["bigbang_soon"], "Alert")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) then
		blackholes = 0
		phase = 1
		self:Bar(L["phase_bar"]:format(phase), 8, "INV_Gizmo_01")
		if db.bigbang then
			self:Bar(L["bigbang"], 98, 64443)
			self:DelayedMessage(93, L["bigbang_soon"], "Alert")
		end
		if db.stars then
			self:Bar(L["stars"], 24)
		end
		if db.smash then
			self:Bar(L["smash"], 33, 64597)
		end
		if db.berserk then
			self:Enrage(360, true, true)
		end
		if db.constellation then
			self:Bar(L["constellation"], 65)
		end
	elseif msg:find(L["first_engage_trigger"]) then
		blackholes = 0
		phase = 1
		self:Bar(L["phase_bar"]:format(phase), 11, "INV_Gizmo_01")	
		if db.bigbang then
			self:Bar(L["bigbang"], 109, 64443)
			self:DelayedMessage(104, L["bigbang_soon"], "Alert")
		end
		if db.stars then
			self:Bar(L["stars"], 35)
		end
		if db.smash then
			self:Bar(L["smash"], 44, 64597)
		end
		if db.berserk then
			self:Enrage(371, true, true)
		end
		if db.constellation then
			self:Bar(L["constellation"], 70)
		end		
	end
end

