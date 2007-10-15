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
	spirit_message = "%d HP! - Spirit Phase!",
	spirit_soon = "Spirit Phase soon!",
	spirit_bar = "~Possible Normal Phase",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "송곳니와 발톱의 힘에... 무릎 꿇어라!",

	totem = "토템",
	totem_desc = "할라지가 번개 토템을 소환할 때 알림.",
	totem_trigger = "할라지|1이;가; 번개 토템 시전을 시작합니다.",
	totem_message = "토템 소환!",

	phase = "단계",
	phase_desc = "단계 변경 알림.",
	phase_spirit = "나는 야생의 영혼과 한 편이다...",
	phase_normal = "영혼이여! 돌아오라!",
	normal_message = "보통 단계!",
	spirit_message = "%d HP! - 영혼 단계!",
	spirit_soon = "곧 영혼 단계!",
	spirit_bar = "~보통 단계",
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
