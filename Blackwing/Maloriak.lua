--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Maloriak", "Blackwing Descent")
if not mod then return end
mod:RegisterEnableMob(41378)

--------------------------------------------------------------------------------
-- Locals
--

local aberrations = 18
local phaseCounter = 0
local warnedAlready = nil
local maloriak = BigWigs:Translate("Maloriak")
local chillTargets = mod:NewTargetList()

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

	L.release_aberration_message = "%d adds left!"
	L.release_all = "%d adds released!"

	L.bitingchill_say = "Biting Chill on ME!"

	L.flashfreeze = "~Flash Freeze"
	L.next_blast = "~Scorching Blast"

	L.phase = "Phase"
	L.phase_desc = "Warning for phase changes."
	L.next_phase = "Next phase"
	L.green_phase_bar = "Green phase"

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

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {{77699, "ICON"}, {77760, "FLASHSHAKE", "WHISPER", "SAY"}, "proximity", {77786, "FLASHSHAKE", "WHISPER", "ICON"}, 92968, 77991, "sludge", "phase", 77912, 77569, 77896, "berserk", "bosskill"}, {
		[77699] = L["blue_phase"],
		[77786] = L["red_phase"],
		[77991] = L["final_phase"],
		sludge = "heroic",
		phase = "general",
	}
end

function mod:OnBossEnable()
	--heroic
	self:Log("SPELL_AURA_APPLIED", "DarkSludge", 92987, 92988)

	--normal
	self:Log("SPELL_CAST_START", "ReleaseAberrations", 77569)
	self:Log("SPELL_INTERRUPT", "Interrupt", "*")

	self:Log("SPELL_CAST_SUCCESS", "FlashFreezeTimer", 77699, 92979, 92978, 92980)
	self:Log("SPELL_AURA_APPLIED", "FlashFreeze", 77699, 92979, 92978, 92980)
	self:Log("SPELL_AURA_APPLIED", "BitingChill", 77760)
	self:Log("SPELL_AURA_APPLIED", "ConsumingFlames", 77786, 92972, 92971, 92973)
	self:Log("SPELL_CAST_SUCCESS", "ScorchingBlast", 77679, 92968, 92969, 92970)
	self:Log("SPELL_AURA_APPLIED", "Remedy", 77912, 92965, 92966, 92967)
	self:Log("SPELL_CAST_START", "ReleaseAll", 77991)
	self:Log("SPELL_AURA_APPLIED", "ArcaneStorm", 77896)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- We keep the emotes in case the group uses Curse of Tongues, in which
	-- case the yells become Demonic.
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	-- We keep the yell triggers around because sometimes he does them far ahead
	-- of the emote.
	self:Yell("Red", L["red_phase_trigger"])
	self:Yell("Blue", L["blue_phase_trigger"])
	self:Yell("Green", L["green_phase_trigger"])
	self:Yell("Dark", L["dark_phase_trigger"])

	self:Death("Win", 41378)
end

function mod:OnEngage(diff)
	self:Berserk(diff > 2 and 840 or 360) -- XXX Berserk timers not confirmed
	aberrations = 18
	phaseCounter = 0
	warnedAlready = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function nextPhase()
	phaseCounter = phaseCounter + 1
	local diff = mod:GetInstanceDifficulty()
	if (diff < 3 and phaseCounter == 2) or (diff > 2 and phaseCounter == 3) then
		mod:SendMessage("BigWigs_StopBar", mod, L["next_phase"])
		mod:Bar("phase", L["green_phase_bar"], 47, "INV_POTION_162")
		phaseCounter = 0
	end
end

do
	local last = 0
	function mod:DarkSludge(player, spellId)
		if not UnitIsUnit(player, "player") then return end
		local time = GetTime()
		if (time - last) > 2 then
			last = time
			self:LocalMessage("sludge", L["sludge_message"], "Personal", spellId, "Info")
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	local potion = msg:match("INV_(.-).BLP")
	if not potion then return end
	if warnedAlready then
		warnedAlready = nil
		return
	end
	if potion == "POTION_20" then
		self:Blue()
		self:SendMessage("BigWigs_StopBar", self, L["next_blast"])
	elseif potion == "POTION_24" then
		self:Red()
		self:Bar(92968, L["next_blast"], 25, 92968)
	elseif potion == "POTION_162" then
		self:Green()
		self:SendMessage("BigWigs_StopBar", self, L["next_blast"])
	elseif potion == "ELEMENTAL_PRIMAL_SHADOW" then
		self:Dark()
	end
	warnedAlready = nil
end

function mod:Red()
	warnedAlready = true
	self:Bar(92968, L["next_blast"], 25, 92968)
	self:Bar("phase", L["next_phase"], 47, "INV_ALCHEMY_ELIXIR_EMPTY")
	self:Message("phase", L["red_phase"], "Positive", "Interface\\Icons\\INV_POTION_24", "Alarm")
	self:CloseProximity()
	nextPhase()
end

function mod:Blue()
	warnedAlready = true
	self:SendMessage("BigWigs_StopBar", self, L["next_blast"])
	self:Bar("phase", L["next_phase"], 47, "INV_ALCHEMY_ELIXIR_EMPTY")
	self:Bar(77699, L["flashfreeze"], 28, 77699)
	self:Message("phase", L["blue_phase"], "Positive", "Interface\\Icons\\INV_POTION_20", "Alarm")
	self:OpenProximity(5)
	nextPhase()
end

function mod:Green()
	warnedAlready = true
	self:SendMessage("BigWigs_StopBar", self, L["next_blast"])
	self:Bar("phase", L["next_phase"], 47, "INV_ALCHEMY_ELIXIR_EMPTY")
	self:Message("phase", L["green_phase"], "Positive", "Interface\\Icons\\INV_POTION_162", "Alarm")
	self:CloseProximity()
	nextPhase()
end

function mod:Dark()
	warnedAlready = true
	self:Bar("phase", L["next_phase"], 100, "INV_ALCHEMY_ELIXIR_EMPTY")
	self:Message("phase", L["dark_phase"], "Positive", "Interface\\Icons\\INV_ELEMENTAL_PRIMAL_SHADOW", "Alarm")
	self:CloseProximity()
	nextPhase()
end

function mod:FlashFreezeTimer(_, spellId, _, _, spellName)
	self:Bar(77699, L["flashfreeze"], 15, spellId)
end

function mod:FlashFreeze(player, spellId, _, _, spellName)
	self:TargetMessage(77699, spellName, player, "Attention", spellId) -- attention cuz on heroic you don't break it instantly
	self:PrimaryIcon(77699, player)
end

function mod:Remedy(unit, spellId, _, _, spellName)
	if unit == maloriak then
		self:Message(77912, spellName, "Important", spellId, "Alert")
	end
end

do
	local handle = nil
	local function release()
		aberrations = aberrations - 3
		mod:Message(77569, L["release_aberration_message"]:format(aberrations), "Urgent", 688)
	end
	function mod:ReleaseAberrations()
		-- He keeps casting it even if there are no adds left to release...
		if aberrations <= 0 then return end
		handle = self:ScheduleTimer(release, 1.5)
	end
	function mod:Interrupt(_, _, _, secSpellId, _, _, _, _, _, dGUID)
		if secSpellId ~= 77569 then return end
		local guid = tonumber(dGUID:sub(7, 10), 16)
		if guid ~= 41378 then return end
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
	self:Message(92968, spellName, "Attention", spellId)
	self:Bar(92968, L["next_blast"], 10, 92968)
end

function mod:ReleaseAll(_, spellId)
	self:Message(77991, L["release_all"]:format(aberrations + 2), "Important", spellId, "Alert")
end

do
	local scheduled = nil
	local function chillWarn(spellName)
		mod:TargetMessage(77760, spellName, chillTargets, "Urgent", 77760, "Info")
		scheduled = nil
	end
	function mod:BitingChill(player, spellId, _, _, spellName)
		chillTargets[#chillTargets + 1] = player
		if UnitIsUnit(player, "player") then
			self:Say(77760, L["bitingchill_say"])
			self:FlashShake(77760)
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(chillWarn, 0.3, spellName)
		end
	end
end

function mod:ArcaneStorm(_, spellId, _, _, spellName)
	self:Message(77896, spellName, "Important", spellId, "Alert")
end

