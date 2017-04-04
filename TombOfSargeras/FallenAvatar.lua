
--------------------------------------------------------------------------------
-- TODO List:
-- - Re-check phase 1 timers on live

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

local timers = {
	[234057] = {7, 40, 35.2, 47.3, 40, 35}, -- Unbound Chaos
	[239207] = {15, 42.6, 59.5, 60, 42.5, 42.4}, -- Touch of Sargeras
	[236573] = {28, 42.5, 40, 30.3, 49, 36.5, 36.5}, -- Shadowy Blades
	[239132] = {34.3, 60.8, 60.8, 62.1}, -- Rupture Realities
}

local phase = 1
local corruptedMatrixCounter = 1
local ruptureRealitiesCounter = 1
local unboundChaosCounter = 1
local shadowyBladesCounter = 1
local touchofSargerasCounter = 1
local desolateCounter = 1
local darkMarkCounter = 1
local taintedMatrixCounter = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		239207, -- Touch of Sargeras
		239132, -- Rupture Realities
		234059, -- Unbound Chaos
		{236604, "SAY", "FLASH"}, -- Shadowy Blades
		{236494, "TANK"}, -- Desolate
		236528, -- Ripple of Darkness
		233856, -- Cleansing Protocol
		233556, -- Corrupted Matrix
		{239739, "FLASH", "SAY"}, -- Dark Mark
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
		[233556] = -15123, -- Containment Pylon
		[239739] = -14719, -- Stage Two: An Avatar Awakened
		[240623] = "mythic",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2")
	self:RegisterEvent("RAID_BOSS_WHISPER")

	-- Stage One: A Slumber Disturbed
	self:Log("SPELL_CAST_START", "TouchofSargeras", 239207) -- Touch of Sargeras
	self:Log("SPELL_CAST_START", "RuptureRealities", 239132) -- Rupture Realities
	self:Log("SPELL_AURA_APPLIED", "UnboundChaos", 234059) -- Unbound Chaos
	self:Log("SPELL_CAST_START", "Desolate", 236494) -- Desolate
	self:Log("SPELL_AURA_APPLIED", "DesolateApplied", 236494) -- Desolate
	self:Log("SPELL_AURA_APPLIED_DOSE", "DesolateApplied", 236494) -- Desolate
	self:Log("SPELL_CAST_SUCCESS", "Consume", 240594) -- Consume
	self:Log("SPELL_CAST_SUCCESS", "RippleofDarkness", 236528) -- Ripple of Darkness

	-- Maiden of Valor
	self:Log("SPELL_CAST_START", "CleansingProtocol", 233856) -- Cleansing Protocol
	self:Log("SPELL_AURA_APPLIED", "Malfunction", 233739) -- Malfunction

	-- Containment Pylon
	self:Log("SPELL_CAST_START", "CorruptedMatrix", 233556) -- Corrupted Matrix

	-- Stage Two: An Avatar Awakened
	self:Log("SPELL_AURA_APPLIED", "DarkMark", 239739) -- Dark Mark
	self:Log("SPELL_CAST_START", "RuptureRealitiesP2", 235572) -- Rupture Realities
	self:Log("SPELL_AURA_APPLIED", "FelInfusion", 236684) -- Dark Mark
	self:Log("SPELL_AURA_APPLIED_DOSE", "FelInfusion", 236684) -- Dark Mark

	-- Mythic
	self:Log("SPELL_CAST_START", "TaintedMatrix", 240623) -- Corrupted Matrix
	self:Log("SPELL_AURA_APPLIED", "TaintedEssence", 240728) -- Desolate
	self:Log("SPELL_AURA_APPLIED_DOSE", "TaintedEssence", 240728) -- Desolate
	self:Log("SPELL_CAST_SUCCESS", "RainoftheDestroyer", 234418) -- Rain of the Destroyer
end

function mod:OnEngage()
	phase = 1
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
	self:Bar(239207, timers[239207][touchofSargerasCounter], CL.count:format(self:SpellName(239207), touchofSargerasCounter)) -- Touch of Sargeras
	self:Bar(236604, timers[236573][shadowyBladesCounter]) -- Shadowy Blades
	self:Bar(239132, timers[239132][ruptureRealitiesCounter]) -- Rupture Realities (P1)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 234057 then -- Unbound Chaos
		unboundChaosCounter = unboundChaosCounter + 1
		self:Message(234059, "Attention", "Alert", spellName)
		self:Bar(234059, timers[spellId][unboundChaosCounter])
	elseif spellId == 236573 then -- Shadowy Blades
		shadowyBladesCounter = shadowyBladesCounter + 1
		self:Message(236604, "Attention", "Alert", spellName)
		self:CDBar(236604, timers[spellId][shadowyBladesCounter])
	elseif spellId == 235597 then -- Annihilation // Stage 2
		phase = 2
		self:Message("stages", "Positive", "Long", self:SpellName(-14719), false) -- Stage Two: An Avatar Awakened

		self:StopBar(233556) -- Corrupted Matrix
		self:StopBar(CL.cast:format(233556)) -- Corrupted Matrix (cast)
		self:StopBar(236494) -- Desolate
		self:StopBar(234059) -- Unbound Chaos
		self:StopBar(239207) -- Touch of Sargeras
		self:StopBar(236604) -- Shadowy Blades
		self:StopBar(239132) -- Rupture Realities (P1)

		ruptureRealitiesCounter = 1
		desolateCounter = 1
		darkMarkCounter = 1

		self:CDBar(236494, 17.3) -- Desolate
		self:CDBar(239739, 19.8) -- Dark Mark
		if self:Heroic() or self:Mythic() then
			self:CDBar(242017, 23.4) -- Black Winds
		end
		self:CDBar(235572, 33.4, CL.count:format(self:SpellName(235572), ruptureRealitiesCounter)) -- Rupture Realities (P2)

	elseif spellId == 239417 then -- Black Winds
		self:Message(242017, "Attention", "Alert", spellName)
		self:Bar(242017, 25.5)
	end
end

function mod:RAID_BOSS_WHISPER(_, msg, sender)
	if msg:find("236604", nil, true) then -- Shadowy Blades
		self:Message(236604, "Personal", "Alarm", CL.you:format(self:SpellName(236604)))
		self:Flash(236604)
		self:Say(236604)
	end
end

function mod:TouchofSargeras(args)
	touchofSargerasCounter = touchofSargerasCounter + 1
	self:Message(args.spellId, "Attention", "Alert", CL.incoming:format(args.spellName), CL.count:format(args.spellName, (touchofSargerasCounter-1)))
	self:Bar(args.spellId, timers[args.spellId][touchofSargerasCounter], CL.count:format(args.spellName, touchofSargerasCounter))
end

function mod:RuptureRealities(args)
	ruptureRealitiesCounter = ruptureRealitiesCounter + 1
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
	self:Bar(args.spellId, timers[args.spellId][ruptureRealitiesCounter])
end

function mod:UnboundChaos(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	end
end

function mod:Desolate(args)
	desolateCounter = desolateCounter + 1
	self:Message(args.spellId, "Attention", "Alert", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, phase == 2 and (desolateCounter == 2 and 19 or desolateCounter == 6 and 19 or 12) or (desolateCounter % 4 == 3 and 24.3 or 11.5))
end

function mod:DesolateApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Urgent", "Warning", nil, nil, amount > 1 and true)
end

function mod:Consume(args)
	self:Message("stages", "Neutral", "Info", args.spellName, args.spellId)
	self:StopBar(CL.cast:format(233856)) -- Malfunction
end

function mod:RippleofDarkness(args)
	self:Message(args.spellId, "Urgent", "Warning")
end

function mod:CleansingProtocol(args)
	self:Message(args.spellId, "Urgent", "Alarm", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 18)
end

function mod:Malfunction(args)
	self:Message(233856, "Positive", "Info", CL.removed:format(self:SpellName(233856)))
	self:StopBar(CL.cast:format(self:SpellName(233856)))
end

function mod:CorruptedMatrix(args)
	corruptedMatrixCounter = corruptedMatrixCounter + 1
	self:Message(args.spellId, "Important", "Warning", CL.incoming:format(args.spellName))
	self:CDBar(args.spellId, self:Mythic() and 20 or (corruptedMatrixCounter == 2 and 51 or 60))
	self:Bar(args.spellId, self:Mythic() and 5 or 10, CL.cast:format(args.spellName))
end

do
	local list = mod:NewTargetList()
	function mod:DarkMark(args)
		list[#list+1] = args.destName
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId, CL.count:format(args.spellName, #list)) -- Announce which mark you have

			local _, _, _, _, _, _, expires = UnitDebuff(args.destName, args.spellName)
			local remaining = expires-GetTime()
			self:ScheduleTimer("Say", remaining-3, args.spellId, 3, true)
			self:ScheduleTimer("Say", remaining-2, args.spellId, 2, true)
			self:ScheduleTimer("Say", remaining-1, args.spellId, 1, true)
		end
		if #list == 1 then
			darkMarkCounter = darkMarkCounter + 1
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Attention", "Alarm")
			self:Bar(args.spellId, darkMarkCounter == 3 and 27 or 23, CL.count:format(args.spellName, darkMarkCounter))
		end
	end
end

function mod:RuptureRealitiesP2(args)
	ruptureRealitiesCounter = ruptureRealitiesCounter + 1
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(CL.count:format(args.spellName, (ruptureRealitiesCounter-1))))
	self:CastBar(args.spellId, 7.5, CL.count:format(args.spellName, (ruptureRealitiesCounter-1)))
	self:Bar(args.spellId, 28, CL.count:format(args.spellName, ruptureRealitiesCounter))
end

function mod:FelInfusion(args)
	local amount = args.amount or 1
	if amount % 2 == 0 then
		self:Message(args.spellId, "Attention", "Info", CL.count:format(args.spellName, amount), nil, false)
	end
end

function mod:TaintedMatrix(args)
	taintedMatrixCounter = taintedMatrixCounter + 1
	self:Message(args.spellId, "Important", "Warning", CL.incoming:format(args.spellName))
end

function mod:TaintedEssence(args)
	local amount = args.amount or 1
	if self:Me(args.destGUID) and amount > 4 then
		self:StackMessage(args.spellId, args.destName, amount, "Urgent", "Warning")
	end
end

function mod:RainoftheDestroyer(args)
	self:Message(args.spellId, "Important", "Warning")
end