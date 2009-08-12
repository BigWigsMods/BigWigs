--------------------------------------------------------------------------------
-- Module Declaration
--

local boss = BB["Lord Jaraxxus"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Trial of the Crusader"]	--need the add name translated, maybe add to BabbleZone.
mod.enabletrigger = boss
mod.guid = 34780
mod.toggleoptions = {"incinerate", "legionflame", "icon", "netherportal", "netherpower", "infernaleruption", "bosskill"}

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

	engage_trigger = "text",

	incinerate = "Incinerate Flesh",
	incinerate_desc = "Warn for Incinerate Flesh",
	incinerate_you = "Incinerate on YOU!",
	incinerate_other = "Incinerate on %s",
	incinerate_bar = "~Next Incinerate",
	incinerate_safe = "%s is safe!",

	legionflame = "Legion Flame",
	legionflame_desc = "Warn for Legion Flame",
	legionflame_you = "Flame on YOU!",
	legionflame_other = "Flame on %s!",
	legionflame_bar = "~Next Flame",

	icon = "Place Icon",
	icon_desc = "Place a Raid Icon on the player with Legion Flame. (requires promoted or higher)",	

	netherportal = "Nether Portal",
	netherportal_desc = "Warn for Nether Portal",
	netherportal_bar = "~Next Portal",

	netherpower = "Nether Power",
	netherpower_desc = "Warn for Nether Power",
	netherpower_bar = "~Next Nether Power",

	infernaleruption = "Infernal Eruption",
	infernaleruption_desc = "Warn for Infernal Eruption",
} end)
L:RegisterTranslations("koKR", function() return {
	engage_trigger = "불타는 군단의 에레다르 군주 자라서스님이 상대해주마",	--check

	incinerate = "살점 소각",
	incinerate_desc = "살점 소각을 알립니다.",
	incinerate_you = "당신은 살점 소각!",
	incinerate_other = "살점 소각: %s",
	incinerate_bar = "~살점 소각 대기시간",

	legionflame = "불꽃 군단",
	legionflame_desc = "불꽃 군단을 알립니다.",
	legionflame_you = "당신은 불꽃 군단!",
	legionflame_other = "불꽃 군단: %s!",
	legionflame_bar = "~불꽃 군단 대기시간",

	icon = "전술 표시",
	icon_desc = "불꽃 군단 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",	

	netherportal = "황천의 차원문",
	netherportal_desc = "황천의 차원문을 알립니다.",
	netherportal_bar = "~황천 차원문 대기시간",

	netherpower = "황천의 힘",
	netherpower_desc = "황천의 힘을 알립니다.",
	netherpower_bar = "~황천의 힘 대기시간",

	infernaleruption = "지옥불정령 분출",
	infernaleruption_desc = "지옥불정령 분출을 알립니다.",
} end)
L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Devant vous se tient Jaraxxus, seigneur érédar de la Légion ardente !", -- à vérifier

	incinerate = "Incinérer la chair",
	incinerate_desc = "Warn for Incinerate Flesh",
	incinerate_you = "Incinérer la chair sur VOUS !",
	incinerate_other = "Incinérer la chair : %s",
	incinerate_bar = "~Recharge Incinérer",

	legionflame = "Flamme de la Légion",
	legionflame_desc = "Warn for Legion Flame",
	legionflame_you = "Flamme de la Légion sur VOUS !",
	legionflame_other = "Flamme de la Légion : %s",
	legionflame_bar = "~Recharge Flamme",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par une Flamme de la Légion (nécessite d'être assistant ou mieux).",

	netherportal = "Portail du Néant",
	netherportal_desc = "Prévient de l'arrivée des Portails du Néant.",
	netherportal_bar = "~Recharge Portail",

	netherpower = "Puissance du Néant",
	netherpower_desc = "Prévient de l'arrivée des Puissances du Néant.",
	netherpower_bar = "~Recharge Puissance",

	infernaleruption = "Eruption infernale",
	infernaleruption_desc = "Prévient de l'arrivée des Eruptions infernales.",
} end)
L:RegisterTranslations("deDE", function() return {
	engage_trigger = "^Ihr steht vor Jaraxxus",
	
	incinerate = "Fleisch einäschern",
	incinerate_desc = "Warnt vor Fleisch einäschern.",
	incinerate_you = "Fleisch einäschern auf DIR!",
	incinerate_other = "Fleisch einäschern: %s",
	incinerate_bar = "~Fleisch einäschern",
	
	legionflame = "Legionsflamme",
	legionflame_desc = "Warnt vor Legionsflamme.",
	legionflame_you = "Legionsflamme auf DIR!",
	legionflame_other = "Legionsflamme auf: %s!",
	legionflame_bar = "~Legionsflamme",
	
	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern mit Legionsflamme. (benötigt Assistent oder höher).",
	
	netherportal = "Netherportal",
	netherportal_desc = "Warnt vor Netherportal.",
	netherportal_bar = "~Netherportal",
	
	netherpower = "Macht des Nether",
	netherpower_desc = "Warnt vor Macht des Nether.",	
	netherpower_bar = "~Macht des Nether",
	
	infernaleruption = "Höllische Eruption",
	infernaleruption_desc = "Warnt vor Höllische Eruption.",
} end)
L:RegisterTranslations("zhCN", function() return {
-[[
--	engage_trigger = "text",

	incinerate = "Incinerate Flesh",
	incinerate_desc = "当施放Incinerate Flesh时发出警报。",
	incinerate_you = ">你< Incinerate Flesh！",
	incinerate_other = "Incinerate Flesh：>%s<！",
	incinerate_bar = "<Incinerate Flash 冷却>",

	legionflame = "Legion Flame",
	legionflame_desc = "当施放Legion Flame时发出警报。",
	legionflame_you = ">你< Legion Flame！",
	legionflame_other = "Legion Flame：>%s<！",
	legionflame_bar = "<Legion Flame 冷却>",

	icon = "团队标记",
	icon_desc = "为中了Legion Flame的队员打上团队标记。（需要权限）",	

	netherportal = "Nether Portal",
	netherportal_desc = "当施放Nether Portal时发出警报。",
	netherportal_bar = "<Nether Portal 冷却>",

	netherpower = "Nether Power",
	netherpower_desc = "当施放Nether Power时发出警报。",
	netherpower_bar = "<Nether Power 冷却>",

	infernaleruption = "Infernal Eruption",
	infernaleruption_desc = "当施放Infernal Eruption时发出警报。",
-]]
} end)
L:RegisterTranslations("zhTW", function() return {
--	engage_trigger = "text",

	incinerate = "焚化血肉",
	incinerate_desc = "當施放焚化血肉時發出警報。",
	incinerate_you = ">你< 焚化血肉！",
	incinerate_other = "焚化血肉：>%s<！",
	incinerate_bar = "<焚化血肉 冷卻>",

	legionflame = "聚合烈焰",
	legionflame_desc = "當施放聚合烈焰時發出警報。",
	legionflame_you = ">你< 聚合烈焰！",
	legionflame_other = "聚合烈焰：>%s<！",
	legionflame_bar = "<聚合烈焰 冷卻>",

	icon = "團隊標記",
	icon_desc = "為中了聚合烈焰的隊員打上團隊標記。（需要權限）",	

	netherportal = "虛空傳送門",
	netherportal_desc = "當施放虛空傳送門時發出警報。",
	netherportal_bar = "<虛空傳送門 冷卻>",

	netherpower = "虛空傳送門（能量）",
	netherpower_desc = "當施放虛空傳送門（能量）時發出警報。",
	netherpower_bar = "<虛空傳送門（能量） 冷卻>",

	infernaleruption = "煉獄爆發",
	infernaleruption_desc = "當施放煉獄爆發時發出警報。",
} end)
L:RegisterTranslations("ruRU", function() return {
} end)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "IncinerateFlesh", 67049, 67051)
	self:AddCombatListener("SPELL_AURA_REMOVED", "IncinerateFleshRemoved", 67049, 67051)
	self:AddCombatListener("SPELL_AURA_APPLIED", "LegionFlame", 68125)
	self:AddCombatListener("SPELL_AURA_REMOVED", "RemoveLegionFlameIcon", 68128)
	self:AddCombatListener("SPELL_AURA_APPLIED", "NetherPower", 67108)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "NetherPortal", 67900)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "InfernalEruption", 67903)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	db = self.db.profile
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:IncinerateFlesh(player, spellID)
	if db.incinerate then
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
end

function mod:IncinerateFleshRemoved(player, spellID)
	if db.incinerate then
		self:TargetMessage(L["incinerate_safe"], player, "Positive", 17) -- Power Word: Shield icon.
		self:TriggerEvent("BigWigs_StopBar", self, L["incinerate_other"]:format(player))
	end
end

function mod:LegionFlame(player, spellID)
	if db.legionflame then
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
end

function mod:RemoveLegionFlameIcon(player, spellID)
	if db.icon then
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
	end
end

function mod:NetherPower(_, spellID)
	if db.netherpower then
		self:IfMessage(L["netherpower"], "Attention", spellID)
		self:Bar(L["netherpower_bar"], 40, spellID)
	end
end

function mod:NetherPortal(_, spellID)
	if db.netherportal then
		self:IfMessage(L["netherportal"], "Urgent", spellID, "Alarm")
		self:Bar(L["netherportal_bar"], 120, spellID)
	end
end

function mod:InfernalEruption(_, spellID)
	if db.infernaleruption then
		self:IfMessage(L["infernaleruption"], "Urgent", spellID, "Alarm")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) then

	end
end

