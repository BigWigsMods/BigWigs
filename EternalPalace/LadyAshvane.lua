if not IsTestBuild() then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lady Ashvane", 2164, 2354)
if not mod then return end
mod:RegisterEnableMob(153732) -- Priscilla Ashvane
mod.engageId = 2304
--mod.respawnTime = 31

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local barnacleBashCount = 1
local nextCarapace = 0
local arcingAzeriteCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		296569, -- Coral Growth
		296662, -- Rippling Wave
		{297397, "SAY", "SAY_COUNTDOWN", "FLASH"}, -- Crushing Depths
		298056, -- Upsurge
		{296725, "TANK"}, -- Barnacle Bash
		{-20096, "FLASH"}, -- Arcing Azerite
	},{
		[296569] = CL.stage:format(1),
		[-20096] = CL.stage:format(2),
	}
end

function mod:OnBossEnable()

	self:Log("SPELL_CAST_SUCCESS", "CoralGrowth", 296569)
	self:Log("SPELL_CAST_START", "RipplingWave", 296569)
	self:Log("SPELL_AURA_APPLIED", "CrushingDepthsApplied", 297397)
	self:Log("SPELL_AURA_REMOVED", "CrushingDepthsRemoved", 297397)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1") -- Upsurge
	self:Log("SPELL_CAST_SUCCESS", "BarnacleBash", 296725)
	self:Log("SPELL_AURA_APPLIED", "BarnacleBashApplied", 296725)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BarnacleBashApplied", 296725)
	self:Log("SPELL_AURA_REMOVED", "HardenedCarapaceRemoved", 296650)
	self:Log("SPELL_AURA_APPLIED", "ArcingAzeriteApplied", 296938, 296941, 296939, 296942, 296940, 296943) -- Green, Green, Orange, Orange, Purple, Purple
	self:Log("SPELL_AURA_APPLIED", "HardenedCarapaceApplied", 296650)

	-- Ground Effects: Cutting Coral 296752
end

function mod:OnEngage()
	barnacleBashCount = 1

	self:CDBar(298056, 2.5) -- Upsurge
	self:CDBar(296725, 8) -- Barnacle Bash
	self:Bar(296662, 13) -- Rippling Wave
	self:Bar(296569, 30) -- Coral Growth
	self:Bar(297397, 39) -- Crushing Depths
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CoralGrowth(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 30)
end

function mod:RipplingWave(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
	self:CDBar(args.spellId, 33)
end

do
	local playerList = mod:NewTargetList()
	function mod:CrushingDepthsApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, args.spellName)
			self:SayCountdown(args.spellId, 6)
			self:Flash(args.spellId)
		end
		if #playerList == 1 then
			local cd = 48
			local nextCarapaceCD = nextCarapace - GetTime()
			if stage == 1 or nextCarapaceCD > cd then
				self:CDBar(args.spellId, cd)
			end
		end
		self:TargetsMessage(args.spellId, "red", playerList)
	end

	function mod:CrushingDepthsRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 298056 then -- Upsurge
		self:Message2(spellId, "orange")
		self:PlaySound(spellId, "alarm")
		local cd = 16
		local nextCarapaceCD = nextCarapace - GetTime()
		if stage == 1 or nextCarapaceCD > cd then
			self:CDBar(spellId, cd)
		end
	end
end

function mod:BarnacleBash(args)
	barnacleBashCount = barnacleBashCount + 1
	local cd = stage == 1 and (barnacleBashCount % 2 == 0 and 16 or 31.5) or 15
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
	self:StopBar(297397) -- Crushing Depths

	self:CDBar(296725, 9) -- Barnacle Bash
	self:Bar(-20096, 16.2) -- Arcing Azerite
	self:Bar(297397, 30.3) -- Crushing Depths

	nextCarapace = GetTime() + 65.8
	self:Bar("stages", 65.8, 296650, 296650) -- Hardened Carapace
end

do
	local playerListGreen, playerListOrange, playerListPurple, isOnMe, scheduled = {}, {}, {}, 0, nil

	local function announce()
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
			mod:Message2(-20096, "blue", CL.link:format(mod:ColorName(linkedPlayer)), 296938)
			mod:PlaySound(-20096, "warning")
			mod:Flash(-20096)
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
			mod:Message2(-20096, "blue", CL.link:format(mod:ColorName(linkedPlayer)), 296939)
			mod:PlaySound(-20096, "warning")
			mod:Flash(-20096)
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
			mod:Message2(-20096, "blue", CL.link:format(mod:ColorName(linkedPlayer)), 296940)
			mod:PlaySound(-20096, "warning")
			mod:Flash(-20096)
		elseif not mod:CheckOption(-20096, "ME_ONLY") then
			-- XXX Make a warning with all players listed?
			-- Example: Player1 {rt4} Player2, Player1 {rt2} Player2, Player1 {rt3} Player2
			local iconGreen = "|T"..GetSpellTexture(296938)..":15:15:0:0:64:64:4:60:4:60|t"
			local iconOrange = "|T"..GetSpellTexture(296939)..":15:15:0:0:64:64:4:60:4:60|t"
			local iconPurple = "|T"..GetSpellTexture(296940)..":15:15:0:0:64:64:4:60:4:60|t"
			local messageText = ""
			local playersInTable = #playerListGreen
			for i = 1, playersInTable do
				messageText = messageText..mod:ColorName(playerListGreen[i])
				if i == 1 then -- Add icon
					messageText = messageText..iconGreen
				end
			end
			playersInTable = #playerListOrange
			for i = 1, playersInTable do
				if i == 1 then -- Add icon
					messageText = messageText..", "..mod:ColorName(playerListOrange[i])..iconOrange
				else
					messageText = messageText..mod:ColorName(playerListOrange[i])
				end
			end
			playersInTable = #playerListPurple
			for i = 1, playersInTable do
				if i == 1 then
					messageText = messageText..", "..mod:ColorName(playerListPurple[i])..iconPurple
				else
					messageText = messageText..mod:ColorName(playerListPurple[i])
				end
			end
			mod:Message2(-20096, "yellow", CL.other:format(mod:SpellName(-20096), messageText))
			mod:PlaySound(-20096, "alert")
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
			scheduled = true
			self:SimpleTimer(announce, 0.1)
			if arcingAzeriteCount == 2 then
				self:Bar(-20096, 39)
			end
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

		self:CDBar(298056, 7.2) -- Upsurge
		self:CDBar(296725, 12.2) -- Barnacle Bash
		self:Bar(296662, 17.3) -- Rippling Wave
		self:Bar(296569, 34.5) -- Coral Growth
		self:Bar(297397, 43.3) -- Crushing Depths
	end
end
