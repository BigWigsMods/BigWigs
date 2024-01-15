--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Dathea, Ascended", 2522, 2502)
if not mod then return end
mod:RegisterEnableMob(189813) -- Dathea, Ascended
mod:SetEncounterID(2635)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local coalescingStormCount = 1
local conductiveMarkCount = 1
local ragingBurstCount = 1
local cycloneCount = 1
local crosswindsCount = 1

local mobCollector = {}
local infuserMarks = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.raging_burst = "New Tornadoes"
	L.cyclone = "Pull In"
	L.crosswinds = "Moving Tornadoes"
end

--------------------------------------------------------------------------------
-- Initialization
--

local volatileInfuserMarker = mod:AddMarkerOption(false, "npc", 8, -25903, 8, 7)
function mod:GetOptions()
	return {
		387849, -- Coalescing Storm

		397431, -- Diverted Essence
		{385812, "TANK", "NAMEPLATEBAR"}, -- Aerial Slash
		395501, -- Blowback
		volatileInfuserMarker,

		384273, -- Storm Bolt
		390450, -- Static Cling

		388302, -- Raging Burst
		{391686, "SAY", "ME_ONLY_EMPHASIZE"}, -- Conductive Mark
		--"custom_on_empowered_conductive_mark_yell",
		376943, -- Cyclone
		388410, -- Crosswinds
		{375580, "TANK"}, -- Zephyr Slam
		{376851, "TANK"}, -- Aerial Buffet
	}, {
		[387849] = -25952, -- Coalescing Storm
		[397431] = -25903, -- Volatile Infuser
		[384273] = -25738, -- Thunder Caller
		[388302] = self.displayName,
	}, {
		[387849] = CL.adds, -- Coalescing Storm (Adds)
		[388302] = L.raging_burst, -- Raging Burst (New Tempests)
		[391686] = CL.marks, -- Conductive Mark (Marks)
		[376943] = L.cyclone, -- Cyclone (Pull In)
		[388410] = L.crosswinds, -- Crosswinds (Moving Tempests)
		[375580] = CL.knockback, -- Zephyr Slam (Knockback)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Log("SPELL_CAST_START", "CoalescingStorm", 387849)
	self:Log("SPELL_CAST_START", "Blowback", 395501)
	self:AddDeath("AddDeath", 192934) -- Volatile Infuser
	self:Log("SPELL_CAST_START", "DivertedEssence", 397431)
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

	mobCollector = {}
	infuserMarks = {}

	self:CDBar(391686, 4, CL.count:format(CL.marks, conductiveMarkCount)) -- Conductive Mark
	self:CDBar(388302, 7, CL.count:format(L.raging_burst, ragingBurstCount)) -- Raging Burst
	self:CDBar(375580, self:Easy() and 9.5 or 16, CL.knockback) -- Zephyr Slam
	self:CDBar(388410, self:Easy() and 29 or 25.5, CL.count:format(L.crosswinds, crosswindsCount)) -- Crosswinds
	self:CDBar(376943, self:Easy() and 45 or 35, CL.count:format(L.cyclone, cycloneCount)) -- Cyclone
	self:CDBar(387849, self:Easy() and 80 or 71, CL.count:format(CL.adds, coalescingStormCount)) -- Coalescing Storm

	if self:GetOption(volatileInfuserMarker) and not self:Mythic() then
		self:RegisterTargetEvents("AddMarking")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:AddMarking(_, unit, guid)
	if guid and not mobCollector[guid] and self:MobId(guid) == 192934 then -- Volatile Infuser
		for i = 8, 7, -1 do -- 8, 7
			if not infuserMarks[i] then
				mobCollector[guid] = true
				infuserMarks[i] = guid
				self:CustomIcon(volatileInfuserMarker, unit, i)
				return
			end
		end
	end
end

function mod:AddDeath(args)
	if self:GetOption(volatileInfuserMarker) then
		for i = 8, 7, -1 do -- 8, 7
			if infuserMarks[i] == args.destGUID then
				infuserMarks[i] = nil
				return
			end
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 391595 then -- Conductive Mark
		self:StopBar(CL.count:format(CL.marks, conductiveMarkCount))
		conductiveMarkCount = conductiveMarkCount + 1
		local cd
		if self:Mythic() then
			cd = conductiveMarkCount % 3 == 1 and 34 or 25.5
		elseif self:Heroic() then
			cd = (conductiveMarkCount > 3 and conductiveMarkCount % 2 == 0) and 52 or 25.5
		else
			cd = conductiveMarkCount % 3 == 1 and 23.1 or 31.5
		end
		self:CDBar(391686, cd, CL.count:format(CL.marks, conductiveMarkCount))
	end
end

function mod:CoalescingStorm(args)
	self:StopBar(CL.count:format(CL.adds, coalescingStormCount))
	self:Message(args.spellId, "orange", CL.count:format(CL.adds, coalescingStormCount))
	self:PlaySound(args.spellId, "long")
	coalescingStormCount = coalescingStormCount + 1
	self:CDBar(args.spellId, self:Heroic() and 75 or 87.5, CL.count:format(CL.adds, coalescingStormCount))

	self:CDBar(391686, self:Mythic() and 19.4 or self:Easy() and 9.7 or 35.5, CL.count:format(CL.marks, conductiveMarkCount)) -- Marks
	self:CDBar(375580, self:Mythic() and 30.5 or 20.7, CL.knockback) -- Zephyr Slam
end

function mod:Blowback(args)
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
			self:StackMessage(args.spellId, "blue", args.destName, amount, 1)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:RagingBurst(args)
	self:StopBar(CL.count:format(L.raging_burst, ragingBurstCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.raging_burst, ragingBurstCount))
	self:PlaySound(args.spellId, "alert")
	ragingBurstCount = ragingBurstCount + 1
	self:CDBar(args.spellId, self:Heroic() and 75 or 86.5, CL.count:format(L.raging_burst, ragingBurstCount))
end

function mod:ConductiveMarkApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:PlaySound(args.spellId, "warning")
		if amount == 1 then -- Initial Say
			self:Say(args.spellId, CL.mark, nil, "Mark")
			self:PersonalMessage(args.spellId, nil, CL.mark)
		else
			self:StackMessage(args.spellId, "blue", args.destName, amount, amount, CL.mark)
		end
	end
end

function mod:Cyclone(args)
	self:StopBar(CL.count:format(L.cyclone, cycloneCount))
	self:Message(args.spellId, "orange", CL.count:format(L.cyclone, cycloneCount))
	self:PlaySound(args.spellId, "alarm")
	cycloneCount = cycloneCount + 1
	self:CDBar(args.spellId, self:Heroic() and 75 or 86.5, CL.count:format(L.cyclone, cycloneCount))

	self:CDBar(375580, 15.8, CL.knockback) -- Zephyr Slam
end

function mod:Crosswinds(args)
	self:StopBar(CL.count:format(L.crosswinds, crosswindsCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.crosswinds, crosswindsCount))
	self:PlaySound(args.spellId, "alert")
	crosswindsCount = crosswindsCount + 1
	local cd = crosswindsCount % 2 == 0 and 40 or 46
	if self:Mythic() then
		cd = crosswindsCount % 2 == 0 and 36 or 51
	elseif self:Heroic() then
		cd = crosswindsCount % 2 == 0 and 36 or 41
	end
	self:CDBar(args.spellId, cd, CL.count:format(L.crosswinds, crosswindsCount))
end

function mod:ZephyrSlam(args)
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	self:Message(args.spellId, "purple", CL.casting:format(CL.knockback))
	if self:Tanking(bossUnit) then
		self:PlaySound(args.spellId, "alert")
	end
	self:CDBar(args.spellId, 17, CL.knockback)
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
