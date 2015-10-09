
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Xhul'horac", 1026, 1447)
if not mod then return end
mod:RegisterEnableMob(93068)
mod.engageId = 1800
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local felAndVoid = nil
local blackHoleCount = 1
local impCount = 1
local mobCollector = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.killed = "%s killed!"

	L.imps, L.imps_desc, L.imps_icon = -11694, 186532, "spell_shadow_summonimp"
	L.voidfiend, L.voidfiend_desc, L.voidfiend_icon = -11714, 188939, "spell_shadow_summonvoidwalker"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Phase 1 ]]--
		{190223, "TANK"}, -- Fel Strike
		{186407, "SAY", "PROXIMITY", "FLASH"}, -- Fel Surge
		{186453, "TANK_HEALER"}, -- Felblaze Flurry
		{186490, "SAY", "FLASH"}, -- Chains of Fel
		--[[ Phase 2 ]]--
		{190224, "TANK"}, -- Void Strike
		{186333, "SAY", "PROXIMITY", "FLASH"}, -- Void Surge
		{186783, "TANK_HEALER"}, -- Withering Gaze
		186546, -- Black Hole
		--[[ Phase 4 ]]--
		187204, -- Overwhelming Chaos
		--[[ General ]]--
		186134, -- Feltouched
		186135, -- Voidtouched
		186073, -- Felsinged
		186063, -- Wasting Void
		"imps", -- Wild Pyromaniac
		"voidfiend", -- Unstable Voidfiend
		"stages",
	}, {
		[190223] = CL.phase:format(1),
		[190224] = CL.phase:format(2),
		[187204] = CL.phase:format(4),
		[186134] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Touched", 186134, 186135) -- Feltouched, Voidtouched
	self:Log("SPELL_AURA_REFRESH", "Touched", 186134, 186135) -- Feltouched, Voidtouched
	self:Log("SPELL_AURA_APPLIED", "Felsinged_WastingVoid", 186073, 186063) -- Felsinged, Wasting Void
	self:Log("SPELL_AURA_APPLIED_DOSE", "Felsinged_WastingVoid", 186073, 186063) -- Felsinged, Wasting Void
	self:Log("SPELL_AURA_APPLIED", "Surge", 186407, 186333) -- Fel Surge, Void Surge
	self:Log("SPELL_AURA_REMOVED", "SurgeRemoved", 186407, 186333) -- Fel Surge, Void Surge
	self:Log("SPELL_CAST_START", "ChainsOfFelCast", 186490, 189775) -- Normal, Empowered
	self:Log("SPELL_AURA_APPLIED", "ChainsOfFel", 186500, 189777) -- Normal, Empowered
	self:Log("SPELL_CAST_SUCCESS", "FelblazeFlurry", 186453)
	self:Log("SPELL_CAST_SUCCESS", "WitheringGaze", 186783)
	self:Log("SPELL_CAST_START", "FelStrike", 190223)
	self:Log("SPELL_CAST_START", "VoidStrike", 190224)
	self:Log("SPELL_CAST_SUCCESS", "Striked", 186271, 186292) -- Fel, Void
	self:Log("SPELL_AURA_APPLIED", "OverwhelmingChaos", 187204)
	self:Log("SPELL_AURA_APPLIED_DOSE", "OverwhelmingChaos", 187204)
	self:Log("SPELL_CAST_START", "BlackHole", 186546, 189779) -- Normal, Empowered
	self:Log("SPELL_CAST_START", "FelOrb", 186532)
	self:Log("SPELL_CAST_START", "Voidstep", 188939)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Death("AkkelionDies", 94185) -- Vanguard Akkelion
	self:Death("OmnusDies", 94239) -- Omnus
end

function mod:OnEngage()
	felAndVoid = nil
	blackHoleCount = 1
	wipe(mobCollector)
	self:CDBar(190223, 8) -- Fel Strike
	self:CDBar(186407, 19) -- Fel Surge 19-24
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 190306 then -- Activate Fel Portal
		impCount = 1
		self:Bar("imps", 12, CL.count:format(self:SpellName(L.imps), impCount), L.imps_icon)

	elseif spellId == 187196 then -- Fel Feedback (Vanguard Akkelion Spawned)
		self:Message("stages", "Neutral", "Info", "90% - ".. CL.spawned:format(self:SpellName(-11691)), false)
		self:CDBar(186490, self:Mythic() and 57 or 33) -- Chains of Fel, to _start
		self:CDBar(186453, 12) -- Felblaze Flurry

	elseif spellId == 190307 then -- Activate Void Portal (Phase 2)
		self:Bar("voidfiend", 14.5, L.voidfiend, L.voidfiend_icon)
		if not self:Mythic() then
			self:StopBar(190223) -- Fel Strike
			self:StopBar(186407) -- Fel Surge

			self:Message("stages", "Neutral", "Info", "65% - ".. CL.phase:format(2), false)
			self:CDBar(190224, 17) -- Void Strike
			self:CDBar(186333, 24) -- Void Surge
		else
			felAndVoid = true -- both portals up
			self:Message("stages", "Neutral", "Info", "85% - ".. CL.phase:format(2), false)
		end

	elseif spellId == 189806 then -- Void Feedback (Omnus Spawned)
		if not self:Mythic() then
			self:Message("stages", "Neutral", "Info", "60% - ".. CL.spawned:format(self:SpellName(-11688)), false)
		else
			self:Message("stages", "Neutral", "Info", "80% - ".. CL.spawned:format(self:SpellName(-11688)), false)
		end
		self:CDBar(186546, 18) -- Black Hole
		self:CDBar(186783, 6) -- Withering Gaze

	elseif spellId == 189047 then -- Shadowfel Phasing (Phase 3)
		felAndVoid = true
		if not self:Mythic() then
			self:StopBar(190224) -- Void Strike
			self:StopBar(186333) -- Void Surge

			self:Message("stages", "Neutral", "Info", "35% - ".. CL.phase:format(3), false)
			-- Void Strike comes soon after (1-3s), then he switches to fel
			self:CDBar(186407, 6) -- Fel Surge
		end

	elseif spellId == 187209 then -- Overwhelming Chaos (cast to gain the p4 buff, which just stacks on its own)
		self:UnregisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", unit)
		self:StopBar(CL.count:format(self:SpellName(L.imps), impCount))
		self:StopBar(L.voidfiend)
		self:StopBar(190223) -- Fel Strike
		self:StopBar(186407) -- Fel Surge
		self:StopBar(190224) -- Void Strike
		self:StopBar(186333) -- Void Surge

		self:Message("stages", "Neutral", "Info", "20% - ".. spellName, false)
		self:Bar(187204, 10) -- Overwhelming Chaos
	end
end

function mod:AkkelionDies(args)
	self:StopBar(186453) -- Felblaze Flurry
	self:StopBar(186490) -- Chains of Fel
	if self:Mythic() then
		self:Message("stages", "Neutral", "Info", "50% - ".. L.killed:format(args.destName), false)
		self:CDBar(186490, 27.5) -- (Empowered) Chains of Fel
	end
end

function mod:OmnusDies(args)
	self:StopBar(186783) -- Withering Gaze
	self:StopBar(186546) -- Black Hole
	if self:Mythic() then
		self:Message("stages", "Neutral", "Info", "40% - ".. L.killed:format(args.destName), false)
		self:CDBar(186546, 21) -- (Empowered) Black Hole
		self:CDBar(186490, 27.5) -- (Empowered) Chains of Fel
	end
end

do
	local prev = 0
	function mod:FelOrb(args)
		if not mobCollector[args.sourceGUID] then
			mobCollector[args.sourceGUID] = true
			local t = GetTime()
			if t-prev > 1 then
				prev = t
				impCount = impCount + 1
				self:CDBar("imps", 22, CL.count:format(self:SpellName(L.imps), impCount), L.imps_icon)
			end
		end
	end
end

do
	local prev = 0
	function mod:Voidstep(args)
		if not mobCollector[args.sourceGUID] then
			mobCollector[args.sourceGUID] = true
			local t = GetTime()
			if t-prev > 1 then
				prev = t
				self:CDBar("voidfiend", 24, L.voidfiend, L.voidfiend_icon) -- circles spawn around ~24s, adds land after another 3.5s
			end
		end
	end
end

do
	local prev = 0
	function mod:Touched(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 8 then -- Fire lasts 8 sec and keeps refreshing touched
				prev = t
				self:Message(args.spellId, "Personal", not self:Tank() and "Long", CL.you:format(args.spellName))
			end
		end
	end
end

function mod:Felsinged_WastingVoid(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, args.destName, args.amount, "Personal")
	end
end

do
	local list = mod:NewTargetList()
	function mod:Surge(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Attention", "Alarm")
			if not felAndVoid then
				self:CDBar(args.spellId, 30)
			else -- alternates
				if args.spellId == 186407 then -- Fel Surge
					self:CDBar(186333, 10) -- Void Surge
				else -- Void Surge
					self:CDBar(186407, 20) -- Fel Surge
				end
			end
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:OpenProximity(args.spellId, 10) -- Open to debate
			self:Flash(args.spellId)
		end
	end
end

function mod:SurgeRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

function mod:FelStrike(args)
	self:Message(args.spellId, "Urgent", nil, CL.casting:format(args.spellName))
	if not felAndVoid then
		self:CDBar(args.spellId, 16) -- 15.8
	else -- alternates
		self:PlaySound(args.spellId, "Warning")
		self:CDBar(190224, 8) -- Void Strike
	end
end

function mod:VoidStrike(args)
	self:Message(args.spellId, "Urgent", nil, CL.casting:format(args.spellName))
	if not felAndVoid then
		self:CDBar(args.spellId, 17) -- 17.1/18.2
	else -- alternates
		self:PlaySound(args.spellId, "Warning")
		self:CDBar(190223, 7) -- Fel Strike
	end
end

function mod:Striked(args)
	if felAndVoid and not self:Me(args.destGUID) then
		local spellId = args.spellId == 186271 and 190223 or 190224 -- 186271 -> 190223 (Fel), 186292 -> 190224 (Void)
		self:TargetMessage(spellId, args.destName, "Attention")
		if self:Tank() then -- don't spam long for non-tanks that enable strike
			self:PlaySound(spellId, "Long")
		end
	end
end

function mod:FelblazeFlurry(args)
	self:TargetMessage(args.spellId, args.destName, "Important")
	self:CDBar(args.spellId, 17)
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(186490, name, "Urgent", "Alert", CL.casting:format(self:SpellName(184656))) -- 184656 = "Chains"
		if self:Me(guid) then
			self:Say(186490, 184656) -- 184656 = "Chains"
			self:Flash(186490) -- Flash for cast only
		end
	end
	function mod:ChainsOfFelCast(args)
		self:GetBossTarget(printTarget, 0.3, args.sourceGUID)
		self:CDBar(186490, args.spellId == 186490 and 33 or 30)
	end
end

do
	local list = mod:NewTargetList()
	function mod:ChainsOfFel(args)
		if self:Me(args.destGUID) then
			self:Say(186490, 184656) -- 184656 = "Chains"
		end
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, 186490, list, "Urgent", "Alarm", 184656, 186490) -- 184656 = "Chains"
		end
	end
end

function mod:WitheringGaze(args)
	self:TargetMessage(args.spellId, args.destName, "Important")
	self:Bar(args.spellId, 24.3)
end

function mod:BlackHole(args)
	self:Message(186546, "Urgent", "Alert", CL.incoming:format(CL.count:format(self:SpellName(186546), blackHoleCount)))
	blackHoleCount = blackHoleCount + 1
	self:CDBar(186546, args.spellId == 189779 and 30 or blackHoleCount % 2 == 0 and 30 or 40, CL.count:format(args.spellName, blackHoleCount)) -- 30, 40, 30 is as long a p2 as i've seen
end

function mod:OverwhelmingChaos(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Important")
	self:Bar(args.spellId, 10, CL.count:format(args.spellName, amount + 1))
end

