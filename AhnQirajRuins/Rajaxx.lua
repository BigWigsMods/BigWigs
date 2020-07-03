
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("General Rajaxx", 509)
if not mod then return end
mod:RegisterEnableMob(15341, 15471) -- General Rajaxx, Lieutenant General Andorov
mod:SetAllowWin(true)
mod.engageId = 719

--------------------------------------------------------------------------------
-- Locals
--

local wave_triggers = nil
local rajdead = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "General Rajaxx"

	L.wave = "Waves Warnings"
	L.wave_desc = "Warn for incoming waves"

	L.wave_trigger1a = "Kill first, ask questions later... Incoming!"
	L.wave_trigger1b = "Remember, Rajaxx, when I said I'd kill you last?" -- when you pull the first wave instead of talking to Andorov
	-- L.wave_trigger2 = "" -- There is no callout for wave 2 ><
	L.wave_trigger3 = "The time of our retribution is at hand! Let darkness reign in the hearts of our enemies!"
	L.wave_trigger4 = "No longer will we wait behind barred doors and walls of stone! No longer will our vengeance be denied! The dragons themselves will tremble before our wrath!"
	L.wave_trigger5 = "Fear is for the enemy! Fear and death!"
	L.wave_trigger6 = "Staghelm will whimper and beg for his life, just as his whelp of a son did! One thousand years of injustice will end this day!"
	L.wave_trigger7 = "Fandral! Your time has come! Go and hide in the Emerald Dream and pray we never find you!"
	L.wave_trigger8 = "Impudent fool! I will kill you myself!"

	L.wave_message = "Wave (%d/8)"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"wave",
		25471, -- Attack Order
		8269, -- Frenzy
	}
end

function mod:OnRegister()
	self.displayName = L.bossName

	wave_triggers = {
		[L.wave_trigger1a] = L.wave_message:format(1),
		[L.wave_trigger1b] = L.wave_message:format(1),
		[L.wave_trigger8] = CL.incoming:format(self.displayName),
	}
	for i = 3, 7 do
		wave_triggers[L["wave_trigger"..i]] = L.wave_message:format(i)
	end
end

function mod:VerifyEnable(unit)
	return not rajdead
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "AttackOrder", 25471)
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 8269)

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

function mod:OnWin()
	rajdead = true
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:AttackOrder(args)
	self:TargetMessage2(25471, "yellow", args.destName)
	self:TargetBar(25471, 10, args.destName)
end

function mod:Frenzy(args)
	self:Message2(25471, "red")
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	for trigger, text in next, wave_triggers do
		if msg:find(trigger, nil, true) then
			self:Message2("wave", "yellow", text, false)
			self:PlaySound("wave", "info")
			break
		end
	end
end
