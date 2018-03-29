
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Felhounds of Sargeras", 1712, 1987)
if not mod then return end
mod:RegisterEnableMob(122477, 122135) -- F'harg, Shatug
mod.engageId = 2074
mod.respawnTime = 29

--------------------------------------------------------------------------------
-- Locals
--

local moltenTouchCount = 0
local enflameCorruptionCount = 0
local siphonCorruptionCount = 0
local weightofDarknessCount = 0
local consumingSphereCount = 0

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ F'harg ]]--
		251445, -- Burning Maw
		244072, -- Molten Touch
		{244768, "SAY"}, -- Desolate Gaze
		244057, -- Enflame Corruption
		{248815, "SAY"}, -- Enflamed

		--[[ Shatug ]]--
		245098, -- Corrupting Maw
		244131, -- Consuming Sphere
		{254429, "SAY", "FLASH"}, -- Weight of Darkness
		244056, -- Siphon Corruption
		{248819, "SAY"}, -- Siphoned

		--[[ General ]]--
		244050, -- Destroyer's Boon
		251356, -- Focusing Power

		--[[ Mythic ]]--
		244054, -- Flametouched
		244055, -- Shadowtouched
		245022, -- Burning Remnant
	},{
		[251445] = -15842, -- F'harg
		[245098] = -15836, -- Shatug
		[244050] = "general",
		[244054] = "mythic",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2")

	--[[ F'harg ]]--
	self:Log("SPELL_CAST_SUCCESS", "BurningMaw", 251445)
	self:Log("SPELL_CAST_SUCCESS", "MoltenTouch", 244072)
	self:Log("SPELL_AURA_APPLIED", "MoltenTouchApplied", 244072)
	self:Log("SPELL_AURA_APPLIED", "DesolateGazeApplied", 244768)
	self:Log("SPELL_AURA_REMOVED", "DesolateGazeRemoved", 244768)
	self:Log("SPELL_CAST_SUCCESS", "EnflameCorruption", 244057)

	--[[ Shatug ]]--
	self:Log("SPELL_CAST_SUCCESS", "CorruptingMaw", 245098)
	self:Log("SPELL_AURA_APPLIED", "WeightofDarknessApplied", 254429)
	self:Log("SPELL_AURA_REMOVED", "WeightofDarknessRemoved", 254429)
	self:Log("SPELL_CAST_SUCCESS", "SiphonCorruption", 244056)

	--[[ General ]]--
	self:Log("SPELL_AURA_APPLIED", "EnflamedOrSiphoned", 248815, 248819) -- Enflamed, Siphoned
	self:Log("SPELL_AURA_REMOVED", "EnflamedOrSiphonedRemoved", 248815, 248819) -- Enflamed, Siphoned
	self:Log("SPELL_AURA_APPLIED", "SargerasBlessing", 246057) -- Destroyer's Boon buff
	self:Log("SPELL_AURA_APPLIED", "FocusingPower", 251356)

	--[[ Mythic ]]--
	self:Log("SPELL_AURA_APPLIED", "Touched", 244054, 244055)

	self:Log("SPELL_AURA_APPLIED", "BurningRemnant", 245022)
	self:Log("SPELL_PERIODIC_DAMAGE", "BurningRemnant", 245022)
	self:Log("SPELL_PERIODIC_MISSED", "BurningRemnant", 245022)
end

function mod:OnEngage()
	moltenTouchCount = 1
	enflameCorruptionCount = 1
	siphonCorruptionCount = 1
	weightofDarknessCount = 1
	consumingSphereCount = 1

	local mythic, easy = self:Mythic(), self:Easy()

	self:CDBar(251445, mythic and 10.9 or 10.5) -- Burning Maw
	self:CDBar(245098, mythic and 10.9 or 10.5) -- Corrupting Maw
	self:Bar(244056, mythic and 26.5 or easy and 29 or 28) -- Siphon Corruption
	self:Bar(244057, mythic and 49.6 or easy and 56 or 52) -- Enflame Corruption
	self:Bar(244131, mythic and 49 or easy and 54.5 or 52.5) -- Consuming Sphere
	self:Bar(244768, mythic and 77.5 or easy and 89 or 84.5) -- Desolate Gaze

	if not easy then
		self:Bar(244072, mythic and 18 or 20) -- Molten Touch
		self:Bar(254429, mythic and 73 or 78) -- Weight of Darkness
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
	if spellId == 244159 then -- Consuming Sphere
		self:Message(244131, "yellow", "Alert")
		consumingSphereCount = consumingSphereCount + 1
		self:Bar(244131, self:Mythic() and (consumingSphereCount % 2 == 1 and 86 or 72.5) or self:Easy() and 85 or 78.5)
	elseif spellId == 244069 then -- Weight of Darkness
		weightofDarknessCount = weightofDarknessCount + 1
		self:Flash(254429)
		self:Message(254429, "orange", "Warning")
		self:Bar(254429, self:Mythic() and (weightofDarknessCount % 2 == 1 and 72.5 or 86) or 78.5)
	elseif spellId == 244064 then -- Desolate Gaze
		self:Bar(244768, self:Mythic() and 103 or self:Easy() and 104 or 96.5)
	end
end

function mod:BurningMaw(args)
	self:Message(args.spellId, "red", "Alarm")
	self:CDBar(args.spellId, self:Mythic() and 10.9 or 11)
end

function mod:MoltenTouch(args)
	moltenTouchCount = moltenTouchCount + 1
	if self:Mythic() then
		self:Bar(args.spellId, moltenTouchCount % 2 == 1 and 103.3 or 88.8)
	else
		self:Bar(args.spellId, 96.5)
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:MoltenTouchApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "Warning")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, 3)
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:DesolateGazeApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 8)
		end
		self:PlaySound(args.spellId, "Warning", nil, playerList)
		self:TargetsMessage(args.spellId, "orange", playerList, 5)
	end
end

function mod:DesolateGazeRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:EnflameCorruption(args)
	self:Message(args.spellId, "yellow", "Alert")
	enflameCorruptionCount = enflameCorruptionCount + 1
	self:Bar(args.spellId, self:Mythic() and (enflameCorruptionCount % 2 == 1 and 88.8 or 104.6) or self:Easy() and 104 or 95.5)
	self:CastBar(args.spellId, 9)
end

function mod:CorruptingMaw(args)
	self:Message(args.spellId, "red", "Alarm")
	self:CDBar(args.spellId, self:Mythic() and 10.9 or 11)
end

function mod:WeightofDarknessApplied(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 5)
	end
end

function mod:WeightofDarknessRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:SiphonCorruption(args)
	self:Message(args.spellId, "yellow", "Alert")
	siphonCorruptionCount = siphonCorruptionCount + 1
	self:Bar(args.spellId, self:Mythic() and (siphonCorruptionCount % 2 == 1 and 86.3 or 73) or self:Easy() and 85 or 78.5)
	self:CastBar(args.spellId, 9)
end

function mod:EnflamedOrSiphoned(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "Warning")
		self:TargetMessage2(args.spellId, "blue", args.destName)
		self:Say(args.spellId)
		if self:Mythic() then
			self:SayCountdown(args.spellId, 3, nil, 2)
		else
			self:SayCountdown(args.spellId, 4)
		end
	end
end

function mod:EnflamedOrSiphonedRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

do
	local prev = 0
	function mod:SargerasBlessing(args)
		local t = GetTime()
		if t-prev > 0.5 then
			prev = t
			self:Message(244050, "orange", "Warning", args.spellName, args.spellId)
		end
	end
end

do
	local prev = 0
	function mod:FocusingPower(args)
		local t = GetTime()
		if t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "cyan", "Info")
			self:Bar(args.spellId, 15)
		end
	end
end

--[[ Mythic ]]--
function mod:Touched(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, args.spellId == 244054 and "red" or "blue", "Warning", CL.you:format(args.spellName)) -- Red for Flame, Blue for Shadow
	end
end

do
	local prev = 0
	function mod:BurningRemnant(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "Alert")
				self:TargetMessage2(args.spellId, "blue", args.destName, true)
			end
		end
	end
end
