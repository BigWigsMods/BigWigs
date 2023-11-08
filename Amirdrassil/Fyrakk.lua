--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Fyrakk the Blazing", 2549, 2519)
if not mod then return end
mod:RegisterEnableMob(211286, 211217, 209976, 209888, 204931, 213646, 204409) -- Fyrakk XXX Confirm which is needed
mod:SetEncounterID(2677)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local firestormCount = 1
local dreamRendCount = 1
local blazeCount = 1
local fyralathsBiteCount = 1
local shadowflameBreathCount = 1
local flamefallCount = 1
local shadowflameDevastationCount = 1
local apocalypseRoarCount = 1
local infernalMawCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.firestorm = "Meteors"
	L.dream_rend = "Pull In"
	L.fyralaths_bite = "Tank Bite"
	L.fyralaths_mark = "Mark"
	L.incarnate = "Knockup"
	L.greater_firestorm = "Meteors [G]" -- G for Greater
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
		419506, -- Firestorm
		419504, -- Raging Flames
		420422, -- Wildfire
		417455, -- Dream Rend
		425483, -- Incinerated
		414186, -- Blaze
		417807, -- Aflame
		417431, -- Fyr'alath's Bite XXX Possible TANK flag
		417443, -- Fyr'alath's Mark
		-- Intermission: Amirdrassil in Peril
		419144, -- Corrupt
		410223, -- Shadowflame Breath
		412761, -- Incarnate
		421937, -- Shadowflame Orbs
		429866, -- Shadowflame Eruption
		-- Stage Two: Children of the Stars
		422518, -- Greater Firestorm
		419123, -- Flamefall
		422524, -- Shadowflame Devastation
		-- Stage Three: Shadowflame Incarnate
		423717, -- Bloom
		422935, -- Eternal Firestorm
		422837, -- Apocalypse Roar
		{425492, "TANK"}, -- Infernal Maw
	},{
		["stages"] = "general",
		[419506] = -26666, -- Stage One: The Dream Render
		[419144] = -26667, -- Intermission: Amirdrassil in Peril
		[422518] = -26668, -- Stage Two: Children of the Stars
		[422935] = -26670, -- Stage Three: Shadowflame Incarnate
	},{
		[419506] = L.firestorm, -- Firestorm (Meteors)
		[417455] = L.dream_rend, -- Dream Rend (Pull In)
		[414186] = CL.bombs, -- Blaze (Bombs)
		[417431] = L.fyralaths_bite, -- Fyr'alath's Bite (Tank Bite)
		[417443] = L.fyralaths_mark, -- Fyr'alath's Mark (Mark)
		[410223] = CL.breath, -- Shadowflame Breath (Breath)
		[412761] = L.incarnate, -- Incarnate (Knockup)
		[421937] = CL.orbs, -- Shadowflame Orbs (Orbs)
		[422518] = L.greater_firestorm, -- Greater Firestorm (Meteors [G])
		[422524] = L.shadowflame_devastation, -- Shadowflame Devastation (Deep Breath)
		[423717] = CL.absorb, -- Bloom (Absorb)
		[422935] = L.eternal_firestorm, -- Eternal Firestorm (Meteors [E])
		[422837] = CL.pushback, -- Apocalypse Roar (Pushback)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 419504, 425483) -- Raging Flames, Incinerated
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 419504, 425483, 410223) -- Shadowflame Breath (not in _APPLIED)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 419504, 425483, 410223)

	-- Stage One: The Dream Render
	self:Log("SPELL_CAST_START", "Firestorm", 419506)
	self:Log("SPELL_CAST_START", "Wildfire", 420422)
	self:Log("SPELL_CAST_START", "DreamRend", 417455)
	self:Log("SPELL_CAST_SUCCESS", "Blaze", 414186)
	self:Log("SPELL_AURA_APPLIED", "AflameApplied", 417807)
	self:Log("SPELL_AURA_APPLIED_DOSE", "AflameApplied", 417807)
	self:Log("SPELL_AURA_REMOVED", "AflameRemoved", 417807)
	self:Log("SPELL_CAST_START", "FyralathsBite", 417431)
	self:Log("SPELL_AURA_APPLIED", "FyralathsMarkApplied", 417443)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FyralathsMarkApplied", 417443)

	-- Intermission: Amirdrassil in Peril
	self:Log("SPELL_CAST_START", "Corrupt", 419144)
	self:Log("SPELL_CAST_START", "ShadowflameBreath", 410223)
	self:Log("SPELL_CAST_START", "Incarnate", 412761)
	self:Log("SPELL_CAST_SUCCESS", "ShadowflameOrbs", 421937)
	self:Log("SPELL_AURA_APPLIED", "ShadowflameEruptionApplied", 429866)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShadowflameEruptionApplied", 429866)

	-- Stage Two: Children of the Stars
	self:Log("SPELL_CAST_START", "GreaterFirestorm", 422518)
	self:Log("SPELL_CAST_START", "Flamefall", 419123)
	self:Log("SPELL_CAST_START", "ShadowflameDevastation", 422524)

	-- Stage Three: Shadowflame Incarnate
	self:Log("SPELL_AURA_APPLIED", "BloomApplied", 423717)
	self:Log("SPELL_CAST_SUCCESS", "EternalFirestorm", 422935)
	self:Log("SPELL_CAST_START", "ApocalypseRoar", 422837)
	self:Log("SPELL_CAST_START", "InfernalMaw", 425492)
	self:Log("SPELL_AURA_APPLIED", "InfernalMawApplied", 429672)
	self:Log("SPELL_AURA_APPLIED_DOSE", "InfernalMawApplied", 429672)
end

function mod:OnEngage()
	self:SetStage(1)
	firestormCount = 1
	dreamRendCount = 1
	blazeCount = 1
	fyralathsBiteCount = 1
	shadowflameBreathCount = 1
	flamefallCount = 1
	shadowflameDevastationCount = 1
	apocalypseRoarCount = 1
	infernalMawCount = 1

	-- self:Bar(417431, 10, CL.count:format(L.fyralaths_bite)) -- Fyr'alath's Bite
	-- self:Bar(414186, 20, CL.count:format(CL.bombs)) -- Blaze
	-- self:Bar(419506, 30, CL.count:format(L.firestorm)) -- Firestorm
	-- self:Bar(417455, 50, CL.count:format(L.dream_rend)) -- Dream Rend

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
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
	--self:Bar(args.spellId, 50, CL.count:format(L.firestorm, firestormCount))
end

function mod:Wildfire(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:DreamRend(args)
	self:StopBar(CL.count:format(L.dream_rend, dreamRendCount))
	self:Message(args.spellId, "red", CL.count:format(L.dream_rend, dreamRendCount))
	self:PlaySound(args.spellId, "warning")
	dreamRendCount = dreamRendCount + 1
	--self:Bar(args.spellId, 50, CL.count:format(L.dream_rend, dreamRendCount))
end

function mod:Blaze(args)
	self:StopBar(CL.count:format(CL.bombs, blazeCount))
	self:Message(args.spellId, "yellow", CL.count:format(CL.bombs, blazeCount))
	--self:PlaySound(args.spellId, "alert") -- Sound from Private Aura
	blazeCount = blazeCount + 1
	--self:Bar(args.spellId, 50, CL.count:format(CL.bombs, blazeCount))
end

function mod:AflameApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
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
	fyralathsBiteCount = fyralathsBiteCount + 1
	-- Sound on _APPLIED
	--self:Bar(args.spellId, 25, L.fyralaths_bite)
end

function mod:FyralathsMarkApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1, L.fyralaths_mark)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm")
	elseif amount > 1 then -- Tank Swap?
		self:PlaySound(args.spellId, "warning")
	else
		self:PlaySound(args.spellId, "info")
	end
end

-- Intermission: Amirdrassil in Peril
function mod:Corrupt(args)
	self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alert")
end

function mod:ShadowflameBreath(args)
	self:StopBar(CL.count:format(CL.breath, shadowflameBreathCount))
	self:Message(args.spellId, "orange", CL.count:format(CL.breath, shadowflameBreathCount))
	self:PlaySound(args.spellId, "alert")
	shadowflameBreathCount = shadowflameBreathCount + 1
	--self:Bar(args.spellId, 50, CL.count:format(CL.breath, shadowflameBreathCount))
end

function mod:Incarnate(args)
	self:Message(args.spellId, "red", CL.casting:format(L.incarnate))
	self:PlaySound(args.spellId, "warning")
end

function mod:ShadowflameOrbs(args)
	self:Message(args.spellId, "cyan", CL.incoming:format(CL.orbs))
	self:PlaySound(args.spellId, "info")
end

function mod:ShadowflameEruptionApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
		self:PlaySound(args.spellId, "warning")
	end
end

-- Stage Two: Children of the Stars
function mod:GreaterFirestorm(args)
	self:StopBar(CL.count:format(L.greater_firestorm, firestormCount))
	self:Message(args.spellId, "orange", CL.count:format(L.greater_firestorm, firestormCount))
	self:PlaySound(args.spellId, "alert")
	firestormCount = firestormCount + 1
	--self:Bar(args.spellId, 50, CL.count:format(L.greater_firestorm, firestormCount))
end

function mod:Flamefall(args)
	self:StopBar(CL.count:format(args.spellName, flamefallCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, flamefallCount))
	self:PlaySound(args.spellId, "alert")
	flamefallCount = flamefallCount + 1
	--self:Bar(args.spellId, 50, CL.count:format(args.spellName, flamefallCount))
end

function mod:ShadowflameDevastation(args)
	self:StopBar(CL.count:format(L.shadowflame_devastation, shadowflameDevastationCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.shadowflame_devastation, shadowflameDevastationCount))
	self:PlaySound(args.spellId, "long")
	shadowflameDevastationCount = shadowflameDevastationCount + 1
	--self:Bar(args.spellId, 50, CL.count:format(L.shadowflame_devastation, shadowflameDevastationCount))
end

function mod:BloomApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(CL.absorb))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:EternalFirestorm(args)
	self:Message(args.spellId, "orange", L.eternal_firestorm)
	self:PlaySound(args.spellId, "alert")
end

function mod:ApocalypseRoar(args)
	self:StopBar(CL.count:format(CL.pushback, apocalypseRoarCount))
	self:Message(args.spellId, "yellow", CL.count:format(CL.pushback, apocalypseRoarCount))
	self:PlaySound(args.spellId, "long")
	apocalypseRoarCount = apocalypseRoarCount + 1
	--self:Bar(args.spellId, 50, CL.count:format(CL.pushback, apocalypseRoarCount))
end

function mod:InfernalMaw(args)
	self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alert")
	infernalMawCount = infernalMawCount + 1
	--self:CDBar(args.spellId, 20)
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
