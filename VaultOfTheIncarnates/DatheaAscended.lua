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

local crosswindsCount = 1
local zephyrSlamCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_empowered_conductive_mark_yell = "Stack Yells"
	L.custom_on_empowered_conductive_mark_yell_desc = "Yell when you have 5 or more stacks of the Empowered Conductive Mark so players know you will spread the mark soon"
	L.marks_on_me = "%d Mark" -- {Stacks} Conductive Mark on the player
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		387849, -- Coalescing Storm

		387943, -- Diverted Essence
		381688, -- Unstable Gusts
		{385812, "TANK"}, -- Aerial Slash

		384273, -- Storm Bolt
		390450, -- Static Cling

		388302, -- Raging Burst
		{391686, "SAY"}, -- Empowered Conductive Mark
		--"custom_on_empowered_conductive_mark_yell",
		376943, -- Cyclone
		388410, -- Crosswinds
		{375580, "TANK"}, -- Zephyr Slam
		376851, -- Aerial Buffet
	}, {
		[387849] = -25952, -- Coalescing Storm
		[388302] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Log("SPELL_CAST_START", "CoalescingStorm", 387849)
	self:Log("SPELL_CAST_START", "DivertedEssence", 387943)
	self:Log("SPELL_CAST_SUCCESS", "UnstableGusts", 381688)
	self:Log("SPELL_CAST_START", "AerialSlash", 385812)
	self:Log("SPELL_CAST_START", "StormBolt", 384273)
	self:Log("SPELL_AURA_APPLIED", "StaticClingApplied", 390450)
	self:Log("SPELL_AURA_APPLIED_DOSE", "StaticClingApplied", 390450)
	self:Log("SPELL_CAST_START", "RagingBurst", 388302)
	self:Log("SPELL_AURA_APPLIED", "EmpoweredConductiveMarkApplied", 391686)
	self:Log("SPELL_AURA_APPLIED_DOSE", "EmpoweredConductiveMarkApplied", 391686)
	self:Log("SPELL_CAST_START", "Cyclone", 376943)
	self:Log("SPELL_CAST_START", "Crosswinds", 388410)
	self:Log("SPELL_CAST_START", "ZephyrSlam", 375580)
	self:Log("SPELL_AURA_APPLIED", "ZephyrSlamApplied", 375580)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ZephyrSlamApplied", 375580)
	self:Log("SPELL_CAST_START", "AerialBuffet", 376851)
end

function mod:OnEngage()
	crosswindsCount = 1
	zephyrSlamCount = 1

	self:CDBar(391686, 4) -- Empowered Conductive Mark
	self:CDBar(388302, 7) -- Raging Burst
	self:CDBar(375580, 16) -- ZephyrSlam
	self:CDBar(388410, 25) -- Crosswinds
	self:CDBar(376943, 37) -- Cyclone
	self:CDBar(387849, 75) -- Coalescing Storm
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 391595 then -- Empowered Conductive Mark
		self:CDBar(391686, 28)
	end
end

function mod:CoalescingStorm(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
	self:CDBar(args.spellId, 80)
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

function mod:UnstableGusts(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	--self:Bar(args.spellId, 10)
end

function mod:AerialSlash(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, 20)
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
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 80)
end

function mod:EmpoweredConductiveMarkApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, args.amount)
		self:PlaySound(args.spellId, "warning")
		if amount == 1 then -- Initial Say
			self:Say(args.spellId)
		-- elseif amount > 4 and self:GetOption("custom_on_empowered_conductive_mark_yell") then -- start stack yells from 5+
		-- 	self:Yell(false, L.marks_on_me:format(amount), true)
		end
	end
end

function mod:Cyclone(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, 80)
end

function mod:Crosswinds(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	crosswindsCount = crosswindsCount + 1
	self:CDBar(args.spellId, crosswindsCount % 2 == 1 and 45 or 36)
end

function mod:ZephyrSlam(args)
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
	if self:Tanking(bossUnit) then
		self:PlaySound(args.spellId, "alert")
	end
	zephyrSlamCount = zephyrSlamCount + 1
	self:CDar(args.spellId, zephyrSlamCount % 2 == 1 and 17 or 28)
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
