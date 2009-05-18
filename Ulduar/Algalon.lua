----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Algalon the Observer"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 32871
mod.toggleoptions = {"bosskill", "punch", "smash", "blackhole"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local punch = GetSpellInfo(64412)
local blackholes = 0

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Algalon",

	punch = "Phase Punch",
	punch_desc = "Warn when someone has 4 stacks of Phase Punch",
	punch_message = "%dx Phase Punch on %s",

	smash = "Cosmic Smash",
	smash_desc = "Warn when Cosmic Smash is incoming",
	smash_message = "Incoming Cosmic Smash!",

	blackhole = "Black Hole",
	blackhole_desc = "Warn when Black Holes spawn",
	blackhole_message = "Black Hole %dx spawned",

	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {
	punch = "위상의 주먹",
	punch_desc = "위상의 주먹 4중첩이상을 알립니다.",
	punch_message = "위상의 주먹 %dx: %s",

	smash = "우주의 강타",
	smash_desc = "우주의 강타를 알립니다.",
	smash_message = "곧 우주의 강타!",

	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 /전투기록 , /대화기록 을 입력하여 기록된 데이터나 스샷등을 http://cafe.daum.net/SCU15 통해 알려주세요.",
} end )

L:RegisterTranslations("frFR", function() return {
	punch = "Coup de poing phasique",
	punch_desc = "Prévient quand un joueur a 4 cumuls de Coup de poing phasique.",
	punch_message = "%dx Coups de poing phasiques sur %s",

	smash = "Choc cosmique",
	smash_desc = "Prévient quand un Choc cosmique est sur le point d'arriver.",
	smash_message = "Arrivée d'un Choc cosmique !",

	log = "|cffff0000"..boss.."|r : ce boss a besoin de donnees, merci d'activer votre /combatlog ou Transcriptor et de nous transmettre les logs.",
} end )

L:RegisterTranslations("deDE", function() return {

	log = "|cffff0000"..boss.."|r: Für diesen Boss werden noch Daten benötigt, aktiviere bitte dein /combatlog oder das Addon Transcriptor und lass uns die Logs zukommen.",
} end )

L:RegisterTranslations("zhCN", function() return {
	punch = "Phase Punch",
	punch_desc = "当玩家中了4层Phase Punch时发出警报。",
	punch_message = "%dxPhase Punch：>%s<！",

	smash = "Cosmic Smash",
	smash_desc = "当施放Cosmic Smash时发出警报。",
	smash_message = "即将 Cosmic Smash！",

	blackhole = "黑洞爆炸",
	blackhole_desc = "当黑洞爆炸出现时发出警报。",
	blackhole_message = "黑洞爆炸：>%dx< 出现！",

	log = "|cffff0000"..boss.."|r：缺乏数据，请考虑开启战斗记录（/combatlog）或 Transcriptor 记录并提交战斗记录，谢谢！",
} end )

L:RegisterTranslations("zhTW", function() return {
	punch = "相位拳擊",
	punch_desc = "當玩家中了4層相位拳擊時發出警報。",
	punch_message = "%dx相位拳擊： >%s<！",

	smash = "宇宙潰擊",
	smash_desc = "當施放宇宙潰擊時發出警報。",
	smash_message = "即將 宇宙潰擊！",

	blackhole = "黑洞爆炸",
	blackhole_desc = "當黑洞爆炸出現時發出警報。",
	blackhole_message = "黑洞爆炸：>%dx< 出現！",

	log = "|cffff0000"..boss.."|r：缺乏數據，請考慮開啟戰斗記錄（/combatlog）或 Transcriptor 記錄并提交戰斗記錄，謝謝！",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Punch", 64412)
	self:AddCombatListener("SPELL_AURA_APPLIED_DOSE", "PunchCount", 64412)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Smash", 62301, 64597)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "BlackHole", 64122)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	db = self.db.profile

	BigWigs:Print(L["log"])
end

------------------------------
--      Event Handlers      --
------------------------------

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
		self:Bar(L["smash"], 25, 64597)
	end
end

function mod:BlackHole()
	if db.blackhole then
		blackholes = blackholes + 1				
		self:IfMessage(L["blackhole_message"]:format(blackholes), "Attention") 
	end
end
