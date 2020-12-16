--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Hungering Destroyer", 2296, 2428)
if not mod then return end
mod:RegisterEnableMob(164261) -- Hungering Destroyer
mod.engageId = 2383
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local miasmaCount = 1
local volatileCount = 1
local consumeCount = 1
local expungeCount = 1
local desolateCount = 1
local overwhelmCount = 1
local miasmaMarkClear = {}

--------------------------------------------------------------------------------
-- Initialization
--

local gluttonousMiasmaMarker = mod:AddMarkerOption(false, "player", 1, 329298, 1, 2, 3, 4) -- Gluttonous Miasma
local volatileEjectionMarker = mod:AddMarkerOption(false, "player", 1, 334266, 5, 6, 7, 8) -- Volatile Ejection
function mod:GetOptions()
	return {
		{329298, "SAY"}, -- Gluttonous Miasma
		gluttonousMiasmaMarker,
		334522, -- Consume
		329725, -- Expunge
		{334266, "SAY", "FLASH"}, -- Volatile Ejection
		volatileEjectionMarker,
		329455, -- Desolate
		{329774, "TANK"}, -- Overwhelm
		{332295, "TANK"}, -- Growing Hunger
	}, nil, {
		[334266] = CL.laser, -- Volatile Ejection (Laser)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "GluttonousMiasmaApplied", 329298)
	self:Log("SPELL_CAST_START", "Consume", 334522)
	self:Log("SPELL_CAST_SUCCESS", "ConsumeSuccess", 334522)
	-- self:Log("SPELL_AURA_APPLIED", "ExpungeApplied", 329725)
	self:RegisterEvent("RAID_BOSS_WHISPER")
	self:RegisterMessage("BigWigs_BossComm") -- Syncing for Volatile Ejection targets
	self:Log("SPELL_CAST_START", "VolatileEjection", 334266)
	self:Log("SPELL_CAST_SUCCESS", "VolatileEjectionSuccess", 334266)
	self:Log("SPELL_CAST_START", "Desolate", 329455)
	self:Log("SPELL_CAST_START", "Overwhelm", 329774)
	self:Log("SPELL_AURA_APPLIED", "GrowingHungerApplied", 332295)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GrowingHungerApplied", 332295)
end

function mod:OnEngage()
	miasmaCount = 1
	volatileCount = 1
	consumeCount = 1
	expungeCount = 1
	desolateCount = 1
	overwhelmCount = 1

	self:Bar(329298, 3, CL.count:format(self:SpellName(329298), miasmaCount)) -- Gluttonous Miasma
	if self:Easy() then
		self:Bar(329774, 5.3) -- Overwhelm
		self:Bar(334266, 10.6, CL.count:format(self:SpellName(334266), volatileCount)) -- Volatile Ejection
		self:Bar(329455, 23.2, CL.count:format(self:SpellName(329455), desolateCount)) -- Desolate
		self:Bar(329725, 35.7, CL.count:format(self:SpellName(329725), expungeCount)) -- Expunge
		self:Bar(334522, 93.7, CL.count:format(self:SpellName(334522), consumeCount)) -- Consume
	else
		self:Bar(329774, 5) -- Overwhelm
		self:Bar(334266, 10, CL.count:format(self:SpellName(334266), volatileCount)) -- Volatile Ejection
		self:Bar(329455, 22, CL.count:format(self:SpellName(329455), desolateCount)) -- Desolate
		self:Bar(329725, 32, CL.count:format(self:SpellName(329725), expungeCount)) -- Expunge
		self:Bar(334522, 89, CL.count:format(self:SpellName(334522), consumeCount)) -- Consume
	end

	-- XXX Expunge tracking
	self:RegisterEvent("UNIT_AURA")
end

function mod:OnBossDisable()
	if self:GetOption(gluttonousMiasmaMarker) then
		for i = 1, #miasmaMarkClear do
			local n = miasmaMarkClear[i]
			-- Clearing marks on _REMOVED doesn't work great on this boss
			-- The second set of marks is applied before the first is removed
			-- When trying to remove the first set of marks it can clear the second set
			SetRaidTarget(n, 0)
		end
		miasmaMarkClear = {}
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local playerList, playerIcons = mod:NewTargetList(), {}
	function mod:GluttonousMiasmaApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerIcons[count] = count
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.count_rticon:format(args.spellName, count, count)) 
			-- XXX Add some kind of health % say / yell messages when you are low, 
			-- XXX this initial application doesn't change too much and clutters instead of the Laser says.
			self:PlaySound(args.spellId, "alarm")
		end
		if self:GetOption(gluttonousMiasmaMarker) then
			SetRaidTarget(args.destName, count)
		end
		if count == 1 then
			miasmaMarkClear = {}
			miasmaCount = miasmaCount + 1
		 self:Bar(args.spellId, 24, CL.count:format(args.spellName, miasmaCount))
		end
		miasmaMarkClear[count] = args.destName -- For clearing marks OnBossDisable
		self:TargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(args.spellName, miasmaCount-1), nil, nil, playerIcons)
	end
end

function mod:Consume(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, consumeCount))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 4, CL.count:format(args.spellName, consumeCount)) -- 4s Cast
	consumeCount = consumeCount + 1
	if self:Easy() then
		self:Bar(args.spellId, 101, CL.count:format(args.spellName, consumeCount))
	else
		self:Bar(args.spellId, 96, CL.count:format(args.spellName, consumeCount))
	end
end

function mod:ConsumeSuccess(args)
	self:CastBar(args.spellId, 6, CL.count:format(args.spellName, consumeCount-1)) -- 6s Channel
end

-- XXX Redo when they add events for the debuff
-- function mod:Expunge(args)
-- 	self:Message(args.spellId, "orange", CL.count:format(self:SpellName(329725), expungeCount))
-- 	self:PlaySound(args.spellId, "warning")
-- 	self:CastBar(args.spellId, 5, CL.count:format(args.spellName, expungeCount))
--	expungeCount = expungeCount + 1
-- 	self:Bar(args.spellId, 110, CL.count:format(args.spellName, expungeCount)) -- Expunge
-- end

function mod:UNIT_AURA(_, unit)
	local debuffFound = self:UnitDebuff(unit, 329725) -- Expunge
	if debuffFound then
		self:UnregisterEvent("UNIT_AURA")
		self:ScheduleTimer("RegisterEvent", 10, "UNIT_AURA")
		self:Message(329725, "orange", CL.count:format(self:SpellName(329725), expungeCount)) -- Expunge
		self:PlaySound(329725, "warning")
		self:CastBar(329725, 5, CL.count:format(self:SpellName(329725), expungeCount)) -- Expunge
		expungeCount = expungeCount + 1
		if self:Easy() then
			self:Bar(329725, expungeCount % 2 == 0 and 37.8 or 63, CL.count:format(self:SpellName(329725), expungeCount)) -- Expunge
		else
			self:Bar(329725, expungeCount % 2 == 0 and 36 or 60, CL.count:format(self:SpellName(329725), expungeCount)) -- Expunge
		end
	end
end

-- XXX Hopefully some debuff is added
-- do
-- 	local playerList = mod:NewTargetList()
-- 	function mod:VolatileEjectionApplied(args)
-- 		playerList[#playerList+1] = args.destName
-- 		if self:Me(args.destGUID) then
-- 			self:Say(args.spellId)
-- 			self:SayCountdown(args.spellId, 4)
-- 			self:Flash(args.spellId)
-- 			self:PlaySound(args.spellId, "warning")
-- 		end
-- 		self:TargetsMessage(args.spellId, "orange", playerList)
-- 	end
--
-- 	function mod:VolatileEjectionRemoved(args)
-- 		if self:Me(args.destGUID) then
-- 			self:CancelSayCountdown(args.spellId)
-- 		end
-- 	end
-- end

do
	local playerList = {}
	local function addPlayerToList(self, name)
		if not tContains(playerList, name) then
			local count = #playerList+1
			playerList[count] = name
			self:TargetsMessage(334266, "orange", self:ColorName(playerList), self:Mythic() and 5 or 3, CL.laser, nil, 2)
			if self:GetOption(volatileEjectionMarker) then
				SetRaidTarget(name, count+4)
			end
		end
	end

	function mod:RAID_BOSS_WHISPER(_, msg)
		if msg:find("334064", nil, true) then -- Volatile Ejection
			self:PlaySound(334266, "warning")
			self:Flash(334266)
			self:Say(334266, CL.laser)
			self:Sync("VolatileEjectionTarget")
		end
	end

	function mod:BigWigs_BossComm(_, msg, _, name)
		if msg == "VolatileEjectionTarget" then
			addPlayerToList(self, name)
		end
	end

	function mod:VolatileEjection(args)
		volatileCount = volatileCount + 1
		if self:Easy() then
			self:Bar(334266, volatileCount % 3 == 1 and 25.3 or 37.9, CL.count:format(CL.laser, volatileCount))
		else
			self:Bar(334266, volatileCount % 3 == 1 and 24 or 36, CL.count:format(CL.laser, volatileCount))
		end
	end

	function mod:VolatileEjectionSuccess(args)
		if self:GetOption(volatileEjectionMarker) then
			for _, name in pairs(playerList) do
				SetRaidTarget(name, 0)
			end
		end
		playerList = {}
	end
end

function mod:Desolate(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, desolateCount))
	self:PlaySound(args.spellId, "alert")
	desolateCount = desolateCount + 1
	if self:Easy() then
		self:Bar(args.spellId, desolateCount % 2 == 0 and 37.9 or 63.1, CL.count:format(args.spellName, desolateCount)) -- Desolate
	else
		self:Bar(args.spellId, desolateCount % 2 == 0 and 36 or 60, CL.count:format(args.spellName, desolateCount)) -- Desolate
	end
end

function mod:Overwhelm(args)
	self:TargetMessage(args.spellId, "purple", self:UnitName("boss1target"), CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "warning")
	overwhelmCount = overwhelmCount + 1
	if self:Easy() then
		self:Bar(args.spellId, overwhelmCount % 7 == 1 and 25.2 or 12.6) -- Delayed by Consume every 7th
	else
		self:Bar(args.spellId, overwhelmCount % 7 == 1 and 24 or 12) -- Delayed by Consume every 7th
	end
end

function mod:GrowingHungerApplied(args)
	local amount = args.amount or 1
	if amount % 5 == 0 then -- 5, 10... // Generally doesn't go above 5 if you swap on Overwhelm
		self:StackMessage(args.spellId, args.destName, amount, "purple")
		self:PlaySound(args.spellId, "alert")
	end
end
