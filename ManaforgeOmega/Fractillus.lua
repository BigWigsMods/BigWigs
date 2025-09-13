
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

local shockwaveCount = 1
local shattershellCount = 1
local slamCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.crystalline_shockwave = "Walls"
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
	self:SetSpellRename(1233416, L.crystalline_shockwave) -- Crystalline Shockwave (Walls)
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
		{1233416, "ME_ONLY_EMPHASIZE"}, -- Crystalline Shockwave
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
		[1233416] = L.crystalline_shockwave, -- Crystalline Shockwave (Walls)
		[1220394] = CL.knockback, -- Shattering Backhand (Knockback)
		[1227373] = L.shattershell, -- Shattershell (Breaks)
		[1227378] = CL.rooted, -- Crystal Encasement (Rooted)
		[1231871] = L.shockwave_slam, -- Shockwave Slam (Tank Wall)
		[1232760] = L.crystal_lacerations, -- Crystal Lacerations (Bleed)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "NullConsumptionApplied", 1247424)
	self:Log("SPELL_AURA_APPLIED", "EnragedShatteringApplied", 1225673)
	self:Log("SPELL_CAST_SUCCESS", "CrystallineShockwaveSuccess", 1233411) -- Wall pre-debuffs
	self:Log("SPELL_AURA_APPLIED", "CrystallineShockwavePreDebuffs", 1233411)
	self:Log("SPELL_AURA_APPLIED", "CrystallineShockwaveApplied", 1224414) -- Wall hit debuffs
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
	shockwaveCount = 1
	shattershellCount = 1
	slamCount = 1

	self:CDBar(1233416, 7.0, CL.count:format(L.crystalline_shockwave, shockwaveCount)) -- Crystalline Shockwave Pre-Debuffs
	self:CDBar(1231871, self:Mythic() and 14.5 or 18.0, CL.count:format(L.shockwave_slam, slamCount)) -- Shockwave Slam
	self:CDBar(1227373, self:Mythic() and 32.7 or 41.0, CL.count:format(L.shattershell, shattershellCount)) -- Shattershell
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:NullConsumptionApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.bomb)
		self:PlaySound(args.spellId, "warning", nil, args.destName)
	end
end

function mod:EnragedShatteringApplied(args)
	self:Message(args.spellId, "red", CL.onboss:format(args.spellName))
	self:PlaySound(args.spellId, "warning") -- enrage/failed walls
end

function mod:CrystallineShockwaveSuccess(args)
	self:StopBar(CL.count:format(L.crystalline_shockwave, shockwaveCount))
	self:Message(1233416, "orange", CL.count:format(L.crystalline_shockwave, shockwaveCount))
	shockwaveCount = shockwaveCount + 1
	local cd = shockwaveCount % 2 == 1 and 30.5 or 20.5
	if self:Mythic() then
		cd = shockwaveCount % 2 == 1 and 25.5 or 14.5
	end
	self:CDBar(1233416, cd, CL.count:format(L.crystalline_shockwave, shockwaveCount))
end

function mod:CrystallineShockwavePreDebuffs(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(1233416, nil, L.crystalline_shockwave)
		self:PlaySound(1233416, "warning", nil, args.destName) -- Spawning Walls
	end
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
		if self:Me(args.destGUID) then
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
		self:Bar(1232130, {5.5, 12}, L.nexus_shrapnel)
	end
	local function SoundWhenNotOnMe()
		if not knockbackOnMe then
			mod:PlaySound(1227373, "long") -- take your spot before rooted
		end
	end

	function mod:ShattershellApplied(args)
		if args.time - prev > 2 then
			knockbackOnMe = false
			prev = args.time
			self:StopBar(CL.count:format(L.shattershell, shattershellCount))
			self:Message(args.spellId, "cyan", CL.count:format(L.shattershell, shattershellCount))
			shattershellCount = shattershellCount + 1
			self:CDBar(args.spellId, self:Mythic() and 40 or 51.5, CL.count:format(L.shattershell, shattershellCount))
			self:Bar(1232130, self:Mythic() and 10.5 or 12, L.nexus_shrapnel)
			self:SimpleTimer(SoundWhenNotOnMe, 0.2)
		end
		if self:Me(args.destGUID) then
			knockbackOnMe = true
			self:PersonalMessage(args.spellId, nil, L.shattershell)
			self:Bar(1220394, 8, CL.knockback)
			self:PlaySound(args.spellId, "alarm", nil, args.destName) -- getting knocked back soon
		end
	end
end

function mod:CrystalEncasementApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.rooted)
		self:PlaySound(args.spellId, "alarm", nil, args.destName) -- Rooted
	end
end


function mod:ShockwaveSlam(args)
	self:StopBar(CL.count:format(L.shockwave_slam, slamCount))
	self:Message(args.spellId, "purple", CL.count:format(L.shockwave_slam, slamCount))
	slamCount = slamCount + 1
	self:CDBar(args.spellId, self:Mythic() and 40.5 or 51.1, CL.count:format(L.shockwave_slam, slamCount))
	self:PlaySound(args.spellId, "alert")
end

function mod:ShockwaveSlamApplied(args)
	if self:Tank() then -- No need to warn others about this
		self:TargetMessage(args.spellId, "purple", args.destName)
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm", nil, args.destName) -- On you
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
		if self:Me(args.destGUID) then
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
