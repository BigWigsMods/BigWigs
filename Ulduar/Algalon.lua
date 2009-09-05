----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Algalon the Observer"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.zoneName = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 32871
mod.toggleOptions = {"phase", 64412, 62301, 64122, 64443, "berserk", "bosskill"}
mod.consoleCmd = "Algalon"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local p2 = nil
local phase = nil
local blackholes = 0

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	phase = "Phases",
	phase_desc = "Warn for phase changes.",
	engage_warning = "Phase 1",
	phase2_warning = "Phase 2 incoming",
	phase_bar = "Phase %d",
	engage_trigger = "Your actions are illogical. All possible results for this encounter have been calculated. The Pantheon will receive the Observer's message regardless of outcome.",

	punch_message = "%dx Phase Punch on %s",
	smash_message = "Incoming Cosmic Smash!",
	blackhole_message = "Black Hole %d!",
	bigbang_soon = "Big Bang soon!",
} end )

L:RegisterTranslations("koKR", function() return {
	phase = "단계",
	phase_desc = "단계 변경을 알립니다.",
	engage_warning = "1 단계",
	phase2_warning = "곧 2단계",
	phase_bar = "%d 단계",
	engage_trigger = "^너희 행동은 비논리적이다.",

	punch_message = "위상의 주먹 %dx: %s",
	smash_message = "곧 우주의 강타!",
	blackhole_message = "검은 구멍 폭발 %dx 소환",
	bigbang_soon = "곧 대폭발!",
} end )

L:RegisterTranslations("frFR", function() return {
	phase = "Phases",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",
	engage_warning = "Phase 1",
	phase2_warning = "Arrivée de la phase 2",
	phase_bar = "Phase %d",
	engage_trigger = "Vos actions sont illogiques. Tous les résultats possibles de cette rencontre ont été calculés. Le panthéon recevra le message de l'Observateur quelque soit l'issue.", -- à vérifier

	punch_message = "%2$dx Coups de poing phasiques sur %1$s",
	smash_message = "Arrivée d'un Choc cosmique !",
	blackhole_message = "Trou noir %dx apparu",
	bigbang_soon = "Big Bang imminent !",
} end )

L:RegisterTranslations("deDE", function() return {
	phase = "Phasen",
	phase_desc = "Warnt vor Phasenwechsel.",
	engage_warning = "Phase 1",
	phase2_warning = "Phase 2 bald!",
	phase_bar = "Phase %d",
	engage_trigger = "Euer Handeln ist unlogisch. Alle Möglichkeiten dieser Begegnung wurden berechnet. Das Pantheon wird die Nachricht des Beobachters erhalten, ungeachtet des Ausgangs.",

	punch_message = "%dx Phasenschlag: %s!",
	smash_message = "Kosmischer Schlag kommt!",
	blackhole_message = "Schwarzes Loch %dx!",
	bigbang_soon = "Großer Knall bald!",
} end )

L:RegisterTranslations("zhCN", function() return {
	phase = "阶段",
	phase_desc = "当进入不同阶段时发出警报。",
	engage_warning = "第一阶段！",
	phase2_warning = "即将 第二阶段！",
	phase_bar = "<阶段%d>",
--	engage_trigger = "Your actions are illogical. All possible results for this encounter have been calculated. The Pantheon will receive the Observer's message regardless of outcome.",

	punch_message = "相位冲压%2$d层：>%1$s<！",
	smash_message = "即将 宇宙重击！",
	blackhole_message = "黑洞爆炸：>%dx< 出现！",
	bigbang_soon = "即将 大爆炸！",
} end )

L:RegisterTranslations("zhTW", function() return {
	phase = "階段",
	phase_desc = "當進入不同階段時發出警報。",
	engage_warning = "第一階段！",
	phase2_warning = "即將 第二階段！",
	phase_bar = "<階段%d>",
	engage_trigger = "你的行為毫無意義。這場沖突的結果早已計算出來了。不論結局為何，萬神殿仍將收到觀察者的訊息。",

	punch_message = "相位拳擊%2$d層： >%1$s<！",
	smash_message = "即將 宇宙潰擊！",
	blackhole_message = "黑洞爆炸：>%dx< 出現！",
	bigbang_soon = "即將 大爆炸！",
} end )

L:RegisterTranslations("ruRU", function() return {
	phase = "Фазы",
	phase_desc = "Сообщать о смене фаз.",
	engage_warning = "1-ая фаза",
	phase2_warning = "Наступление 2-ой фазы",
	phase_bar = "%d-ая фаза",
	engage_trigger = "Ваши действия нелогичны. Все возможные исходы этой схватки просчитаны. Пантеон получит сообщение от Наблюдателя в любом случае.",

	punch_message = "%dx фазовых удара на |3-5(%s)",
	smash_message = "Наступление Кары небесной!",
	blackhole_message = "Появление черной дыры %dx",
	bigbang_soon = "Скоро Суровый удар!",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Punch", 64412)
	self:AddCombatListener("SPELL_AURA_APPLIED_DOSE", "PunchCount", 64412)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Smash", 62301, 64598)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "BlackHole", 64122, 65108)
	self:AddCombatListener("SPELL_CAST_START","BigBang", 64443, 64584)
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

function mod:Punch(_, spellId, _, _, spellName)
	self:Bar(spellName, 15, spellId)
end

function mod:PunchCount(player, spellId, _, _, spellName)
	local _, _, icon, stack = UnitDebuff(player, spellName)
	if stack >= 4 then
		self:IfMessage(L["punch_message"]:format(stack, player), "Urgent", icon)
	end
end

function mod:Smash(_, _, _, _, spellName)
	self:IfMessage(L["smash_message"], "Attention", 64597, "Info")
	self:Bar(L["smash_message"], 5, 64597)
	self:Bar(spellName, 25, 64597)
end

function mod:BlackHole(_, spellId)
	blackholes = blackholes + 1
	self:IfMessage(L["blackhole_message"]:format(blackholes), "Positive", spellId)
end

function mod:BigBang(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", 64443, "Alarm")
	self:Bar(spellName, 8, 64443)
	self:Bar(spellName, 90, 64443)
	self:DelayedMessage(85, L["bigbang_soon"], "Attention")
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) then
		blackholes = 0
		phase = 1
		self:Bar(L["phase_bar"]:format(phase), 8, "INV_Gizmo_01")
		if self:GetOption(64443) then
			local sn = GetSpellInfo(64443)
			self:Bar(sn, 98, 64443)
			self:DelayedMessage(93, L["bigbang_soon"], "Attention")
		end
		if self:GetOption(62301) then
			local sn = GetSpellInfo(62301)
			self:Bar(sn, 33, 64597)
		end
		if db.berserk then
			self:Enrage(360, true, true)
		end
	end
end

