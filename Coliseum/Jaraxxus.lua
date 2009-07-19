--------------------------------------------------------------------------------
-- Module Declaration
--

local boss = BB["Lord Jaraxxus"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["The Argent Coliseum"]
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
	incinerate_you = "Incinerate Fles on You!",
	incinerate_other = "Incinerate Flesh %s",
	incinerate_bar = "~Incinerate Flash Cooldown",
	
	legionflame = "Legion Flame",
	legionflame_desc = "Warn for Legion Flame",
	legionflame_you = "Legion Flame on You!",
	legionflame_other = "Legion Flame on %s!",
	legionflame_bar = "~Legion Flame Cooldown",
	
	icon = "Place Icon",
	icon_desc = "Place a Raid Icon on the player with Legion Flame. (requires promoted or higher)",	
	
	netherportal = "Nether Portal",
	netherportal_desc = "Warn for Nether Portal",
	netherportal_bar = "~Nether Portal Cooldown",
	
	netherpower = "Nether Power",
	netherpower_desc = "Warn for Nether Power",	
	netherpower_bar = "~Nether Power Cooldown",
	
	infernaleruption = "Infernal Eruption",
	infernaleruption_desc = "Warn for Infernal Eruption",
	
	
} end)
L:RegisterTranslations("koKR", function() return {
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
	self:AddCombatListener("SPELL_AURA_APPLIED", "IncinerateFlesh", 67049)	
	self:AddCombatListener("SPELL_AURA_REMOVED", "IncinerateFleshRemoved", 67049)	
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
			self:LocalMessage(L["incinerate_you"], "Personal", spellID, "Alert")
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

