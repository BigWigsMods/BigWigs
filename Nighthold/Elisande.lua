
--------------------------------------------------------------------------------
-- Notes:
-- - Localization:
--   - Sadly we need to rely on yells if we don't want to schedule more timers
--   - I've coded a fallback mechanism (search for l11n), to automatically get
--     the localizations. The yells should be .2s after the casts, so it should
--     work reliably, but getting the translations would be safer.


--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Grand Magistrix Elisande", 1088, 1743)
if not mod then return end
mod:RegisterEnableMob(106643, 111151) -- Elisande, Midnight Siphoner
mod.engageId = 1872
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local phase = 0
local isPhaseTransition = nil
local elementalCollector = {}

local lfrTimers = {
	-- Timers are after Leave the Nightwell success (208863)

	-- Summon Time Elemental - Slow
	[211614] = {5, 62, 40, 55},

	-- Summon Time Elemental - Fast
	[211616] = {65},

	--[[ Phase 1 ]]--
	-- Arcanetic Ring
	[228877] = {21, 30, 37, 35, 35},

	-- Spanning Singularity
	[209170] = {17, 57, 30},

	--[[ Phase 2 ]]--
	-- Epocheric Orb
	[210022] = {40, 37},

	-- Delphuric Beam
	[209244] = {35, 77, 25}, -- in Phase 3 for LFR

	-- Ablating Explosion
	[209973] = {}, -- first 12.1, then between 20.7 and 21.8 (no pattern)

	--[[ Phase 3 ]]--
	-- Permeliative Torment
	[211261] = {}, -- Not in LFR

	-- Conflexive Burst
	[209597] = {}, -- Not in LFR
}

local normalTimers = {
	-- Timers are after Leave the Nightwell success (208863)

	-- Summon Time Elemental - Slow
	[211614] = {5, 49, 41, 60},

	-- Summon Time Elemental - Fast
	[211616] = {8, 71, 101},

	--[[ Phase 1 ]]--
	-- Arcanetic Ring
	[228877] = {34, 31, 76, 50, 40, 15, 30},

	-- Spanning Singularity
	[209170] = {23, 36, 46, 65},

	--[[ Phase 2 ]]--
	-- Epocheric Orb
	[210022] = {18, 56, 31, 85}, -- then constant 15s after the sequence

	-- Delphuric Beam
	[209244] = {59, 26, 40, 110},

	-- Ablating Explosion
	[209973] = {}, -- first 12.1, then between 20.7 and 21.8 (no pattern)

	--[[ Phase 3 ]]--
	-- Permeliative Torment
	[211261] = {23, 41, 106},

	-- Conflexive Burst
	[209597] = {48, 67, 50, 45}, -- then constant 10s after the sequence
}

local heroicTimers = {
	-- Timers are after Leave the Nightwell success (208863)

	-- Summon Time Elemental - Slow
	[211614] = {5, 49, 52, 60},

	-- Summon Time Elemental - Fast
	[211616] = {8, 88, 95, 20},

	--[[ Phase 1 ]]--
	-- Arcanetic Ring
	[228877] = {35, 40, 10, 63, 10},

	-- Spanning Singularity
	[209170] = {25, 36, 57, 65},

	--[[ Phase 2 ]]--
	-- Epocheric Orb
	[210022] = {18, 76, 37, 70, 15, 15, 30, 15},

	-- Delphuric Beam
	[209244] = {59, 57, 60, 70},

	-- Ablating Explosion
	[209973] = {12, 20.7, 20.6, 22, 20.7, 25.5, 20.6, 20.6, 20.6, 20.6},

	--[[ Phase 3 ]]--
	-- Permeliative Torment
	[211261] = {23, 61, 37, 60},

	-- Conflexive Burst
	[209597] = {48, 52.0, 56.0, 65.0, 10.0},
}

local mythicTimers = {
	-- Timers are after Leave the Nightwell success (208863)

	-- Summon Time Elemental - Slow
	[211614] = { -- timers are complete
		[1] = {5, 39, 75},
		[2] = {5, 39, 45, 30, 30},
		[3] = {5, 54, 55, 30},
	},

	-- Summon Time Elemental - Fast
	[211616] = { -- timers are complete
		[1] = {8, 81},
		[2] = {8, 51},
		[3] = {8, 36, 45},
	},

	--[[ Phase 1 ]]--
	-- Arcanetic Ring
	[228877] = {30, 39, 15, 31, 19, 10, 26, 9, 10},

	-- Spanning Singularity
	[209170] = {56, 50, 45}, -- timers are complete

	--[[ Phase 2 ]]--
	-- Epocheric Orb
	[210022] = {14, 85, 60, 20, 10}, -- timers are complete

	-- Delphuric Beam
	[209244] = {57.8, 50, 65}, -- timers are complete

	-- Ablating Explosion
	[209973] = {12.2, 20.6, 20.6, 20.6, 20.6, 20.7, 21.8, 20.6, 20.6, 20.7}, -- timers are complete

	--[[ Phase 3 ]]--
	-- Permeliative Torment
	[211261] = {63.7, 75, 25, 20}, -- timers are complete

	-- Conflexive Burst
	[209597] = {38.7, 90, 45, 30}, -- timers are complete
}

local timers = mod:Mythic() and mythicTimers or mod:Heroic() and heroicTimers or mod:Normal() and normalTimers or lfrTimers

local slowElementalCount = 1
local slowZoneCount = 1
local fastElementalCount = 1
local fastZoneCount = 1
local ringCount = 1
local singularityCount = 1
local orbCount = 1
local beamCount = 1
local ablatingCount = 1
local tormentCount = 1
local conflexiveBurstCount = 1

-- These are for abilites which will echo on mythic
local savedRingCount = nil
local savedSingularityCount = nil
local savedOrbCount = nil
local savedBeamCount = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.elisande = "Elisande"

	L.ring_yell = "Let the waves of time crash over you!"
	--L.singularity_msg = "I control the battlefield, not you!" -- unused
	L.orb_yell = "You'll find time can be quite volatile."
	--L.beam_msg = "The threads of time answer to me!" -- unused

	L.recursive_elemental = -13226
	L.recursive_elemental_icon = 209165 -- Slow Time
	L.slowTimeZone = "Slow Time Zone"

	L.expedient_elemental = -13229
	L.expedient_elemental_icon = 209166 -- Fast Time
	L.fastTimeZone = "Fast Time Zone"

	L.boss_active = "Elisande Active"
	L.boss_active_desc = "Time until Elisande is active after clearing the trash event."
	L.boss_active_icon = "achievement_thenighthold_grandmagistrixelisande"
	L.elisande_trigger = "I foresaw your coming, of course. The threads of fate that led you to this place. Your desperate attempt to stop the Legion."
end

-- Localization fallback (l11n)
local english_ring_msg = "Let the waves of time crash over you!"
local english_orb_msg = "You'll find time can be quite volatile."
local need_ring_msg = GetLocale() ~= "enUS" and english_ring_msg == L.ring_yell
local need_orb_msg = GetLocale() ~= "enUS" and english_orb_msg == L.orb_yell
local ring_msg_is_next = nil
local orb_msg_is_next = nil
local localized_ring_msg = nil
local localized_orb_msg = nil
-- Localization fallback END (l11n)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ General ]]--
		"boss_active",
		"stages",
		229889, -- Terminate (Berserk)

		--[[ Recursive Elemental ]]--
		"recursive_elemental",
		209620, -- Recursion
		221864, -- Blast
		209165, -- Slow Time

		--[[ Expedient Elemental ]]--
		"expedient_elemental",
		209617, -- Expedite
		209166, -- Fast Time

		--[[ Time Layer 1 ]]--
		228877, -- Arcanetic Ring
		209170, -- Spanning Singularity
		{209615, "TANK"}, -- Ablation

		--[[ Time Layer 2 ]]--
		{209244, "SAY", "FLASH"}, -- Delphuric Beam
		210022, -- Epocheric Orb
		{209973, "FLASH", "SAY", "TANK"}, -- Ablating Explosion

		--[[ Time Layer 3 ]]--
		211261, -- Permeliative Torment
		{209597, "SAY", "FLASH"}, -- Conflexive Burst
		209971, -- Ablative Pulse
		{211887, "TANK"}, -- Ablated
	},{
		["boss_active"] = "general",
		["recursive_elemental"] = -13226, -- Recursive Elemental
		["expedient_elemental"] = -13229, -- Expedient Elemental
		[228877] = -13222, -- Time Layer 1
		[209244] = -13235, -- Time Layer 2
		[211261] = -13232, -- Time Layer 3
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_CAST_START", "TimeStop", 208944) -- Phase triggering
	self:Log("SPELL_CAST_SUCCESS", "LeavetheNightwell", 208863) -- New phase starting
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_SAY", "Warmup")

	--[[ Recursive Elemental ]]--
	self:Log("SPELL_CAST_START", "Recursion", 209620)
	self:Log("SPELL_CAST_START", "Blast", 221864)
	self:Log("SPELL_AURA_APPLIED", "SlowTime", 209165)
	self:Log("SPELL_AURA_REMOVED", "TimeAuraRemoved", 209165)

	--[[ Expedient Elemental ]]--
	self:Log("SPELL_CAST_START", "Expedite", 209617)
	self:Log("SPELL_AURA_APPLIED", "FastTime", 209166)
	self:Log("SPELL_AURA_REMOVED", "TimeAuraRemoved", 209166)

	--[[ Time Layer 1 ]]--
	self:Log("SPELL_CAST_START", "ArcaneticRing", 228877) -- l11n
	self:Log("SPELL_AURA_APPLIED", "SingularityDamage", 209433)
	self:Log("SPELL_PERIODIC_DAMAGE", "SingularityDamage", 209433)
	self:Log("SPELL_PERIODIC_MISSED", "SingularityDamage", 209433)
	self:Log("SPELL_AURA_APPLIED", "Ablation", 209615)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Ablation", 209615)

	--[[ Time Layer 2 ]]--
	self:Log("SPELL_CAST_START", "DelphuricBeamCast", 214278) -- P2
	self:Log("SPELL_CAST_SUCCESS", "DelphuricBeamCast", 214295) -- P3 is only success
	self:Log("SPELL_AURA_APPLIED", "DelphuricBeam", 209244)
	self:Log("SPELL_CAST_START", "EpochericOrb", 210022) -- l11n
	self:Log("SPELL_AURA_APPLIED", "AblatingExplosion", 209973)

	--[[ Time Layer 3 ]]--
	self:Log("SPELL_AURA_APPLIED", "PermeliativeTorment", 211261)
	self:Log("SPELL_CAST_SUCCESS", "ConflexiveBurst", 209597)
	self:Log("SPELL_AURA_APPLIED", "ConflexiveBurstApplied", 209598)
	self:Log("SPELL_CAST_START", "AblativePulse", 209971)
	self:Log("SPELL_AURA_APPLIED", "Ablated", 211887)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Ablated", 211887)
end

function mod:OnEngage()
	phase = 0 -- Phase 1 starts upon first Leave the Nightwell cast
	isPhaseTransition = nil

	slowElementalCount = 1
	slowZoneCount = 1
	fastElementalCount = 1
	fastZoneCount = 1
	ringCount = 1
	singularityCount = 1
	orbCount = 1
	beamCount = 1
	ablatingCount = 1
	tormentCount = 1
	conflexiveBurstCount = 1

	savedRingCount = nil
	savedSingularityCount = nil
	savedOrbCount = nil
	savedBeamCount = nil

	-- l11n START
	need_ring_msg = GetLocale() ~= "enUS" and english_ring_msg == L.ring_yell
	need_orb_msg = GetLocale() ~= "enUS" and english_orb_msg == L.orb_yell
	-- l11n END

	timers = self:Mythic() and mythicTimers or mod:Heroic() and heroicTimers or mod:Normal() and normalTimers or lfrTimers
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Warmup(event, msg)
	if msg == L.elisande_trigger then
		self:UnregisterEvent(event)
		self:Bar("boss_active", 68, L.boss_active, L.boss_active_icon)
	end
end

--[[ General ]]--
do
	local prev = 0
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, spellName, _, _, spellId)
		if spellId == 211614 then -- Slow
			self:Message("recursive_elemental", "Neutral", "Info", L.recursive_elemental, L.recursive_elemental_icon)
			slowElementalCount = slowElementalCount + 1
			local timer = nil
			if self:Mythic() then
				timer = timers[spellId][phase][slowElementalCount]
			else
				timer = timers[spellId][slowElementalCount]
			end
			if timer then
				self:Bar("recursive_elemental", timer, L.recursive_elemental, L.recursive_elemental_icon)
			end
		elseif spellId == 211616 then -- Fast
			self:Message("expedient_elemental", "Neutral", "Info", L.expedient_elemental, L.expedient_elemental_icon)
			fastElementalCount = fastElementalCount + 1
			local timer = nil
			if self:Mythic() then
				timer = timers[spellId][phase][fastElementalCount]
			else
				timer = timers[spellId][fastElementalCount]
			end
			if timer then
				self:Bar("expedient_elemental", timer, L.expedient_elemental, L.expedient_elemental_icon)
			end
		elseif spellId == 209170 or spellId == 209171 then -- Spanning Singularity heroic / mythic
			self:Message(209170, "Attention", "Info")
			singularityCount = singularityCount + 1
			local timer = timers[209170][singularityCount]
			if timer then
				self:Bar(209170, timer, CL.count:format(spellName, singularityCount))
			end
		elseif self:Easy() and (spellId == 209168 or spellId == 233010) then -- Spanning Singularity normal mode / LFR
			local t = GetTime()
			if t-prev > 1.5 then -- event can fire twice
				prev = t
				self:Message(209170, "Attention", "Info")
				singularityCount = singularityCount + 1
				local timer = timers[209170][singularityCount]
				if self:LFR() then -- XXX Unsure if timers are complete
					self:Bar(209170, timer, CL.count:format(spellName, singularityCount))
				elseif timer then
					self:Bar(209170, timer, CL.count:format(spellName, singularityCount))
				end
			end
		end
	end
end

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	if isPhaseTransition then -- Otherwise it triggers in intermission
		return
	end

	local addsFound = {}

	for i = 1, 5 do
		local guid = UnitGUID(("boss%d"):format(i))
		if guid then
			local mobId = self:MobId(guid)
			if mobId == 105301 or mobId == 105299 then -- Fast Elemental, Slow Elemental
				if not elementalCollector[guid] then
					elementalCollector[guid] = true
				end
				addsFound[guid] = true
			end
		end
	end

	for guid,_ in pairs(elementalCollector) do
		if not addsFound[guid] then -- add died
			elementalCollector[guid] = nil
			local mobId = self:MobId(guid)
			if mobId == 105301 then -- Fast Elemental
				self:Bar(209166, 35, CL.count:format(L.fastTimeZone, fastZoneCount))
				fastZoneCount = fastZoneCount + 1
			elseif mobId == 105299 then -- Slow Elemental
				self:Bar(209165, 70, CL.count:format(L.slowTimeZone, slowZoneCount))
				slowZoneCount = slowZoneCount + 1
			end
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	-- l11n START
	-- XXX maybe add a print to tell the user to tell us?
	if orb_msg_is_next then
		localized_orb_msg = msg
		need_orb_msg = nil
		orb_msg_is_next = nil
	end
	if ring_msg_is_next then
		localized_ring_msg = msg
		need_ring_msg = nil
		ring_msg_is_next = nil
	end
	-- l11n END

	if msg == L.ring_yell or (localized_ring_msg and msg:find(localized_ring_msg)) then -- Arcanetic Ring, l11n
		self:Message(228877, "Attention", "Alarm", CL.count:format(self:SpellName(228877), ringCount))
		ringCount = ringCount + 1
		local timer = timers[228877][ringCount]
		if self:LFR() then -- XXX Unsure if timers are complete
			self:Bar(228877, timer, CL.count:format(self:SpellName(228877), ringCount))
		elseif timer and (not savedRingCount or ringCount < savedRingCount) then
			self:Bar(228877, timer, CL.count:format(self:SpellName(228877), ringCount))
		end

	elseif msg == L.orb_yell or (localized_orb_msg and msg:find(localized_orb_msg)) then -- Epocheric Orb, l11n
		self:Message(210022, "Urgent", "Alert", CL.count:format(self:SpellName(210022), orbCount))
		orbCount = orbCount + 1
		local timer = timers[210022][orbCount] or self:Easy() and 15
		if self:LFR() then -- XXX Unsure if timers are complete
			self:Bar(210022, timer, CL.count:format(self:SpellName(210022), orbCount))
		elseif timer and (not savedOrbCount or orbCount < savedOrbCount) then
			self:Bar(210022, timer, CL.count:format(self:SpellName(210022), orbCount))
		end

	-- Should be in DelphuricBeamCast XXX remove if confirmed
	--elseif msg:find(L.beam_msg) then
	--	self:Message(209244, "Urgent", "Alert")
	--	beamCount = beamCount + 1
	--	if not savedBeamCount or beamCount < savedBeamCount then
	--		local t = timers[209244][beamCount]
	--		if t then
	--			self:Bar(209244, t, CL.count:format(self:SpellName(209244), beamCount))
	--		end
	--	end

	-- Should be in StartSingularityTimer XXX remove if confirmed
	--elseif msg:find(L.singularity_msg) and phase == 2 or phase == 3 then -- Mythic only, zones apears 2s after the message.
	--	self:ScheduleTimer("Message", 2, 209170, "Attention", "Info", self:SpellName(209170))
	end
end

-- No event, so we are using this scheduling (mythic p2+p3 only)
function mod:StartSingularityTimer()
	singularityCount = singularityCount + 1
	local t = timers[209170][singularityCount]
	if not t then
		return
	end

	if not savedSingularityCount or singularityCount < savedSingularityCount then
		self:CDBar(209170, t, CL.count:format(self:SpellName(209170), singularityCount))
		self:DelayedMessage(209170, t, "Attention", nil, nil, "Info") -- Zones appear 2s after yell
		self:ScheduleTimer("StartSingularityTimer", t)
	end
end

function mod:TimeStop(args)
	isPhaseTransition = true
	self:Message("stages", "Neutral", "Info", args.spellName, args.spellId)
	self:Bar("stages", 9.7, CL.stage:format(phase+1), args.spellId)
	self:Bar("stages", 13.2, L.elisande, "Achievement_thenighthold_grandmagistrixelisande")
	-- Stop old bars
	self:StopBar(L.recursive_elemental)
	self:StopBar(L.expedient_elemental)
	self:StopBar(CL.count:format(L.fastTimeZone, fastZoneCount-1))
	self:StopBar(CL.count:format(L.slowTimeZone, slowZoneCount-1))
	self:StopBar(CL.count:format(self:SpellName(228877), ringCount)) -- Arcanetic Ring
	self:StopBar(CL.count:format(self:SpellName(210022), orbCount)) -- Epocheric Orb
	self:StopBar(CL.count:format(self:SpellName(209244), beamCount)) -- Delphuric Beam
	self:StopBar(CL.count:format(self:SpellName(209170), singularityCount)) -- Singularity
	self:StopBar(CL.count:format(self:SpellName(209973), ablatingCount)) -- Ablating
	self:StopBar(229889) -- Terminate (Berserk)
	wipe(elementalCollector) -- This prevents starting wrong time zone bars at the start of the next phase
	-- New bars will be started in LeavetheNightwell
end

function mod:LeavetheNightwell()
	phase = phase + 1
	isPhaseTransition = nil

	if self:Mythic() then
		self:Berserk(phase == 3 and 194 or 199, true, nil, 229889, 229889)
	end

	if phase == 2 then
		self:Message("stages", "Neutral", "Long", CL.stage:format(phase), false)

		savedRingCount = ringCount
		savedSingularityCount = singularityCount

		beamCount = 1
		orbCount = 1
		ablatingCount = 1

		if not self:LFR() then -- Beams not in LFR
			self:Bar(209244, timers[209244][beamCount]) -- Delphuric Beam
		end
		self:Bar(210022, timers[210022][orbCount]) -- Epocheric Orb
		self:Bar(209973, self:Easy() and 12.1 or timers[209973][ablatingCount]) -- Ablating Explosion
	elseif phase == 3 then
		self:Message("stages", "Neutral", "Long", CL.stage:format(phase), false)

		savedOrbCount = orbCount
		savedBeamCount = beamCount

		beamCount = 1
		orbCount = 1
		tormentCount = 1
		conflexiveBurstCount = 1

		if not self:LFR() then -- These abilities don't apear in LFR in P3
			self:Bar(211261, timers[211261][tormentCount], CL.count:format(self:SpellName(211261), tormentCount)) -- Permeliative Torment
			self:Bar(209597, timers[209597][conflexiveBurstCount], CL.count:format(self:SpellName(209597), conflexiveBurstCount)) -- Conflexive Burst
		end
		if not self:Easy() then -- Not in Normal or LFR
			self:Bar(210022, timers[210022][orbCount]) -- Epocheric Orb
		end
		if self:Mythic() or self:LFR() then -- Beams are in P3 in LFR.
			self:Bar(209244, timers[209244][beamCount]) -- Delphuric Beam
		end
	end

	slowElementalCount = 1
	slowZoneCount = 1
	fastElementalCount = 1
	fastZoneCount = 1
	ringCount = 1
	singularityCount = 1

	self:Bar("recursive_elemental", self:Mythic() and timers[211614][phase][slowElementalCount] or timers[211614][slowElementalCount], L.recursive_elemental, L.recursive_elemental_icon)
	self:Bar("expedient_elemental", self:Mythic() and timers[211616][phase][fastElementalCount] or timers[211616][fastElementalCount], L.expedient_elemental, L.expedient_elemental_icon)
	if not (self:Easy() and phase > 1) then
		self:Bar(228877, timers[228877][ringCount] + (phase > 1 and 2 or 0), CL.count:format(self:SpellName(228877), ringCount)) -- Arcanetic Ring
	end
	if phase == 1 or self:Normal() then
		self:Bar(209170, timers[209170][singularityCount], CL.count:format(self:SpellName(209170), singularityCount)) -- Spanning Singularity
	elseif phase == 2 or phase == 3 then -- No events in p2/3 for heroic / mythic, so scheduling it is!
		singularityCount = 0 -- will get incremented in the function
		self:StartSingularityTimer()
	end
end

--[[ Recursive Elemental ]]--
function mod:Recursion(args)
	self:Message(args.spellId, "Important", self:Interrupter(args.sourceGUID) and "Alert")
end

function mod:Blast(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "Important", "Alert")
	end
end

function mod:SlowTime(args)
	if self:Me(args.destGUID)then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Long")
		local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
		local t = expires - GetTime()
		self:TargetBar(args.spellId, t, args.destName)
	end
end

--[[ Expedient Elemental ]]--
function mod:Expedite(args)
	self:Message(args.spellId, "Attention", self:Interrupter(args.sourceGUID) and "Info")
end

function mod:FastTime(args)
	if self:Me(args.destGUID)then
		self:Message(args.spellId, "Positive", "Long", CL.you:format(args.spellName))
		local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
		local t = expires - GetTime()
		self:TargetBar(args.spellId, t, args.destName)
	end
end

function mod:TimeAuraRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellId, args.destName)
	end
end

--[[ Time Layer 1 ]]--
function mod:ArcaneticRing() -- l11n
	if self:LFR() and ringCount == 1 then -- For some reason Elisande forgets to yell on the first rings in LFR
		self:CHAT_MSG_MONSTER_YELL("", L.ring_yell, "")
	elseif need_ring_msg then
		ring_msg_is_next = true
	end
end

do
	local prev = 0
	function mod:SingularityDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(209170, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

function mod:Ablation(args)
	local amount = args.amount or 1
	if amount % 2 == 1 or amount > 3 then
		self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 3 and "Warning")
	end
end

--[[ Time Layer 2 ]]--
function mod:DelphuricBeamCast()
	self:Message(209244, "Urgent", "Alert")
	beamCount = beamCount + 1
	local timer = timers[209244][beamCount]
	if self:LFR() then
		self:Bar(209244, timers[209244][beamCount], CL.count:format(self:SpellName(209244), beamCount))
	elseif (not savedBeamCount or beamCount < savedBeamCount) and timer then
		self:Bar(209244, timer, CL.count:format(self:SpellName(209244), beamCount))
	end
end

function mod:DelphuricBeam(args)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
		local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
		local t = expires - GetTime()
		self:TargetBar(args.spellId, t, args.destName)
		self:TargetMessage(args.spellId, args.destName, "Important", "Alarm")
	end
end

function mod:EpochericOrb() -- l11n
	if need_orb_msg then
		orb_msg_is_next = true
	end
end

function mod:AblatingExplosion(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Long")
	ablatingCount = ablatingCount + 1

	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
	end
	local timer = self:Easy() and 20.7 or timers[args.spellId][ablatingCount]
	if timer then
		self:Bar(args.spellId, timer, CL.count:format(args.spellName, ablatingCount))
	end
end

--[[ Time Layer 3 ]]--
do
	local playerList = mod:NewTargetList()
	function mod:PermeliativeTorment(args)
		if self:Me(args.destGUID) then
			local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
			local t = expires - GetTime()
			self:TargetBar(args.spellId, t, args.destName)
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Important", "Alarm")
			tormentCount = tormentCount + 1
			local timer = timers[args.spellId][tormentCount]
			if timer then
				self:Bar(args.spellId, timer, CL.count:format(args.spellName, tormentCount))
			end
		end
	end
end

function mod:ConflexiveBurst(args)
	conflexiveBurstCount = conflexiveBurstCount + 1
	local timer = timers[209597][conflexiveBurstCount] or self:Normal() and 10
	if timer then
		self:Bar(209597, timer, CL.count:format(args.spellName, conflexiveBurstCount))
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:ConflexiveBurstApplied(args)
		if self:Me(args.destGUID) then
			self:Flash(209597)
			self:Say(209597)
			-- Need to constantly update because of fast/slow time
			--local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
			--local t = expires - GetTime()
			--self:TargetBar(209597, t, args.destName)
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, 209597, playerList, "Important", "Alarm")
		end
	end
end

function mod:AblativePulse(args)
	self:Message(args.spellId, "Important", "Alert", CL.casting:format(args.spellName))
end

function mod:Ablated(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 4 and "Warning")
end
