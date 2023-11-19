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

local wildfireCount = 1
local firestormCount = 1
local dreamRendCount = 1
local blazeCount = 1
local fyralathsBiteCount = 1

local spiritCount = 1
local incarnateCount = 1
local shadowflameDevastationCount = 1
local flamefallCount = 1

local shadowflameBreathCount = 1
local apocalypseRoarCount = 1
local infernalMawCount = 1

local blazeTimer

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.spirit_trigger = "Spirit of the Kaldorei" -- [CHAT_MSG_MONSTER_YELL] Amirdrassil must not fall.#Spirit of the Kaldorei

	L.firestorm = "Meteors"
	L.dream_rend = "Pull In"
	L.fyralaths_bite = "Tank Frontal"
	L.fyralaths_mark = "Mark"
	L.spirits_of_the_kaldorei = "Spirits"
	L.greater_firestorm = "Meteors [G]" -- G for Greater
	L.incarnate = "Fly Away"
	L.shadowflame_devastation = "Deep Breath"
	L.eternal_firestorm = "Meteors [E]" -- E for Eternal
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		-- Stage One: The Dream Render
		{419506, "PRIVATE"}, -- Firestorm
		419504, -- Raging Flames
		420422, -- Wildfire
		417455, -- Dream Rend
		425483, -- Incinerated
		{414186, "PRIVATE"}, -- Blaze
		417807, -- Aflame
		417431, -- Fyr'alath's Bite
		{417443, "TANK"}, -- Fyr'alath's Mark
		-- Intermission: Amirdrassil in Peril
		419144, -- Corrupt
		429866, -- Shadowflame Eruption
		-- Stage Two: Children of the Stars
		422032, -- Spirits of the Kaldorei
		{422518, "PRIVATE"}, -- Greater Firestorm
		412761, -- Incarnate
		422524, -- Shadowflame Devastation
		419123, -- Flamefall
		-- Stage Three: Shadowflame Incarnate
		423717, -- Bloom
		{422935, "PRIVATE"}, -- Eternal Firestorm
		422837, -- Apocalypse Roar
		410223, -- Shadowflame Breath
		{425492, "TANK"}, -- Infernal Maw
	},{
		["stages"] = "general",
		[419506] = -26666, -- Stage One: The Dream Render
		[419144] = -26667, -- Intermission: Amirdrassil in Peril
		[422032] = -26668, -- Stage Two: Children of the Stars
		[423717] = -26670, -- Stage Three: Shadowflame Incarnate
	},{
		[419506] = L.firestorm, -- Firestorm (Meteors)
		[417455] = L.dream_rend, -- Dream Rend (Pull In)
		[417431] = L.fyralaths_bite, -- Fyr'alath's Bite (Tank Bite)
		[417443] = L.fyralaths_mark, -- Fyr'alath's Mark (Mark)
		[422032] = L.spirits_of_the_kaldorei, -- Spirits of the Kaldorei (Spirits)
		[422518] = L.greater_firestorm, -- Greater Firestorm (Meteors [G])
		[412761] = L.incarnate, -- Incarnate (Knockup)
		[422524] = L.shadowflame_devastation, -- Shadowflame Devastation (Deep Breath)
		[423717] = CL.absorb, -- Bloom (Absorb)
		[422935] = L.eternal_firestorm, -- Eternal Firestorm (Meteors [E])
		[410223] = CL.breath, -- Shadowflame Breath (Breath)
		[422837] = CL.pushback, -- Apocalypse Roar (Pushback)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1") -- Incarnate
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL") -- P2 Spirit of the Kaldorei

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 419504, 425483) -- Raging Flames, Incinerated
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 419504, 425483, 410223) -- Shadowflame Breath (not in _APPLIED)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 419504, 425483, 410223)

	-- Stage One: The Dream Render
	self:Log("SPELL_CAST_START", "Firestorm", 419506)
	self:Log("SPELL_CAST_START", "Wildfire", 420422)
	self:Log("SPELL_CAST_START", "DreamRend", 417455)
	self:Log("SPELL_CAST_SUCCESS", "Blaze", 414186)
	self:Log("SPELL_AURA_APPLIED", "AflameApplied", 417807)
	self:Log("SPELL_AURA_REMOVED", "AflameRemoved", 417807)
	self:Log("SPELL_CAST_START", "FyralathsBite", 417431)
	self:Log("SPELL_AURA_APPLIED", "FyralathsMarkApplied", 417443)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FyralathsMarkApplied", 417443)

	-- Intermission: Amirdrassil in Peril
	self:Log("SPELL_CAST_START", "Corrupt", 419144)
	self:Log("SPELL_CAST_START", "Incarnate", 412761)
	self:Log("SPELL_AURA_APPLIED", "ShadowflameEruptionApplied", 429866)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShadowflameEruptionApplied", 429866)
	self:Log("SPELL_AURA_REMOVED", "CorruptRemoved", 421922)

	-- Stage Two: Children of the Stars
	self:Log("SPELL_CAST_START", "GreaterFirestorm", 422518)
	self:Log("SPELL_CAST_START", "Flamefall", 419123)
	self:Log("SPELL_CAST_SUCCESS", "ShadowflameDevastation", 422524)

	-- Stage Three: Shadowflame Incarnate
	self:Log("SPELL_AURA_APPLIED", "BloomApplied", 423717)
	self:Log("SPELL_CAST_SUCCESS", "EternalFirestormP3", 422935)
	self:Log("SPELL_CAST_START", "ShadowflameBreath", 410223)
	self:Log("SPELL_CAST_START", "ApocalypseRoar", 422837)
	self:Log("SPELL_CAST_START", "InfernalMaw", 425492)
	self:Log("SPELL_AURA_APPLIED", "InfernalMawApplied", 429672)
	self:Log("SPELL_AURA_APPLIED_DOSE", "InfernalMawApplied", 429672)
end

function mod:OnEngage()
	self:SetStage(1)
	wildfireCount = 1
	firestormCount = 1
	dreamRendCount = 1
	blazeCount = 1
	fyralathsBiteCount = 1

	spiritCount = 1
	incarnateCount = 1
	flamefallCount = 1
	shadowflameDevastationCount = 1

	apocalypseRoarCount = 1
	shadowflameBreathCount = 1
	infernalMawCount = 1

	self:Bar(420422, 4, CL.count:format(self:SpellName(420422), wildfireCount)) -- Wildfire
	self:Bar(417431, 9, CL.count:format(L.fyralaths_bite, fyralathsBiteCount)) -- Fyr'alath's Bite
	self:Bar(419506, 13, CL.count:format(L.firestorm, firestormCount)) -- Firestorm
	self:Bar(417455, 42, CL.count:format(L.dream_rend, dreamRendCount)) -- Dream Rend
	if not self:Easy() then
		self:Bar(414186, 32.0, CL.count:format(self:SpellName(414187), blazeCount)) -- Blaze
		blazeTimer = self:ScheduleTimer("Blaze", 32.0)
	end

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")

	self:SetPrivateAuraSound(414186, 414187) -- Blaze
	self:SetPrivateAuraSound(419506, 419060) -- Firestorm
	self:SetPrivateAuraSound(422518, 422520) -- Greater Firestorm
	self:SetPrivateAuraSound(422935, 425525) -- Eternal Firestorm
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
	self:StopBar(CL.count:format(L.firestorm, firestormCount))
	self:Message(args.spellId, "orange", CL.count:format(L.firestorm, firestormCount))
	self:PlaySound(args.spellId, "alert")
	firestormCount = firestormCount + 1
	self:Bar(args.spellId, 53.5, CL.count:format(L.firestorm, firestormCount))
end

function mod:Wildfire(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, wildfireCount))
	self:PlaySound(args.spellId, "alert")
	wildfireCount = wildfireCount + 1
	self:Bar(args.spellId, wildfireCount == 2 and 24.0 or 53.5, CL.count:format(args.spellName, wildfireCount)) -- Wildfire
end

function mod:DreamRend(args)
	self:StopBar(CL.count:format(L.dream_rend, dreamRendCount))
	self:Message(args.spellId, "red", CL.count:format(L.dream_rend, dreamRendCount))
	self:PlaySound(args.spellId, "warning")
	dreamRendCount = dreamRendCount + 1
	self:Bar(args.spellId, 53.6, CL.count:format(L.dream_rend, dreamRendCount))
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
		cd = blazeCount % 2 == 0 and 24 or 29.5
	elseif stage == 2 then
		local timer = { 20.6, 15.0, 25.0, 30.0, 27.0, 23.0, 30.0, 25.0 }
		cd = timer[blazeCount]
	elseif stage == 3 then
		cd = 41
	end
	if cd then
		self:Bar(414186, cd, CL.count:format(spellName, blazeCount))
		blazeTimer = self:ScheduleTimer("Blaze", cd)
	end
end

function mod:AflameApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:AflameRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:FyralathsBite(args)
	self:Message(args.spellId, "purple", CL.casting:format(L.fyralaths_bite))
	self:PlaySound(args.spellId, "alert") -- frontal
	fyralathsBiteCount = fyralathsBiteCount + 1
	self:Bar(args.spellId, fyralathsBiteCount % 3 == 1 and 23.6 or 15.0, L.fyralaths_bite)
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

-- Intermission: Amirdrassil in Peril

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 421830 then -- Incarnate
		local stage = self:GetStage()
		if stage == 1 then
			-- skip this one, cast after the CLEU Incarnate
			self:SetStage(1.5)
		elseif stage == 1.5 then
			self:SetStage(2)
			self:Message("stages", "cyan", CL.stage:format(2), false)
			self:PlaySound("stages", "long")

			spiritCount = 1
			incarnateCount = 1
			fyralathsBiteCount = 1
			firestormCount = 1
			blazeCount = 1
			shadowflameDevastationCount = 1
			flamefallCount = 1

			-- corrupt removed - 4.7~5
			-- self:Bar(419123, 1.7, CL.count:format(self:SpellName(419123), flamefallCount)) -- Flamefall
			self:Bar(417431, 14.2, CL.count:format(L.fyralaths_bite, fyralathsBiteCount)) -- Fyr'alath's Bite
			self:Bar(422518, 31.2, CL.count:format(L.greater_firestorm, firestormCount)) -- Greater Firestorm
			self:Bar(412761, 39.8, CL.count:format(L.incarnate, incarnateCount)) -- Incarnate
			if not self:Easy() then
				self:Bar(414186, 15.9, CL.count:format(self:SpellName(414186), blazeCount)) -- Blaze
				blazeTimer = self:ScheduleTimer("Blaze", 15.9)
			end
			self:Bar("stages", 211.3, CL.stage:format(3), 422935) -- Stage 2 (Eternal Firestorm)
		end
	end
end

function mod:Corrupt(args)
	self:StopBar(args.spellName)
	self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "info")
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
		end
	end
end

function mod:ShadowflameEruptionApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:CorruptRemoved() -- Stage 2
	self:Message("stages", "green", CL.stage:format(2), false)
	self:PlaySound("stages", "info")
end

-- Stage Two: Children of the Stars

function mod:Incarnate(args)
	if self:GetStage() == 1 then -- Intermission start
		self:CancelTimer(blazeTimer)
		self:StopBar(CL.count:format(self:SpellName(420422), wildfireCount)) -- Wildfire
		self:StopBar(CL.count:format(L.fyralaths_bite, fyralathsBiteCount)) -- Fyr'alath's Bite
		self:StopBar(CL.count:format(L.firestorm, firestormCount)) -- Firestorm
		self:StopBar(CL.count:format(L.dream_rend, dreamRendCount)) -- Dream Rend
		self:StopBar(CL.count:format(self:SpellName(414186), blazeCount)) -- Blaze
		self:UnregisterUnitEvent("UNIT_HEALTH", "boss1")

		self:Message("stages", "cyan", CL.intermission, false)
		self:PlaySound("stages", "long")

		self:Bar(419144, 13) -- Corrupt

	elseif self:GetStage() == 2 then
		self:StopBar(CL.count:format(L.incarnate, incarnateCount))
		self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(L.incarnate, incarnateCount)))
		self:PlaySound(args.spellId, "info")
		incarnateCount = incarnateCount + 1

		local timer = { 45.0, 80.0, 79.5 }
		local cd = timer[incarnateCount]
		if cd then -- last cast is p3 transition, what to do if you push before the second cast?
			self:Bar(args.spellId, cd, CL.count:format(L.incarnate, incarnateCount))
			self:Bar(422524, 14.5, CL.count:format(L.shadowflame_devastation, shadowflameDevastationCount)) -- Shadowflame Devastation
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
	self:StopBar(CL.count:format(L.greater_firestorm, firestormCount))
	self:Message(args.spellId, "orange", CL.count:format(L.greater_firestorm, firestormCount))
	self:PlaySound(args.spellId, "alert")
	firestormCount = firestormCount + 1
	if firestormCount < 3 then
		self:Bar(args.spellId, 80, CL.count:format(args.spellName, firestormCount))
	end
end

function mod:Flamefall(args)
	self:StopBar(CL.count:format(args.spellName, flamefallCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, flamefallCount))
	self:PlaySound(args.spellId, "alert")
	flamefallCount = flamefallCount + 1
	-- self:Bar(args.spellId, timers[2][args.spellId][flamefallCount], CL.count:format(args.spellName, flamefallCount))
end

function mod:ShadowflameDevastation(args)
	self:StopBar(CL.count:format(L.shadowflame_devastation, shadowflameDevastationCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.shadowflame_devastation, shadowflameDevastationCount))
	self:PlaySound(args.spellId, "long")
	shadowflameDevastationCount = shadowflameDevastationCount + 1
	-- self:Bar(args.spellId, timers[2][args.spellId][shadowflameDevastationCount], CL.count:format(L.shadowflame_devastation, shadowflameDevastationCount))
end

-- Stage 3

function mod:EternalFirestormP3()
	self:CancelTimer(blazeTimer)
	self:StopBar(CL.stage:format(3))
	self:StopBar(CL.count:format(L.spirits_of_the_kaldorei, spiritCount)) -- Spirits of the Kaldorei
	self:StopBar(CL.count:format(L.incarnate, incarnateCount)) -- Incarnate
	self:StopBar(CL.count:format(L.greater_firestorm, firestormCount)) -- Greater Firestorm
	self:StopBar(CL.count:format(self:SpellName(419123), flamefallCount)) -- Flamefall
	self:StopBar(CL.count:format(L.shadowflame_devastation, shadowflameDevastationCount)) -- Shadowflame Devastation
	self:StopBar(CL.count:format(L.fyralaths_bite, fyralathsBiteCount)) -- Fyr'alath's Bite

	self:Message("stages", "cyan", CL.stage:format(3), false)
	self:PlaySound("stages", "long")

	-- Would like an encounter event for earlier
	self:SetStage(3)
	infernalMawCount = 1
	shadowflameBreathCount = 1
	apocalypseRoarCount = 1

	-- Seeds spawn 2s after this event
	self:Bar(425492, 5, CL.count:format(self:SpellName(425492), infernalMawCount)) -- Infernal Maw
	self:Bar(410223, 10, CL.count:format(CL.breath, shadowflameBreathCount)) -- Shadowflame Breath
	self:Bar(422935, 18.1, CL.count:format(L.eternal_firestorm, firestormCount)) -- Eternal Firestorm
	self:ScheduleTimer("EternalFirestorm", 18.1)
	self:Bar(422837, 34.1, CL.count:format(CL.pushback, apocalypseRoarCount)) -- Apocalypse Roar
	if not self:Easy() then
		self:Bar(414186, 12.1, CL.count:format(self:SpellName(414186), blazeCount)) -- Blaze
		blazeTimer = self:ScheduleTimer("Blaze", 12.1)
	end
end

function mod:EternalFirestorm()
	self:StopBar(CL.count:format(L.eternal_firestorm, firestormCount))
	self:Message(422935, "orange", CL.count:format(L.eternal_firestorm, firestormCount))
	-- sound warning from private aura
	firestormCount = firestormCount + 1

	self:Bar(422935, 41, CL.count:format(L.eternal_firestorm, firestormCount))
	self:ScheduleTimer("EternalFirestorm", 41)
end

function mod:BloomApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(CL.absorb))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:ApocalypseRoar(args)
	self:StopBar(CL.count:format(CL.pushback, apocalypseRoarCount))
	self:Message(args.spellId, "yellow", CL.count:format(CL.pushback, apocalypseRoarCount))
	self:PlaySound(args.spellId, "long")
	apocalypseRoarCount = apocalypseRoarCount + 1
	self:Bar(args.spellId, 41, CL.count:format(CL.pushback, apocalypseRoarCount))
end

function mod:ShadowflameBreath(args)
	self:StopBar(CL.count:format(CL.breath, shadowflameBreathCount))
	self:Message(args.spellId, "orange", CL.count:format(CL.breath, shadowflameBreathCount))
	self:PlaySound(args.spellId, "alert")
	shadowflameBreathCount = shadowflameBreathCount + 1
	self:Bar(args.spellId, 41, CL.count:format(CL.breath, shadowflameBreathCount))
end

function mod:InfernalMaw(args)
	self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
	if self:Tank() then
		self:PlaySound(args.spellId, "alert")
	end
	infernalMawCount = infernalMawCount + 1
	local cd = infernalMawCount % 2 == 0 and 3.0 or infernalMawCount % 4 == 1 and 25.0 or 10.0
	self:CDBar(args.spellId, cd)
end

function mod:InfernalMawApplied(args)
	local amount = args.amount or 1
	local warnFrom = 2
	self:StackMessage(425492, "purple", args.destName, args.amount, warnFrom)
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	if amount >= warnFrom and bossUnit and self:Tank() and not self:Me(args.destGUID) and not self:Tanking(bossUnit) then
		self:PlaySound(425492, "warning") -- tauntswap
	elseif self:Me(args.destGUID) then
		self:PlaySound(425492, "alarm") -- On you
	end
end
