if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Shriekwing", 2296, 2393)
if not mod then return end
mod:RegisterEnableMob(172145)
mod.engageId = 2398
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Initialization
--

local sanguineCurseMarker = mod:AddMarkerOption(false, "player", 1, 336338, 1, 2, 3, 4, 5, 6, 7, 8) -- Cursed Blood
function mod:GetOptions()
	return {
		-- Stage One - Thirst for Blood
		{328857, "TANK"}, -- Exsanguinating Bite
		328897, -- Exsanguinated
		{336235, "SAY", "SAY_COUNTDOWN"}, -- Dark Descent
		{336338, "SAY", "SAY_COUNTDOWN"}, -- Sanguine Curse
		sanguineCurseMarker,
		336341, -- Sanguine Ichor
		336399, -- Echo Screech
		330711, -- Piercing Shriek
		-- Stage Two - Terror of Castle Nathria
		328921, -- Bloodgorge
		321511, -- Dark Sonar
	}, {
		[328857] = -22101, -- Stage One - Thirst for Blood
		[328921] = -22102, -- Stage Two - Terror of Castle Nathria
	}
end

function mod:OnBossEnable()
	-- Stage One - Thirst for Blood
	self:Log("SPELL_CAST_START", "ExsanguinatingBite", 328857)
	self:Log("SPELL_AURA_APPLIED", "ExsanguinatedApplied", 328897)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ExsanguinatedApplied", 328897)
	self:Log("SPELL_AURA_APPLIED", "DarkDescentApplied", 336235)
	self:Log("SPELL_AURA_REMOVED", "DarkDescentRemoved", 336235)
	self:Log("SPELL_AURA_APPLIED", "SanguineCurseApplied", 336338)
	self:Log("SPELL_AURA_REMOVED", "SanguineCurseRemoved", 336338)
	self:Log("SPELL_CAST_SUCCESS", "EchoScreech", 336399)
	self:Log("SPELL_CAST_START", "PiercingShriek", 330711)

	-- Stage Two - Terror of Castle Nathria
	self:Log("SPELL_CAST_START", "Bloodgorge", 328921)
	self:Log("SPELL_CAST_SUCCESS", "DarkSonar", 321511)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 336341) -- Sanguine Ichor
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 336341)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 336341)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ExsanguinatingBite(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "info")
	--self:Bar(args.spellId, 60)
end

function mod:ExsanguinatedApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 3 == 1 then
			self:StackMessage(args.spellId, args.destName, amount, "purple")
			self:PlaySound(args.spellId, "alert")
		end
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:DarkDescentApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 8)
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "red", playerList)
	end

	function mod:DarkDescentRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:SanguineCurseApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 24)
			self:PlaySound(args.spellId, "warning")
		end
		if self:GetOption(sanguineCurseMarker) then
			SetRaidTarget(args.destName, #playerList)
		end
		self:TargetsMessage(args.spellId, "orange", playerList)
	end

	function mod:SanguineCurseRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		if self:GetOption(sanguineCurseMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:EchoScreech(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 60)
end

function mod:PiercingShriek(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
	--self:Bar(args.spellId, 60)
end

function mod:Bloodgorge(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
end

function mod:DarkSonar(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
	--self:Bar(args.spellId, 60)
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
