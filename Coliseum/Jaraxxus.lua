--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Lord Jaraxxus", "Trial of the Crusader")
if not mod then return end
mod.toggleOptions = {{67049, "WHISPER"}, {68123, "WHISPER", "ICON", "FLASHSHAKE"}, 67106, "adds", {67905, "FLASHSHAKE"}, "berserk", "bosskill"}
mod.optionHeaders = {
	[67049] = "normal",
	[67905] = "heroic",
	bosskill = "general",
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.enable_trigger = "Trifling gnome! Your arrogance will be your undoing!"

	L.engage = "Engage"
	L.engage_trigger = "You face Jaraxxus, Eredar Lord of the Burning Legion!"
	L.engage_trigger1 = "But I'm in charge here"

	L.adds = "Portals and volcanos"
	L.adds_desc = "Show a timer and warn for when Jaraxxus summons portals and volcanos."

	L.incinerate_message = "Incinerate"
	L.incinerate_other = "%s goes boom!"
	L.incinerate_bar = "Next Incinerate"
	L.incinerate_safe = "%s is safe, yay :)"

	L.legionflame_message = "Flame"
	L.legionflame_other = "Flame on %s!"
	L.legionflame_bar = "Next Flame"

	L.infernal_bar = "Volcano spawns"
	L.netherportal_bar = "Portal spawns"
	L.netherpower_bar = "~Next Nether Power"

	L.kiss_message = "Kiss on YOU!"
	L.kiss_interrupted = "Interrupted!"
end
L = mod:GetLocale()

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
	self:Log("SPELL_AURA_APPLIED", "NetherPower", 67106, 67107, 67108, 66228)
	self:Log("SPELL_CAST_SUCCESS", "NetherPortal", 68404, 68405, 68406, 67898, 67899, 67900, 66269)
	self:Log("SPELL_CAST_SUCCESS", "InfernalEruption", 66258, 67901, 67902, 67903)
	self:Log("SPELL_AURA_APPLIED", "MistressKiss", 67905, 67906, 67907, 66334) -- debuff before getting interrupted
	self:Log("SPELL_AURA_REMOVED", "MistressKissRemoved", 67905, 67906, 67907, 66334)
	self:Log("SPELL_INTERRUPT", "MistressKissInterrupted", 66335, 66359, 67073, 67074, 67075, 67908, 67909, 67910) -- debuff after getting interrupted

	-- Only happens the first time we engage Jaraxxus, still 11 seconds left until he really engages.
	self:Yell("FirstEngage", L["engage_trigger1"])
	self:Yell("Engage", L["engage_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 34780)
end

function mod:FirstEngage()
	self:Bar("adds", L["engage"], 12, "INV_Gizmo_01")
end

function mod:OnEngage(diff)
	self:Bar("adds", L["netherportal_bar"], 20, 68404)
	if diff > 2 then
		self:Berserk(600)
	end
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
	self:Message(67049, L["incinerate_safe"]:format(player), "Positive", 17) -- Power Word: Shield icon.
	self:SendMessage("BigWigs_StopBar", self, L["incinerate_other"]:format(player))
end

function mod:LegionFlame(player, spellId)
	self:TargetMessage(68123, L["legionflame_message"], player, "Personal", spellId, "Alert")
	if UnitIsUnit(player, "player") then self:FlashShake(68123) end
	self:Whisper(68123, player, L["legionflame_message"])
	self:Bar(68123, L["legionflame_other"]:format(player), 8, spellId)
	self:PrimaryIcon(68123, player)
end

function mod:NetherPower(unit, spellId, _, _, spellName)
	if unit == self.displayName then
		self:Message(67106, spellName, "Attention", spellId)
		self:Bar(67106, L["netherpower_bar"], 44, spellId)
	end
end

function mod:NetherPortal(_, spellId, _, _, spellName)
	self:Message("adds", spellName, "Urgent", spellId, "Alarm")
	self:Bar("adds", L["infernal_bar"], 60, 66258)
end

function mod:InfernalEruption(_, spellId, _, _, spellName)
	self:Message("adds", spellName, "Urgent", spellId, "Alarm")
	self:Bar("adds", L["netherportal_bar"], 60, 68404)
end

function mod:MistressKiss(player, spellId)
	if not UnitIsUnit(player, "player") then return end
	self:LocalMessage(67905, L["kiss_message"], "Personal", spellId)
	self:Bar(67905, L["kiss_message"], 15, spellId)
	self:FlashShake(67905)
end

function mod:MistressKissRemoved(player, spellId)
	if not UnitIsUnit(player, "player") then return end
	self:SendMessage("BigWigs_StopBar", self, L["kiss_message"])
end

function mod:MistressKissInterrupted(player, spellId)
	if not UnitIsUnit(player, "player") then return end
	self:LocalMessage(67905, L["kiss_interrupted"], "Personal", spellId)
end

