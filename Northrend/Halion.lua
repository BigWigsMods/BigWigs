--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Halion", "The Ruby Sanctum")
if not mod then return end
mod.otherMenu = "Northrend"

mod:RegisterEnableMob(39863, 40141)
mod.toggleOptions = {74769, 75954, {74562, "ICON", "FLASHSHAKE"}, {74792, "ICON", "FLASHSHAKE"}, "berserk", "bosskill"}

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
	
	L.fireconsumption_message_self = "Fire Consuption on YOU!"
	L.fireconsumption_message "Fire Consuption"
	
	L.shadowconsumption_message_self = "Shadow Consuption on YOU!"
	L.shadowconsumption_message = "Shadow Consuption"
  
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "FireConsumption", 74562)
	self:Log("SPELL_AURA_APPLIED", "ShadowConsumption", 74792)
	self:Log("SPELL_CAST_START", "Breath", 75954, 74526) --2nd id is fire breath, not sure if we need it
	self:Death("Win", 28860)

	self:Emote("TwilightCutter", L["twilight_cutter_trigger"])
	self:Yell("PhaseTwo", L["phase_two_trigger"])
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

function mod:OnEngage(diff)
	phase = 1
	self:Berserk(600) -- assumed
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FireConsumption(player, spellId)
	self:PrimaryIcon(74562, player)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(74562, L["fireconsumption_message_self"], "Personal", spellId, "Info")
		self:FlashShake(74562)
	end
	self:TargetMessage(74562, L["fireconsumption_message"], player, "Urgent", 74562)
end

function mod:ShadowConsumption(player, spellId)
	self:SecondaryIcon(74792, player)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(74792, L["shadowconsumption_message_self"], "Personal", spellId, "Info")
		self:FlashShake(74792)
	end   
	self:TargetMessage(74792, L["shadowconsumption_message"], player, "Urgent", 74792)
end

function mod:Breath(_, spellId)
	self:Bar(75954, L["breath_cooldown"], 12, spellId)
end

function mod:TwilightCutter()
	self:Bar(74769, L["twilight_cutter_bar"], 33, 74769)
	self:Message(74769, L["twilight_cutter_warning"], "Important", 57491, "Alert")
end

function mod:PhaseTwo()
	phase = 2
	self:Bar(74769, L["twilight_cutter_bar"], 30, 74769)
end
