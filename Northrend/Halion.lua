--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Halion", "The Ruby Sanctum")
if not mod then return end
mod.otherMenu = "Northrend"

mod:RegisterEnableMob(39863, 40142)
mod.toggleOptions = {{74562, "ICON", "FLASHSHAKE", "WHISPER"}, {74792, "ICON", "FLASHSHAKE"}, 74769, 75954, 75879, "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "Your world teeters on the brink of annihilation. You will ALL bear witness to the coming of a new age of DESTRUCTION!"

	L.phase_two_trigger = "You will find only suffering within the realm of twilight! Enter if you dare!"

	L.twilight_cutter_trigger = "The orbiting spheres pulse with dark energy!"
	L.twilight_cutter_bar = "~Twilight Cutter"
	L.twilight_cutter_warning = "Twilight Cutter soon"

	L.fireconsumption_message_self = "Fiery Combustion on YOU!"
	L.fireconsumption_message = "Fiery Combustion"

	L.shadowconsumption_message_self = "Soul Consumption on YOU!"
	L.shadowconsumption_message = "Soul Consumption"
    
    L.meteorstrike_bar = "Meteor Strike"
    L.meteorstrike_warning = "Meteor Strike"
	
	L.breath_cooldown = "Next Breath"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "FireConsumption", 74562)
	self:Log("SPELL_AURA_APPLIED", "ShadowConsumption", 74792)
    self:Log("SPELL_CAST_SUCCESS", "MeteorStrike", 75879)
	self:Log("SPELL_CAST_START", "Breath", 75954, 74526) --2nd id is fire breath, not sure if we need it
	self:Death("Win", 28860)

	self:Emote("TwilightCutter", L["twilight_cutter_trigger"])
	self:Yell("Engage", L["engage_trigger"])
	self:Yell("PhaseTwo", L["phase_two_trigger"])

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

function mod:OnEngage(diff)
	phase = 1
	self:Berserk(600) -- assumed
    self:Bar(75879, L["meteorstrike_bar"], 30, 75879)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FireConsumption(player, spellId)
	self:PrimaryIcon(74562, player)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(74562, L["fireconsumption_message_self"], "Personal", spellId, "Info")
		self:FlashShake(74562)
	else
		self:Whisper(74562, player, L["fireconsumption_message_self"], true)
	end
	self:TargetMessage(74562, L["fireconsumption_message"], player, "Urgent", spellId)
end

function mod:ShadowConsumption(player, spellId)
	self:SecondaryIcon(74792, player)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(74792, L["shadowconsumption_message_self"], "Personal", spellId, "Info")
		self:FlashShake(74792)
	end
	self:TargetMessage(74792, L["shadowconsumption_message"], player, "Urgent", spellId)
end

function mod:Breath(_, spellId)
	self:Bar(75954, L["breath_cooldown"], 12, spellId)
end

function mod:TwilightCutter()
	self:Bar(74769, L["twilight_cutter_bar"], 33, 74769)
	self:Message(74769, L["twilight_cutter_warning"], "Important", 74769, "Alert")
end

function mod:MeteorStrike()
	self:Bar(75879, L["meteorstrike_bar"], 40, 75879)
	self:Message(75879, L["meteorstrike_warning"], "Important", 75879, "Alert")
end

function mod:PhaseTwo()
	phase = 2
	self:Bar(74769, L["twilight_cutter_bar"], 40, 74769)
end

