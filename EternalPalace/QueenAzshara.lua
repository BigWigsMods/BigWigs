if not IsTestBuild() then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Queen Azshara", 2164, 2361)
if not mod then return end
mod:RegisterEnableMob(152910) -- Queen Azshara
mod.engageId = 2299
--mod.respawnTime = 31

--------------------------------------------------------------------------------
-- Local
--

local ancientWardCount = 3

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.ancient_ward_down = "Ancient Ward Powered Down! (%d remaining)"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- 300074, -- Pressure Surge
		-- 298569, -- Drained Soul
		297937, -- Painful Memories
		297934, -- Longing
		297912, -- Torment
		297907, -- Cursed Heart
		298121, -- Lightning Orbs
		297972, -- Lightning Bolt
		{298014, "TANK_HEALER"}, -- Cold Blast
		{298021, "TANK_HEALER"}, -- Ice Shard
		{298756, "TANK"}, -- Serrated Edge
		298425, -- Charged Spear
		298787, -- Arcane Orbs
		299094, -- Beckon
		299250, -- Queen's Decree
		302999, -- Arcane Vulnerability
		300518, -- Arcane Detonation
		297371, -- Reversal of Fortune
		{303657, "SAY", "SAY_COUNTDOWN"}, -- Arcane Burst
		297372, -- Inversion
		{300743, "TANK"}, -- Void Touched
		303980, -- Nether Portal
		300807, -- Overload
	},{
		[297937] = -20254, -- Aethanel and Cyranus, the Cursed Lovers
		[298121] = -20261, -- Aethanel
		[298756] = -20266, -- Cyranus
		[298787] = -20450, -- Queen Azshara
		[299250] = CL.intermission, -- Intermission One: Queen's Decree
		[302999] = -20323, -- Stage Two: Hearts Unleashed
		[297372] = -20340, -- Stage Three: Song of the Tides
		[300743] = -20361, -- Stage Four: My Palace Is a Prison
	}
end

function mod:OnBossEnable()
	-- self:Log("SPELL_CAST_SUCCESS", "PressureSurge", 300074)
	-- self:Log("SPELL_CAST_SUCCESS", "DrainedSoul", 298569)
	-- Stage 1
	self:Log("SPELL_CAST_START", "PainfulMemories", 297937)
	self:Log("SPELL_CAST_START", "Longing", 297934)
	self:Log("SPELL_AURA_APPLIED", "Torment", 297912)

	-- Aethanel
	self:Log("SPELL_CAST_START", "LightningOrbs", 298121)
	self:Log("SPELL_CAST_START", "LightningBolt", 297972)
	self:Log("SPELL_CAST_START", "ColdBlast", 298014)
	self:Log("SPELL_AURA_APPLIED", "ColdBlastApplied", 298014)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ColdBlastApplied", 298014)
	self:Log("SPELL_CAST_START", "IceShard", 298021)

	-- Cyranus
	self:Log("SPELL_AURA_APPLIED", "SerratedEdgeApplied", 298756)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SerratedEdgeApplied", 298756)
	self:Log("SPELL_CAST_SUCCESS", "ChargedSpear", 298425)

	-- Queen Azshara
	self:Log("SPELL_CAST_START", "ArcaneOrbs", 298787)
	self:Log("SPELL_CAST_START", "Beckon", 298787)
	self:Log("SPELL_AURA_APPLIED", "BeckonApplied", 299094)

	-- Intermission
	self:Log("SPELL_CAST_START", "QueensDecree", 299250)
	self:Log("SPELL_AURA_APPLIED", "PersonalDecrees", 299249, 299251, 299254, 299255, 299252, 299253) -- Suffer!, Obey!, Stand Together!, Stand Alone!, March!, Stay!

	-- Stage 2
	self:Log("SPELL_AURA_APPLIED", "ArcaneVulnerabilityApplied", 302999)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ArcaneVulnerabilityApplied", 302999)
	self:Log("SPELL_CAST_START", "ArcaneDetonation", 300518)
	self:Log("SPELL_CAST_START", "ReversalofFortune", 297371)
	self:Log("SPELL_AURA_APPLIED", "ArcaneBurstApplied", 303657)
	self:Log("SPELL_AURA_REMOVED", "ArcaneBurstRemoved", 303657)

	-- Stage 3
	self:Log("SPELL_CAST_START", "Inversion", 297372)

	-- Stage 4
	self:Log("SPELL_AURA_APPLIED", "VoidTouchedApplied", 300743)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VoidTouchedApplied", 300743)
	self:Log("SPELL_CAST_SUCCESS", "NetherPortal", 303980)
	self:Log("SPELL_CAST_START", "Overload", 300807)

	-- Ground Effects
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 297907) -- Cursed Heart
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 297907)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 297907)
end

function mod:OnEngage()
	ancientWardCount = 3
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- function mod:PressureSurge(args)
	-- ancientWardCount = ancientWardCount - 1
	-- self:Message2(args.spellId, "cyan", L.ancient_ward_down:format(ancientWardCount))
	-- self:PlaySound(args.spellId, "long")
-- end

-- function mod:PressureSurge(args)
	-- ancientWardCount = ancientWardCount + 1
	-- self:Message2(args.spellId, "cyan")
	-- self:PlaySound(args.spellId, "long")
-- end

function mod:PainfulMemories(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
end

function mod:Longing(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
end

do
	local prev = 0
	function mod:Torment(args)
		local t = GetTime()
		if t-prev > 1.5 then
			prev = t
			self:Message2(args.spellId, "red")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

-- Aethanel
function mod:LightningOrbs(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:LightningBolt(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message2(args.spellId, "orange")
		if ready then
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:ColdBlast(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
end

function mod:ColdBlastApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	self:PlaySound(args.spellId, amount == 3 and "warning" or "alarm", nil, args.destName)
end

function mod:IceShard(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
end

function mod:SerratedEdgeApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	self:PlaySound(args.spellId, "alert", nil, args.destName)
end

function mod:ChargedSpear(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

-- Queen Azshara
function mod:ArcaneOrbs(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:Beckon(args)
	self:Message2(args.spellId, "cyan")
	--self:PlaySound(args.spellId, "alert")
end

function mod:BeckonApplied(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	self:PlaySound(args.spellId, "alert", nil, args.destName)
end

-- Intermission
function mod:QueensDecree(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
end

function mod:PersonalDecrees(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(299250, nil, args.spellName, args.spellId)
		self:PlaySound(299250, "alarm")
	end
end

-- Stage 2
function mod:ArcaneVulnerabilityApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 0 then
			self:StackMessage(args.spellId, args.destName, amount, "blue")
			if amount > 5 then
				self:PlaySound(args.spellId, "alarm")
			end
		end
	end
end

function mod:ArcaneDetonation(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:ReversalofFortune(args)
	self:Message2(args.spellId, "info")
	self:PlaySound(args.spellId, "long")
end

function mod:ArcaneBurstApplied(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	self:PlaySound(args.spellId, "alert", nil, args.destName)
	self:TargetBar(args.spellId, 10, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 10)
	end
end

function mod:ArcaneBurstRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	self:StopBar(args.spellId, args.destName)
end

-- Stage 3
function mod:Inversion(args)
	self:Message2(args.spellId, "info")
	self:PlaySound(args.spellId, "long")
end

-- Stage 4
function mod:VoidTouchedApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	self:PlaySound(args.spellId, "alert", nil, args.destName)
end

function mod:NetherPortal(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:Overload(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
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
