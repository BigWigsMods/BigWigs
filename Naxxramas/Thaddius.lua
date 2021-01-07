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

local addsdead = 0
local lastCharge = nil
local shiftTime = nil
local throwHandle = nil
local strategy = {}

local ADDON_PATH = "Interface\\AddOns\\BigWigs_Naxxramas"
if select(5, GetAddOnInfo("BigWigs_Naxxramas")) == "MISSING" then -- we lod or checkout?
	ADDON_PATH = "Interface\\AddOns\\BigWigs\\Naxxramas"
end

local ICON_POSITIVE = 135769 -- "Interface\\Icons\\Spell_ChargePositive"
local ICON_NEGATIVE = 135768 -- "Interface\\Icons\\Spell_ChargeNegative"

local DIRECTION_SOUND = {}
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

	DIRECTION_SOUND.left = ("%s\\Extras\\Thaddius-%s-Left.ogg"):format(ADDON_PATH, locale)
	DIRECTION_SOUND.right = ("%s\\Extras\\Thaddius-%s-Right.ogg"):format(ADDON_PATH, locale)
	DIRECTION_SOUND.swap = ("%s\\Extras\\Thaddius-%s-Swap.ogg"):format(ADDON_PATH, locale)
	DIRECTION_SOUND.stay = ("%s\\Extras\\Thaddius-%s-Stay.ogg"):format(ADDON_PATH, locale)
end

local DIRECTION_ARROW = {
	left = function()
		local frame = mod.arrow
		frame.texture:SetRotation(0)
		frame.texture:SetTexCoord(0, 1, 0, 1)
		frame:SetPoint("CENTER", -250, 100)
		frame:Show()
		mod:SimpleTimer(function() mod.arrow:Hide() end, 4)
	end,
	right = function()
		local frame = mod.arrow
		frame.texture:SetRotation(0)
		frame.texture:SetTexCoord(1, 0, 0, 1)
		frame:SetPoint("CENTER", 250, 100)
		frame:Show()
		mod:SimpleTimer(function() mod.arrow:Hide() end, 4)
	end,
	swap = function()
		local frame = mod.arrow
		frame.texture:SetRotation(math.rad(-70))
		frame:SetPoint("CENTER", 0, 100)
		frame:Show()
		mod:SimpleTimer(function() mod.arrow:Hide() end, 4)
	end,
}

local INITIAL_DIRECTION = {
	{ [ICON_NEGATIVE] = "left", [ICON_POSITIVE] = "right" }, -- 1
	{ [ICON_POSITIVE] = "left", [ICON_NEGATIVE] = "right" }, -- 2
	[false] = {}
}

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

	L.add_death_trigger = "%s dies."
	L.overload_trigger = "%s overloads!"
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

	-- BigWigs_ThaddiusArrows
	L.polarity_extras = "Additional alerts for Polarity Shift positioning"

	L.custom_off_select_charge_position = "First position"
	L.custom_off_select_charge_position_desc = "Where to move to after the first Polarity Shift."
	L.custom_off_select_charge_position_value1 = "|cffff2020Negative (-)|r are LEFT, |cff2020ffPositive (+)|r are RIGHT"
	L.custom_off_select_charge_position_value2 = "|cff2020ffPositive (+)|r are LEFT, |cffff2020Negative (-)|r are RIGHT"

	L.custom_off_select_charge_movement = "Movement"
	L.custom_off_select_charge_movement_desc = "The movement strategy your group uses."
	L.custom_off_select_charge_movement_value1 = "Run |cff20ff20THROUGH|r the boss"
	L.custom_off_select_charge_movement_value2 = "Run |cff20ff20CLOCKWISE|r around the boss"
	L.custom_off_select_charge_movement_value3 = "Run |cff20ff20COUNTER-CLOCKWISE|r around the boss"
	L.custom_off_select_charge_movement_value4 = "Four camps 1: Polarity changed moves |cff20ff20RIGHT|r, same polarity moves |cff20ff20LEFT|r"
	L.custom_off_select_charge_movement_value5 = "Four camps 2: Polarity changed moves |cff20ff20LEFT|r, same polarity moves |cff20ff20RIGHT|r"

	L.custom_off_charge_graphic = "Graphical arrow"
	L.custom_off_charge_graphic_desc = "Show an arrow graphic."
	L.custom_off_charge_text = "Text arrows"
	L.custom_off_charge_text_desc = "Show an additional message."
	L.custom_off_charge_voice = "Voice alert"
	L.custom_off_charge_voice_desc = "Play a voice alert."

	-- Translate these to get locale sound files!
	L.left = "<--- GO LEFT <--- GO LEFT <---"
	L.right = "---> GO RIGHT ---> GO RIGHT --->"
	L.swap = "^^^^ SWITCH SIDES ^^^^ SWITCH SIDES ^^^^"
	L.stay = "==== DON'T MOVE ==== DON'T MOVE ===="
end
L = mod:GetLocale()

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
		"custom_off_select_charge_position",
		"custom_off_select_charge_movement",
		"custom_off_charge_graphic",
		"custom_off_charge_text",
		"custom_off_charge_voice",
	}, {
		["custom_off_select_charge_position"] = L.polarity_extras,
	}
end

function mod:OnRegister()
	local frame = CreateFrame("Frame", "BigWigsThaddiusArrow", UIParent)
	frame:SetFrameStrata("HIGH")
	frame:Raise()
	frame:SetSize(100, 100)
	frame:SetAlpha(0.6)
	self.arrow = frame

	local texture = frame:CreateTexture(nil, "BACKGROUND")
	texture:SetTexture(ADDON_PATH.."\\Extras\\arrow")
	texture:SetAllPoints(frame)
	frame.texture = texture

	frame:Hide()
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "StalaggPower", 28134)
	self:Log("SPELL_CAST_START", "PolarityShiftCast", 28089)
	self:Log("SPELL_CAST_SUCCESS", "PolarityShift", 28089)

	self:BossYell("Engage", L.trigger_phase1_1, L.trigger_phase1_2)
	self:Emote("AddDeath", L.add_death_trigger)
	self:Emote("PrePhase2", L.overload_trigger)
	self:BossYell("Phase2", L.trigger_phase2_1, L.trigger_phase2_2, L.trigger_phase2_3)
	self:Death("Win", 15928)
end

function mod:OnEngage()
	addsdead = 0
	lastCharge = nil
	shiftTime = nil

	strategy = {}
	local opt = self:GetOption("custom_off_select_charge_position")
	strategy.first = INITIAL_DIRECTION[opt]

	opt = self:GetOption("custom_off_select_charge_movement")
	if opt == 1 then -- through
		strategy.change = "swap"
		strategy.nochange = "stay"
	elseif opt == 2 then -- cw
		strategy.change = "left"
		strategy.nochange = "stay"
	elseif opt == 3 then -- ccw
		strategy.change = "right"
		strategy.nochange = "stay"
	elseif opt == 4 then -- 4r
		strategy.change = "right"
		strategy.nochange = "left"
	elseif opt == 5 then -- 4l
		strategy.change = "left"
		strategy.nochange = "right"
	end

	self:Message("stages", "yellow", L.phase1_message, false)
	self:Throw()
end

function mod:OnBossDisable()
	self.arrow:Hide()
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

function mod:AddDeath(msg, sender)
	addsdead = addsdead + 1
	self:Message("stages", "yellow", CL.mob_killed:format(sender, addsdead, 2), false)
	if addsdead == 2 then
		self:CancelTimer(throwHandle)
		self:StopBar(L.throw)
	end
end

do
	local prev = 0
	function mod:PrePhase2()
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message("stages", "yellow", CL.incoming:format(L.bossName), false)
			self:Bar("stages", 3, L.bossName, "spell_lightning_lightningbolt01")
		end
	end
end

function mod:Phase2()
	-- XXX Can remove these if ruRU triggers get updated
	self:CancelTimer(throwHandle)
	self:StopBar(L.throw)

	self:Berserk(300, true)
	self:Message("stages", "yellow", L.phase2_message, false)
end

function mod:PolarityShiftCast(args)
	self:Message(28089, "orange", CL.casting:format(args.spellName))
	self:PlaySound(28089, "long")
	shiftTime = GetTime()
	self:RegisterUnitEvent("UNIT_AURA", "player")
end

function mod:PolarityShift(args)
	self:Bar(28089, 30)
	self:DelayedMessage(28089, 27, "orange", CL.soon:format(args.spellName))
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

	self:PolarityShiftAura(lastCharge, newCharge)

	lastCharge = newCharge
	shiftTime = nil
	self:UnregisterUnitEvent(event, unit)
end

function mod:PolarityShiftAura(lastCharge, newCharge)
	local direction, color, text
	local icon = newCharge == ICON_POSITIVE and "Spell_ChargePositive" or "Spell_ChargeNegative"
	if newCharge == lastCharge then
		-- No change
		direction = strategy.nochange
		color = "yellow"
		text = L.polarity_nochange
	else
		-- Change
		color = newCharge == ICON_POSITIVE and "blue" or "red"
		if not lastCharge then
			-- First charge
			direction = strategy.first[newCharge]
			text = newCharge == ICON_POSITIVE and L.polarity_first_positive or L.polarity_first_negative
		else
			direction = strategy.change
			text = L.polarity_changed
		end
		if not direction or not self:GetOption("custom_off_charge_voice") then
			self:PlaySound(28089, "alert")
		end
		self:Flash(28089, icon)
	end
	if direction then
		if self:GetOption("custom_off_charge_graphic") then
			DIRECTION_ARROW[direction]()
		end
		if self:GetOption("custom_off_charge_text") then
			self:Message(28089, color, L[direction], false) -- SetOption::blue,red,yellow::
		end
		if self:GetOption("custom_off_charge_voice") then
			PlaySoundFile(DIRECTION_SOUND[direction], "Master")
		end
	end
	self:Message(28089, color, text, icon) -- SetOption::blue,red,yellow::
end
