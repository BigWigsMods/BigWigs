--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Dausegne, the Fallen Oracle", 2481, 2459)
if not mod then return end
mod:RegisterEnableMob(184529) -- Dausegne - IGC <The Fallen Oracle> XXX Might be wrong? no other npc on wowhead.
mod:SetEncounterID(2540)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local barrageCount = 1
local coreCount = 1
local arcCount = 1
local haloCount = 1
local siphonCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.staggering_barrage = "Barrage" -- Staggering Barrage
	L.domination_core = "Core" -- Domination Core
	L.obliteration_arc = "Arc" -- Obliteration Arc
	L.disintergration_halo = "Rings" -- Disintegration Halo
	L.siphon_reservoir = "Siphon" -- Siphon Reservoir
end

--------------------------------------------------------------------------------
-- Initialization
--

local staggeringBarrageMarker = mod:AddMarkerOption(false, "player", 1, 361018, 1, 2, 3) -- Staggering Barrage
function mod:GetOptions()
	return {
		361966, -- Infused Strikes
		{361018, "SAY_COUNTDOWN", "SAY"}, -- Staggering Barrage
		staggeringBarrageMarker,
		359483, -- Domination Core
		361225, -- Encroaching Dominion
		363607, -- Domination Bolt
		361513, -- Obliteration Arc
		363200, -- Disintegration Halo
		361643, -- Siphon Reservoir
		--361651, -- Siphoned Barrier XXX Infobox with shield amount?
		365418, -- Total Dominion
	},{
		[361966] = -24104 -- The Fallen Oracle
	},{
		[361018] = L.staggering_barrage, -- Staggering Barrage (Barrage)
		[359483] = L.domination_core, -- Domination Core (Core)
		[361513] = L.obliteration_arc,  -- Obliteration Arc (Arc)
		[363200] = L.disintergration_halo,  -- Disintegration Halo (Rings)
		[361643] = L.siphon_reservoir,  -- Siphon Reservoir (Siphon)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "InfusedStrikesApplied", 361966)
	self:Log("SPELL_AURA_APPLIED_DOSE", "InfusedStrikesApplied", 361966)
	self:Log("SPELL_AURA_REMOVED", "InfusedStrikesRemoved", 361966)
	--self:Log("SPELL_CAST_SUCCESS", "StaggeringBarrage", 360959)
	self:Log("SPELL_AURA_APPLIED", "StaggeringBarrageApplied", 361018)
	self:Log("SPELL_AURA_REMOVED", "StaggeringBarrageRemoved", 361018)
	self:Log("SPELL_CAST_START", "DominationCore", 359483)
	self:Log("SPELL_CAST_START", "DominationBolt", 363607)
	self:Log("SPELL_CAST_START", "ObliterationArc", 361513)
	self:Log("SPELL_CAST_SUCCESS", "DisintegrationHalo", 363200) -- XXX !!Likely wrong trigger!!
	self:Log("SPELL_CAST_START", "SiphonReservoir", 361643)
	--self:Log("SPELL_AURA_APPLIED", "SiphonedBarrierApplied", 361651)
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
	siphonCount = 1

	-- self:Bar(361018, 10, CL.count:format(L.staggering_barrage, barrageCount)) -- Staggering Barrage
	-- self:Bar(359483, 10, CL.count:format(L.domination_core, coreCount)) -- Domination Core
	-- self:Bar(361513, 10, CL.count:format(L.obliteration_arc, arcCount)) -- Obliteration Arc
	-- self:Bar(363200, 10, CL.count:format(L.disintergration_halo, haloCount)) -- Disintegration Halo
	-- self:Bar(361643, 10, CL.count:format(L.siphon_reservoir, siphonCount)) -- Siphon Reservoir
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

do
	local playerList = {}
	local prev = 0
	function mod:StaggeringBarrageApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
			-- self:StopBar(CL.count:format(L.staggering_barrage, barrageCount))
			barrageCount = barrageCount + 1
			-- self:Bar(args.spellId, 10, CL.count:format(L.staggering_barrage, barrageCount))
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Yell(args.spellId, L.staggering_barrage)
			self:YellCountdown(args.spellId, 8)
		else
			self:PlaySound(args.spellId, "alert")
		end
		self:TargetMessage(args.spellId, "orange", args.destName, CL.count:format(L.staggering_barrage, barrageCount-1))
		self:CustomIcon(staggeringBarrageMarker, args.destName, count)
	end

	function mod:StaggeringBarrageRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelYellCountdown(args.spellId)
		end
		self:CustomIcon(staggeringBarrageMarker, args.destName)
	end
end

function mod:DominationCore(args)
	self:Message(args.spellId, "yellow", CL.incoming:format(CL.count:format(L.domination_core, coreCount)))
	self:PlaySound(args.spellId, "long")
	coreCount = coreCount + 1
	-- self:Bar(args.spellId, 10, CL.count:format(L.domination_core, coreCount))
end

function mod:DominationBolt(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "info")
		end
	end
end

function mod:ObliterationArc(args)
	self:Message(args.spellId, "yellow", CL.count:format(L.obliteration_arc, arcCount))
	self:PlaySound(args.spellId, "alert")
	arcCount = arcCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(L.obliteration_arc, arcCount))
end

function mod:DisintegrationHalo(args)
	self:Message(args.spellId, "orange", CL.incoming:format(CL.count:format(L.disintergration_halo, arcCount)))
	self:PlaySound(args.spellId, "long")
	haloCount = haloCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(L.disintergration_halo, haloCount))
end

function mod:SiphonReservoir(args)
	self:Message(args.spellId, "cyan", CL.count:format(L.siphon_reservoir, siphonCount))
	self:PlaySound(args.spellId, "info")
	siphonCount = siphonCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(L.disintergration_halo, siphonCount))
end

function mod:SiphonedBarrierRemoved(args)
	self:Message(args.spellId, "green", CL.removed:format(args.spellName))
	self:PlaySound(args.spellId, "info")
	-- XXX Do we reset here? Back to "stage 1"?
	-- barrageCount = 1
	-- coreCount = 1
	-- arcCount = 1
	-- haloCount = 1
	-- siphonCount = 1

	-- self:Bar(361018, 10, CL.count:format(L.staggering_barrage, barrageCount)) -- Staggering Barrage
	-- self:Bar(359483, 10, CL.count:format(L.domination_core, coreCount)) -- Domination Core
	-- self:Bar(361513, 10, CL.count:format(L.obliteration_arc, arcCount)) -- Obliteration Arc
	-- self:Bar(363200, 10, CL.count:format(L.disintergration_halo, haloCount)) -- Disintegration Halo
	-- self:Bar(361643, 10, CL.count:format(L.siphon_reservoir, siphonCount)) -- Siphon Reservoir
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
