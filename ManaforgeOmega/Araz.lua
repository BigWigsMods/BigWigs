if not BigWigsLoader.isNext then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Forgeweaver Araz", 2810, 2687)
if not mod then return end
mod:RegisterEnableMob(233817) -- Forgeweaver Araz
mod:SetEncounterID(3132)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local overwhelmingPowerCount = 1
local arcaneObliterationCount = 1
local arcaneObliterationTotalCount = 1
local silencingTempestCount = 1
local arcaneExpulsionCount = 1
local invokerCollectorCount = 1
local astralHarvestCount = 1

local voidHarvestCount = 1
local voidTearCount = 1
local deathThroesCount = 1

local timersEasy = {
	[1] = { -- from pull
		[1228502] = {4.0, 22.0, 22.0, 22.0, 22.0, 22.0, 0}, -- Overwhelming Power
		[1228216] = {30.9, 45.0, 0}, -- Arcane Obliteration
		[1228188] = {97.9, 0}, -- Silencing Tempest
		[1231720] = {10.9, 44.0, 0}, -- Invoke Collector
		[1228214] = {19.9, 44.0, 8.0, 23.0, 8.0, 0}, -- Astral Harvest
		[1248171] = {0}, -- Void Tear
	},
	[2] = { -- from Mana Sacrifice _START
		[1228502] = {18.6, 22.0, 22.0, 22.0, 22.0, 0}, -- Overwhelming Power
		[1228216] = {68.6, 0}, -- Arcane Obliteration
		[1228188] = {47.2, 0}, -- Silencing Tempest
		[1231720] = {25.7, 22.0, 0}, -- Invoke Collector
		[1228214] = {34.7, 22.0, 8.0, 23.0, 8.0, 0}, -- Astral Harvest
		[1248171] = {0}, -- Void Tear
	},
}

local timersHeroic = {
	[1] = { -- from pull
		[1228502] = {4.0, 22.0, 22.0, 22.0, 22.0, 22.0, 0}, -- Overwhelming Power
		[1228216] = {30.9, 45.0, 0}, -- Arcane Obliteration
		[1228188] = {63.0, 44.0, 23.0, 0}, -- Silencing Tempest
		[1231720] = {9.0, 44.0, 44.0, 0}, -- Invoke Collector
		[1228214] = {20.0, 46.0, 8.0, 36.0, 8.0, 8.0, 0}, -- Astral Harvest
		[1248171] = {0}, -- Void Tear
	},
	[2] = { -- from Mana Sacrifice _START
		[1228502] = {18.6, 22.0, 22.0, 22.0, 22.0, 22.0, 0}, -- Overwhelming Power
		[1228216] = {68.6, 0}, -- Arcane Obliteration
		[1228188] = {57.6, 44.0, 21.0, 0}, -- Silencing Tempest
		[1231720] = {23.6, 22.0, 44.0, 0}, -- Invoke Collector
		[1228214] = {34.6, 22.0, 8.0, 36.0, 8.0, 8.0, 0}, -- Astral Harvest
		[1248171] = {0}, -- Void Tear
	},
}

local timersMythic = {
	[1] = { -- from pull
		[1228502] = {4.0, 22.0, 22.0, 22.0, 22.0, 22.0, 0}, -- Overwhelming Power
		[1228216] = {31.0, 45.0, 0}, -- Arcane Obliteration
		[1228188] = {63.0, 44, 23.0, 0}, -- Silencing Tempest
		[1231720] = {8.9, 44.0, 44.0, 0}, -- Invoke Collector
		[1228214] = {24.0, 46.0, 15.0, 29.5, 15.6, 15.0, 0}, -- Astral Harvest
		[1248171] = {22.0, 46.0, 15.0, 28.5, 15.5, 15.1, 0}, -- Void Tear
	},
	[2] = { -- from Mana Sacrifice _START
		[1228502] = {18.9, 22.0, 22.0, 22.0, 22.0, 22.0, 0}, -- Overwhelming Power
		[1228216] = {69.0, 0}, -- Arcane Obliteration
		[1228188] = {57.8, 44.0, 21.0, 0}, -- Silencing Tempest
		[1231720] = {23.8, 22.0, 44.0, 0}, -- Invoke Collector
		[1228214] = {38.9, 21.5, 15.5, 29.0, 15.0, 14.5, 0}, -- Astral Harvest
		[1248171] = {36.9, 21.5, 15.5, 29.0, 15.0, 14.5, 0}, -- Void Tear
	},
}

local timers = mod:Mythic() and timersMythic or mod:Heroic() and timersHeroic or timersEasy

local function getTimers(spellId, count)
	if timers[arcaneExpulsionCount] then
		return timers[arcaneExpulsionCount][spellId][count]
	end
end

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.invoke_collector = "Collector" -- Short for Arcane Collector
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:SetSpellRename(1231720, L.invoke_collector) -- Invoke Collector (Collector)
	self:SetSpellRename(1228214, CL.orbs) -- Astral Harvest (Orbs)
	self:SetSpellRename(1228216, CL.soak) -- Arcane Obliteration (Soak)
	self:SetSpellRename(1228188, CL.pools) -- Silencing Tempest (Pools)
	self:SetSpellRename(1227631, CL.knockback) -- Arcane Expulsion (Knockback)
	self:SetSpellRename(1234328, CL.dodge) -- Photon Blast (Dodge)
	self:SetSpellRename(1232590, CL.raid_damage) -- Arcane Convergence (Raid Damage)
	self:SetSpellRename(1233415, CL.weakened) -- Mana Splinter (Weakened)
	self:SetSpellRename(1243901, CL.orbs) -- Void Harvest (Orbs)
	self:SetSpellRename(1232221, CL.knockback) -- Death Throes (Knockback)
end

function mod:GetOptions()
	return {
		"stages",
		"berserk",
		-- Stage One: Priming the Forge
		1231720, -- Invoke Collector
			-- Arcane Collector
				{1228214, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Astral Harvest
					-- Arcane Manifestation
						1236207, -- Astral Surge
		1228216, -- Arcane Obliteration
			-- Arcane Echo
				-- 1228454, -- Mark of Power XXX Add warning when too close?
			1228219, -- Astral Mark
		{1228188, "SAY", "ME_ONLY_EMPHASIZE"}, -- Silencing Tempest
		{1228502, "TANK"}, -- Overwhelming Power
		{1227631, "CASTBAR"}, -- Arcane Expulsion
		{1248009, "CASTBAR"}, -- Dark Terminus
		-- Intermission: The Iris Opens
			1240705, -- Astral Burn
			1240437, -- Volatile Surge
			1232412, -- Focusing Iris
			-- Arcane Collector
				{1234328, "NAMEPLATE"}, -- Photon Blast
				1232590, -- Arcane Convergence
			-32596, -- Shielded Attendant
				{1238266, "TANK"}, -- Ramping Power
			{1233415, "CASTBAR", "CASTBAR_COUNTDOWN"}, -- Mana Splinter
		-- Stage Two: Darkness Hungers
			1233074, -- Crushing Darkness
			{1243901, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Void Harvest
				-- Void Manifestation
					1243641, -- Void Surge
		-- Mythic
		1248171, -- Void Tear
		1232221, -- Death Throes
	},{
		{
			tabName = CL.stage:format(1),
			{1231720, 1228214, 1236207, 1228216, 1228219, 1228188, 1228502, 1227631, 1248009, 1248171},
		},
		{
			tabName = CL.intermission,
			{1240705, 1240437, 1232412, 1234328, 1232590, -32596, 1238266, 1233415},
		},
		{
			tabName = CL.stage:format(2),
			{1233074, 1243901, 1243641, 1228188, 1228502, 1232221},
		},
		[1248171] = "mythic",
		[1232221] = "mythic",
	},{
		[1231720] = L.invoke_collector, -- Invoke Collector (Collector)
		[1228214] = CL.orbs, -- Astral Harvest (Orbs)
		[1228216] = CL.soak, -- Arcane Obliteration (Soak)
		[1228188] = CL.pools, -- Silencing Tempest (Pools)
		[1227631] = CL.knockback, -- Arcane Expulsion (Knockback)
		[1234328] = CL.dodge, -- Photon Blast (Dodge)
		[1232590] = CL.raid_damage, -- Arcane Convergence (Raid Damage)
		[-32596] = CL.adds, -- Shielded Attendant (Adds)
		[1233415] = CL.weakened, -- Mana Splinter (Weakened)
		[1243901] = CL.orbs, -- Void Harvest (Orbs)
		[1232221] = CL.knockback, -- Death Throes (Knockback)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	-- Stage One: Priming the Forge
	self:Log("SPELL_CAST_START", "OverwhelmingPower", 1228502)
	self:Log("SPELL_AURA_APPLIED", "OverwhelmingPowerApplied", 1228502)
	self:Log("SPELL_AURA_APPLIED_DOSE", "OverwhelmingPowerApplied", 1228502)
	self:Log("SPELL_CAST_START", "ArcaneObliteration", 1228216)
	self:Log("SPELL_AURA_APPLIED", "AstralMarkApplied", 1228219)
	self:Log("SPELL_CAST_START", "SilencingTempest", 1228161)
	self:Log("SPELL_AURA_APPLIED", "SilencingTempestApplied", 1228188, 1238874) -- Silencing Tempest, Echoing Tempest
	self:Log("SPELL_AURA_REMOVED", "SilencingTempestRemoved", 1228188, 1238874)
	self:Log("SPELL_CAST_START", "ArcaneExpulsion", 1227631)
	self:Log("SPELL_CAST_START", "InvokeCollector", 1231720)
	self:Log("SPELL_CAST_START", "AstralHarvest", 1228213)
	self:Log("SPELL_AURA_APPLIED", "AstralHarvestApplied", 1228214)
	self:Log("SPELL_AURA_APPLIED", "AstralSurgeApplied", 1236207)
	self:Log("SPELL_AURA_APPLIED_DOSE", "AstralSurgeApplied", 1236207)
	self:Log("SPELL_CAST_START", "DarkTerminus", 1248009)
	-- Intermission: The Iris Opens
	self:Log("SPELL_CAST_SUCCESS", "IntermissionStart", 1230231) -- Staging into intermission
	self:Log("SPELL_AURA_APPLIED", "AstralBurnApplied", 1240705)
	self:Log("SPELL_AURA_APPLIED_DOSE", "AstralBurnApplied", 1240705)
	self:Log("SPELL_AURA_APPLIED", "VolatileSurgeApplied", 1240437)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VolatileSurgeApplied", 1240437)
	self:Log("SPELL_AURA_APPLIED", "FocusingIrisDamage", 1232412)
	self:Log("SPELL_PERIODIC_DAMAGE", "FocusingIrisDamage", 1232412)
	self:Log("SPELL_PERIODIC_MISSED", "FocusingIrisDamage", 1232412)
	self:Log("SPELL_CAST_START", "PhotonBlast", 1234328)
	self:Log("SPELL_CAST_SUCCESS", "PhotonBlastSuccess", 1234328)
	self:Log("SPELL_CAST_START", "ArcaneConvergence", 1232590)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RampingPowerApplied", 1238266)
	self:Log("SPELL_CAST_START", "ManaSacrifice", 1230529) -- Intermission Ending
	self:Log("SPELL_AURA_APPLIED", "ManaSacrificeApplied", 1230529)
	self:Log("SPELL_AURA_APPLIED", "ManaSplinterApplied", 1233415)
	-- Stage Two: Darkness Hungers
	self:Log("SPELL_AURA_APPLIED", "CrushingDarknessDamage", 1233074)
	self:Log("SPELL_PERIODIC_DAMAGE", "CrushingDarknessDamage", 1233074)
	self:Log("SPELL_PERIODIC_MISSED", "CrushingDarknessDamage", 1233074)
	self:Log("SPELL_CAST_START", "VoidHarvest", 1243887)
	self:Log("SPELL_AURA_APPLIED", "VoidHarvestApplied", 1243901)
	self:Log("SPELL_AURA_APPLIED", "VoidSurgeApplied", 1243641)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VoidSurgeApplied", 1243641)
	-- Mythic
	self:Log("SPELL_CAST_START", "VoidTear", 1248133)
	self:Log("SPELL_CAST_START", "DeathThroes", 1232221)

	timers = self:Mythic() and timersMythic or self:Heroic() and timersHeroic or timersEasy
end

function mod:OnEngage()
	self:SetStage(1)

	overwhelmingPowerCount = 1
	arcaneObliterationCount = 1
	arcaneObliterationTotalCount = 1
	silencingTempestCount = 1
	arcaneExpulsionCount = 1
	invokerCollectorCount = 1
	astralHarvestCount = 1
	voidTearCount = 1

	self:Bar(1228502, getTimers(1228502, 1), CL.count:format(self:SpellName(1228502), overwhelmingPowerCount)) -- Overwhelming Power
	self:Bar(1231720, getTimers(1231720, 1), CL.count:format(L.invoke_collector, invokerCollectorCount)) -- Invoke Collector
	self:Bar(1228214, getTimers(1228214, 1), CL.count:format(CL.orbs, astralHarvestCount)) -- Astral Harvest
	self:Bar(1228216, getTimers(1228216, 1), CL.count:format(CL.soak, arcaneObliterationTotalCount)) -- Arcane Obliteration
	self:Bar(1228188, getTimers(1228188, 1), CL.count:format(CL.pools, silencingTempestCount)) -- Silencing Tempest
	self:Bar(1227631, self:Easy() and 125.0 or 155.0, CL.count:format(CL.knockback, arcaneExpulsionCount)) -- Arcane Expulsion
	if self:Mythic() then
		self:Bar(1248171, getTimers(1248171, 1), CL.count:format(self:SpellName(1248171), voidTearCount)) -- Void Tear
	end
	if self:Heroic() then
		self:Berserk(600) -- Heroic PTR
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 1233072 then -- -Phase Transition P2 -> P3-
		self:Stage2Start()
	end
end

-- Stage One: Priming the Forge
function mod:OverwhelmingPower(args)
	self:StopBar(CL.count:format(args.spellName, overwhelmingPowerCount))
	self:Message(args.spellId, "purple", CL.casting:format(CL.count:format(args.spellName, overwhelmingPowerCount)))
	self:PlaySound(args.spellId, "alert")
	overwhelmingPowerCount = overwhelmingPowerCount + 1
	local cd
	if self:GetStage() == 1 then  -- 6 per rotation
		cd = getTimers(args.spellId, overwhelmingPowerCount)
	elseif self:GetStage() == 2 then
		cd = 44
	end
	self:Bar(args.spellId, cd, CL.count:format(args.spellName, overwhelmingPowerCount))
end

function mod:OverwhelmingPowerApplied(args)
	local highStacks = 4
	local amount = args.amount or 1
	self:StackMessage(args.spellId, "purple", args.destName, amount, highStacks)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm", nil, args.destName)
	elseif self:Tank() and amount >= highStacks then
		self:PlaySound(args.spellId, "warning") -- swap?
	end
end

function mod:ArcaneObliteration(args)
	self:StopBar(CL.count:format(CL.soak, arcaneObliterationTotalCount))
	self:Message(args.spellId, "red", CL.count:format(CL.soak, arcaneObliterationTotalCount))
	self:PlaySound(args.spellId, "warning") -- soak if needed
	arcaneObliterationCount = arcaneObliterationCount + 1
	arcaneObliterationTotalCount = arcaneObliterationTotalCount + 1 -- Total count as in mythic you can only soak 1 in the whole fight.
	self:Bar(args.spellId, getTimers(args.spellId, arcaneObliterationCount), CL.count:format(CL.soak, arcaneObliterationTotalCount))
end

function mod:AstralMarkApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm") -- cant soak next
	end
end

function mod:SilencingTempest()
	self:StopBar(CL.count:format(CL.pools, silencingTempestCount))
	self:Message(1228188, "cyan", CL.count:format(CL.pools, silencingTempestCount))
	silencingTempestCount = silencingTempestCount + 1
	local cd = getTimers(1228188, silencingTempestCount)
	self:Bar(1228188, cd, CL.count:format(CL.pools, silencingTempestCount))
end

function mod:SilencingTempestApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(1228188, nil, CL.pools)
		self:PlaySound(1228188, "warning", nil, args.destName) -- move out
		self:Say(1228188, CL.pools, true, "Pools")
	end
end

function mod:SilencingTempestRemoved(args)
	if self:Me(args.destGUID) then
		self:Say(1228188, CL.over:format(CL.pools), true, "Pools Over")
	end
end

function mod:ArcaneExpulsion(args)
	self:StopBar(CL.count:format(CL.knockback, arcaneExpulsionCount))
	self:Message(args.spellId, "red", CL.count:format(CL.knockback, arcaneExpulsionCount))
	self:PlaySound(args.spellId, "warning") -- knocback inc
	self:CastBar(args.spellId, 5, CL.count:format(CL.knockback, arcaneExpulsionCount))
	arcaneExpulsionCount = arcaneExpulsionCount + 1
end

function mod:InvokeCollector(args)
	self:StopBar(CL.count:format(L.invoke_collector, invokerCollectorCount))
	self:Message(args.spellId, "cyan", CL.count:format(L.invoke_collector, invokerCollectorCount))
	self:PlaySound(args.spellId, "long") -- debuffs incoming
	invokerCollectorCount = invokerCollectorCount + 1
	local cd = getTimers(args.spellId, silencingTempestCount)
	self:Bar(args.spellId, cd, CL.count:format(L.invoke_collector, invokerCollectorCount))
end

function mod:AstralHarvest()
	self:StopBar(CL.count:format(CL.orbs, astralHarvestCount))
	self:Message(1228214, "yellow", CL.count:format(CL.orbs, astralHarvestCount))
	self:PlaySound(1228214, "info")
	astralHarvestCount = astralHarvestCount + 1
	local cd = getTimers(1228214, astralHarvestCount)
	self:Bar(1228214, cd, CL.count:format(CL.orbs, astralHarvestCount))
end

function mod:AstralHarvestApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning", nil, args.destName) -- move out
		self:Say(args.spellId, CL.orb, nil, "Orb")
		self:SayCountdown(args.spellId, 4)
	end
end

function mod:AstralSurgeApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, 1)
		self:PlaySound(args.spellId, "alarm", nil, args.destName) -- raid dot
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

function mod:DarkTerminus(args) -- Early P2 Starting
	self:StopBar(CL.count:format(self:SpellName(1228502), overwhelmingPowerCount)) -- Overwhelming Power
	self:StopBar(CL.count:format(L.invoke_collector, invokerCollectorCount)) -- Invoke Collector
	self:StopBar(CL.count:format(CL.orbs, astralHarvestCount)) -- Astral Harvest
	self:StopBar(CL.count:format(CL.soak, arcaneObliterationTotalCount)) -- Arcane Obliteration
	self:StopBar(CL.count:format(CL.pools, silencingTempestCount)) -- Silencing Tempest
	self:StopBar(CL.count:format(CL.knockback, arcaneExpulsionCount)) -- Arcane Expulsion
	self:StopBar(CL.count:format(self:SpellName(1248133), voidTearCount)) -- Void Tear

	self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, 7)
end

-- Intermission: The Iris Opens
function mod:IntermissionStart()
	self:SetStage(1.5)
	self:Message("stages", "cyan", CL.intermission, false)
	self:PlaySound("stages", "long") -- intermission

	self:StopBar(CL.count:format(self:SpellName(1228502), overwhelmingPowerCount)) -- Overwhelming Power
	self:StopBar(CL.count:format(L.invoke_collector, invokerCollectorCount)) -- Invoke Collector
	self:StopBar(CL.count:format(CL.orbs, astralHarvestCount)) -- Astral Harvest
	self:StopBar(CL.count:format(CL.soak, arcaneObliterationCount)) -- Arcane Obliteration
	self:StopBar(CL.count:format(CL.pools, silencingTempestCount)) -- Silencing Tempest
	self:StopBar(CL.count:format(CL.knockback, arcaneExpulsionCount)) -- Arcane Expulsion
	self:StopBar(CL.count:format(self:SpellName(1248133), voidTearCount)) -- Void Tear

	self:Bar(-32596, 21, CL.adds, 1232738) -- Shielded Attendant. Hardened Shell Icon
end

do
	local prev = 0
	function mod:FocusingIrisDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou", nil, args.destName)
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

function mod:PhotonBlast(args)
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:UnitWithinRange(unit, 45) then
		self:Message(args.spellId, "yellow", CL.dodge)
		self:PlaySound(args.spellId, "alert") -- dodge
	end
	self:Nameplate(args.spellId, 0, args.sourceGUID)
	-- How can we clear the nameplates for this? needed?
end

function mod:PhotonBlastSuccess(args)
	self:Nameplate(args.spellId, 8, args.sourceGUID)
end

function mod:ArcaneConvergence(args)
	self:Message(args.spellId, "orange", CL.raid_damage)
	self:PlaySound(args.spellId, "alarm") -- raid damage inc
end

function mod:RampingPowerApplied(args)
	local amount = args.amount or 1
	local highStacks = 10 -- why are you still tanking?
	if amount == 5 or amount >= highStacks then -- 5 & 10 (capped at 10?)
		self:StackMessage(args.spellId, "purple", args.destName, amount, highStacks)
		if amount >= highStacks then
			self:PlaySound(args.spellId, "alarm", nil, args.destName) -- swap?
		end
	end
end

function mod:ManaSacrifice() -- Back to P1 / P2
	if arcaneExpulsionCount <= 2 then -- Stage 1
		self:Message("stages", "green", CL.stage:format(1), false)
		self:PlaySound("stages", "long")
		self:SetStage(1)

		arcaneObliterationCount = 1
		overwhelmingPowerCount = 1
		silencingTempestCount = 1
		astralHarvestCount = 1
		invokerCollectorCount = 1
		voidTearCount = 1

		-- Move these to the actual p1 start? small improvement or no difference?
		self:Bar(1228502, getTimers(1228502, overwhelmingPowerCount), CL.count:format(self:SpellName(1228502), overwhelmingPowerCount)) -- Overwhelming Power
		self:Bar(1228216, getTimers(1228216, arcaneObliterationCount), CL.count:format(CL.soak, arcaneObliterationTotalCount)) -- Arcane Obliteration
		self:Bar(1228214, getTimers(1228214, astralHarvestCount), CL.count:format(CL.orbs, astralHarvestCount)) -- Astral Harvest
		self:Bar(1228188, getTimers(1228188, silencingTempestCount), CL.count:format(CL.pools, silencingTempestCount)) -- Silencing Tempest
		self:Bar(1231720, getTimers(1231720, invokerCollectorCount), CL.count:format(L.invoke_collector, invokerCollectorCount)) -- Invoke Collector
		self:Bar(1227631, self:Easy() and 120.0 or 140.0, CL.count:format(CL.knockback, arcaneExpulsionCount)) -- Arcane Expulsion
		if self:Mythic() then
			self:Bar(1248171, getTimers(1248171, voidTearCount), CL.count:format(self:SpellName(1248171), voidTearCount)) -- Void Tear
		end
	else -- Stage 2
		self:Message("stages", "green", CL.soon:format(CL.stage:format(2)), false)
		self:PlaySound("stages", "long")
	end
end

function mod:ManaSacrificeApplied()
	self:CastBar(1233415, 5, CL.weakened)
end

function mod:ManaSplinterApplied(args)
	self:TargetMessage(args.spellId, "red", args.destName)
	self:PlaySound(args.spellId, "long") -- weakened
	self:Bar(args.spellId, 12, CL.weakened)
end

function mod:AstralBurnApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 3 == 1 then -- 1, 4, 7, etc.
			self:StackMessage(args.spellId, "blue", args.destName, amount, 1)
			self:PlaySound(args.spellId, "alarm", nil, args.destName) -- stacking debuff
		end
	end
end

-- Stage Two: Darkness Hungers
function mod:Stage2Start()
	self:SetStage(2)
	self:Message("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long") -- stage 2

	voidHarvestCount = 1
	silencingTempestCount = 1
	overwhelmingPowerCount = 1
	deathThroesCount = 1

	self:Bar(1228502, 8, CL.count:format(self:SpellName(1228502), overwhelmingPowerCount)) -- Overwhelming Power
	self:Bar(1243901, 16.0, CL.count:format(CL.orbs, voidHarvestCount)) -- Void Harvest
	self:Bar(1228188, 66.0, CL.count:format(CL.pools, silencingTempestCount)) -- Silencing Tempest
	if self:Mythic() then
		self:Bar(1232221, 39.0, CL.count:format(CL.knockback, deathThroesCount)) -- Death Throes
	end
end

do
	local prev = 0
	function mod:CrushingDarknessDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou", nil, args.destName)
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

function mod:VoidHarvest()
	self:StopBar(CL.count:format(CL.orbs, voidHarvestCount))
	self:Message(1243901, "yellow", CL.count:format(CL.orbs, voidHarvestCount))
	self:PlaySound(1243901, "info") -- debuffs incoming
	voidHarvestCount = voidHarvestCount + 1
	local cd = voidHarvestCount % 2 == 0 and 8 or voidHarvestCount == 3 and 80 or 46
	self:Bar(1243901, cd, CL.count:format(CL.orbs, voidHarvestCount))
end

function mod:VoidHarvestApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning", nil, args.destName) -- move out
		self:Say(args.spellId, CL.orb, nil, "Orb")
		self:SayCountdown(args.spellId, 4)
	end
end

function mod:VoidSurgeApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, 1)
		self:PlaySound(args.spellId, "alarm", nil, args.destName) -- raid dot
	end
end

-- Mythic
function mod:VoidTear()
	local spellName = self:SpellName(1248171)
	self:StopBar(CL.count:format(spellName, voidTearCount))
	self:Message(1248171, "orange", CL.count:format(spellName, voidTearCount))
	self:PlaySound(1248171, "alarm") -- watch for void tear location
	voidTearCount = voidTearCount + 1
	local cd = getTimers(1248171, voidTearCount)
	self:Bar(1248171, cd, CL.count:format(spellName, voidTearCount))
end

function mod:DeathThroes(args)
	self:Message(args.spellId, "orange", CL.knockback)
	self:PlaySound(args.spellId, "warning") -- knockback
	deathThroesCount = deathThroesCount + 1
	self:Bar(1248171, 44.0, CL.count:format(CL.knockback, deathThroesCount))
end
