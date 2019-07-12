--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lady Ashvane", 2164, 2354)
if not mod then return end
mod:RegisterEnableMob(152236) -- Priscilla Ashvane
mod.engageId = 2304
--mod.respawnTime = 31

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local barnacleBashCount = 1
local nextCarapace = 0
local arcingAzeriteCount = 1
local raidList = {}

local function UpdateRaidList()
	raidList = {}
	for id = 1,30 do
		local unit = "raid"..id
		local name = mod:UnitName(unit)
		if name then
			raidList[name] = id
		end
	end
end

--------------------------------------------------------------------------------
-- Initialization
--

local arcingAzeriteMarker = mod:AddMarkerOption(false, "player", 1, -20096, 1, 4, 7, 2, 6, 3) -- Arcing Azerite
function mod:GetOptions()
	return {
		"stages",
		296662, -- Rippling Wave
		{297397, "SAY", "SAY_COUNTDOWN", "FLASH"}, -- Briny Bubble
		298056, -- Upsurge
		{296725, "TANK"}, -- Barnacle Bash
		{-20096, "FLASH"}, -- Arcing Azerite
		arcingAzeriteMarker,
	},{
		[296569] = CL.stage:format(1),
		[-20096] = CL.stage:format(2),
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "RipplingWave", 296662)
	self:Log("SPELL_AURA_APPLIED", "BrinyBubbleApplied", 302992, 297397) -- Normal, etc
	self:Log("SPELL_AURA_REMOVED", "BrinyBubbleRemoved", 302992, 297397)
	self:Log("SPELL_CAST_SUCCESS", "Upsurge", 298056)
	self:Log("SPELL_CAST_SUCCESS", "BarnacleBash", 296725)
	self:Log("SPELL_AURA_APPLIED", "BarnacleBashApplied", 296725)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BarnacleBashApplied", 296725)
	self:Log("SPELL_AURA_REMOVED", "HardenedCarapaceRemoved", 296650)
	self:Log("SPELL_AURA_APPLIED", "ArcingAzeriteApplied", 296938, 296941, 296939, 296942, 296940, 296943) -- Green, Green, Orange, Orange, Purple, Purple
	self:Log("SPELL_AURA_REMOVED", "ArcingAzeriteRemoved", 296938, 296941, 296939, 296942, 296940, 296943)
	self:Log("SPELL_AURA_APPLIED", "HardenedCarapaceApplied", 296650)

	-- Ground Effects: Cutting Coral 296752

	if self:GetOption(arcingAzeriteMarker) then
		UpdateRaidList()
	end
end

function mod:OnEngage()
	barnacleBashCount = 1

	self:CDBar(298056, 2.5) -- Upsurge
	self:CDBar(296725, 8) -- Barnacle Bash
	self:Bar(296662, 15) -- Rippling Wave
	self:Bar(297397, 39) -- Briny Bubble

	if self:GetOption(arcingAzeriteMarker) then
		UpdateRaidList()
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:RipplingWave(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
	self:CDBar(args.spellId, 30)
end

do
	local playerList = mod:NewTargetList()
	function mod:BrinyBubbleApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(297397, "warning")
			self:Say(297397, args.spellName)
			self:SayCountdown(297397, 6)
			self:Flash(297397)
		end
		if #playerList == 1 then
			local cd = 45
			local nextCarapaceCD = nextCarapace - GetTime()
			if stage == 1 or nextCarapaceCD > cd then
				self:CDBar(297397, cd)
			end
		end
		self:TargetsMessage(297397, "red", playerList)
	end

	function mod:BrinyBubbleRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(297397)
		end
	end
end

function mod:Upsurge(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	local cd = 15
	local nextCarapaceCD = nextCarapace - GetTime()
	if stage == 1 or nextCarapaceCD > cd then
		self:CDBar(args.spellId, cd)
	end
end

function mod:BarnacleBash(args)
	barnacleBashCount = barnacleBashCount + 1
	local cd = stage == 1 and (barnacleBashCount % 2 == 0 and 15 or 30) or 15
	local nextCarapaceCD = nextCarapace - GetTime()
	if stage == 1 or nextCarapaceCD > cd then
		self:CDBar(args.spellId, cd)
	end
end

function mod:BarnacleBashApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alert")
end

function mod:HardenedCarapaceRemoved(args)
	stage = 2
	self:Message2("stages", "orange", CL.stage:format(stage), args.spellId)
	self:PlaySound("stages", "long")

	arcingAzeriteCount = 1

	self:StopBar(298056) -- Upsurge
	self:StopBar(296725) -- Barnacle Bash
	self:StopBar(296662) -- Rippling Wave
	self:StopBar(296569) -- Coral Growth
	self:StopBar(297397) -- Briny Bubble

	self:CDBar(296725, 12.5) -- Barnacle Bash
	self:CDBar(298056, 17.6) -- Upsurge
	self:Bar(-20096, 20.5) -- Arcing Azerite
	self:Bar(297397, 38.6) -- Briny Bubble

	nextCarapace = GetTime() + 65.8
	self:Bar("stages", 65.8, 296650, 296650) -- Hardened Carapace
end

do
	local playerListGreen, playerListOrange, playerListPurple, isOnMe, scheduled = {}, {}, {}, 0, nil

	local function announce(self)
		if isOnMe == 1 then -- Green
			local playerName = UnitName("player")
			local playersInTable = #playerListGreen
			local linkedPlayer = nil
			for i = 1, playersInTable do
				if playerListGreen[i] ~= playerName then
					linkedPlayer = playerListGreen[i]
					break
				end
			end
			self:Message2(-20096, "blue", CL.link:format(self:ColorName(linkedPlayer)), 296938)
			self:PlaySound(-20096, "warning")
			self:Flash(-20096)
		elseif isOnMe == 2 then -- Orange
			local playerName = UnitName("player")
			local playersInTable = #playerListOrange
			local linkedPlayer = nil
			for i = 1, playersInTable do
				if playerListOrange[i] ~= playerName then
					linkedPlayer = playerListOrange[i]
					break
				end
			end
			self:Message2(-20096, "blue", CL.link:format(self:ColorName(linkedPlayer)), 296939)
			self:PlaySound(-20096, "warning")
			self:Flash(-20096)
		elseif isOnMe == 3 then -- Purple
			local playerName = UnitName("player")
			local playersInTable = #playerListPurple
			local linkedPlayer = nil
			for i = 1, playersInTable do
				if playerListPurple[i] ~= playerName then
					linkedPlayer = playerListPurple[i]
					break
				end
			end
			self:Message2(-20096, "blue", CL.link:format(self:ColorName(linkedPlayer)), 296940)
			self:PlaySound(-20096, "warning")
			self:Flash(-20096)
		elseif not self:CheckOption(-20096, "ME_ONLY") then
			local iconGreen = "|T"..GetSpellTexture(296938)..":15:15:0:0:64:64:4:60:4:60|t"
			local iconOrange = "|T"..GetSpellTexture(296939)..":15:15:0:0:64:64:4:60:4:60|t"
			local iconPurple = "|T"..GetSpellTexture(296940)..":15:15:0:0:64:64:4:60:4:60|t"
			local messageText = ""
			local playersInTable = #playerListGreen

			for i = 1, playersInTable do
				messageText = messageText..self:ColorName(playerListGreen[i])
				if i == 1 then -- Add icon
					messageText = messageText..iconGreen
				end
			end
			playersInTable = #playerListOrange
			for i = 1, playersInTable do
				if i == 1 then -- Add icon
					messageText = messageText..", "..self:ColorName(playerListOrange[i])..iconOrange
				else
					messageText = messageText..self:ColorName(playerListOrange[i])
				end
			end
			playersInTable = #playerListPurple
			for i = 1, playersInTable do
				if i == 1 then
					messageText = messageText..", "..self:ColorName(playerListPurple[i])..iconPurple
				else
					messageText = messageText..self:ColorName(playerListPurple[i])
				end
			end
			self:Message2(-20096, "yellow", CL.other:format(self:SpellName(-20096), messageText))
			self:PlaySound(-20096, "alert")
		end

		if self:GetOption(arcingAzeriteMarker) then
			if #playerListGreen == 2 then
				if raidList[playerListGreen[1]] < raidList[playerListGreen[2]] then
					SetRaidTarget(playerListGreen[1], 1) -- Star
					SetRaidTarget(playerListGreen[2], 4) -- Triangle
				else
					SetRaidTarget(playerListGreen[2], 1) -- Star
					SetRaidTarget(playerListGreen[1], 4) -- Triangle
				end
			elseif playerListGreen[1] then -- Only prio melee icon
				SetRaidTarget(playerListGreen[1], 1)
			end
			if #playerListOrange == 2 then
				if raidList[playerListOrange[1]] < raidList[playerListOrange[2]] then
					SetRaidTarget(playerListOrange[1], 2) -- Circle
					SetRaidTarget(playerListOrange[2], 7) -- Cross
				else
					SetRaidTarget(playerListOrange[2], 2) -- Circle
					SetRaidTarget(playerListOrange[1], 7) -- Cross
				end
			elseif playerListOrange[1] then -- Only prio melee icon
				SetRaidTarget(playerListOrange[1], 2) -- Circle
			end
			if #playerListPurple == 2 then
				if raidList[playerListPurple[1]] < raidList[playerListPurple[2]] then
					SetRaidTarget(playerListPurple[1], 3) -- Diamond
					SetRaidTarget(playerListPurple[2], 6) -- Moon
				else
					SetRaidTarget(playerListPurple[2], 3) -- Diamond
					SetRaidTarget(playerListPurple[1], 6) -- Moon
				end
			elseif playerListPurple[1] then -- Only prio melee icon
				SetRaidTarget(playerListPurple[1], 3) -- Diamond
			end
		end

		scheduled = nil
		isOnMe = 0
		wipe(playerListGreen)
		wipe(playerListOrange)
		wipe(playerListPurple)
	end

	function mod:ArcingAzeriteApplied(args)
		if args.spellId == 296938 or args.spellId == 296941 then -- Green
			playerListGreen[#playerListGreen+1] = args.destName
			if self:Me(args.destGUID) then
				isOnMe = 1
			end
		elseif args.spellId == 296939 or args.spellId == 296942 then -- Orange
			playerListOrange[#playerListOrange+1] = args.destName
			if self:Me(args.destGUID) then
				isOnMe = 2
			end
		elseif args.spellId == 296940 or args.spellId == 296943 then -- Purple
			playerListPurple[#playerListPurple+1] = args.destName
			if self:Me(args.destGUID) then
				isOnMe = 3
			end
		end
		if not scheduled then
			arcingAzeriteCount = arcingAzeriteCount + 1
			scheduled = self:ScheduleTimer(announce, 0.1, self)
			if arcingAzeriteCount == 2 then
				self:Bar(-20096, 34)
			end
		end
	end

	function mod:ArcingAzeriteRemoved(args)
		if self:GetOption(arcingAzeriteMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:HardenedCarapaceApplied(args)
	if stage == 2 then -- Applied on Pull
		stage = 1
		self:Message2("stages", "orange", CL.stage:format(stage), args.spellId)
		self:PlaySound("stages", "long")

		barnacleBashCount = 1

		self:StopBar(296725) -- Barnacle Bash
		self:StopBar(297397) -- Crushing Depths

		self:CDBar(296725, 10.9) -- Barnacle Bash
		self:CDBar(298056, 12.9) -- Upsurge
		self:Bar(296662, 18.9) -- Rippling Wave
		self:Bar(297397, 40.9) -- Briny Bubble
	end
end
