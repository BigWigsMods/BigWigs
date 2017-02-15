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

local burningCount = 1
local shatteringCount = 1
local shatteringTimers = {24, 60, 60, 50}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{231363, "SAY"}, -- Burning Armor
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
	self:Log("SPELL_AURA_APPLIED", "BurningArmor", 231363)		
	self:Log("SPELL_CAST_SUCCESS", "CrashingComent", 230345)
	self:Log("SPELL_AURA_APPLIED", "CrashingCometDebuff", 232249)	
	self:Log("SPELL_CAST_SUCCESS", "InfernalSpike", 233021)	
	--self:Log("SPELL_CAST_SUCCESS", "ShatteringStar", 233279)
	self:Log("SPELL_AURA_APPLIED", "ShatteringStarDebuff", 233272)	
	self:Log("SPELL_CAST_START", "InfernalBurning", 233062)	
	
	self:Log("SPELL_AURA_APPLIED", "FelPool", 230348) -- Fel Pool
	self:Log("SPELL_PERIODIC_DAMAGE", "FelPool", 230348)
	self:Log("SPELL_PERIODIC_MISSED", "FelPool", 230348)
	
	-- Mythic
	self:Log("SPELL_CAST_SUCCESS", "RainofBrimstone", 238588)	
end

function mod:OnEngage()
	burningCount = 1
	shatteringCount = 1
	
	self:Bar(231363, 10) -- Burning Armor
	self:Bar(233279, shatteringTimers[shatteringCount]) -- Shattering Star
	self:Bar(233062, 54) -- Infernal Burning
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BurningArmor(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Alert")
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
	self:Bar(args.spellId, 24)
end

function mod:CrashingComent(args)
	--self:Message(args.spellId, "Neutral", "Long")
	--self:Bar(args.spellId, 10)
end

do
	local list = mod:NewTargetList()
	function mod:CrashingCometDebuff(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, 230345, list, "Important", "Warning", nil, nil, true)
		end
		if self:Me(args.destGUID) then
			self:Say(230345)
		end
	end
end

function mod:InfernalSpike(args)
	self:Message(args.spellId, "Neutral", "Info")
	--self:Bar(args.spellId, 10)
end

--function mod:ShatteringStar(args)
	--self:Message(args.spellId, "Attention", "Warning")
	--self:Bar(args.spellId, 10)
--end

function mod:ShatteringStarDebuff(args)
	shatteringCount = shatteringCount + 1
	self:TargetMessage(233279, args.destName, "Attention", "Alarm")
	self:Bar(233279, 6, 233283) -- Shattering Nova
	self:Bar(233279, shatteringTimers[shatteringCount] or shatteringCount % 2 == 1 and 20 or 40, 233283) -- Shattering Nova
	if self:Me(args.destGUID) then
		self:Say(233279)
		self:Flash(233279)
	end
end

function mod:InfernalBurning(args)
	burningCount = burningCount + 1
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 6, CL.casting:format(args.spellName))
	self:Bar(args.spellId, burningCount <= 3 and 60 or 64)
end

do
	local prev = 0
	function mod:FelPool(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

-- Mythic
function mod:RainofBrimstone(args)
	self:Message(args.spellId, "Attention", "Alert")
	--self:Bar(args.spellId, 10)
end
