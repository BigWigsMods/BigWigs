if not IsTestBuild() then return end -- XXX dont load on live

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Felhounds of Sargeras", nil, 1987, 1712)
if not mod then return end
mod:RegisterEnableMob(126916, 126915) -- F'harg, Shatug
mod.engageId = 2074
--mod.respawnTime = 30

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
		249227, -- Molten Touch
		{244768, "SAY"}, -- Desolate Gaze
		244057, -- Enflame Corruption
		{248815, "SAY"}, -- Enflamed

		--[[ Shatug ]]--
		245098, -- Corrupting Maw
		244131, -- Consuming Sphere
		{244069, "SAY", "ICON"}, -- Weight of Darkness
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
	--[[ F'harg ]]--
	self:Log("SPELL_CAST_SUCCESS", "BurningMaw", 251445)
	self:Log("SPELL_CAST_SUCCESS", "MoltenTouch", 249227)
	self:Log("SPELL_AURA_APPLIED", "DesolateGaze", 244768)
	self:Log("SPELL_CAST_SUCCESS", "EnflameCorruption", 244057)
	self:Log("SPELL_AURA_APPLIED", "Enflamed", 248815)
	self:Log("SPELL_AURA_REMOVED", "EnflamedRemoved", 248815)

	--[[ Shatug ]]--
	self:Log("SPELL_CAST_SUCCESS", "CorruptingMaw", 245098)
	self:Log("SPELL_CAST_SUCCESS", "ConsumingSphere", 244131)
	self:Log("SPELL_AURA_APPLIED", "WeightofDarkness", 244069)
	self:Log("SPELL_AURA_REMOVED", "WeightofDarknessRemoved", 244069)
	self:Log("SPELL_CAST_SUCCESS", "SiphonCorruption", 244056)
	self:Log("SPELL_AURA_APPLIED", "Siphoned", 248819)
	self:Log("SPELL_AURA_REMOVED", "SiphonedRemoved", 248819)

	--[[ General ]]--
	self:Log("SPELL_AURA_APPLIED", "SargerasBlessing", 246057) -- Destroyer's Boon buff
	self:Log("SPELL_AURA_APPLIED", "FocusingPower", 251356)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BurningMaw(args)
	self:Message(args.spellId, "Important", "Alarm")
end

function mod:MoltenTouch(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:DesolateGaze(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
end

function mod:EnflameCorruption(args)
	self:Message(args.spellId, "Attention", "Alert")
end

do
	local playerList = mod:NewTargetList()
	function mod:Enflamed(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 4)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Important", "Warning")
		end
	end
end

function mod:EnflamedRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:CorruptingMaw(args)
	self:Message(args.spellId, "Important", "Alarm")
end

function mod:ConsumingSphere(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:WeightofDarkness(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, true)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 5)
	end
	self:PrimaryIcon(args.spellId, args.destName)
end

function mod:WeightofDarknessRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	self:PrimaryIcon(args.spellId)
end

function mod:SiphonCorruption(args)
	self:Message(args.spellId, "Attention", "Alert")
end

do
	local playerList = mod:NewTargetList()
	function mod:Siphoned(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 4)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Important", "Warning")
		end
	end
end

function mod:SiphonedRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:SargerasBlessing(args)
	self:Message(244050, "Urgent", "Warning", args.spellName, args.spellId)
end

function mod:FocusingPower(args)
	self:TargetMessage(args.spellId, args.destName, "Neutral", "Info")
	self:TargetBar(args.spellId, 15, args.destName)
end
