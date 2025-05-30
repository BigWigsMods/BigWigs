
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Chrome King Gallywix", 2769, 2646)
if not mod then return end
mod:RegisterEnableMob(231075)
mod:SetEncounterID(3016)
mod:SetPrivateAuraSounds({
	466155, -- Sapper's Satchel
	466344, -- Fused Canisters
	{ -- Overloaded Rockets
		1214760, 1214749, 1214750, 1214757,
		1214758, 1214759, 1214761, 1214762,
		1214763, 1214764, 1214765, 1214766, 1214767
	},
	1219279, -- Gallybux Pest Eliminator
	1218550 -- Biggest Baddest Bomb Barrage
})
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local canistersCount = 1
local bombsCount = 1
local suppressionCount = 1
local ventingHeatCount = 1
local egoCheckCount = 1

local fullCanistersCount = 1
local fullBombsCount = 1
local fullSuppressionCount = 1
local fullVentingHeatCount = 1

local gigaCoilsCount = 1
local gigaBlastCount = 1
local mayhemRocketsCount = 1

local encounterStart = 0
local spawnedDuds = 0

local mobCollector, mobMarks = {}, {}

-- Rashanan style timers: Each Giga Coils starts a mini-phase
local timersLFR = {
	{ -- Phase 1
		[465952] = { 17.3, 31.4, 0 }, -- Big Bad Buncha Bombs
		[467182] = { 33.3, 0 }, -- Suppression
		[466751] = { 22.2, 31.4, 0 }, -- Venting Heat
	},
	{ -- Phase 2
		[469286] = { 73.7, 74.9 }, -- Giga Coils
		[465952] = { -- Big Bad Buncha Bombs
			{ 45.1, 0 },
		},
		[467182] = { -- Suppression
			{ 25.9, 32.0, 0 },
			{ 23.5, },
		},
		[466751] = { -- Venting Heat
			{ 12.6, 40.8, 0 },
			{ 10.2, },
		},
	},
	{ -- Phase 3
		[469286] = { 83.6, 71.0, 74.6, 75.6 }, -- Giga Coils
		[1214607] = { -- Bigger Badder Bomb Blast
			{ 26.2, 33.1, 0 },
			{ 25.8, 0 },
			{ 10.2, 37.5, 0 },
			{ 13.4, 37.5, 0 },
			{ 24.4, },
		},
		[467182] = { -- Suppression
			{ 34.3, 32.5, 0 },
			{ 32.9, 23.7, 0 },
			{ 35.2, 31.2, 0 },
			{ 25.9, 32.5, 0 },
		},
		[466751] = { -- Venting Heat
			{ 21.8, 31.2, 0 },
			{ 20.4, 31.2, 0 },
			{ 22.7, 32.5, 0 },
			{ 20.9, 23.7, 0 },
			{ 11.9, },
		},
	}
}
local timersNormal = {
	{ -- Phase 1
		[466340] = { 7.3, 18.9, 20.4, 21.0, 18.4, 22.9, 0 }, -- Scatterblast Canisters
		[465952] = { 22.3, 39.3, 39.3, 0 }, -- Big Bad Buncha Bombs
		[467182] = { 34.9, 43.2, 37.4, 0 }, -- Suppression
		[466751] = { 13.9, 28.7, 31.5, 30.6, 0 }, -- Venting Heat
	},
	{ -- Phase 2 (4:48 third coils)
		[469286] = { 9.0, 70.7, 70.7 }, -- Giga Coils
		[466341] = { -- Fused Canisters
			{ 12.7, 41.2, 0 },
			{ 34.0, 0 },
		},
		[465952] = { -- Big Bad Buncha Bombs
			{ 44.7, 0 },
			{ 46.3, 0 },
		},
		[467182] = { -- Suppression
			{ 29.9, 0 },
			{ 8.9, 43.7, 0 },
		},
		[466751] = { -- Venting Heat
			{ 25.5, 0 },
			{ 20.8, 0 },
		},
	},
	{ -- Phase 3
		[469286] = { 60.1, 59.5, 66.4, 54.5, 60.0, 67.8 }, -- Giga Coils
		[466342] = { -- Tick-Tock Canisters
			{ 22.0, 0 },
			{ 6.5, 35.0, 0 },
			{ 27.3, 0 },
			{ 6.0, 35.0, 0 },
			{ 31.6, 0 },
			{ 17.6, 37.0, 0 },
		},
		[1214607] = { -- Bigger Badder Bomb Blast
			{ 8.0, 34.0, 0 },
			{ 28.5, 0 },
			{ 16.9, 37.0, 0 },
			{ 25.6, 0 },
			{ 34.0, 0 },
			{ 30.2, 0 },
		},
		[467182] = { -- Suppression
			{ 33.0, 0 },
			{ 20.9, 0 },
			{ 7.3, 37.0, 0 },
			{ 31.6, 0 },
			{ 17.6, 0 },
			{ 5.2, 37.0, 0 },
		},
		[466751] = { -- Venting Heat
			{ 18.0, 0 },
			{ 12.9, 36.0, 0 },
			{ 38.9, 0 },
			{ 22.1, 0 },
			{ 26.1, 0 },
			{ 14.2, 37.0, 0 },
		},
	}
}
local timersHeroic = {
	{ -- Phase 1
		[466340] = { 6.5, 17.2, 18.4, 17.1, 18.3, 18.9, 0 }, -- Scatterblast Canisters
		[465952] = { 20.2, 35.5, 33.7, 0 }, -- Big Bad Buncha Bombs
		[467182] = { 31.6, 37.2, 33.7, 0 }, -- Suppression
		[466751] = { 12.6, 25.9, 26.7, 27.6, 0 }, -- Venting Heat
	},
	{ -- Phase 2
		[469286] = { 9.0, 57.7 }, -- Giga Coils
		[466341] = { -- Fused Canisters
			{ 10.2, 32.9, 0 },
			{ 27.7, 0 },
			{ 11.6, },
		},
		[465952] = { -- Big Bad Buncha Bombs
			{ 36.5, 0 },
			{ 37.8, 0 },
		},
		[467182] = { -- Suppression
			{ 24.0, 0 },
			{ 9.4, 35.2, 0 },
			{ 28.9, },
		},
		[466751] = { -- Venting Heat
			{ 20.5, 0 },
			{ 18.2, 0 },
			{ 16.6, },
		},
	},
	{ -- Phase 3
		[469286] = { 60.1, 60.4, 69.0 }, -- Giga Coils
		[466342] = { -- Tick-Tock Canisters
			{ 22.0, 0 },
			{ 6.9, 35.0, 0 },
			{ 27.9, 0 },
			{ 3.4, 38.6 },
		},
		[1214607] = { -- Bigger Badder Bomb Blast
			{ 8.0, 36.0, 0 },
			{ 31.0, 0 },
			{ 18.5, 25.0, 0 }, -- XXX 19.0, 35.0 ???
			{ 23.3 },
		},
		[466958] = { -- Ego Check
			{ 14.1, 13.0, 15.0, 8.1, 0 },
			{ 15.4, 13.5, 8.1, 10.0, 0 },
			{ 16.5, 8.0, 9.0, 26.1, 0 },
			{ 10.6, 18.5, 11.0 },
		},
		[467182] = { -- Suppression
			{ 33.0, 0 },
			{ 20.0, 0 },
			{ 7.4, 37.0, 0 }, -- XXX 7.6, 43.0 ???
			{ 31.2 },
		},
		[466751] = { -- Venting Heat
			{ 18.0, 0 },
			{ 11.9, 37.1, 0 },
			{ 38.4, 0 },
			{ 19.6 },
		},
	}
}
local timersMythic = {
	{ -- Phase 1
		[469286] = { 27.0, 58.1, 60.5, 59.0, 0 }, -- Giga Coils
		[469327] = { 18.0, 56.1, 62.0, 52.5, 0 }, -- Giga Blast
		[1217987] = { 31.0, 28.5, 31.7, 38.4, 25.6, 38.9, 0 }, -- Combination Canisters
		[1214607] = { 8.1, 58.0, 57.5, 55.5, 0 }, -- Bigger Badder Bomb Blast
		[466958] = { 16.0, 21.6, 14.6, 19.9, 17.0, 12.5, 16.5, 23.7, 11.5, 23.8, 17.1, 0 }, -- Ego Check
		[467182] = { 43.1, 60.5, 64.4, 0 }, -- Suppression
		[466751] = { 39.6, 16.5, 23.6, 18.4, 22.0, 29.6, 12.1, 23.3, 0 }, -- Venting Heat
	},
	{ -- Phase 2
		[469327] = { 49.6, 56.5, 43.6 }, -- Giga Blast
		[1218546] = { 37.5, 48.0, 54.1 }, -- Biggest Baddest Bomb Barrage
		[1218488] = { 12.6, 42.5, 37.0, 34.5, 51.6 }, -- Scatterbomb Canisters
		[466958] = { 21.1, 26.5, 28.6, 27.9, 29.0, 22.1 }, -- Ego Check
		[467182] = { 23.1, 44.0, 44.9, 55.1 }, -- Suppression
		[466751] = { 9.0, 35.0, 19.6, 36.9, 20.5, 25.1 }, -- Venting Heat
	},
	{ -- Phase 3
		[469327] = { 56.6, }, -- Giga Blast
		[1218546] = { 30.0, 51.5, }, -- Biggest Baddest Bomb Barrage
		[1218488] = { 7.5, 37.0, 45.5, }, -- Scatterbomb Canisters
		[466958] = { 23.0, 39.1, 25.9, }, -- Ego Check
		[467182] = { 64.1, 34.5, }, -- Suppression
		[466751] = { 19.5, 33.5, 20.5, }, -- Venting Heat
	}
}
local timers = mod:Mythic() and timersMythic or mod:Normal() and timersNormal or mod:LFR() and timersLFR or timersHeroic

local function cd(spellId, count)
	-- not knowing the full fight sequence makes normal table lookups sketchy without metatables
	local coilCount = gigaCoilsCount
	local stage = mod:GetStage()
	if stage == 1 or mod:Mythic() then
		return timers[stage][spellId][count]
	elseif stage == 2 then
		coilCount = coilCount - 1 -- there's no before the first coil phase like in p3
	end
	return timers[stage][spellId][coilCount] and timers[stage][spellId][coilCount][count]
end

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.story_phase_trigger = "What, you think you won?" -- What, you think you won? Nah, I got somethin' else for ya.

	L.scatterblast_canisters = "Cone Soak"
	L.fused_canisters = "Group Soaks"
	L.tick_tock_canisters = "Soaks"
	L.total_destruction = "DESTRUCTION!"

	L.duds = "Duds" -- Short for 1500-Pound "Dud"
	L.all_duds_detontated = "All Duds Detonated!"
	L.duds_remaining = "%d |4Dud remains:Duds remaining;" -- 1 Dud Remains | 2 Duds Remaining
	L.duds_soak = "Soak Duds (%d left)"
end

--------------------------------------------------------------------------------
-- Initialization
--

local wrenchmongerMarker = mod:AddMarkerOption(false, "npc", 8, -31036, 8, 7, 6) -- Darkfuse Wrenchmonger
local gigaJuicedTechnicanMarker = mod:AddMarkerOption(false, "npc", 4, -31029, 4, 5) -- Giga-Juiced Technician
local sharpshotSentryMarker = mod:AddMarkerOption(false, "npc", 1, -31487, 1, 2, 3, 6) -- Sharpshot Sentry
function mod:GetOptions()
	return {
		wrenchmongerMarker,
		gigaJuicedTechnicanMarker,
		sharpshotSentryMarker,

		"stages",
		1220761, -- Mechengineer's Canisters
			-- 474447, -- Canister Detonation
		465952, -- Big Bad Buncha Bombs
			466154, -- Blast Burns
			466153, -- Bad Belated Boom
			466165, -- 1500-Pound "Dud"
				466246, -- Focused Detonation
					1217292, -- Time-Release Crackle
			-- 466338, -- Zagging Zizzler
		467182, -- Suppression
		466751, -- Venting Heat
		1222831, -- Overloaded Coils

		-- Mythic
			1217987, -- Combination Canisters
			1218488, -- Scatterbomb Canisters
			474130, -- Mechmastermind's Canisters
				-- 1220763, -- Mastermind's Detonation
			{1218546, "PRIVATE"}, -- Biggest Baddest Bomb Barrage
			{1218696, "CASTBAR"}, -- Mayhem Rockets

		-- Stage One: The House of Chrome
			466340, -- Scatterblast Canisters
			-- {1220290, "TANK"}, -- Trick Shots

		-- Stage Two: Mechanical Maniac
			469286, -- Giga Coils
				469327, -- Giga Blast
				-- 1219313, -- Overloaded Bolts (repeating swirl timer?)

			469362, -- Charged Giga Bomb
				469404, -- Giga BOOM! (fail damage)
				469795, -- Giga Bomb Detonation
					1215209, -- Sabotage Zone
					-- 1220846, -- Control Meltdown

			{466341, "PRIVATE"}, -- Fused Canisters
		-- Darkfuse Cronies
			-- Darkfuse Technician
				-- -31482, -- Darkfuse Technician
				-- 471352, -- Juice It!
			-- Sharpshot Sentry
				466834, -- Shock Barrage
			-- Darkfuse Wrenchmonger
				{1216845, "NAMEPLATE"}, -- Wrench
				1216852, -- Lumbering Rage

		-- Intermission: Docked and Loaded
			1214229, -- Armageddon-class Plating
			-- 1219319, -- Radiant Electricity
			{1214369, "CASTBAR"}, -- TOTAL DESTRUCTION!!!

		-- Stage Three: What an Arsenal!
			1214607, -- Bigger Badder Bomb Blast
				{1214755, "PRIVATE"}, -- Overloaded Rockets
			466342, -- Tick-Tock Canisters
			1219333, -- Gallybux Finale Blast (Suppression Stage 3)
		-- Greedy Goblin's Armaments
			{466958, "TANK_HEALER"}, -- Ego Check
				-- 467064, -- Checked Ego
	},{
		[1217987] = "mythic",
		[466340] = -30490, -- Stage One: The House of Chrome
		[469286] = -30497, -- Stage Two: Mechanical Maniac
		[1214229] = -31558, -- Intermission: Docked and Loaded
		[1214607] = -31445, -- Stage Three: What an Arsenal!
	},{
		[1220761] = CL.heal_absorb, -- Mechengineer's Canisters
		[466340] = L.scatterblast_canisters, -- Scatterblast Canisters (Cone Soak)
		[465952] = CL.bombs, -- Big Bad Buncha Bombs (Bombs)
		[466165] = L.duds, -- 1500-Pound "Dud" (Duds)
		[1217292] = CL.explosion, -- Time-Release Crackle (Explosion)
		[1214229] = CL.shield, -- Armageddon-class Plating (Shield)
		[466341] = L.fused_canisters, -- Fused Canisters (Group Soaks)
		[1214607] = CL.bombs, -- Bigger Badder Bomb Blast (Bombs)
		[466342] = L.tick_tock_canisters, -- Tick-Tock Canisters (Soaks)
		[1217987] = L.tick_tock_canisters, -- Combination Canisters (Soaks)
		[1218488] = L.scatterblast_canisters, -- Scatterbomb Canisters (Cone Soak)
		[474130] = CL.heal_absorb, -- Mechmastermind's Canisters
		[1218546] = CL.bombs, -- Biggest Baddest Bomb Barrage (Bombs)
	}
end

function mod:OnRegister()
	self:SetSpellRename(466340, L.scatterblast_canisters) -- Scatterblast Canisters (Cone Soak)
	self:SetSpellRename(465952, CL.bombs) -- Big Bad Buncha Bombs (Bombs)
	self:SetSpellRename(466341, L.fused_canisters) -- Fused Canisters (Group Soaks)
	self:SetSpellRename(1214607, CL.bombs) -- Bigger Badder Bomb Blast (Bombs)
	self:SetSpellRename(466342, L.tick_tock_canisters) -- Tick-Tock Canisters (Soaks)
	self:SetSpellRename(1217987, L.tick_tock_canisters) -- Combination Canisters (Soaks)
	self:SetSpellRename(1218488, L.scatterblast_canisters) -- Scatterbomb Canisters (Cone Soak)
	self:SetSpellRename(1218546, CL.bombs) -- Biggest Baddest Bomb Barrage (Bombs)
end

function mod:OnBossEnable()
	if self:Story() then
		self:Log("SPELL_CAST_SUCCESS", "GigaBlastSuccess", 469327) -- mini phase
		self:RegisterEvent("CHAT_MSG_MONSTER_YELL") -- phase 2
	end

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 1215209) -- Sabotage Zone
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 1215209)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 1215209)

	self:Log("SPELL_AURA_APPLIED", "MechengineersCanistersApplied", 1220761, 474130) -- + mythic
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	-- self:Log("SPELL_CAST_START", "BigBadBunchaBombs", 465952) -- EMOTE
	self:Log("SPELL_AURA_APPLIED", "BlastBurnsApplied", 466154)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlastBurnsApplied", 466154)
	self:Log("SPELL_AURA_APPLIED", "FifteenHundredPoundDudApplied", 466165)
	self:Log("SPELL_AURA_REMOVED", "FifteenHundredPoundDudRemoved", 466165)
	self:Log("SPELL_AURA_APPLIED", "FocusedDetonationApplied", 466246)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FocusedDetonationApplied", 466246)
	self:Log("SPELL_AURA_REMOVED", "FocusedDetonationRemoved", 466246)
	self:Log("SPELL_CAST_START", "Suppression", 467182)
	self:Log("SPELL_CAST_START", "VentingHeat", 466751)
	-- self:Log("SPELL_AURA_APPLIED", "TrickShotsApplied", 1220290)
	-- self:Log("SPELL_AURA_APPLIED_DOSE", "TrickShotsApplied", 1220290)
	-- self:Log("SPELL_AURA_REMOVED", "TrickShotsRemoved", 1220290) -- XXX used as phase 2 start below

	-- Stage 1
	self:Log("SPELL_CAST_START", "ScatterblastCanisters", 466340)

	-- Stage 2
	self:Log("SPELL_AURA_REMOVED", "TrickShotsRemoved", 1220290)
	-- self:Log("SPELL_CAST_START", "GigaCoils", 469286) -- USCS 469286
	self:Log("SPELL_AURA_REMOVED", "GigaCoilsRemoved", 469293)
	self:Log("SPELL_CAST_START", "GigaBlast", 469327)
	self:Log("SPELL_AURA_APPLIED", "ChargedGigaBombApplied", 469362)
	self:Log("SPELL_AURA_APPLIED", "GigaBoomApplied", 469404)
	-- self:Log("SPELL_AURA_APPLIED_DOSE", "GigaBoomApplied", 469404)
	self:Log("SPELL_AURA_APPLIED", "GigaBombDetonationApplied", 469795)
	self:Log("SPELL_CAST_START", "FusedCanisters", 466341)

	self:RegisterUnitEvent("UNIT_SPELLCAST_START", nil, "boss1") -- Giga Coils
	-- self:Log("SPELL_CAST_START", "JuiceIt", 471352)
	self:Log("SPELL_CAST_START", "ShockBarrage", 466834)
	self:Log("SPELL_CAST_START", "Wrench", 1216845)
	self:Log("SPELL_AURA_APPLIED", "WrenchApplied", 1216845)
	self:Log("SPELL_AURA_APPLIED_DOSE", "WrenchApplied", 1216845)
	self:Log("SPELL_AURA_APPLIED", "LumberingRageApplied", 1216852)
	self:Death("AddsDeath", 231978, 231939, 231977, 237192) -- Sharpshot Sentry, Darkfuse Wrenchmonger, Darkfuse Technician, Giga-Juiced Technician

	-- Intermission
	self:Log("SPELL_AURA_APPLIED", "ArmageddonClassPlatingApplied", 1214229)
	self:Log("SPELL_AURA_REMOVED", "ArmageddonClassPlatingRemoved", 1214229)
	self:Log("SPELL_CAST_START", "TotalDestruction", 1214369)
	self:Log("SPELL_AURA_REMOVED", "TotalDestructionRemoved", 1214369)
	self:Log("SPELL_INTERRUPT", "TotalDestructionInterrupted", 1214369)
	-- self:Log("SPELL_AURA_APPLIED", "IntermissionCircuitRebootApplied", 1226890)
	-- self:Log("SPELL_AURA_REMOVED", "IntermissionCircuitRebootRemoved", 1226890)

	-- Stage 3
	self:Log("SPELL_CAST_START", "BiggerBadderBombBlast", 1214607)
	self:Log("SPELL_CAST_START", "TickTockCanisters", 466342)
	self:Log("SPELL_CAST_START", "EgoCheck", 466958)
	self:Log("SPELL_AURA_APPLIED", "EgoCheckApplied", 466958)
	self:Log("SPELL_AURA_APPLIED_DOSE", "EgoCheckApplied", 466958)
	self:Log("SPELL_CAST_START", "OverloadedCoils", 1222831)

	-- Mythic
	self:Log("SPELL_CAST_START", "CombinationCanisters", 1217987)

	self:Log("SPELL_AURA_APPLIED", "CircuitRebootApplied", 1226891)
	self:Log("SPELL_AURA_REMOVED", "CircuitRebootRemoved", 1226891)
	self:Log("SPELL_CAST_START", "MayhemRockets", 1218696)

	self:Log("SPELL_CAST_START", "ScatterbombCanisters", 1218488)
	-- self:Log("SPELL_CAST_START", "BiggestBaddestBombBarrage", 1218546) -- EMOTE

	self:Log("SPELL_AURA_APPLIED", "WrenchmongerSpawn", 1216846) -- Holding a Wrench

	timers = self:Mythic() and timersMythic or self:Normal() and timersNormal or self:LFR() and timersLFR or timersHeroic
end

function mod:OnEngage()
	self:SetStage(self:Mythic() and 0.5 or 1)

	canistersCount = 1
	bombsCount = 1
	suppressionCount = 1
	ventingHeatCount = 1
	egoCheckCount = 1

	fullCanistersCount = 1
	fullBombsCount = 1
	fullSuppressionCount = 1
	fullVentingHeatCount = 1

	gigaCoilsCount = 1
	gigaBlastCount = 1

	mobCollector = {}
	mobMarks = {}

	encounterStart = GetTime()

	if self:Story() then
		-- XXX Something affects energy gain (damage?), which causes the Giga Blast "phases" to vary,
		-- XXX which pushes around all the other timers. So I'm just going to leave the timers off for now.
		-- Bombs > Suppression > Bombs > Suppression > Giga Blast x3
		-- self:Bar(465952, 15.4 - 4.5, CL.count:format(self:SpellName(465952), fullBombsCount)) -- Big Bad Buncha Bombs (emote is 2.2s earlier, debuffs 4.5s)
		-- self:Bar(467182, 26.7, CL.count:format(self:SpellName(467182), fullSuppressionCount)) -- Suppression
		-- self:Bar(469327, 64, CL.count:format(self:SpellName(469327), gigaBlastCount)) -- Giga Blast
		self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
	elseif not self:Mythic() then
		if not self:LFR() then
			self:Bar(466340, cd(466340, 1), CL.count:format(L.scatterblast_canisters, canistersCount)) -- Scatterblast Canisters
		end
		self:Bar(465952, cd(465952, 1) - 4.5, CL.count:format(CL.bombs, bombsCount)) -- Big Bad Buncha Bombs (emote is 2.2s earlier)
		self:Bar(467182, cd(467182, 1), CL.count:format(self:SpellName(467182), suppressionCount)) -- Suppression
		self:Bar(466751, cd(466751, 1), CL.count:format(self:SpellName(466751), ventingHeatCount)) -- Venting Heat
		self:Bar("stages", self:Easy() and 123.4 or 111.0, CL.stage:format(2), "ability_siege_engineer_magnetic_crush")
		self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
	end

	if self:GetOption(wrenchmongerMarker) or self:GetOption(sharpshotSentryMarker) or self:GetOption(gigaJuicedTechnicanMarker) then
		self:RegisterTargetEvents("AddMarking")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 53 then -- Intermission at ~50%
		self:UnregisterUnitEvent(event, unit)
		self:Message("stages", "cyan", CL.soon:format(CL.intermission), false)
		self:PlaySound("stages", "info")
	end
end

-- Marking

function mod:WrenchmongerSpawn(args)
	-- flag marks for the six prespawned mobs alternating 8/7
	-- and then use 876 for the three that jump down
	if not mobCollector[args.sourceGUID] then
		local icon = mobMarks[231939] or 8
		mobCollector[args.sourceGUID] = icon
		icon = icon - 1
		if icon < (gigaCoilsCount < 3 and 7 or 6) then
			icon = 8
		end
		mobMarks[231939] = icon
	end
end

function mod:AddMarking(_, unit, guid)
	if mobCollector[guid] then
		if self:MobId(guid) == 231939 then
			self:CustomIcon(wrenchmongerMarker, unit, mobCollector[guid])
		elseif self:MobId(guid) == 237192 then
			self:CustomIcon(gigaJuicedTechnicanMarker, unit, mobCollector[guid])
		elseif self:MobId(guid) == 231978 then
			self:CustomIcon(sharpshotSentryMarker, unit, mobCollector[guid])
		end
	elseif self:MobId(guid) == 237192 then -- IEEU is too slow, just use target events
		local icon = mobMarks[237192] or 4
		mobCollector[guid] = icon
		self:CustomIcon(gigaJuicedTechnicanMarker, unit, icon)
		mobMarks[237192] = icon + 1
	end
end

-- Story Mode

function mod:GigaBlastSuccess()
	if gigaBlastCount % 3 == 1 then
		bombsCount = 1
		suppressionCount = 1
		ventingHeatCount = 1

		-- local stage = self:GetStage()
		-- if stage == 1 then -- Venting Heat > Suppression > Bombs > Suppression > Giga Blast x3
		-- 	self:CDBar(466751, 15.6, CL.count:format(self:SpellName(466751), fullVentingHeatCount)) -- Venting Heat
		-- 	self:CDBar(467182, 28.2, CL.count:format(self:SpellName(467182), fullSuppressionCount)) -- Suppression
		-- 	self:CDBar(465952, 44.3 - 4.5, CL.count:format(self:SpellName(465952), fullBombsCount)) -- Big Bad Buncha Bombs
		-- 	self:CDBar(469327, 65.5, CL.count:format(self:SpellName(469327), gigaBlastCount)) -- Giga Blast
		-- elseif stage == 2 then -- Venting Heat > Bombs > Suppression > Venting Heat > Bombs > Suppression > Giga Blast x3
		-- 	self:CDBar(466751, 18.8, CL.count:format(self:SpellName(466751), fullVentingHeatCount)) -- Venting Heat
		-- 	self:CDBar(1214607, 22.3, CL.count:format(self:SpellName(1214607), fullBombsCount)) -- Bigger Badder Bomb Blast
		-- 	self:CDBar(467182, 28.8, CL.count:format(self:SpellName(467182), fullSuppressionCount)) -- Suppression
		-- 	self:CDBar(469327, 65.5, CL.count:format(self:SpellName(469327), gigaBlastCount)) -- Giga Blast
		-- end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg:find(L.story_phase_trigger, nil, true) then
		self:StopBar(CL.count:format(self:SpellName(465952), fullBombsCount)) -- Big Bad Buncha Bombs
		self:StopBar(CL.count:format(self:SpellName(467182), fullSuppressionCount)) -- Suppression
		self:StopBar(CL.count:format(self:SpellName(466751), fullVentingHeatCount)) -- Venting Heat
		self:StopBar(CL.count:format(self:SpellName(469327), gigaBlastCount)) -- Giga Blast
		self:UnregisterEvent("UNIT_HEALTH", "boss1")

		self:Message("stages", "cyan", CL.stage:format(2), false)
		self:PlaySound("stages", "long")
		self:SetStage(2)

		bombsCount = 1
		suppressionCount = 1
		ventingHeatCount = 1

		fullBombsCount = 1
		fullSuppressionCount = 1
		fullVentingHeatCount = 1

		gigaBlastCount = 1

		-- Venting Heat > Bombs > Suppression > Venting Heat > Bombs > Suppression > Giga Blast x3
		-- self:Bar(466751, 15.5, CL.count:format(self:SpellName(466751), fullVentingHeatCount)) -- Venting Heat
		-- self:Bar(1214607, 19.0, CL.count:format(self:SpellName(1214607), fullBombsCount)) -- Bigger Badder Bomb Blast
		-- self:Bar(467182, 25.5, CL.count:format(self:SpellName(467182), fullSuppressionCount)) -- Suppression
		-- self:Bar(469327, 63.5, CL.count:format(self:SpellName(469327), gigaBlastCount)) -- Giga Blast

		if encounterStart > 0 then
			-- hard enrage at 9:38
			local enrageCD = 578 - (GetTime() - encounterStart)
			self:Bar(1222831, enrageCD) -- Overloaded Coils
		end
	end
end

-- General

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

function mod:MechengineersCanistersApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.heal_absorb)
		self:PlaySound(args.spellId, "info") -- healing absorb
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	-- a bit earlier than the cast, bar is aligned with when the debuffs go out
	if msg:find("spell:465952", nil, true) then
		-- |TInterface\\ICONS\\Ships_ABILITY_Bombers.BLP:20|t %s begins to cast |cFFFF0000|Hspell:465952|h[Big Bad Buncha Bombs]|h|r!
		self:StopBar(CL.count:format(CL.bombs, fullBombsCount))
		self:Message(465952, "red", CL.count:format(CL.bombs, fullBombsCount))
		self:PlaySound(465952, "alert")
		bombsCount = bombsCount + 1
		fullBombsCount = fullBombsCount + 1
		spawnedDuds = self:Mythic() and 4 or 2
		if not self:Story() then
			local bombsCD = cd(465952, bombsCount)
			if bombsCD and bombsCD > 0 then
				self:CDBar(465952, bombsCD - 2.3, CL.count:format(CL.bombs, fullBombsCount))
			end
			self:Bar(466153, 11.9) -- Bad Belated Boom
		-- elseif fullBombsCount == 2 then -- 1 per Giga Blast, except 2 before the first Giga Blast
		-- 	self:CDBar(465952, 25.1, CL.count:format(self:SpellName(465952), fullBombsCount))
		end

	elseif self:Mythic() and msg:find("spell:1218546", nil, true) then
		-- |TInterface\\ICONS\\Ships_ABILITY_Bombers.BLP:20|t %s begins to cast |cFFFF0000|Hspell:1218546|h[Biggest Baddest Bomb Barrage]|h|r!
		self:StopBar(CL.count:format(CL.bombs, fullBombsCount))
		self:Message(1218546, "red", CL.count:format(CL.bombs, fullBombsCount))
		self:PlaySound(1218546, "alarm") -- avoid
		bombsCount = bombsCount + 1
		fullBombsCount = fullBombsCount + 1
		local bombsCD = cd(1218546, bombsCount)
		if bombsCD and bombsCD > 0 then
			self:Bar(1218546, bombsCD - 2.3, CL.count:format(CL.bombs, fullBombsCount))
		end

		self:Bar(1214755, 7.7) -- Overloaded Rockets
	end
end

-- function mod:BigBadBunchaBombs(args)
-- 	self:StopBar(CL.count:format(CL.bombs, fullBombsCount))
-- 	self:Message(args.spellId, "red", CL.count:format(CL.bombs, fullBombsCount))
-- 	self:PlaySound(args.spellId, "alert")
-- 	bombsCount = bombsCount + 1
-- 	fullBombsCount = fullBombsCount + 1
-- 	self:CDBar(args.spellId, cd(465952, bombsCount), CL.count:format(CL.bombs, fullBombsCount))

-- 	spawnedDuds = self:Mythic() and 4 or 2
-- 	self:Bar(466153, 9.7) -- Bad Belated Boom
-- end

do
	local stacksOnMe = 0
	local scheduled = nil
	local playerName = mod:UnitName("player")
	function mod:BlastBurnsStackMessage()
		local emphAt = 3
		self:StackMessage(466154, "blue", playerName, stacksOnMe, emphAt)
		if stacksOnMe >= emphAt then
			self:PlaySound(466154, "alarm") -- larger dot
		else
			self:PlaySound(466154, "info") -- small dot
		end
		scheduled = nil
	end

	function mod:BlastBurnsApplied(args)
		if self:Me(args.destGUID) then
			stacksOnMe = args.amount or 1
			if not scheduled then
				scheduled = self:ScheduleTimer("BlastBurnsStackMessage", 0.1)
			end
		end
	end
end

do
	local prev = 0
	function mod:FifteenHundredPoundDudApplied(args)
		-- self:StopBar(L.duds_soak:format(spawnedDuds))
		if args.time - prev > 2 then
			self:Bar(args.spellId, 15, L.duds)
		end
		-- if args.time - prev > 2 then
		-- 	prev = args.time
		-- 	self:Message(args.spellId, "red", CL.spawned:format(L.duds))
		-- 	self:Bar(args.spellId, 15, L.duds_soak:format(spawnedDuds))
		-- else
		-- 	local timeLeft = 15 - (args.time - prev)
		-- 	self:Bar(args.spellId, {timeLeft, 15}, L.duds_soak:format(spawnedDuds))
		-- end
	end

	function mod:FifteenHundredPoundDudRemoved(args)
		-- self:StopBar(L.duds_soak:format(spawnedDuds))
		self:StopBar(L.duds)
		spawnedDuds = spawnedDuds - 1
		-- self:Message(args.spellId, "green", L.duds_remaining:format(spawnedDuds))
		-- local timeLeft = 15 - (args.time - prev)
		-- if spawnedDuds > 0 and timeLeft > 0 then
		-- 	self:Bar(args.spellId, {timeLeft, 15}, L.duds_soak:format(spawnedDuds+1))
		if spawnedDuds <= 0 then
			self:StopBar(args.spellId) -- 1500-Pound "Dud"
			self:Message(args.spellId, "green", L.all_duds_detontated)
			self:PlaySound(args.spellId, "info")
		end
	end
end

function mod:FocusedDetonationApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "purple", args.destName, args.amount, 2)
		self:PlaySound(args.spellId, "info") -- soaked bomb
	end
	self:TargetBar(1217292, 10, args.destName, CL.explosion) -- Time-Release Crackle
end

function mod:FocusedDetonationRemoved(args)
	self:StopBar(1217292, args.destName) -- Time-Release Crackle
end

function mod:Suppression(args)
	self:StopBar(CL.count:format(args.spellName, fullSuppressionCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, fullSuppressionCount))
	self:PlaySound(args.spellId, "alarm") -- avoid
	if (self:GetStage() == 3 or self:Mythic()) and not self:Story() then
		self:Bar(1219333, 6) -- Gallybux Finale Blast
	end
	suppressionCount = suppressionCount + 1
	fullSuppressionCount = fullSuppressionCount + 1
	if not self:Story() then
		self:CDBar(args.spellId, cd(args.spellId, suppressionCount), CL.count:format(args.spellName, fullSuppressionCount))
	-- elseif suppressionCount % 2 == 0 then
	-- 	local cd = (self:GetStage() == 1 and (fullSuppressionCount - 2) % 4 == 0) and 23.9 or 25.5
	-- 	self:CDBar(args.spellId, cd, CL.count:format(args.spellName, fullSuppressionCount))
	end
end

function mod:VentingHeat(args)
	self:StopBar(CL.count:format(args.spellName, fullVentingHeatCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, fullVentingHeatCount))
	self:PlaySound(args.spellId, "alert") -- raid damage
	ventingHeatCount = ventingHeatCount + 1
	fullVentingHeatCount = fullVentingHeatCount + 1
	if not self:Story() then
		self:CDBar(args.spellId, cd(args.spellId, ventingHeatCount), CL.count:format(args.spellName, fullVentingHeatCount))
	-- elseif self:GetStage() == 2 and ventingHeatCount % 2 == 0 then
	-- 	self:CDBar(args.spellId, 25.0, CL.count:format(args.spellName, fullVentingHeatCount))
	end
end

-- do
-- 	local trickShotsAmount = 0
-- 	local emphAt = 7
-- 	function mod:TrickShotsApplied(args)
-- 		self:StopBar(CL.count:format(args.spellName, trickShotsAmount + 1))
-- 		trickShotsAmount = args.amount or 1
-- 		self:StackMessage(args.spellId, "purple", args.destName, trickShotsAmount, emphAt)
-- 		if trickShotsAmount >= emphAt then
-- 			self:PlaySound(args.spellId, "warning") -- big damage on swap or at 10
-- 		end
-- 		self:Bar(args.spellId, 4, CL.count:format(args.spellName, trickShotsAmount + 1))
-- 	end
-- 	function mod:TrickShotsRemoved(args)
-- 		self:StopBar(CL.count:format(args.spellName, trickShotsAmount + 1))
-- 		trickShotsAmount = 0
-- 	end
-- end

-- Stage One: The House of Chrome

function mod:ScatterblastCanisters(args)
	self:StopBar(CL.count:format(L.scatterblast_canisters, fullCanistersCount))
	self:Message(args.spellId, "orange", CL.count:format(L.scatterblast_canisters, fullCanistersCount))
	self:PlaySound(args.spellId, "alert") -- soak
	canistersCount = canistersCount + 1
	fullCanistersCount = fullCanistersCount + 1
	self:CDBar(args.spellId, cd(args.spellId, canistersCount), CL.count:format(L.scatterblast_canisters, fullCanistersCount))
end

-- Stage Two: Mechanical Maniac

function mod:TrickShotsRemoved()
	-- self:StopBar(CL.count:format(args.spellName, trickShotsAmount + 1))
	-- trickShotsAmount = 0
	if self:GetStage() == 1 then
		self:StopBar(CL.stage:format(2))
		self:StopBar(CL.count:format(L.scatterblast_canisters, fullCanistersCount)) -- Scatterblast Canisters
		self:StopBar(CL.count:format(CL.bombs, fullBombsCount)) -- Big Bad Buncha Bombs
		self:StopBar(CL.count:format(self:SpellName(467182), fullSuppressionCount)) -- Suppression
		self:StopBar(CL.count:format(self:SpellName(466751), fullVentingHeatCount)) -- Venting Heat

		self:SetStage(2)

		fullCanistersCount = 1
		fullBombsCount = 1
		fullSuppressionCount = 1
		fullVentingHeatCount = 1

		gigaCoilsCount = 1
		gigaBlastCount = 1

		if not self:LFR() then
			self:Message("stages", "cyan", CL.stage:format(2), false)
			self:PlaySound("stages", "info")
			self:CDBar(469286, timers[2][469286][1], CL.count:format(self:SpellName(469286), gigaCoilsCount)) -- Giga Coils
		else
			self:SimpleTimer(function() -- Delay a little on LFR so it doesn't show at the same time as the Giga Coils message
				self:Message("stages", "cyan", CL.stage:format(2), false)
				self:PlaySound("stages", "info")
			end, 1)
		end
	end
end

function mod:UNIT_SPELLCAST_START(_, unit, _, spellId)
	if spellId == 469286 then -- Giga Coils
		self:StopBar(CL.count:format(self:SpellName(469286), gigaCoilsCount)) -- Giga Coils
		if not self:Mythic() then
			self:StopBar(CL.count:format(L.scatterblast_canisters, fullCanistersCount)) -- Scatterblast Canisters
			self:StopBar(CL.count:format(L.fused_canisters, fullCanistersCount)) -- Fused Canisters
			self:StopBar(CL.count:format(L.tick_tock_canisters, fullCanistersCount)) -- Tick-Tock Canisters
			self:StopBar(CL.count:format(CL.bombs, fullBombsCount)) -- Big Bad Buncha Bombs/Bigger Badder Bomb Blast
			self:StopBar(CL.count:format(self:SpellName(467182), fullSuppressionCount)) -- Suppression
			self:StopBar(CL.count:format(self:SpellName(466751), fullVentingHeatCount)) -- Venting Heat
			self:StopBar(CL.count:format(self:SpellName(466958), egoCheckCount)) -- Ego Check

			gigaBlastCount = 1

			-- No Trick Shots in LFR so manually trigger the phase change
			if self:LFR() and self:GetStage() == 1 then
				self:TrickShotsRemoved()
			end
		end

		self:Message(469286, "cyan", CL.count:format(self:SpellName(469286), gigaCoilsCount))
		self:PlaySound(469286, "long")

		if self:Mythic() then
			gigaCoilsCount = gigaCoilsCount + 1
			if gigaCoilsCount < 5 then
				self:CDBar(469286, cd(469286, gigaCoilsCount), CL.count:format(self:SpellName(469286), gigaCoilsCount))
			end

			-- In mythic, after two sets of Giga Coils, the adds drop down instead of start on a platform
			if gigaCoilsCount == 3 then
				mobMarks[231939] = 8
			end
		end
	end
end

function mod:GigaCoilsRemoved()
	if self:Mythic() then
		self:Message(469286, "cyan", CL.over:format(CL.count:format(self:SpellName(469286), gigaCoilsCount-1)))
		return
	end

	self:StopBar(CL.count:format(self:SpellName(469327), gigaBlastCount))

	self:Message(469286, "cyan", CL.over:format(CL.count:format(self:SpellName(469286), gigaCoilsCount)))
	self:PlaySound(469286, "long")
	gigaCoilsCount = gigaCoilsCount + 1

	canistersCount = 1 -- re-used for Fused Canisters
	bombsCount = 1
	suppressionCount = 1
	ventingHeatCount = 1
	egoCheckCount = 1

	local stage = self:GetStage()
	if stage == 2 then
		if not self:LFR() then
			self:CDBar(466341, cd(466341, canistersCount), CL.count:format(L.fused_canisters, fullCanistersCount)) -- Fused Canisters
		end
		local bombsCD = cd(465952, bombsCount)
		if bombsCD and bombsCD > 0 then
			self:CDBar(465952, bombsCD - 4.5, CL.count:format(CL.bombs, fullBombsCount)) -- Big Bad Buncha Bombs
		end
	elseif stage == 3 then
		if not self:Easy() then
			self:CDBar(466958, cd(466958, egoCheckCount), CL.count:format(self:SpellName(466958), egoCheckCount)) -- Ego Check
		end
		if not self:LFR() then
			self:CDBar(466342, cd(466342, canistersCount), CL.count:format(L.tick_tock_canisters, fullCanistersCount)) -- Tick-Tock Canisters
		end
		self:CDBar(1214607, cd(1214607, bombsCount), CL.count:format(CL.bombs, fullBombsCount)) -- Bigger Badder Bomb Blast
	end
	if stage == 2 or stage == 3 then
		self:CDBar(467182, cd(467182, suppressionCount), CL.count:format(self:SpellName(467182), fullSuppressionCount)) -- Suppression
		self:CDBar(466751, cd(466751, ventingHeatCount), CL.count:format(self:SpellName(466751), fullVentingHeatCount)) -- Venting Heat

		local gigaCoilsCD = timers[stage][469286][gigaCoilsCount]
		if gigaCoilsCD then
			self:CDBar(469286, gigaCoilsCD - 3, CL.count:format(self:SpellName(469286), gigaCoilsCount)) -- Giga Coils (USCS is 3s earlier)
		end
	end
end

function mod:GigaBlast(args)
	self:StopBar(CL.count:format(args.spellName, gigaBlastCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, gigaBlastCount))
	self:PlaySound(args.spellId, "alert") -- Watch beam?
	gigaBlastCount = gigaBlastCount + 1
	if self:Mythic() then
		self:CDBar(args.spellId, cd(469327, gigaBlastCount), CL.count:format(args.spellName, gigaBlastCount)) -- Giga Blast
	elseif not self:Story() then
		self:Bar(args.spellId, self:LFR() and 7.5 or 6.5, CL.count:format(args.spellName, gigaBlastCount))
	elseif gigaBlastCount % 3 ~= 1 then
		self:Bar(args.spellId, 7.5, CL.count:format(args.spellName, gigaBlastCount))
	end
end

function mod:ChargedGigaBombApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:GigaBoomApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "red")
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:GigaBombDetonationApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info")
	end
end

function mod:FusedCanisters(args)
	self:StopBar(CL.count:format(L.fused_canisters, fullCanistersCount))
	self:Message(args.spellId, "orange", CL.count:format(L.fused_canisters, fullCanistersCount))
	self:PlaySound(args.spellId, "alert") -- soak
	canistersCount = canistersCount + 1
	fullCanistersCount = fullCanistersCount + 1
	self:CDBar(args.spellId, cd(args.spellId, canistersCount), CL.count:format(L.fused_canisters, fullCanistersCount))
end

-- function mod:JuiceIt(args)
-- 	local unit = self:GetUnitIdByGUID(args.sourceGUID)
-- 	if unit then
-- 		if self:UnitWithinRange(unit, 10) then
-- 			self:Message(args.spellId, "orange")
-- 			self:PlaySound(args.spellId, "alarm") -- watch out
-- 		end
-- 	end
-- 	self:Nameplate(args.spellId, 20, args.sourceGUID)
-- end

do
	local prev = 0
	function mod:ShockBarrage(args)
		-- use cast order for marks (was hoping their positions were consistent, but they weren't.)
		if not mobCollector[args.sourceGUID] then
			if args.time - prev > 3 then
				prev = args.time
				mobMarks[231978] = 1
			end
			local icon = mobMarks[231978] or 1
			mobCollector[args.sourceGUID] = icon
			mobMarks[231978] = icon + 1
		end

		local canDo, ready = self:Interrupter(args.sourceGUID)
		if canDo and ready then
			self:Message(args.spellId, "yellow")
			self:PlaySound(args.spellId, "alert")
		end
		-- self:Nameplate(466834, 2.5, args.sourceGUID) -- XXX 2.5 recast >.>
	end
end

function mod:Wrench(args)
	self:Nameplate(1216845, 7.4, args.sourceGUID)
end

function mod:WrenchApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 1 and (not self:Tank() or amount < 6) then -- don't spam tanks if there are a lot of them
			self:StackMessage(args.spellId, "blue", args.destName, amount, 3)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

do
	local prev = 0
	function mod:LumberingRageApplied(args)
		if self:Dispeller("enrage", true) and args.time - prev > 2 then
			prev = args.time
			self:Message(args.spellId, "red")
			self:PlaySound(args.spellId, "warning") -- 200% damage increase and movement? DO IT
		end
	end
end

function mod:AddsDeath(args)
	self:ClearNameplate(args.destGUID)

	if args.mobId == 237192 or args.mobId == 231939 then -- Giga-Juiced Technican, Darkfuse Wrenchmonger
		-- In mythic, the initial mobs are all up at the same time, but you only pull a set at a time, so just reset here
		mobMarks[237192] = nil -- Giga-Juiced Technican
	end
end

-- Intermission: Docked and Loaded

do
	local appliedTime = 0
	function mod:ArmageddonClassPlatingApplied(args)
		self:UnregisterUnitEvent("UNIT_HEALTH", "boss1")
		self:StopBar(CL.count:format(CL.bombs, fullBombsCount)) -- Big Bad Buncha Bombs
		self:StopBar(CL.count:format(self:SpellName(467182), fullSuppressionCount)) -- Suppression
		self:StopBar(CL.count:format(self:SpellName(466751), fullVentingHeatCount)) -- Venting Heat
		self:StopBar(CL.count:format(L.scatterblast_canisters, fullCanistersCount)) -- Scatterblast Canisters
		self:StopBar(CL.count:format(self:SpellName(469286), gigaCoilsCount)) -- Giga Coils
		self:StopBar(CL.count:format(self:SpellName(469327), gigaBlastCount)) -- Giga Blast
		self:StopBar(CL.count:format(L.fused_canisters, fullCanistersCount)) -- Fused Canisters
		self:StopBar(CL.count:format(self:SpellName(466958), egoCheckCount)) -- Ego Check

		appliedTime = args.time

		if not self:Mythic() then
			self:SetStage(2.5)
		end
		self:Message(args.spellId, "cyan", CL.onboss:format(CL.shield))
		self:PlaySound(args.spellId, "warning") -- immune

		self:CDBar(1214369, self:Mythic() and 8.6 or self:LFR() and 10.6 or 9.6, L.total_destruction) -- TOTAL DESTRUCTION!!!
	end
	function mod:ArmageddonClassPlatingRemoved(args)
		if args.amount == 0 then
			self:Message(args.spellId, "green", CL.removed_after:format(CL.shield, args.time - appliedTime))
			self:PlaySound(args.spellId, "info")
		end
	end
end

function mod:TotalDestruction(args)
	self:StopBar(L.total_destruction)
	self:Message(args.spellId, "yellow", CL.casting:format(L.total_destruction))
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, self:Mythic() and 27.6 or 33, L.total_destruction)
end

function mod:TotalDestructionRemoved()
	self:StopCastBar(L.total_destruction)

	if not self:Mythic() then
		self:SetStage(3)
		self:Message("stages", "cyan", CL.stage:format(3), false)
	else
		self:SetStage(1)
		self:Message("stages", "cyan", CL.stage:format(1), false)
	end
	self:PlaySound("stages", "long") -- stage

	bombsCount = 1 -- re-used for Bigger Badder Bomb Blast
	canistersCount = 1 -- re-used for Tick-Tock Canisters
	suppressionCount = 1
	ventingHeatCount = 1
	egoCheckCount = 1

	fullCanistersCount = 1
	fullBombsCount = 1
	fullSuppressionCount = 1
	fullVentingHeatCount = 1

	gigaCoilsCount = 1
	gigaBlastCount = 1

	if not self:Easy() then
		self:CDBar(466958, cd(466958, egoCheckCount), CL.count:format(self:SpellName(466958), egoCheckCount)) -- Ego Check
	end
	self:CDBar(1214607, cd(1214607, bombsCount), CL.count:format(CL.bombs, fullBombsCount)) -- Bigger Badder Bomb Blast
	self:CDBar(467182, cd(467182, suppressionCount), CL.count:format(self:SpellName(467182), fullSuppressionCount)) -- Suppression
	self:CDBar(466751, cd(466751, ventingHeatCount), CL.count:format(self:SpellName(466751), fullVentingHeatCount)) -- Venting Heat
	if self:Mythic() then
		self:CDBar(1217987, cd(1217987, canistersCount), CL.count:format(L.tick_tock_canisters, fullCanistersCount)) -- Combination Canisters
		self:CDBar(469327, cd(469327, gigaBlastCount), CL.count:format(self:SpellName(469327), gigaBlastCount)) -- Giga Blast
		self:CDBar(469286, cd(469286, gigaCoilsCount) - 2, CL.count:format(self:SpellName(469286), gigaCoilsCount)) -- Giga Coils
		self:Bar("stages", 208.7, CL.intermission, "ability_mount_rocketmountblue")
	else
		if not self:LFR() then
			self:CDBar(466342, cd(466342, canistersCount), CL.count:format(L.tick_tock_canisters, fullCanistersCount)) -- Tick-Tock Canisters
		end
		self:CDBar(469286, timers[3][469286][gigaCoilsCount] - 3, CL.count:format(self:SpellName(469286), gigaCoilsCount)) -- Giga Coils
	end

	if encounterStart > 0 and (self:Normal() or self:Heroic()) then
		-- hard enrage at 9:38
		local enrageCD = 578 - (GetTime() - encounterStart)
		self:Bar(1222831, enrageCD) -- Overloaded Coils
	end
end

function mod:TotalDestructionInterrupted(args)
	-- You can break the shield and interrupt before Gallywix gains TOTAL DESTRUCTION!!!
	if (not self:Mythic() and self:GetStage() < 3) or (self:Mythic() and self:GetStage() < 1) then
		self:TotalDestructionRemoved()
	end

	self:Message(1214369, "green", CL.interrupted_by:format(args.extraSpellName, self:ColorName(args.sourceName)))
end

-- XXX need to check other difficulties, but not interrupting doesn't wipe you,
--     but the boss doesn't get stunned for 3s, which pushes timers 3s forward.
--     Would need to reduce the initial times by 3s or subtract it from the bar calls.
-- function mod:IntermissionCircuitRebootApplied()
-- 	if not self:Easy() then
-- 		self:PauseBar(466958, CL.count:format(self:SpellName(466958), egoCheckCount)) -- Ego Check
-- 	end
-- 	self:PauseBar(1214607, CL.count:format(CL.bombs, fullBombsCount)) -- Bigger Badder Bomb Blast
-- 	self:PauseBar(467182, CL.count:format(self:SpellName(467182), fullSuppressionCount)) -- Suppression
-- 	self:PauseBar(466751, CL.count:format(self:SpellName(466751), fullVentingHeatCount)) -- Venting Heat
-- 	if self:Mythic() then
-- 		self:PauseBar(1217987, CL.count:format(self:SpellName(1217987), fullCanistersCount)) -- Combination Canisters
-- 		self:PauseBar(469327, CL.count:format(self:SpellName(469327), gigaBlastCount)) -- Giga Blast
-- 	else
-- 		self:PauseBar(466342, CL.count:format(L.tick_tock_canisters, fullCanistersCount)) -- Tick-Tock Canisters
-- 	end
-- 	self:PauseBar(469286, CL.count:format(self:SpellName(469286), gigaCoilsCount)) -- Giga Coils
-- end

-- function mod:IntermissionCircuitRebootRemoved()
-- 	if not self:Easy() then
-- 		self:ResumeBar(466958, CL.count:format(self:SpellName(466958), egoCheckCount)) -- Ego Check
-- 	end
-- 	self:ResumeBar(1214607, CL.count:format(CL.bombs, fullBombsCount)) -- Bigger Badder Bomb Blast
-- 	self:ResumeBar(467182, CL.count:format(self:SpellName(467182), fullSuppressionCount)) -- Suppression
-- 	self:ResumeBar(466751, CL.count:format(self:SpellName(466751), fullVentingHeatCount)) -- Venting Heat
-- 	if self:Mythic() then
-- 		self:ResumeBar(1217987, CL.count:format(self:SpellName(1217987), fullCanistersCount)) -- Combination Canisters
-- 		self:ResumeBar(469327, CL.count:format(self:SpellName(469327), gigaBlastCount)) -- Giga Blast
-- 	else
-- 		self:ResumeBar(466342, CL.count:format(L.tick_tock_canisters, fullCanistersCount)) -- Tick-Tock Canisters
-- 	end
-- 	self:ResumeBar(469286, CL.count:format(self:SpellName(469286), gigaCoilsCount)) -- Giga Coils
-- end

-- Stage Three: What an Arsenal!

function mod:BiggerBadderBombBlast(args)
	self:StopBar(CL.count:format(CL.bombs, fullBombsCount))
	self:Message(args.spellId, "red", CL.count:format(CL.bombs, fullBombsCount))
	self:PlaySound(args.spellId, "warning") -- dodge
	bombsCount = bombsCount + 1
	fullBombsCount = fullBombsCount + 1
	spawnedDuds = self:Mythic() and 4 or 2
	if not self:Story() then
		self:Bar(args.spellId, cd(args.spellId, bombsCount), CL.count:format(CL.bombs, fullBombsCount))
		self:Bar(1214755, 6.5) -- Overloaded Rockets
		-- self:Bar(466153, 11.9) -- Bad Belated Boom (basically explode when the rockets fire)
	-- elseif bombsCount % 2 == 0 then
	-- 	self:Bar(args.spellId, 30.0, CL.count:format(args.spellName, fullBombsCount))
	end
end

function mod:TickTockCanisters(args)
	self:StopBar(CL.count:format(L.tick_tock_canisters, fullCanistersCount))
	self:Message(args.spellId, "orange", CL.count:format(L.tick_tock_canisters, fullCanistersCount))
	self:PlaySound(args.spellId, "alert") -- soak
	canistersCount = canistersCount + 1
	fullCanistersCount = fullCanistersCount + 1
	self:Bar(args.spellId, cd(args.spellId, canistersCount), CL.count:format(L.tick_tock_canisters, fullCanistersCount))
end

function mod:EgoCheck(args)
	self:StopBar(CL.count:format(args.spellName, egoCheckCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, egoCheckCount))
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:Tanking(unit) then
		self:PlaySound(args.spellId, "alarm") -- defensive
	end
	egoCheckCount = egoCheckCount + 1
	self:Bar(args.spellId, cd(args.spellId, egoCheckCount), CL.count:format(args.spellName, egoCheckCount))
end

function mod:EgoCheckApplied(args)
	self:StackMessage(466958, "purple", args.destName, args.amount, 2)
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and not self:Tanking(unit) then -- XXX Confirm swap on every cast?
		self:PlaySound(466958, "warning") -- tauntswap?
	end
end

function mod:OverloadedCoils(args)
	self:StopBar(args.spellId)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm") -- enrage
	-- self:CastBar(args.spellId, 10)
end


-- Mythic

function mod:CombinationCanisters(args)
	self:StopBar(CL.count:format(L.tick_tock_canisters, fullCanistersCount))
	self:Message(args.spellId, "orange", CL.count:format(L.tick_tock_canisters, fullCanistersCount))
	self:PlaySound(args.spellId, "alert") -- soak
	canistersCount = canistersCount + 1
	fullCanistersCount = fullCanistersCount + 1
	self:Bar(args.spellId, cd(args.spellId, canistersCount), CL.count:format(L.tick_tock_canisters, fullCanistersCount))
end

function mod:CircuitRebootApplied(args)
	self:StopBar(CL.intermission)
	self:StopBar(CL.count:format(CL.bombs, fullBombsCount)) -- Biggest Baddest Bomb Barrage/Bigger Badder Bomb Blast
	self:StopBar(CL.count:format(L.tick_tock_canisters, fullCanistersCount)) -- Combination Canisters
	self:StopBar(CL.count:format(L.scatterblast_canisters, fullCanistersCount)) -- Scatterbomb Canisters
	self:StopBar(CL.count:format(self:SpellName(466958), egoCheckCount)) -- Ego Check
	self:StopBar(CL.count:format(self:SpellName(466751), fullVentingHeatCount)) -- Venting Heat
	self:StopBar(CL.count:format(self:SpellName(467182), fullSuppressionCount)) -- Suppression
	self:StopBar(CL.count:format(self:SpellName(469327), gigaBlastCount)) -- Giga Blast
	self:StopBar(CL.count:format(self:SpellName(469286), gigaCoilsCount)) -- Giga Coils

	local stage = self:GetStage() + 0.5
	self:SetStage(stage)
	self:Message("stages", "cyan", CL.intermission, false)
	self:PlaySound("stages", "long")

	mayhemRocketsCount = 1
	mobMarks[231978] = 1 -- Sharpshot Sentry

	self:CDBar("stages", 34, CL.stage:format(stage + 0.5), "inv_misc_desecrated_leatherglove")
end

function mod:MayhemRockets(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, mayhemRocketsCount))
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, 6.0, CL.count:format(args.spellName, mayhemRocketsCount))
	mayhemRocketsCount = mayhemRocketsCount + 1
end

function mod:CircuitRebootRemoved(args)
	local stage = self:GetStage() + 0.5
	self:StopBar(CL.stage:format(stage))

	self:SetStage(stage)
	self:Message("stages", "cyan", CL.stage:format(stage), false)
	self:PlaySound("stages", "long")

	canistersCount = 1
	bombsCount = 1
	suppressionCount = 1
	ventingHeatCount = 1
	egoCheckCount = 1
	gigaBlastCount = 1

	fullCanistersCount = 1
	fullBombsCount = 1
	fullSuppressionCount = 1
	fullVentingHeatCount = 1

	self:CDBar(466751, cd(466751, ventingHeatCount), CL.count:format(self:SpellName(466751), fullVentingHeatCount)) -- Venting Heat
	self:CDBar(1218488, cd(1218488, canistersCount), CL.count:format(L.scatterblast_canisters, fullCanistersCount)) -- Scatterbomb Canisters
	self:CDBar(466958, cd(466958, egoCheckCount), CL.count:format(self:SpellName(466958), egoCheckCount)) -- Ego Check
	self:CDBar(467182, cd(467182, suppressionCount), CL.count:format(self:SpellName(467182), fullSuppressionCount)) -- Suppression
	self:CDBar(1218546, cd(1218546, bombsCount) - 4.5, CL.count:format(CL.bombs, fullBombsCount)) -- Biggest Baddest Bomb Barrage
	self:CDBar(469327, cd(469327, gigaBlastCount), CL.count:format(self:SpellName(469327), gigaBlastCount)) -- Giga Blast

	-- XXX should probably compare against the enrage time
	if stage == 2 then
		self:Bar(469286, 159.2 - 2, CL.count:format(self:SpellName(469286), gigaCoilsCount)) -- Giga Coils
		self:Bar("stages", 167.2, CL.intermission, "ability_mount_rocketmountblue")
	elseif stage == 3 and encounterStart > 0 then
		-- hard enrage at 9:38
		local enrageCD = 578 - (GetTime() - encounterStart)
		self:Bar(1222831, enrageCD) -- Overloaded Coils
	end
end

-- function mod:BiggestBaddestBombBarrage(args)
-- 	self:StopBar(CL.count:format(CL.bombs, fullBombsCount))
-- 	self:Message(args.spellId, "red", CL.count:format(CL.bombs, fullBombsCount))
-- 	self:PlaySound(args.spellId, "warning") -- dodge
-- 	bombsCount = bombsCount + 1
-- 	fullBombsCount = fullBombsCount + 1
-- 	self:Bar(args.spellId, cd(args.spellId, bombsCount), CL.count:format(CL.bombs, fullBombsCount))

-- 	self:Bar(1214755, 5.5) -- Overloaded Rockets
-- end

function mod:ScatterbombCanisters(args)
	self:StopBar(CL.count:format(L.scatterblast_canisters, fullCanistersCount))
	self:Message(args.spellId, "orange", CL.count:format(L.scatterblast_canisters, fullCanistersCount))
	self:PlaySound(args.spellId, "alert") -- frontal soak
	canistersCount = canistersCount + 1
	fullCanistersCount = fullCanistersCount + 1
	self:CDBar(args.spellId, cd(args.spellId, canistersCount), CL.count:format(L.scatterblast_canisters, fullCanistersCount))
end
