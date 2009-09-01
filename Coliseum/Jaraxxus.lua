--------------------------------------------------------------------------------
-- Module Declaration
--

local boss = BB["Lord Jaraxxus"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Trial of the Crusader"]
mod.enabletrigger = boss
mod.guid = 34780
mod.toggleOptions = {67049, 68123, "icon", 68404, 67106, 66258, "bosskill"}
mod.consoleCmd = "Jaraxxus"

--------------------------------------------------------------------------------
-- Localization
--

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	engage = "Engage",
	engage_trigger = "You face Jaraxxus, Eredar lord of the Burning Legion!",
	engage_trigger1 = "Banished to the Nether",

	incinerate_message = "Incinerate",
	incinerate_other = "Incinerate on %s",
	incinerate_bar = "~Next Incinerate",

	legionflame_message = "Flame",
	legionflame_other = "Flame on %s!",
	legionflame_bar = "~Next Flame",

	icon = "Place Icon",
	icon_desc = "Place a Raid Icon on the player with Legion Flame. (requires promoted or higher)",

	netherportal_bar = "~Next Portal",
	netherpower_bar = "~Next Nether Power",
} end)
L:RegisterTranslations("koKR", function() return {
	engage = "전투 시작",
	engage_trigger = "불타는 군단의 에레다르 군주, 자락서스 님이 상대해주마!",
	engage_trigger1 = "황천으로 사라져라!",

	incinerate_message = "Incinerate",
	incinerate_other = "살점 소각: %s",
	incinerate_bar = "~살점 소각 대기시간",

	legionflame_message = "Flame",
	legionflame_other = "군단 불꽃 : %s!",
	legionflame_bar = "~군단 불꽃 대기시간",

	icon = "전술 표시",
	icon_desc = "불꽃 군단 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	netherportal_bar = "~황천 차원문 대기시간",
	netherpower_bar = "~황천의 힘 대기시간",
} end)
L:RegisterTranslations("frFR", function() return {
	engage = "Engagement",
	engage_trigger = "Devant vous se tient Jaraxxus, seigneur Eredar de la Legion ardente?!",
	--engage_trigger1 = "Banished to the Nether",

	incinerate_message = "Incinerate",
	incinerate_other = "Incinerer la chair?: %s",
	incinerate_bar = "~Recharge Incinerer",

	legionflame_message = "Flame",
	legionflame_other = "Flamme de la Legion?: %s",
	legionflame_bar = "~Recharge Flamme",

	icon = "Icone",
	icon_desc = "Place une icone de raid sur le dernier joueur affecte par une Flamme de la Legion (necessite d'etre assistant ou mieux).",

	netherportal_bar = "~Recharge Portail",
	netherpower_bar = "~Recharge Puissance",
} end)
L:RegisterTranslations("deDE", function() return {
	engage = "Angegriffen",
	engage_trigger = "^Ihr steht vor Jaraxxus",
	--engage_trigger1 = "Banished to the Nether", --need!

	incinerate_message = "Incinerate",
	incinerate_other = "Fleisch einaschern: %s!",
	incinerate_bar = "~Fleisch einaschern",

	legionflame_message = "Flame",
	legionflame_other = "Legionsflamme: %s!",
	legionflame_bar = "~Legionsflamme",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern mit Legionsflamme (benotigt Assistent oder hoher).",

	netherportal_bar = "~Netherportal",
	netherpower_bar = "~Macht des Nether",
} end)
L:RegisterTranslations("zhCN", function() return {
	engage = "激活",
	engage_trigger = "You face Jaraxxus, Eredar lord of the Burning Legion!",
	engage_trigger1 = "Banished to the Nether",

	incinerate_message = "Incinerate",
	incinerate_other = "Incinerate Flesh：>%s<！",
	incinerate_bar = "<下一Incinerate Flash>",

	legionflame_message = "Flame",
	legionflame_other = "Legion Flame：>%s<！",
	legionflame_bar = "<下一Legion Flame>",

	icon = "????",
	icon_desc = "?中了Legion Flame的??打上????。（需要?限）",

	netherportal_bar = "<下一Nether Portal>",
	netherpower_bar = "<下一Nether Power>",
} end)
L:RegisterTranslations("zhTW", function() return {
	engage = "進入戰斗",
	engage_trigger = "You face Jaraxxus, Eredar lord of the Burning Legion!",
	engage_trigger1 = "Banished to the Nether",

	incinerate_message = "焚化血肉",
	incinerate_other = "焚化血肉：>%s<！",
	incinerate_bar = "<下一焚化血肉>",

	legionflame_message = "聚合烈焰",
	legionflame_other = "聚合烈焰：>%s<！",
	legionflame_bar = "<下一聚合烈焰>",

	icon = "團隊標記",
	icon_desc = "?中了聚合烈焰的隊員打上團隊標記。（需要權限）",

	netherportal_bar = "<下一虛空傳送門>",
	netherpower_bar = "<下一虛空傳送門（能量）>",
} end)
L:RegisterTranslations("ruRU", function() return {
	engage = "Начало битвы",

	engage_trigger = "Перед вами Джараксус, эредарский повелитель Пылающего Легиона!",
	engage_trigger1 = "Отправляйся в Пустоту!",

	incinerate_message = "Incinerate",
	incinerate_other = "Испепеление плоти на |3-5(%s)",
	incinerate_bar = "~Следующее Испепеление",

	legionflame_message = "Flame",
	legionflame_other = "Пламя Легиона на |3-5(%s)!",
	legionflame_bar = "~Следующее Пламя",

	icon = "Помечать иконкой",
	icon_desc = "Помечать иконкой игрока с Пламенем Легиона. (Необходимо быть рейд лидером или иметь промоут)",

	netherportal_bar = "~Следующие врата",
	netherpower_bar = "~Следующая Сила Пустоты",
} end)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "IncinerateFlesh", 67049, 67050, 67051, 66237)
	self:AddCombatListener("SPELL_AURA_REMOVED", "IncinerateFleshRemoved", 67049, 67050, 67051, 66237)
	self:AddCombatListener("SPELL_AURA_APPLIED", "LegionFlame", 68123, 68124, 68125, 66197)
	self:AddCombatListener("SPELL_AURA_REMOVED", "RemoveLegionFlameIcon", 68126, 68127, 68128, 66199)
	self:AddCombatListener("SPELL_AURA_APPLIED", "NetherPower", 67106, 67107, 67108, 66228)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "NetherPortal", 68404, 68405, 68406, 67898, 67899, 67900, 66269)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "InfernalEruption", 66258, 67901, 67902, 67903)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:IncinerateFlesh(player, spellId)
	self:TargetMessage(L["incinerate_message"], player, "Personal", spellId, "Info")
	self:Whisper(player, L["incinerate_message"])
	self:Bar(L["incinerate_other"]:format(player), 12, spellId)
	self:Bar(L["incinerate_bar"], 20, spellId)
end

function mod:IncinerateFleshRemoved(player, spellId)
	self:TriggerEvent("BigWigs_StopBar", self, L["incinerate_other"]:format(player))
end

function mod:LegionFlame(player, spellId)
	self:TargetMessage(L["legionflame_message"], player, "Personal", spellId, "Alert")
	self:Whisper(player, L["legionflame_message"])
	self:Bar(L["legionflame_other"]:format(player), 8, spellId)
	self:Bar(L["legionflame_bar"], 30, spellId)
	self:Icon(player, "icon")
end

function mod:RemoveLegionFlameIcon(player, spellId)
	if self.db.profile.icon then
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
	end
end

function mod:NetherPower(unit, spellId, _, _, spellName)
	if unit == boss then
		self:IfMessage(spellName, "Attention", spellId)
		self:Bar(L["netherpower_bar"], 44, spellId)
	end
end

function mod:NetherPortal(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Urgent", spellId, "Alarm")
	self:Bar(L["netherportal_bar"], 120, spellId)
end

function mod:InfernalEruption(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Urgent", spellId, "Alarm")
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
--if you wipe then you never get "engage_trigger1" message again, but always "engage_trigger" message before boss start attack.
--Correct me if i'm wrong
	if msg:find(L["engage_trigger1"]) then
		self:Bar(L["engage"], 11, "INV_Gizmo_01")
		--[[if self.db.profile.netherportal then
			self:Bar(L["netherportal_bar"], 30, 68404) -- engage+19
		end
		if self.db.profile.infernaleruption then
			self:Bar(L["infernaleruption"], 90, 66258) -- engage+79
		end]]
	end
	if msg:find(L["engage_trigger"]) then
		if self.db.profile.netherportal then
			self:Bar(L["netherportal_bar"], 20, 68404)
		end
		if self.db.profile.infernaleruption then
			self:Bar(L["infernaleruption"], 80, 66258)
		end
	end
end

