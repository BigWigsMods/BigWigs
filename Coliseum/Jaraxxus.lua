--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Lord Jaraxxus", "Trial of the Crusader")
if not mod then return end
mod.enabletrigger = 34780
mod.toggleOptions = {67049, 68123, "icon", 68404, 67106, 66258, "bosskill"}

--------------------------------------------------------------------------------
-- Localization
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Jaraxxus", "enUS", true)
if L then
	L.engage = "Engage"
	L.engage_trigger = "You face Jaraxxus, Eredar Lord of the Burning Legion!"
	L.engage_trigger1 = "Banished to the Nether"

	L.incinerate_message = "Incinerate"
	L.incinerate_other = "Incinerate on %s"
	L.incinerate_bar = "Next Incinerate"
	L.incinerate_safe = "%s is safe, yay :)"

	L.legionflame_message = "Flame"
	L.legionflame_other = "Flame on %s!"
	L.legionflame_bar = "Next Flame"

	L.icon = "Place Icon"
	L.icon_desc = "Place a Raid Icon on the player with Legion Flame. (requires promoted or higher)"

	L.infernal_bar = "Volcano spawns"
	L.netherportal_bar = "Portal spawns"
	L.netherpower_bar = "Next Nether Power"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Jaraxxus")
mod.locale = L

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "IncinerateFlesh", 67049, 67050, 67051, 66237)
	self:AddCombatListener("SPELL_AURA_REMOVED", "IncinerateFleshRemoved", 67049, 67050, 67051, 66237)
	self:AddCombatListener("SPELL_AURA_APPLIED", "LegionFlame", 68123, 68124, 68125, 66197)
	self:AddCombatListener("SPELL_AURA_REMOVED", "RemoveLegionFlameIcon", 68126, 68127, 68128, 66199)
	self:AddCombatListener("SPELL_AURA_APPLIED", "NetherPower", 67106, 67107, 67108, 66228)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "NetherPortal", 68404, 68405, 68406, 67898, 67899, 67900, 66269)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "InfernalEruption", 66258, 67901, 67902, 67903)
	self:AddDeathListener("Win", 34780)

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
	self:IfMessage(L["incinerate_safe"]:format(player), "Positive", 17) -- Power Word: Shield icon.
	self:SendMessage("BigWigs_StopBar", self, L["incinerate_other"]:format(player))
end

function mod:LegionFlame(player, spellId)
	self:TargetMessage(L["legionflame_message"], player, "Personal", spellId, "Alert")
	self:Whisper(player, L["legionflame_message"])
	self:Bar(L["legionflame_other"]:format(player), 8, spellId)
	self:Bar(L["legionflame_bar"], 30, spellId)
	self:PrimaryIcon(player, "icon")
end

function mod:RemoveLegionFlameIcon()
	self:PrimaryIcon(false, "icon")
end

function mod:NetherPower(unit, spellId, _, _, spellName, _, _, _, dGuid)
	local target = tonumber(dGuid:sub(-12, -7), 16)
	if target == 34780 then
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
	self:Bar(L["infernal_bar"], 120, spellId)
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
--if you wipe then you never get "engage_trigger1" message again, but always "engage_trigger" message before boss start attack.
--Correct me if i'm wrong
	if msg:find(L["engage_trigger1"]) then
		self:Bar(L["engage"], 11, "INV_Gizmo_01")
	elseif msg:find(L["engage_trigger"]) then
		if self:GetOption(68404) then
			self:Bar(L["netherportal_bar"], 20, 68404)
		end
		if self:GetOption(66258) then
			self:Bar(L["infernal_bar"], 80, 66258)
		end
	end
end

