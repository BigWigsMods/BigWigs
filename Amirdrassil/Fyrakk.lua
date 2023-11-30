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
-- Locals
--

local fyralathsBiteCount = 1
local blazeCount = 1

local firestormCount = 1
local wildfireCount = 1
local dreamRendCount = 1
local darkflameShadesCount = 1
local darkflameCleaveCount = 1

local orbCount = 1

local spiritCount = 1
local incarnateCount = 1
local shadowflameDevastationCount = 1
local flamefallCount = 1
local addCount = 0

local swirlCount = 1
local shadowflameBreathCount = 1
local apocalypseRoarCount = 1
local infernalMawCount = 1

local timerHandles = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.spirit_trigger = "Spirit of the Kaldorei" -- [CHAT_MSG_MONSTER_YELL] Amirdrassil must not fall.#Spirit of the Kaldorei

	L.fyralaths_bite = "Frontal"
	L.fyralaths_bite_mythic = "Frontals"
	L.fyralaths_mark = "Mark"
	L.darkflame_shades = "Shades"
	L.darkflame_cleave = "Mythic Soaks"
	L.incarnate_intermission = "Knock Up"
	L.incarnate = "Fly Away"
	L.spirits_of_the_kaldorei = "Spirits"
	L.molten_gauntlet = "Gauntlet"
	L.greater_firestorm_shortened_bar = "Firestorm [G]" -- G for Greater
	L.greater_firestorm_message_full = "Firestorm [Greater]"
	L.eternal_firestorm_shortened_bar = "Firestorm [E]" -- E for Eternal
	L.eternal_firestorm_message_full = "Firestorm [Eternal]"
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
		430441, -- Darkflame Shades
		{426368, "CASTBAR", "PRIVATE"}, -- Darkflame Cleave

		-- Intermission: Amirdrassil in Peril
		419144, -- Corrupt
		421937, -- Shadowflame Orbs
		429866, -- Shadowflame Eruption

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
		{428968, "PRIVATE"}, -- Shadow Cage

		-- Stage Three: Shadowflame Incarnate
		{422935, "PRIVATE"}, -- Eternal Firestorm
		422837, -- Apocalypse Roar
		410223, -- Shadowflame Breath
		{425492, "TANK"}, -- Infernal Maw
		-- Seed
		423601, -- Seed of Amirdrassil
		423717, -- Bloom
		423598, -- Blazing Seed (Damage)
		430048, -- Corrupted Seed
	},{
		["stages"] = "general",
		[419506] = -26666, -- Stage One: The Dream Render
		[430441] = "mythic",
		[419144] = -26667, -- Intermission: Amirdrassil in Peril
		[422032] = -26668, -- Stage Two: Children of the Stars
		[428971] = "mythic",
		[422935] = -26670, -- Stage Three: Shadowflame Incarnate
		[423601] = 423601, -- Seed
		[430048] = "mythic",
	},{
		[417431] = L.fyralaths_bite, -- Fyr'alath's Bite (Frontal)
		[417443] = L.fyralaths_mark, -- Fyr'alath's Mark (Mark)
		[430441] = L.darkflame_shades, -- Darkflame Shades (Shades)
		[426368] = L.darkflame_cleave, -- Darkflame Cleave (Mythic Soaks)
		[421937] = CL.orbs, -- Shadowflame Orbs (Orbs)
		[422032] = L.spirits_of_the_kaldorei, -- Spirits of the Kaldorei (Spirits)
		[422518] = L.greater_firestorm_shortened_bar, -- Greater Firestorm (Firestorm [G])
		[412761] = L.incarnate, -- Incarnate (Fly Away)
		[422524] = CL.breath, -- Shadowflame Devastation (Deep Breath)
		[423717] = CL.absorb, -- Bloom (Absorb)
		[422935] = L.eternal_firestorm_shortened_bar, -- Eternal Firestorm (Firestorm [E])
		[410223] = CL.breath, -- Shadowflame Breath (Breath)
		[422837] = CL.roar, -- Apocalypse Roar (Roar)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1") -- Incarnate
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL") -- P2 Spirit of the Kaldorei
	self:RegisterMessage("BigWigs_EncounterEnd") -- stop simulated bars immediately on wipe

	self:Log("SPELL_AURA_APPLIED", "AmirdrassilBurns", 429872)
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 419504, 425483) -- Raging Flames, Incinerated
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 419504, 425483, 410223) -- Shadowflame Breath (not in _APPLIED)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 419504, 425483, 410223)

	self:Log("SPELL_CAST_SUCCESS", "Blaze", 414186)
	self:Log("SPELL_AURA_APPLIED", "AflameApplied", 417807)
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
	self:Log("SPELL_AURA_APPLIED", "ShadowflameEruptionApplied", 429866)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShadowflameEruptionApplied", 429866)
	self:Log("SPELL_AURA_APPLIED", "CorruptApplied", 421922)
	self:Log("SPELL_AURA_REMOVED", "CorruptRemoved", 421922)

	-- Stage Two: Children of the Stars
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
	self:SetStage(1)
	blazeCount = 1
	fyralathsBiteCount = 1

	firestormCount = 1
	wildfireCount = 1
	dreamRendCount = 1
	darkflameShadesCount = 1
	darkflameCleaveCount = 1
	timerHandles = {}

	self:Bar(420422, 4, CL.count:format(self:SpellName(420422), wildfireCount)) -- Wildfire
	self:Bar(417431, 9, CL.count:format(self:Mythic() and L.fyralaths_bite_mythic or L.fyralaths_bite, fyralathsBiteCount)) -- Fyr'alath's Bite
	self:Bar(419506, self:Mythic() and 12 or 13, CL.count:format(self:SpellName(419506), firestormCount)) -- Firestorm
	self:Bar(417455, self:Mythic() and 48 or 42, CL.count:format(self:SpellName(417455), dreamRendCount)) -- Dream Rend
	if not self:Easy() then
		self:Bar(414186, self:Mythic() and 36 or 32, CL.count:format(self:SpellName(414186), blazeCount)) -- Blaze
		timerHandles[414186] = self:ScheduleTimer("Blaze", self:Mythic() and 36 or 32)
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
		self:SetPrivateAuraSound(428968, 428970) -- Shadow Cage
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
	-- self:PlaySound(args.spellId, "alert") -- private aura sound
	firestormCount = firestormCount + 1
	self:Bar(args.spellId, self:Mythic() and 61.5 or 53.5, CL.count:format(args.spellName, firestormCount))
end

function mod:Wildfire(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, wildfireCount))
	self:PlaySound(args.spellId, "alarm")
	wildfireCount = wildfireCount + 1

	local cd
	if self:Mythic() then
		cd = wildfireCount == 2 and 38 or 61.5
	else
		cd = wildfireCount == 2 and 24 or 53.5
	end
	self:Bar(args.spellId, cd, CL.count:format(args.spellName, wildfireCount))
end

function mod:DreamRend(args)
	self:StopBar(CL.count:format(args.spellName, dreamRendCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, dreamRendCount))
	self:PlaySound(args.spellId, "warning")
	dreamRendCount = dreamRendCount + 1
	self:Bar(args.spellId, self:Mythic() and 61.5 or 53.6, CL.count:format(args.spellName, dreamRendCount))
end

function mod:Blaze()
	local spellName = self:SpellName(414186)
	self:StopBar(CL.count:format(spellName, blazeCount))
	self:Message(414186, "yellow", CL.count:format(spellName, blazeCount))
	-- sound warning from private aura
	blazeCount = blazeCount + 1

	local cd
	local stage = self:GetStage()
	if stage == 1 then
		if self:Mythic() then
			cd = blazeCount % 2 == 0 and 27 or 34.5
		else
			cd = blazeCount % 2 == 0 and 24 or 29.5
		end
	elseif stage == 1.5 then -- Mythic
		local timer = { 16.1, 12.0, 8.0 }
		cd = timer[blazeCount]
	elseif stage == 2 then
		local timer = { 20.6, 15.0, 25.0, 30.0, 27.0, 23.0, 30.0, 25.0 }
		cd = timer[blazeCount]
	elseif stage == 3 then
		if self:Mythic() then
			cd = blazeCount % 2 == 0 and 13 or 33
		else
			cd = 41
		end
	end
	if cd then
		self:Bar(414186, cd, CL.count:format(spellName, blazeCount))
		timerHandles[414186] = self:ScheduleTimer("Blaze", cd)
	end
end

function mod:AflameApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount == 1 then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "alarm")
		elseif amount % 5 == 1 then
			self:Message(args.spellId, "blue", CL.stackyou:format(amount, args.spellName))
			self:PlaySound(args.spellId, "alarm")
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
	local spellName = (self:Mythic() and self:GetStage() == 1) and L.fyralaths_bite_mythic or L.fyralaths_bite
	self:Message(args.spellId, "purple", spellName)
	self:PlaySound(args.spellId, "alert") -- frontal
	fyralathsBiteCount = fyralathsBiteCount + 1
	if self:GetStage() == 1 then
		self:Bar(args.spellId, fyralathsBiteCount % 3 == 1 and (self:Mythic() and 31.5 or 23.6) or 15, spellName)
	elseif fyralathsBiteCount % 3 ~= 0 then
		self:Bar(args.spellId, 11, spellName)
	end
end

function mod:FyralathsMarkApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, "purple", args.destName, amount, 2, L.fyralaths_mark)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm")
	elseif amount > 1 then -- Tank Swap?
		self:PlaySound(args.spellId, "warning")
	end
end

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
	self:Message(args.spellId, "orange", CL.count:format(L.darkflame_cleave, darkflameCleaveCount))
	self:PlaySound(args.spellId, "alert") -- soak
	darkflameCleaveCount = darkflameCleaveCount + 1
	self:Bar(args.spellId, 61.5, CL.count:format(L.darkflame_cleave, darkflameCleaveCount))
	self:CastBar(args.spellId, 4, L.darkflame_cleave)
end

-- Intermission: Amirdrassil in Peril

function mod:IncarnateIntermission()
	self:StopBar(CL.count:format(self:SpellName(414186), blazeCount)) -- Blaze
	self:CancelTimer(timerHandles[414186])
	self:StopBar(CL.count:format(self:SpellName(420422), wildfireCount)) -- Wildfire
	self:StopBar(CL.count:format(L.fyralaths_bite, fyralathsBiteCount)) -- Fyr'alath's Bite
	self:StopBar(CL.count:format(L.fyralaths_bite_mythic, fyralathsBiteCount))
	self:StopBar(CL.count:format(self:SpellName(419506), firestormCount)) -- Firestorm
	self:StopBar(CL.count:format(self:SpellName(417455), dreamRendCount)) -- Dream Rend
	self:StopBar(CL.count:format(L.darkflame_shades, darkflameShadesCount)) -- Darkflame Shades
	self:StopBar(CL.count:format(L.darkflame_cleave, darkflameCleaveCount)) -- Darkflame Cleave
	self:UnregisterUnitEvent("UNIT_HEALTH", "boss1")

	self:Message("stages", "cyan", CL.intermission, false)
	self:PlaySound("stages", "long")

	blazeCount = 1
	orbCount = 1

	self:Bar(412761, 9.2, L.incarnate_intermission) -- Incarnate
	self:Bar(419144, 13) -- Corrupt
	self:Bar(421937, 16, CL.count:format(CL.orbs, orbCount)) -- Shadowflame Orbs
	timerHandles[421937] = self:ScheduleTimer("ShadowflameOrbs", 16)
	if self:Mythic() then
		self:Bar(414186, 16.1, CL.count:format(self:SpellName(414186), blazeCount)) -- Blaze
		timerHandles[414186] = self:ScheduleTimer("Blaze", 16.1)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 421830 then -- Incarnate
		local stage = self:GetStage()
		if stage == 1 then
			-- skip this one, cast after the CLEU Incarnate
			self:SetStage(1.5)
		elseif stage == 1.5 then
			self:StopBar(CL.count:format(self:SpellName(414186), blazeCount)) -- Blaze
			self:CancelTimer(timerHandles[414186])
			self:StopBar(CL.count:format(CL.orbs, orbCount)) -- Shadowflame Orbs
			self:CancelTimer(timerHandles[421937])

			self:SetStage(2)
			self:Message("stages", "cyan", CL.stage:format(2), false)
			self:PlaySound("stages", "long")

			fyralathsBiteCount = 1
			blazeCount = 1
			firestormCount = 1

			spiritCount = 1
			incarnateCount = 1
			shadowflameDevastationCount = 1
			flamefallCount = 1

			-- corrupt removed - 4.7~5
			-- self:Bar(419123, 1.7, CL.count:format(self:SpellName(419123), flamefallCount)) -- Flamefall
			self:Bar(417431, 14.2, CL.count:format(L.fyralaths_bite, fyralathsBiteCount)) -- Fyr'alath's Bite
			self:Bar(422518, 31.2, CL.count:format(L.greater_firestorm_shortened_bar, firestormCount)) -- Greater Firestorm
			self:Bar(412761, 39.8, CL.count:format(L.incarnate, incarnateCount)) -- Incarnate
			if not self:Easy() then
				self:Bar(414186, 15.9, CL.count:format(self:SpellName(414186), blazeCount)) -- Blaze
				timerHandles[414186] = self:ScheduleTimer("Blaze", 15.9)
			end
			self:Bar("stages", 211.3, CL.stage:format(3), 422935) -- Stage 2 (Eternal Firestorm)
		end
	end
end

function mod:Corrupt(args)
	self:StopBar(args.spellName)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "warning")
end

do
	local appliedTime = 0
	function mod:CorruptApplied(args)
		appliedTime = args.time
	end
	function mod:CorruptRemoved(args)
		if args.amount == 0 then
			self:Message(419144, "green", CL.removed_after:format(args.spellName, args.time - appliedTime))
			self:PlaySound(419144, "info")

			self:Bar(419123, 5.7, CL.count:format(self:SpellName(419123), 1)) -- Flamefall
		end
	end
end

function mod:ShadowflameOrbs()
	self:Message(421937, "cyan", CL.count:format(CL.orbs, orbCount))
	self:PlaySound(421937, "info")
	orbCount = orbCount + 1
	if orbCount < 4 then
		self:Bar(421937, 6, CL.count:format(CL.orbs, orbCount))
		timerHandles[421937] = self:ScheduleTimer("ShadowflameOrbs", 6)
	end
end

do
	local stacks = 0
	local scheduled = nil
	function mod:ShadowflameEruptionMessage()
		self:Message(429866, "red", CL.stackyou:format(stacks, self:SpellName(429866)))
		self:PlaySound(429866, "alarm")
		scheduled = nil
	end
	function mod:ShadowflameEruptionApplied(args)
		if self:Me(args.destGUID) then
			stacks = args.amount or 1
			if not scheduled then
				scheduled = self:ScheduleTimer("ShadowflameEruptionMessage", 1)
			end
		end
	end
end

-- Stage Two: Children of the Stars

function mod:Incarnate(args)
	if self:GetStage() == 1 then
		self:IncarnateIntermission()
	elseif self:GetStage() == 2 then
		self:StopBar(CL.count:format(L.incarnate, incarnateCount))
		self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(L.incarnate, incarnateCount)))
		self:PlaySound(args.spellId, "info")
		incarnateCount = incarnateCount + 1

		local timer = { 45.0, 80.0, 79.5 }
		local cd = timer[incarnateCount]
		if not cd then -- last cast is p3 transition, what to do if you push before the second cast?
			self:Bar(args.spellId, 8.2, L.incarnate_intermission) -- Incarnate
		else
			self:Bar(args.spellId, cd, CL.count:format(L.incarnate, incarnateCount))
			self:Bar(422524, 14.5, CL.count:format(CL.breath, shadowflameDevastationCount)) -- Shadowflame Devastation
			self:Bar(419123, 36.5, CL.count:format(self:SpellName(419123), flamefallCount)) -- Flamefall
			self:Bar(417431, 45.5, CL.count:format(L.fyralaths_bite, fyralathsBiteCount)) -- Fyr'alath's Bite
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg, sender)
	-- if msg == "Amirdrassil must not fall." or msg == "Our lives are sworn to Amirdrassil!" or msg == "This tree will not fall!" then
	if sender == L.spirit_trigger and self:GetStage() == 2 then
		self:StopBar(CL.count:format(L.spirits_of_the_kaldorei, spiritCount))
		self:Message(422032, "green", CL.count:format(L.spirits_of_the_kaldorei, spiritCount))
		if self:Healer() then
			self:PlaySound(422032, "alert")
		end
		spiritCount = spiritCount + 1
		local timer = { 15.5, 20.0, 25.0, 32.0, 26.0, 25.0, 25.0 }
		self:Bar(422032, timer[spiritCount], CL.count:format(L.spirits_of_the_kaldorei, spiritCount))
	end
end

function mod:GreaterFirestorm(args)
	self:StopBar(CL.count:format(L.greater_firestorm_shortened_bar, firestormCount))
	self:Message(args.spellId, "orange", CL.count:format(L.greater_firestorm_message_full, firestormCount))
	-- self:PlaySound(args.spellId, "info") -- adds?
	-- tanks get a private aura
	firestormCount = firestormCount + 1
	if firestormCount < 3 then
		self:Bar(args.spellId, 80, CL.count:format(L.greater_firestorm_shortened_bar, firestormCount))
	end

	addCount = 0

	self:Bar(428963, 15, L.molten_gauntlet) -- Molten Gauntlet
	if self:Mythic() then
		self:Bar(428968, 15) -- Shadow Cage
		timerHandles[428968] = self:ScheduleTimer("ShadowCage", 15)
	end
	self:Bar(428400, self:Mythic() and 53.8 or 68.3) -- Exploding Core
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
	self:Message(428968, "cyan")
	self:Bar(428968, 23)
	timerHandles[428968] = self:ScheduleTimer("ShadowCage", 23)
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
		self:StopBar(428968) -- Shadow Cage
		self:CancelTimer(timerHandles[428968])
		self:StopBar(428400) -- Exploding Core
	end
end

function mod:Flamefall(args)
	self:StopBar(CL.count:format(args.spellName, flamefallCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, flamefallCount))
	self:PlaySound(args.spellId, "alarm")
	flamefallCount = flamefallCount + 1
	-- local timer = { 6.5, 75.0, 80.0, 0 }
	-- self:Bar(args.spellId, timer[flamefallCount], CL.count:format(args.spellName, flamefallCount))
end

function mod:ShadowflameDevastation(args)
	self:StopBar(CL.count:format(CL.breath, shadowflameDevastationCount))
	self:Message(args.spellId, "red", CL.count:format(CL.breath, shadowflameDevastationCount))
	self:PlaySound(args.spellId, "long")
	shadowflameDevastationCount = shadowflameDevastationCount + 1
	-- if shadowflameDevastationCount < 3 then
	-- 	self:Bar(args.spellId, 80, CL.count:format(L.shadowflame_devastation, shadowflameDevastationCount))
	-- end
end

-- Stage 3

function mod:EternalFirestormP3()
	-- Would like an encounter event for earlier
	self:StopBar(CL.stage:format(3))
	self:StopBar(CL.count:format(self:SpellName(414186), blazeCount)) -- Blaze
	self:CancelTimer(timerHandles[414186])
	self:StopBar(CL.count:format(L.fyralaths_bite, fyralathsBiteCount)) -- Fyr'alath's Bite
	self:StopBar(CL.count:format(L.spirits_of_the_kaldorei, spiritCount)) -- Spirits of the Kaldorei
	self:StopBar(CL.count:format(L.incarnate, incarnateCount)) -- Incarnate
	self:StopBar(CL.count:format(L.greater_firestorm_shortened_bar, firestormCount)) -- Greater Firestorm

	self:SetStage(3)
	self:Message("stages", "cyan", CL.stage:format(3), false)
	self:PlaySound("stages", "long")

	blazeCount = 1
	firestormCount = 1

	infernalMawCount = 1
	shadowflameBreathCount = 1
	apocalypseRoarCount = 1

	-- Seeds spawn 2s after this event
	self:Bar(425492, 5, CL.count:format(self:SpellName(425492), infernalMawCount)) -- Infernal Maw
	self:Bar(423601, 6.5) -- Seed of Amirdrassil
	self:Bar(410223, 10, CL.count:format(CL.breath, shadowflameBreathCount)) -- Shadowflame Breath
	self:Bar(422935, 18.1, CL.count:format(L.eternal_firestorm_shortened_bar, firestormCount)) -- Eternal Firestorm
	self:ScheduleTimer("EternalFirestorm", 18.1)
	self:Bar(422837, 34.1, CL.count:format(CL.roar, apocalypseRoarCount)) -- Apocalypse Roar
	if not self:Easy() then
		self:Bar(414186, 12.1, CL.count:format(self:SpellName(414186), blazeCount)) -- Blaze
		timerHandles[414186] = self:ScheduleTimer("Blaze", 12.1)
	end
end

function mod:EternalFirestorm()
	self:StopBar(CL.count:format(L.eternal_firestorm_shortened_bar, firestormCount))
	self:Message(422935, "orange", CL.count:format(L.eternal_firestorm_message_full, firestormCount))
	-- sound warning from private aura
	firestormCount = firestormCount + 1
	self:Bar(422935, self:Mythic() and 46 or 41, CL.count:format(L.eternal_firestorm_shortened_bar, firestormCount))
	self:ScheduleTimer("EternalFirestorm", self:Mythic() and 46 or 41)
end

function mod:BloomApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(CL.absorb))
		-- self:TargetBar(args.spellId, 6, args.destName)
		self:PlaySound(args.spellId, "info")
	end
end

-- function mod:BloomRemoved(args)
-- 	if self:Me(args.destGUID) then
-- 		self:StopBar(args.spellName, args.destName)
-- 	end
-- end

function mod:ApocalypseRoar(args)
	self:StopBar(CL.count:format(CL.roar, apocalypseRoarCount))
	self:Message(args.spellId, "red", CL.count:format(CL.roar, apocalypseRoarCount))
	self:PlaySound(args.spellId, "long")
	apocalypseRoarCount = apocalypseRoarCount + 1
	if apocalypseRoarCount < 6 then
		self:Bar(args.spellId, self:Mythic() and 46 or 41, CL.count:format(CL.roar, apocalypseRoarCount))
		if self:Mythic() then
			self:Bar(430048, 18.5, CL.count:format(self:SpellName(430048), apocalypseRoarCount - 1)) -- Corrupted Seed
		end
	end
end

function mod:ShadowflameBreath(args)
	self:StopBar(CL.count:format(CL.breath, shadowflameBreathCount))
	self:Message(args.spellId, "red", CL.count:format(CL.breath, shadowflameBreathCount))
	self:PlaySound(args.spellId, "alert")
	shadowflameBreathCount = shadowflameBreathCount + 1
	if shadowflameBreathCount < 6 then
		self:Bar(args.spellId, self:Mythic() and 46 or 41, CL.count:format(CL.breath, shadowflameBreathCount))
	end
end

function mod:InfernalMaw(args)
	self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
	if self:Tank() then
		self:PlaySound(args.spellId, "alert")
	end
	infernalMawCount = infernalMawCount + 1
	local cd = infernalMawCount % 2 == 0 and 3 or infernalMawCount % 4 == 1 and (self:Mythic() and 30 or 25) or	10
	self:CDBar(args.spellId, cd)
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
