--------------------------------------------------------------------------------
-- Module Declaration
--

local boss = BB["Icehowl"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Trial of the Crusader"]	--need the add name translated, maybe add to BabbleZone.
mod.otherMenu = "The Argent Coliseum"
mod.enabletrigger = boss
mod.guid = 34797
mod.toggleoptions = {"butt", "charge", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--
local db
local pName = UnitName("player")

--------------------------------------------------------------------------------
-- Localization
--

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	cmd = "Icehowl",
	
	butt = "Ferocious Butt",
	butt_desc = "Warn for Ferocious Butt.",
	butt_message = "Ferocious Butt: %s!",
	butt_bar = "~Butt Cooldown",
	
	charge = "Furious Charge",
	charge_desc = "Warn about Furious Charge on players.",
	charge_trigger = "^%%s",	--check
	charge_other = "Furious Charge: %s!",
	charge_you = "Furious Charge YOU!",
	charge_warning = "Trample soon",
} end)
L:RegisterTranslations("koKR", function() return {
	butt = "흉포한 박치기",
	butt_desc = "흉포한 박치기를 알립니다.",
	butt_message = "흉포한 박치기: %s!",
	butt_bar = "~박치기 대기시간",
	
	charge = "사나운 돌진",
	charge_desc = "사나운 돌진의 대상 플레이어를 알립니다.",
	charge_trigger = "([^%s]+)|1을;를; 노려보며 큰 소리로 울부짖습니다.$",
	charge_other = "사나운 돌진: %s!",
	charge_you = "당신에게 사나운 돌진!",
	charge_warning = "곧 밟아 뭉개기",
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
	self:AddCombatListener("SPELL_AURA_APPLIED", "Butt", 67654)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	db = self.db.profile
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Butt(player, spellID)
	if db.butt then
		self:TargetMessage(L["butt_message"], player, "Attention", spellID)
		self:Bar(L["butt_bar"], 12, spellID)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(message, unit, _, _, player)
	if unit == boss and db.charge and message:find(L["charge_trigger"]) then
		if player == pName then
			self:LocalMessage(L["charge_you"], "Personal", 52311, "Alarm")
			self:WideMessage(L["charge_other"]:format(player))
		else
			self:TargetMessage(L["charge_other"], player, "Attention", 52311)
		end
		self:Bar(L["charge_other"]:format(player), 7, 62374)
		self:DelayedMessage(4, L["charge_warning"], "Attention")
	end
end

