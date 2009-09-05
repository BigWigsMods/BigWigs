----------------------------------
--      Module Declaration      --
----------------------------------
local boss = "Thaddius"
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.displayName = boss
mod.bossName = { boss, "Feugen", "Stalagg" }
mod.zoneName = "Naxxramas"
--[[
	15928 - thaddius 
	15929 - stalagg
	15930 - feugen
	
--]]
mod.enabletrigger = { 15928, 15929, 15930 }
mod.guid = 15928
mod.toggleOptions = {28089, -1, 28134, "throw", "phase", "berserk", "bosskill"}
mod.consoleCmd = "Thaddius"

------------------------------
--      Are you local?      --
------------------------------

local deaths = 0
local stage1warn = nil
local lastCharge = nil
local shiftTime = nil

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Thaddius", "enUS", true)
if L then
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
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Thaddius")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "StalaggPower", 28134, 54529)
	self:AddCombatListener("SPELL_CAST_START", "Shift", 28089)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	deaths = 0
	stage1warn = nil
	lastCharge = nil
	shiftTime = nil

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:StalaggPower(_, spellId, _, _, spellName)
	self:IfMessage(L["surge_message"], "Important", spellId)
	self:Bar(spellName, 10, spellId)
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
		if self:GetOption(28089) then
			if not lastCharge then
				self:LocalMessage(newCharge == "Interface\\Icons\\Spell_ChargePositive" and
					L["polarity_first_positive"] or L["polarity_first_negative"],
					"Personal", newCharge, "Alert")
			else
				if newCharge == lastCharge then
					self:LocalMessage(L["polarity_nochange"], "Positive", newCharge)
				else
					self:LocalMessage(L["polarity_changed"], "Personal", newCharge, "Alert")
				end
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
	if self:GetOption(28089) then
		self:IfMessage(L["polarity_message"], "Important", 28089)
	end
end

local function throw()
	if shiftTime then return end
	if mod.db.profile.throw then
		mod:Bar(L["throw_bar"], 20, "Ability_Druid_Maul")
		mod:DelayedMessage(15, L["throw_warning"], "Urgent")
	end
	mod:ScheduleEvent("thadthrow", throw, 21)
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if self:GetOption(28089) and msg:find(L["polarity_trigger"]) then
		self:DelayedMessage(25, L["polarity_warning"], "Important")
		self:Bar(L["polarity_bar"], 28, "Spell_Nature_Lightning")
	elseif msg == L["trigger_phase1_1"] or msg == L["trigger_phase1_2"] then
		if self.db.profile.phase and not stage1warn then
			self:Message(L["phase1_message"], "Important")
		end
		deaths = 0
		stage1warn = true
		throw()
	elseif msg:find(L["trigger_phase2_1"]) or msg:find(L["trigger_phase2_2"]) or msg:find(L["trigger_phase2_3"]) then
		self:CancelAllScheduledEvents()
		self:SendMessage("BigWigs_StopBar", self, L["throw_bar"])
		if self.db.profile.phase then
			self:Message(L["phase2_message"], "Important")
		end
		if self.db.profile.berserk then
			self:Enrage(360, true, true)
		end
	end
end

