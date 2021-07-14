--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Soulrender Dormazain", 2450, 2445)
if not mod then return end
mod:RegisterEnableMob(175727, 175728) -- Soulrender Dormazain, Garrosh Hellscream
mod:SetEncounterID(2434)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local timersHeroic = {
	[350411] = {80.5, 162, 96.4, 60, 90}, -- Hellscream _START
	[350615] = {28.5, 162.5, 60, 94, 61, 101}, -- Call Mawsworn _START
	[350217] = {12, 45.5, 45.5, 69.8, 43.9, 44.1, 63, 44, 44, 82.5}, -- Torment
	[350422] = {10.7, 33, 33, 41, 54, 33, 33, 37, 60, 33, 41.5, 87.6}, -- Ruinblade _START (4/5 vary by a few seconds)
}

local timersMythic = {
	[350411] = {55.5, 164.0, 43.0, 65, 55, 40, 60}, -- Hellscream _START
	[350615] = {28.5, 162.5, 60, 94, 61, 101}, -- Call Mawsworn _START
	[350217] = {12, 45.5, 45.5, 65.5, 33, 33, 30, 50, 30}, -- Torment
	[350422] = {10.7, 33, 33, 41, 54, 33, 33, 37, 60, 33, 41.5, 87.6}, -- Ruinblade _START (4/5 vary by a few seconds)
}

local brandCount = 1
local callMawswornCount = 1
local ruinbladeCount = 1
local hellscreamCount = 1
local chainCount = 3
local encoreOfTormentCount = 1
local tormentCount = 1
local mobCollector = {}

local timers = mod:Mythic() and timersMythic or timersHeroic

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_off_nameplate_defiance = "Defiance Nameplate Icon"
	L.custom_off_nameplate_defiance_desc = "Show an icon on the nameplate of Mawsworn that have Defiance.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."
	L.custom_off_nameplate_defiance_icon = 351773

	L.custom_off_nameplate_tormented = "Tormented Nameplate Icon"
	L.custom_off_nameplate_tormented_desc = "Show an icon on the nameplate of Mawsworn that have Tormented.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."
	L.custom_off_nameplate_tormented_icon = 350649

	L.cones = "Cones" -- Torment
	L.dance = "Dance" -- Tormented Eruptions
	L.brands = "Brands" -- Brand of Torment
	L.brand = "Brand" -- Single Brand of Torment
	L.spike = "Spike" -- Short for Agonizing Spike
	L.chains = "Chains" -- Hellscream
	L.chain = "Chain" -- Soul Manacles
	L.souls = "Souls" -- Rendered Soul

	L.overlord = "Mawsworn Overlord" -- Mawsworn Overlord 

	L.chains_remaining = "%d Chains remaining"
	L.all_broken = "All Chains broken"
end

--------------------------------------------------------------------------------
-- Initialization
--


local brandOfTormentMarker = mod:AddMarkerOption(false, "player", 1, 350647, 1, 2) -- Brand of Torment
local agonizerMarker = mod:AddMarkerOption(false, "npc", 8, -23289, 8, 7, 6, 5) -- Mawsworn Agonizer
function mod:GetOptions()
	return {
		350217, -- Torment
		349985, -- Tormented Eruptions
		{350647, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Brand of Torment
		brandOfTormentMarker,
		"custom_off_nameplate_tormented",
		{350422, "TANK"}, -- Ruinblade
		350615, -- Call Mawsworn
		agonizerMarker,
		351779, -- Agonizing Spike
		350650, -- Defiance
		"custom_off_nameplate_defiance",
		350411, -- Hellscream
		354231, -- Soul Manacles
		351229, -- Rendered Soul
		353554, -- Mythic Overlord Spawn Timer
	},{
	},{
		[350217] = L.cones, -- Torment (Cones)
		[349985] = L.dance, -- Tormented Eruptions (Dance)
		[350647] = L.brands, -- Brand of Torment (Brands)
		[350615] = CL.adds, -- Call Mawsworn (Adds)
		[351779] = L.spike, -- Agonizing Spike (Spike)
		[350411] = L.chains, -- Hellscream (Chains)
		[354231] = L.chain, -- Soul Manacles (Chain)
		[351229] = L.souls, -- Rendered Soul (Souls)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss2") -- for Pain
	-- self:Log("SPELL_CAST_SUCCESS", "Pain", 350766) -- Alternative for Torment
	self:Log("SPELL_CAST_SUCCESS", "TormentedEruptions", 349985)
	self:Log("SPELL_CAST_SUCCESS", "BrandOfTorment", 350648)
	self:Log("SPELL_AURA_APPLIED", "BrandOfTormentApplied", 350647)
	self:Log("SPELL_AURA_REMOVED", "BrandOfTormentRemoved", 350647)
	self:Log("SPELL_AURA_APPLIED", "TormentedApplied", 350649)
	self:Log("SPELL_AURA_REMOVED", "TormentedRemoved", 350649)
	self:Log("SPELL_CAST_SUCCESS", "Ruinblade", 350422)
	self:Log("SPELL_AURA_APPLIED", "RuinbladeApplied", 350422)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RuinbladeApplied", 350422)
	self:Log("SPELL_CAST_START", "CallMawsworn", 350615)
	self:Log("SPELL_CAST_START", "AgonizingSpike", 351779)
	self:Log("SPELL_AURA_APPLIED", "GarroshDefianceApplied", 350650) -- Buff they get when reaching Garrosh, not from the Overlord
	self:Log("SPELL_AURA_APPLIED", "DefianceApplied", 351773) -- Overlord buff
	self:Log("SPELL_AURA_REMOVED", "DefianceRemoved", 351773)
	self:Log("SPELL_CAST_START", "Hellscream", 350411)
	self:Log("SPELL_AURA_REMOVED_DOSE", "WarmongersShacklesRemovedDose", 350415)
	self:Log("SPELL_AURA_REMOVED", "WarmongersShacklesRemoved", 350415)
	self:Log("SPELL_AURA_APPLIED", "SoulManacles", 354231)

	-- XXX Ground damage for Vessel and Cones

	if self:GetOption("custom_off_nameplate_defiance") or self:GetOption("custom_off_nameplate_tormented") then
		self:ShowPlates()
	end
end

function mod:OnEngage()
	callMawswornCount = 1
	ruinbladeCount = 1
	hellscreamCount = 1
	encoreOfTormentCount = 1
	tormentCount = 1
	brandCount = 1
	mobCollector = {}
	timers = self:Mythic() and timersMythic or timersHeroic

	self:Bar(350422, timers[350422][ruinbladeCount]) -- Ruinblade
	self:Bar(350217, timers[350217][tormentCount], CL.count:format(L.cones, tormentCount)) -- Torment
	self:Bar(350615, timers[350615][callMawswornCount], CL.count:format(CL.adds, callMawswornCount)) -- Call Mawsworn
	self:Bar(350647, timers[350647][brandCount], CL.count:format(L.brands, brandCount)) -- Brand of Torment
	self:Bar(350411, timers[350411][hellscreamCount], CL.count:format(L.chains, hellscreamCount)) -- Hellscream
	self:Bar(349985, 131.5, CL.count:format(L.dance, encoreOfTormentCount)) -- Tormented Eruptions

	if self:Mythic() then
		self:Berserk(500) --Mythic berserk timing, might be normal/heroic but unknown.
	end

end

function mod:OnBossDisable()
	if self:GetOption("custom_off_nameplate_defiance") or self:GetOption("custom_off_nameplate_tormented") then
		self:HidePlates()
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:RenderedSoul()
		local t = GetTime()
		if t-prev > 10 then
			self:Bar(351229, 5, CL.count:format(L.souls, 1))
			self:ScheduleTimer("Message", 5, 351229, "yellow", CL.count:format(L.souls, 1))
			self:ScheduleTimer("Bar", 5, 351229, 5, CL.count:format(L.souls, 2))
			self:ScheduleTimer("Message", 10, 351229, "yellow", CL.count:format(L.souls, 2))
		else -- Queue up more
			local remaining = 10-(t-prev)
			self:ScheduleTimer("Bar", remaining, 351229, 5, CL.count:format(L.souls, 3))
			self:ScheduleTimer("Message", remaining+5, 351229, "yellow", CL.count:format(L.souls, 3))
			self:ScheduleTimer("Bar", remaining+5, 351229, 5, CL.count:format(L.souls, 4))
			self:ScheduleTimer("Message", remaining+10, 351229, "yellow", CL.count:format(L.souls, 4))
		end
		prev = GetTime()
	end
end

-- XXX Did this use to have a SPELL_CAST_SUCCESS? Wishful thinking?
function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 350766 then
		self:Pain()
	end
end

function mod:Pain() -- Boss casting Torment on Garrosh
	self:Message(350217, "yellow", CL.count:format(L.cones, tormentCount))
	tormentCount = tormentCount + 1
	self:Bar(350217, timers[350217][tormentCount], CL.count:format(L.cones, tormentCount))
	self:RenderedSoul()
end

function mod:TormentedEruptions(args)
	self:Message(args.spellId, "cyan", CL.count:format(L.dance, encoreOfTormentCount))
	self:PlaySound(args.spellId, "alert")
	encoreOfTormentCount = encoreOfTormentCount + 1
	self:Bar(args.spellId, 161.5, CL.count:format(L.dance, encoreOfTormentCount))
	-- XXX Schedule cast bars for each cone / use remaining events on retail

	brandCount = 1
	self:Bar(350647, 33.09, CL.count:format(L.brands, brandCount))
end

do
	local playerList = {}
	function mod:BrandOfTorment(args)
		playerList = {}
		brandCount = brandCount + 1
		if brandCount < 7 then -- breaks during dance
			self:Bar(350647, 15.7, CL.count:format(L.brands, brandCount))
		end
	end

	function mod:BrandOfTormentApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.count:format(L.brand, brandCount-1))
			self:PlaySound(args.spellId, "warning")
			self:SayCountdown(args.spellId, 15)
		end
		self:NewTargetsMessage(args.spellId, "orange", playerList, nil, CL.count:format(L.brand, brandCount-1))
		self:CustomIcon(brandOfTormentMarker, args.destName, count)
	end

	function mod:BrandOfTormentRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(brandOfTormentMarker, args.destName)
	end
end

function mod:TormentedApplied(args)
	if self:GetOption("custom_off_nameplate_tormented") then
		self:AddPlateIcon(args.spellId, args.sourceGUID)
	end
end

function mod:TormentedRemoved(args)
	if self:GetOption("custom_off_nameplate_tormented") then
		self:RemovePlateIcon(args.spellId, args.sourceGUID)
	end
end

function mod:Ruinblade(args)
	ruinbladeCount = ruinbladeCount + 1
	self:Bar(args.spellId, timers[args.spellId][ruinbladeCount] or 33)
end

function mod:RuinbladeApplied(args)
	local amount = args.amount or 1
	self:NewStackMessage(args.spellId, "purple", args.destName, amount)
	self:PlaySound(args.spellId, "alarm")
end

do
	local agonizersMarked = 0
	function mod:AgonizerMarking(event, unit, guid)
		if self:MobId(guid) == 177594 and not mobCollector[guid] then -- Mawsworn Agonizer
			self:CustomIcon(agonizerMarker, unit, 8-agonizersMarked) -- 8, 7, 6, 5
			mobCollector[guid] = true
			agonizersMarked = agonizersMarked + 1
			if agonizersMarked == 4 then -- All 4 marked
				self:UnregisterTargetEvents()
			end
		end
	end

	function mod:CallMawsworn(args)
		self:Message(args.spellId, "yellow", CL.count:format(CL.adds, callMawswornCount))
		self:PlaySound(args.spellId, "info")
		callMawswornCount = callMawswornCount + 1
		self:Bar(args.spellId, timers[args.spellId][callMawswornCount], CL.count:format(CL.adds, callMawswornCount))
		if self:GetOption(agonizerMarker) then
			agonizersMarked = 0
			self:RegisterTargetEvents("AgonizerMarking")
			self:ScheduleTimer("UnregisterTargetEvents", 20)
		end
		if self:Mythic() then
			self:Bar(353554, 7, L.overlord)
		end
	end
end

function mod:AgonizingSpike(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:DefianceApplied(args)
	if self:GetOption("custom_off_nameplate_defiance") then
		self:AddPlateIcon(args.spellId, args.sourceGUID)
	end
end

function mod:DefianceRemoved(args)
	if self:GetOption("custom_off_nameplate_defiance") then
		self:RemovePlateIcon(args.spellId, args.sourceGUID)
	end
end

do
	local prev = 0
	function mod:GarroshDefianceApplied(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:TargetMessage(args.spellId, "orange", args.destName)
		end
	end
end

function mod:Hellscream(args)
	chainCount = 3
	self:Message(args.spellId, "red", L.chains)
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, self:Mythic() and 25 or 35, L.chains)
	hellscreamCount = hellscreamCount + 1
	self:Bar(args.spellId, timers[args.spellId][hellscreamCount], CL.count:format(L.chains, hellscreamCount))
	self:RenderedSoul()
end

function mod:WarmongersShacklesRemovedDose()
	chainCount = chainCount - 1
	self:Message(350411, "green", L.chains_remaining:format(chainCount))
end

function mod:WarmongersShacklesRemoved()
	self:Message(350411, "green", CL.interrupted:format(L.chains))
	self:StopBar(CL.cast:format(L.chains))
end

function mod:SoulManacles(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, L.chain)
		self:PlaySound(args.spellId, "info")
	end
end
