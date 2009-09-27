--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Lord Jaraxxus", "Trial of the Crusader")
if not mod then return end
mod:Toggle(67049, "MESSAGE", "BAR", "WHISPER")
mod:Toggle(68123, "MESSAGE", "BAR", "WHISPER", "ICON")
mod:Toggle(67106, "MESSAGE", "BAR")
mod:Toggle("adds", "MESSAGE", "BAR")
mod:Toggle("bosskill")

--------------------------------------------------------------------------------
-- Localization
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Jaraxxus", "enUS", true)
if L then
	L.enable_trigger = "Trifling gnome! Your arrogance will be your undoing!"

	L.engage = "Engage"
	L.engage_trigger = "You face Jaraxxus, Eredar Lord of the Burning Legion!"
	L.engage_trigger1 = "Banished to the Nether"

	L.adds = "Portals and volcanos"
	L.adds_desc = "Show a timer and warn for when Jaraxxus summons portals and volcanos."

	L.incinerate_message = "Incinerate"
	L.incinerate_other = "%s goes boom!"
	L.incinerate_bar = "Next Incinerate"
	L.incinerate_safe = "%s is safe, yay :)"

	L.legionflame_message = "Flame"
	L.legionflame_other = "Flame on %s!"
	L.legionflame_bar = "Next Flame"

	L.icon = "Place Icon"
	L.icon_desc = "Place a Raid Icon on the player with Legion Flame. (requires promoted or higher)"

	L.infernal_bar = "Volcano spawns"
	L.netherportal_bar = "Portal spawns"
	L.netherpower_bar = "~Next Nether Power"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Jaraxxus")
mod.locale = L

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:RegisterEnableMob(34780)
	self:RegisterEnableYell(L["enable_trigger"])
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "IncinerateFlesh", 67049, 67050, 67051, 66237)
	self:Log("SPELL_AURA_REMOVED", "IncinerateFleshRemoved", 67049, 67050, 67051, 66237)
	self:Log("SPELL_AURA_APPLIED", "LegionFlame", 68123, 68124, 68125, 66197)
	self:Log("SPELL_AURA_REMOVED", "RemoveLegionFlameIcon", 68126, 68127, 68128, 66199)
	self:Log("SPELL_AURA_APPLIED", "NetherPower", 67106, 67107, 67108, 66228)
	self:Log("SPELL_CAST_SUCCESS", "NetherPortal", 68404, 68405, 68406, 67898, 67899, 67900, 66269)
	self:Log("SPELL_CAST_SUCCESS", "InfernalEruption", 66258, 67901, 67902, 67903)

	-- Only happens the first time we engage Jaraxxus, still 11 seconds left until he really engages.
	self:Yell("FirstEngage", L["engage_trigger1"])
	self:Yell("Engage", L["engage_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 34780)
end

function mod:FirstEngage()
	self:Bar(L["engage"], 11, "INV_Gizmo_01")
end

function mod:OnEngage()
	self:Bar("adds", L["netherportal_bar"], 20, 68404)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:IncinerateFlesh(player, spellId)
	self:TargetMessage(67049, L["incinerate_message"], player, "Urgent", spellId, "Info")
	self:Whisper(67049, player, L["incinerate_message"])
	self:Bar(67049, L["incinerate_other"]:format(player), 12, spellId)
end

function mod:IncinerateFleshRemoved(player, spellId)
	self:IfMessage(67049, L["incinerate_safe"]:format(player), "Positive", 17) -- Power Word: Shield icon.
	self:SendMessage(67049, "BigWigs_StopBar", self, L["incinerate_other"]:format(player))
end

function mod:LegionFlame(player, spellId)
	self:TargetMessage(68123, L["legionflame_message"], player, "Personal", spellId, "Alert")
	self:Whisper(68123, player, L["legionflame_message"])
	self:Bar(68123, L["legionflame_other"]:format(player), 8, spellId)
	self:PrimaryIcon(68123, player, "icon")
end

function mod:RemoveLegionFlameIcon()
	self:PrimaryIcon(68123, false, "icon")
end

function mod:NetherPower(unit, spellId, _, _, spellName, _, _, _, dGuid)
	local target = tonumber(dGuid:sub(-12, -7), 16)
	if target == 34780 then
		self:IfMessage(67106, spellName, "Attention", spellId)
		self:Bar(67106, L["netherpower_bar"], 44, spellId)
	end
end

function mod:NetherPortal(_, spellId, _, _, spellName)
	self:IfMessage("adds", spellName, "Urgent", spellId, "Alarm")
	self:Bar("adds", L["infernal_bar"], 60, 66258)
end

function mod:InfernalEruption(_, spellId, _, _, spellName)
	self:IfMessage("adds", spellName, "Urgent", spellId, "Alarm")
	self:Bar("adds", L["netherportal_bar"], 60, 68404)
end

