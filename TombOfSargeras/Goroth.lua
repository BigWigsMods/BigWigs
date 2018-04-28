
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Goroth", 1676, 1862)
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
local shatteringTimers = {24, 60, 60, 60, 47}
local shatteringTimersMythic = {34, 60, 60, 60, 32}

local spikeCounter = 1
local cometCounter = 1

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{231363, "TANK", "SAY"}, -- Burning Armor
		233514, -- Infernal Spike
		{232249, "FLASH", "SAY"}, -- Crashing Comet
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

	self:Log("SPELL_CAST_SUCCESS", "BurningArmorSuccess", 231363)
	self:Log("SPELL_AURA_APPLIED", "BurningArmor", 231363)
	self:Log("SPELL_AURA_REMOVED", "MeltedArmorRemoved", 234264)
	self:Log("SPELL_AURA_APPLIED", "ShatteringStarDebuff", 233272)
	self:Log("SPELL_CAST_START", "InfernalBurning", 233062)
	self:Log("SPELL_CAST_SUCCESS", "CrashingComet", 232249)
	self:Log("SPELL_AURA_APPLIED", "CrashingCometApplied", 232249)
	self:Log("SPELL_AURA_REMOVED", "CrashingCometRemoved", 232249)

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
	spikeCounter = 1
	cometCounter = 1

	self:Bar(233514, 4.8) -- Infernal Spike
	if not self:LFR() then -- Technically exists but is irrelevant. No debuff, no aoe, just a delayed single target minor damage hit.
		self:Bar(232249, 8.5) -- Crashing Comet
	end
	self:CDBar(231363, 10) -- Burning Armor
	self:Bar(233279, self:Mythic() and shatteringTimersMythic[shatteringCounter] or shatteringTimers[shatteringCounter], CL.count:format(self:SpellName(233279), 1)) -- Shattering Star
	self:Bar(233062, 54) -- Infernal Burning
	if self:Mythic() then
		self:CDBar(238588, 12) -- Rain of Brimstone
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:UNIT_SPELLCAST_SUCCEEDED(_, spellName, _, _, spellId)
	if spellId == 233050 then --Infernal Spike
		self:Message(233514, "Important", "Alert", CL.casting:format(spellName))
		spikeCounter = spikeCounter + 1
		if self:LFR() then
			self:Bar(233514, spikeCounter == 4 and 26 or 16.6)
		else
			self:Bar(233514, spikeCounter == 4 and 22 or spikeCounter == 11 and 19.5 or 17)
		end
	elseif spellId == 233285 then -- Rain of Brimstone
		rainCounter = rainCounter + 1
		self:Message(238588, "Urgent", "Warning", CL.incoming:format(spellName))
		self:Bar(238588, rainCounter == 5 and 68 or 60, CL.count:format(spellName, rainCounter))
		self:Bar(238588, 8, self:SpellName(182580), 238588) -- Meteor Impact
	end
end

function mod:BurningArmorSuccess(args)
	armorCounter = armorCounter + 1
	if self:LFR() then
		self:CDBar(args.spellId, armorCounter == 3 and 33 or armorCounter == 8 and 29 or 24.3)
	elseif self:Mythic() then
		self:CDBar(args.spellId, 24.5)
	else
		self:CDBar(args.spellId, (armorCounter > 3 and armorCounter % 2 ~= 0 and 35) or (self:Normal() and 25 or 24))
	end
end

function mod:BurningArmor(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", not self:UnitDebuff("player", self:SpellName(234264)) and "Warning" or "Alarm", nil, nil, true)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
end

function mod:MeltedArmorRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(231363, "Urgent", "Warning", CL.removed:format(args.spellName))
	end
end

function mod:ShatteringStarDebuff(args)
	self:TargetMessage(233279, args.destName, "Attention", "Alarm", CL.count:format(args.spellName, shatteringCounter))
	self:CastBar(233279, 6, CL.count:format(args.spellName, shatteringCounter)) -- <cast: Shattering Star>
	shatteringCounter = shatteringCounter + 1
	local t = (self:Mythic() and shatteringTimersMythic[shatteringCounter] or shatteringTimers[shatteringCounter]) or (self:Mythic() and 29 or (shatteringCounter % 2 == 0 and 19 or 41))
	self:Bar(233279, t, CL.count:format(args.spellName, shatteringCounter)) -- Shattering Star
	if self:Me(args.destGUID) then
		self:Say(233279)
		self:Flash(233279)
	end
end

function mod:InfernalBurning(args)
	burningCounter = burningCounter + 1
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, self:LFR() and 10 or 6)
	self:Bar(args.spellId, self:LFR() and 64.4 or 60.5)
end

function mod:CrashingComet(args)
	cometCounter = cometCounter + 1
	self:Bar(args.spellId, cometCounter == 7 and 20 or cometCounter == 10 and 25 or 18.3)
end

do
	local list = mod:NewTargetList()
	function mod:CrashingCometApplied(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Important", "Warning")
		end

		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:Flash(args.spellId)
			self:SayCountdown(args.spellId, 5)
		end
	end
end

function mod:CrashingCometRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
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
