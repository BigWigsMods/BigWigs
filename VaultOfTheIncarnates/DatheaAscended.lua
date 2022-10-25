if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Dathea, Ascended", 2522, 2502)
if not mod then return end
mod:RegisterEnableMob(189813) -- Dathea, Ascended
mod:SetEncounterID(2635)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local coalescingStormCount = 1
local conductiveMarkCount = 1
local ragingBurstCount = 1
local cycloneCount = 1
local crosswindsCount = 1
local zephyrSlamCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.marks_on_me = "%d Mark" -- {Stacks} Conductive Mark on the player

	L.conductive_marks = "Marks"
	L.conductive_mark = "Mark"
	L.raging_burst = "New Tornadoes"
	L.cyclone = "Pull In"
	L.crosswinds = "Moving Tornadoes"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		387849, -- Coalescing Storm
		395501, -- Blowback

		387943, -- Diverted Essence
		{385812, "TANK"}, -- Aerial Slash

		384273, -- Storm Bolt
		390450, -- Static Cling

		388302, -- Raging Burst
		{391686, "SAY"}, -- Conductive Mark
		--"custom_on_empowered_conductive_mark_yell",
		376943, -- Cyclone
		388410, -- Crosswinds
		{375580, "TANK"}, -- Zephyr Slam
		{376851, "TANK"}, -- Aerial Buffet
	}, {
		[387849] = -25952, -- Coalescing Storm
		[388302] = "general",
	},{
		[387849] = CL.adds, -- Coalescing Storm (Adds)
		[388302] = L.raging_burst, -- Raging Burst (New Tempests)
		[391686] = L.conductive_marks, -- Conductive Mark (Marks)
		[376943] = L.cyclone, -- Cyclone (Pull In)
		[388410] = L.crosswinds, -- Crosswinds (Moving Tempests)
		[375580] = CL.knockback, -- Zephyr Slam (Knockback)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Log("SPELL_CAST_START", "CoalescingStorm", 387849)
	self:Log("SPELL_CAST_START", "Blowback", 395501)
	self:Log("SPELL_CAST_START", "DivertedEssence", 387943)
	self:Log("SPELL_CAST_START", "AerialSlash", 385812)
	self:Log("SPELL_CAST_START", "StormBolt", 384273)
	self:Log("SPELL_AURA_APPLIED", "StaticClingApplied", 390450)
	self:Log("SPELL_AURA_APPLIED_DOSE", "StaticClingApplied", 390450)
	self:Log("SPELL_CAST_START", "RagingBurst", 388302)
	self:Log("SPELL_AURA_APPLIED", "ConductiveMarkApplied", 391686)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ConductiveMarkApplied", 391686)
	self:Log("SPELL_CAST_START", "Cyclone", 376943)
	self:Log("SPELL_CAST_START", "Crosswinds", 388410)
	self:Log("SPELL_CAST_START", "ZephyrSlam", 375580)
	self:Log("SPELL_AURA_APPLIED", "ZephyrSlamApplied", 375580)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ZephyrSlamApplied", 375580)
	self:Log("SPELL_CAST_START", "AerialBuffet", 376851)
end

function mod:OnEngage()
	coalescingStormCount = 1
	conductiveMarkCount = 1
	ragingBurstCount = 1
	cycloneCount = 1
	crosswindsCount = 1
	zephyrSlamCount = 1

	self:CDBar(391686, 4, CL.count:format(L.conductive_marks, conductiveMarkCount)) -- Conductive Mark
	self:CDBar(388302, 7, CL.count:format(L.raging_burst, ragingBurstCount)) -- Raging Burst
	self:CDBar(375580, 16, CL.count:format(CL.knockback, zephyrSlamCount)) -- Zephyr Slam
	self:CDBar(388410, 25.5, CL.count:format(L.crosswinds, crosswindsCount)) -- Crosswinds
	self:CDBar(376943, 37, CL.count:format(L.cyclone, cycloneCount)) -- Cyclone
	self:CDBar(387849, 75, CL.count:format(CL.adds, coalescingStormCount)) -- Coalescing Storm
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 391595 then -- Conductive Mark
		self:StopBar(CL.count:format(L.conductive_marks, conductiveMarkCount))
		conductiveMarkCount = conductiveMarkCount + 1
		local cd = 28
		if self:Mythic() then
			cd = conductiveMarkCount % 3 == 1 and 39.2 or 25.5
		end
		self:CDBar(391686, cd, CL.count:format(L.conductive_marks, conductiveMarkCount))
	end
end

function mod:CoalescingStorm(args)
	self:StopBar(CL.count:format(CL.adds, coalescingStormCount))
	self:Message(args.spellId, "orange", CL.count:format(CL.adds, coalescingStormCount))
	self:PlaySound(args.spellId, "long")
	coalescingStormCount = coalescingStormCount + 1
	self:CDBar(args.spellId, self:Mythic() and 90 or 80.5, CL.count:format(CL.adds, coalescingStormCount))
end


function mod:Blowback(args)
	-- Range check XXX
	self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "warning")
end

function mod:DivertedEssence(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:AerialSlash(args)
	local castingUnit = self:UnitTokenFromGUID(args.sourceGUID)
	if castingUnit and self:Tanking(castingUnit) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
	--self:NameplateBar(args.spellId, 12.2, args.sourceGUID)
end

function mod:StormBolt(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:StaticClingApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 3 == 0 or amount > 10 then
			self:StackMessage(args.spellId, "blue", args.destName, args.amount, args.amount)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:RagingBurst(args)
	self:StopBar(CL.count:format(L.raging_burst, ragingBurstCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.raging_burst, ragingBurstCount))
	self:PlaySound(args.spellId, "alert")
	ragingBurstCount = ragingBurstCount + 1
	self:CDBar(args.spellId, self:Mythic() and 90 or 80, CL.count:format(L.raging_burst, ragingBurstCount))
end

function mod:ConductiveMarkApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, args.amount, L.conductive_mark)
		self:PlaySound(args.spellId, "warning")
		if amount == 1 then -- Initial Say
			self:Say(args.spellId, L.conductive_mark)
		end
	end
end

function mod:Cyclone(args)
	self:StopBar(CL.count:format(L.cyclone, cycloneCount))
	self:Message(args.spellId, "orange", CL.count:format(L.cyclone, cycloneCount))
	self:PlaySound(args.spellId, "alarm")
	cycloneCount = cycloneCount + 1
	self:CDBar(args.spellId, self:Mythic() and 90 or 80.5, CL.count:format(L.cyclone, cycloneCount))
end

function mod:Crosswinds(args)
	self:StopBar(CL.count:format(L.crosswinds, crosswindsCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.crosswinds, crosswindsCount))
	self:PlaySound(args.spellId, "alert")
	crosswindsCount = crosswindsCount + 1
	local cd = crosswindsCount % 2 == 1 and 41 or 36
	if self:Mythic() then
		cd = crosswindsCount % 2 == 1 and 55 or 35.5
	end
	self:CDBar(args.spellId, cd, CL.count:format(L.crosswinds, crosswindsCount))
end

do
	function mod:ZephyrSlam(args)
		local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
		self:Message(args.spellId, "purple", CL.casting:format(CL.knockback))
		if self:Tanking(bossUnit) then
			self:PlaySound(args.spellId, "alert")
		end
		zephyrSlamCount = zephyrSlamCount + 1
		local cd = zephyrSlamCount % 4 == 1 and 28 or 17
		if self:Mythic() then
			cd = zephyrSlamCount % 4 == 1 and 38 or 17
		end
		self:CDBar(args.spellId, cd, CL.knockback)
	end
end

function mod:ZephyrSlamApplied(args)
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, "purple", args.destName, amount, 2)
	if amount > 1 and not self:Tanking(bossUnit) then -- Maybe swap?
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:AerialBuffet(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "info")
end
