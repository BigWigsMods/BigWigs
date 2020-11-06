--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Thaddius", 533)
if not mod then return end
mod:RegisterEnableMob(15928, 15929, 15930) -- Thaddius, Stalagg, Feugen
mod:SetAllowWin(true)
mod.engageId = 1120
mod.toggleOptions = {{28089, "FLASHSHAKE"}, 28134, "throw", "phase", "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local deaths = 0
local stage1warn = nil
local lastCharge = nil
local shiftTime = nil
local throwHandle = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Thaddius"

	L.phase = "Phase"
	L.phase_desc = "Warn for Phase transitions"

	L.throw = "Throw"
	L.throw_desc = "Warn about tank platform swaps."

	L.trigger_phase1_1 = "Stalagg crush you!"
	L.trigger_phase1_2 = "Feed you to master!"
	L.trigger_phase2_1 = "Eat... your... bones..."
	L.trigger_phase2_2 = "Break... you!!"
	L.trigger_phase2_3 = "Kill..."

	L.polarity_trigger = "Now you feel pain..."
	L.polarity_message = "Polarity Shift incoming!"
	L.polarity_warning = "3 sec to Polarity Shift!"
	L.polarity_bar = "Polarity Shift"
	L.polarity_changed = "Polarity changed!"
	L.polarity_nochange = "Same polarity!"

	L.polarity_first_positive = "You're POSITIVE!"
	L.polarity_first_negative = "You're NEGATIVE!"

	L.phase1_message = "Phase 1"
	L.phase2_message = "Phase 2, Berserk in 6 minutes!"

	L.surge_message = "Power Surge on Stalagg!"

	L.throw_bar = "Throw"
	L.throw_warning = "Throw in ~5 sec!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "StalaggPower", 28134, 54529)
	self:Log("SPELL_CAST_START", "Shift", 28089)
	self:Death("Win", 15928)

	deaths = 0
	stage1warn = nil
	lastCharge = nil
	shiftTime = nil

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:StalaggPower(_, spellId, _, _, spellName)
	self:Message(28134, L["surge_message"], "Important", spellId)
	self:Bar(28134, spellName, 10, spellId)
end

function mod:UNIT_AURA(event, unit)
	if unit and unit ~= "player" then return end
	if not shiftTime or (GetTime() - shiftTime) < 3 then return end

	local newCharge = nil
	for i = 1, 40 do
		local name, _, icon, stack = UnitDebuff("player", i)
		if not name then break end
		-- If stack > 1 we need to wait for another UNIT_AURA event.
		-- UnitDebuff returns 0 for debuffs that don't stack.
		if icon == "Interface\\Icons\\Spell_ChargeNegative" or
		   icon == "Interface\\Icons\\Spell_ChargePositive" then
			if stack > 1 then return end
			newCharge = icon
			-- We keep scanning even though we found one, because
			-- if we have another buff with these icons that has
			-- stack > 1 then we need to break and wait for another
			-- UNIT_AURA event.
		end
	end
	if newCharge then
		if not lastCharge then
			self:LocalMessage(28089, newCharge == "Interface\\Icons\\Spell_ChargePositive" and
				L["polarity_first_positive"] or L["polarity_first_negative"],
				"Personal", newCharge, "Alert")
			self:FlashShake(28089)
		else
			if newCharge == lastCharge then
				self:LocalMessage(28089, L["polarity_nochange"], "Positive", newCharge)
			else
				self:LocalMessage(28089, L["polarity_changed"], "Personal", newCharge, "Alert")
				self:FlashShake(28089)
			end
		end
		lastCharge = newCharge
		shiftTime = nil
		self:UnregisterEvent("UNIT_AURA")
	end
end

function mod:Shift()
	shiftTime = GetTime()
	self:RegisterEvent("UNIT_AURA")
	self:Message(28089, L["polarity_message"], "Important", 28089)
end

local function throw()
	mod:Bar("throw", L["throw_bar"], 20, "Ability_Druid_Maul")
	mod:DelayedMessage("throw", 15, L["throw_warning"], "Urgent")
	throwHandle = mod:ScheduleTimer(throw, 21)
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if msg:find(L["polarity_trigger"]) then
		self:DelayedMessage(28089, 25, L["polarity_warning"], "Important")
		self:Bar(28089, L["polarity_bar"], 28, "Spell_Nature_Lightning")
	elseif msg == L["trigger_phase1_1"] or msg == L["trigger_phase1_2"] then
		if not stage1warn then
			self:Message("phase", L["phase1_message"], "Important")
		end
		deaths = 0
		stage1warn = true
		throw()
		self:Engage()
	elseif msg:find(L["trigger_phase2_1"]) or msg:find(L["trigger_phase2_2"]) or msg:find(L["trigger_phase2_3"]) then
		self:CancelTimer(throwHandle, true)
		self:SendMessage("BigWigs_StopBar", self, L["throw_bar"])
		self:Message("phase", L["phase2_message"], "Important")
		self:Berserk(360, true)
	end
end

