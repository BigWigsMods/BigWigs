----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Razorscale"]
local Commander = BB["Expedition Commander"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = {Commander, boss}
mod.guid = 33186
mod.toggleoptions = {"phase", -1, "breath", "flame", "harpoon", "berserk", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local p2 = nil
local pName = UnitName("player")
local started = nil
local count = 1

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Razorscale",

	engage_message = "%s Engaged!",

	phase = "Phases",
	phase_desc = "Warn when Razorscale switches between phases.",
	ground_trigger = "Move quickly! She won't remain grounded for long!",
	ground_message = "Razorscale Chained up!",
	air_trigger = "Give us a moment to prepare to build the turrets.",
	air_message = "Takeoff!",
	phase2_trigger = "%s grounded permanently!",
	phase2_message = "Phases 2!",
	phase2_warning = "Phase 2 Soon!",
	stun_bar = "Stun",

	breath = "Flame Breath",
	breath_desc = "Flame Breath warnings.",
	breath_trigger = "%s takes a deep breath...",
	breath_message = "Flame Breath!",

	flame = "Devouring Flame on You",
	flame_desc = "Warn when you are in a Devouring Flame.",
	flame_message = "Devouring Flame on YOU!",
	
	harpoon = "Hapoon Turret",
	harpoon_desc = "Hapoon Turret announce.",
	harpoon_message = "Hapoon Turret(%d)",
} end )

L:RegisterTranslations("ruRU", function() return {
	engage_message = "%s Engaged!",

	phase = "Фазы",
	phase_desc = "Warn when Razorscale switches between phases.",
	ground_trigger = "Быстрее! Сейчас она снова взлетит!",
	ground_message = "Острокрылая на привязи!",
	air_trigger = "Дайте время подготовить пушки.",
	air_message = "Взлет!",
	phase2_trigger = "Острокрылая обессилела и больше не может летать!",
	phase2_message = "Вторая фаза!",
	phase2_warning = "Скоро вторая фаза!",
	stun_bar = "Stun",

	breath = "Огненное дыхание",
	breath_desc = "Flame Breath warnings.",
	breath_trigger = "%s делает глубокий вдох...",
	breath_message = "Огненное дыхание!",

	flame = "Вы в Лавовой Бомбе!",
	flame_desc = "Warn when you are in a Devouring Flame.",
	flame_message = "ВЫ В ЛАВОВОЙ БОМБЕ!",
	
	--harpoon = "Hapoon Turret",
	--harpoon_desc = "Hapoon Turret announce.",
	--harpoon_message = "Hapoon Turret(%d)",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_message = "%s 전투 시작!",

	phase = "단계",
	phase_desc = "칼날비늘의 단계 변경을 알립니다.",
	ground_trigger = "움직이세요! 오래 붙잡아둘 수는 없을 겁니다!",
	ground_message = "칼날비늘 묶임!",
	--air_trigger = "Give us a moment to prepare to build the turrets.",	--check
	air_message = "이륙!",
	--phase2_trigger = "Razorscale lands permanently!",	--check
	phase2_message = "2 단계!",
	phase2_warning = "곧 2 단계!",
	stun_bar = "기절",

	breath = "화염 숨결",
	breath_desc = "화염 숨결을 알립니다.",
	breath_trigger = "%s|1이;가; 숨을 깊게 들이마십니다...",
	breath_message = "화염 숨결!",

	flame = "자신의 파멸의 불길",
	flame_desc = "자신이 파멸의 불길에 걸렸을 때 알립니다.",
	flame_message = "당신은 파멸의 불길!",
	
	harpoon = "작살 포탑",
	harpoon_desc = "작살 포탑의 준비를 알립니다.",
	harpoon_message = "작살 포탑(%d)",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_message = "%s engagée !",

	phase = "Phases",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",
	ground_trigger = "Faites vite ! Elle va pas rester au sol très longtemps !",
	ground_message = "Tranchécaille enchaînée !",
	air_trigger = "Laissez un instant pour préparer la construction des tourelles.",
	air_message = "Décollage !",
	phase2_trigger = "Tranchécaille bloquée au sol !",
	phase2_message = "Phases 2 !",
	phase2_warning = "Phase 2 imminente !",
	stun_bar = "Étourdie",

	breath = "Souffle de flammes",
	breath_desc = "Prévient de l'arrivée des Souffles de flammes.",
	breath_trigger = "%s inspire profondément…",
	breath_message = "Souffle de flammes !",

	flame = "Flamme dévorante sur vous",
	flame_desc = "Prévient quand vous vous trouvez dans une Flamme dévorante.",
	flame_message = "Flamme dévorante sur VOUS !",
	
	--harpoon = "Hapoon Turret",
	--harpoon_desc = "Hapoon Turret announce.",
	--harpoon_message = "Hapoon Turret(%d)",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_message = "%s angregriffen!",

	phase = "Phasen",
	phase_desc = "Warnen wenn Klingenschuppe die Phase wechselt.",
	ground_trigger = "Beeilt Euch! Sie wird nicht lange am Boden bleiben!",
	ground_message = "Klingenschuppe angekettet!",
	air_trigger = "Gebt uns einen Moment, damit wir uns auf den Bau der Geschütze vorbereiten können.",
	air_message = "Hebt ab!",
	phase2_trigger = "%s dauerhaft an den Boden gebunden!",
	phase2_message = "Phase 2!",
	phase2_warning = "Phase 2 bald!",
	stun_bar = "Stun",

	breath = "Flamen Atem",
	breath_desc = "Flamen Atem Warnung.",
	breath_trigger = "%s holt tief Luft...",
	breath_message = "Flammen Atem!",

	flame = "Verschlingende Flamme",
	flame_desc = "Warnung wenn du von Verschlingende Flamme getroffen wirst.",
	flame_message = "Verschlingende Flamme auf DIR!",
	
	--harpoon = "Hapoon Turret",
	--harpoon_desc = "Hapoon Turret announce.",
	--harpoon_message = "Hapoon Turret(%d)",
} end )

L:RegisterTranslations("zhCN", function() return {
--[[
	engage_message = "%s已激怒！",

	phase = "阶段",
	phase_desc = "当锋鳞转换不同阶段时发出警报。",
	ground_trigger = "Move quickly! She won't remain grounded for long!",
	ground_message = "锋鳞被锁住了！",
	air_trigger = "Give us a moment to prepare to build the turrets.",
	air_message = "起飞！",
	phase2_trigger = "Razorscale lands permanently!",
	phase2_message = "第二阶段！",
	phase2_warning = "即将 第二阶段！",
	stun_bar = "<昏迷>",

	breath = "烈焰喷射",
	breath_desc = "当烈焰喷射时发出警报。",
	breath_trigger = "%s takes a deep breath...",
	breath_message = "烈焰喷射！",

	flame = "自身Devouring Flame",
	flame_desc = "当你中了Devouring Flame时发出警报。",
	flame_message = ">你< Devouring Flame！",
	
	harpoon = "Hapoon Turret",
	harpoon_desc = "Hapoon Turret announce.",
	harpoon_message = "Hapoon Turret(%d)",
]]
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_message = "%s已狂怒！",

	phase = "階段",
	phase_desc = "當銳鱗轉換不同階段發出警報。",
--	ground_trigger = "Move quickly! She won't remain grounded for long!",
	ground_message = "銳鱗被鎖住了！",
--	air_trigger = "Give us a moment to prepare to build the turrets.",
	air_message = "起飛！",
--	phase2_trigger = "Razorscale lands permanently!",
	phase2_message = "第二階段！",
	phase2_warning = "即將 第二階段！",
	stun_bar = "<擊昏>",

	breath = "火息術",
	breath_desc = "當火息術時發出警報。",
--	breath_trigger = "%s takes a deep breath...",
	breath_message = "火息術！",

	flame = "自身吞噬烈焰",
	flame_desc = "當你中了吞噬烈焰時發出警報。",
	flame_message = ">你< 吞噬烈焰！",
	
	--harpoon = "Hapoon Turret",
	--harpoon_desc = "Hapoon Turret announce.",
	--harpoon_message = "Hapoon Turret(%d)",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Flame", 63014, 63816)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	db = self.db.profile
	started = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Flame(player)
	if player == pName and db.flame then
		self:LocalMessage(L["flame_message"], "Personal", 63816, "Alarm")
	end
end

function mod:UNIT_HEALTH(msg)
	if not db.phase then return end
	if UnitName(msg) == boss then
		local hp = UnitHealth(msg)
		if hp > 51 and hp <= 55 and not p2 then
			self:Message(L["phase2_warning"], "Positive")
			p2 = true
		elseif hp > 70 and p2 then
			p2 = nil
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["phase2_trigger"] and db.phase then
		self:IfMessage(L["phase2_message"], "Attention")
	elseif msg == L["breath_trigger"] and db.breath then
		self:IfMessage(L["breath_message"], "Attention")
	elseif msg == L["harpoon_trigger"] and db.harpoon then
		self:IfMessage(L["harpoon_message"]:format(count), "Attention", 56790)
		if count == 4 then count = 0 end
		count = count + 1
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["ground_trigger"] and db.phase then
		self:Message(L["ground_message"], "Attention", nil, "Long")
		self:Bar(L["stun_bar"], 38, 20170) --20170, looks like a stun :p
	elseif msg == L["air_trigger"] then
		p2 = nil
		if not started then
			self:Message(L["engage_message"]:format(boss), "Attention")
			self:Enrage(600, true)
			started = true
			count = 1
		else
			self:TriggerEvent("BigWigs_StopBar", self, L["stun_bar"])
			self:Message(L["air_message"], "Attention", nil, "Info")
		end
	end
end
