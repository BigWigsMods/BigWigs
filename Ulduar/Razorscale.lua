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
mod.toggleoptions = {"phase", -1, "breath", "flame", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local p2 = nil
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Razorscale",

	["We are ready to help!"] = true,

	engage_message = "%s Engaged!",

	phase = "Phases",
	phase_desc = "Warn when Razorscale switches between phases.",
	ground_trigger = "Move quickly! She won't remain grounded for long!",
	ground_message = "Razorscale Chained up!",
	air_trigger = "Give us a moment to prepare to build the turrets.",
	air_message = "Takeoff!",
	phase2_trigger = "Razorscale lands permanently!",
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
} end )

L:RegisterTranslations("koKR", function() return {
	["We are ready to help!"] = "우리는 도울 준비가 되었습니다!",	--check

	engage_message = "%s 전투 시작!",

	phase = "단계",
	phase_desc = "칼날비늘의 단계 변경을 알립니다.",
	ground_trigger = "움직이세요! 오래 붙잡아둘 수는 없을 겁니다!",
	ground_message = "칼날비늘 묶임!",
	air_trigger = "Give us a moment to prepare to build the turrets.",	--check
	air_message = "이륙!",
	phase2_trigger = "Razorscale lands permanently!",	--check
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
} end )

L:RegisterTranslations("frFR", function() return {
	["We are ready to help!"] = "Nous sommes prêts à aider !",

	engage_message = "%s engagée !",

	phase = "Phases",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",
	ground_trigger = "Faites vite ! Elle va pas rester au sol très longtemps !", -- à vérifier
	ground_message = "Tranchécaille enchaînée !",
	--air_trigger = "Give us a moment to prepare to build the turrets.",
	air_message = "Décollage !",
	--phase2_trigger = "Razorscale lands permanently!",
	phase2_message = "Phases 2 !",
	phase2_warning = "Phase 2 imminente !",
	stun_bar = "Étourdie",

	breath = "Souffle de flammes",
	breath_desc = "Prévient de l'arrivée des Souffles de flammes.",
	breath_trigger = "%s inspire profondément...", -- à vérifier
	breath_message = "Souffle de flammes !",

	flame = "Flamme dévorante sur vous",
	flame_desc = "Prévient quand vous vous trouvez dans une Flamme dévorante.",
	flame_message = "Flamme dévorante sur VOUS !",
} end )

L:RegisterTranslations("deDE", function() return {
	-- ["We are ready to help!"] = true,

	engage_message = "%s angregriffen!",

	phase = "Phasen",
	phase_desc = "Warnen wenn Klingenschuppe die Phase wechselt.",
	--ground_trigger = "Move quickly! She won't remain grounded for long!",
	ground_message = "Klingenschuppe angekettet!",
	--air_trigger = "Give us a moment to prepare to build the turrets.",
	air_message = "Hebt ab!",
	--phase2_trigger = "Razorscale lands permanently!",
	phase2_message = "Phase 2!",
	phase2_warning = "Phase 2 bald!",
	stun_bar = "Stun",

	breath = "Flamen Atem",
	breath_desc = "Flamen Atem Warnung.",
	breath_trigger = "%s holt tief Luft", -- check
	breath_message = "Flamen Atem!",

	flame = "Verschlingende Flamme",
	flame_desc = "Warnung wenn du von Verschlingende Flamme getroffen wirst.",
	flame_message = "Verschlingende Flamme auf DIR!",
} end )

L:RegisterTranslations("zhCN", function() return {
--[[
	["We are ready to help!"] = true,

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
]]
} end )

L:RegisterTranslations("zhTW", function() return {
	["We are ready to help!"] = true,

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
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("GOSSIP_SHOW")
	self:RegisterEvent("QUEST_PROGRESS", "GOSSIP_SHOW")

	self:AddCombatListener("SPELL_AURA_APPLIED", "Flame", 63014, 63816)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("BigWigs_RecvSync")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:TriggerEvent("BigWigs_ThrottleSync", "Start", 2)

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:GOSSIP_SHOW()
	local target = UnitName("target")
	local gossip = GetGossipOptions()
	if gossip and target == Commander then
		if gossip == L["We are ready to help!"] then
			self:Sync("Start")
		end
	end
end

function mod:BigWigs_RecvSync( sync, rest )
	if sync == "Start" and rest then
		p2 = nil
		self:Message(L["engage_message"]:format(boss), "Attention")
	end
end

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
			p2 = false
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["phase2_trigger"] and db.phase then
		self:IfMessage(L["phase2_message"], "Attention")
	elseif msg == L["breath_trigger"] and db.breath then
		self:IfMessage(L["breath_message"], "Attention")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["ground_trigger"] and db.phase then
		--20170, looks like a stun :p
		self:Message(L["ground_message"], "Attention", nil, "Long")
		self:Bar(L["stun_bar"], 38, 20170)
	elseif msg == L["air_trigger"] and db.phase then
		self:TriggerEvent("BigWigs_StopBar", self, L["stun_bar"])
		self:Message(L["air_message"], "Attention", nil, "Info")
	end
end
