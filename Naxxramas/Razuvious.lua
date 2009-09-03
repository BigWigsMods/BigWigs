----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Instructor Razuvious"]
local understudy = BB["Death Knight Understudy"]

local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.wipemobs = understudy
mod.guid = 16061
mod.toggleOptions = {29107, 55550, -1, 29061, 29060, "bosskill",}
mod.consoleCmd = "Razuvious"

------------------------------
--      Are you local?      --
------------------------------

local started = nil

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	shout_warning = "Disrupting Shout in 5sec!",
	shout_next = "Shout Cooldown",

	taunt_warning = "Taunt ready in 5sec!",
	shieldwall_warning = "Barrier gone in 5sec!",
} end )

L:RegisterTranslations("deDE", function() return {
	shout_warning = "Unterbrechender Schrei in 5 sek!",
	shout_next = "~Unterbrechender Schrei",

	taunt_warning = "Spott bereit in 5 sek!",
	shieldwall_warning = "Knochenbarriere weg in 5 sek!",
} end )

L:RegisterTranslations("koKR", function() return {
	shout_warning = "5초 후 분열의 외침!",
	shout_next = "분열 대기시간",

	taunt_warning = "5초 후 도발 종료!",
	shieldwall_warning = "5초 후 방패의 벽 종료!",
} end )

L:RegisterTranslations("zhCN", function() return {
	shout_warning = "5秒后，瓦解怒吼！",
	shout_next = "瓦解怒吼冷却！",

	taunt_warning = "5秒后，可以嘲讽！",
	shieldwall_warning = "5秒后，可以白骨屏障！",
} end )

L:RegisterTranslations("zhTW", function() return {
	shout_warning = "5秒後，混亂怒吼！",
	shout_next = "混亂怒吼冷卻！",

	taunt_warning = "5秒後，可以嘲諷！",
	shieldwall_warning = "5秒後，可以骸骨屏障！",
} end )

L:RegisterTranslations("frFR", function() return {
	shout_warning = "Cri perturbant dans 5 sec. !",
	shout_next = "Recharge Cri",

	taunt_warning = "Provocation prête dans 5 sec. !",
	shieldwall_warning = "Barrière d'os terminée dans 5 sec. !",
} end )

L:RegisterTranslations("ruRU", function() return {
	shout_warning = "Разрушительный крик через 5сек!",
	shout_next = "~перезарядка крика",

	taunt_warning = "Провокация закончится через 5сек!",
	shieldwall_warning = "Преграда из костей закончится через 5сек!",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Shout", 29107, 55543)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Taunt", 29060)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Knife", 55550)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "ShieldWall", 29061)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	started = nil

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Shout(_, spellId, _, _, spellName)
	if spellName then
		self:IfMessage(spellName, "Important", 55543)
	end
	self:Bar(L["shout_next"], 15, 55543)
	self:DelayedMessage(12, L["shout_warning"], "Attention")
end

function mod:ShieldWall(_, spellId, _, _, spellName)
	self:Message(spellName, "Positive", nil, nil, nil, spellId)
	self:Bar(spellName, 20, spellId)
	self:DelayedMessage(15, L["taunt_warning"], "Attention")
end

function mod:Taunt(_, spellId, _, _, spellName)
	self:Message(spellName, "Positive", nil, nil, nil, spellId)
	self:Bar(spellName, 20, spellId)
	self:DelayedMessage(15, L["shieldwall_warning"], "Attention")
end

function mod:Knife(player, spellId, _, _, spellName)
	self:TargetMessage(spellName, unit, "Important", spellId)
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self:GetOption(29107) then
			self:Shout()
		end
	end
end

