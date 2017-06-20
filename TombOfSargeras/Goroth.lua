
--------------------------------------------------------------------------------
-- TODO List:
-- - Double check LFR timers on live

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Goroth", 1147, 1862)
if not mod then return end
mod:RegisterEnableMob(115844)
mod.engageId = 2032
mod.respawnTime = 15

--------------------------------------------------------------------------------
-- Locals
--

local burningCounter = 1
local rainCounter = 1
local armorCounter = 1

local shatteringCounter = 1
local shatteringTimers = {24.0, 60.0, 60.0, 60.0, 47.0}
local shatteringTimersMythic = {24.0, 60.0, 60.0, 46.1}

local cometSpikeCounter = 1
local cometSpikeTimersLFR = {4, 10, 6, 14, 8, 8, 14, 10, 6, 14, 8, 8, 14, 10, 6, 14, 8, 8, 14} -- 8, 8, 8, 10, 8, 8, 10 Repeating
local cometSpikeTimers = {4, 6, 12, 12, 12, 6, 12, 6, 12, 12, 12, 6, 12, 6, 12, 12, 12, 6, 10} -- 7.5 Repeating
local cometWarned = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.cometSpike = "Crashing Comet & Infernal Spike [Bars and Warnings]"
	L.cometSpike_desc = "Display a bar showing when either Crashing Comet or Infernal Spike is about to be cast."
	L.cometSpike_icon = 233021
	L.cometSpike_bar = "Comet / Spike" -- Crashing Comet / Infernal Spike -- Short
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{231363, "TANK", "SAY"}, -- Burning Armor
		"cometSpike", -- Crashing Comet / Infernal Spike
		{230345, "FLASH", "SAY"}, -- Crashing Comet
		{233279, "FLASH", "SAY"}, -- Shattering Star
		233062, -- Infernal Burning
		234346, -- Fel Eruption
		238588, -- Rain of Brimstone
	},{
		[231363] = "general",
		[238588] = "mythic",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Log("SPELL_AURA_APPLIED", "BurningArmor", 231363)
	self:Log("SPELL_AURA_APPLIED", "CrashingComet", 230345)
	self:Log("SPELL_AURA_APPLIED", "ShatteringStarDebuff", 233272)
	self:Log("SPELL_CAST_START", "InfernalBurning", 233062)

	-- Fel Pool
	self:Log("SPELL_AURA_APPLIED", "FelPool", 230348)
	self:Log("SPELL_PERIODIC_DAMAGE", "FelPool", 230348)
	self:Log("SPELL_PERIODIC_MISSED", "FelPool", 230348)
end

function mod:OnEngage()
	burningCounter = 1
	shatteringCounter = 1
	armorCounter = 1
	rainCounter = 1
	cometSpikeCounter = 1
	wipe(cometWarned)

	self:Bar("cometSpike", self:LFR() and cometSpikeTimersLFR[cometSpikeCounter] or cometSpikeTimers[cometSpikeCounter], L.cometSpike_bar, L.cometSpike_icon)
	self:Bar(231363, 11) -- Burning Armor
	self:Bar(233279, shatteringTimers[shatteringCounter], CL.count:format(self:SpellName(233279), 1)) -- Shattering Star
	self:Bar(233062, 54) -- Infernal Burning
	if self:Mythic() then
		self:Bar(238588, 14) -- Rain of Brimstone
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 233050 then --Infernal Spike
		cometSpikeCounter = cometSpikeCounter + 1
		self:Message("cometSpike", "Important", "Alert", CL.casting:format(spellName), L.cometSpike_icon)
		local timer = nil
		if self:LFR() then
			timer = cometSpikeTimersLFR[cometSpikeCounter] or (cometSpikeCounter % 7 == 2 and 10 or cometSpikeCounter % 7 == 5 and 10 or 8)
		else
			timer = cometSpikeTimers[cometSpikeCounter] or 7.5
		end
		if timer then
			self:Bar("cometSpike", timer or 7.5, L.cometSpike_bar, L.cometSpike_icon)
		end
	elseif spellId == 233285 then -- Rain of Brimstone
		rainCounter = rainCounter + 1
		self:Message(238588, "Urgent", "Warning", CL.incoming:format(spellName))
		self:Bar(238588, rainCounter == 5 and 68 or 60, CL.count:format(spellName, rainCounter))
		self:Bar(238588, 8, self:SpellName(182580), 238588) -- Meteor Impact
	end
end

function mod:BurningArmor(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Warning")
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
	armorCounter = armorCounter + 1
	self:CDBar(args.spellId, (armorCounter > 3 and armorCounter % 2 == 0 and 35) or 24.2)
end

do
	local list = mod:NewTargetList()
	function mod:CrashingComet(args)
		list[#list+1] = args.destName
		if #list == 1 then
			cometSpikeCounter = cometSpikeCounter + 1
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Important", "Warning")
			local timer = nil
			if self:LFR() then
				timer = cometSpikeTimersLFR[cometSpikeCounter] or (cometSpikeCounter % 7 == 2 and 10 or cometSpikeCounter % 7 == 5 and 10 or 8)
			else
				timer = cometSpikeTimers[cometSpikeCounter] or 7.5
			end
			if timer then
				self:Bar("cometSpike", timer, L.cometSpike_bar, L.cometSpike_icon)
			end
		end

		if self:Me(args.destGUID) then
			self:TargetMessage(args.spellId, args.destName, "Important", "Warning")
			self:Say(args.spellId)
			self:Flash(args.spellId)

			local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
			local remaining = expires-GetTime()
			self:ScheduleTimer("Say", remaining-3, args.spellId, 3, true)
			self:ScheduleTimer("Say", remaining-2, args.spellId, 2, true)
			self:ScheduleTimer("Say", remaining-1, args.spellId, 1, true)
		end
	end
end


function mod:ShatteringStarDebuff(args)
	self:TargetMessage(233279, args.destName, "Attention", "Alarm", CL.count:format(args.spellName, shatteringCounter))
	self:CastBar(233279, 6, CL.count:format(args.spellName, shatteringCounter)) -- <cast: Shattering Star>
	shatteringCounter = shatteringCounter + 1
	local t =  (self:Mythic() and shatteringTimersMythic[shatteringCounter] or shatteringTimers[shatteringCounter]) or (self:Mythic() and 30 or (shatteringCounter % 2 == 1 and 19 or 41))
	self:Bar(233279, t, CL.count:format(args.spellName, shatteringCounter)) -- Shattering Star
	if self:Me(args.destGUID) then
		self:Say(233279)
		self:Flash(233279)
	end
end

function mod:InfernalBurning(args)
	burningCounter = burningCounter + 1
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 6)
	self:Bar(args.spellId, 60)
end

do
	local prev = 0
	function mod:FelPool(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(234346, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end
