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
local teleportCount = 1
local nextTeleport = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.staggering_barrage = "Barrage" -- Staggering Barrage
	L.obliteration_arc = "Arc" -- Obliteration Arc

	L.disintergration_halo = "Rings" -- Disintegration Halo
	L.rings_x = "Rings x%d"
	L.rings_enrage = "Rings (Enrage)"
	L.ring_count = "Ring (%d/%d)"

	L.custom_on_ring_timers = "Individual Halo Timers"
	L.custom_on_ring_timers_desc = "Disintegration Halo triggers a set of rings, this will show bars for when each of the rings starts moving. Uses settings from Disintegration Halo."
	L.custom_on_ring_timers_icon = 363200

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
		361513, -- Obliteration Arc
		363200, -- Disintegration Halo
		"custom_on_ring_timers",
		361630, -- Teleport
		{361651, "INFOBOX"}, -- Siphoned Barrier
		365418, -- Total Dominion
	},nil,{
		[361018] = L.staggering_barrage, -- Staggering Barrage (Barrage)
		[359483] = CL.add, -- Domination Core (Add)
		[361513] = L.obliteration_arc,  -- Obliteration Arc (Arc)
		[363200] = L.disintergration_halo,  -- Disintegration Halo (Rings)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "InfusedStrikesApplied", 361966)
	self:Log("SPELL_AURA_APPLIED_DOSE", "InfusedStrikesApplied", 361966)
	self:Log("SPELL_AURA_REMOVED", "InfusedStrikesRemoved", 361966)
	self:Log("SPELL_AURA_APPLIED", "StaggeringBarrageApplied", 361018)
	self:Log("SPELL_AURA_REMOVED", "StaggeringBarrageRemoved", 361018)
	self:Log("SPELL_CAST_START", "DominationCore", 359483)
	self:Log("SPELL_CAST_START", "ObliterationArc", 361513)
	self:Log("SPELL_CAST_SUCCESS", "DisintegrationHaloSuccess", 362805)
	self:Log("SPELL_CAST_START", "Teleport", 361630)
	self:Log("SPELL_AURA_APPLIED", "SiphonedBarrierApplied", 361651)
	self:Log("SPELL_AURA_REMOVED", "SiphonedBarrierRemoved", 361651)
	self:Log("SPELL_CAST_START", "TotalDominion", 365418)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 361225) -- Encroaching Dominion
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 361225)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 361225)
end

function mod:OnEngage()
	barrageCount = 1
	coreCount = 1
	arcCount = 1
	haloCount = 1
	teleportCount = 1
	nextTeleport = GetTime() + (self:Easy() and 80 or 72.8)
	self:SetStage(1)

	self:Bar(359483, self:Easy() and 7 or 6.5, CL.count:format(CL.add, coreCount)) -- Domination Core
	self:Bar(363200, self:Easy() and 5.5 or 5, CL.count:format(L.rings_x:format(teleportCount), haloCount)) -- Disintegration Halo (emote at 5, ring at ~13)
	self:Bar(361513, self:Easy() and 16.5 or 15, CL.count:format(L.obliteration_arc, arcCount)) -- Obliteration Arc
	self:Bar(361018, self:Easy() and 32 or 29, CL.count:format(L.staggering_barrage, barrageCount)) -- Staggering Barrage
	self:Bar(361630, self:Easy() and 80 or 72.8, CL.count:format(self:SpellName(361630), teleportCount)) -- Teleport
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local tankTimers = {}
	function mod:InfusedStrikesApplied(args)
		self:CancelTimer(tankTimers[args.destName])
		self:StopBar(CL.bomb, args.destName)
		if self:Tank() then
			local amount = args.amount or 1
			if amount % 2 == 0 and amount > 8 then -- XXX Finetune
				self:NewStackMessage(args.spellId, "purple", args.destName, amount, 5)
				if amount > 15 and not self:Tanking("boss1") then
					self:PlaySound(args.spellId, "alarm")
				end
			end
		end
		tankTimers[args.destName] = self:ScheduleTimer("TargetBar", 10, args.spellId, 10, args.destName, CL.bomb)
	end

	function mod:InfusedStrikesRemoved(args)
		self:StopBar(CL.bomb, args.destName)
		self:CancelTimer(tankTimers[args.destName])
	end
end

function mod:StaggeringBarrageApplied(args)
	self:TargetMessage(args.spellId, "orange", args.destName, CL.count:format(L.staggering_barrage, barrageCount))
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Yell(args.spellId, L.staggering_barrage)
		self:YellCountdown(args.spellId, 8)
	else
		self:PlaySound(args.spellId, "alert", nil, args.destName)
	end
	self:SecondaryIcon(args.spellId, args.destName)

	barrageCount = barrageCount + 1
	local cd = self:Easy() and 38.8 or 35
	if barrageCount < 4 and nextTeleport > GetTime() + cd then -- 3 per rotation, except first
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
	self:Message(args.spellId, "yellow", CL.incoming:format(CL.count:format(CL.add, coreCount)))
	self:PlaySound(args.spellId, "long")
	coreCount = coreCount + 1
	local cd = self:Easy() and (coreCount == 2 and 37.2 or 40.5) or (coreCount == 2 and 33.5 or 36.5)
	if coreCount < 4 and nextTeleport > GetTime() + cd then -- 3 per rotation, except first
		self:Bar(args.spellId, cd, CL.count:format(CL.add, coreCount))
	end
end

function mod:ObliterationArc(args)
	self:Message(args.spellId, "yellow", CL.count:format(L.obliteration_arc, arcCount))
	self:PlaySound(args.spellId, "alert")
	arcCount = arcCount + 1
	local cd = self:Easy() and 38.8 or 35
	if arcCount < 4 and nextTeleport > GetTime() + cd then -- 3 per rotation, except first
		self:Bar(args.spellId, cd, CL.count:format(L.obliteration_arc, arcCount))
	end
end

do
	local ringCount = 1
	function mod:DisintegrationHalo()
		if ringCount == 1 then
			if haloCount == 4 then
				self:Message(363200, "orange", L.rings_enrage)
			else
				self:Message(363200, "orange", CL.count:format(L.rings_x:format(teleportCount), haloCount-1))
			end
			self:PlaySound(363200, "long")
		end
		if ringCount < teleportCount and haloCount < 3 then -- skip enrage rings
			ringCount = ringCount + 1
			self:CDBar(363200, 5.5, L.ring_count:format(ringCount, teleportCount))
			haloTimer = self:ScheduleTimer("DisintegrationHalo", 5.5)
		end
	end

	function mod:DisintegrationHaloSuccess(args)
		self:StopBar(CL.count:format(L.rings_x:format(teleportCount), haloCount))
		self:Message(363200, "orange", CL.soon:format(CL.count:format(L.rings_x:format(teleportCount), haloCount)))
		self:PlaySound(363200, "info")
		haloCount = haloCount + 1
		ringCount = 1
		if teleportCount > 1 and haloCount < 3 then -- 2 per rotation, except first
			self:Bar(363200, self:Easy() and 77.8 or 70, CL.count:format(L.rings_x:format(teleportCount), haloCount))
		elseif teleportCount == 4 and haloCount == 3 then -- enrage, shorter cd, then triggers infinite rings
			--self:Bar(363200, 35, CL.count:format(L.rings_enrage, haloCount)) -- Don't need to show do we?
		end
		if self:GetOption("custom_on_ring_timers") then
			self:Bar(363200, 8.5, L.ring_count:format(ringCount, teleportCount))
			haloTimer = self:ScheduleTimer("DisintegrationHalo", 8.5)
		end
	end
end

function mod:Teleport(args)
	-- clean up anything we messed up
	self:StopBar(CL.count:format(L.rings_x:format(teleportCount), haloCount)) -- Disintegration Halo
	self:StopBar(CL.count:format(CL.add, coreCount)) -- Domination Core
	self:StopBar(CL.count:format(L.obliteration_arc, arcCount)) -- Obliteration Arc
	self:StopBar(CL.count:format(L.staggering_barrage, barrageCount)) -- Staggering Barrage
	self:StopBar(CL.count:format(args.spellName, teleportCount)) -- Teleport
	self:CancelTimer(haloTimer)
	for i = 2, teleportCount do
		self:StopBar(L.ring_count:format(i, teleportCount))
	end

	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, teleportCount))
	self:PlaySound(args.spellId, "info")
	teleportCount = teleportCount + 1
end

do
	local timer, maxAbsorb = nil, 0
	local appliedTime = 0
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
		appliedTime = args.time
	end

	function mod:SiphonedBarrierRemoved(args)
		self:CloseInfo(args.spellId)
		if timer then
			self:CancelTimer(timer)
			timer = nil
		end
		self:SetStage(self:GetStage() + 1)
		self:Message(args.spellId, "green", CL.removed_after:format(args.spellName, args.time - appliedTime))
		self:PlaySound(args.spellId, "info")
		barrageCount = 1
		coreCount = 1
		arcCount = 1
		haloCount = 1

		self:Bar(363200, self:Easy() and 7.5 or 7, CL.count:format(L.rings_x:format(teleportCount), haloCount)) -- Disintegration Halo
		self:Bar(359483, self:Easy() and 9.3 or 8.5, CL.count:format(CL.add, coreCount)) -- Domination Core
		self:Bar(361513, self:Easy() and 18.7 or 17, CL.count:format(L.obliteration_arc, arcCount)) -- Obliteration Arc
		self:Bar(361018, self:Easy() and 34.3 or 31, CL.count:format(L.staggering_barrage, barrageCount)) -- Staggering Barrage

		nextTeleport = GetTime() + (self:Easy() and 121 or 110.2)
		if teleportCount < 4 then -- Only 3 teleports before berserk
			self:Bar(361630, self:Easy() and 121 or 110.2, CL.count:format(self:SpellName(361630), teleportCount)) -- Teleport
		else
			self:Bar(365418, (self:Easy() and 121 or 110.2)) -- Total Domination
		end
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
