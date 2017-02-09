
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Star Augur Etraeus", 1088, 1732)
if not mod then return end
mod:RegisterEnableMob(103758)
mod.engageId = 1863
mod.respawnTime = 50

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local mobCollector = {}
local gravPullSayTimers = {}
local ejectionCount = 1
local timers = {
	-- Icy Ejection, SPELL_CAST_SUCCESS, timers vary a lot (+-2s)
	[206936] = {25, 35, 6, 6, 48, 2, 2},

	-- Fel Ejection, SPELL_CAST_SUCCESS
	[205649] = {17, 4, 4, 2, 10, 3.5, 3.5, 32, 4, 3.5, 3.5, 3.5, 22, 7.5, 17.5, 1, 2, 1.5},
}

local grandCounter = 1
local grandTimers = {
	{15, 13.4, 14}, -- P1
	{26, 44.9, 57.7}, -- P2
	{60, 43.7, 41.4}, -- P3
	{47.9, 61.3, 51.3}, -- P4
}

local worldDevouringForceCounter = 1
local worldDevouringForceTimers = {22.7, 41.7, 57.6}

local voidCount = 1

--------------------------------------------------------------------------------
-- Upvalues
--

local tDeleteItem = tDeleteItem

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.yourSign = "Your sign"
	L.with = "with"
	L[205429] = "|T1391538:15:15:0:0:64:64:4:60:4:60|t|cFFFFDD00Crab|r"
	L[205445] = "|T1391537:15:15:0:0:64:64:4:60:4:60|t|cFFFF0000Wolf|r"
	L[216345] = "|T1391536:15:15:0:0:64:64:4:60:4:60|t|cFF00FF00Hunter|r"
	L[216344] = "|T1391535:15:15:0:0:64:64:4:60:4:60|t|cFF00DDFFDragon|r"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ General ]]--
		"stages",
		221875, -- Nether Traversal

		--[[ Stage One ]]--
		206464, -- Coronal Ejection

		--[[ Stage Two ]]--
		{205984, "SAY"}, -- Gravitational Pull
		206589, -- Chilled
		{206936, "SAY", "FLASH", "PROXIMITY"}, -- Icy Ejection
		206949, -- Frigid Nova

		--[[ Stage Three ]]--
		{214167, "SAY"}, -- Gravitational Pull
		{206388, "TANK"}, -- Felburst
		206517, -- Fel Nova
		{205649, "SAY"}, -- Fel Ejection
		206398, -- Felflame

		--[[ Stage Four ]]--
		{214335, "SAY"}, -- Gravitational Pull
		207439, -- Void Nova
		222761, -- Big Bang
		216909, -- World-Devouring Force

		--[[ Thing That Should Not Be ]]--
		207720, -- Witness the Void

		--[[ Mythic ]]--
		{205408, "INFOBOX", "PROXIMITY"}, -- Grand Conjunction
	}, {
		["stages"] = "general",
		[206464] = -13033, -- Stage One
		[205984] = -13036, -- Stage Two
		[214167] = -13046, -- Stage Three
		[214335] = -13053, -- Stage Four
		[207720] = -13057, -- Thing That Should Not Be
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_CAST_START", "NetherTraversal", 221875)
	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 206398) -- Felflame
	self:Log("SPELL_AURA_APPLIED_DOSE", "GroundEffectDamage", 206398) -- Felflame

	--[[ Stage One ]]--
	self:Log("SPELL_CAST_SUCCESS", "CoronalEjection", 206464)

	--[[ Stage Two ]]--
	self:Log("SPELL_AURA_APPLIED", "GravitationalPull", 205984, 214167, 214335) -- Stage 2, Stage 3, Stage 4
	self:Log("SPELL_AURA_REMOVED", "GravitationalPullRemoved", 205984, 214167, 214335) -- Stage 2, Stage 3, Stage 4
	self:Log("SPELL_CAST_SUCCESS", "GravitationalPullSuccess", 205984, 214167, 214335) -- Stage 2, Stage 3, Stage 4
	self:Log("SPELL_AURA_APPLIED", "Chilled", 206589)
	self:Log("SPELL_CAST_SUCCESS", "IcyEjection", 206936)
	self:Log("SPELL_AURA_APPLIED", "IcyEjectionApplied", 206936)
	self:Log("SPELL_AURA_REMOVED", "IcyEjectionRemoved", 206936)
	self:Log("SPELL_CAST_START", "FrigidNova", 206949)

	--[[ Stage Three ]]--
	self:Log("SPELL_AURA_APPLIED", "Felburst", 206388)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Felburst", 206388)
	self:Log("SPELL_CAST_START", "FelNova", 206517)
	self:Log("SPELL_CAST_SUCCESS", "FelEjection", 205649)
	self:Log("SPELL_AURA_APPLIED", "FelEjectionApplied", 205649)

	--[[ Stage Four ]]--
	self:Log("SPELL_CAST_START", "VoidNova", 207439)
	self:Log("SPELL_CAST_START", "WorldDevouringForce", 216909)

	--[[ Thing That Should Not Be ]]--
	self:Log("SPELL_CAST_START", "WitnessTheVoid", 207720)
	self:Death("ThingDeath", 104880) -- Thing That Should Not Be

	--[[ Mythic ]]--
	self:Log("SPELL_CAST_START", "GrandConjunction", 205408)
	self:Log("SPELL_CAST_SUCCESS", "GrandConjunctionSuccess", 205408)
	self:Log("SPELL_AURA_APPLIED", "StarSigns", 205429, 205445, 216345, 216344) -- Star Sign: Crab, Wolf, Hunter, Dragon
	self:Log("SPELL_AURA_REMOVED", "StarSignsRemoved", 205429, 205445, 216345, 216344)

	if self:Mythic() then
		-- Experimenting with using callbacks for nameplate addons
		self:ShowFriendlyNameplates()
	end
end

function mod:OnEngage()
	phase = 1
	ejectionCount = 1
	grandCounter = 1
 	worldDevouringForceCounter = 1
	voidCount = 1
	wipe(mobCollector)
	wipe(gravPullSayTimers)
	self:Bar(206464, 12.5) -- Coronal Ejection
	self:Bar(221875, 20) -- Nether Traversal
	if self:Mythic() then
		self:CDBar(205408, 15) -- Grand Conjunction
	end
end

function mod:OnBossDisable()
	wipe(mobCollector)
	self:HideFriendlyNameplates()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 222130 then -- Phase 2 Conversation
		phase = 2
		self:Message("stages", "Neutral", "Long", "90% - ".. CL.stage:format(2), false)
		ejectionCount = 1
		self:CDBar(206936, timers[206936][ejectionCount], CL.count:format(self:SpellName(206936), ejectionCount))
		self:Bar(205984, 30) -- Gravitational Pull
		if not self:Easy() then
			self:Bar(206949, 53) -- Frigid Nova
		end
		if self:Mythic() then
			grandCounter = 1
			self:CDBar(205408, 26)
		end
	elseif spellId == 222133 then -- Phase 3 Conversation
		phase = 3
		self:Message("stages", "Neutral", "Long", "60% - ".. CL.stage:format(3), false)
		self:StopBar(CL.count:format(self:SpellName(206936, ejectionCount)))
		self:StopBar(206949) -- Frigid Nova
		ejectionCount = 1
		self:CDBar(205649, timers[205649][ejectionCount], CL.count:format(self:SpellName(205649), ejectionCount))
		self:CDBar(214167, 28) -- Gravitational Pull
		if not self:Easy() then
			self:CDBar(206517, 62) -- Fel Nova
		end
		if self:Mythic() then
			grandCounter = 1
			self:CDBar(205408, 60)
		end
	elseif spellId == 222134 then -- Phase 4 Conversation
		phase = 4
		self:Message("stages", "Neutral", "Long", "30% - ".. CL.stage:format(4), false)
		self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
		self:StopBar(CL.count:format(self:SpellName(205649, ejectionCount)))
		self:StopBar(206517) -- Fel Nova
		ejectionCount = 1
		self:CDBar(214335, 20) -- Gravitational Pull
		if not self:Easy() then
			self:CDBar(207439, 42) -- Void Nova
		end
		self:Berserk(201.5, true, nil, 222761, 222761) -- Big Bang (end of cast)
		if self:Mythic() then
			grandCounter = 1
			worldDevouringForceCounter = 1
			self:CDBar(205408, 47) -- Grand Conjunction
			self:Bar(216909, worldDevouringForceTimers[worldDevouringForceCounter]) -- World-Devouring Force
		end
	end
end

function mod:NetherTraversal(args)
	self:Bar(args.spellId, 8.5, CL.cast:format(args.spellName))
end

do
	local prev = 0
	function mod:GroundEffectDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

--[[ Stage One ]]--
function mod:CoronalEjection(args)
	self:Message(args.spellId, "Attention", "Info")
end

--[[ Stage Two ]]--
do
	local timers = {
		[205984] = 30,
		[214167] = 28,
		[214335] = 62,
	}
	function mod:GravitationalPullSuccess(args)
		-- Only show this once by using the success event
		self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, self:Tank())
		self:CDBar(args.spellId, timers[args.spellId])
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
	end
end

function mod:GravitationalPull(args)
	local _, _, _, _, _, _, expires = UnitDebuff(args.destName, args.spellName)
	local remaining = expires-GetTime()
	self:TargetBar(args.spellId, remaining, args.destName)

	if self:Me(args.destGUID) then
		gravPullSayTimers[1] = self:ScheduleTimer("Say", remaining-3, args.spellId, 3, true)
		gravPullSayTimers[2] = self:ScheduleTimer("Say", remaining-2, args.spellId, 2, true)
		gravPullSayTimers[3] = self:ScheduleTimer("Say", remaining-1, args.spellId, 1, true)
	end
end

function mod:GravitationalPullRemoved(args)
	if self:Me(args.destGUID) then
		for i = #gravPullSayTimers, 1, -1 do
			self:CancelTimer(gravPullSayTimers[i])
			gravPullSayTimers[i] = nil
		end
	end
end

function mod:IcyEjection(args)
	ejectionCount = ejectionCount + 1
	self:CDBar(args.spellId, timers[args.spellId][ejectionCount] or 30, CL.count:format(args.spellName, ejectionCount))
end

do
	local list = mod:NewTargetList()
	function mod:IcyEjectionApplied(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Attention", "Warning")
		end

		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:OpenProximity(args.spellId, 8)
			self:TargetBar(args.spellId, 10, args.destName)
			self:ScheduleTimer("Say", 7, args.spellId, 3, true)
			self:ScheduleTimer("Say", 8, args.spellId, 2, true)
			self:ScheduleTimer("Say", 9, args.spellId, 1, true)
		end
	end
end

function mod:IcyEjectionRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

function mod:FrigidNova(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:Bar(args.spellId, 4, CL.cast:format(args.spellName))
	self:CDBar(args.spellId, 60)
end

function mod:Chilled(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal")
		self:TargetBar(args.spellId, 12, args.destName)
	end
end

--[[ Stage Three ]]--
function mod:Felburst(args)
	local amount = args.amount or 1
	if amount % 2 == 1 or amount > 5 then
		self:StackMessage(args.spellId, args.destName, amount, "Important", amount > 5 and "Warning")
	end
end

function mod:FelNova(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:Bar(args.spellId, 4, CL.cast:format(args.spellName))
	self:CDBar(args.spellId, 45)
end


function mod:FelEjection(args)
	ejectionCount = ejectionCount + 1
	self:CDBar(args.spellId, timers[args.spellId][ejectionCount] or 30, CL.count:format(args.spellName, ejectionCount))
end

do
	local list = mod:NewTargetList()
	function mod:FelEjectionApplied(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Attention", "Warning")
		end

		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:TargetBar(args.spellId, 8, args.destName)
		end
	end
end

--[[ Stage Four ]]--
function mod:VoidNova(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:Bar(args.spellId, 4, CL.cast:format(args.spellName))
	self:CDBar(args.spellId, 75)
end

function mod:WorldDevouringForce(args)
	self:Message(args.spellId, "Important", "Alarm")
	worldDevouringForceCounter = worldDevouringForceCounter + 1
	local t = worldDevouringForceTimers[worldDevouringForceCounter]
	if t then
		self:Bar(args.spellId, t)
	end
end

--[[ Thing That Should Not Be ]]--
function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	for i = 1, 5 do
		local guid = UnitGUID(("boss%d"):format(i))
		if guid and not mobCollector[guid] then
			mobCollector[guid] = true
			local mobId = self:MobId(guid)
			if mobId == 104880 then -- Thing That Should Not Be
				voidCount = 1
				self:CDBar(207720, 14.5, CL.count:format(self:SpellName(207720), voidCount)) -- Witness the Void
			end
		end
	end
end

function mod:WitnessTheVoid(args)
	self:Message(args.spellId, "Attention", "Warning", CL.casting:format(CL.count:format(args.spellName, voidCount)))
	self:Bar(args.spellId, 4, CL.cast:format(CL.count:format(args.spellName, voidCount)))
	voidCount = voidCount + 1
	self:Bar(args.spellId, 14.6, CL.count:format(args.spellName, voidCount))
end

function mod:ThingDeath(args)
	self:StopBar(CL.cast:format(CL.count:format(self:SpellName(207720), voidCount-1))) -- Witness the Void Cast
	self:StopBar(CL.count:format(self:SpellName(207720), voidCount)) -- Witness the Void
end

--[[ Mythic ]]--
do
	local starSignTables = {
		[205429] = {},
		[205445] = {},
		[216345] = {},
		[216344] = {},
	}
	local mySign, scheduled, tryCount = nil, nil, 0

	function mod:GrandConjunction(args)
		grandCounter = grandCounter + 1
		self:Message(args.spellId, "Attention", "Info")
		self:Bar(args.spellId, 4, CL.cast:format(args.spellName))
		self:OpenProximity(args.spellId, 5) -- no idea if this range is reasonable

		local timer = 47 -- assumed p4 cd as default
		if grandTimers[phase][grandCounter] then -- Everything else is assumed
			timer = grandTimers[phase][grandCounter]
		elseif phase == 1 then
			timer = 14
		elseif phase == 2 then
			timer = 57
		elseif phase == 3 then
			timer = 42
		end
		self:CDBar(args.spellId, timer)

		starSignTables = {
			[205429] = {},
			[205445] = {},
			[216345] = {},
			[216344] = {},
		}
		tryCount = 0
	end

	function mod:GrandConjunctionSuccess(args)
		self:CloseProximity(args.spellId)
	end

	local function warn(self, spellId)
		tryCount = tryCount + 1
		if not mySign and tryCount < 5 then
			-- without counting, it could run endless if the same sign as ours gets
			-- removed from another player first and then from us
			scheduled = self:ScheduleTimer(warn, 0.1, self)
		else
			local list = mod:NewTargetList()
			for _,name in pairs(starSignTables[mySign]) do
				list[#list+1] = name
			end
			self:TargetMessage(205408, list, "Personal", "Warning", mySign, mySign)
			scheduled = nil
		end
	end

	local function updateInfoBox(self)
		if mySign then
			-- -------------------------
			-- | 1 Your Sign  *Crab* 2 |
			-- | 3 with      PlayerA 4 |
			-- | 5           PlayerB 6 |
			-- | 7           PlayerC 8 |
			-- | 9                  10 |
			-- -------------------------

			self:SetInfo(205408, 1, L.yourSign)
			self:SetInfo(205408, 2, L[mySign])
			self:SetInfo(205408, 3, L.with)
			self:SetInfo(205408, 4, "")
			self:SetInfo(205408, 6, "")
			self:SetInfo(205408, 8, "")

			local i = 0
			for _,name in pairs(starSignTables[mySign]) do
				if name ~= UnitName("player") then
					self:SetInfo(205408, 4+2*i, self:ColorName(name))
					i = i + 1
				end
			end

			self:OpenInfo(205408, self:SpellName(mySign))
		else
			self:CloseInfo(205408)
		end
	end

	function mod:StarSigns(args)
		self:AddPlate(args.spellId, args.destName, 10)
		starSignTables[args.spellId][#starSignTables[args.spellId]+1] = args.destName

		if self:Me(args.destGUID) then
			mySign = args.spellId
		end
		if mySign and mySign == args.spellId then
			updateInfoBox(self)
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(warn, 0.1, self)
		end
	end

	function mod:StarSignsRemoved(args)
		self:RemovePlate(args.spellId, args.destName)
		tDeleteItem(starSignTables[args.spellId], args.destName)

		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", "Info", CL.removed:format(args.spellName))
			mySign = nil
			updateInfoBox(self)
		end
		if mySign and mySign == args.spellId then -- Fewer players with our sign
			updateInfoBox(self)
			if not scheduled then
				scheduled = self:ScheduleTimer(warn, 0.1, self)
			end
		end
	end
end
