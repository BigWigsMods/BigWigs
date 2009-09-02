--------------------------------------------------------------------------------
-- Module Declaration
--
local boss = BB["Anub'arak"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Trial of the Crusader"]
mod.enabletrigger = boss
mod.guid = 34564
mod.toggleOptions = {66118, 67574, "icon", "burrow", "berserk", "bosskill"}
mod.consoleCmd = "Anubarak"

--------------------------------------------------------------------------------
-- Locals
--

local db

--------------------------------------------------------------------------------
-- Localization
--

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	engage_message = "Anub'arak engaged, burrow in 80sec!",
	engage_trigger = "This place will serve as your tomb!",

	unburrow_trigger = "emerges from the ground",
	burrow_trigger = "burrows into the ground",
	burrow = "Burrow",
	burrow_desc = "Show a timer for Anub'Arak's Burrow ability",
	burrow_cooldown = "Next Burrow",
	burrow_soon = "Burrow soon",

	icon = "Place icon",
	icon_desc = "Place a raid target icon on the person targetted by Anub'arak during his burrow phase. (requires promoted or higher)",

	chase = "Pursue",
} end)
L:RegisterTranslations("koKR", function() return {
	engage_message = "전투 시작",
	engage_trigger = "여기가 네 무덤이 되리라!",	--check

	burrow = "소멸",
	burrow_desc = "아눕아락의 소멸 기술에 대하여 타이머등으로 알립니다.",
	burrow_cooldown = "다음 소멸",
} end)
L:RegisterTranslations("frFR", function() return {
	engage_message = "Anub'arak engagé, Fouir dans 80 sec. !",
	engage_trigger = "Ce terreau sera votre tombeau !",

	unburrow_trigger = "surgit de la terre",
	burrow_trigger = "s'enfonce dans le sol",
	burrow = "Fouir",
	burrow_desc = "Affiche un délai de la technique Fouir d'Anub'Arak.",
	burrow_cooldown = "Prochain Fouir",
	burrow_soon = "Fouir imminent",

	icon = "Icône",
	icon_desc = "Place une icône sur le dernier joueur poursuivi par Anub'arak lors de sa phase sous terre (nécessite d'être assistant ou mieux).",

	chase = "Poursuivi",
} end)
L:RegisterTranslations("deDE", function() return {
	engage_message = "Anub'arak angegriffen, Eingraben in 80 sek!",
	engage_trigger = "^Dieser Ort wird Euch als Grab dienen!", --check!

	--unburrow_trigger = "%s emerges from the ground!", --check!
	burrow = "Eingraben",
	burrow_desc = "Zeige einen Timer für Anub'arak's Eingraben.",
	burrow_cooldown = "~Eingraben",
	
	chase = "Verfolgen",
} end)
L:RegisterTranslations("zhCN", function() return {
	--engage_message = "Anub'arak engaged, burrow in 80sec!",
--	engage_trigger = "This place will serve as your tomb!",

	--unburrow_trigger = "%s emerges from the ground!",
	burrow = "钻地",
	burrow_desc = "当阿努巴拉克钻地时显示计时条。",
	burrow_cooldown = "下一钻地",
} end)
L:RegisterTranslations("zhTW", function() return {
	--engage_message = "Anub'arak engaged, burrow in 80sec!",
	engage_trigger = "這裡將會是你們的墳墓!",

	--unburrow_trigger = "%s emerges from the ground!",
	burrow = "鑽地",
	burrow_desc = "當阿努巴拉克鑽地時顯示計時條。",
	burrow_cooldown = "下一鑽地",
} end)
L:RegisterTranslations("ruRU", function() return {
	engage_message = "Ануб'арак вступил в бой, зарывание в землю через 80сек!",
	engage_trigger = "Это место станет вашей могилой!",

	--unburrow_trigger = "emerges from the ground",
	burrow = "Червоточина",
	burrow_desc = "Отображать таймер способности Ануб'арака зарывается в землю",
	burrow_cooldown = "Следующее зарывание",

	chase = "Преследование",
} end)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Swarm", 66118)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Pursue", 67574)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	db = self.db.profile
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Swarm(player, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
end

function mod:Pursue(player, spellId)
	self:TargetMessage(L["chase"], player, "Personal", spellId)
	self:Whisper(player, L["chase"])
	self:Icon(player, "icon")
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) then
		if db.burrow then
			self:IfMessage(L["engage_message"], "Attention", 65919)
			self:Bar(L["burrow_cooldown"], 80, 65919)
		end
		if db.berserk then
			self:Enrage(600, true, true)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if db.burrow and msg:find(L["unburrow_trigger"]) then
		self:Bar(L["burrow_cooldown"], 80, 65919)
		self:DelayedMessage(70, L["burrow_soon"], "Attention")
	end
	if db.burrow and msg:find(L["burrow_trigger"]) then
		self:Bar(L["burrow"], 65, 65919)
	end
end

