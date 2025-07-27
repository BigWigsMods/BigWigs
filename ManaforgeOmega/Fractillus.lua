if not BigWigsLoader.isTestBuild then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Fractillus", 2810, 2747)
if not mod then return end
mod:RegisterEnableMob(237861) -- Fractillus
mod:SetEncounterID(3133)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local conjunctionCount = 1
local crystallizationCount = 1
local slamCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.crystalline_eruption = "Walls"
	L.shattershell = "Breaks"
	L.shockwave_slam = "Tank Wall"
	L.nexus_shrapnel = "Shrapnel Lands"
	L.crystal_lacerations = "Bleed"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:SetSpellRename(1247424, CL.bomb) -- Null Consumption (Bomb)
	self:SetSpellRename(1232130, L.nexus_shrapnel) -- Nexus Shrapnel (Shrapnel Lands)
	self:SetSpellRename(1233416, L.crystalline_eruption) -- Crystalline Eruption (Walls)
	self:SetSpellRename(1220394, CL.knockback) -- Shattering Backhand (Knockback)
	self:SetSpellRename(1227373, L.shattershell) -- Shattershell (Breaks)
	self:SetSpellRename(1227378, CL.rooted) -- Crystal Encasement (Rooted)
	self:SetSpellRename(1231871, L.shockwave_slam) -- Shockwave Slam (Tank Wall)
	self:SetSpellRename(1232760, L.crystal_lacerations) -- Crystal Lacerations (Bleed)
end

function mod:GetOptions()
	return {
		1232130, -- Nexus Shrapnel
		{1247424, "ME_ONLY_EMPHASIZE"}, -- Null Consumption
		1225673, -- Enraged Shattering
		{1233416, "ME_ONLY_EMPHASIZE"}, -- Crystalline Eruption
			1224414, -- Crystalline Shockwave
		{1220394, "COUNTDOWN"}, -- Shattering Backhand
		{1227373, "ME_ONLY_EMPHASIZE"}, -- Shattershell
			1227378, -- Crystal Encasement
		1231871, -- Shockwave Slam
		-- Mythic
		1232760, -- Crystal Lacerations
	},{
		[1232760] = "mythic",
	},{
		[1247424] = CL.bomb, -- Null Consumption (Bomb)
		[1232130] = L.nexus_shrapnel, -- Nexus Shrapnel (Shrapnel Lands)
		[1233416] = L.crystalline_eruption, -- Crystalline Eruption (Walls)
		[1220394] = CL.knockback, -- Shattering Backhand (Knockback)
		[1227373] = L.shattershell, -- Shattershell (Breaks)
		[1227378] = CL.rooted, -- Crystal Encasement (Rooted)
		[1231871] = L.shockwave_slam, -- Shockwave Slam (Tank Wall)
		[1232760] = L.crystal_lacerations, -- Crystal Lacerations (Bleed)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:RegisterUnitEvent("UNIT_AURA", nil, "player") -- Crystalline Eruption Debuffs
	self:Log("SPELL_AURA_APPLIED", "NullConsumptionApplied", 1247424)
	-- self:Log("SPELL_AURA_REMOVED", "NullConsumptionRemoved", 1247424)
	-- self:Log("SPELL_CAST_START", "CrystallineEruption", 1233416) -- debuffs are applied way before this and not logged, using USCS for applications
	self:Log("SPELL_AURA_APPLIED", "EnragedShatteringApplied", 1225673)
	self:Log("SPELL_AURA_APPLIED", "CrystallineShockwaveApplied", 1224414)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrystallineShockwaveApplied", 1224414)
	self:Log("SPELL_CAST_START", "ShatteringBackhand", 1220394)
	self:Log("SPELL_AURA_APPLIED", "ShattershellApplied", 1227373)
	self:Log("SPELL_AURA_APPLIED", "CrystalEncasementApplied", 1227378)
	self:Log("SPELL_CAST_START", "ShockwaveSlam", 1231871)
	self:Log("SPELL_AURA_APPLIED", "ShockwaveSlamApplied", 1231871)
	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "CrystalLacerationsApplied", 1232760)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrystalLacerationsApplied", 1232760)
end

function mod:OnEngage()
	conjunctionCount = 1
	crystallizationCount = 1
	slamCount = 1

	self:Bar(1233416, self:Mythic() and 7.0 or 3, CL.count:format(L.crystalline_eruption, conjunctionCount)) -- Crystalline Eruption
	self:Bar(1231871, self:Mythic() and 23.0 or 16, CL.count:format(L.shockwave_slam, slamCount)) -- Shockwave Slam
	self:Bar(1227373, self:Mythic() and 41.0 or 32.2, CL.count:format(L.shattershell, crystallizationCount)) -- Nether Crystallization
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 1233411 then -- Crystalline Eruption
		self:EntropicConjunctionApplied()
	end
end

do
	local applied = false
	function mod:UNIT_AURA()
		local hasAura = self:GetPlayerAura(1233411) -- Crystalline Eruption
		if hasAura and not applied then
			applied = true
			self:PersonalMessage(1233416, nil, L.crystalline_eruption)
			self:PlaySound(1233416, "warning") -- Spawning Walls
		elseif not hasAura and applied then
			applied = false
		end
	end
end

function mod:NullConsumptionApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.bomb)
		self:PlaySound(args.spellId, "warning")
		-- too many ppl get things, lets not do say messages. There is decent visuals.
		-- self:Say(args.spellId, CL.bomb, nil, "Bomb")
		-- self:SayCountdown(args.spellId, 6)
	end
end

-- function mod:NullConsumptionRemoved(args)
-- 	if self:Me(args.destGUID) then
-- 		self:CancelSayCountdown(args.spellId)
-- 	end
-- end

function mod:EnragedShatteringApplied(args)
	self:Message(args.spellId, "red", CL.onboss:format(args.spellName))
	self:PlaySound(args.spellId, "warning") -- enrage/failed walls
end

function mod:EntropicConjunctionApplied()
	self:StopBar(CL.count:format(L.crystalline_eruption, conjunctionCount))
	self:Message(1233416, "orange", CL.count:format(L.crystalline_eruption, conjunctionCount))
	-- self:PlaySound(1233416, "alert")
	conjunctionCount = conjunctionCount + 1
	local cd = 16
	if self:Mythic() then
		cd = conjunctionCount % 2 == 1 and 30 or 20
	end
	self:CDBar(1233416, cd, CL.count:format(L.crystalline_eruption, conjunctionCount))
end

do
	local playerName = mod:UnitName("player")
	local scheduled = nil
	local stacksOnMe = 0

	function mod:EntropicShockwaveStacks() -- self warnings only
		self:StackMessage(1224414, "blue", playerName, stacksOnMe, 1)
		self:PlaySound(1224414, "warning")
	end

	function mod:CrystallineShockwaveApplied(args)
		if self:Me(args.destGUID)  then
			if scheduled then
				self:CancelTimer(scheduled)
				scheduled = nil
			end
			stacksOnMe = args.amount or 1
			if not scheduled then
				scheduled = self:ScheduleTimer("EntropicShockwaveStacks", 0.2)
			end
		end
	end
end

do
	local prev = 0
	local knockbackOnMe = false
	function mod:ShatteringBackhand()
			if knockbackOnMe then
				self:Bar(1220394, {2.5, 9}, CL.knockback)
			end
			self:Bar(1232130, {5.5, 12}, L.nexus_shrapnel)
	end

	function mod:ShattershellApplied(args)
		if args.time - prev > 2 then
			knockbackOnMe = false
			prev = args.time
			self:Message(args.spellId, "cyan", CL.count:format(L.shattershell, crystallizationCount))
			self:PlaySound(args.spellId, "long") -- take your spot before rooted
			crystallizationCount = crystallizationCount + 1
			self:Bar(args.spellId, self:Mythic() and 50.5 or 40, CL.count:format(L.shattershell, crystallizationCount))
			self:Bar(1232130, 12,  L.nexus_shrapnel)
		end
		if self:Me(args.destGUID) then
			knockbackOnMe = true
			self:PersonalMessage(args.spellId, nil, L.shattershell)
			self:PlaySound(args.spellId, "alarm") -- getting knocked back soon
			self:Bar(1220394, 9, CL.knockback)
		end
	end
end

function mod:CrystalEncasementApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.rooted)
		self:PlaySound(args.spellId, "alarm") -- Rooted
	end
end


function mod:ShockwaveSlam(args)
	self:StopBar(CL.count:format(L.shockwave_slam, slamCount))
	self:Message(args.spellId, "purple", CL.count:format(L.shockwave_slam, slamCount))
	self:PlaySound(args.spellId, "alert")
	slamCount = slamCount + 1
	self:Bar(args.spellId, self:Mythic() and 50.5 or 40, CL.count:format(L.shockwave_slam, slamCount))
end

function mod:ShockwaveSlamApplied(args)
	if self:Tank() then -- No need to warn others about this
		self:TargetMessage(args.spellId, "purple", args.destName)
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm") -- On you
		else
			self:PlaySound(args.spellId, "warning") -- tankswap
		end
	end
end

-- Mythic
do
	local playerName = mod:UnitName("player")
	local scheduled = nil
	local stacksOnMe = 0

	function mod:CrystalLacerationsStacks() -- self warnings only
		self:StackMessage(1232760, "blue", playerName, stacksOnMe, 3, L.crystal_lacerations)
	end

	function mod:CrystalLacerationsApplied(args)
		if self:Me(args.destGUID)  then
			if scheduled then
				self:CancelTimer(scheduled)
				scheduled = nil
			end
			stacksOnMe = args.amount or 1
			if not scheduled then
				scheduled = self:ScheduleTimer("CrystalLacerationsStacks", 0.1)
			end
		end
	end
end
