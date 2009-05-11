----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Algalon the Observer"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 32871
mod.toggleoptions = {"bosskill", "punch", "smash"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local punch = GetSpellInfo(64412)

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

	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {

	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 /전투기록 , /대화기록 을 입력하여 기록된 데이터나 스샷등을 http://cafe.daum.net/SCU15 통해 알려주세요.",
} end )

L:RegisterTranslations("frFR", function() return {

	log = "|cffff0000"..boss.."|r : ce boss a besoin de donnees, merci d'activer votre /combatlog ou Transcriptor et de nous transmettre les logs.",
} end )

L:RegisterTranslations("deDE", function() return {

	log = "|cffff0000"..boss.."|r: Für diesen Boss werden noch Daten benötigt, aktiviere bitte dein /combatlog oder das Addon Transcriptor und lass uns die Logs zukommen.",
} end )

L:RegisterTranslations("zhCN", function() return {
	
	log = "|cffff0000"..boss.."|r：缺乏数据，请考虑开启战斗记录（/combatlog）或 Transcriptor 记录并提交战斗记录，谢谢！",
} end )

L:RegisterTranslations("zhTW", function() return {
	
	log = "|cffff0000"..boss.."|r：缺乏數據，請考慮開啟戰斗記錄（/combatlog）或 Transcriptor 記錄并提交戰斗記錄，謝謝！",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Punch", 64412)
	self:AddCombatListener("SPELL_AURA_APPLIED_DOSE", "PunchCount", 64412)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Smash", 62301, 64597)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	db = self.db.profile

	BigWigs:Print(L["log"])
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Punch(player, spellID)
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

function mod:Smash(player, spellID)
	if db.smash then
		self:IfMessage(L["smash_message"], "Attention", 62301, "Info"  )
		self:Bar(L["smash"], 25, 64597)
	end
end

