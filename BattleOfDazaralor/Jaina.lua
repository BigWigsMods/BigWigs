--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Jaina Proudmoore", 2070, 2343)
if not mod then return end
mod:RegisterEnableMob(133251)
mod.engageId = 2281
--mod.respawnTime = 31

--------------------------------------------------------------------------------
-- Locals
--

local ringofIceCount = 1
local icefallCount = 1
local stage = 1

--------------------------------------------------------------------------------
-- Localization
--

--local L = mod:GetLocale()
--if L then
--
--end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- General
		285215, -- Chilling Touch
		287490, -- Frozen Solid
		-- Stage 1
		{288038, "FLASH"}, -- Marked Target
		285725, -- Set Charge
		285828, -- Bombard
		287365, -- Searing Pitch
		{285253, "TANK"}, -- Ice Shard
		287565, -- Avalanche
		287925, -- Time Warp
		287626, -- Grasp of Frost
		285177, -- Freezing Blast
		285459, -- Ring of Ice
		-- Intermission
		289861, -- Howling Winds
		-- Stage 2
		289940, -- Crystalline Dust
		288345, -- Glacial Ray
		288475, -- Icefall
		-- Intermission
		288719, -- Flash Freeze
		289985, -- Arcane Barrage
		289220, -- Heart of Frost
		289219, -- Frost Nova
		290084, -- Water Bolt Volley
		-- Stage 3
		288647, -- Orb of Frost
		288671, -- Shattering Lance
		288747, -- Prismatic Image
	}
end

function mod:OnBossEnable()
	-- General
	self:Log("SPELL_AURA_APPLIED", "ChillingTouch", 285215)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ChillingTouch", 285215)
	self:Log("SPELL_AURA_APPLIED", "FrozenSolid", 287490)

	-- Stage 1
	self:Log("SPELL_AURA_APPLIED", "MarkedTargetApplied", 288038) -- XXX Fixate icon nameplates
	self:Log("SPELL_CAST_SUCCESS", "SetCharge", 285725)
	self:Log("SPELL_CAST_SUCCESS", "Bombard", 285828)
	self:Log("SPELL_AURA_APPLIED", "IceShard", 285253)
	self:Log("SPELL_AURA_APPLIED_DOSE", "IceShard", 285253)
	self:Log("SPELL_CAST_START", "Avalanche", 287565)
	self:Log("SPELL_CAST_SUCCESS", "TimeWarp", 287925)
	self:Log("SPELL_AURA_APPLIED", "GraspofFrost", 287626)
	self:Log("SPELL_CAST_START", "FreezingBlast", 285177)
	self:Log("SPELL_CAST_START", "RingofIce", 285459)

	-- Intermission
	self:Log("SPELL_CAST_SUCCESS", "HowlingWinds", 289861)

	-- Stage 2
	self:Log("SPELL_CAST_SUCCESS", "CrystallineDust", 289940)
	self:Log("SPELL_CAST_START", "GlacialRay", 288345)
	self:Log("SPELL_CAST_START", "Icefall", 288475)

	-- Intermission
	self:Log("SPELL_CAST_START", "FlashFreeze", 288719)
	self:Log("SPELL_CAST_SUCCESS", "ArcaneBarrage", 289985)
	self:Log("SPELL_AURA_APPLIED", "HeartofFrost", 289220)
	self:Log("SPELL_CAST_START", "FrostNova", 289219)
	self:Log("SPELL_CAST_START", "WaterBoltVolley", 290084)

	-- Stage 3
	self:Log("SPELL_CAST_SUCCESS", "OrbofFrost", 288647)
	self:Log("SPELL_CAST_START", "ShatteringLance", 288671)
	self:Log("SPELL_CAST_START", "PrismaticImage", 288747)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 287365) -- Searing Pitch
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 287365)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 287365)
end

function mod:OnEngage()
	ringofIceCount = 1
	icefallCount = 1
	stage = 1
	self:CDBar(287565, 8) -- Avalanche
	self:CDBar(285177, 17) -- Freezing Blast
	self:CDBar(285459, 60, CL.count:format(self:SpellName(285459), ringofIceCount)) -- Ring of Ice
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ChillingTouch(args)
	if self:Me(args.destGUID) then -- Check if we have to warn for high stacks in Mythic
		local amount = args.amount or 1
		if amount >= 18 or amount % 5 == 0 then
			self:StackMessage(args.spellId, args.destName, amount, "blue")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:FrozenSolid(args)
		playerList[#playerList+1] = args.destName
		self:PlaySound(args.spellId, "warning", nil, playerList)
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end
end

-- Stage One
function mod:MarkedTargetApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
		self:Flash(args.spellId)
	end
end

function mod:SetCharge(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:Bombard(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

function mod:IceShard(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alert", nil, args.destName)
end

function mod:Avalanche(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, stage > 1 and 75 or 60)
end

function mod:TimeWarp(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

do
	local playerList = mod:NewTargetList()
	function mod:GraspofFrost(args)
		playerList[#playerList+1] = args.destName
		self:PlaySound(args.spellId, "alert", nil, playerList)
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end
end

function mod:FreezingBlast(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, 10)
end

function mod:RingofIce(args)
	self:Message2(args.spellId, "orange", CL.count:format(args.spellName, ringofIceCount))
	self:PlaySound(args.spellId, "long")
	ringofIceCount = ringofIceCount + 1
	self:CDBar(args.spellId, 60, CL.count:format(args.spellName, ringofIceCount))
end

-- Intermission
function mod:HowlingWinds(args)
	stage = stage + 1
	self:Message2(args.spellId, "green")
	self:PlaySound(args.spellId, "info")
end

-- Stage Two
function mod:CrystallineDust(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 15, CL.count:format(args.spellName, icefallCount))
end

function mod:GlacialRay(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:CDBar(args.spellId, 60, CL.count:format(args.spellName, icefallCount))
end

function mod:Icefall(args)
	if self:MobId(args.sourceGUID) == 133251 then -- Jaina
		self:Message2(args.spellId, "orange", CL.count:format(args.spellName, icefallCount))
		self:PlaySound(args.spellId, "long")
		--self:CastBar(args.spellId, 10, CL.count:format(args.spellName, icefallCount)) -- impact
		icefallCount = icefallCount + 1
		self:CDBar(args.spellId, 55, CL.count:format(args.spellName, icefallCount))
	else -- Prismatic Image
		self:Message2(args.spellId, "orange")
		self:PlaySound(args.spellId, "long")
	end
end

-- Intermission: Flash Freeze
function mod:FlashFreeze(args)
	stage = 3
	self:Message2(args.spellId, "green")
	self:PlaySound(args.spellId, "long")
end

function mod:ArcaneBarrage(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

do
	local playerList = mod:NewTargetList()
	function mod:HeartofFrost(args)
		playerList[#playerList+1] = args.destName
		self:PlaySound(args.spellId, "alert", nil, playerList)
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end
end

function mod:FrostNova(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

function mod:WaterBoltVolley(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

-- Stage 3
function mod:OrbofFrost(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:ShatteringLance(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:PrismaticImage(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
	self:CDBar(args.spellId, 51)
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
