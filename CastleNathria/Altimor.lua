if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Huntsman Altimor", 2296, 2429)
if not mod then return end
mod:RegisterEnableMob(
	165066, -- Huntsman Altimor
	165067, -- Margore
	169457, -- Bargast
	169458) -- Hecutis
mod.engageId = 2418
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Huntsman Altimor ]]--
		335114, -- Sinseeker
		334404, -- Spreadshot

		--[[ Margore ]]--
		{334971, "TANK"}, -- Jagged Claws
		{334945, "SAY", "SAY_COUNTDOWN", "PROXIMITY"}, -- Bloody Thrash

		--[[ Bargast ]]--
		{334797, "TANK_HEALER"}, -- Rip Soul
		334884, -- Devour Soul
		334757, -- Shades of Bargast
		334708, -- Deathly Roar

		--[[ Hecutis ]]--
		{334860, "TANK_HEALER"}, -- Crushing Stone
		{334852, "SAY", "SAY_COUNTDOWN", "FLASH"}, -- Petrifying Howl
		334893, -- Stone Shards
	}, {
		[335114] = -22309, -- Huntsman Altimor
		[334971] = -22312, -- Margore
		[334797] = -22311, -- Bargast
		[334860] = -22310, -- Hecutis
	}
end

function mod:OnBossEnable()
	--[[ Huntsman Altimor ]]--
	self:Log("SPELL_CAST_START", "Sinseeker", 335114) -- ideally will be changed to _AURA_APPLIED or sth where we can announce the targets
	self:Log("SPELL_CAST_START", "Spreadshot", 334404)

	--[[ Margore ]]--
	self:Log("SPELL_AURA_APPLIED", "JaggedClawsApplied", 334971)
	self:Log("SPELL_AURA_APPLIED_DOSE", "JaggedClawsApplied", 334971)
	self:Log("SPELL_AURA_APPLIED", "BloodyThrash", 334945)
	self:Log("SPELL_AURA_REMOVED", "BloodyThrashRemoved", 334945)

	--[[ Bargast ]]--
	self:Log("SPELL_CAST_START", "RipSoulStart", 334797)
	self:Log("SPELL_CAST_SUCCESS", "RipSoul", 334797)
	self:Log("SPELL_AURA_APPLIED", "DevourSoul", 334884)
	self:Log("SPELL_CAST_START", "ShadesOfBargast", 334757)
	self:Log("SPELL_CAST_START", "DeathlyRoar", 334708)
	self:Death("ShadeOfBargastDeath", 171557)

	--[[ Hecutis ]]--
	self:Log("SPELL_AURA_APPLIED", "CrushingStone", 334860)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrushingStone", 334860)
	self:Log("SPELL_AURA_APPLIED", "PetrifyingHowl", 334852)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 334893) -- Stone Shards
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 334893)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 334893)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ Huntsman Altimor ]]--

function mod:Sinseeker(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 42)
end

do
	local prev = 0
	function mod:Spreadshot(args)
		local t = args.time
		if t-prev > 10 then -- I'm still afraid this is going to be too spammy
			prev = t
			self:Message2(args.spellId, "yellow")
			self:PlaySound(args.spellId, "long")
			--self:Bar(args.spellId, 42)
		end
	end
end


--[[ Margore ]]--

function mod:JaggedClawsApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	if amount > 1 then
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:BloodyThrash(args)
	self:TargetMessage2(args.spellId, "orange", args.destName)
	self:OpenProximity(args.spellId, 6, args.destName, true)
	--self:Bar(args.spellId, 42)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 8)
	end
end

function mod:BloodyThrashRemoved(args)
	self:CloseProximity(args.spellId)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end


--[[ Bargast ]]--

function mod:RipSoulStart(args)
	self:Message2(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, 2.5)
	--self:Bar(args.spellId, 42)
end

function mod:RipSoul(args)
	if self:Healer() then
		self:Message2(args.spellId, "green", CL.spawned:format(args.spellName)) -- probably need a better name
		self:PlaySound(args.spellId, "info")
	end
end

function mod:DevourSoul(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end


function mod:ShadesOfBargast(args)
	self:Message2(args.spellId, "green", CL.incoming:format(args.spellName))
	self:PlaySound(args.spellId, "long")
	--self:Bar(args.spellId, 42)
end

do
	local prev = 0
	function mod:DeathlyRoar(args)
		local t = args.time
		if t-prev > 10 then
			prev = t
			self:Message2(args.spellId, "red")
			self:PlaySound(args.spellId, "info")
			self:CastBar(args.spellId, 6)
		end
	end
end

function mod:ShadeOfBargastDeath(args)
	self:StopBar(CL.cast:format(self:SpellName(334708)))
end


--[[ Hecutis ]]--

function mod:CrushingStone(args)
	local amount = args.amount or 1
	if amount % 3 == 1 then -- lets see how fast it stacks
		self:StackMessage(args.spellId, args.destName, amount, "purple")
		self:PlaySound(args.spellId, "info")
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:PetrifyingHowl(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 12)
			self:Flash(args.spellId)
			self:TargetBar(args.spellId, args.destName, 12)
		end
		self:TargetsMessage(args.spellId, "orange", playerList, 3)
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
