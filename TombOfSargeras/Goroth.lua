if not IsTestBuild() then return end -- XXX dont load on live

--------------------------------------------------------------------------------
-- TODO List:

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

local shatteringCounter = 1
local shatteringTimers = {24.0, 60.0, 60.0, 50.0}

local cometSpikeCounter = 1
local cometSpikeTimers = {4, 6, 12, 12, 12, 6, 12, 6, 12, 12, 12, 6, 12, 6, 12, 12, 12, 6, 10} -- Alternates every 7.5s after this
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
		{"cometSpike", "SAY"}, -- Crashing Comet / Infernal Spike
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
	rainCounter = 1
	cometSpikeCounter = 1
	wipe(cometWarned)

	self:Bar("cometSpike", cometSpikeTimers[cometSpikeCounter], L.cometSpike_bar)
	self:Bar(231363, 11) -- Burning Armor
	self:Bar(233279, shatteringTimers[shatteringCounter]) -- Shattering Star
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
		self:Message("cometSpike", "Important", "Alert", CL.casting:format(args.spellName))
		self:Bar("cometSpike", cometSpikeTimers[cometSpikeCounter] or 7.5, L.cometSpike_bar, L.cometSpike_icon)
	elseif spellId == 232249 then -- Crashing Comet
		cometSpikeCounter = cometSpikeCounter + 1
		--self:Message("cometSpike", "Urgent", "Warning", CL.casting:format(args.spellName)) -- XXX Needed with Aura Scan warnings?
		self:Bar("cometSpike", cometSpikeTimers[cometSpikeCounter] or 7.5, L.cometSpike_bar, L.cometSpike_icon)
	elseif spellId == 233285 then -- Raun of Brimstone
		rainCounter = rainCounter + 1
		self:Message(238588, "Urgent", "Warning", CL.incoming:format(spellName))
		self:Bar(238588, raincounter < 7 and (rainCounter % 2 == 0 and 24 or 36) or raincounter > 7 and 60 or 47, CL.count:format(spellName, rainCounter))
		self:Bar(238588, 8, CL.cast:format(spellName))
	end
end

function mod:BurningArmor(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Warning")
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
	self:Bar(args.spellId, 24.3)
end

do
	local list, guid = mod:NewTargetList(), nil
	function mod:UNIT_AURA(event, unit)
		local name = UnitDebuff(unit, self:SpellName(232249)) -- Crashing Comet debuff ID
		local n = self:UnitName(unit)
		if cometWarned[n] and not name then
			cometWarned[n] = nil
		elseif name and not cometWarned[n] then
			guid = UnitGUID(n)
			list[#list+1] = n
			if #list == 1 then
				self:ScheduleTimer("TargetMessage", 0.1, "cometSpike", list, "Important", "Warning", 232249, 232249)
			end
			if self:Me(guid) then
				self:Say("cometSpike", 232249)
				self:Flash("cometSpike", 232249)
			end
			cometWarned[n] = true
		end
	end
end

function mod:ShatteringStarDebuff(args)
	shatteringCounter = shatteringCounter + 1
	self:TargetMessage(233279, args.destName, "Attention", "Alarm")
	self:Bar(233279, 6, CL.cast:format(args.spellName))
	self:Bar(233279, shatteringTimers[shatteringCounter] or shatteringCounter % 2 == 1 and 20 or 40) -- Shattering Star
	if self:Me(args.destGUID) then
		self:Say(233279)
		self:Flash(233279)
	end
end

function mod:InfernalBurning(args)
	burningCounter = burningCounter + 1
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 6, CL.cast:format(args.spellName))
	self:Bar(args.spellId, burningCounter == 4 and 64 or 60)
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