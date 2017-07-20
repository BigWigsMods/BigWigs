
-- GLOBALS: math

--------------------------------------------------------------------------------
-- TODO List:
-- - Keep updating the timers if any new timers shorter than current are found
-- - Check Desolate timers in P1 again - might get offset later in the fight
-- - Maybe mark Shadowy Blades? 3 in heroic, 7 in mythic. Maybe too much for mythic?

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Fallen Avatar", 1147, 1873)
if not mod then return end
mod:RegisterEnableMob(116939, 117264) -- Fallen Avatar, Maiden of Valor
mod.engageId = 2038
mod.respawnTime = 25

--------------------------------------------------------------------------------
-- Locals
--

local timersHeroic = {
	[234057] = {7, 42, 35, 41, 36, 35, 43}, -- Unbound Chaos
	[239207] = {15, 42.5, 55, 43, 42.5, 42.5}, -- Touch of Sargeras
	[236573] = {30, 42.5, 36.5, 30, 30, 30, 33}, -- Shadowy Blades
	[239132] = {37, 60.8, 60, 62}, -- Rupture Realities
}

local timersMythic = {
	[234057] = {7, 43.8, 41.4, 35.7, 36.1, 35.3, 35.1}, -- Unbound Chaos
	[239207] = {15.5, 63.5, 63, 63}, -- Touch of Sargeras
	[236573] = {28.5, 35.3, 48.5, 42.5, 48.3, 40.1}, -- Shadowy Blades
	[239132] = {34.5, 64.5, 63, 63}, -- Rupture Realities
}

local stage = 1
local corruptedMatrixCounter = 1
local ruptureRealitiesCounter = 1
local unboundChaosCounter = 1
local shadowyBladesCounter = 1
local touchofSargerasCounter = 1
local desolateCounter = 1
local darkMarkCounter = 1
local taintedMatrixCounter = 1
local energyLeakCheck = nil

local timers = mod:Mythic() and timersMythic or timersHeroic

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.touch_impact = "Touch Impact" -- Touch of Sargeras Impact (short)

	L.custom_on_stop_timers = "Always show ability bars"
	L.custom_on_stop_timers_desc = "Fallen Avatar randomizes which off-cooldown ability he uses next. When this option is enabled, the bars for those abilities will stay on your screen."

	L.energy_leak = "Energy Leak"
	L.energy_leak_desc = "Display a warning when energy has leaked onto the boss in stage 1."
	L.energy_leak_msg = "Energy Leak! (%d)"
end
--------------------------------------------------------------------------------
-- Initialization
--

local darkMarkIcons = mod:AddMarkerOption(false, "player", 6, 239739, 6, 4, 3)
function mod:GetOptions()
	return {
		"stages",
		"energy_leak",
		"custom_on_stop_timers",
		239207, -- Touch of Sargeras
		239132, -- Rupture Realities
		234059, -- Unbound Chaos
		{236604, "SAY", "FLASH"}, -- Shadowy Blades
		239212, -- Lingering Darkness
		{236494, "TANK"}, -- Desolate
		236528, -- Ripple of Darkness
		233856, -- Cleansing Protocol
		233556, -- Corrupted Matrix
		{239739, "FLASH", "SAY", "INFOBOX"}, -- Dark Mark
		darkMarkIcons,
		235572, -- Rupture Realities
		242017, -- Black Winds
		236684, -- Fel Infusion
		240623, -- Tainted Matrix
		240728, -- Tainted Essence
		234418, -- Rain of the Destroyer
	},{
		["stages"] = "general",
		[239058] = -14709, -- Stage One: A Slumber Disturbed
		[233856] = -14713, -- Maiden of Valor
		[233556] = -15565, -- Containment Pylon
		[239739] = -14719, -- Stage Two: An Avatar Awakened
		[240623] = "mythic",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2")
	self:RegisterEvent("RAID_BOSS_WHISPER")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 239212) -- Lingering Darkness
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", 239212)
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", 239212)

	-- Stage One: A Slumber Disturbed
	self:Log("SPELL_CAST_START", "TouchofSargeras", 239207)
	self:Log("SPELL_CAST_START", "RuptureRealities", 239132)
	self:Log("SPELL_AURA_APPLIED", "UnboundChaos", 234059)
	self:Log("SPELL_CAST_START", "Desolate", 236494)
	self:Log("SPELL_AURA_APPLIED", "DesolateApplied", 236494)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DesolateApplied", 236494)
	self:Log("SPELL_CAST_SUCCESS", "Consume", 240594)
	self:Log("SPELL_CAST_SUCCESS", "RippleofDarkness", 236528)

	-- Maiden of Valor
	self:Log("SPELL_CAST_START", "CleansingProtocol", 233856)
	self:Log("SPELL_AURA_APPLIED", "Malfunction", 233739)
	self:Death("MaidenDeath", 117264)

	-- Containment Pylon
	self:Log("SPELL_CAST_START", "CorruptedMatrix", 233556)

	-- Stage Two: An Avatar Awakened
	self:Log("SPELL_CAST_SUCCESS", "Annihilation", 235597) -- Stage 2 cast
	self:Log("SPELL_AURA_APPLIED", "DarkMark", 239739)
	self:Log("SPELL_AURA_REMOVED", "DarkMarkRemoved", 239739)
	self:Log("SPELL_CAST_START", "RuptureRealitiesP2", 235572)
	self:Log("SPELL_AURA_APPLIED", "FelInfusion", 236684)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FelInfusion", 236684)

	-- Mythic
	self:Log("SPELL_CAST_START", "TaintedMatrix", 240623)
	self:Log("SPELL_AURA_APPLIED", "TaintedEssence", 240728)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TaintedEssence", 240728)

	self:RegisterMessage("BigWigs_BarCreated", "BarCreated")
end

function mod:OnEngage()
	timers = self:Mythic() and timersMythic or timersHeroic
	stage = 1
	corruptedMatrixCounter = 1
	desolateCounter = 1
	unboundChaosCounter = 1
	touchofSargerasCounter = 1
	shadowyBladesCounter = 1
	ruptureRealitiesCounter = 1
	darkMarkCounter = 1
	taintedMatrixCounter = 1

	self:Bar(236494, 12) -- Desolate
	self:Bar(234059, timers[234057][unboundChaosCounter]) -- Unbound Chaos
	if not self:Easy() then
		self:Bar(239207, timers[239207][touchofSargerasCounter], CL.count:format(self:SpellName(239207), touchofSargerasCounter)) -- Touch of Sargeras
	end
	if self:Mythic() then
		self:CDBar(233856, 73) -- Maiden Shield (if no fail)
	end
	self:Bar(236604, timers[236573][shadowyBladesCounter]) -- Shadowy Blades
	self:Bar(239132, timers[239132][ruptureRealitiesCounter]) -- Rupture Realities (P1)

	if not self:LFR() then
		self:InitCheckUnitPower()
		energyLeakCheck = self:ScheduleRepeatingTimer("CheckUnitPower", 1)
	end

	self:RegisterUnitEvent("UNIT_POWER", nil, "boss2")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local tbl, checks, prev, last = {}, 0, 0, nil

	function mod:InitCheckUnitPower()
		wipe(tbl)
		checks = 0
		last = nil
	end

	function mod:CheckUnitPower()
		local power = UnitPower("boss1")
		tbl[checks%5 + 1] = math.max(power-(last or 0), 0)

		local sum = 0
		for _,v in pairs(tbl) do
			sum = sum + v
		end

		if sum >= 5 then -- Check power gained
			local t = GetTime()
			if last and power > last and t-prev > 2 then -- Skip first message, only if power is bigger than before
				self:Message("energy_leak", "Attention", "Info", L.energy_leak_msg:format(sum), false)
				self:InitCheckUnitPower()
				prev = t
			end
		end

		last = power
		checks = checks + 1
	end
end

do
	local abilitysToPause = {
		[234059] = true, -- Unbound Chaos
		[239207] = true, -- Touch of Sargeras
		[236604] = true, -- Shadowy Blades
		[239132] = true, -- Rupture Realities (P1)
	}

	local castPattern = CL.cast:gsub("%%s", ".+")

	local function stopAtZeroSec(bar)
		if bar.remaining < 0.15 then -- Pause at 0.0
			bar:SetDuration(0.01) -- Make the bar look full
			bar:Start()
			bar:Pause()
			bar:SetTimeVisibility(false)
		end
	end

	function mod:BarCreated(_, _, bar, _, key, text)
		if self:GetOption("custom_on_stop_timers") and abilitysToPause[key] and not text:match(castPattern) and text ~= L.touch_impact then
			bar:AddUpdateFunction(stopAtZeroSec)
		end
	end
end

do
	local bladeTimer = nil

	function mod:UNIT_SPELLCAST_SUCCEEDED(_, spellName, _, _, spellId)
		if spellId == 234057 then -- Unbound Chaos
			if self:Tank() then
				self:Message(234059, "Attention", "Alert")
			end
			unboundChaosCounter = unboundChaosCounter + 1
			self:Bar(234059, timers[spellId][unboundChaosCounter] or 35)
		elseif spellId == 236573 then -- Shadowy Blades
			bladeTimer = self:ScheduleTimer("Message", 0.3, 236604, "Attention", "Alert")
			shadowyBladesCounter = shadowyBladesCounter + 1
			self:CDBar(236604, timers[spellId][shadowyBladesCounter] or 30)
			self:CastBar(236604, 5)
		end
	end

	function mod:RAID_BOSS_WHISPER(_, msg)
		if msg:find("236604", nil, true) then -- Shadowy Blades
			if bladeTimer then
				self:CancelTimer(bladeTimer)
				bladeTimer = nil
			end
			self:Message(236604, "Personal", "Alarm", CL.you:format(self:SpellName(236604)))
			self:Flash(236604)
			self:Say(236604)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	if msg:find("234418") then -- Rain of the Destroyer
		self:Message(234418, "Important", "Alarm")
		self:Bar(234418, 35)
		self:CDBar(234418, 6, self:SpellName(182580)) -- Meteor Impact (estimated)
	end
end

function mod:UNIT_POWER(unit)
	local power = UnitPower(unit)
	if power >= 85 then
		self:Message(233856, "Attention", self:Damager() and "Info", CL.soon:format(self:SpellName(233856))) -- Cleansing Protocol
		self:UnregisterUnitEvent("UNIT_POWER", unit)
	end
end

do
	local prev = 0
	function mod:GroundEffectDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

function mod:TouchofSargeras(args)
	self:StopBar(CL.count:format(args.spellName, touchofSargerasCounter))
	self:Message(args.spellId, "Attention", "Alert", CL.incoming:format(CL.count:format(args.spellName, touchofSargerasCounter)))
	self:Bar(args.spellId, 10.5, L.touch_impact)
	touchofSargerasCounter = touchofSargerasCounter + 1
	self:Bar(args.spellId, timers[args.spellId][touchofSargerasCounter] or 42, CL.count:format(args.spellName, touchofSargerasCounter))
end

function mod:RuptureRealities(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
	ruptureRealitiesCounter = ruptureRealitiesCounter + 1
	self:Bar(args.spellId, timers[args.spellId][ruptureRealitiesCounter] or 60)
	self:CastBar(args.spellId, 7.5)
end

function mod:UnboundChaos(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	end
end

function mod:Desolate(args)
	self:Message(args.spellId, "Attention", "Alert", CL.casting:format(args.spellName))
	desolateCounter = desolateCounter + 1
	self:CDBar(args.spellId, stage == 2 and (desolateCounter % 2 == 0 and 12 or 23) or (desolateCounter % 4 == 3 and 24.3 or 11.5))
end

function mod:DesolateApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Urgent", "Warning", nil, nil, amount > 1 and true)
end

function mod:Consume(args)
	self:Message("stages", "Neutral", "Info", args.spellName, args.spellId)
	self:StopBar(CL.cast:format(self:SpellName(233856))) -- Malfunction
end

function mod:RippleofDarkness(args)
	self:Message(args.spellId, "Urgent", "Warning")
end

function mod:CleansingProtocol(args)
	self:Message(args.spellId, "Urgent", "Alarm", CL.casting:format(args.spellName))
	if self:Mythic() then
		self:CDBar(args.spellId, 80) -- Maiden Shield (if no fail)
	end
	self:CastBar(args.spellId, 18)
end

function mod:Malfunction()
	self:Message(233856, "Positive", "Info", CL.removed:format(self:SpellName(233856))) -- Cleansing Protocol
	self:StopBar(CL.cast:format(self:SpellName(233856))) -- Cleansing Protocol
	self:RegisterUnitEvent("UNIT_POWER", nil, "boss2")
end

function mod:MaidenDeath()
	if energyLeakCheck then
		self:CancelTimer(energyLeakCheck)
		energyLeakCheck = nil
	end
	self:UnregisterUnitEvent("UNIT_POWER", "boss2")
end

function mod:CorruptedMatrix(args)
	self:Message(args.spellId, "Important", "Warning", CL.incoming:format(args.spellName))
	corruptedMatrixCounter = corruptedMatrixCounter + 1
	self:CDBar(args.spellId, self:Mythic() and 20 or 50)
	self:CastBar(args.spellId, self:Mythic() and 8 or 10)
end

function mod:Annihilation() -- Stage 2
	stage = 2
	self:Message("stages", "Positive", "Long", CL.stage:format(stage), false)

	self:StopBar(233556) -- Corrupted Matrix
	self:StopBar(CL.cast:format(self:SpellName(233556))) -- Corrupted Matrix (cast)
	self:StopBar(236494) -- Desolate
	self:StopBar(234059) -- Unbound Chaos
	self:StopBar(CL.count:format(self:SpellName(239207), touchofSargerasCounter)) -- Touch of Sargeras
	self:StopBar(CL.cast:format(CL.count:format(self:SpellName(239207), touchofSargerasCounter))) -- Touch of Sargeras (cast)
	self:StopBar(236604) -- Shadowy Blades
	self:StopBar(239132) -- Rupture Realities (P1)
	self:StopBar(240623) -- Tainted Matrix
	self:StopBar(233856) -- Maiden Shield
	self:StopBar(CL.cast:format(self:SpellName(240623))) -- Tainted Matrix (cast)

	ruptureRealitiesCounter = 1
	desolateCounter = 1
	darkMarkCounter = 1

	if energyLeakCheck then
		self:CancelTimer(energyLeakCheck)
		energyLeakCheck = nil
	end

	self:UnregisterUnitEvent("UNIT_POWER", "boss2")

	self:CDBar(236494, 20) -- Desolate
	self:CDBar(239739, self:Mythic() and 31.1 or 21.5) -- Dark Mark
	if self:Mythic() then
		self:Bar(234418, 14.3) -- Rain of the Destroyer
	end
	self:CDBar(235572, self:Mythic() and 38.4 or 38, CL.count:format(self:SpellName(235572), ruptureRealitiesCounter)) -- Rupture Realities (P2)
end

do
	local list, infoBoxList, timer = mod:NewTargetList(), {}, nil
	local infoBoxText = {
		[1] = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_6.png:0|t %.1f",
		[3] = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_4.png:0|t %.1f",
		[5] = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_3.png:0|t %.1f",
	}

	local function updateInfoBox(self)
		for _,debuff in pairs(infoBoxList) do
			local pos = debuff.pos-1
			self:SetInfo(239739, pos, (infoBoxText[pos]):format(debuff.expires-GetTime()))
		end
	end

	function mod:DarkMark(args)
		local count = #list+1
		list[count] = args.destName

		local _, _, _, _, _, _, expires = UnitDebuff(args.destName, args.spellName) -- random duration
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId, CL.count:format(args.spellName, count)) -- Announce which mark you have
			local remaining = expires-GetTime()
			self:SayCountdown(args.spellId, remaining)
		end

		if count == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Attention", "Alarm")
			darkMarkCounter = darkMarkCounter + 1
			self:Bar(args.spellId, self:Mythic() and (darkMarkCounter == 2 and 25.5 or 30.5) or 34, CL.count:format(args.spellName, darkMarkCounter))
			self:OpenInfo(args.spellId, args.spellName)
			self:SetInfo(args.spellId, 1, infoBoxText[1]:format(6))
			self:SetInfo(args.spellId, 3, infoBoxText[3]:format(8))
			if not self:Easy() then
				self:SetInfo(args.spellId, 5, infoBoxText[5]:format(10))
			end
			wipe(infoBoxList)
			timer = self:ScheduleRepeatingTimer(updateInfoBox, 0.1, self)
		end

		infoBoxList[args.destName] = {pos = count*2, expires = expires}
		self:SetInfo(args.spellId, count*2, self:ColorName(args.destName))

		if self:GetOption(darkMarkIcons) then
			local icon = count == 1 and 6 or count == 2 and 4 or count == 3 and 3 -- (Blue -> Green -> Purple) in order of exploding/application
			if icon then
				SetRaidTarget(args.destName, icon)
			end
		end
	end

	function mod:DarkMarkRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		if self:GetOption(darkMarkIcons) then
			SetRaidTarget(args.destName, 0)
		end
		if infoBoxList[args.destName] then
			self:SetInfo(args.spellId, infoBoxList[args.destName].pos, "")
			self:SetInfo(args.spellId, infoBoxList[args.destName].pos-1, "")
			infoBoxList[args.destName] = nil
		end
		if not next(infoBoxList) then
			self:CloseInfo(args.spellId)
			if timer then
				self:CancelTimer(timer)
				timer = nil
			end
		end
	end
end

function mod:RuptureRealitiesP2(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(CL.count:format(args.spellName, ruptureRealitiesCounter)))
	self:CastBar(args.spellId, 7.5, CL.count:format(args.spellName, ruptureRealitiesCounter))
	ruptureRealitiesCounter = ruptureRealitiesCounter + 1
	self:Bar(args.spellId, 37.7, CL.count:format(args.spellName, ruptureRealitiesCounter))
end

function mod:FelInfusion(args)
	local amount = args.amount or 1
	if amount % 2 == 0 then
		self:Message(args.spellId, "Attention", "Info", CL.count:format(args.spellName, amount), nil, false)
	end
end

do
	local prev = 0
	function mod:TaintedMatrix(args)
		local t = GetTime()
		if t-prev > 1.5 then
			prev = t
			taintedMatrixCounter = taintedMatrixCounter + 1
			self:Message(args.spellId, "Important", "Warning", CL.incoming:format(args.spellName))
			self:CDBar(args.spellId, 60, CL.count:format(args.spellName, taintedMatrixCounter))
			self:CastBar(args.spellId, 8)
		end
	end
end

function mod:TaintedEssence(args)
	local amount = args.amount or 1
	if self:Me(args.destGUID) and amount > 4 then
		self:StackMessage(args.spellId, args.destName, amount, "Urgent", "Warning")
	end
end
