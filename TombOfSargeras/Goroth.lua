if not IsTestBuild() then return end -- XXX dont load on live

--------------------------------------------------------------------------------
-- TODO List:
-- - Infernal Spike and Crashing Comet timers look like they are somehow connected (alternating, swapping timers and whatnot)
--
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

local shatteringCounter = 1
local shatteringTimers = {24.0, 60.0, 60.0, 50.0}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{231363, "TANK", "SAY"}, -- Burning Armor
		{230345, "SAY"}, -- Crashing Comet
		233021, -- Infernal Spike
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

	-- Mythic
	self:Log("SPELL_CAST_SUCCESS", "RainofBrimstone", 238588)
end

function mod:OnEngage()
	burningCounter = 1
	shatteringCounter = 1

	self:Bar(231363, 11) -- Burning Armor
	self:Bar(233279, shatteringTimers[shatteringCounter]) -- Shattering Star
	self:Bar(233062, 54) -- Infernal Burning
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 233050 then --Infernal Spike
		self:Message(233021, "Important", "Alert", CL.casting:format(args.spellName))
		--self:Bar(233021, 16) -- XXX Need more data, very random on PTR.
	elseif spellId == 232249 then -- Crashing Comet
		self:Message(230345, "Urgent", "Warning", CL.casting:format(args.spellName))
		--self:Bar(230345, 16) -- XXX Need more data, very random on PTR.
	end
end

function mod:BurningArmor(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Warning")
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
	self:Bar(args.spellId, 24.3)
end

function mod:ShatteringStarDebuff(args)
	shatteringCounter = shatteringCounter + 1
	self:TargetMessage(233279, args.destName, "Attention", "Alarm")
	self:Bar(233279, 6, 233283) -- Shattering Nova
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
	self:Bar(args.spellId, burningCounter <= 3 and 60 or 64)
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

-- Mythic
function mod:RainofBrimstone(args)
	self:Message(args.spellId, "Urgent", "Warning")
end
