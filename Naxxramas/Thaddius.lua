--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Thaddius", 533)
if not mod then return end
mod:RegisterEnableMob(15928, 15929, 15930) -- Thaddius, Stalagg, Feugen
mod:SetAllowWin(true)
mod.engageId = 1120

--------------------------------------------------------------------------------
-- Locals
--

local lastCharge = nil
local shiftTime = nil
local throwHandle = nil
local strategy = nil

local ICON_POSITIVE = 135769 -- "Interface\\Icons\\Spell_ChargePositive"
local ICON_NEGATIVE = 135768 -- "Interface\\Icons\\Spell_ChargeNegative"

local SOUND_LEFT, SOUND_RIGHT, SOUND_SWAP, SOUND_STAY
do
	local locale = GetLocale()
	if locale == "zhTW" then locale = "zhCN" end
	local locales = {
		deDE = true,
		koKR = true,
		zhCN = true,
	}
	if not locales[locale] then
		locale = "enUS"
	end

	local sound_path = "Interface\\AddOns\\BigWigs_Naxxramas\\Sounds"
	if select(5, GetAddOnInfo("BigWigs_Naxxramas")) == "MISSING" then -- we lod or checkout?
		sound_path = "Interface\\AddOns\\BigWigs\\Naxxramas\\Sounds"
	end
	SOUND_LEFT = ("%s\\Thaddius-%s-Left.ogg"):format(sound_path, locale)
	SOUND_RIGHT = ("%s\\Thaddius-%s-Right.ogg"):format(sound_path, locale)
	SOUND_SWAP = ("%s\\Thaddius-%s-Swap.ogg"):format(sound_path, locale)
	SOUND_STAY = ("%s\\Thaddius-%s-Stay.ogg"):format(sound_path, locale)
end

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Thaddius"

	L.trigger_phase1_1 = "Stalagg crush you!"
	L.trigger_phase1_2 = "Feed you to master!"
	L.trigger_phase2_1 = "Eat... your... bones..."
	L.trigger_phase2_2 = "Break... you!!"
	L.trigger_phase2_3 = "Kill..."

	L.polarity_trigger = "Now you feel pain..."

	L.polarity_warning = "3 sec to Polarity Shift!"
	L.polarity_changed = "Polarity changed!"
	L.polarity_nochange = "Same polarity!"
	L.polarity_first_positive = "You are POSITIVE!"
	L.polarity_first_negative = "You are NEGATIVE!"

	L.phase1_message = "Phase 1"
	L.phase2_message = "Phase 2 - Berserk in 5 minutes!"

	L.throw = "Throw"
	L.throw_desc = "Warn about tank platform swaps."
	L.throw_icon = "Ability_Druid_Maul"
	L.throw_warning = "Throw in ~5 sec!"

	-- Simplified BigWigs_ThaddiusArrows
	L.polarity_extras = "Additional alerts for Polarity positioning. Only enable one strategy!"

	L.custom_off_charge_RL = "Strategy 1"
	L.custom_off_charge_RL_desc = "|cffff2020Negative (-)|r are LEFT, |cff2020ffPositive (+)|r are RIGHT. Start in front of the boss."
	L.custom_off_charge_LR = "Strategy 2"
	L.custom_off_charge_LR_desc = "|cff2020ffPositive (+)|r are LEFT, |cffff2020Negative (-)|r are RIGHT. Start in front of the boss."

	L.custom_off_charge_text = "Text arrows"
	L.custom_off_charge_text_desc = "Show an additional message with the direction to move when Polarity Shift happens."
	L.custom_off_charge_voice = "Voice alerts"
	L.custom_off_charge_voice_desc = "Play a speech sound when Polarity Shift happens."

	-- Translate these to get locale sound files!
	L.warn_left = "<--- GO LEFT <--- GO LEFT <---"
	L.warn_right = "---> GO RIGHT ---> GO RIGHT --->"
	L.warn_swap = "^^^^ SWITCH SIDES ^^^^ SWITCH SIDES ^^^^"
	L.warn_stay = "==== DON'T MOVE ==== DON'T MOVE ===="
end
L = mod:GetLocale()

local direction = {
	{ -- 1
		[ICON_NEGATIVE] = { sound = SOUND_LEFT, text = L.warn_left },
		[ICON_POSITIVE] = { sound = SOUND_RIGHT, text = L.warn_right },
	},
	{ -- 2
		[ICON_POSITIVE] = { sound = SOUND_LEFT, text = L.warn_left },
		[ICON_NEGATIVE] = { sound = SOUND_RIGHT, text = L.warn_right },
	},
}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{28089, "FLASH"}, -- Polarity Shift
		28134, -- Power Surge
		"throw",
		"stages",
		"berserk",
		"custom_off_charge_RL",
		"custom_off_charge_LR",
		"custom_off_charge_text",
		"custom_off_charge_voice",
	}, {
		["custom_off_charge_RL"] = L.polarity_extras,
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "StalaggPower", 28134)
	self:Log("SPELL_CAST_START", "Shift", 28089)

	self:BossYell("Engage", L.trigger_phase1_1, L.trigger_phase1_2)
	self:BossYell("Phase2", L.trigger_phase2_1, L.trigger_phase2_2, L.trigger_phase2_3)
	self:BossYell("Polarity", L.polarity_trigger)
	self:Death("Win", 15928)
end

function mod:OnEngage()
	lastCharge = nil
	shiftTime = nil

	if self:GetOption("custom_off_charge_RL") then
		strategy = direction[1]
	elseif self:GetOption("custom_off_charge_LR") then
		strategy = direction[2]
	else
		strategy = nil
	end
	self.strategy = strategy

	self:Message("stages", "cyan", L.phase1_message, false)
	self:Throw()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Throw()
	self:Bar("throw", 20, L.throw, L.throw_icon)
	self:DelayedMessage("throw", 15, "orange", L.throw_warning, L.throw_icon)
	throwHandle = self:ScheduleTimer("Throw", 21)
end

function mod:StalaggPower(args)
	self:Message(28134, "red", CL.on:format(args.spellName, args.destName))
	self:Bar(28134, 10)
end

function mod:Phase2()
	self:CancelTimer(throwHandle)
	self:StopBar(L.throw)

	self:Berserk(300, true)
	self:Message("stages", "cyan", L.phase2_message, false)
end

function mod:Polarity()
	self:DelayedMessage(28089, 27, "orange", L.polarity_warning)
	self:Bar(28089, 30)
end

function mod:Shift(args)
	self:Message(28089, "orange", CL.incoming:format(args.spellName))
	shiftTime = GetTime()
	self:RegisterUnitEvent("UNIT_AURA", "player")
end

function mod:UNIT_AURA(event, unit)
	if not shiftTime or (GetTime() - shiftTime) < 3 then return end

	local newCharge = nil
	for i = 1, 40 do
		local name, icon, stack = UnitAura("player", i, "HARMFUL")
		if not name then break end

		if icon == ICON_NEGATIVE or icon == ICON_POSITIVE then
			-- If stack > 1 we need to wait for another UNIT_AURA event.
			-- UnitDebuff returns 0 for debuffs that don't stack.
			if stack > 1 then return end
			newCharge = icon
			-- We keep scanning even though we found one, because
			-- if we have another buff with these icons that has
			-- stack > 1 then we need to break and wait for another
			-- UNIT_AURA event.
		end
	end
	if not newCharge then return end

	local icon = newCharge == ICON_POSITIVE and "Spell_ChargePositive" or "Spell_ChargeNegative"
	if newCharge == lastCharge then
		if strategy then
			if self:GetOption("custom_off_charge_text") then
				self:Message(28089, "yellow", L.warn_stay, false)
			end
			if self:GetOption("custom_off_charge_voice") then
				PlaySoundFile(SOUND_STAY, "Master")
			end
		end
		self:Message(28089, "yellow", L.polarity_nochange, icon)
	else
		local color = newCharge == ICON_POSITIVE and "blue" or "red"
		if not lastCharge then
			-- First charge
			local text = newCharge == ICON_POSITIVE and L.polarity_first_positive or L.polarity_first_negative
			if strategy then
				if self:GetOption("custom_off_charge_text") then
					self:Message(28089, color, strategy[newCharge].text, false) -- SetOption::blue,red::
				end
				if self:GetOption("custom_off_charge_voice") then
					PlaySoundFile(strategy[newCharge].sound, "Master")
				end
			end
			self:Message(28089, color, text, icon) -- SetOption::blue,red::
		else
			if strategy then
				if self:GetOption("custom_off_charge_text") then
					self:Message(28089, color, L.warn_swap, false) -- SetOption::blue,red::
				end
				if self:GetOption("custom_off_charge_voice") then
					PlaySoundFile(SOUND_SWAP, "Master")
				end
			end
			self:Message(28089, color, L.polarity_changed, icon) -- SetOption::blue,red::
		end
		if not strategy or not self:GetOption("custom_off_charge_voice") then
			self:PlaySound(28089, "alert")
		end
		self:Flash(28089, icon)
	end
	lastCharge = newCharge
	shiftTime = nil
	self:UnregisterUnitEvent(event, unit)
end
