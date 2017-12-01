--------------------------------------------------------------------------------
-- TODO:
-- -- Raid Markers for Weigt of Darkness and/or Siphon Corruption?
-- -- Check which debuffs for Weight of Darkness are the correct ones

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Felhounds of Sargeras", nil, 1987, 1712)
if not mod then return end
mod:RegisterEnableMob(122477, 122135) -- F'harg, Shatug
mod.engageId = 2074
mod.respawnTime = 5

--------------------------------------------------------------------------------
-- Locals
--

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
		{254429, "SAY"}, -- Weight of Darkness
		244056, -- Siphon Corruption
		{248819, "SAY"}, -- Siphoned

		--[[ General ]]--
		244050, -- Destroyer's Boon
		251356, -- Focusing Power
	},{
		[251445] = -15842, -- F'harg
		[245098] = -15836, -- Shatug
		[244050] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2")

	--[[ F'harg ]]--
	self:Log("SPELL_CAST_SUCCESS", "BurningMaw", 251445)
	self:Log("SPELL_AURA_APPLIED", "MoltenTouchApplied", 244072)
	self:Log("SPELL_AURA_APPLIED", "DesolateGazeApplied", 244768)
	self:Log("SPELL_AURA_REMOVED", "DesolateGazeRemoved", 244768)
	self:Log("SPELL_CAST_SUCCESS", "EnflameCorruption", 244057)
	self:Log("SPELL_AURA_APPLIED", "Enflamed", 248815)
	self:Log("SPELL_AURA_REMOVED", "EnflamedRemoved", 248815)

	--[[ Shatug ]]--
	self:Log("SPELL_CAST_SUCCESS", "CorruptingMaw", 245098)
	self:Log("SPELL_AURA_APPLIED", "WeightofDarknessApplied", 254429)
	self:Log("SPELL_AURA_REMOVED", "WeightofDarknessRemoved", 254429)
	self:Log("SPELL_CAST_SUCCESS", "SiphonCorruption", 244056)
	self:Log("SPELL_AURA_APPLIED", "Siphoned", 248819)
	self:Log("SPELL_AURA_REMOVED", "SiphonedRemoved", 248819)

	--[[ General ]]--
	self:Log("SPELL_AURA_APPLIED", "SargerasBlessing", 246057) -- Destroyer's Boon buff
	self:Log("SPELL_AURA_APPLIED", "FocusingPower", 251356)
end

function mod:OnEngage()
	self:CDBar(251445, 10.5) -- Burning Maw
	self:CDBar(245098, 10.5) -- Corrupting Maw
	self:Bar(244072, 20) -- Molten Touch
	self:Bar(244056, 28) -- Siphon Corruption
	self:Bar(244057, 52) -- Enflame Corruption
	self:Bar(244131, 52.5) -- Consuming Sphere
	self:Bar(254429, 78) -- Weight of Darkness
	self:Bar(244768, 84.5) -- Desolate Gaze
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, spellName, _, _, spellId)
	if spellId == 244159 then -- Consuming Sphere
		self:Message(244131, "Attention", "Alert")
		self:Bar(244131, 78.5)
	elseif spellId == 244069 then -- Weight of Darkness
		self:Bar(254429, 78.5)
	elseif spellId == 244064 then -- Desolate Gaze
		self:Bar(244768, 96.5)
	end
end

function mod:BurningMaw(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:CDBar(args.spellId, 10.5)
end

do
	local playerList = mod:NewTargetList()
	function mod:MoltenTouchApplied(args)
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:Bar(args.spellId, 96.5)
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Attention", "Warning")
		end
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:DesolateGazeApplied(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 8)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Urgent", "Warning", nil, nil, true)
		end
	end
end

function mod:DesolateGazeRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:EnflameCorruption(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:Bar(args.spellId, 95.5)
	self:CastBar(args.spellId, 9)
end

function mod:Enflamed(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Warning")
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 4)
	end
end

function mod:EnflamedRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:CorruptingMaw(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:CDBar(args.spellId, 10.5)
end

do
	local playerList = mod:NewTargetList()
	function mod:WeightofDarknessApplied(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 5)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Urgent", "Warning", nil, nil, true)
		end
	end
end

function mod:WeightofDarknessRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:SiphonCorruption(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:Bar(args.spellId, 78.5)
	self:CastBar(args.spellId, 9)
end

function mod:Siphoned(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Warning")
		self:SayCountdown(args.spellId, 4)
	end
end

function mod:SiphonedRemoved(args)
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
			self:Message(244050, "Urgent", "Warning", args.spellName, args.spellId)
		end
	end
end

-- XXX Only on pull?
function mod:FocusingPower(args)
	self:TargetMessage(args.spellId, args.destName, "Neutral", "Info")
	self:TargetBar(args.spellId, 15, args.destName)
end
