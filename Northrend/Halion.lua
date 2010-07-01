--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Halion", "The Ruby Sanctum")
if not mod then return end
mod.otherMenu = "Northrend"
mod:RegisterEnableMob(39863, 40142)
mod.toggleOptions = {{74562, "ICON", "FLASHSHAKE", "WHISPER"}, 75879, {74792, "ICON", "FLASHSHAKE", "WHISPER"}, 74769, 75954, "berserk", "bosskill"}

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
	L.twilight_cutter_bar = "~Laser beams"
	L.twilight_cutter_warning = "Laser beams incoming!"

	L.fire_message = "Fire bomb"
	L.shadow_message = "Shadow bomb"

	L.meteorstrike_bar = "Meteor Strike"

	L.breath_cooldown = "Next Breath"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Fire", 74562)
	self:Log("SPELL_AURA_APPLIED", "Shadow", 74792)
	self:Log("SPELL_CAST_SUCCESS", "MeteorStrike", 75879, 74648)
	-- Dark breath 25m, flame breath 25m, dark breath 10m, flame breath 10m
	self:Log("SPELL_CAST_START", "Breath", 75954, 74526, 74806, 74525)
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

function mod:Fire(player, spellId)
	if UnitIsUnit(player, "player") then
		self:FlashShake(74562)
	end
	self:TargetMessage(74562, L["fire_message"], player, "Personal", spellId)
	self:Whisper(74562, player, L["fire_message"])
	self:PrimaryIcon(74562, player)
end

function mod:Shadow(player, spellId)
	if UnitIsUnit(player, "player") then
		self:FlashShake(74792)
	end
	self:TargetMessage(74792, L["shadow_message"], player, "Personal", spellId)
	self:Whisper(74792, player, L["shadow_message"])
	self:SecondaryIcon(74792, player)
end

function mod:Breath(_, spellId)
	self:Bar(75954, L["breath_cooldown"], 12, spellId)
end

function mod:TwilightCutter()
	self:Bar(74769, L["twilight_cutter_bar"], 33, 74769)
	self:Message(74769, L["twilight_cutter_warning"], "Important", 74769, "Alert")
end

function mod:MeteorStrike(_, spellId, _, _, spellName)
	self:Bar(75879, L["meteorstrike_bar"], 40, spellId)
	self:Message(75879, spellName, "Important", spellId)
end

function mod:PhaseTwo()
	phase = 2
	self:Bar(74769, L["twilight_cutter_bar"], 40, 74769)
end
