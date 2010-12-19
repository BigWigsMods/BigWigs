--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Maloriak", "Blackwing Descent")
if not mod then return end
mod:RegisterEnableMob(41378)
mod.toggleOptions = {"darkSludge", {77699, "ICON"}, {77760, "FLASHSHAKE", "ICON", "WHISPER"}, "proximity", {77786, "FLASHSHAKE", "WHISPER", "ICON"}, 77991, "phase", 77912, 77569, 77896, "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local aberrations = 18
local phaseCounter = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	--heroic
	L.darkSludge = (GetSpellInfo(92987))
	L.darkSludge_desc = ("Warning for when you stand in %s."):format((GetSpellInfo(92987)))

	--normal
	L.final_phase = "Final Phase"

	L.release_aberration_message = "%s adds left!"
	L.release_all = "%s adds released!"

	L.bitingchill_say = "Biting Chill on ME!"

	L.flashfreeze = "~Flash Freeze"

	L.phase = "Phase"
	L.phase_desc = "Warning for Phase changes."
	L.next_phase = "Next Phase"
	
	L.you = "%s on YOU!"

	L.red_phase_trigger = "Mix and stir, apply heat..."
	L.red_phase = "|cFFFF0000Red|r phase"
	L.blue_phase_trigger = "How well does the mortal shell handle extreme temperature change? Must find out! For science!"
	L.blue_phase = "|cFF809FFEBlue|r phase"
	L.green_phase_trigger = "This one's a little unstable, but what's progress without failure?"
	L.green_phase = "|cFF33FF00Green|r phase"
	L.dark_phase = "|cFF660099Dark|r phase"
	L.dark_phase_trigger = "Your mixtures are weak, Maloriak! They need a bit more... kick!"
end
L = mod:GetLocale()

mod.optionHeaders = {
	[77699] = L["blue_phase"],
	[77786] = L["red_phase"],
	[92987] = L["dark_phase"],
	[77991] = L["final_phase"],
	darkSludge = "heroic",
	phase = "general",
}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	--heroic
	--self:Log("SPELL_AURA_APPLIED", "DarkSludge", 92987)

	--normal
	self:Log("SPELL_CAST_START", "ReleaseAberrations", 77569)
	self:Log("SPELL_CAST_SUCCESS", "FlashFreezeTimer", 77699, 92979, 92978)
	self:Log("SPELL_AURA_APPLIED", "FlashFreeze", 77699, 92979, 92978)
	self:Log("SPELL_AURA_APPLIED", "BitingChill", 77760)
	self:Log("SPELL_CAST_SUCCESS", "ConsumingFlames", 77786, 92972, 92971)
	self:Log("SPELL_AURA_APPLIED", "Remedy", 77912, 92965, 92966, 92967)
	self:Log("SPELL_CAST_START", "ReleaseAll", 77991)
	self:Log("SPELL_AURA_APPLIED", "ArcaneStorm", 77896)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Yell("Red", L["red_phase_trigger"])
	self:Yell("Blue", L["blue_phase_trigger"])
	self:Yell("Green", L["green_phase_trigger"])
	self:Yell("Dark", L["dark_phase_trigger"])

	self:Death("Win", 41378)
end

function mod:OnEngage(diff)
	-- XXX Berserk timers not confirmed
	if diff > 2 then
		self:Berserk(600)
	end
	aberrations = 18
	phaseCounter = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function nextPhase(phase)
	if mod:GetInstanceDifficulty() > 2 then
		if phaseCounter == 3 then
			mod:SendMessage("BigWigs_StopBar", mod, L["next_phase"])
			if phase == "dark" then
				mod:Bar("phase", L["green_phase"], 100, "Interface\\Icons\\INV_POTION_162")
			elseif phase == "green" then
				phaseCounter = 0
			else
				mod:Bar("phase", L["green_phase"], 47, "Interface\\Icons\\INV_POTION_162")
			end
		end
		phaseCounter = phaseCounter + 1
	end
end

do
	local last = 0
	function mod:DarkSludge(player, spellId)
		if mod:GetInstanceDifficulty() < 3 then return end
		local time = GetTime()
		if (time - last) > 2 then
			last = time
			if UnitIsUnit(player, "player") then
				self:LocalMessage("darkSludge", L["you"]:format((GetSpellInfo(92987))), "Personal", spellId, "Info")
			end
		end
	end
end

function mod:Red()
	self:Bar("phase", L["next_phase"], 47, "INV_ALCHEMY_ELIXIR_EMPTY")
	self:Message("phase", L["red_phase"], "Positive", "Interface\\Icons\\INV_POTION_24", "Alarm")
	self:CloseProximity()
	nextPhase("red")
end

function mod:Blue()
	self:Bar("phase", L["next_phase"], 47, "INV_ALCHEMY_ELIXIR_EMPTY")
	self:Bar(77699, L["flashfreeze"], 28, spellId) --
	self:Message("phase", L["blue_phase"], "Positive", "Interface\\Icons\\INV_POTION_20", "Alarm")
	self:OpenProximity(5)
	nextPhase("blue")
end

function mod:Green()
	self:Bar("phase", L["next_phase"], 47, "INV_ALCHEMY_ELIXIR_EMPTY")
	self:Message("phase", L["green_phase"], "Positive", "Interface\\Icons\\INV_POTION_162", "Alarm")
	self:CloseProximity()
	nextPhase("green")
end

function mod:Dark()
	self:Bar("phase", L["next_phase"], 100, "INV_ALCHEMY_ELIXIR_EMPTY")
	self:Message("phase", L["dark_phase"], "Positive", "Interface\\Icons\\INV_ELEMENTAL_PRIMAL_SHADOW", "Alarm")
	self:CloseProximity()
	nextPhase("dark")
end

function mod:FlashFreezeTimer(_, spellId, _, _, spellName)
	self:Bar(77699, L["flashfreeze"], 15, spellId)
end

function mod:FlashFreeze(player, spellId, _, _, spellName)
	self:TargetMessage(77699, spellName, player, "Attention", spellId) -- attention cuz on heroic you don't break it instantly
	self:PrimaryIcon(77699, player)
end

function mod:Remedy(unit, spellId, _, _, spellName)
	if UnitIsUnit(unit, "boss1") then
		self:Message(77912, spellName, "Important", spellId, "Alert")
	end
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
	self:TargetMessage(77786, spellName, player, "Urgent", spellId) -- let the other know too so they can shout on the guy if he is slow
	self:Whisper(77786, player, L["you"]:format((GetSpellInfo(77786))))
	self:PrimaryIcon(77786, player)
end

function mod:ReleaseAll(_, spellId)
	self:Message(77991, L["release_all"]:format(aberrations), "Important", spellId, "Alert")
end

function mod:BitingChill(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:Say(77760, L["bitingchill_say"])
		self:FlashShake(77760)
	end
	self:TargetMessage(77760, spellName, player, "Urgent", spellId, "Info")
	self:Whisper(77760, player, spellName)
	self:SecondaryIcon(77760, player)
end

function mod:ArcaneStorm(_, spellId, _, _, spellName)
	self:Message(77896, spellName, "Important", spellId, "Alert")
end
