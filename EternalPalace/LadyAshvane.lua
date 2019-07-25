--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lady Ashvane", 2164, 2354)
if not mod then return end
mod:RegisterEnableMob(152236) -- Priscilla Ashvane
mod.engageId = 2304
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local barnacleBashCount = 1
local upsurgeCount = 1
local ripplingWaveCount = 1
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
-- Localization
--

local L = mod:GetLocale()
if L then
	L.linkText = "|T%d:15:15:0:0:64:64:4:60:4:60|t(%s+%s) "
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
		296752, -- Cutting Coral
		{-20096, "FLASH", "SAY"}, -- Arcing Azerite
		arcingAzeriteMarker,
	},{
		[296569] = CL.stage:format(1),
		[-20096] = CL.stage:format(2),
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "RipplingWave", 296662)
	self:Log("SPELL_AURA_APPLIED", "BrinyBubbleApplied", 302989, 297397) -- Normal, etc
	self:Log("SPELL_AURA_REMOVED", "BrinyBubbleRemoved", 302989, 297397)
	self:Log("SPELL_CAST_SUCCESS", "Upsurge", 298056)
	self:Log("SPELL_CAST_START", "BarnacleBash", 296725)
	self:Log("SPELL_AURA_APPLIED", "BarnacleBashApplied", 296725)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BarnacleBashApplied", 296725)
	self:Log("SPELL_AURA_REMOVED", "HardenedCarapaceRemoved", 296650)
	self:Log("SPELL_AURA_APPLIED", "ArcingAzeriteApplied", 296938, 296941, 296939, 296942, 296940, 296943) -- Green, Green, Orange, Orange, Purple, Purple
	self:Log("SPELL_AURA_REMOVED", "ArcingAzeriteRemoved", 296938, 296941, 296939, 296942, 296940, 296943)
	self:Log("SPELL_AURA_APPLIED", "HardenedCarapaceApplied", 296650)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 296752) -- Cutting Coral
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 296752)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 296752)

	UpdateRaidList()
end

function mod:OnEngage()
	barnacleBashCount = 1
	upsurgeCount = 1
	ripplingWaveCount = 1

	self:CDBar(298056, 2.5) -- Upsurge
	self:CDBar(296725, 7) -- Barnacle Bash
	self:Bar(296662, 15, CL.count:format(self:SpellName(296662), ripplingWaveCount)) -- Rippling Wave
	self:Bar(297397, 39) -- Briny Bubble

	UpdateRaidList()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:RipplingWave(args)
	self:Message2(args.spellId, "cyan", CL.count:format(args.spellName, ripplingWaveCount))
	self:PlaySound(args.spellId, "long")
	self:StopBar(CL.count:format(args.spellName, ripplingWaveCount)) -- Rippling Wave
	ripplingWaveCount = ripplingWaveCount + 1
	self:CDBar(args.spellId, 30, CL.count:format(args.spellName, ripplingWaveCount))
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
	upsurgeCount = upsurgeCount + 1
	local cd = stage == 1 and (upsurgeCount % 2 == 1 and 30 or 15) or 44 -- Stage 1: 30/15 Alternating, Stage 2 44
	local nextCarapaceCD = nextCarapace - GetTime()
	if stage == 1 or nextCarapaceCD > cd then
		self:CDBar(args.spellId, cd)
	end
end

function mod:BarnacleBash(args)
	barnacleBashCount = barnacleBashCount + 1
	local cd = stage == 1 and (barnacleBashCount % 2 == 0 and 15 or 30) or barnacleBashCount == 2 and 15 or 26 -- Stage 1: Alternate 15, 30..; Stage 2: 12.5, 15, 26
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
	barnacleBashCount = 1
	upsurgeCount = 1

	self:StopBar(298056) -- Upsurge
	self:StopBar(296725) -- Barnacle Bash
	self:StopBar(CL.count:format(self:SpellName(296662), ripplingWaveCount)) -- Rippling Wave
	self:StopBar(296569) -- Coral Growth
	self:StopBar(297397) -- Briny Bubble

	self:CDBar(296725, 13.4) -- Barnacle Bash
	self:CDBar(298056, 17.4) -- Upsurge
	self:Bar(-20096, 20.5) -- Arcing Azerite
	self:Bar(297397, 38.6) -- Briny Bubble

	nextCarapace = GetTime() + 65.8
	self:Bar("stages", 65.8, 296650, 296650) -- Hardened Carapace
end

do
	local playerListGreen, playerListOrange, playerListPurple, isOnMe, scheduled = {}, {}, {}, 0, false

	local function announce()
		local self = mod
		if isOnMe == 1 then -- Green
			local playerName = self:UnitName("player")
			local playersInTable = #playerListGreen
			local linkedPlayer = ""
			for i = 1, playersInTable do
				if playerListGreen[i][1] ~= playerName then
					linkedPlayer = ("|T13700%d:0|t%s"):format(playerListGreen[i][2], self:ColorName(playerListGreen[i][1]))
				else
					self:Say(-20096, CL.count_rticon:format(self:SpellName(-20096), isOnMe, playerListGreen[i][2]))
				end
			end
			self:Message2(-20096, "blue", CL.link:format(linkedPlayer), 296938)
			self:PlaySound(-20096, "warning")
			self:Flash(-20096, 296938)
		elseif isOnMe == 2 then -- Orange
			local playerName = self:UnitName("player")
			local playersInTable = #playerListOrange
			local linkedPlayer = ""
			for i = 1, playersInTable do
				if playerListOrange[i][1] ~= playerName then
					linkedPlayer = ("|T13700%d:0|t%s"):format(playerListOrange[i][2], self:ColorName(playerListOrange[i][1]))
				else
					self:Say(-20096, CL.count_rticon:format(self:SpellName(-20096), isOnMe, playerListOrange[i][2]))
				end
			end
			self:Message2(-20096, "blue", CL.link:format(linkedPlayer), 296939)
			self:PlaySound(-20096, "warning")
			self:Flash(-20096, 296939)
		elseif isOnMe == 3 then -- Purple
			local playerName = self:UnitName("player")
			local playersInTable = #playerListPurple
			local linkedPlayer = ""
			for i = 1, playersInTable do
				if playerListPurple[i][1] ~= playerName then
					linkedPlayer = ("|T13700%d:0|t%s"):format(playerListPurple[i][2], self:ColorName(playerListPurple[i][1]))
				else
					self:Say(-20096, CL.count_rticon:format(self:SpellName(-20096), isOnMe, playerListPurple[i][2]))
				end
			end
			self:Message2(-20096, "blue", CL.link:format(linkedPlayer), 296940)
			self:PlaySound(-20096, "warning")
			self:Flash(-20096, 296940)
		elseif not self:CheckOption(-20096, "ME_ONLY") then
			local messageText = ""

			local playersInTable = #playerListGreen
			if playersInTable > 0 then
				if playerListGreen[2] then
					local player1 = ("|T13700%d:0|t%s"):format(playerListGreen[1][2], self:ColorName(playerListGreen[1][1]))
					local player2 = ("|T13700%d:0|t%s"):format(playerListGreen[2][2], self:ColorName(playerListGreen[2][1]))
					messageText = messageText .. L.linkText:format(GetSpellTexture(296938), player1, player2)
				else
					local player1 = ("|T13700%d:0|t%s"):format(playerListGreen[1][2], self:ColorName(playerListGreen[1][1]))
					messageText = messageText .. L.linkText:format(GetSpellTexture(296938), player1, "")
				end
			end

			playersInTable = #playerListOrange
			if playersInTable > 0 then
				if playerListOrange[2] then
					local player1 = ("|T13700%d:0|t%s"):format(playerListOrange[1][2], self:ColorName(playerListOrange[1][1]))
					local player2 = ("|T13700%d:0|t%s"):format(playerListOrange[2][2], self:ColorName(playerListOrange[2][1]))
					messageText = messageText .. L.linkText:format(GetSpellTexture(296939), player1, player2)
				else
					local player1 = ("|T13700%d:0|t%s"):format(playerListOrange[1][2], self:ColorName(playerListOrange[1][1]))
					messageText = messageText .. L.linkText:format(GetSpellTexture(296939), player1, "")
				end
			end

			playersInTable = #playerListPurple
			if playersInTable > 0 then
				if playerListPurple[2] then
					local player1 = ("|T13700%d:0|t%s"):format(playerListPurple[1][2], self:ColorName(playerListPurple[1][1]))
					local player2 = ("|T13700%d:0|t%s"):format(playerListPurple[2][2], self:ColorName(playerListPurple[2][1]))
					messageText = messageText .. L.linkText:format(GetSpellTexture(296940), player1, player2)
				else
					local player1 = ("|T13700%d:0|t%s"):format(playerListPurple[1][2], self:ColorName(playerListPurple[1][1]))
					messageText = messageText .. L.linkText:format(GetSpellTexture(296940), player1, "")
				end
			end

			self:Message2(-20096, "yellow", CL.other:format(self:SpellName(-20096), messageText))
			self:PlaySound(-20096, "alert")
		end

		if self:GetOption(arcingAzeriteMarker) then
			-- Green
			if playerListGreen[1] then
				SetRaidTarget(playerListGreen[1][1], playerListGreen[1][2])
				if playerListGreen[2] then
					SetRaidTarget(playerListGreen[2][1], playerListGreen[2][2])
				end
			end
			-- Orange
			if playerListOrange[1] then
				SetRaidTarget(playerListOrange[1][1], playerListOrange[1][2])
				if playerListOrange[2] then
					SetRaidTarget(playerListOrange[2][1], playerListOrange[2][2])
				end
			end
			-- Purple
			if playerListPurple[1] then
				SetRaidTarget(playerListPurple[1][1], playerListPurple[1][2])
				if playerListPurple[2] then
					SetRaidTarget(playerListPurple[2][1], playerListPurple[2][2])
				end
			end
		end

		scheduled = false
		isOnMe = 0
		playerListGreen, playerListOrange, playerListPurple = {}, {}, {}
	end

	function mod:ArcingAzeriteApplied(args)
		if args.spellId == 296938 or args.spellId == 296941 then -- Green
			playerListGreen[#playerListGreen+1] = {args.destName, 1}
			if #playerListGreen == 2 then
				if raidList[playerListGreen[1][1]] < raidList[playerListGreen[2][1]] then
					playerListGreen[1][2] = 1 -- Star
					playerListGreen[2][2] = 4 -- Triangle
				else
					playerListGreen[2][2] = 1 -- Star
					playerListGreen[1][2] = 4 -- Triangle
				end
			end
			if self:Me(args.destGUID) then
				isOnMe = 1
			end
		elseif args.spellId == 296939 or args.spellId == 296942 then -- Orange
			playerListOrange[#playerListOrange+1] = {args.destName, 2}
			if #playerListOrange == 2 then
				if raidList[playerListOrange[1][1]] < raidList[playerListOrange[2][1]] then
					playerListOrange[1][2] = 2 -- Circle
					playerListOrange[2][2] = 7 -- Cross
				else
					playerListOrange[2][2] = 2 -- Circle
					playerListOrange[1][2] = 7 -- Cross
				end
			end
			if self:Me(args.destGUID) then
				isOnMe = 2
			end
		elseif args.spellId == 296940 or args.spellId == 296943 then -- Purple
			playerListPurple[#playerListPurple+1] = {args.destName, 3}
			if #playerListPurple == 2 then
				if raidList[playerListPurple[1][1]] < raidList[playerListPurple[2][1]] then
					playerListPurple[1][2] = 3 -- Diamond
					playerListPurple[2][2] = 6 -- Moon
				else
					playerListPurple[2][2] = 3 -- Diamond
					playerListPurple[1][2] = 6 -- Moon
				end
			end
			if self:Me(args.destGUID) then
				isOnMe = 3
			end
		end
		if not scheduled then
			scheduled = true
			arcingAzeriteCount = arcingAzeriteCount + 1
			self:SimpleTimer(announce, 0.1)
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
		upsurgeCount = 1
		ripplingWaveCount = 1

		self:StopBar(296725) -- Barnacle Bash
		self:StopBar(297397) -- Crushing Depths

		self:CDBar(296725, 10.9) -- Barnacle Bash
		self:CDBar(298056, 12.9) -- Upsurge
		self:Bar(296662, 18.9, CL.count:format(self:SpellName(296662), ripplingWaveCount)) -- Rippling Wave
		self:Bar(297397, 40.9) -- Briny Bubble
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
