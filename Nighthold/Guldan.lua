
--------------------------------------------------------------------------------
-- TODO List:
-- - Soul Siphon CD

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Gul'dan", 1530, 1737)
if not mod then return end
mod:RegisterEnableMob(104154)
mod.engageId = 1866
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local mobCollector = {}
local phase = 1
local obeliskCounter = 1
local bondsCount = 1
local liquidHellfireCount = 1
local handOfGuldanCount = 1
local blackHarvestCount = 1
local stormCount = 1
local flamesCount = 1
local eyeCount = 1
local eyeOnMe = false
local severCount = 1
local crashCounter = 1
local orbCounter = 1
local visionCounter = 1
local essenceCount = 1
local timeStopCheck = nil
local liquidHellfireEmpowered = false
local eyeEmpowered = false
local bondsEmpowered = false
local expectedBonds = mod:Mythic() and 4 or 3
local parasiteSayTimers = {}
local effluxCount = 1
local effluxTimers = {11.0, 14.0, 20.0, 12.0, 12.3, 12.0}

local normalTimers = {
	-- Black Harvest (206744 _start), after 227427 _applied
	[206744] = {71.2, 82.8, 100}, -- not sure if complete
	-- Empowered Eye of Gul'dan P3 (211152 _start), after 227427 _applied
	[211152] = {42.7, 71.4, 71.4, 28.6, 114.3}, -- not sure if complete
}
local heroicTimers = {
	-- Hand of Gul'dan P2
	[212258] = {13.5, 48.9, 138.9},
	-- Storm of the Destroyer (167819 _start), after 227427 _applied
	[167935] = {84.1, 68.8, 61.2, 76.5}, -- timers should be complete
	-- Black Harvest (206744 _start), after 227427 _applied
	[206744] = {64.1, 72.5, 87.6}, -- timers should be complete
	-- Empowered Eye of Gul'dan P3 (211152 _start), after 227427 _applied
	[211152] = {39.1, 62.5, 62.5, 25, 100}, -- timers should be complete
	-- Flames of Sargeras (When applied).
	[221606] = {27.6, 7.8, 8.8, 34.7, 7.8, 8.8, 34.7, 7.8, 8.7, 34.8, 7.7, 8.8, 36.0, 7.7, 8.8}
}
local mythicTimers = {
	-- Hand of Gul'dan "P2"
	[212258] = {16.6, 165},
	-- Storm of the Destroyer (167819 _start), after 227427 _applied
	[167935] = {72.6, 57.9, 51.6, 64.7, 57.4},
	-- Black Harvest (206744 _start), after 227427 _applied
	[206744] = {55.7, 61.0, 75.3, 86.8},
	-- Empowered Eye of Gul'dan P3 (211152 _start), after 227427 _applied
	[211152] = {35.1, 52.6, 53.3, 20.4, 84.2, 52.6},
	-- Flames of Sargeras (When applied).
	[221606] = {25.7, 6.4, 7.4, 29.4, 6.4, 7.4, 29.4, 6.4, 7.4, 29.4, 6.4, 7.4, 29.5, 7.4, 7.4, 28.4, 6.4, 7.4, 28.4, 6.4, 7.4},
	-- Violent Winds
	[218144] = {11.5, 43.4, 66, 75.4}
}

local timers = mod:Mythic() and mythicTimers or mod:Heroic() and heroicTimers or normalTimers

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	-- HORDE: Have you forgotten your humiliation on the Broken Shore? How your mighty warchief was stuck in the belly like a helpless piglet? Will you die slowly as he did, consumed by fel corruption and squealing for a merciful end?
	-- ALLIANCE: Have you forgotten your humiliation on the Broken Shore? How your precious high king was bent and broken before me? Will you beg for your lives as he did, whimpering like some worthless dog?
	L.warmup_trigger = "Have you forgotten"

	L.empowered = "(E) %s" -- (E) Eye of Gul'dan
	L.gains = "Gul'dan gains %s"
	L.p2_start = "You failed, heroes! The ritual is upon us! But first, I'll indulge myself a bit... and finish you!"
	L.p4_mythic_start_yell = "Time to return the demon hunter's soul to his body... and deny the Legion's master a host!"

	L.nightorb = "{227283}"
	L.nightorb_desc = "Summons a Nightorb, killing it will spawn a Time Zone."
	L.nightorb_icon = "inv_icon_shadowcouncilorb_purple"
	L.timeStopZone = "Time Stop Zone"

	L.manifest = "{221149}"
	L.manifest_desc = "Summons a Soul Fragment of Azzinoth, killing it will spawn a Demonic Essence."
	L.manifest_icon = "inv_weapon_glave_01"

	L.winds = "{218144}" -- Violent Winds
	L.winds_desc = "Gul'dan summons Violent Winds to push the players off the platform."
	L.winds_icon = 218144
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ General ]]--
		"warmup",
		"stages",
		"berserk",

		--[[ Essence of Aman'Thul ]]--
		210339, -- Time Dilation
		{217830, "SAY"}, -- Scattering Field
		{210296, "TANK"}, -- Resonant Barrier

		--[[ Stage One ]]--
		{206219, "SAY", "FLASH"}, -- Liquid Hellfire
		206514, -- Fel Efflux
		212258, -- Hand of Gul'dan

		--[[ Inquisitor Vethriz ]]--
		207938, -- Shadowblink
		212568, -- Drain
		206840, -- Gaze of Vethriz

		--[[ Fel Lord Kuraz'mal ]]--
		{206675, "TANK"}, -- Shatter Essence
		229945, -- Fel Obelisk

		--[[ D'zorykx the Trapper ]]--
		208545, -- Anguished Spirits
		206883, -- Soul Vortex
		{206896, "TANK"}, -- Torn Soul

		--[[ Stage Two ]]--
		{209011, "SAY", "FLASH"}, -- Bonds of Fel
		{209270, "PROXIMITY"}, -- Eye of Gul'dan
		208672, -- Carrion Wave

		--[[ Stage Three ]]--
		206939, -- Well of Souls
		221891, -- Soul Siphon
		208802, -- Soul Corrosion
		167935, -- Storm of the Destroyer
		206744, -- Black Harvest
		{221606, "SAY", "FLASH"}, -- Flames of Sargeras
		{211152, "PROXIMITY"}, -- Empowered Eye of Gul'dan
		221781, -- Desolate Ground
		{227556, "TANK"}, -- Fury of the Fel   XXX untested

		--[[ Mythic ]] --
		"winds", -- Violent Winds
		211439, -- Will of the Demon Within
		220957, -- Soulsever
		227071, -- Flame Crash
		{206847, "FLASH", "SAY"}, -- Parasitic Wound
		{206983, "FLASH", "SAY"}, -- Shadowy Gaze
		"manifest", -- Manifest Azzinoth
		221336, -- Chaos Seed
		221408, -- Bulwark of Azzinoth
		221486, -- Purify Essence
		"nightorb", -- Summon Nightorb
		227008, -- Visions of the Dark Titan
		227009, -- Wounded
		{206310, "EMPHASIZE"}, -- Time Stop
	}, {
		["warmup"] = "general",
		[210339] = -14886, -- Essence of Aman'Thul
		[206219] = -14885, -- Stage One
		[207938] = -14897, -- Inquisitor Vethriz
		[206675] = -14894, -- Fel Lord Kuraz'mal
		[208545] = -14902, -- D'zorykx the Trapper
		[209011] = -14062, -- Stage Two
		[206939] = -14090, -- Stage Three
		["winds"] = "mythic",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4", "boss5")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	self:RegisterEvent("RAID_BOSS_EMOTE")

	--[[ Essence of Aman'Thul ]]--
	self:Log("SPELL_AURA_APPLIED", "TimeDilation", 210339)
	self:Log("SPELL_AURA_APPLIED", "ScatteringField", 217830)
	self:Log("SPELL_AURA_APPLIED", "ResonantBarrier", 210296)

	self:Log("SPELL_AURA_APPLIED", "EyeOfAmanThul", 206516)
	self:Log("SPELL_AURA_REMOVED", "EyeOfAmanThulRemoved", 206516)

	--[[ Stage One ]]--
	self:Log("SPELL_CAST_START", "LiquidHellfire", 206219, 206220) -- Normal, Empowered
	self:Log("SPELL_CAST_START", "HandOfGuldan", 212258)
	self:Log("SPELL_CAST_START", "FelEfflux", 206514)
	self:Log("SPELL_AURA_APPLIED", "FelEffluxDamage", 206515)
	self:Log("SPELL_PERIODIC_DAMAGE", "FelEffluxDamage", 206515)
	self:Log("SPELL_PERIODIC_MISSED", "FelEffluxDamage", 206515)

	--[[ Inquisitor Vethriz ]]--
	self:Log("SPELL_CAST_SUCCESS", "Shadowblink", 207938)
	self:Log("SPELL_AURA_APPLIED", "Drain", 212568)
	self:Log("SPELL_CAST_START", "GazeOfVethrizCast", 206840)
	self:Log("SPELL_DAMAGE", "GazeOfVethrizDamage", 217770)
	self:Log("SPELL_MISSED", "GazeOfVethrizDamage", 217770)

	--[[ Fel Lord Kuraz'mal ]]--
	self:Log("SPELL_CAST_START", "ShatterEssence", 206675)

	--[[ D'zorykx the Trapper ]]--
	self:Log("SPELL_CAST_START", "AnguishedSpirits", 208545)
	self:Log("SPELL_CAST_START", "SoulVortex", 206883)
	self:Log("SPELL_AURA_APPLIED", "TornSoul", 206896)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TornSoul", 206896)
	self:Log("SPELL_AURA_REMOVED", "TornSoulRemoved", 206896)

	--[[ Stage Two ]]--
	self:Log("SPELL_CAST_START", "BondsOfFelCast", 206222, 206221) -- Normal, Empowered
	self:Log("SPELL_AURA_APPLIED", "BondsOfFel", 209011, 206384) -- Normal, Empowered
	self:Log("SPELL_CAST_START", "EyeOfGuldan", 209270, 211152) -- Normal, Empowered
	self:Log("SPELL_AURA_APPLIED", "EyeOfGuldanApplied", 209454, 221728) -- Normal, Empowered
	self:Log("SPELL_AURA_REMOVED", "EyeOfGuldanRemoved", 209454, 221728) -- Normal, Empowered
	self:Log("SPELL_DAMAGE", "EyeofGuldandDamage", 209518, 211132) -- Normal, Empowered
	self:Log("SPELL_MISSED", "EyeofGuldandDamage", 209518, 211132) -- Normal, Empowered
	self:Log("SPELL_CAST_START", "Duplicate", 209291)
	self:Log("SPELL_CAST_START", "CarrionWave", 208672)

	--[[ Stage Three ]]--
	self:Log("SPELL_CAST_SUCCESS", "Phase3Start", 227427) -- The Eye of Aman'Thul
	self:Log("SPELL_AURA_APPLIED", "FuryOfTheFel", 227556) -- XXX untested
	self:Log("SPELL_AURA_APPLIED_DOSE", "FuryOfTheFel", 227556) -- XXX untested

	self:Log("SPELL_CAST_START", "StormOfTheDestroyer", 167819, 167935, 177380, 152987)
	self:Log("SPELL_AURA_APPLIED", "SoulSiphon", 221891)
	self:Log("SPELL_AURA_APPLIED", "SoulCorrosion", 208802)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SoulCorrosion", 208802)
	self:Log("SPELL_CAST_START", "BlackHarvest", 206744)
	self:Log("SPELL_AURA_APPLIED", "FlamesOfSargerasSoon", 221606)

	self:Log("SPELL_AURA_APPLIED", "DesolateGroundDamage", 221781)
	self:Log("SPELL_PERIODIC_DAMAGE", "DesolateGroundDamage", 221781)
	self:Log("SPELL_PERIODIC_MISSED", "DesolateGroundDamage", 221781)
	self:Log("SPELL_DAMAGE", "DesolateGroundDamage", 221781)
	self:Log("SPELL_MISSED", "DesolateGroundDamage", 221781)

	self:Death("Deaths", 104537, 104534, 111070, 104154) -- Fel Lord Kuraz'mal, D'zorykx the Trapper, Fragment of Azzinoth, Gul'dan

	-- Mythic
	self:Log("SPELL_CAST_START", "WilloftheDemonWithin", 211439)
	self:Log("SPELL_AURA_APPLIED", "ParasiticWound", 206847)
	self:Log("SPELL_AURA_REMOVED", "ParasiticWoundRemoved", 206847)
	self:Log("SPELL_AURA_APPLIED", "ShadowyGaze", 206983)
	self:Log("SPELL_AURA_APPLIED", "ShearedSoul", 206458)
	self:Log("SPELL_AURA_APPLIED", "Wounded", 227009)
	self:Log("SPELL_CAST_START", "Soulsever", 220957)
	self:Log("SPELL_AURA_APPLIED", "TimeStop", 206310)
	self:Log("SPELL_AURA_REMOVED", "TimeStopRemoved", 206310)
	self:Log("SPELL_CAST_START", "VisionsoftheDarkTitan", 227008)
	self:Log("SPELL_CAST_SUCCESS", "VisionsoftheDarkTitanSuccess", 227008)

	-- Shard of Azzinoth
	self:Log("SPELL_CAST_SUCCESS", "ChaosSeed", 221336)
	self:Log("SPELL_CAST_START", "BulwarkofAzzinoth", 221408)
	self:Log("SPELL_CAST_START", "PurifiedEssence", 221486)
	self:Log("SPELL_CAST_SUCCESS", "PurifiedEssenceSuccess", 221486)

	self:Death("NightorbDeath", 111054)
end

function mod:OnEngage()
	phase = 1
	bondsCount = 1
	liquidHellfireCount = 1
	handOfGuldanCount = 1
	blackHarvestCount = 1
	stormCount = 1
	flamesCount = 1
	eyeCount = 1
	eyeOnMe = false
	obeliskCounter = 1
	essenceCount = 1
	timeStopCheck = nil
	wipe(mobCollector)
	effluxCount = 1
	liquidHellfireEmpowered = false
	bondsEmpowered = false
	eyeEmpowered = false
	expectedBonds = self:Mythic() and 4 or 3
	timers = self:Mythic() and mythicTimers or self:Heroic() and heroicTimers or normalTimers
	if self:Mythic() then
		phase = 2 -- Mythic skips the P1 of heroic
		self:Bar(209011, 6.8, CL.count:format(self:SpellName(209011), bondsCount)) -- Bonds of Fel
		self:Bar(212258, timers[212258][handOfGuldanCount], CL.count:format(self:SpellName(212258), handOfGuldanCount)) -- Hand of Gul'dan
		self:Bar(209270, 26.3, CL.count:format(self:SpellName(209270), eyeCount)) -- Eye of Guldan
		self:Bar(206219, 36.6, CL.count:format(self:SpellName(206219), liquidHellfireCount)) -- Liquid Hellfire
	else
		self:Bar("stages", 35, 206516) -- Eye of Aman'Thul
		self:Bar(212258, 7) -- Hand of Gul'dan
		self:Bar(206514, effluxTimers[effluxCount])
		self:Berserk(720)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if msg:find(L.p2_start) and not self:Mythic() then -- Stage Two: The Ritual of Aman'Thul Start
		self:StopBar(CL.count:format(self:SpellName(206219), liquidHellfireCount)) -- Liquid Hellfire
		self:StopBar(206514) -- Fel Efflux

		phase = 2
		liquidHellfireCount=1
		handOfGuldanCount=1
		eyeCount = 1
		bondsCount = 1

		self:Message("stages", "Neutral", "Long", CL.stage:format(phase), false)

		-- Timers Stage 2
		self:CDBar("stages", 14.5, 226141) -- Arcanetic Eruption timer / (spell icon/name: Knockback)
		self:CDBar("stages", 18.1, 206516) -- Eye of Aman'Thul // Boss Attackable
		self:Bar(209011, self:Easy() and 22.8 or 24.8, CL.count:format(self:SpellName(209011), bondsCount)) -- Bonds of Fel
		if not self:Easy() then
			self:Bar(212258, 31.5, CL.count:format(self:SpellName(212258), handOfGuldanCount)) -- Hand of Guldan
		end
		self:Bar(209270, self:Easy() and 50.4 or 47, CL.count:format(self:SpellName(209270), eyeCount)) -- Eye of Gul'dan
		self:Bar(206219, self:Easy() and 79.6 or 58.1, CL.count:format(self:SpellName(206219), liquidHellfireCount)) -- Liquid Hellfire
	elseif msg == L.p4_mythic_start_yell and self:Mythic() then -- Mythic Stage 4
		phase = 4
		self:Message("stages", "Neutral", "Long", CL.stage:format(phase), false)
		self:Bar(211439, 39) -- Will of the Demon Within
	elseif msg:find(L.warmup_trigger, nil, true) then
		self:Bar("warmup", UnitFactionGroup("player") == "Alliance" and 62 or 66, CL.active, "achievement_thenighthold_guldan")
	end
end

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	self:CheckForEncounterEngage()
	for i=1, 5 do
		local guid = UnitGUID(("boss%d"):format(i))
		if guid and not mobCollector[guid] then
			mobCollector[guid] = true
			if self:MobId(guid) == 104537 then
				self:Message("stages", "Neutral", nil, self:SpellName(-14894), false)
				self:CDBar(206675, self:Mythic() and 20 or 18.3)
				self:CDBar(229945, self:Mythic() and 10 or 10) -- Fel Obelisk
			elseif self:MobId(guid) == 104536 then
				self:Message("stages", "Neutral", nil, self:SpellName(-14897), false)
			elseif self:MobId(guid) == 104534 then
				self:Message("stages", "Neutral", nil, self:SpellName(-14902), false)
			elseif (self:MobId(guid) == 105295 or self:MobId(guid) == 107232 or self:MobId(guid) == 107233 or self:MobId(guid) == 112249) then -- Dreadlords
				self:Message("stages", "Neutral", nil, self:SpellName(209142), false) -- Dreadlord
			elseif self:MobId(guid) == 111070 then -- Soul Fragment of Azzinoth
				self:Bar(221336, 3.3) -- Chaos Seed
			end
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, spellName, _, _, spellId)
	if spellId == 210273 then -- Fel Obelisk
		obeliskCounter = obeliskCounter+1
		self:Message(229945, "Attention", "Alarm")
		self:Bar(229945, self:Mythic() and ((obeliskCounter % 2 == 0) and 5 or 16) or 23) -- Fel Obelisk
	elseif spellId == 227035 then -- Parasitic Wound
		self:Bar(206847, 36.0)
	elseif spellId == 221149 or spellId == 227277 then -- Manifest Azzinoth
		self:Message("manifest", "Attention", "Alert", 221149, L.manifest_icon)
		self:CDBar(221408, 15.0) -- Bulwark of Azzinoth
		self:Bar("manifest", 41.0, 221149, L.manifest_icon) -- Glaive Icon
	elseif spellId == 227071 then -- Flame Crash
		crashCounter = crashCounter + 1
		self:Bar(spellId, crashCounter == 5 and 50 or crashCounter == 8 and 50 or 20, CL.count:format(spellName, crashCounter))
	elseif spellId == 227283 then -- Nightorb
		orbCounter = orbCounter + 1
		self:Message("nightorb", "Attention", "Alert", spellId, L.nightorb_icon)
		if orbCounter ~= 5 then
			self:Bar("nightorb", orbCounter == 3 and 60 or orbCounter == 4 and 40 or 45, CL.count:format(spellName, orbCounter), L.nightorb_icon)
		end
	end
end

function mod:RAID_BOSS_EMOTE(event, msg)
	if msg:find("206221", nil, true) and not bondsEmpowered then -- Gains Empowered Bonds of Fel
		bondsEmpowered = true
		self:Message(209011, "Neutral", nil, L.gains:format(self:SpellName(206221)))
		local oldText = CL.count:format(self:SpellName(209011), bondsCount)
		self:Bar(209011, self:BarTimeLeft(oldText), CL.count:format(L.empowered:format(self:SpellName(209011)), bondsCount)) -- (E) Bonds of Fel
		self:StopBar(oldText) -- Bonds of Fel
	elseif msg:find("206220", nil, true) and not liquidHellfireEmpowered then -- Empowered Liquid Hellfire
		liquidHellfireEmpowered = true -- Fires every cast, not just on gaining empowered
		self:Message(206219, "Neutral", nil, L.gains:format(self:SpellName(206220)))
		local oldText = CL.count:format(self:SpellName(206219), liquidHellfireCount)
		self:Bar(206219, self:BarTimeLeft(oldText), CL.count:format(L.empowered:format(self:SpellName(206219)), liquidHellfireCount)) -- (E) Liquid Hellfire
		self:StopBar(oldText) -- Liquid Hellfire
	elseif msg:find("211152", nil, true) and not eyeEmpowered then -- Empowered Eye of Gul'dan
		eyeEmpowered = true
		self:Message(211152, "Neutral", nil, L.gains:format(self:SpellName(211152)))
		local oldText = CL.count:format(self:SpellName(209270), eyeCount)
		self:Bar(211152, self:BarTimeLeft(oldText), CL.count:format(L.empowered:format(self:SpellName(209270)), eyeCount)) -- (E) Eye of Guldan
		self:StopBar(oldText) -- Eye of Gul'dan
	end
end

--[[ Essence of Aman'Thul ]]--
function mod:TimeDilation(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal")
	end
end

do
	local list = mod:NewTargetList()
	function mod:ScatteringField(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.5, args.spellId, list, "Positive", "Info", nil, nil, true)
		end
		if self:Me(args.sourceGUID) then
			self:Say(args.spellId)
		end
	end
end

function mod:ResonantBarrier(args)
	self:TargetMessage(args.spellId, args.destName, "Positive")
	self:TargetBar(args.spellId, 6, args.destName)
end

function mod:EyeOfAmanThul(args)
	self:Message("stages", "Neutral", "Long", args.spellName, args.spellId)
	if self:Easy() then
		self:Bar(206514, 9.8) -- Fel Efflux
	end
end

function mod:EyeOfAmanThulRemoved(args) -- Phase 2 start
	if phase ~= 2 then -- Boss say message is faster, don't trigger if we already are in phase 2
		self:StopBar(CL.count:format(self:SpellName(206219), liquidHellfireCount)) -- Liquid Hellfire
		self:StopBar(206514) -- Fel Efflux

		phase = 2
		handOfGuldanCount = 1
		liquidHellfireCount = 1
		bondsCount = 1
		eyeCount = 1

		self:Message("stages", "Neutral", "Long", CL.stage:format(2), args.spellId)
		self:Bar(209011, self:Easy() and 7.5 or 9.5, CL.count:format(self:SpellName(209011), bondsCount)) -- Bonds of Fel
		if not self:Easy() then
			self:Bar(212258, 13.5, CL.count:format(self:SpellName(212258), handOfGuldanCount)) -- Hand of Gul'dan
		end
		self:Bar(206219, self:Easy() and 45 or 23.5, CL.count:format(self:SpellName(206219), liquidHellfireCount)) -- Liquid Hellfire
		self:Bar(209270, self:Easy() and 32.4 or 29, CL.count:format(self:SpellName(209270), eyeCount)) -- Eye of Gul'dan
	end
end

function mod:Deaths(args)
	if args.mobId == 104537 then -- Fel Lord Kuraz'mal
		self:StopBar(206675) -- Shatter Essence
		self:StopBar(229945) -- Fel Obelisk
	elseif args.mobId == 104534 then -- D'zorykx the Trapper
		self:StopBar(206883) -- Soul Vortex
		self:StopBar(CL.cast:format(self:SpellName(206883))) -- Soul Vortex cast
	elseif args.mobId == 111070 then -- Azzinoth
		self:StopBar(221336) -- Chaos Seed
	elseif args.mobId == 104154 and self:Mythic() then -- Guldan
		self:StopBar(CL.count:format(self:SpellName(221606), flamesCount % 3 == 0 and 3 or flamesCount % 3)) -- Flames Bar
		self:StopBar(206744) -- Black Harvest
		self:StopBar(167935) -- Storm of the Destroyer
		self:StopBar(CL.count:format(L.empowered:format(self:SpellName(209270)), eyeCount)) -- Eye of Guldan
	end
end

--[[ Stage One ]]--
function mod:LiquidHellfire(args)
	local spellName = self:SpellName(206219)
	self:Message(206219, "Urgent", "Alarm", CL.incoming:format(CL.count:format(args.spellName, liquidHellfireCount)))
	liquidHellfireCount = liquidHellfireCount + 1
	if self:Mythic() and liquidHellfireCount == 3 then -- Empowered spells are set in Mythic
		liquidHellfireEmpowered = true
	end
	if liquidHellfireEmpowered then
		spellName = L.empowered:format(spellName)
	end
	local t = 0
	if phase == 1 then
		t = liquidHellfireCount == 2 and 15 or (self:Easy() and liquidHellfireCount > 3 and 32.5) or 25
	elseif self:Mythic() then
		t = (liquidHellfireCount == 5 or liquidHellfireCount == 7) and 66 or 33
	elseif self:Easy() then
		t = liquidHellfireCount == 5 and 82.5 or 41.2
	else
		t = liquidHellfireCount == 5 and 73.2 or 36.6
	end
	self:Bar(206219, t, CL.count:format(spellName, liquidHellfireCount)) -- gets skipped once
end

function mod:FelEfflux(args)
	effluxCount=effluxCount+1
	self:Message(args.spellId, "Important", "Alert")
	if self:Easy() then
		self:CDBar(args.spellId, 15.6) -- easy: pull, 11, 14, EyeOfAmanThul, 10, 15.6, 16.8, 15.6,...
	else
		self:Bar(args.spellId, effluxTimers[effluxCount] or 12)
	end
end

do
	local prev = 0
	function mod:FelEffluxDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(206514, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

function mod:HandOfGuldan(args)
	self:Message(args.spellId, "Attention", "Info")
	handOfGuldanCount = handOfGuldanCount + 1
	if phase == 1 and handOfGuldanCount < 4 then
		self:Bar(args.spellId, handOfGuldanCount == 2 and 14 or 10, CL.count:format(args.spellName, handOfGuldanCount))
	elseif phase == 2 then
		local timer = timers[args.spellId][handOfGuldanCount]
		if timer then
			self:Bar(args.spellId, timer, CL.count:format(args.spellName, handOfGuldanCount))
		end
	end
end

--[[ Inquisitor Vethriz ]]--
function mod:Shadowblink(args)
	self:Message(args.spellId, "Attention", "Info")
end

function mod:Drain(args)
	if self:Dispeller("magic") or self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	end
end

function mod:GazeOfVethrizCast(args)
	self:Message(args.spellId, "Attention", "Info")
end

do
	local prev = 0
	function mod:GazeOfVethrizDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(206840, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

--[[ Fel Lord Kuraz'mal ]]--
function mod:ShatterEssence(args)
	self:Message(args.spellId, "Important", "Warning", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 3)
	self:Bar(args.spellId, self:Mythic() and 21 or 52)
end

--[[ D'zorykx the Trapper ]]--
function mod:AnguishedSpirits(args)
	self:Message(args.spellId, "Attention", "Alert", CL.incoming:format(args.spellName))
end

function mod:SoulVortex(args)
	self:Message(args.spellId, "Urgent", "Long")
	self:CastBar(args.spellId, 9) -- actual cast + pull in
	self:Bar(args.spellId, 21.1)
end

function mod:TornSoul(args)
	if self:Tank(args.destName) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 1 and "Warning") -- check sound amount
		self:TargetBar(args.spellId, 30, args.destName)
	end
end

function mod:TornSoulRemoved(args)
	self:StopBar(args.spellId, args.destName)
end

--[[ Stage Two ]]--
function mod:BondsOfFelCast(args)
	local spellName = self:SpellName(209011)
	self:Message(209011, "Attention", "Info", CL.casting:format(CL.count:format(args.spellName, bondsCount)))
	bondsCount = bondsCount + 1
	if self:Mythic() then -- Only the first cast is not empowered
		bondsEmpowered = true
	end
	if bondsEmpowered then
		spellName = L.empowered:format(spellName)
	end
	self:Bar(209011, self:Mythic() and 40 or self:Heroic() and 44.5 or 50, CL.count:format(spellName, bondsCount))
end

do
	local list, scheduled = mod:NewTargetList(), nil
	function mod:BondsOfFel(args)
		list[#list+1] = args.destName
		if #list == 1 then
			scheduled = self:ScheduleTimer("TargetMessage", 1, 209011, list, "Important", "Warning", CL.count:format(self:SpellName(209011), bondsCount-1), nil, true) -- Have the bonds number in the list warning also
		end
		if self:Me(args.destGUID) then
			self:Say(209011, CL.count:format(args.spellName, #list))
			self:Flash(209011)
		end
		if #list == expectedBonds then
			self:CancelTimer(scheduled)
			self:TargetMessage(209011, list, "Important", "Warning", CL.count:format(self:SpellName(209011), bondsCount-1), nil, true) -- Have the bonds number in the list warning also
		end
	end
end

function mod:EyeOfGuldan(args)
	local spellName = self:SpellName(209270)
	self:Message(args.spellId, "Urgent", "Alert", CL.count:format(args.spellName, eyeCount))
	eyeCount = eyeCount + 1
	if self:Mythic() and eyeCount == 6 then -- Empowered Eye next in Mythic
		eyeEmpowered = true
	end
	if eyeEmpowered then
		spellName = L.empowered:format(spellName)
	end
	local timer = nil
	if phase == 2 then
		timer = self:LFR() and 64 or self:Normal() and 60 or (self:Mythic() and (eyeCount == 7 and 80 or 48)) or 53.3
	else
		timer = timers[211152][eyeCount]
	end
	if timer or self:Easy() then -- message for incomplete easy timers
		self:Bar(args.spellId, timer, CL.count:format(spellName, eyeCount))
	end
end

function mod:EyeOfGuldanApplied(args)
	if self:Me(args.destGUID) then
		eyeOnMe = true
		local spellId = args.spellId == 209454 and 209270 or 211152
		local spellName = args.spellId == 209454 and args.spellName or L.empowered:format(args.spellName)
		self:Message(spellId, "Personal", "Alert", CL.you:format(spellName))
		self:OpenProximity(spellId, 8)
	end
end

function mod:EyeOfGuldanRemoved(args)
	if self:Me(args.destGUID) then
		eyeOnMe = false
		self:CloseProximity(args.spellId == 209454 and 209270 or 211152)
	end
end

do
	local prev = 0
	function mod:EyeofGuldandDamage(args)
		if self:Me(args.destGUID) then
			local spellId = args.spellId == 209518 and 209270 or 211152
			local spellName = args.spellId == 209518 and args.spellName or L.empowered:format(args.spellName)
			local t = GetTime()
			if t-prev < 0.5 then -- Warn if you take more than one tick
				self:Message(spellId, "Personal", "Alert", CL.underyou:format(spellName))
			elseif eyeOnMe == false then -- Always warn if you arn't fixated
				self:Message(spellId, "Personal", "Alert", CL.underyou:format(spellName))
			end
			prev = t
		end
	end
end

do
	local prev = 0
	function mod:Duplicate(args)
		local t = GetTime()
		if t-prev > 1.5 then
			prev = t
			self:Message(209270, "Neutral", "Info", args.spellId)
		end
	end
end

function mod:CarrionWave(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "Attention", "Long")
		self:Bar(args.spellId, 6.1)
	end
end

--[[ Stage Three ]]--
function mod:FuryOfTheFel(args)
	local amount = args.amount or 1
	self:Message(args.spellId, "Positive", "Info", CL.count:format(args.spellName, amount))
end

function mod:Phase3Start(args) -- The Eye of Aman'thul applied (227427)
	self:StopBar(CL.count:format(self:SpellName(212258), handOfGuldanCount)) -- Hand of Gul'dan
	self:StopBar(CL.count:format(L.empowered:format(self:SpellName(209011)), bondsCount)) -- Empowered Bonds of Fel
	self:StopBar(CL.count:format(L.empowered:format(self:SpellName(206219)), liquidHellfireCount)) -- Empowered Liquid Hellfire
	self:StopBar(CL.count:format(L.empowered:format(self:SpellName(209270)), eyeCount)) -- Empowered Eye of Gul'dan

	eyeCount = 1
	phase = 3
	self:Message("stages", "Neutral", "Long", CL.stage:format(3), args.spellId)
	self:Bar("stages", 8, args.spellName, args.spellId) -- Eye of Aman'Thul
	self:CDBar("winds", 11.5, CL.count:format(self:SpellName(218144), blackHarvestCount), 218144) -- Violent Winds, using blackHarvestCount, only once below Mythic.
	self:Bar(206939, 15.2) -- Well of Souls
	self:Bar(221606, self:Mythic() and 24.5 or self:Heroic() and 27.5 or 29.3) -- Flames of Sargeras
	self:Bar(211152, timers[211152][eyeCount], CL.count:format(L.empowered:format(self:SpellName(209270)), eyeCount)) -- Empowered Eye of Gul'dan
	self:Bar(206744, timers[206744][blackHarvestCount], CL.count:format(self:SpellName(206744), blackHarvestCount)) -- Black Harvest
	self:Bar(167935, self:Easy() and 94 or timers[167935][stormCount]) -- Storm of the Destroyer
end

function mod:StormOfTheDestroyer(args)
	self:Message(167935, "Important", "Long")
	if args.spellId == 167819 then -- First Storm
		stormCount = stormCount + 1
		if self:Easy() then
			self:Bar(167935, stormCount == 2 and 78.5 or 70)
		else
			local timer = timers[167935][stormCount]
			if timer then
				self:Bar(167935, timer) -- timers should be complete
			end
		end
	end
end

do
	local list = mod:NewTargetList()
	function mod:SoulSiphon(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 1, args.spellId, list, "Important")
		end
	end
end

function mod:SoulCorrosion(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "Personal", amount > 2 and "Info") -- check sound amount
	end
end

function mod:BlackHarvest(args)
	self:Message(args.spellId, "Urgent", "Alert", CL.count:format(args.spellName, blackHarvestCount))
	blackHarvestCount = blackHarvestCount + 1
	local timer = timers[args.spellId][blackHarvestCount]
	if timer or self:Easy() then -- message for incomplete easy timers
		self:CDBar(args.spellId, timer, CL.count:format(args.spellName, blackHarvestCount))
	end
	-- Violet Winds timers
	if self:Mythic() then
		local windsTimer = timers[218144][blackHarvestCount]
		if windsTimer then
			self:Bar("winds", windsTimer, CL.count:format(self:SpellName(218144), blackHarvestCount), 218144)
		end
	end
end

do
	local prev = 0
	function mod:DesolateGroundDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

do
	local prev = 0
	function mod:FlamesOfSargerasSoon(args)
		if self:Me(args.destGUID) then
			self:TargetMessage(args.spellId, args.destName, "Personal", "Warning")
			self:Say(args.spellId)
			self:Flash(args.spellId)
			self:TargetBar(args.spellId, 6, args.destName)
		elseif self:Tank(args.destName) and self:Tank() then -- Tank taunt mechanic in P3
			self:TargetMessage(args.spellId, args.destName, "Personal", "Warning")
		end
		local t = GetTime()
		if t-prev > 5 then
			prev = t
			flamesCount = flamesCount + 1
			if self:Easy() then
				self:Bar(args.spellId, flamesCount == 9 and 41 or flamesCount % 2 == 0 and 19 or 39.6)
			else
				local timer = timers[args.spellId][flamesCount]
				if timer then
					self:Bar(args.spellId, timer, CL.count:format(args.spellName, flamesCount % 3 == 0 and 3 or flamesCount % 3))
				end
			end
		end
	end
end

-- Mythic Only
function mod:WilloftheDemonWithin(args)
	if phase ~= 4 then -- Fallback for missing the p4 yell
		phase = 4
		self:Message("stages", "Neutral", "Long", CL.stage:format(phase), false)
	end

	self:Message(args.spellId, "Attention", "Warning")
	self:CastBar(args.spellId, 4)

	severCount = 1
	crashCounter = 1
	orbCounter = 1
	visionCounter = 1
	self:Bar(206847, 8.6) -- Parasitic Wound
	self:Bar(220957, 19.6, CL.count:format(self:SpellName(220957), severCount)) -- Soulsever
	self:Bar("manifest", 26.6, 221149, L.manifest_icon) -- Manifest Azzinoth
	self:Bar(227071, 29.6, CL.count:format(self:SpellName(227071), crashCounter)) -- Flame Crash
	self:Bar("nightorb", 39.6, CL.count:format(self:SpellName(227283), orbCounter), L.nightorb_icon) -- Summon Nightorb
	self:Bar(227008, 96.2, CL.count:format(self:SpellName(227008), visionCounter)) -- Visions of the Dark Titan
end

do
	local playerList = mod:NewTargetList()
	function mod:ParasiticWound(args)
		local _, _, _, expires = self:UnitDebuff(args.destName, args.spellName)
		local remaining = expires-GetTime()
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
			for i = 1, 3 do
				if remaining-i > 0 then
					parasiteSayTimers[#parasiteSayTimers+1] = self:ScheduleTimer("Say", remaining-i, 206847, i, true)
				end
			end
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, playerList, "Urgent", "Alarm", nil, nil, true)
		end
	end
end

function mod:ParasiticWoundRemoved(args) -- Stop Parasite Say Messages
	if self:Me(args.destGUID) then
		for _,timer in pairs(parasiteSayTimers) do
			self:CancelTimer(timer)
		end
		wipe(parasiteSayTimers)
	end
end

function mod:TimeStop(args) -- Stop Parasite Say Messages
	if self:Me(args.destGUID) then
		for _,timer in pairs(parasiteSayTimers) do
			self:CancelTimer(timer)
		end
		wipe(parasiteSayTimers)
	end
end

function mod:TimeStopRemoved(args) -- Resume Parasite Say Messages
	if self:Me(args.destGUID) then
		local debuff, _, _, expires = self:UnitDebuff("player", self:SpellName(206847))
		if not debuff then return end
		local remaining = floor(expires - GetTime())

		for i = 1, 3 do
			if remaining-i > 0 then
				parasiteSayTimers[#parasiteSayTimers+1] = self:ScheduleTimer("Say", remaining-i, 206847, i, true)
			end
		end
	end
end

do
	-- 4 Fixates, 2 players, avoid double names in list.
	local playerList, first = mod:NewTargetList(), ""
	function mod:ShadowyGaze(args)
		if #playerList == 0 then -- First fixate
			first = args.destName
			playerList[#playerList+1] = args.destName
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, playerList, "Important", "Info")
		end
		if args.destName ~= first and #playerList < 2 then -- Second Fixate
			playerList[#playerList+1] = args.destName
		end
	end
end

function mod:Soulsever(args)
	severCount = severCount + 1
	self:Message(args.spellId, "Urgent", self:Tank() and "Warning", args.spellName)
	self:Bar(args.spellId, severCount == 5 and 50 or severCount == 8 and 50 or 20, CL.count:format(args.spellName, severCount))
end

function mod:ShearedSoul(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(220957, args.destName, "Personal", "Alert")
	end
end

do
	local timeStop = mod:SpellName(206310)

	local function checkForTimeStop(self)
		if UnitIsDead("player") then
			-- Nothing
		elseif not self:UnitDebuff("player", timeStop) then
			self:Message(206310, "Personal", "Warning", CL.no:format(timeStop))
			timeStopCheck = self:ScheduleTimer(checkForTimeStop, 1.5, self)
		else
			self:Message(206310, "Positive", nil, CL.you:format(timeStop))
		end
	end

	function mod:PurifiedEssence(args)
		self:Message(args.spellId, "Important", "Alarm", CL.cast:format(CL.count:format(args.spellName, essenceCount)))
		essenceCount = essenceCount + 1
		self:CastBar(args.spellId, 4, CL.count:format(args.spellName, essenceCount))
		if not timeStopCheck then
			checkForTimeStop(self)
		end
	end

	function mod:PurifiedEssenceSuccess()
		if timeStopCheck then
			self:CancelTimer(timeStopCheck)
			timeStopCheck = nil
		end
	end

	function mod:VisionsoftheDarkTitan(args)
		visionCounter = visionCounter+1
		self:Message(args.spellId, "Important", "Alarm", CL.casting:format(args.spellName))
		self:CastBar(args.spellId, 9)
		if visionCounter ~= 4 then
			self:Bar(args.spellId, visionCounter == 3 and 150 or 90, CL.count:format(args.spellName, visionCounter))
		end
		if not timeStopCheck then
			checkForTimeStop(self)
		end
	end

	function mod:VisionsoftheDarkTitanSuccess()
		if timeStopCheck then
			self:CancelTimer(timeStopCheck)
			timeStopCheck = nil
		end
	end
end

function mod:Wounded(args)
	self:Message(args.spellId, "Neutral", "Long")
	self:Bar(args.spellId, 15)
	self:StopBar(CL.cast:format(self:SpellName(227008))) -- Visions of the Dark Titan
end

-- Shard of Azzinoth
function mod:ChaosSeed(args)
	self:Bar(args.spellId, 10.9)
end

function mod:BulwarkofAzzinoth(args)
	self:Message(args.spellId, "Urgent", "Alert")
end

function mod:NightorbDeath()
	self:Bar(206310, 10, CL.count:format(L.timeStopZone, orbCounter-1))
end
