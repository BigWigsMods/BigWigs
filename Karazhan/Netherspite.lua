------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Netherspite"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local started
local voidcount

local p1Duration = 60
local p2Duration = 30
local netherDuration = 5

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Netherspite",

	phase_cmd = "phase",
	phase_name = "Phases",
	phase_desc = ("Warns when %s changes from one phase to another"):format(boss),

	voidzone_cmd = "voidzone",
	voidzone_name = "Voidzones",
	voidzone_desc = "Warn for Voidzones",

	netherbreath_cmd = "netherbreath",
	netherbreath_name = "Netherbreath",
	netherbreath_desc = "Warn for Netherbreath",

	phase1_message = "Withdrawal - Netherbreaths Over",
	phase1_warning = "Netherspite Engaged - Rage in 60sec!",
	phase1_bar = "Next Withdrawal",
	phase1_trigger = "%s cries out in withdrawal, opening gates to the nether.",
	phase2_message = "Rage - Incoming Netherbreaths!",
	phase2_bar = "Next Rage",
	phase2_trigger = "%s goes into a nether-fed rage!",

	voidzone_trigger = "casts Void Zone.",
	voidzone_warn = "Void Zone (%d)!",

	netherbreath_trigger = "casts Face Random Target.",
	netherbreath_warn = "Incoming Netherbreath!",
} end )

L:RegisterTranslations("deDE", function() return {
	phase_name = "Phase",
	phase_desc = ("Warnt wenn %s von einer Phase zur anderen wechselt"):format(boss),

	voidzone_name = "Zone der Leere",
	voidzone_desc = "Warnt vor Zone der Leere",

	netherbreath_name = "Netheratem",
	netherbreath_desc = "Warnt vor Netheratem",

	phase1_message = "Withdrawal - Netheratem vorbei",
	phase1_warning = "Nethergroll Engaged - Rage in 60 Sek!",
	phase1_bar = "Next Withdrawal",
	phase1_trigger = "%s schreit auf und \195\182ffnet Tore zum Nether.",
	phase2_message = "Rage - Incoming Netheratem!",
	phase2_bar = "N\195\164chste Rage",
	phase2_trigger = "Netherenergien versetzen %s in rasende Wut",

	voidzone_trigger = "wirkt Zone der Leere.",
	voidzone_warn = "Zone der Leere (%d)!",

	netherbreath_trigger = "casts Face Random Target.",
	netherbreath_warn = "Incoming Netheratem!",
} end )

L:RegisterTranslations("koKR", function() return {
	phase_name = "단계",
	phase_desc = ("%s의 다음 단계로 변화 시 경고"):format(boss),

	voidzone_name = "공허의 지대",
	voidzone_desc = "공허의 지대 경고",

	netherbreath_name = "황천의 숨결",
	netherbreath_desc = "황천의 숨결 경고",

	phase1_message = "물러남 - 황천의 숨결 종료!",
	phase1_warning = "황천의 원령 전투 개시 - 60초 후 분노!",
	phase1_bar = "다음 물러남",
	phase1_trigger = "%s|1이;가; 물러나며 고함을 지르더니 황천의 문을 엽니다.",
	phase2_message = "분노 - 황천의 숨결 시전!",
	phase2_bar = "다음 분노",
	phase2_trigger = "%s|1이;가; 황천의 기운을 받고 분노에 휩싸입니다!",

	voidzone_trigger = "공허의 지대|1을;를; 시전합니다.",
	voidzone_warn = "공허의 지대 (%d)!",

	netherbreath_trigger = "무작위 대상 바라보기|1을;를; 시전합니다.",
	netherbreath_warn = "황천의 숨결 시전!",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
mod.enabletrigger = boss
mod.toggleoptions = {"voidzone", "netherbreath", "phase", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "Netherbreath", 3)

	started = nil
	voidcount = 1
end

------------------------------
--    Event Handlers     --
------------------------------


function mod:BigWigs_RecvSync( sync, rest, nick )
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.phase then
			self:Message(L["phase1_warning"], "Important")
			self:Bar(L["phase2_bar"], p1Duration, "Spell_ChargePositive")
		end
	elseif sync == "Netherbreath" and self.db.profile.netherbreath then
		self:Message( L["netherbreath_warn"], "Urgent")
		self:Bar(L["netherbreath_warn"], netherDuration, "Spell_Arcane_MassDispel")
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if not self.db.profile.phase then return end
	if msg == L["phase1_trigger"] then
		self:TriggerEvent("BigWigs_StopBar", self, L["netherbreath_warn"])
		self:Message(L["phase1_message"], "Important")
		self:Bar(L["phase2_bar"], p1Duration, "Spell_ChargePositive")
	elseif msg == L["phase2_trigger"] then
		self:Message(L["phase2_message"], "Important")
		self:Bar(L["phase1_bar"], p2Duration, "Spell_ChargeNegative")
	end	
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if self.db.profile.voidzone and msg:find( L["voidzone_trigger"] ) then
		self:Message( L["voidzone_warn"]:format(voidcount), "Attention")
		voidcount = voidcount + 1
	elseif msg:find(L["netherbreath_trigger"]) then
		self:Sync("Netherbreath")
	end
end
