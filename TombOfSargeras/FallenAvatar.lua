
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

local phase = 1
local corruptedMatrixCounter = 1
local ruptureRealitiesCounter = 1
local unboundChaosCounter = 1
local shadowyBladesCounter = 1
local touchofSargerasCounter = 1
local desolateCounter = 1
local darkMarkCounter = 1
local taintedMatrixCounter = 1

local timers = timersHeroic

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.touch_impact = "Touch Impact" -- Touch of Sargeras Impact (short)

	L.custom_on_stop_timers = "Always show ability bars"
	L.custom_on_stop_timers_desc = "Fallen Avatar randomizes which off-cooldown ability he uses next. When this option is enabled, the bars for those abilities will stay on your screen."
end
--------------------------------------------------------------------------------
-- Initialization
--

local darkMarkIcons = mod:AddMarkerOption(false, "player", 6, 239739, 6, 4, 3)
function mod:GetOptions()
	return {
		"stages",
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
		{239739, "FLASH", "SAY"}, -- Dark Mark
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
	self:Log("SPELL_AURA_REMOVED", "DarkMarkRemoved", 239739) -- Dark Mark
	self:Log("SPELL_CAST_START", "RuptureRealitiesP2", 235572) -- Rupture Realities
	self:Log("SPELL_AURA_APPLIED", "FelInfusion", 236684) -- Dark Mark
	self:Log("SPELL_AURA_APPLIED_DOSE", "FelInfusion", 236684) -- Dark Mark

	-- Mythic
	self:Log("SPELL_CAST_START", "TaintedMatrix", 240623) -- Tainted Matrix
	self:Log("SPELL_AURA_APPLIED", "TaintedEssence", 240728) -- Desolate
	self:Log("SPELL_AURA_APPLIED_DOSE", "TaintedEssence", 240728) -- Desolate

	self:RegisterMessage("BigWigs_BarCreated", "BarCreated")
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
	if not self:Easy() then
		self:Bar(239207, timers[239207][touchofSargerasCounter], CL.count:format(self:SpellName(239207), touchofSargerasCounter)) -- Touch of Sargeras
	end
	self:Bar(236604, timers[236573][shadowyBladesCounter]) -- Shadowy Blades
	self:Bar(239132, timers[239132][ruptureRealitiesCounter]) -- Rupture Realities (P1)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

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

	function mod:BarCreated(_, _, bar, module, key, text, time, icon, isApprox)
		if self:GetOption("custom_on_stop_timers") and abilitysToPause[key] and not text:match(castPattern) and text ~= L.touch_impact then
			bar:AddUpdateFunction(stopAtZeroSec)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 234057 then -- Unbound Chaos
		if self:Tank() then
			self:Message(234059, "Attention", "Alert")
		end
		unboundChaosCounter = unboundChaosCounter + 1
		self:Bar(234059, timers[spellId][unboundChaosCounter])
	elseif spellId == 236573 then -- Shadowy Blades
		self:Message(236604, "Attention", "Alert", spellName)
		shadowyBladesCounter = shadowyBladesCounter + 1
		self:CDBar(236604, timers[spellId][shadowyBladesCounter])
		self:CastBar(236604, 5)
	elseif spellId == 235597 then -- Annihilation // Stage 2
		phase = 2
		self:Message("stages", "Positive", "Long", self:SpellName(-14719), false) -- Stage Two: An Avatar Awakened

		self:StopBar(233556) -- Corrupted Matrix
		self:StopBar(CL.cast:format(self:SpellName(233556))) -- Corrupted Matrix (cast)
		self:StopBar(236494) -- Desolate
		self:StopBar(234059) -- Unbound Chaos
		self:StopBar(CL.count:format(self:SpellName(239207), touchofSargerasCounter)) -- Touch of Sargeras
		self:StopBar(CL.cast:format(CL.count:format(self:SpellName(239207), touchofSargerasCounter))) -- Touch of Sargeras (cast)
		self:StopBar(236604) -- Shadowy Blades
		self:StopBar(239132) -- Rupture Realities (P1)
		self:StopBar(240623) -- Tainted Matrix
		self:StopBar(CL.cast:format(self:SpellName(240623))) -- Tainted Matrix (cast)

		ruptureRealitiesCounter = 1
		desolateCounter = 1
		darkMarkCounter = 1

		self:CDBar(236494, 20) -- Desolate
		self:CDBar(239739, 21.5) -- Dark Mark
		self:CDBar(235572, 38, CL.count:format(self:SpellName(235572), ruptureRealitiesCounter)) -- Rupture Realities (P2)
	end
end

function mod:RAID_BOSS_WHISPER(_, msg, sender)
	if msg:find("236604", nil, true) then -- Shadowy Blades
		self:Message(236604, "Personal", "Alarm", CL.you:format(self:SpellName(236604)))
		self:Flash(236604)
		self:Say(236604)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	if msg:find("234418") then -- Rain of the Destroyer
		self:Message(234418, "Important", "Alarm")
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
	self:Bar(args.spellId, timers[args.spellId][touchofSargerasCounter], CL.count:format(args.spellName, touchofSargerasCounter))
end

function mod:RuptureRealities(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
	ruptureRealitiesCounter = ruptureRealitiesCounter + 1
	self:Bar(args.spellId, timers[args.spellId][ruptureRealitiesCounter])
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
	self:CDBar(args.spellId, phase == 2 and (desolateCounter % 2 == 0 and 12 or 23) or (desolateCounter % 4 == 3 and 24.3 or 11.5))
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
	self:CastBar(args.spellId, 18)
end

function mod:Malfunction(args)
	self:Message(233856, "Positive", "Info", CL.removed:format(self:SpellName(233856)))
	self:StopBar(CL.cast:format(self:SpellName(233856)))
end

function mod:CorruptedMatrix(args)
	self:Message(args.spellId, "Important", "Warning", CL.incoming:format(args.spellName))
	corruptedMatrixCounter = corruptedMatrixCounter + 1
	self:CDBar(args.spellId, self:Mythic() and 20 or 50)
	self:CastBar(args.spellId, self:Mythic() and 5 or 10)
end

do
	local list = mod:NewTargetList()
	function mod:DarkMark(args)
		list[#list+1] = args.destName
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId, CL.count:format(args.spellName, #list)) -- Announce which mark you have
			self:SayCountdown(args.spellId, 6)
		end
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Attention", "Alarm")
			darkMarkCounter = darkMarkCounter + 1
			self:Bar(args.spellId, 34, CL.count:format(args.spellName, darkMarkCounter))
		end

		if self:GetOption(darkMarkIcons) then
			local icon = #list == 1 and 6 or #list == 2 and 4 or #list == 3 and 3 -- (Blue -> Green -> Purple) in order of exploding/application
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

function mod:TaintedMatrix(args)
	self:Message(args.spellId, "Important", "Warning", CL.incoming:format(args.spellName))
	taintedMatrixCounter = taintedMatrixCounter + 1
end

function mod:TaintedEssence(args)
	local amount = args.amount or 1
	if self:Me(args.destGUID) and amount > 4 then
		self:StackMessage(args.spellId, args.destName, amount, "Urgent", "Warning")
	end
end
