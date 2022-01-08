if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Dausegne, the Fallen Oracle", 2481, 2459)
if not mod then return end
mod:RegisterEnableMob(181224) -- Dausegne
mod:SetEncounterID(2540)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local barrageCount = 1
local coreCount = 1
local arcCount = 1
local haloCount = 1
local haloTimer = nil
local siphonCount = 1
local nextSiphon = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.staggering_barrage = "Barrage" -- Staggering Barrage
	L.domination_core = "Add" -- Domination Core
	L.obliteration_arc = "Arc" -- Obliteration Arc

	L.disintergration_halo = "Rings" -- Disintegration Halo
	L.rings_x = "Rings x%d"
	L.ring_count = "Ring (%d/%d)"

	L.siphon_reservoir = "Teleport" -- Siphon Reservoir
	L.absorb_text = "%s (%.0f%%)"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		361966, -- Infused Strikes
		{361018, "ICON", "SAY_COUNTDOWN", "SAY"}, -- Staggering Barrage
		359483, -- Domination Core
		361225, -- Encroaching Dominion
		--363607, -- Domination Bolt
		361513, -- Obliteration Arc
		363200, -- Disintegration Halo
		361643, -- Siphon Reservoir
		{361651, "INFOBOX"}, -- Siphoned Barrier
		365418, -- Total Dominion
	},nil,{
		[361018] = L.staggering_barrage, -- Staggering Barrage (Barrage)
		[359483] = L.domination_core, -- Domination Core (Add)
		[361513] = L.obliteration_arc,  -- Obliteration Arc (Arc)
		[363200] = L.disintergration_halo,  -- Disintegration Halo (Rings)
		[361643] = L.siphon_reservoir,  -- Siphon Reservoir (Teleport)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "InfusedStrikesApplied", 361966)
	self:Log("SPELL_AURA_APPLIED_DOSE", "InfusedStrikesApplied", 361966)
	self:Log("SPELL_AURA_REMOVED", "InfusedStrikesRemoved", 361966)
	self:Log("SPELL_AURA_APPLIED", "StaggeringBarrageApplied", 361018)
	self:Log("SPELL_AURA_REMOVED", "StaggeringBarrageRemoved", 361018)
	self:Log("SPELL_CAST_START", "DominationCore", 359483)
	--self:Log("SPELL_CAST_START", "DominationBolt", 363607)
	self:Log("SPELL_CAST_START", "ObliterationArc", 361513)
	--self:Log("SPELL_CAST_SUCCESS", "DisintegrationHalo", 363200) -- XXX Emote
	self:Log("SPELL_AURA_APPLIED", "SiphonReservoir", 361643)
	self:Log("SPELL_AURA_APPLIED", "SiphonedBarrierApplied", 361651)
	self:Log("SPELL_AURA_REMOVED", "SiphonedBarrierRemoved", 361651)
	self:Log("SPELL_CAST_START", "TotalDominion", 365418)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 361225) -- Encroaching Dominion
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 361225)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 361225)

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER") -- Disintegration Halo
end

function mod:OnEngage()
	barrageCount = 1
	coreCount = 1
	arcCount = 1
	haloCount = 1
	siphonCount = 1
	nextSiphon = GetTime() + 72.5

	self:Bar(359483, 6.5, CL.count:format(L.domination_core, coreCount)) -- Domination Core
	self:Bar(363200, 12.5, CL.count:format(L.rings_x:format(siphonCount), haloCount)) -- Disintegration Halo (emote at 5, ring at ~13)
	self:Bar(361513, 15, CL.count:format(L.obliteration_arc, arcCount)) -- Obliteration Arc
	self:Bar(361018, 29, CL.count:format(L.staggering_barrage, barrageCount)) -- Staggering Barrage
	self:Bar(361643, 72.5, CL.count:format(L.siphon_reservoir, siphonCount)) -- Siphon Reservoir
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:InfusedStrikesApplied(args)
	if self:Tank() then
		local amount = args.amount or 1
		if amount % 2 == 0 and amount > 8 then -- XXX Finetune
			self:NewStackMessage(args.spellId, "purple", args.destName, amount, 5)
			if amount > 15 and not self:Tanking("boss1") then
				self:PlaySound(args.spellId, "alarm")
			end
		end
	end
	self:TargetBar(args.spellId, 20, args.destName, CL.bomb)
end

function mod:InfusedStrikesRemoved(args)
	self:StopBar(args.spellId, args.destName)
end

function mod:StaggeringBarrageApplied(args)
	self:TargetMessage(args.spellId, "orange", args.destName, CL.count:format(L.staggering_barrage, barrageCount))
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Yell(args.spellId, L.staggering_barrage)
		self:YellCountdown(args.spellId, 8)
	else
		self:PlaySound(args.spellId, "alert")
	end
	self:SecondaryIcon(args.spellId, args.destName)

	barrageCount = barrageCount + 1
	local cd = 35
	if barrageCount < 4 and nextSiphon > GetTime() + cd then -- 3 per rotation, except first
		self:Bar(361018, cd, CL.count:format(L.staggering_barrage, barrageCount))
	end
end

function mod:StaggeringBarrageRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelYellCountdown(args.spellId)
	end
	self:SecondaryIcon(args.spellId, nil)
end

function mod:DominationCore(args)
	self:Message(args.spellId, "yellow", CL.incoming:format(CL.count:format(L.domination_core, coreCount)))
	self:PlaySound(args.spellId, "long")
	coreCount = coreCount + 1
	local cd = coreCount == 2 and 33.5 or 35.5
	if coreCount < 4 and nextSiphon > GetTime() + cd then -- 3 per rotation, except first
		self:Bar(args.spellId, cd, CL.count:format(L.domination_core, coreCount))
	end
end

-- function mod:DominationBolt(args)
-- 	local canDo, ready = self:Interrupter(args.sourceGUID)
-- 	if canDo then
-- 		self:Message(args.spellId, "yellow")
-- 		if ready then
-- 			self:PlaySound(args.spellId, "info")
-- 		end
-- 	end
-- end

function mod:ObliterationArc(args)
	self:Message(args.spellId, "yellow", CL.count:format(L.obliteration_arc, arcCount))
	self:PlaySound(args.spellId, "alert")
	arcCount = arcCount + 1
	local cd = 35
	if arcCount < 4 and nextSiphon > GetTime() + cd then -- 3 per rotation, except first
		self:Bar(args.spellId, cd, CL.count:format(L.obliteration_arc, arcCount))
	end
end

function mod:CHAT_MSG_RAID_BOSS_WHISPER(_, msg)
	if msg:find("spell:365373") then -- Disintegration Halo
		self:Message(363200, "orange", CL.soon:format(CL.count:format(L.rings_x:format(siphonCount), haloCount)))
		self:PlaySound(363200, "info")
		-- Start timers for subsequent rings (first after ~8s, then ~6s)
		self:Bar(363200, 7.5, CL.count:format(L.rings_x:format(siphonCount), haloCount))
		if haloCount < 3 then -- don't need bars for the spam at the end
			for i = 2, siphonCount do
				local delay = 7.5 + (5.5 * (i-2))
				self:ScheduleTimer("Bar", delay, 363200, 5.5, L.ring_count:format(i,siphonCount))
			end
		end
		haloCount = haloCount + 1
		-- Delayed message for when the first ring triggers (hopefully these get proper events)
		haloTimer = self:ScheduleTimer(function()
			self:Message(363200, "orange", CL.count:format(L.rings_x:format(siphonCount), haloCount-1))
			self:PlaySound(363200, "long")
			if siphonCount > 1 and haloCount < 3 then -- 2 per rotation, except first
				self:Bar(363200, 70, CL.count:format(L.rings_x:format(siphonCount), haloCount))
			elseif siphonCount == 4 and haloCount == 3 then -- shorter cd, then triggers infinite rings
				self:Bar(363200, 35, CL.count:format(L.rings_x:format(666), haloCount))
			end
		end, 7.5)
	end
end

function mod:SiphonReservoir(args)
	-- clean up anything we messed up
	self:StopBar(CL.count:format(L.rings_x:format(siphonCount), haloCount)) -- Disintegration Halo
	self:StopBar(CL.count:format(L.domination_core, coreCount)) -- Domination Core
	self:StopBar(CL.count:format(L.obliteration_arc, arcCount)) -- Obliteration Arc
	self:StopBar(CL.count:format(L.staggering_barrage, barrageCount)) -- Staggering Barrage
	self:StopBar(CL.count:format(L.siphon_reservoir, siphonCount)) -- Siphon Reservoir
	self:CancelTimer(haloTimer)
	for i = 2, siphonCount do
		self:StopBar(L.ring_count:format(i))
	end

	self:Message(args.spellId, "cyan", CL.count:format(L.siphon_reservoir, siphonCount))
	self:PlaySound(args.spellId, "info")
	siphonCount = siphonCount + 1
end

do
	local timer, maxAbsorb = nil, 0
	local function updateInfoBox(self)
		local absorb = UnitGetTotalAbsorbs("boss1")
		local absorbPercentage = absorb / maxAbsorb
		self:SetInfoBar(361651, 1, absorbPercentage)
		self:SetInfo(361651, 2, L.absorb_text:format(self:AbbreviateNumber(absorb), absorbPercentage * 100))
	end

	function mod:SiphonedBarrierApplied(args)
		if self:CheckOption(args.spellId, "INFOBOX") then
			self:OpenInfo(args.spellId, args.spellName)
			self:SetInfoBar(args.spellId, 1, 1)
			self:SetInfo(args.spellId, 1, _G.ABSORB)
			maxAbsorb = args.amount
			timer = self:ScheduleRepeatingTimer(updateInfoBox, 0.1, self)
		end
	end

	function mod:SiphonedBarrierRemoved(args)
		self:CloseInfo(args.spellId)
		if timer then
			self:CancelTimer(timer)
			timer = nil
		end

		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
		barrageCount = 1
		coreCount = 1
		arcCount = 1
		haloCount = 1

		self:Bar(359483, 8, CL.count:format(L.domination_core, coreCount)) -- Domination Core
		self:Bar(363200, 14, CL.count:format(L.rings_x:format(siphonCount), haloCount)) -- Disintegration Halo (emote at 6.5 + 7.5 for activation)
		self:Bar(361513, 16.5, CL.count:format(L.obliteration_arc, arcCount)) -- Obliteration Arc
		self:Bar(361018, 30.5, CL.count:format(L.staggering_barrage, barrageCount)) -- Staggering Barrage

		nextSiphon = GetTime() + 110.5
		self:Bar(361643, 110.5, CL.count:format(L.siphon_reservoir, siphonCount)) -- Siphon Reservoir
	end
end

function mod:TotalDominion(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
