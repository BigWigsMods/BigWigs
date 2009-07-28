--------------------------------------------------------------------------------
-- Module Declaration
--
local boss = BB["Anub'arak"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Trial of the Crusader"]	--need the add name translated, maybe add to BabbleZone.
mod.otherMenu = "The Argent Coliseum"
mod.enabletrigger = boss
mod.guid = 34564
mod.toggleoptions = {"bosskill", "burrow", "pursue", "phase"}

--------------------------------------------------------------------------------
-- Locals
--

local db
local phase

--------------------------------------------------------------------------------
-- Localization
--

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	cmd = "Anubarak",

	engage = "Engage",
	engage_trigger = "This place will serve as your tomb!",

	phase = "Phase",
	phase_desc = "Warn on phase transitions",
	phase_message = "Phase 2!",

	burrow = "Burrow",
	burrow_desc = "Show a timer for Anub'Arak's Burrow ability",
	burrow_emote = "FIXME",
	burrow_message = "Burrow",
	burrow_cooldown = "Next Burrow",

	pursue = "Pursue",
	pursue_desc = "Show who Anub'Arak is pursuing",
	pursue_message = "Pursuing YOU!",
	pursue_other = "Pursuing %s",

} end)
L:RegisterTranslations("koKR", function() return {
	engage = "전투 시작",
	engage_trigger = "여기가 네 무덤이 되리라!",	--check

	phase = "단계",
	phase_desc = "단계 변화를 알립니다.",
	phase_message = "2 단계!",

	burrow = "소멸",
	burrow_desc = "아눕아락의 소멸 기술에 대하여 타이머등으로 알립니다.",
	burrow_emote = "FIXME",	--check
	burrow_message = "소멸!",
	burrow_cooldown = "다음 소멸",

	pursue = "추격",
	pursue_desc = "누가 아눕아락의 추격인지 알립니다.",
	pursue_message = "당신을 추격중!",
	pursue_other = "추격: %s",
} end)
L:RegisterTranslations("frFR", function() return {
	engage = "Engagement",
	engage_trigger = "Ce terreau sera votre tombeau !", -- à vérifier

	phase = "Phase",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",
	phase_message = "Phase 2 !",

	burrow = "Burrow",
	burrow_desc = "Show a timer for Anub'Arak's Burrow ability",
	--burrow_emote = "FIXME",
	burrow_message = "Burrow",
	burrow_cooldown = "Next Burrow",

	pursue = "Poursuite",
	pursue_desc = "Indique qui Anub'Arak est entrain de poursuivre.",
	pursue_message = "VOUS êtes poursuivi(e) !",
	pursue_other = "Pursuivi(e) : %s",
} end)
L:RegisterTranslations("deDE", function() return {
	engage_trigger = "^Dieser Ort wird Euch als Grab dienen!",

	phase = "Phase",
	phase_desc = "Warnt vor Phasenwechsel.",
	phase_message = "Phase 2!",

	burrow = "Verbergen",
	burrow_desc = "Zeige einen Timer für Anub'arak's Eingraben.",
	burrow_emote = "^Erhebt Euch, Diener",
	burrow_message = "Eingraben",
	burrow_cooldown = "Nächstes Eingraben",

	pursue = "Verfolgen",
	pursue_desc = "Zeigt, wen Anub'arak verfolgt.",
	pursue_message = "Verfolgt DICH!",
	pursue_other = "Verfolgt: %s",
} end)
L:RegisterTranslations("zhCN", function() return {
} end)
L:RegisterTranslations("zhTW", function() return {
	engage = "Engage",
	engage_trigger = "This place will serve as your tomb!",

	phase = "階段",
	phase_desc = "當進入不同階段時發出警報。",
	phase_message = "第二階段!",

	burrow = "Burrow",
	burrow_desc = "Show a timer for Anub'Arak's Burrow ability",
	burrow_emote = "FIXME",
	burrow_message = "Burrow",
	burrow_cooldown = "Next Burrow",

	pursue = "Pursue",
	pursue_desc = "Show who Anub'Arak is pursuing",
	pursue_message = "Pursuing YOU!",
	pursue_other = "Pursuing %s",
} end)
L:RegisterTranslations("ruRU", function() return {
} end)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnEnable()
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	self:AddCombatListener("SPELL_AURA_APPLIED", "Pursue", 67574)
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	db = self.db.profile
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Pursue(unit)
	if db.pursue then
		if unit == "player" then
			self:IfMessage(L["pursue_message"], "Important")
		else
			self:IfMessage(L["pursue_other"], "Attention")
		end
	end
end

function mod:UNIT_HEALTH(unit)
	if db.phase then
		if UnitName(unit) == boss then
			if UnitHealth(unit) < 30 and phase ~= 2 then
				self:IfMessage(L["phase_message"], "Positive")
			elseif phase ==2 then
				phase = 1
			end
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) then
		phase = 1
		if db.burrow then
			--self:Bar(L["burrow_cooldown"], 90, 67322)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if db.burrow then
		if msg:find(L["burrow_emote"]) then
			--self:IfMessage(L["burrow"])	
			--self:Bar(L["burrow"], 30, 67322)
			--self:Bar(L["burrow_cooldown"], 90, 67322)
		end
	end
end
