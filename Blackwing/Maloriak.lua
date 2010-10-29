if not GetSpellInfo(90000) then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Maloriak", "Blackwing Descent")
if not mod then return end
mod:RegisterEnableMob(41378)
mod.toggleOptions = {{77699, "ICON"}, {77760, "FLASHSHAKE", "ICON", "WHISPER"}, "proximity", {77786, "FLASHSHAKE", "WHISPER"}, 77991, "phase", 77912, 77569, "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

--local aberrations = 18

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.final_phase = "Final Phase"

	L.release_aberration_message = "%s Aberration left"
	L.release_all = "%s Aberration Released"

	L.bitingchill_say = "Biting Chill on ME!"

	L.flashfreeze = "~Flash Freeze"
	L.consuming_flames = "Consuming Flames on YOU!"

	L.phase_desc = "Warning for Phase changes"
	L.next_phase = "Next Phase"

	L.phase = "Phase"
	L.phase_desc = "Warning for Phase changes"

	L.red_phase_trigger = "Mix and stir, apply heat..."
	L.red_phase = "|cFFFF0000Red|r phase"
	L.blue_phase_trigger = "How well does the mortal shell handle extreme temperature change? Must find out! For science!"
	L.blue_phase = "|cFF809FFEBlue|r phase"
	L.green_phase_trigger = "This one's a little unstable, but what's progress without failure?"
	L.green_phase = "|cFF33FF00Green|r phase"
end
L = mod:GetLocale()

mod.optionHeaders = {
	[77699] = L["blue_phase"],
	[77786] = L["red_phase"],
	--[77912] = L["green_phase"],
	[77991] = L["final_phase"],
	phase = "general",
}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "ReleaseAberrations", 77569)

	self:Log("SPELL_CAST_SUCCESS", "FlashFreezeTimer", 77699)
	self:Log("SPELL_AURA_APPLIED", "FlashFreeze", 77699)

	self:Log("SPELL_AURA_APPLIED", "BitingChill", 77760)

	self:Log("SPELL_CAST_SUCCESS", "ConsumingFlames", 77786)

	self:Log("SPELL_AURA_APPLIED", "Remedy", 77912)

	self:Log("SPELL_CAST_START", "ReleaseAll", 77991)

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

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

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg == L["red_phase_trigger"] then
		self:Bar("phase", L["next_phase"], 47, "INV_ALCHEMY_ELIXIR_EMPTY") -- just use an empty vial for bars, might not be the best idea
		self:Message("phase", L["red_phase_trigger"], "Attention", "Interface\\Icons\\INV_POTION_24", "Alarm")
	elseif msg == L["blue_phase_trigger"] then
		self:Bar("phase", L["next_phase"], 47, "INV_ALCHEMY_ELIXIR_EMPTY")
		self:Message("phase", L["blue_phase_trigger"], "Attention", "Interface\\Icons\\INV_POTION_20", "Alarm")
	elseif msg == L["green_phase_trigger"] then
		self:Bar("phase", L["next_phase"], 47, "INV_ALCHEMY_ELIXIR_EMPTY")
		self:Message("phase", L["green_phase_trigger"], "Attention", "Interface\\Icons\\INV_POTION_162", "Alarm")
	end
end

function mod:FlashFreezeTimer(_, spellId, _, _, spellName)
	self:Bar(77699, L["flashfreeze"], 15, spellId)
end

function mod:FlashFreeze(player)
	self:PrimaryIcon(77699, player)
end

function mod:Remedy(_, spellId, _, _, spellName)
	self:Message(77912, spellName, "Important", spellId, "Alert")
end

function mod:ReleaseAberrations(_, spellId)
	aberrations = aberrations - 3
	self:Message(77569, L["release_aberration_message"]:format(aberrations), "Urgent", spellId)
end

function mod:ConsumingFlames(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:FlashShake(77786)
		self:LocalMessage(77786, spellName, "Personal", spellId, "Info")
	end
	self:Whisper(77786, player, L["consuming_flames"])
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
	self:TargetMessage(77760, spellName, player, "Urgent", spellId, "Info")
	self:Whisper(77760, player, spellName)
	self:SecondaryIcon(77760, player)
end

