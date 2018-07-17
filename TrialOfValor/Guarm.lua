
--------------------------------------------------------------------------------
-- TODO List:
-- - Lick timers for lfr, normal, hc

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Guarm-TrialOfValor", 1648, 1830)
if not mod then return end
mod:RegisterEnableMob(114323)
mod.engageId = 1962
mod.respawnTime = 15

--------------------------------------------------------------------------------
-- Locals
--
local breathCounter = 0
local fangCounter = 0
local leapCounter = 0
local foamCount = 1
local phaseStartTime = 0
local lickTimer = {14.1, 22.7, 26.3, 33.7, 43.3, 95.8, 99.4, 106.8, 116.5, 171.9, 175.4, 182.6, 192.6}
local foamTargets = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.lick = "Lick"
	L.lick_desc = "Show bars for the different licks." -- For translators: short names of 228248, 228253, 228228
end

--------------------------------------------------------------------------------
-- Initialization
--

local foamMarker = mod:AddMarkerOption(false, "player", 1, -14535, 1, 2, 3)
function mod:GetOptions()
	return {
		--[[ General ]]--
		"berserk",
		{228248, "SAY", "FLASH"}, -- Frost Lick
		{228253, "SAY", "FLASH"}, -- Shadow Lick
		{228228, "SAY", "FLASH"}, -- Flame Lick
		{228187, "FLASH"}, -- Guardian's Breath
		227514, -- Flashing Fangs
		227816, -- Headlong Charge
		227883, -- Roaring Leap

		--[[ Mythic ]]--
		"lick", -- Lick
		-14535, -- Volatile Foam
		foamMarker,
		{228810, "SAY", "FLASH"}, -- Briney Volatile Foam
		{228744, "SAY", "FLASH"}, -- Flaming Volatile Foam
		{228818, "SAY", "FLASH"}, -- Shadowy Volatile Foam
	},{
		["berserk"] = "general",
		["lick"] = "mythic",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_APPLIED", "FrostLick", 228248)
	self:Log("SPELL_AURA_APPLIED", "ShadowLick", 228253)
	self:Log("SPELL_AURA_APPLIED", "FlameLick", 228228)

	self:Log("SPELL_CAST_START", "FlashingFangs", 227514)

	self:Log("SPELL_CAST_SUCCESS", "HeadlongCharge", 227816)

	self:Log("SPELL_CAST_SUCCESS", "RoaringLeap", 227883)

	self:Log("SPELL_CAST_SUCCESS", "VolatileFoam", 228824)
	self:Log("SPELL_AURA_APPLIED", "BrineyFoam", 228810)
	self:Log("SPELL_AURA_APPLIED", "FlamingFoam", 228744)
	self:Log("SPELL_AURA_APPLIED", "ShadowyFoam", 228818)

	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
end

function mod:OnEngage()
	breathCounter = 0
	fangCounter = 0
	leapCounter = 0
	foamCount = 1
	phaseStartTime = GetTime()
	wipe(foamTargets)
	self:Berserk(self:Mythic() and 244 or self:Normal() and 360 or self:LFR() and 420 or 300)
	self:Bar(227514, 6) -- Flashing Fangs
	self:Bar(228187, 14.5) -- Guardian's Breath
	self:Bar(227883, 48.5) -- Roaring Leap
	self:Bar(227816, 57) -- Headlong Charge
	if self:Mythic() then
		self:Bar(-14535, 10.9, CL.count:format(self:SpellName(-14535), foamCount), 228810)
		self:StartLickTimer(1)
	end
end

function mod:OnBossDisable()
	if self:GetOption(foamMarker) then
		for i = 1, #foamTargets do
			SetRaidTarget(foamTargets[i], 0)
			foamTargets[i] = nil
		end
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 228187 then -- Guardian's Breath (starts casting)
		breathCounter = breathCounter + 1
		self:Bar(spellId, (breathCounter % 2 == 0 and 51) or 20.7, CL.count:format(self:SpellName(spellId), breathCounter+1))
		self:Message(spellId, "Attention", "Warning")
		self:CastBar(spellId, 5)
		self:Flash(spellId)
	end
end

do
	local list = mod:NewTargetList()
	function mod:FrostLick(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.4, args.spellId, list, "Urgent", "Alarm", nil, nil, self:Dispeller("magic"))
		end
	end
end

do
	local list = mod:NewTargetList()
	function mod:ShadowLick(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.4, args.spellId, list, "Urgent", "Alarm")
		end
	end
end

do
	local list = mod:NewTargetList()
	function mod:FlameLick(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.4, args.spellId, list, "Urgent", "Alarm")
		end
	end
end

function mod:FlashingFangs(args)
	fangCounter = fangCounter + 1
	self:Message(args.spellId, "Attention", nil, CL.casting:format(args.spellName))
	self:CDBar(args.spellId, fangCounter == 1 and 23 or fangCounter % 2 == 0 and 52 or 20)
end

function mod:HeadlongCharge(args)
	self:Message(args.spellId, "Important", "Long")
	self:Bar(args.spellId, 75.2)
	self:CastBar(args.spellId, 7)
	self:Bar(228187, 30, CL.count:format(self:SpellName(228187), breathCounter+1)) -- Correct Guardian's Breath timer
	if self:Mythic() then
		self:Bar(-14535, 29.1, CL.count:format(self:SpellName(-14535), foamCount), 228810) -- Volatile Foam
	end
end

function mod:RoaringLeap(args)
	leapCounter = leapCounter + 1
	self:Message(args.spellId, "Urgent", "Info")
	if leapCounter % 2 == 0 then
		self:CDBar(227514, 11.2) -- Adjust Flashing Fangs timer
		self:Bar(args.spellId, 53.2)
	else
		self:Bar(args.spellId, 21.8)
	end
end

function mod:VolatileFoam()
	foamCount = foamCount + 1
	local t = foamCount == 2 and 19.4 or foamCount % 3 == 1 and 17 or foamCount % 3 == 2 and 15 or 42
	self:Bar(-14535, t, CL.count:format(self:SpellName(-14535), foamCount), 228810)
end

do
	local function markFoam(self, destName)
		if self:GetOption(foamMarker) then
			local c = #foamTargets+1
			foamTargets[c] = destName
			SetRaidTarget(destName, c)
			if c == 1 then
				self:ScheduleTimer("OnBossDisable", 10)
			end
		end
	end

	function mod:BrineyFoam(args)
		markFoam(self, args.destName)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Neutral", "Alarm", CL.you:format(args.spellName))
			self:Say(args.spellId, ("{rt6} %s {rt6}"):format(args.spellName))
			self:Flash(args.spellId)
		end
	end

	function mod:FlamingFoam(args)
		markFoam(self, args.destName)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Important", "Alert", CL.you:format(args.spellName))
			self:Say(args.spellId, ("{rt7} %s {rt7}"):format(args.spellName))
			self:Flash(args.spellId)
		end
	end

	function mod:ShadowyFoam(args)
		markFoam(self, args.destName)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Attention", "Warning", CL.you:format(args.spellName)) -- purple message would be appropriate
			self:Say(args.spellId, ("{rt3} %s {rt3}"):format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

function mod:StartLickTimer(count)
	local data = self:Mythic() and lickTimer
	local info = data and data[count]
	if not info then
		-- all out of lick data
		return
	end

	local length = floor(info - (GetTime() - phaseStartTime))

	self:CDBar("lick", length, CL.count:format(L.lick, count), 228253)

	self:ScheduleTimer("StartLickTimer", length, count + 1)
end
