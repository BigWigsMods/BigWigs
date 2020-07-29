if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Council of Blood", 2296, 2426)
if not mod then return end
mod:RegisterEnableMob(
	166971, -- Castellan Niklaus
	166969, -- Baroness Frieda
	166970) -- Lord Stavros
mod.engageId = 2412
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Castellan Niklaus ]]--
		{328334, "SAY"},
		335776, -- Unyielding Shield
		334948, -- Unstoppable Charge
		330965, -- Castellan's Cadre
		330967, -- Fixate

		--[[ Baroness Frieda ]]--
		{327773, "TANK"}, -- Drain Essence
		{337110, "TANK"}, -- Bolt of Power
		{327475, "PROXIMITY"}, -- Anima Fountain
		{331706, "SAY", "SAY_COUNTDOWN"}, -- Scarlet Letter
		330978, -- Dredger Servants

		--[[ Lord Stavros ]]--
		327497, -- Evasive Lunge
		327619, -- Waltz of Blood
		{331637, "SAY"}, -- Dark Recital
		330964, -- Dancing Fools

		--[[ Intermission: The Danse Macabre ]]--
		330848, -- Wrong Moves
	}, {
		[328334] = -22147, -- Castellan Niklaus
		[327773] = -22148, -- Baroness Frieda
		[327497] = -22149, -- Lord Stavros
		[330848] = -22146, -- Intermission: The Danse Macabre
	}
end

function mod:OnBossEnable()
	--[[ Castellan Niklaus ]]--
	self:Log("SPELL_CAST_START", "TacticalAdvance", 328334)
	self:Log("SPELL_CAST_START", "UnyieldingShield", 335776)
	self:Log("SPELL_CAST_START", "UnstoppableCharge", 334948)
	self:Log("SPELL_CAST_START", "CastellansCadre", 330965)
	self:Log("SPELL_AURA_APPLIED", "Fixate", 330967)

	--[[ Baroness Frieda ]]--
	self:Log("SPELL_AURA_APPLIED", "DrainEssence", 327773)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DrainEssence", 327773)
	self:Log("SPELL_CAST_START", "BoltOfPower", 337110)
	self:Log("SPELL_AURA_APPLIED", "ScarletLetter", 331706)
	self:Log("SPELL_AURA_REMOVED", "ScarletLetterRemoved", 331706)
	self:Log("SPELL_CAST_START", "DredgerServants", 330978)

	--[[ Lord Stavros ]]--
	self:Log("SPELL_CAST_START", "EvasiveLunge", 327497)
	self:Log("SPELL_CAST_SUCCESS", "WaltzOfBlood", 327619)
	self:Log("SPELL_AURA_APPLIED", "DarkRecitalApplied", 331637)
	self:Log("SPELL_AURA_REMOVED", "DarkRecitalRemoved", 331637)
	self:Log("SPELL_CAST_SUCCESS", "DancingFools", 330964)

	--[[ Intermission: The Danse Macabre ]]--
	self:Log("SPELL_AURA_APPLIED", "WrongMovesApplied", 330848)
	self:Log("SPELL_AURA_REMOVED", "WrongMovesRemoved", 330848)
end

function mod:OnEngage()
	self:OpenProximity(327475, 6) -- Anima Fountain
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ Castellan Niklaus ]]--

do
	local function printTarget(self, name, guid)
		self:TargetMessage2(328334, "orange", name)
		if self:Me(guid) then
			self:Say(328334)
			self:PlaySound(328334, "warning")
		end
	end

	function mod:TacticalAdvance(args)
		self:GetUnitTarget(printTarget, 0.3, args.sourceGUID)
	end
end

function mod:UnyieldingShield(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	--self:Bar(args.spellId, 42)
end

function mod:UnstoppableCharge(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
	--self:Bar(args.spellId, 42)
end

function mod:CastellansCadre(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	--self:Bar(args.spellId, 42)
end

function mod:Fixate(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
	end
end


--[[ Baroness Frieda ]]--

function mod:DrainEssence(args)
	local amount = args.amount or 1
	if amount % 3 == 1 then -- lets see how fast it stacks
		self:StackMessage(args.spellId, args.destName, amount, "purple")
		self:PlaySound(args.spellId, "info")
	end
end

function mod:BoltOfPower(args)
	self:Message2(args.spellId, "yellow", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 42)
end

function mod:ScarletLetter(args)
	self:TargetMessage2(args.spellId, "red", args.destName)
	self:PlaySound(args.spellId, "long")
	self:TargetBar(args.spellId, args.destName, 8)
	--self:Bar(args.spellId, 42)

	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 8)
	end
end

function mod:ScarletLetterRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:DredgerServants(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	--self:Bar(args.spellId, 42)
end

--[[ Lord Stavros ]]--

function mod:EvasiveLunge(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, 42)
end

function mod:WaltzOfBlood(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	--self:Bar(args.spellId, 42)
end

do
	local playerList = mod:NewTargetList()
	function mod:DarkRecitalApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:PlaySound(args.spellId, "warning")
			self:TargetBar(args.spellId, args.destName, 20)
		end
		self:TargetsMessage(args.spellId, "red", playerList)
	end

	function mod:DarkRecitalRemoved(args)
		if self:Me(args.destGUID) then
			self:StopBar(args.spellId, args.destName)
		end
	end
end

function mod:DancingFools(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	--self:Bar(args.spellId, 42)
end

--[[ Intermission: The Danse Macabre ]]--

function mod:WrongMovesApplied(args)
	if self:Me(args.destGUID) then
		self:Message2(args.spellId, "red", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "info")
		self:TargetBar(args.spellId, args.destName, 30)
	end
end

function mod:WrongMovesRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellId, args.destName)
	end
end
