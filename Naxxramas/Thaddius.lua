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

	SOUND_LEFT = ("%s\\Extras\\Thaddius-%s-Left.ogg"):format(ADDON_PATH, locale)
	SOUND_RIGHT = ("%s\\Extras\\Thaddius-%s-Right.ogg"):format(ADDON_PATH, locale)
	SOUND_SWAP = ("%s\\Extras\\Thaddius-%s-Swap.ogg"):format(ADDON_PATH, locale)
	SOUND_STAY = ("%s\\Extras\\Thaddius-%s-Stay.ogg"):format(ADDON_PATH, locale)
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

	-- Simplified BigWigs_ThaddiusArrows
	L.polarity_extras = "Additional alerts for Polarity positioning."

	-- Probably should have just made this a plugin so I could use a radio buttons or a dropdown ~_~
	L.custom_off_charge_RL = "Position 1"
	L.custom_off_charge_RL_desc = "|cffff2020Negative (-)|r are LEFT, |cff2020ffPositive (+)|r are RIGHT. Start in front of the boss."
	L.custom_off_charge_LR = "Position 2"
	L.custom_off_charge_LR_desc = "|cff2020ffPositive (+)|r are LEFT, |cffff2020Negative (-)|r are RIGHT. Start in front of the boss."

	L.custom_on_charge_across = "Movement: Run through"
	L.custom_on_charge_across_desc = "Polarity change moves THROUGH Thaddius, no polarity change DOES NOT MOVE."

	L.custom_off_charge_clockwise = "Movement: Clockwise"
	L.custom_off_charge_clockwise_desc = "Polarity change moves CLOCKWISE around Thaddius, no polarity change DOES NOT MOVE."
	L.custom_off_charge_cclockwise = "Movement: Counter-clockwise"
	L.custom_off_charge_cclockwise_desc = "Polarity change moves COUNTER-CLOCKWISE around Thaddius, no polarity change DOES NOT MOVE."

	L.custom_off_charge_4RL = "Movement: Four camps 1"
	L.custom_off_charge_4RL_desc = "Polarity change moves RIGHT, no polarity change moves LEFT."
	L.custom_off_charge_4LR = "Movement: Four camps 2"
	L.custom_off_charge_4LR_desc = "Polarity change moves LEFT, no polarity change moves RIGHT."

	L.custom_off_charge_graphic = "Graphical arrows"
	L.custom_off_charge_graphic_desc = "Show an arrow graphic."
	L.custom_off_charge_text = "Text arrows"
	L.custom_off_charge_text_desc = "Show an additional message."
	L.custom_off_charge_voice = "Voice alerts"
	L.custom_off_charge_voice_desc = "Play a voice alert."

	-- Translate these to get locale sound files!
	L.warn_left = "<--- GO LEFT <--- GO LEFT <---"
	L.warn_right = "---> GO RIGHT ---> GO RIGHT --->"
	L.warn_swap = "^^^^ SWITCH SIDES ^^^^ SWITCH SIDES ^^^^"
	L.warn_stay = "==== DON'T MOVE ==== DON'T MOVE ===="
end
L = mod:GetLocale()

local function ARROW_LEFT()
	local frame = mod.arrow
	frame.texture:SetTexture("ADDON_PATH\\Extras\\arrow")
	frame.texture:SetTexCoord(0, 1, 0, 1)
	frame:SetPoint("CENTER", -250, 100)
	frame:Show()

	mod:SimpleTimer(function() frame:Hide() end, 4)
end

local function ARROW_RIGHT()
	local frame = mod.arrow
	frame.texture:SetTexture("ADDON_PATH\\Extras\\arrow")
	frame.texture:SetTexCoord(1, 0, 0, 1)
	frame:SetPoint("CENTER", 250, 100)
	frame:Show()

	mod:SimpleTimer(function() frame:Hide() end, 4)
end

local function ARROW_SWAP()
	local frame = mod.arrow
	frame.texture:SetTexture("ADDON_PATH\\Extras\\straightArrow")
	frame.texture:SetTexCoord(0, 1, 0, 1)
	frame:SetPoint("CENTER", 0, 200)
	frame:Show()

	mod:SimpleTimer(function() frame:Hide() end, 4)
end

local function ARROW_STAY()
	-- local frame = mod.arrow
	-- frame.texture:SetTexture("ADDON_PATH\\Extras\\stop")
	-- frame.texture:SetTexCoord(0, 1, 0, 1)
	-- frame:SetPoint("CENTER", 0, 200)
	-- frame:Show()

	-- mod:SimpleTimer(function() frame:Hide() end, 4)
end

local DIRECTION_LEFT = { sound = SOUND_LEFT, text = L.warn_left, arrow = ARROW_LEFT }
local DIRECTION_RIGHT = { sound = SOUND_RIGHT, text = L.warn_right, arrow = ARROW_RIGHT }
local DIRECTION_ACROSS = { sound = SOUND_SWAP, text = L.warn_swap, arrow = ARROW_SWAP }
local DIRECTION_NONE = { sound = SOUND_STAY, text = L.warn_stay, arrow = ARROW_STAY }

local INITIAL_DIRECTION = {
	{ -- 1
		[ICON_NEGATIVE] = DIRECTION_LEFT,
		[ICON_POSITIVE] = DIRECTION_RIGHT,
	},
	{ -- 2
		[ICON_POSITIVE] = DIRECTION_LEFT,
		[ICON_NEGATIVE] = DIRECTION_RIGHT,
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
		"custom_on_charge_across",
		"custom_off_charge_clockwise",
		"custom_off_charge_clockwise",
		"custom_off_charge_4RL",
		"custom_off_charge_4LR",
		"custom_off_charge_graphic",
		"custom_off_charge_text",
		"custom_off_charge_voice",
	}, {
		["custom_off_charge_RL"] = L.polarity_extras,
	}
end

function mod:OnRegister()
	local frame = CreateFrame("Frame", "BigWigsThaddiusArrow", UIParent)
	frame:SetFrameStrata("MEDIUM")
	frame:SetSize(200, 200)
	frame:SetAlpha(0.6)
	frame:Hide()
	self.arrow = frame

	local texture = frame:CreateTexture(nil, "BACKGROUND")
	texture:SetAllPoints(frame)
	frame.texture = texture
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "StalaggPower", 28134)
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
	if self:GetOption("custom_off_charge_RL") then
		strategy.first = INITIAL_DIRECTION[1]
	elseif self:GetOption("custom_off_charge_LR") then
		strategy.first = INITIAL_DIRECTION[2]
	end
	if strategy.first then
		if self:GetOption("custom_on_charge_across") then
			strategy.change = DIRECTION_ACROSS
			strategy.nochange = DIRECTION_NONE
		elseif self:GetOption("custom_off_charge_clockwise") then
			strategy.change = DIRECTION_LEFT
			strategy.nochange = DIRECTION_NONE
		elseif self:GetOption("custom_off_charge_cclockwise") then
			strategy.change = DIRECTION_RIGHT
			strategy.nochange = DIRECTION_NONE
		elseif self:GetOption("custom_off_charge_4RL") then
			strategy.change = DIRECTION_RIGHT
			strategy.nochange = DIRECTION_LEFT
		elseif self:GetOption("custom_off_charge_4LR") then
			strategy.change = DIRECTION_LEFT
			strategy.nochange = DIRECTION_RIGHT
		end
	end

	self:Message("stages", "cyan", L.phase1_message, false)
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
	self:Message("stages", "yellow", L.mob_killed:format(sender, addsdead, 2), false)
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
	self:Message("stages", "cyan", L.phase2_message, false)
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

	shiftTime = nil
	self:UnregisterUnitEvent(event, unit)

	local info, text, color
	local icon = newCharge == ICON_POSITIVE and "Spell_ChargePositive" or "Spell_ChargeNegative"
	if newCharge == lastCharge then
		-- No change
		info = strategy.nochange
		color = "yellow"
		text = L.polarity_nochange
	else
		-- Change
		color = newCharge == ICON_POSITIVE and "blue" or "red"
		if not lastCharge then
			-- First charge
			info = strategy.first
			text = newCharge == ICON_POSITIVE and L.polarity_first_positive or L.polarity_first_negative
		else
			info = strategy.change
			text = L.polarity_changed
		end
		if not info or not self:GetOption("custom_off_charge_voice") then
			self:PlaySound(28089, "alert")
		end
		self:Flash(28089, icon)
	end

	if info then
		if self:GetOption("custom_off_charge_graphic") then
			info.arrow()
		end
		if info.text and self:GetOption("custom_off_charge_text") then
			self:Message(28089, color, info.text, false) -- SetOption::blue,red::
		end
		if self:GetOption("custom_off_charge_voice") then
			PlaySoundFile(info.sound, "Master")
		end
	end
	self:Message(28089, color, text, icon) -- SetOption::blue,red,yellow::

	lastCharge = newCharge
end
