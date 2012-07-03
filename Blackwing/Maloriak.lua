--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Maloriak", 754, 173)
if not mod then return end
mod:RegisterEnableMob(41378)

--------------------------------------------------------------------------------
-- Locals
--

local aberrations = 18
local phaseCounter = 0
local chillTargets = mod:NewTargetList()
local isChilled, currentPhase = nil, nil
local scorchingBlast = "~"..GetSpellInfo(77679)
local flashFreeze = "~"..GetSpellInfo(77699)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	--heroic
	L.sludge = "Dark Sludge"
	L.sludge_desc = "Warning for when you stand in Dark Sludge."
	L.sludge_message = "Sludge on YOU!"

	--normal
	L.final_phase = "Final phase"
	L.final_phase_soon = "Final phase soon!"

	L.release_aberration_message = "%d adds left!"
	L.release_all = "%d adds released!"

	L.phase = "Phase"
	L.phase_desc = "Warning for phase changes."
	L.next_phase = "Next phase"
	L.green_phase_bar = "Green phase"

	L.red_phase_trigger = "Mix and stir, apply heat..."
	L.red_phase_emote_trigger = "red"
	L.red_phase = "|cFFFF0000Red|r phase"
	L.blue_phase_trigger = "How well does the mortal shell handle extreme temperature change? Must find out! For science!"
	L.blue_phase_emote_trigger = "blue"
	L.blue_phase = "|cFF809FFEBlue|r phase"
	L.green_phase_trigger = "This one's a little unstable, but what's progress without failure?"
	L.green_phase_emote_trigger = "green"
	L.green_phase = "|cFF33FF00Green|r phase"
	L.dark_phase_trigger = "Your mixtures are weak, Maloriak! They need a bit more... kick!"
	L.dark_phase_emote_trigger = "dark"
	L.dark_phase = "|cFF660099Dark|r phase"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{77699, "ICON"}, {77760, "FLASHSHAKE", "WHISPER", "SAY"}, "proximity",
		{77786, "FLASHSHAKE", "WHISPER", "ICON"}, 77679,
		77991, 78194,
		{"sludge", "FLASHSHAKE"},
		"phase", 77912, 77569, 77896, "berserk", "bosskill"
	}, {
		[77699] = L["blue_phase"],
		[77786] = L["red_phase"],
		[77991] = L["final_phase"],
		sludge = "heroic",
		phase = "general"
	}
end

function mod:OnBossEnable()
	--heroic
	self:Log("SPELL_AURA_APPLIED", "DarkSludge", 92987, 92988)
	self:Log("SPELL_PERIODIC_DAMAGE", "DarkSludge", 92987, 92988)

	--normal
	self:Log("SPELL_CAST_START", "ReleaseAberrations", 77569)
	self:Log("SPELL_INTERRUPT", "Interrupt", "*")

	self:Log("SPELL_CAST_SUCCESS", "FlashFreezeTimer", 77699, 92979, 92978, 92980)
	self:Log("SPELL_AURA_APPLIED", "FlashFreeze", 77699, 92979, 92978, 92980)
	self:Log("SPELL_AURA_REMOVED", "FlashFreezeRemoved", 77699, 92979, 92978, 92980)
	self:Log("SPELL_AURA_APPLIED", "BitingChill", 77760)
	self:Log("SPELL_AURA_REMOVED", "BitingChillRemoved", 77760)
	self:Log("SPELL_AURA_APPLIED", "ConsumingFlames", 77786, 92972, 92971, 92973)
	self:Log("SPELL_CAST_SUCCESS", "ScorchingBlast", 77679, 92968, 92969, 92970)
	self:Log("SPELL_AURA_APPLIED", "Remedy", 77912, 92965, 92966, 92967)
	self:Log("SPELL_CAST_START", "ReleaseAll", 77991)
	self:Log("SPELL_CAST_START", "ArcaneStorm", 77896)
	self:Log("SPELL_CAST_START", "Jets", 78194)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- We keep the emotes in case the group uses Curse of Tongues, in which
	-- case the yells become Demonic.
	self:Emote("Red", L["red_phase_emote_trigger"])
	self:Emote("Blue", L["blue_phase_emote_trigger"])
	self:Emote("Green", L["green_phase_emote_trigger"])
	self:Emote("Dark", L["dark_phase_emote_trigger"])

	-- We keep the yell triggers around because sometimes he does them far ahead
	-- of the emote.
	self:Yell("Red", L["red_phase_trigger"])
	self:Yell("Blue", L["blue_phase_trigger"])
	self:Yell("Green", L["green_phase_trigger"])
	self:Yell("Dark", L["dark_phase_trigger"])

	self:Death("Win", 41378)
end

function mod:OnEngage(diff)
	if diff > 2 then
		self:Bar("phase", L["next_phase"], 16, "INV_ELEMENTAL_PRIMAL_SHADOW")
		self:Berserk(720)
	else
		self:Berserk(420)
	end
	aberrations = 18
	phaseCounter = 0
	isChilled, currentPhase = nil, nil
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local last = 0
	function mod:DarkSludge(player, spellId)
		if not UnitIsUnit(player, "player") then return end
		local time = GetTime()
		if (time - last) > 2 then
			last = time
			self:LocalMessage("sludge", L["sludge_message"], "Personal", spellId, "Info")
			self:FlashShake("sludge")
		end
	end
end

local function nextPhase(timeToNext)
	phaseCounter = phaseCounter + 1
	local diff = mod:Difficulty()
	if (diff < 3 and phaseCounter == 2) or (diff > 2 and phaseCounter == 3) then
		mod:Bar("phase", L["green_phase_bar"], timeToNext, "INV_POTION_162")
	else
		mod:Bar("phase", L["next_phase"], timeToNext, "INV_ALCHEMY_ELIXIR_EMPTY")
	end
end

function mod:Red()
	if currentPhase == "red" then return end
	currentPhase = "red"
	self:SendMessage("BigWigs_StopBar", self, flashFreeze)
	self:Bar(77679, scorchingBlast, 25, 77679)
	self:Message("phase", L["red_phase"], "Positive", "Interface\\Icons\\INV_POTION_24", "Long")
	if not isChilled then
		self:CloseProximity()
	end
	nextPhase(47)
end

function mod:Blue()
	if currentPhase == "blue" then return end
	currentPhase = "blue"
	self:SendMessage("BigWigs_StopBar", self, scorchingBlast)
	self:Bar(77699, flashFreeze, 28, 77699)
	self:Message("phase", L["blue_phase"], "Positive", "Interface\\Icons\\INV_POTION_20", "Long")
	self:OpenProximity(5)
	nextPhase(47)
end

function mod:Green()
	if currentPhase == "green" then return end
	currentPhase = "green"
	self:SendMessage("BigWigs_StopBar", self, scorchingBlast)
	self:SendMessage("BigWigs_StopBar", self, flashFreeze)
	self:Message("phase", L["green_phase"], "Positive", "Interface\\Icons\\INV_POTION_162", "Long")
	if not isChilled then
		self:CloseProximity()
	end
	nextPhase(47)
	-- Make sure to reset after the nextPhase() call, which increments it
	phaseCounter = 0
end

function mod:Dark()
	if currentPhase == "dark" then return end
	currentPhase = "dark"
	self:Message("phase", L["dark_phase"], "Positive", "Interface\\Icons\\INV_ELEMENTAL_PRIMAL_SHADOW", "Long")
	if not isChilled then
		self:CloseProximity()
	end
	nextPhase(100)
end

function mod:FlashFreezeTimer(_, spellId, _, _, spellName)
	self:Bar(77699, flashFreeze, 15, spellId)
end

function mod:FlashFreeze(player, spellId, _, _, spellName)
	self:TargetMessage(77699, spellName, player, "Attention", spellId, "Info")
	self:PrimaryIcon(77699, player)
end

function mod:FlashFreezeRemoved()
	self:PrimaryIcon(77699)
end

function mod:Remedy(unit, spellId, _, _, spellName, _, _, _, _, dGUID)
	if self:GetCID(dGUID) == 41378 then
		self:Message(77912, spellName, "Important", spellId, "Alarm")
	end
end

do
	local handle = nil
	local function release()
		aberrations = aberrations - 3
		mod:Message(77569, L["release_aberration_message"]:format(aberrations), "Important", 688, "Alert") --Summon Imp Icon
	end
	function mod:ReleaseAberrations()
		-- He keeps casting it even if there are no adds left to release...
		if aberrations < 1 then return end
		--cast is 1.95sec with Tongues, plus some latency time
		handle = self:ScheduleTimer(release, 2.1)
	end
	function mod:Interrupt(_, _, _, secSpellId)
		if secSpellId ~= 77569 then return end
		-- Someone interrupted release aberrations!
		self:CancelTimer(handle, true)
		handle = nil
	end
end

function mod:ConsumingFlames(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:FlashShake(77786)
	end
	self:TargetMessage(77786, spellName, player, "Personal", spellId, "Info")
	self:Whisper(77786, player, spellName)
	self:PrimaryIcon(77786, player)
end

function mod:ScorchingBlast(_, spellId, _, _, spellName)
	self:Message(77679, spellName, "Attention", spellId)
	self:Bar(77679, scorchingBlast, 10, 77679)
end

function mod:ReleaseAll(_, spellId)
	self:Message(77991, L["release_all"]:format(aberrations + 2), "Important", spellId, "Alert")
	self:Bar(78194, "~"..GetSpellInfo(78194), 12.5, 78194)
end

do
	local scheduled = nil
	local function chillWarn(spellName)
		mod:TargetMessage(77760, spellName, chillTargets, "Attention", 77760, "Info")
		scheduled = nil
	end
	function mod:BitingChill(player, spellId, _, _, spellName)
		chillTargets[#chillTargets + 1] = player
		if UnitIsUnit(player, "player") then
			self:Say(77760, CL["say"]:format((GetSpellInfo(77760))))
			self:FlashShake(77760)
			isChilled = true
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(chillWarn, 0.3, spellName)
		end
	end
end

function mod:BitingChillRemoved(player)
	if UnitIsUnit(player, "player") then
		isChilled = nil
		if currentPhase ~= "blue" then
			self:CloseProximity()
		end
	end
end

function mod:ArcaneStorm(_, spellId, _, _, spellName)
	self:Message(77896, spellName, "Urgent", spellId)
end

function mod:Jets(_, spellId, _, _, spellName)
	self:Bar(78194, spellName, 10, spellId)
end

function mod:UNIT_HEALTH_FREQUENT(_, unit)
	if unit ~= "boss1" then return end
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < 29 then --Switches at 25%
		self:Message("phase", L["final_phase_soon"], "Positive", 77991, "Info")
		self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
	end
end

