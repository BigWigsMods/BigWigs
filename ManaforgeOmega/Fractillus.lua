if not BigWigsLoader.isTestBuild then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Fractillus", 2810, 2747)
if not mod then return end
mod:RegisterEnableMob(237861) -- Fractillus XXX Confirm
mod:SetEncounterID(3133)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local conjunctionCount = 1
local backhandCount = 1
local crystallizationCount = 1
local slamCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

-- function mod:OnRegister()
-- 	self:SetSpellRename(1234567, "String") -- Spell (Rename)
-- end

function mod:GetOptions()
	return {
		-- 1226089, -- Crystal Nexus
			-- 1232130, -- Nexus Shrapnel
		-- 1236785, -- Void-Infused Nexus
			{1247424, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Null Consumption
				-- 1247495, -- Null Explosion
		1233416, -- Entropic Conjunction
			1224414, -- Entropic Shockwave
		1220394, -- Crystalline Backhand
		1227373, -- Nether Crystallization
			1227378, -- Crystallized
		{1231871, "TANK"}, -- Shockwave Slam
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "NullConsumptionApplied", 1247424)
	self:Log("SPELL_AURA_REMOVED", "NullConsumptionRemoved", 1247424)
	self:Log("SPELL_CAST_START", "EntropicConjunction", 1233416, 1230610) -- XXX 1s / 2s cast times
	self:Log("SPELL_AURA_APPLIED", "EntropicShockwaveApplied", 1224414)
	self:Log("SPELL_CAST_START", "CrystallineBackhand", 1220394)
	self:Log("SPELL_CAST_SUCCESS", "NetherCrystallization", 1227373)
	-- self:Log("SPELL_AURA_APPLIED", "NetherCrystallizationApplied", 1227373) -- On everyone?
	self:Log("SPELL_AURA_APPLIED", "CrystallizedApplied", 1227378)
	self:Log("SPELL_CAST_START", "ShockwaveSlam", 1231871)
	self:Log("SPELL_AURA_APPLIED", "ShockwaveSlamApplied", 1231871)
end

function mod:OnEngage()
	conjunctionCount = 1
	backhandCount = 1
	crystallizationCount = 1
	slamCount = 1

	-- self:Bar(1233416, 6, CL.count:format(self:SpellName(1233416), conjunctionCount)) -- Entropic Conjunction
	-- self:Bar(1220394, 6, CL.count:format(self:SpellName(1220394), backhandCount)) -- Crystalline Backhand
	-- self:Bar(1227373, 6, CL.count:format(self:SpellName(1227373), crystallizationCount)) -- Nether Crystallization
	-- self:Bar(1231871, 6, CL.count:format(self:SpellName(1231871), slamCount)) -- Shockwave Slam
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:NullConsumptionApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId, nil, nil, "Null Consumption")
		self:SayCountdown(args.spellId, 6)
	end
end

function mod:NullConsumptionRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:EntropicConjunction(args)
	self:Message(1233416, "orange", CL.count:format(args.spellName, conjunctionCount))
	self:PlaySound(1233416, "alert") -- watch shockwaves
	conjunctionCount = conjunctionCount + 1
	--self:Bar(1233416, 0, CL.count:format(args.spellName, conjunctionCount))
end

function mod:EntropicShockwaveApplied(args)
	if self:Me(args.destGUID)  then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:CrystallineBackhand(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, backhandCount))
	self:PlaySound(args.spellId, "warning") -- kockback
	backhandCount = backhandCount + 1
	--self:Bar(args.spellId, 0, CL.count:format(args.spellName, backhandCount))
end

function mod:NetherCrystallization(args)
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, crystallizationCount))
	self:PlaySound(args.spellId, "long") -- take your spot before rooted
	crystallizationCount = crystallizationCount + 1
	--self:Bar(args.spellId, 0, CL.count:format(args.spellName, crystallizationCount))
end

function mod:CrystallizedApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm") -- Rooted
	end
end

function mod:ShockwaveSlam(args)
	self:StopBar(CL.count:format(args.spellName, slamCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, slamCount))
	self:PlaySound(args.spellId, "alert")
	slamCount = slamCount + 1
	-- self:Bar(args.spellId, 0, CL.count:format(args.spellName, slamCount))
end

function mod:ShockwaveSlamApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- On you
	elseif self:Tank() then
		self:PlaySound(args.spellId, "warning") -- taunt for breath
	end
end
