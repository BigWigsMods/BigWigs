if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Hungering Destroyer", 2296, 2428)
if not mod then return end
mod:RegisterEnableMob(164261) -- Hungering Destroyer
mod.engageId = 2383
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local volatileCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{329298, "SAY"}, -- Gluttonous Miasma
		334522, -- Consume
		329758, -- Expunge -- XXX No events??
		{334266, "SAY", "SAY_COUNTDOWN", "FLASH"}, -- Volatile Ejection
		329455, -- Desolate
		{329774, "TANK"}, -- Overwhelm
		{332295, "TANK"}, -- Growing Hunger
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "GluttonousMiasmaApplied", 329298)
	self:Log("SPELL_CAST_START", "Consume", 334522)
	self:Log("SPELL_CAST_START", "Expunge", 329758)
	self:Log("SPELL_CAST_START", "VolatileEjection", 334266)
	self:Log("SPELL_CAST_START", "Desolate", 329455)
	self:Log("SPELL_CAST_START", "Overwhelm", 329774)
	self:Log("SPELL_AURA_APPLIED", "GrowingHungerApplied", 332295)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GrowingHungerApplied", 332295)
end

function mod:OnEngage()
	volatileCount = 1
	self:Bar(329774, 5.5) -- Overwhelm
	self:Bar(329298, 4.5) -- Gluttonous Miasma
	self:Bar(329298, 10.2) -- Volatile Ejection
	self:Bar(334522, 111) -- Consume
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local playerList = mod:NewTargetList()
	function mod:GluttonousMiasmaApplied(args)
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
		 self:Bar(args.spellId, 24)
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:PlaySound(args.spellId, "alarm")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end
end

function mod:Consume(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 10) -- 2s Cast, 8s Channel
	self:Bar(args.spellId, 110)
end

function mod:Expunge(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 5)
end

function mod:VolatileEjection(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
	volatileCount = volatileCount + 1
	self:Bar(args.spellId, volatileCount == 3 and 12 or 35.5)
end

-- do
-- 	local playerList = mod:NewTargetList()
-- 	function mod:VolatileEjectionApplied(args)
-- 		playerList[#playerList+1] = args.destName
-- 		if self:Me(args.destGUID) then
-- 			self:Say(args.spellId)
-- 			self:SayCountdown(args.spellId, 4)
-- 			self:Flash(args.spellId)
-- 			self:PlaySound(args.spellId, "warning")
-- 		end
-- 		self:TargetsMessage(args.spellId, "orange", playerList)
-- 	end
--
-- 	function mod:VolatileEjectionRemoved(args)
-- 		if self:Me(args.destGUID) then
-- 			self:CancelSayCountdown(args.spellId)
-- 		end
-- 	end
-- end

function mod:Overwhelm(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 11.5)
end

function mod:Desolate(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, 60)
end

function mod:GrowingHungerApplied(args)
	local amount = args.amount or 1
	if amount % 3 == 0 or amount > 5 then -- 3, 6+
		self:StackMessage(args.spellId, args.destName, amount, "purple")
		self:PlaySound(args.spellId, "alert")
	end
end
