if not BigWigsLoader.isTestBuild then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Forgeweaver Araz", 2810, 2687)
if not mod then return end
mod:RegisterEnableMob(247989) -- Forgeweaver Araz XXX Confirm
mod:SetEncounterID(3132)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local arcaneObliterationCount = 1
local silencingTempestCount = 1
local arcaneExpulsionCount = 1
local invokerCollectorCount = 1

local hungeringGloomCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.tempest = "Tempest" -- Short for Echoing Tempest and Silencing Tempest
	L.astral_harvest = "Harvest" -- Short for Astral Harvest
	L.hungering_gloom = "Gloom" -- Short for Hungering Gloom
end

--------------------------------------------------------------------------------
-- Initialization
--

-- function mod:OnRegister()
-- 	self:SetSpellRename(1234567, "String") -- Spell (Rename)
-- end

function mod:GetOptions()
	return {
		{1228502, "TANK"}, -- Overwhelming Power
		1228216, -- Arcane Obliteration
			-- Arcane Echo
				-- 1228454, -- Mark of Power XXX Add warning when too close?
				1238867, -- Echoing Invocation
				{1238874, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Echoing Tempest
			1228219, -- Astral Mark
		{1228188, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Silencing Tempest XXX Add the pacify debuff?
		{1227631, "CASTBAR"}, -- Arcane Expulsion
		1231720, -- Invoke Collector
			-- Arcane Collector
				-- 1231726, -- Arcane Barrier
				-- 1237322, -- Prime Sequence
				-- 1228103, -- Arcane Siphon
				{1228214, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Astral Harvest
					-- Arcane Manifestation
						1236207, -- Astral Surge
		-- Intermission: Priming the Forge
			1240437, -- Volatile Surge
			1232412, -- Focusing Iris
			-- Arcane Collector
				1234328, -- Photon Blast
				-- 1226260, -- Arcane Convergence
			-- Shielded Attendant
				-- 1232738, -- Hardened Shell
				{1238266, "TANK"}, -- Ramping Power
			1233415, -- Mana Splinter
		-- Intermission: The Iris Opens
			-- 1232409, -- Unstable Surge
				1240705, -- Astral Burn
		-- Stage Two: Darkness Hungers
			-- 1233076, -- Dark Singularity
				-- 1233074, -- Crushing Darkness
				{1243901, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Hungering Gloom
					-- Void Manifestation
						1243641, -- Void Surge
	},{
		{
			tabName = CL.stage:format(1),
			{1228502, 1228216, 1238867, 1238874, 1228219, 1228188, 1227631, 1231720, 1228214, 1236207},
		},
		{
			tabName = CL.count:format(CL.intermission, 1),
			{1240437, 1232412, 1234328, 1238266, 1233415},
		},
		{
			tabName = CL.count:format(CL.intermission, 2),
			{1240705, 1232412, 1234328, 1238266, 1233415},
		},
		{
			tabName = CL.stage:format(2),
			{1243901, 1243641, 1228502, 1228188},
		},
	}
end

function mod:OnBossEnable()
	-- General
	self:Log("SPELL_AURA_APPLIED", "OverwhelmingPower", 1228502)
	self:Log("SPELL_AURA_APPLIED_DOSE", "OverwhelmingPower", 1228502)
	self:Log("SPELL_CAST_START", "ArcaneObliteration", 1228216)
	self:Log("SPELL_AURA_APPLIED", "EchoingInvocation", 1238867) -- Channeled
	self:Log("SPELL_CAST_START", "EchoingTempest", 1238873)
	self:Log("SPELL_AURA_APPLIED", "EchoingTempestApplied", 1238874)
	self:Log("SPELL_AURA_APPLIED", "AstralMarkApplied", 1228219)
	self:Log("SPELL_CAST_START", "SilencingTempest", 1228161)
	self:Log("SPELL_AURA_APPLIED", "SilencingTempestApplied", 1228188)
	self:Log("SPELL_CAST_START", "ArcaneExpulsion", 1227631)
	self:Log("SPELL_CAST_START", "InvokeCollector", 1231720)
	self:Log("SPELL_AURA_APPLIED", "AstralHarvestApplied", 1228214)
	self:Log("SPELL_AURA_APPLIED", "AstralSurgeApplied", 1236207)
	self:Log("SPELL_AURA_APPLIED_DOSE", "AstralSurgeApplied", 1236207)
	-- Intermission: Priming the Forge
	self:Log("SPELL_AURA_APPLIED", "VolatileSurgeApplied", 1240437)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VolatileSurgeApplied", 1240437)
	self:Log("SPELL_AURA_APPLIED", "FocusingIrisDamage", 1232412)
	self:Log("SPELL_PERIODIC_DAMAGE", "FocusingIrisDamage", 1232412)
	self:Log("SPELL_PERIODIC_MISSED", "FocusingIrisDamage", 1232412)
	self:Log("SPELL_CAST_START", "PhotonBlast", 1234328)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RampingPowerApplied", 1238266)
	self:Log("SPELL_AURA_APPLIED", "ManaSplinterApplied", 1233415)
	-- Intermission: The Iris Opens
	self:Log("SPELL_AURA_APPLIED", "AstralBurnApplied", 1240705)
	self:Log("SPELL_AURA_APPLIED_DOSE", "AstralBurnApplied", 1240705)
	-- Stage Two: Darkness Hungers
	self:Log("SPELL_CAST_START", "HungeringGloom", 1243887)
	self:Log("SPELL_AURA_APPLIED", "HungeringGloomApplied", 1243901)
	self:Log("SPELL_AURA_APPLIED", "VoidSurgeApplied", 1243641)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VoidSurgeApplied", 1243641)
end

function mod:OnEngage()
	self:SetStage(1)

	arcaneObliterationCount = 1
	silencingTempestCount = 1
	arcaneExpulsionCount = 1
	invokerCollectorCount = 1

	-- self:Bar(1228216, 30, CL.count:format(self:SpellName(1228216), arcaneObliterationCount)) -- Arcane Obliteration
	-- self:Bar(1228188, 30, CL.count:format(self:SpellName(1228188), silencingTempestCount)) -- Silencing Tempest
	-- self:Bar(1227631, 30, CL.count:format(self:SpellName(1227631), arcaneExpulsionCount)) -- Arcane Expulsion
	-- self:Bar(1231720, 30, CL.count:format(self:SpellName(1231720), invokerCollectorCount)) -- Invoke Collector

	hungeringGloomCount = 1 -- move to stage 2 start
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:OverwhelmingPower(args)
	local highStacks = 4
	local amount = args.amount or 1
	self:StackMessage(args.spellId, "purple", args.destName, amount, highStacks)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm")
	elseif self:Tank() and amount >= highStacks then
		self:PlaySound(args.spellId, "warning") -- swap?
	end
end

function mod:ArcaneObliteration(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, arcaneObliterationCount))
	self:PlaySound(args.spellId, "alert")
	arcaneObliterationCount = arcaneObliterationCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, arcaneObliterationCount))
end

function mod:EchoingInvocation(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "info")
end

function mod:EchoingTempest(args)
	self:Message(1238874, "cyan")
end

function mod:EchoingTempestApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning") -- move out
		self:Say(args.spellId, L.tempest, nil, "Tempest")
		self:SayCountdown(args.spellId, 3, nil, 2)
	end
end

function mod:AstralMarkApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm") -- cant soak next
	end
end

function mod:SilencingTempest(args)
	self:Message(1228188, "cyan", CL.count:format(args.spellName, silencingTempestCount))
	self:PlaySound(1228188, "alert")
	silencingTempestCount = silencingTempestCount + 1
	-- self:Bar(1228188, 30, CL.count:format(args.spellName, silencingTempestCount))
end

function mod:SilencingTempestApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning") -- move out
		self:Say(args.spellId, L.tempest, nil, "Tempest")
		self:SayCountdown(args.spellId, 3, nil, 2)
	end
end

function mod:ArcaneExpulsion(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, arcaneExpulsionCount))
	self:PlaySound(args.spellId, "warning") -- knocback inc
	self:CastBar(args.spellId, 5, CL.count:format(args.spellName, arcaneExpulsionCount))
	arcaneExpulsionCount = arcaneExpulsionCount + 1
	-- self:Bar(args.spellId, 30, CL.count:format(args.spellName, arcaneExpulsionCount))
end

function mod:InvokeCollector(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, invokerCollectorCount))
	self:PlaySound(args.spellId, "long") -- debuffs incoming
	invokerCollectorCount = invokerCollectorCount + 1
	-- self:Bar(args.spellId, 30, CL.count:format(args.spellName, invokerCollectorCount))
end

function mod:AstralHarvestApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning") -- move out
		self:Say(args.spellId, L.astral_harvest, nil, "Harvest")
		self:SayCountdown(args.spellId, 4)
	end
end

function mod:AstralSurgeApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, 1)
		self:PlaySound(args.spellId, "alarm") -- failed?
	end
end

function mod:VolatileSurgeApplied(args)
	if self:Me(args.destGUID) then -- 3, 6, 9, etc.
		local amount = args.amount or 1
		if amount % 3 == 1 then
			self:StackMessage(args.spellId, "blue", args.destName, amount, 6)
		end
	end
end

do
	local prev = 0
	function mod:FocusingIrisDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

function mod:PhotonBlast(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert") -- dodge?
end

function mod:RampingPowerApplied(args)
	local amount = args.amount or 1
	local highStacks = 9 -- why are you still tanking?
	if amount % 3 == 1 or amount >= highStacks then -- 3, 6, 9, 10..
		self:StackMessage(args.spellId, "purple", args.destName, amount, highStacks)
		if amount >= highStacks then
			self:PlaySound(args.spellId, "alarm") -- swap?
		end
	end
end

function mod:ManaSplinterApplied(args)
	self:TargetMessage(args.spellId, "red", args.destName)
	self:PlaySound(args.spellId, "long") -- weakened
	self:TargetBar(args.spellId, 23, args.destName)
end

function mod:AstralBurnApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, 1)
		self:PlaySound(args.spellId, "alarm") -- failed?
	end
end

function mod:HungeringGloom(args)
	self:Message(1243901, "yellow", CL.count:format(args.spellName, hungeringGloomCount))
	self:PlaySound(1243901, "long") -- debuffs incoming
	hungeringGloomCount = hungeringGloomCount + 1
	-- self:Bar(1243901, 30, CL.count:format(args.spellName, hungeringGloomCount))
end

function mod:HungeringGloomApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning") -- move out
		self:Say(args.spellId, L.hungering_gloom, nil, "Gloom")
		self:SayCountdown(args.spellId, 4)
	end
end

function mod:VoidSurgeApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, 1)
		self:PlaySound(args.spellId, "alarm") -- failed?
	end
end
