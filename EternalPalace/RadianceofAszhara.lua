--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Radiance of Azshara", 2164, 2353)
if not mod then return end
mod:RegisterEnableMob(152364) -- Radiance of Azshara
mod.engageId = 2305
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local nextAncientTempest = nil
local unshackledPowerCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

local arcaneBombMarker = mod:AddMarkerOption(false, "player", 1, 296737, 1, 2, 3, 4) -- Arcane Bomb
function mod:GetOptions()
	return {
		{296566, "TANK"}, -- Tide Fist
		296428, -- Arcanado Burst
		296459, -- Squall Trap
		{296737, "SAY", "SAY_COUNTDOWN"}, -- Arcane Bomb
		arcaneBombMarker,
		296894, -- Unshackled Power
		295916, -- Ancient Tempest
		296701, -- Gale Buffet
	},{
		[296546] = -20076, -- Rising Fury
		[295916] = -20078, -- Raging Storm
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "TideFistStart", 296566)
	self:Log("SPELL_AURA_APPLIED", "TideFistApplied", 296566)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1") -- Arcanado Burst, Power Gain (Ancient Tempest Over)
	self:Log("SPELL_CAST_START", "SquallTrap", 296459)
	self:Log("SPELL_AURA_APPLIED", "ArcaneBombApplied", 296737)
	self:Log("SPELL_AURA_REMOVED", "ArcaneBombRemoved", 296737)
	self:Log("SPELL_CAST_START", "UnshackledPower", 296894)
	self:Log("SPELL_CAST_START", "AncientTempest", 295916)
	self:Log("SPELL_CAST_START", "GaleBuffet", 296701)
end

function mod:OnEngage()
	stage = 1
	unshackledPowerCount = 1
	nextAncientTempest = GetTime() + 96

	self:CDBar(296428, 6) -- Arcanado Burst
	self:CDBar(296737, 7) -- Arcane Bomb
	self:CDBar(296894, 10) -- Unshackled Power
	self:CDBar(296566, 15) -- Tide Fist
	self:CDBar(296459, 85) -- Squall Trap
	self:CDBar(295916, 96) -- Ancient Tempest
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:TideFistStart(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
	local cd = 20
	local nextAncientTempestCD = nextAncientTempest - GetTime()
	if nextAncientTempestCD > cd then
		self:CDBar(args.spellId, cd)
	end
end

function mod:TideFistApplied(args)
	self:TargetMessage2(args.spellId, "purple", args.destName)
	self:PlaySound(args.spellId, "alert", args.destName)
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 296428 then -- Arcanado Burst
		self:Message2(spellId, "yellow")
		self:PlaySound(spellId, "alarm")
		local cd = 10
		local nextAncientTempestCD = nextAncientTempest - GetTime()
		if nextAncientTempestCD > cd then
			self:CDBar(spellId, cd)
		end
	elseif spellId == 297121 and stage == 2 then -- Power Gain (Ancient Tempest Over) // Cast on pull so checking for stage
		self:Message2(295916, "cyan", CL.over:format(self:SpellName(295916)))
		self:PlaySound(295916, "long")

		self:StopBar(296701) -- Gale Buffet

		stage = 1
		unshackledPowerCount = 1
		nextAncientTempest = GetTime() + 96

		self:CDBar(296428, 6) -- Arcanado Burst
		self:CDBar(296737, 7) -- Arcane Bomb
		self:CDBar(296894, 10) -- Unshackled Power
		self:CDBar(296566, 15.2) -- Tide Fist
		self:CDBar(296459, 85) -- Squall Trap
		self:CDBar(295916, 96) -- Ancient Tempest
	end
end

function mod:SquallTrap(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
end

do
	local playerList, playerIcons = mod:NewTargetList(), {}
	function mod:ArcaneBombApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerIcons[count] = count
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.count_rticon:format(args.spellName, count, count))
			self:SayCountdown(args.spellId, self:Mythic() and 4 or 10, count)
			self:PlaySound(args.spellId, "alert")
		end
		if #playerList == 1 then
			local cd = 20
			local nextAncientTempestCD = nextAncientTempest - GetTime()
			if nextAncientTempestCD > cd or stage == 2 then
				self:Bar(args.spellId, cd)
			end
		end
		if self:GetOption(arcaneBombMarker) then
			SetRaidTarget(args.destName, #playerList)
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, 4, nil, nil, nil, playerIcons)
	end

	function mod:ArcaneBombRemoved(args)
		if self:GetOption(arcaneBombMarker) then
			SetRaidTarget(args.destName, 0)
		end
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
			self:Message2(args.spellId, "green", CL.removed:format(args.spellName))
		end
	end
end

function mod:UnshackledPower(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	unshackledPowerCount = unshackledPowerCount + 1
	local cd = unshackledPowerCount == 3 and 9 or 17
	local nextAncientTempestCD = nextAncientTempest - GetTime()
	if nextAncientTempestCD > cd then
		self:CDBar(args.spellId, cd)
	end
end

function mod:AncientTempest(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")

	stage = 2

	self:StopBar(296428) -- Arcanado Burst
	self:StopBar(296737) -- Arcane Bomb
	self:StopBar(296894) -- Unshackled Power
	self:StopBar(296566) -- Tide Fist

	self:CDBar(296737, 7) -- Arcane Bomb
	self:CDBar(296701, 26) -- Gale Buffet
end

function mod:GaleBuffet(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
	self:CDBar(args.spellId, 23)
end
