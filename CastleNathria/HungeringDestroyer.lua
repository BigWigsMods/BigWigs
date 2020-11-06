
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
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "GluttonousMiasmaApplied", 329298)
	self:Log("SPELL_AURA_REMOVED", "GluttonousMiasmaRemoved", 329298)
	self:Log("SPELL_CAST_START", "Consume", 334522)
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

	self:Bar(329774, 5.5) -- Overwhelm
	self:Bar(329298, 4.5, CL.count:format(self:SpellName(329298), miasmaCount)) -- Gluttonous Miasma
	self:Bar(329298, 10.2, CL.count:format(self:SpellName(329298), volatileCount)) -- Volatile Ejection
	self:Bar(329455, 22.2, CL.count:format(self:SpellName(329455), desolateCount)) -- Desolate
	self:Bar(329725, 35, CL.count:format(self:SpellName(329725), expungeCount)) -- Expunge
	self:Bar(334522, 111, CL.count:format(self:SpellName(334522), consumeCount)) -- Consume

	-- XXX Expunge tracking
	self:RegisterEvent("UNIT_AURA")
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
			self:PlaySound(args.spellId, "alarm")
		end
		if self:GetOption(gluttonousMiasmaMarker) then
			SetRaidTarget(args.destName, count)
		end
		if count == 1 then
			miasmaCount = miasmaCount + 1
		 self:Bar(args.spellId, 24, CL.count:format(args.spellName, miasmaCount))
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(args.spellName, miasmaCount-1), nil, nil, nil, playerIcons)
	end
end

function mod:GluttonousMiasmaRemoved(args)
	if self:GetOption(gluttonousMiasmaMarker) then
		SetRaidTarget(args.destName, 0)
	end
end

function mod:Consume(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, consumeCount))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 10, CL.count:format(args.spellName, consumeCount)) -- 2s Cast, 8s Channel
	consumeCount = consumeCount + 1
	self:Bar(args.spellId, 119, CL.count:format(args.spellName, consumeCount))
end

-- XXX Redo when they add events for the debuff
-- function mod:Expunge(args)
-- 	self:Message(args.spellId, "orange", CL.count:format(self:SpellName(329725), expungeCount))
-- 	self:PlaySound(args.spellId, "warning")
-- 	self:CastBar(args.spellId, 5, CL.count:format(args.spellName, expungeCount))
--	expungeCount = expungeCount + 1
-- 	self:Bar(args.spellId, 110, CL.count:format(args.spellName, expungeCount)) -- Expunge
-- end

do
	local prev = 0
	function mod:UNIT_AURA(_, unit)
		local debuffFound = self:UnitDebuff(unit, 329725) -- Expunge
		if debuffFound then
			local t = GetTime()
			if t-prev > 10 then
				prev = t
				self:Message(329725, "orange", CL.count:format(self:SpellName(329725), expungeCount)) -- Expunge
				self:PlaySound(329725, "warning")
				self:CastBar(329725, 5, CL.count:format(self:SpellName(329725), expungeCount)) -- Expunge
				expungeCount = expungeCount + 1
				self:Bar(329725, 35, CL.count:format(self:SpellName(329725), expungeCount)) -- Expunge
			end
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
			self:TargetsMessage(334266, "orange", self:ColorName(playerList), self:Mythic() and 5 or 3, nil, nil, 2)
			if self:GetOption(volatileEjectionMarker) then
				SetRaidTarget(name, count+4)
			end
		end
	end

	function mod:RAID_BOSS_WHISPER(_, msg)
		if msg:find("334064", nil, true) then -- Volatile Ejection
			self:PlaySound(334266, "warning")
			self:Flash(334266)
			self:Say(334266)
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
		self:Bar(334266, volatileCount == 3 and 12 or 35.5, CL.count:format(self:SpellName(334266), volatileCount))
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
	self:Bar(args.spellId, 60, CL.count:format(args.spellName, desolateCount)) -- Desolate
end

function mod:Overwhelm(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 11.5)
end

function mod:GrowingHungerApplied(args)
	local amount = args.amount or 1
	if amount % 3 == 0 or amount > 5 then -- 3, 6+
		self:StackMessage(args.spellId, args.destName, amount, "purple")
		self:PlaySound(args.spellId, "alert")
	end
end
