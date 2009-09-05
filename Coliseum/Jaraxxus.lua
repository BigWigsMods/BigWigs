--------------------------------------------------------------------------------
-- Module Declaration
--

local boss = BB["Lord Jaraxxus"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.zoneName = BZ["Trial of the Crusader"]
mod.enabletrigger = boss
mod.guid = 34780
mod.toggleOptions = {67049, 68123, "icon", 68404, 67106, 66258, "bosskill"}
mod.consoleCmd = "Jaraxxus"

--------------------------------------------------------------------------------
-- Localization
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Jaraxxus", "enUS", true)
if L then
	L.engage = "Engage"
	L.engage_trigger = "You face Jaraxxus, Eredar lord of the Burning Legion!"
	L.engage_trigger1 = "Banished to the Nether"

	L.incinerate_message = "Incinerate"
	L.incinerate_other = "Incinerate on %s"
	L.incinerate_bar = "~Next Incinerate"

	L.legionflame_message = "Flame"
	L.legionflame_other = "Flame on %s!"
	L.legionflame_bar = "~Next Flame"

	L.icon = "Place Icon"
	L.icon_desc = "Place a Raid Icon on the player with Legion Flame. (requires promoted or higher)"

	L.netherportal_bar = "~Next Portal"
	L.netherpower_bar = "~Next Nether Power"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Jaraxxus")

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
	self:PrimaryIcon(player, "icon")
end

function mod:RemoveLegionFlameIcon()
	self:PrimaryIcon(false, "icon")
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

