if GetBuildInfo() ~= "4.0.3" then return end -- lets not braek live stuff
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Maloriak", "Blackwing Descent")
if not mod then return end
mod.toggleOptions = {{77699, "ICON"}, {77760, "FLASHSHAKE", "ICON"}, "proximity", {77786, "FLASHSHAKE"}, 77912, 77991, "bosskill", "berserk", 77569}

--------------------------------------------------------------------------------
-- Locals
--

local aberrations = 18

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.blue_phase = "Blue Phase"
	L.red_phase = "Red Phase"
	L.green_phase = "Green Phase"
	L.final_phase = "Final Phase"
	
	L.release_aberration_message = "%s Aberration left"
	L.release_all = "%s Aberration Released"
	
	L.bitingchill_say = "Biting Chill on ME!"
	
	L.flashfreeze = "~Flash Freeze"
	L.consuming_flames = "Consuming Flames on YOU!"
	
	L.phase_change_emote = "%s throws a %s vial into the cauldron!" -- need transcriptor log to confirm this so we can make phase specific warning
end
L = mod:GetLocale()

mod.optionHeaders = {
	[77699] = L["blue_phase"],
	[77786] = L["red_phase"],
	[77912] = L["green_phase"],
	[77991] = L["final_phase"],
	bosskill = "general",
}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:RegisterEnableMob(41378)
end

function mod:OnBossEnable()
	BigWigs:Print("This is a alpha module, timers ARE inaccurate. Please provide us with Transcriptor logs! You can contact us at #bigwigs@freenode.net or with the wowace ticket tracker.")

	self:Log("SPELL_CAST_START", "ReleaseAberrations", 77569)

	self:Log("SPELL_CAST_SUCCESS", "FlashFreezeTimer", 77699)
	self:Log("SPELL_AURA_APPLIED", "FlashFreeze", 77699)
	
	self:Log("SPELL_AURA_APPLIED", "BitingChill", 77760)
	
	self:Log("SPELL_CAST_SUCCESS", "ConsumingFlames", 77786)
	
	self:Log("SPELL_AURA_APPLIED", "Remedy", 77912)
	
	self:Log("SPELL_CAST_START", "ReleaseAll", 77991)
	
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 41378)
end


function mod:OnEngage(diff)
	aberrations = 18
	self:Berserk(360)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FlashFreezeTimer(_, spellId, _, _, spellName)
	self:Bar(77699, L["flashfreeze"], 15, spellId)
end

function mod:FlashFreeze(player)
	self:PrimaryIcon(77699, player)
end

function mod:Remedy(_, spellId, _, _, spellName)
	self:Message(77912, spellName, "Important", spellId, "Alert")
end

function mod:ReleaseAberrations(_,spellId)
	aberrations = aberrations - 3 
	self:Message(77569, L["release_aberration_message"]:format(aberrations), "Important", spellId, "Alert")
end

function mod:ConsumingFlames(player, spellId)
	if UnitIsUnit(player, "player") then
		self:FlashShake(77786)
	end
	self:TargetMessage(77786, L["consuming_flames"], player, "Personal", spellId, "Info")
end

function mod:ReleaseAll(_, spellId)	
	self:Message(77991, L["release_all"]:format(aberrations), "Important", spellId, "Alert")
end

function mod:BitingChill(player, spellId, _, _, spellName)	
	if UnitIsUnit(player, "player") then
		self:Say(77760, L["bitingchill_say"])
		self:FlashShake(77760)
		self:OpenProximity(3)
		self:ScheduleTimer(self.CloseProximity, 10, self)
	end
	self:TargetMessage(77760, spellName, player, "Personal", spellId, "Info")
	self:Whisper(77760, player, spellName)
	self:SecondaryIcon(77760, player)
end