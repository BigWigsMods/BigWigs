--------------------------------------------------------------------------------
-- Module Declaration
--

local boss = BB["Gormok the Impaler"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Trial of the Crusader"]	--need the add name translated, maybe add to BabbleZone.
mod.otherMenu = "The Argent Coliseum"
mod.enabletrigger = boss
mod.guid = 34796
mod.toggleoptions = {"stomp", "impaler", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--
local db = nil
local pName = UnitName("player")
local impaler = GetSpellInfo(63355)

--------------------------------------------------------------------------------
-- Localization
--

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	cmd = "Gormok",
	
	impaler = "Impaler",
	impaler_desc = "Warn when someone has 2 or more stacks of Impaler.",
	impaler_message = "Impaler: %s",
	
	stomp = "Staggering Stomp",
	stomp_desc = "Warn when Gormok casts Staggering Stomp.",
	stomp_message = "Staggering Stomp!",
	stomp_warning = "Staggering Stomp soon!",
	stomp_bar = "~Next Stomp",
} end)
L:RegisterTranslations("koKR", function() return {
	impaler = "꿰뚫기",
	impaler_desc = "꿰뚫기 중첩이 2이상이 된 플레이어를 알립니다.",
	impaler_message = "꿰뚫기: %s",
	
	stomp = "진동의 발구르기",
	stomp_desc = "고르목의 진동의 발구르기 시전을 알립니다.",
	stomp_message = "진동의 발구르기!",
	stomp_warning = "잠시 후 발구르기!",
	stomp_bar = "~다음 발구르기",
} end)
L:RegisterTranslations("frFR", function() return {
} end)
L:RegisterTranslations("deDE", function() return {
} end)
L:RegisterTranslations("zhCN", function() return {
} end)
L:RegisterTranslations("zhTW", function() return {
} end)
L:RegisterTranslations("ruRU", function() return {
} end)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED_DOSE", "Impaler", 67477)
	self:AddCombatListener("SPELL_CAST_START", "Stomp", 67647)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	db = self.db.profile
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Impaler(player, spellID)
	if db.impaler then
		local _, _, icon, stack = UnitDebuff(player, impaler)
		if stack and stack > 1 then
			self:TargetMessage(L["impaler_message"], player, "Urgent", icon, "Info", stack)
		end
	end
end

function mod:Stomp(_, spellID)
	if db.stomp then
		self:IfMessage(L["stomp_message"], Attention, spellID, Long)
		self:Bar(L["stomp_bar"], 21, spellID)
		self:DelayedMessage(18, L["stomp_warning"], "Attention")
	end
end
