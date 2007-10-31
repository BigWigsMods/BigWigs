------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Halazzi"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local hp = 100
local UnitName = UnitName
local UnitHealth = UnitHealth
local first, second

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Halazzi",

	engage_trigger = "Get on ya knees and bow.... to da fang and claw!",

	totem = "Totem",
	totem_desc = "Warn when Halazzi casts a Lightning Totem.",
	totem_trigger = "Halazzi  begins to cast Lightning Totem.",
	totem_message = "Incoming Lightning Totem!",

	phase = "Phases",
	phase_desc = "Warn for phase changes.",
	phase_spirit = "I fight wit' untamed spirit....",
	phase_normal = "Spirit, come back to me!",
	normal_message = "Normal Phase!",
	spirit_message = "%d%% HP! - Spirit Phase!",
	spirit_soon = "Spirit Phase soon!",
	spirit_bar = "~Possible Normal Phase",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "무릎 꿇고 경배하라... 송곳니와 발톱에!", -- Check

	totem = "토템",
	totem_desc = "할라지가 번개 토템을 소환할 때 알림.",
	totem_trigger = "할라지|1이;가; 번개 토템 시전을 시작합니다.",
	totem_message = "토템 소환!",

	phase = "단계",
	phase_desc = "단계 변경 알림.",
	phase_spirit = "야생의 혼이 내 편이다...", -- Check
	phase_normal = "혼이여! 이리 돌아오라!", -- Check
	normal_message = "보통 단계!",
	spirit_message = "%d%% HP! - 영혼 단계!",
	spirit_soon = "곧 영혼 단계!",
	spirit_bar = "~보통 단계",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "À genoux, les idiots… devant la griffe et le croc !",

	totem = "Totem",
	totem_desc = "Préviens quand Halazzi incante un Totem de foudre.",
	totem_trigger = "Halazzi commence à lancer Totem de foudre.",
	totem_message = "Arrivée d'un Totem de foudre !",

	phase = "Phase",
	phase_desc = "Préviens quand la rencontre entre dans une nouvelle phase.",
	phase_spirit = "L'esprit en moi, il est indompté…",
	phase_normal = "Esprit, reviens à moi !",
	normal_message = "Phase normale !",
	spirit_message = "%d%% PV ! - Phase esprit !",
	spirit_soon = "Phase esprit imminente !",
	spirit_bar = "~Phase normale probable",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "Get on ya knees and bow.... to da fang and claw!",

	totem = "图腾",
	totem_desc = "当Halazzi施放一闪电图腾时发出警报.",
	totem_trigger = "Halazzi开始施放闪电图腾。",
	totem_message = "即将 闪电图腾!",

	phase = "阶段",
	phase_desc = "阶段变化警报",
	phase_spirit = "I fight wit' untamed spirit....",
	phase_normal = "Spirit, come back to me!",
	normal_message = "正常阶段!",
	spirit_message = "%d%% 生命值! - 灵魂阶段!",
	spirit_soon = "即将灵魂阶段!",
	spirit_bar = "~可能 正常阶段",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Aman"]
mod.enabletrigger = boss
mod.toggleoptions = {"totem", "phase", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "HalHP", 4.5)
	self:TriggerEvent("BigWigs_ThrottleSync", "HalSoon", 4.5)
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if self.db.profile.totem and msg == L["totem_trigger"] then
		self:Message(L["totem_message"], "Attention")
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if not self.db.profile.phase then return end

	if sync == "HalHP" and rest then
		hp = rest
	elseif sync == "HalSoon" then
		self:Message(L["spirit_soon"], "Positive")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if not self.db.profile.phase then return end

	if msg == L["phase_spirit"] then
		self:Message(L["spirit_message"]:format(hp), "Urgent")
		self:Bar(L["spirit_bar"], 50, "Spell_Nature_Regenerate")
	elseif msg == L["phase_normal"] then
		self:Message(L["normal_message"], "Attention")
	elseif msg == L["engage_trigger"] then
		hp = 100; first = nil; second = nil;
	end
end

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.phase then return end

	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if not first and (health == 75 or health == 50 or health == 25) then
			first = true
			second = nil
			self:Sync(("%s %d"):format("HalHP", health))
		elseif not second and (health == 80 or health == 55 or health == 30) then
			second = true
			first = nil
			self:Sync("HalSoon")
		end
	end
end
