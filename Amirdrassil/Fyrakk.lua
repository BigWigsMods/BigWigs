--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Fyrakk the Blazing", 2549, 2519)
if not mod then return end
mod:RegisterEnableMob(204931) -- Fyrakk
mod:SetEncounterID(2677)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Timers
--

local timersHeroic = {
	[419123] = {5.5, 75, 80, 0}, -- Flamefall
	[417431] = {18.5, 11, 60, 11, 11, 58, 11, 11}, -- Fyr'alath's Bite
	[422518] = {35.5, 80, 0}, -- Greater Firestorm
	[422524] = {58.5, 80, 0}, -- Shadowflame Devastation
	[422032] = {20, 20, 25, 29, 26, 24, 25}, -- Spirits of the Kaldorei
	[414186] = {20.2, 15, 25, 30, 26.9, 23, 30, 25}, -- Blaze
	[412761] = {44.0, 80, 79.5, 0}, -- Incarnate
	[417807] = {27.5, 16, 58.5, 16, 64.5, 16, 13.5}, -- Aflame
}

local timersMythic = {
	[419123] = timersHeroic[419123], -- Flamefall
	[417431] = timersHeroic[417431], -- Fyr'alath's Bite
	[422518] = timersHeroic[422518], -- Greater Firestorm
	[422524] = timersHeroic[422524], -- Shadowflame Devastation
	[422032] = {20, 20, 25, 29, 26, 26.7, 27}, -- Spirits of the Kaldorei
	[414186] = {20, 15, 25, 34, 23, 23, 34, 21}, -- Blaze
	[412761] = timersHeroic[412761], -- Incarnate
	[417807] = timersHeroic[417807], -- Aflame
}
local timers = mod:Mythic() and timersMythic or timersHeroic

--------------------------------------------------------------------------------
-- Locals
--

local fyralathsBiteCount = 1
local blazeCount = 1

local aflameCount = 1
local firestormCount = 1
local wildfireCount = 1
local dreamRendCount = 1
local darkflameShadesCount = 1
local darkflameCleaveCount = 1

local corruptApplied = 0
local shadowflameOrbsCount = 1

local spiritsCount = 1
local incarnateCount = 1
local shadowflameDevastationCount = 1
local flamefallCount = 1
local shadowCageCount = 1
local addCount = 0

local eternalFirestormSwirlCount = 1
local shadowflameBreathCount = 1
local apocalypseRoarCount = 1
local infernalMawCount = 1

local timerHandles = {}
local myOrb = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.spirits_trigger = "Spirit of the Kaldorei" -- [CHAT_MSG_MONSTER_YELL] Amirdrassil must not fall.#Spirit of the Kaldorei

	L.fyralaths_bite = "Frontal"
	L.fyralaths_bite_mythic = "Frontals"
	L.darkflame_shades = "Shades"
	L.darkflame_cleave = "Mythic Soaks"

	L.incarnate_intermission = "Knock Up"

	L.incarnate = "Fly Away"
	L.molten_gauntlet = "Gauntlet"
	L.mythic_debuffs = "Cages" -- Shadow Cage & Molten Eruption

	L.greater_firestorm_shortened_bar = "Firestorm [G]" -- G for Greater
	L.greater_firestorm_message_full = "Firestorm [Greater]"
	L.eternal_firestorm_shortened_bar = "Firestorm [E]" -- E for Eternal
	L.eternal_firestorm_message_full = "Firestorm [Eternal]"

	L.eternal_firestorm_swirl = "Eternal Firestorm Pools"
	L.eternal_firestorm_swirl_desc = "Show timers for when the Eternal Firestorm will spawn the pools that you need to avoid standing in."
	L.eternal_firestorm_swirl_icon = 402736

	L.flame_orb = "Flame Orb"
	L.shadow_orb = "Shadow Orb"
	L.orb_message_flame = "You are Flame"
	L.orb_message_shadow = "You are Shadow"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		429872, -- Amirdrassil Burns
		{414186, "PRIVATE"}, -- Blaze
		417807, -- Aflame
		417431, -- Fyr'alath's Bite
		{417443, "TANK"}, -- Fyr'alath's Mark

		-- Stage One: The Dream Render
		{419506, "PRIVATE"}, -- Firestorm
		419504, -- Raging Flames (Damage)
		420422, -- Wildfire
		417455, -- Dream Rend
		425483, -- Incinerated (Damage)
		-- Mythic
		{430441, "OFF"}, -- Darkflame Shades
		{426368, "CASTBAR", "PRIVATE"}, -- Darkflame Cleave

		-- Intermission: Amirdrassil in Peril
		{419144, "CASTBAR"}, -- Corrupt
		421937, -- Shadowflame Orbs
		429866, -- Shadowflame Eruption
		{429906, "ME_ONLY_EMPHASIZE"}, -- Shadowbound
		{429903, "ME_ONLY_EMPHASIZE"}, -- Flamebound

		-- Stage Two: Children of the Stars
		422032, -- Spirits of the Kaldorei
		{422518, "PRIVATE"}, -- Greater Firestorm
		{428963, "TANK"}, -- Molten Gauntlet
		428400, -- Exploding Core
		412761, -- Incarnate
		422524, -- Shadowflame Devastation
		419123, -- Flamefall
		-- Mythic
		{428971, "PRIVATE"}, -- Molten Eruption
		{428970, "PRIVATE"}, -- Shadow Cage

		-- Stage Three: Shadowflame Incarnate
		{422935, "PRIVATE"}, -- Eternal Firestorm
		"eternal_firestorm_swirl",
		422837, -- Apocalypse Roar
		410223, -- Shadowflame Breath
		{425492, "TANK"}, -- Infernal Maw
		-- Seed of Amirdrassil
		423601, -- Seed of Amirdrassil
		423717, -- Bloom
		423598, -- Blazing Seed (Damage)
		-- Mythic
		430048, -- Corrupted Seed
	},{
		["stages"] = "general",
		[419506] = -26666, -- Stage One: The Dream Render
		[430441] = "mythic",
		[419144] = -26667, -- Intermission: Amirdrassil in Peril
		[429906] = "mythic",
		[422032] = -26668, -- Stage Two: Children of the Stars
		[428971] = "mythic",
		[422935] = -26670, -- Stage Three: Shadowflame Incarnate
		[423601] = 423601, -- Seed of Amirdrassil
		[430048] = "mythic",
	},{
		[417431] = L.fyralaths_bite.."/"..L.fyralaths_bite_mythic, -- Fyr'alath's Bite (Frontal/Frontals)
		[417443] = CL.mark, -- Fyr'alath's Mark (Mark)
		[430441] = L.darkflame_shades, -- Darkflame Shades (Shades)
		[426368] = L.darkflame_cleave, -- Darkflame Cleave (Mythic Soaks)
		[421937] = CL.orbs, -- Shadowflame Orbs (Orbs)
		[429906] = L.shadow_orb, -- Shadowbound (Shadow Orb)
		[429903] = L.flame_orb, -- Flamebound (Flame Orb)
		[422032] = CL.spirits, -- Spirits of the Kaldorei (Spirits)
		[422518] = L.greater_firestorm_shortened_bar, -- Greater Firestorm (Firestorm [G])
		[428970] = L.mythic_debuffs, -- Shadow Cage (Cages)
		[412761] = L.incarnate, -- Incarnate (Fly Away)
		[422524] = CL.breath, -- Shadowflame Devastation (Breath)
		[423717] = CL.absorb, -- Bloom (Absorb)
		[422935] = L.eternal_firestorm_shortened_bar, -- Eternal Firestorm (Firestorm [E])
		[410223] = CL.breath, -- Shadowflame Breath (Breath)
		[422837] = CL.roar, -- Apocalypse Roar (Roar)
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL") -- P2 Spirit of the Kaldorei
	self:RegisterMessage("BigWigs_EncounterEnd") -- stop simulated bars immediately on wipe

	self:Log("SPELL_AURA_APPLIED", "AmirdrassilBurns", 429872)
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 419504, 425483) -- Raging Flames, Incinerated
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 419504, 425483, 410223) -- Shadowflame Breath (not in _APPLIED)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 419504, 425483, 410223)

	-- self:Log("SPELL_CAST_SUCCESS", "Blaze", 414186) -- Scheduled
	self:Log("SPELL_AURA_APPLIED", "AflameApplied", 417807)
	self:Log("SPELL_AURA_APPLIED_DOSE", "AflameApplied", 417807)
	self:Log("SPELL_AURA_REMOVED", "AflameRemoved", 417807)
	self:Log("SPELL_CAST_START", "FyralathsBite", 417431)
	self:Log("SPELL_AURA_APPLIED", "FyralathsMarkApplied", 417443)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FyralathsMarkApplied", 417443)

	-- Stage One: The Dream Render
	self:Log("SPELL_CAST_START", "Firestorm", 419506)
	self:Log("SPELL_CAST_START", "Wildfire", 420422)
	self:Log("SPELL_CAST_START", "DreamRend", 417455)
	-- Mythic
	self:Log("SPELL_CAST_SUCCESS", "DarkflameShades", 430441)
	self:Log("SPELL_CAST_SUCCESS", "DarkflameCleave", 426368)

	-- Intermission: Amirdrassil in Peril
	self:Log("SPELL_CAST_START", "Corrupt", 419144)
	self:Log("SPELL_AURA_APPLIED", "CorruptApplied", 421922)
	self:Log("SPELL_AURA_REMOVED", "CorruptRemoved", 421922)
	-- self:Log("SPELL_CAST_SUCCESS", "ShadowflameOrbs", 421937) -- Scheduled
	self:Log("SPELL_AURA_APPLIED", "ShadowflameEruptionApplied", 429866)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShadowflameEruptionApplied", 429866)
	self:Log("SPELL_AURA_APPLIED", "ShadowboundApplied", 429906)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShadowboundApplied", 429906)
	self:Log("SPELL_AURA_APPLIED", "FlameboundApplied", 429903)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FlameboundApplied", 429903)

	-- Stage Two: Children of the Stars
	self:Log("SPELL_CAST_SUCCESS", "SpiritsOfTheKaldorei", 422032)
	self:Log("SPELL_CAST_START", "GreaterFirestorm", 422518)
	self:Log("SPELL_CAST_START", "Gauntlet", 428963, 428965) -- Molten Gauntlet, Shadow Gauntlet
	self:Log("SPELL_CAST_START", "ExplodingCore", 428400)
	self:Death("ColossusDeath", 207796, 214012) -- Burning Colossus, Dark Colossus

	self:Log("SPELL_CAST_START", "Incarnate", 412761)
	self:Log("SPELL_CAST_SUCCESS", "ShadowflameDevastation", 422524)
	self:Log("SPELL_CAST_START", "Flamefall", 419123)

	-- Stage Three: Shadowflame Incarnate
	self:Log("SPELL_CAST_SUCCESS", "EternalFirestormP3", 422935)
	self:Log("SPELL_CAST_START", "ShadowflameBreath", 410223)
	self:Log("SPELL_CAST_START", "ApocalypseRoar", 422837)
	self:Log("SPELL_CAST_START", "InfernalMaw", 425492)
	self:Log("SPELL_AURA_APPLIED", "InfernalMawApplied", 429672)
	self:Log("SPELL_AURA_APPLIED_DOSE", "InfernalMawApplied", 429672)

	self:Log("SPELL_AURA_APPLIED", "BloomApplied", 423717)
	-- self:Log("SPELL_AURA_REMOVED", "BloomRemoved", 423717)
	self:Log("SPELL_CAST_SUCCESS", "BlazingSeedDamage", 423598)
end

function mod:OnEngage()
	timers = self:Mythic() and timersMythic or timersHeroic
	self:SetStage(1)

	blazeCount = 1
	fyralathsBiteCount = 1

	aflameCount = 1
	firestormCount = 1
	wildfireCount = 1
	dreamRendCount = 1
	darkflameShadesCount = 1
	darkflameCleaveCount = 1
	timerHandles = {}

	shadowflameBreathCount = 1
	flamefallCount = 1
	shadowflameDevastationCount = 1
	apocalypseRoarCount = 1
	infernalMawCount = 1
	spiritsCount = 1
	incarnateCount = 1
	addCount = 0
	myOrb = nil

	self:Bar(420422, 4.0, CL.count:format(self:SpellName(420422), wildfireCount)) -- Wildfire
	self:Bar(417431, 9.0, CL.count:format(self:Mythic() and L.fyralaths_bite_mythic or L.fyralaths_bite, fyralathsBiteCount)) -- Fyr'alath's Bite
	self:Bar(419506, self:Mythic() and 12.0 or 13.0, CL.count:format(self:SpellName(419506), firestormCount)) -- Firestorm
	self:Bar(417455, self:Mythic() and 48.0 or 42.0, CL.count:format(self:SpellName(417455), dreamRendCount)) -- Dream Rend
	self:Bar(417807, self:Easy() and 12 or 8, CL.count:format(self:SpellName(417807), aflameCount)) -- Aflame

	if not self:Easy() then
		local cd = self:Mythic() and 36 or 32
		self:Bar(414186, cd, CL.count:format(self:SpellName(414186), blazeCount)) -- Blaze
		timerHandles[414186] = self:ScheduleTimer("Blaze", cd)
	end
	if self:Mythic() then
		self:Bar(426368, 28.0, CL.count:format(L.darkflame_cleave, darkflameCleaveCount))
	end

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
	self:SetPrivateAuraSound(414186, 414187) -- Blaze
	self:SetPrivateAuraSound(414186, 421825)
	self:SetPrivateAuraSound(414186, 421826)
	self:SetPrivateAuraSound(414186, 421827)
	self:SetPrivateAuraSound(414186, 421828)
	self:SetPrivateAuraSound(414186, 421829)
	self:SetPrivateAuraSound(419506, 419060) -- Firestorm
	self:SetPrivateAuraSound(422518, 422520) -- Greater Firestorm
	self:SetPrivateAuraSound(422935, 425525) -- Eternal Firestorm
	if self:Mythic() then
		self:SetPrivateAuraSound(426368, 426370) -- Darkflame Cleave
		self:SetPrivateAuraSound(428971, 428988, "alarm") -- Molten Eruption
		self:SetPrivateAuraSound(428970, 428970) -- Shadow Cage
	end
end

function mod:BigWigs_EncounterEnd()
	for id, timer in next, timerHandles do
		self:CancelTimer(timer)
		timerHandles[id] = nil
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 72 then -- Intermission at 70%
		self:UnregisterUnitEvent(event, unit)
		self:Message("stages", "cyan", CL.soon:format(CL.intermission), false) -- Intermission soon
		self:PlaySound("stages", "info")
	end
end

function mod:AmirdrassilBurns(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

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

-- Stage One: The Dream Render
function mod:Firestorm(args)
	self:StopBar(CL.count:format(args.spellName, firestormCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, firestormCount))
	self:PlaySound(args.spellId, "alert")
	-- personal private aura sound on _applied
	firestormCount = firestormCount + 1
	self:Bar(args.spellId, self:Mythic() and 61.5 or 53.5, CL.count:format(args.spellName, firestormCount))
end

function mod:Wildfire(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, wildfireCount))
	self:PlaySound(args.spellId, "alarm")
	wildfireCount = wildfireCount + 1

	local cd = self:Mythic() and 61.5 or 53.5
	if wildfireCount == 2 then -- shorter cd
		cd = self:Mythic() and 38.0 or 24.0
	end
	self:Bar(args.spellId, cd, CL.count:format(args.spellName, wildfireCount))
end

function mod:DreamRend(args)
	self:StopBar(CL.count:format(args.spellName, dreamRendCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, dreamRendCount))
	self:PlaySound(args.spellId, "warning")
	dreamRendCount = dreamRendCount + 1
	self:Bar(args.spellId, self:Mythic() and 61.5 or 53.5, CL.count:format(args.spellName, dreamRendCount))
end

function mod:Blaze()
	if timerHandles[414186] then
		self:CancelTimer(timerHandles[414186])
		timerHandles[414186] = nil
	end
	local spellName = self:SpellName(414186)
	self:StopBar(CL.count:format(spellName, blazeCount))
	self:Message(414186, "yellow", CL.count:format(spellName, blazeCount))
	self:PlaySound(414186, "alert")
	-- personal sound warning from private aura on _applied
	blazeCount = blazeCount + 1
	local cd
	local stage = self:GetStage()
	if stage == 1 then
		if self:Mythic() then
			cd = blazeCount % 2 == 0 and 27 or 34.5
		else
			cd = blazeCount % 2 == 0 and 24 or 29.5
		end
	elseif stage == 1.5 then
		if blazeCount == 2 then
			cd = 8
		end
	elseif stage == 2 then
		cd = timers[414186][blazeCount]
	else -- Stage 3
		if self:Mythic() then
			cd = blazeCount % 2 == 0 and 13.0 or 33.0
		else
			cd = blazeCount % 2 == 0 and 13.0 or 28.0
		end
	end
	self:Bar(414186, cd, CL.count:format(spellName, blazeCount))
	if cd and cd > 0 then
		timerHandles[414186] = self:ScheduleTimer("Blaze", cd)
	end
end

do
	local prev = 0
	function mod:AflameApplied(args)
		local amount = args.amount or 1
		if amount == 1 and args.time - prev > 2 then
			prev = args.time
			self:StopBar(CL.count:format(args.spellName, aflameCount))
			aflameCount = aflameCount + 1
			self:Bar(args.spellId, self:GetStage() < 2 and (self:Easy() and 12.0 or 8.0) or timers[args.spellId][aflameCount], CL.count:format(args.spellName, aflameCount))
		end
		if self:Me(args.destGUID) and amount % 5 == 1 then
			self:StackMessage(args.spellId, "blue", args.destName, amount, 1)
			if amount == 1 then -- Only for initial
				self:PlaySound(args.spellId, "alarm")
			end
		end
	end
end

function mod:AflameRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:FyralathsBite(args)
	self:StopBar(CL.count:format(L.fyralaths_bite, fyralathsBiteCount))
	self:StopBar(CL.count:format(L.fyralaths_bite_mythic, fyralathsBiteCount)) -- Stage 1 Mythic
	local spellName = (self:Mythic() and self:GetStage() == 1) and L.fyralaths_bite_mythic or L.fyralaths_bite
	self:Message(args.spellId, "purple", CL.casting:format(CL.count:format(spellName, fyralathsBiteCount)))
	self:PlaySound(args.spellId, "alert") -- frontal
	fyralathsBiteCount = fyralathsBiteCount + 1
	local cd
	if self:GetStage() == 1 then
		cd = fyralathsBiteCount % 3 == 1 and (self:Mythic() and 31.5 or 23.6) or 15
	else
		cd = timers[args.spellId][fyralathsBiteCount]
	end
	self:Bar(args.spellId, cd, CL.count:format(spellName, fyralathsBiteCount))
end

function mod:FyralathsMarkApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, "purple", args.destName, amount, 2, CL.mark)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm")
	elseif amount > 1 then -- Tank Swap?
		self:PlaySound(args.spellId, "warning")
	else
		self:PlaySound(args.spellId, "info")
	end
end

-- Mythic
do
	local prev = 0
	function mod:DarkflameShades(args)
		if args.time - prev > 5 then
			prev = args.time
			self:StopBar(CL.count:format(L.darkflame_shades, darkflameShadesCount))
			self:Message(args.spellId, "cyan", CL.count:format(L.darkflame_shades, darkflameShadesCount))
			self:PlaySound(args.spellId, "info") -- adds?
			darkflameShadesCount = darkflameShadesCount + 1
			self:Bar(args.spellId, darkflameShadesCount % 3 == 1 and 31.5 or 15, CL.count:format(L.darkflame_shades, darkflameShadesCount))
		end
	end
end

function mod:DarkflameCleave(args)
	self:StopBar(CL.count:format(L.darkflame_cleave, darkflameCleaveCount))
	self:Message(args.spellId, "orange", CL.count:format(L.darkflame_cleave, darkflameCleaveCount))
	self:PlaySound(args.spellId, "alert") -- soak
	darkflameCleaveCount = darkflameCleaveCount + 1
	self:Bar(args.spellId, 61.5, CL.count:format(L.darkflame_cleave, darkflameCleaveCount))
	self:CastBar(args.spellId, 4, L.darkflame_cleave)
end

-- Intermission: Amirdrassil in Peril
function mod:Incarnate(args)
	self:StopBar(CL.count:format(L.incarnate, incarnateCount))
	self:Message(args.spellId, "red", CL.casting:format(L.incarnate))
	self:PlaySound(args.spellId, "warning")

	if self:GetStage() == 1 then -- Intermission start
		self:StopBar(CL.count:format(self:SpellName(420422), wildfireCount)) -- Wildfire
		self:StopBar(CL.count:format(L.fyralaths_bite, fyralathsBiteCount)) -- Fyr'alath's Bite
		self:StopBar(CL.count:format(L.fyralaths_bite_mythic, fyralathsBiteCount)) -- Fyr'alath's Bite
		self:StopBar(CL.count:format(self:SpellName(419506), firestormCount)) -- Firestorm
		self:StopBar(CL.count:format(self:SpellName(417455), dreamRendCount)) -- Dream Rend
		self:StopBar(CL.count:format(self:SpellName(417807), aflameCount)) -- Aflame
		self:StopBar(CL.count:format(L.darkflame_shades, darkflameShadesCount)) -- Darkflame Shades
		self:StopBar(CL.count:format(L.darkflame_cleave, darkflameCleaveCount)) -- Darkflame Cleave
		self:StopBar(CL.count:format(self:SpellName(414186), blazeCount)) -- Blaze
		if timerHandles[414187] then -- Blaze
			self:CancelTimer(timerHandles[414187])
			timerHandles[414187] = nil
		end
		self:UnregisterUnitEvent("UNIT_HEALTH", "boss1")

		self:SetStage(1.5) -- Intermission start
		self:Bar(412761, 9.2, L.incarnate_intermission) -- Incarnate
		self:Bar(419144, 13) -- Corrupt
		if self:Mythic() then
			blazeCount = 1
			local cd = 28
			self:Bar(414186, cd, CL.count:format(self:SpellName(414186), blazeCount)) -- Blaze
			timerHandles[414186] = self:ScheduleTimer("Blaze", cd)
		end

	else -- Stage 2 Incarnates
		incarnateCount = incarnateCount + 1
		self:Bar(args.spellId, timers[args.spellId][incarnateCount], CL.count:format(L.incarnate, incarnateCount)) -- Incarnate
	end
end

function mod:Corrupt(args)
	self:StopBar(args.spellName)
	self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, 33)
	shadowflameOrbsCount = 1
	local cd = 3.5 -- First Shadowflame Orbs
	self:Bar(421937, cd, CL.count:format(CL.orbs, shadowflameOrbsCount)) -- Shadowflame Orbs
	self:ScheduleTimer("ShadowflameOrbs", cd)
end

function mod:CorruptApplied(args)
	corruptApplied = args.time
end

function mod:ShadowflameOrbs()
	self:StopBar(CL.count:format(CL.orbs, shadowflameOrbsCount))
	if self:Mythic() and myOrb then
		self:Message(421937, "cyan", CL.other:format(CL.count:format(CL.orbs, shadowflameOrbsCount), myOrb))
	else
		self:Message(421937, "cyan", CL.count:format(CL.orbs, shadowflameOrbsCount))
	end
	self:PlaySound(421937, "info")
	shadowflameOrbsCount = shadowflameOrbsCount + 1
	if shadowflameOrbsCount < 4 then
		local cd = 6
		self:Bar(421937, cd, CL.count:format(CL.orbs, shadowflameOrbsCount))
		timerHandles[421937] = self:ScheduleTimer("ShadowflameOrbs", cd)
	end
end

do
	local stacks = 0
	local pName = nil
	local function ShadowflameEruptionMessage()
		mod:StackMessage(429866, "blue", pName, stacks, 1)
		mod:PlaySound(429866, "warning", nil, pName) -- big dot
		pName = nil
	end
	function mod:ShadowflameEruptionApplied(args)
		if self:Me(args.destGUID) then
			stacks = args.amount or 1
			if not pName then -- Re-use as throttle
				pName = args.destName
				self:SimpleTimer(ShadowflameEruptionMessage, 1)
			end
		end
	end
end

function mod:ShadowboundApplied(args)
	if self:Me(args.destGUID) then
		if args.amount then
			self:StackMessage(args.spellId, "blue", args.destName, args.amount, 100, L.shadow_orb) -- Never emphasize stacks
		else
			myOrb = L.orb_message_shadow
			self:PersonalMessage(args.spellId, "you", L.shadow_orb)
		end
		self:PlaySound(args.spellId, "alarm", nil, args.destName)
	end
end

function mod:FlameboundApplied(args)
	if self:Me(args.destGUID) then
		if args.amount then
			self:StackMessage(args.spellId, "blue", args.destName, args.amount, 100, L.flame_orb) -- Never emphasize stacks
		else
			myOrb = L.orb_message_flame
			self:PersonalMessage(args.spellId, "you", L.flame_orb)
		end
		self:PlaySound(args.spellId, "alarm", nil, args.destName)
	end
end

-- Stage Two: Children of the Stars
function mod:CorruptRemoved(args)
	self:StopBar(CL.cast:format(args.spellName)) -- Corrupt Castbar
	self:StopBar(CL.count:format(self:SpellName(414186), blazeCount)) -- Blaze
	if timerHandles[414186] then -- Blaze
		self:CancelTimer(timerHandles[414186])
		timerHandles[414186] = nil
	end
	self:StopBar(CL.count:format(CL.orbs, shadowflameOrbsCount)) -- Shadowflame Orbs
	if timerHandles[421937] then -- Shadowflame Orbs
		self:CancelTimer(timerHandles[421937])
		timerHandles[421937] = nil
	end

	self:Message(419144, "cyan", CL.removed_after:format(args.spellName, args.time - corruptApplied))
	self:Message("stages", "green", CL.stage:format(2), false)
	self:PlaySound("stages", "long")

	self:SetStage(2)
	firestormCount = 1
	flamefallCount = 1
	shadowflameDevastationCount = 1
	fyralathsBiteCount = 1
	spiritsCount = 1
	blazeCount = 1
	incarnateCount = 1
	aflameCount = 1
	addCount = 0

	self:Bar(422518, timers[422518][firestormCount], CL.count:format(L.greater_firestorm_shortened_bar, firestormCount)) -- Greater Firestorm
	self:Bar(419123, timers[419123][flamefallCount], CL.count:format(self:SpellName(419123), flamefallCount)) -- Flamefall
	self:Bar(422524, timers[422524][shadowflameDevastationCount], CL.count:format(CL.breath, shadowflameDevastationCount)) -- Shadowflame Devastation
	self:Bar(417431, timers[417431][fyralathsBiteCount], CL.count:format(L.fyralaths_bite, fyralathsBiteCount)) -- Fyr'alath's Bite
	self:Bar(422032, timers[422032][spiritsCount], CL.count:format(CL.spirits, spiritsCount)) -- Spirits of Kaldorei
	self:Bar(412761, timers[412761][incarnateCount], CL.count:format(L.incarnate, incarnateCount)) -- Incarnate
	self:Bar(417807, timers[417807][aflameCount], CL.count:format(self:SpellName(417807), aflameCount))
	if not self:Easy() then
		local cd = timers[414186][blazeCount]
		self:Bar(414186, cd, CL.count:format(self:SpellName(414186), blazeCount))
		timerHandles[414186] = self:ScheduleTimer("Blaze", cd) -- Trigger Next
	end
	self:Bar("stages", 216, CL.stage:format(3), 408330) -- Axel icon
end

function mod:CHAT_MSG_MONSTER_YELL(_, _, sender)
	if sender == L.spirits_trigger then
		self:StopBar(CL.count:format(CL.spirits, spiritsCount))
		self:Message(422032, "green", CL.count:format(CL.spirits, spiritsCount))
		if self:Healer() then
			self:PlaySound(422032, "alert")
		end
		spiritsCount = spiritsCount + 1
		local cd = timers[422032][spiritsCount]
		if self:Mythic() and spiritsCount == 6 then -- all trees (no spirit yell), need to schedule
			timerHandles[422032] = self:ScheduleTimer("CHAT_MSG_MONSTER_YELL", cd, nil, nil, L.spirits_trigger)
		end
		self:Bar(422032, cd, CL.count:format(CL.spirits, spiritsCount))
	end
end

function mod:SpiritsOfTheKaldorei(args)
	if not self.seeSpirits then
		self.seeSpirits = true
		self:Error("ID is now enabled.")
	end
end

function mod:GreaterFirestorm(args)
	self:StopBar(CL.count:format(L.greater_firestorm_shortened_bar, firestormCount))
	self:Message(args.spellId, "orange", CL.count:format(L.greater_firestorm_message_full, firestormCount))
	self:PlaySound(args.spellId, "alert")
	-- tanks get a private aura
	firestormCount = firestormCount + 1
	self:Bar(args.spellId, timers[args.spellId][firestormCount], CL.count:format(L.greater_firestorm_shortened_bar, firestormCount))

	addCount = 0
	self:Bar(428963, 15, L.molten_gauntlet) -- Molten Gauntlet
	self:Bar(428400, self:Mythic() and 53.8 or 68.3) -- Exploding Core
	if self:Mythic() then
		-- This keeps a consistent count for the cage timers, always 1-2 / 3-4
		shadowCageCount = (firestormCount - 1) * 2 - 1
		local cd = 15
		self:Bar(428970, cd, CL.count:format(L.mythic_debuffs, shadowCageCount))
		timerHandles[428970] = self:ScheduleTimer("ShadowCage", cd)
	end
end

do
	local prev = 0
	function mod:Gauntlet(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Message(428963, "purple", L.molten_gauntlet)
			if self:Tank() then
				self:PlaySound(428963, "alert")
			end
			self:Bar(428963, 12.2, L.molten_gauntlet)
		end
	end
end

function mod:ShadowCage()
	self:Message(428970, "yellow", CL.count:format(L.mythic_debuffs, shadowCageCount))
	self:PlaySound(428970, "info")
	shadowCageCount = shadowCageCount + 1
	if shadowCageCount % 2 == 0 then -- 2 per
		local cd = 23
		self:Bar(428970, cd, CL.count:format(L.mythic_debuffs, shadowCageCount))
		timerHandles[428970] = self:ScheduleTimer("ShadowCage", cd)
	else
		timerHandles[428970] = nil
	end
end

do
	local prev = 0
	function mod:ExplodingCore(args)
		if args.time - prev > 3 then
			prev = args.time
			self:Message(args.spellId, "red")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:ColossusDeath(args)
	addCount = addCount + 1
	if addCount == 2 then
		self:StopBar(L.molten_gauntlet) -- Gauntlet
		self:StopBar(428400) -- Exploding Core
	end

	if self:Mythic() and args.mobId == 207796 then -- Burning Colosus
		self:StopBar(CL.count:format(L.mythic_debuffs, shadowCageCount)) -- Shadow Cage
		if timerHandles[428970] then
			self:CancelTimer(timerHandles[428970])
			timerHandles[428970] = nil
		end
	end
end

function mod:Flamefall(args)
	self:StopBar(CL.count:format(args.spellName, flamefallCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, flamefallCount))
	self:PlaySound(args.spellId, "alarm")
	flamefallCount = flamefallCount + 1
	self:Bar(args.spellId, timers[args.spellId][flamefallCount], CL.count:format(args.spellName, flamefallCount))
end

function mod:ShadowflameDevastation(args)
	self:StopBar(CL.count:format(CL.breath, shadowflameDevastationCount))
	self:Message(args.spellId, "red", CL.count:format(CL.breath, shadowflameDevastationCount))
	self:PlaySound(args.spellId, "long")
	shadowflameDevastationCount = shadowflameDevastationCount + 1
	self:Bar(args.spellId, timers[args.spellId][shadowflameDevastationCount], CL.count:format(CL.breath, shadowflameDevastationCount))
end

-- Stage Three: Shadowflame Incarnate
function mod:EternalFirestormP3()
	-- Would like an encounter event for earlier
	self:StopBar(CL.stage:format(3)) -- Stage 3
	self:StopBar(CL.count:format(self:SpellName(419123), flamefallCount)) -- Flamefall
	self:StopBar(CL.count:format(CL.breath, shadowflameDevastationCount)) -- Shadowflame Devastation
	self:StopBar(CL.count:format(L.fyralaths_bite, fyralathsBiteCount)) -- Fyr'alath's Bite
	self:StopBar(CL.count:format(L.fyralaths_bite_mythic, fyralathsBiteCount)) -- Fyr'alath's Bite
	self:StopBar(CL.count:format(CL.spirits, spiritsCount)) -- Spirits of the Kaldorei
	if timerHandles[422032] then
		self:CancelTimer(timerHandles[422032])
		timerHandles[422032] = nil
	end
	self:StopBar(CL.count:format(self:SpellName(417807), aflameCount)) -- Aflame
	self:StopBar(CL.count:format(L.incarnate, incarnateCount)) -- Incarnate
	self:StopBar(CL.count:format(L.greater_firestorm_shortened_bar, firestormCount)) -- Greater Firestorm
	self:StopBar(CL.count:format(self:SpellName(414186), blazeCount)) -- Blaze
	if timerHandles[414186] then
		self:CancelTimer(timerHandles[414186])
		timerHandles[414186] = nil
	end

	self:SetStage(3)
	self:Message("stages", "cyan", CL.stage:format(3), false)
	self:PlaySound("stages", "long")

	blazeCount = 1
	aflameCount = 1

	infernalMawCount = 1
	shadowflameBreathCount = 1
	apocalypseRoarCount = 1
	firestormCount = 1
	eternalFirestormSwirlCount = 1

	self:Bar(425492, 5.0, CL.count:format(self:SpellName(425492), infernalMawCount)) -- Infernal Maw
	self:Bar(423601, 6.5) -- Seed of Amirdrassil
	self:Bar(410223, 10.0, CL.count:format(CL.breath, shadowflameBreathCount)) -- Shadowflame Breath
	self:Bar(422837, 34.0, CL.count:format(CL.roar, apocalypseRoarCount)) -- Apocalypse Roar
	local firestormCD = 18.0
	self:Bar(422935, firestormCD, CL.count:format(L.eternal_firestorm_shortened_bar, firestormCount)) -- Eternal Firestorm
	self:ScheduleTimer("EternalFirestorm", firestormCD)
	if not self:Easy() then
		local blazeCD = 12.0
		self:Bar(414186, blazeCD, CL.count:format(self:SpellName(414186), blazeCount)) -- Blaze
		timerHandles[414186] = self:ScheduleTimer("Blaze", blazeCD)
	end
	if self:Mythic() then -- Unsure about other difficulty timers
		self:Bar("eternal_firestorm_swirl", 4, CL.count:format(CL.pools, eternalFirestormSwirlCount), 402736)
		self:ScheduleTimer("EternalFirestormSwirlTimer", 4) -- Trigger Next
	end
end

function mod:EternalFirestorm()
	self:StopBar(CL.count:format(L.eternal_firestorm_shortened_bar, firestormCount))
	self:Message(422935, "orange", CL.count:format(L.eternal_firestorm_message_full, firestormCount))
	self:PlaySound(422935, "alert")
	-- personal sound warning from private aura
	firestormCount = firestormCount + 1
	local cd = self:Mythic() and 46 or self:LFR() and 41.2 or 41 -- LFR is a bit longer and there's no enrage.. don't drift pls
	self:Bar(422935, cd, CL.count:format(L.eternal_firestorm_shortened_bar, firestormCount))
	self:ScheduleTimer("EternalFirestorm", cd)
end

function mod:BloomApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(CL.absorb))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:EternalFirestormSwirlTimer()
	self:StopBar(CL.count:format(CL.pools, eternalFirestormSwirlCount))
	-- No Messages or Sounds, just bars.
	--self:Message("eternal_firestorm_swirl", "yellow", CL.count:format(CL.pools, eternalFirestormSwirlCount), 402736)
	--self:PlaySound("eternal_firestorm_swirl", "alert")
	eternalFirestormSwirlCount = eternalFirestormSwirlCount + 1
	local cdTable = {3.8, 6.2, 11.1, 11.5, 11.5, 5.1, 6.3, 12, 11.1, 11.7, 5, 6.5, 12.1, 11.0, 11.6, 5.0,  6.5, 11.8, 10.5, 11.8, 5, 6.5, 11.1, 10.5, 10.5}
	local cd = cdTable[eternalFirestormSwirlCount]
	if cd and cd > 0 then
		self:Bar("eternal_firestorm_swirl", cd, CL.count:format(CL.pools, eternalFirestormSwirlCount), 402736)
		self:ScheduleTimer("EternalFirestormSwirlTimer", cd)
	end
end

function mod:ApocalypseRoar(args)
	self:StopBar(CL.count:format(CL.roar, apocalypseRoarCount))
	self:Message(args.spellId, "red", CL.count:format(CL.roar, apocalypseRoarCount))
	self:PlaySound(args.spellId, "long")
	apocalypseRoarCount = apocalypseRoarCount + 1
	self:Bar(args.spellId, self:Mythic() and 46 or 41, CL.count:format(CL.roar, apocalypseRoarCount))
	if self:Mythic() then
		self:Bar(430048, 18, CL.count:format(self:SpellName(430048), apocalypseRoarCount - 1)) -- Corrupted Seed
	end
end

function mod:ShadowflameBreath(args)
	self:StopBar(CL.count:format(CL.breath, shadowflameBreathCount))
	self:Message(args.spellId, "yellow", CL.count:format(CL.breath, shadowflameBreathCount))
	self:PlaySound(args.spellId, "alert")
	shadowflameBreathCount = shadowflameBreathCount + 1
	self:Bar(args.spellId, self:Mythic() and 46 or 41, CL.count:format(CL.breath, shadowflameBreathCount))
end

function mod:InfernalMaw(args)
	self:StopBar(CL.count:format(args.spellName, infernalMawCount))
	self:Message(args.spellId, "purple", CL.casting:format(CL.count:format(args.spellName, infernalMawCount)))
	self:PlaySound(args.spellId, "alert")
	infernalMawCount = infernalMawCount + 1
	local cd = infernalMawCount % 2 == 0 and 3 or infernalMawCount % 4 == 1 and (self:Mythic() and 30 or 25) or	10
	self:Bar(args.spellId, cd, CL.count:format(args.spellName, infernalMawCount))
end

function mod:InfernalMawApplied(args)
	local amount = args.amount or 1
	if amount % 4 == 0 then
		self:StackMessage(425492, "purple", args.destName, amount, 4)
		if self:Me(args.destGUID) then
			self:PlaySound(425492, "alarm") -- On you
		elseif self:Tank() then
			self:PlaySound(425492, "warning") -- tauntswap
		end
	end
end

do
	local prev = 0
	function mod:BlazingSeedDamage(args)
		if args.time - prev > 5 then
			prev = args.time
			self:Message(args.spellId, "red")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end
