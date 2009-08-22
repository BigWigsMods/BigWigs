--------------------------------------------------------------------------------
-- Module Declaration
--

local boss = BB["Lord Jaraxxus"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Trial of the Crusader"]
mod.enabletrigger = boss
mod.guid = 34780
mod.toggleoptions = {67049, 68123, "icon", 68404, 67106, 66258, "bosskill"}

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
	cmd = "Jaraxxus",

	engage = "Engage",
	engage_trigger = "You face Jaraxxus, Eredar lord of the Burning Legion!",
	engage_trigger1 = "Banished to the Nether",

	incinerate_you = "Incinerate on YOU!",
	incinerate_other = "Incinerate on %s",
	incinerate_bar = "~Next Incinerate",
	incinerate_safe = "%s is safe!",

	legionflame_you = "Flame on YOU!",
	legionflame_other = "Flame on %s!",
	legionflame_bar = "~Next Flame",

	icon = "Place Icon",
	icon_desc = "Place a Raid Icon on the player with Legion Flame. (requires promoted or higher)",

	netherportal_bar = "~Next Portal",
	netherpower_bar = "~Next Nether Power",
} end)
L:RegisterTranslations("koKR", function() return {
	engage = "전투 시작",
	engage_trigger = "불타는 군단의 에레다르 군주 자라서스 님이 상대해주마!",
	engage_trigger1 = "황천으로",	--check

	incinerate_you = "당신은 살점 소각!",
	incinerate_other = "살점 소각: %s",
	incinerate_bar = "~살점 소각 대기시간",
	incinerate_safe = "%s 안전함!",

	legionflame_you = "당신은 불꽃 군단!",
	legionflame_other = "불꽃 군단: %s!",
	legionflame_bar = "~불꽃 군단 대기시간",
	
	icon = "전술 표시",
	icon_desc = "불꽃 군단 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	netherportal_bar = "~황천 차원문 대기시간",
	netherpower_bar = "~황천의 힘 대기시간",
} end)
L:RegisterTranslations("frFR", function() return {
	engage = "Engagement",
	engage_trigger = "Devant vous se tient Jaraxxus, seigneur Érédar de la Légion ardente !",
	engage_trigger1 = "Banished to the Nether",

	incinerate_you = "Incinérer la chair sur VOUS !",
	incinerate_other = "Incinérer la chair : %s",
	incinerate_bar = "~Recharge Incinérer",
	incinerate_safe = "%s est sauf !",

	legionflame_you = "Flamme de la Légion sur VOUS !",
	legionflame_other = "Flamme de la Légion : %s",
	legionflame_bar = "~Recharge Flamme",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par une Flamme de la Légion (nécessite d'être assistant ou mieux).",

	netherportal_bar = "~Recharge Portail",
	netherpower_bar = "~Recharge Puissance",
} end)
L:RegisterTranslations("deDE", function() return {
	engage_trigger = "^Ihr steht vor Jaraxxus",

	incinerate_you = "Fleisch einäschern auf DIR!",
	incinerate_other = "Fleisch einäschern: %s",
	incinerate_bar = "~Fleisch einäschern",
	incinerate_safe = "%s ist sicher!",

	legionflame_you = "Legionsflamme auf DIR!",
	legionflame_other = "Legionsflamme auf: %s!",
	legionflame_bar = "~Legionsflamme",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern mit Legionsflamme. (benötigt Assistent oder höher).",

	netherportal_bar = "~Netherportal",
	netherpower_bar = "~Macht des Nether",
} end)
L:RegisterTranslations("zhTW", function() return {
--	engage_trigger = "text",

	incinerate_you = ">你< 焚化血肉！",
	incinerate_other = "焚化血肉：>%s<！",
	incinerate_bar = "<焚化血肉 冷卻>",

	legionflame_you = ">你< 聚合烈焰！",
	legionflame_other = "聚合烈焰：>%s<！",
	legionflame_bar = "<聚合烈焰 冷卻>",

	icon = "團隊標記",
	icon_desc = "為中了聚合烈焰的隊員打上團隊標記。（需要權限）",

	netherportal_bar = "<虛空傳送門 冷卻>",
	netherpower_bar = "<虛空傳送門（能量） 冷卻>",
} end)
L:RegisterTranslations("ruRU", function() return {
	engage = "Начало битвы",
	
	engage_trigger = "Перед вами Джараксус, эредарский повелитель Пылающего Легиона!",
	engage_trigger1 = "Отправляйся в Пустоту!",

	incinerate_you = "Испепеление плоти на ВАС!",
	incinerate_other = "Испепеление плоти на |3-5(%s)",
	incinerate_bar = "~Следующее Испепеление",
	incinerate_safe = "%s спасен!",

	legionflame_you = "Пламя Легиона на ВАС!",
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
	db = self.db.profile
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:IncinerateFlesh(player, spellID)
	if player == pName then
		self:LocalMessage(L["incinerate_you"], "Personal", spellID, "Info")
		self:WideMessage(L["incinerate_other"]:format(player))
	else
		self:TargetMessage(L["incinerate_other"], player, "Important", spellID)
		self:Whisper(player, L["incinerate_you"])
	end
	self:Bar(L["incinerate_other"]:format(player), 12, spellID)
	self:Bar(L["incinerate_bar"], 20, spellID)
end

function mod:IncinerateFleshRemoved(player, spellID)
	self:TargetMessage(L["incinerate_safe"], player, "Positive", 17) -- Power Word: Shield icon.
	self:TriggerEvent("BigWigs_StopBar", self, L["incinerate_other"]:format(player))
end

function mod:LegionFlame(player, spellID)
	if player == pName then
		self:LocalMessage(L["legionflame_you"], "Personal", spellID, "Alert")
		self:WideMessage(L["legionflame_other"]:format(player))
	else
		self:TargetMessage(L["legionflame_other"], player, "Important", spellID)
		self:Whisper(player, L["legionflame_you"])
	end
	self:Bar(L["legionflame_other"]:format(player), 8, spellID)
	self:Bar(L["legionflame_bar"], 30, spellID)
	if db.icon then
		self:Icon(player, "icon")
	end
end

function mod:RemoveLegionFlameIcon(player, spellID)
	if db.icon then
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
	end
end

function mod:NetherPower(unit, spellID, _, _, spellName)
	if unit == boss then
		self:IfMessage(spellName, "Attention", spellID)
		self:Bar(L["netherpower_bar"], 44, spellID)
	end
end

function mod:NetherPortal(_, spellID, _, _, spellName)
	self:IfMessage(spellName, "Urgent", spellID, "Alarm")
	self:Bar(L["netherportal_bar"], 120, spellID)
end

function mod:InfernalEruption(_, spellID, _, _, spellName)
	self:IfMessage(spellName, "Urgent", spellID, "Alarm")
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
--if you wipe then you never get "engage_trigger1" message again, but always "engage_trigger" message before boss start attack. 
--Correct me if i'm wrong
	if msg:find(L["engage_trigger1"]) then
		self:Bar(L["engage"], 11, "INV_Gizmo_01")	
		--[[if db.netherportal then
			self:Bar(L["netherportal_bar"], 30, 68404) -- engage+19
		end
		if db.infernaleruption then
			self:Bar(L["infernaleruption"], 90, 66258) -- engage+79
		end]]
	end
	if msg:find(L["engage_trigger"]) then
		if db.netherportal then
			self:Bar(L["netherportal_bar"], 20, 68404) 
		end
		if db.infernaleruption then
			self:Bar(L["infernaleruption"], 80, 66258) 
		end
	end
end

