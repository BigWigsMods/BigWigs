--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Aberrus, the Shadowed Crucible Trash", 2569)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	198873, -- Sundered Edgelord
	201746, -- Sundered Naturalist
	198874, -- Sundered Siegemaster
	201736, -- Sundered Arcanist
	205656, -- Sundered Chemist
	203939, -- Animation Fluid
	205651, -- Bubbling Slime
	203809, -- Entropic Hatred
	203806 -- Whisper in the Dark
)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	--[[ Pre-Kazzara ]]--
	L.edgelord = "Sundered Edgelord"

	--[[ Kazzara -> Amalgamation Chamber ]]--
	L.naturalist = "Sundered Naturalist"
	L.siegemaster = "Sundered Siegemaster"
	L.banner = "Banner"
	L.arcanist = "Sundered Arcanist"
	L.chemist = "Sundered Chemist"

	--[[ Amalgamation Chamber -> Forgotten Experiments ]]--
	L.fluid = "Animation Fluid"
	L.slime = "Bubbling Slime"
	L.goo = "Crawling Goo"

	--[[ Echo of Neltharion -> Sarkareth ]]--
	L.whisper = "Whisper in the Dark"
end

--------------------------------------------------------------------------------
-- Initialization
--

local bannerMarker = mod:AddMarkerOption(true, "npc", 8, "banner", 8, 7)
function mod:GetOptions()
	return {
		--[[ Pre-Kazzara ]]--
		408975, -- Dancing Steel

		--[[ Kazzara -> Amalgamation Chamber ]]--
		{418113, "SAY", "SAY_COUNTDOWN"}, -- Dream Burst
		406210, -- Healing Bloom
		408811, -- Form Ranks
		bannerMarker,
		{411439, "TANK_HEALER"}, -- Sundering Strike
		406399, -- Zone of Azure Might
		411900, -- Gloom Fluid
		411905, -- Blaze Boil

		--[[ Amalgamation Chamber -> Forgotten Experiments ]]--
		411892, -- Viscous Bile
		{411808, "SAY", "SAY_COUNTDOWN"}, -- Slime Ejection
		412498, -- Stagnating Pool

		--[[ Echo of Neltharion -> Sarkareth ]]--
		{409576, "SAY", "SAY_COUNTDOWN"}, -- Dark Bindings
		409612, -- Umbral Torrent
	},{
		[408975] = L.edgelord,
		[418113] = L.naturalist,
		[408811] = L.siegemaster,
		[406399] = L.arcanist,
		[411900] = L.chemist,
		[411892] = L.fluid,
		[411808] = L.slime,
		[412498] = L.goo,
		[409576] = L.whisper,
	},{
		[408811] = L.banner, -- Form Ranks (Banner)
		[409612] = CL.orbs, -- Umbral Torrent (Orbs)
	}
end

function mod:OnRegister()
	-- Delayed for custom banner locale
	bannerMarker = self:AddMarkerOption(true, "npc", 8, "banner", 8, 7) -- Banner (short for Sundered Flame Banner)
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	--[[ Pre-Kazzara ]]--
	self:Log("SPELL_CAST_SUCCESS", "DancingSteel", 408975)

	--[[ Kazzara -> Amalgamation Chamber ]]--
	self:Log("SPELL_AURA_APPLIED", "DreamBurstApplied", 418113)
	self:Log("SPELL_AURA_REMOVED", "DreamBurstRemoved", 418113)
	self:Log("SPELL_CAST_START", "HealingBloom", 406210)
	self:Log("SPELL_SUMMON", "FormRanks", 408811)
	self:Log("SPELL_AURA_APPLIED", "SunderingStrikeApplied", 411439)
	self:Log("SPELL_CAST_START", "ZoneOfAzureMight", 406399)
	self:Log("SPELL_AURA_APPLIED", "ChemistDamage", 411900, 411905) -- Gloom Fluid, Blaze Boil
	self:Log("SPELL_PERIODIC_DAMAGE", "ChemistDamage", 411900, 411905)
	self:Log("SPELL_PERIODIC_MISSED", "ChemistDamage", 411900, 411905)

	--[[ Amalgamation Chamber -> Forgotten Experiments ]]--
	self:Log("SPELL_AURA_APPLIED", "ViscousBileDamage", 411892)
	self:Log("SPELL_PERIODIC_DAMAGE", "ViscousBileDamage", 411892)
	self:Log("SPELL_PERIODIC_MISSED", "ViscousBileDamage", 411892)
	self:Log("SPELL_CAST_SUCCESS", "SlimeEjection", 411808)
	self:Log("SPELL_AURA_APPLIED", "SlimeEjectionApplied", 411808)
	self:Log("SPELL_AURA_REMOVED", "SlimeEjectionRemoved", 411808)
	self:Death("BubblingSlimeKilled", 205651) -- Bubbling Slime
	self:Log("SPELL_AURA_APPLIED", "StagnatingPoolDamage", 412498)

	--[[ Echo of Neltharion -> Sarkareth ]]--
	self:Log("SPELL_AURA_APPLIED", "DarkBindingsApplied", 413785, 409576) -- Source: Entropic Hatred (203809), Whisper in the Dark (203806)
	self:Log("SPELL_AURA_REMOVED", "DarkBindingsRemoved", 413785, 409576)
	self:Log("SPELL_CAST_START", "UmbralTorrent", 409612)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ Pre-Kazzara ]]--
do
	local prev = 0
	function mod:DancingSteel(args)
		if self:Melee() and args.time-prev > 4 then
			prev = args.time
			self:Message(args.spellId, "yellow")
			self:PlaySound(args.spellId, "long")
		end
	end
end

--[[ Kazzara -> Amalgamation Chamber ]]--
function mod:DreamBurstApplied(args)
	self:TargetMessage(args.spellId, "yellow", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId, nil, nil, "Dream Burst")
		self:SayCountdown(args.spellId, 3.5)
	end
end

function mod:DreamBurstRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:HealingBloom(args)
	local canDo, ready = self:Interrupter()
	if canDo then
		self:Message(args.spellId, "red", CL.casting:format(args.spellName))
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

do
	local bannerCollector, icon, prevWarn, prevMarkClear = {}, 8, 0, 0
	function mod:BannerMarking(_, unit, guid)
		if bannerCollector[guid] then
			self:CustomIcon(bannerMarker, unit, bannerCollector[guid]) -- icon order from SPELL_SUMMON
			bannerCollector[guid] = nil
			if not next(bannerCollector) then
				self:UnregisterTargetEvents()
			end
		end
	end

	function mod:FormRanks(args)
		if args.time-prevWarn > 1 then -- Don't spam warn for multiple casts
			prevWarn = args.time
			self:Message(args.spellId, "orange", CL.spawned:format(L.banner))
			self:PlaySound(args.spellId, "warning")
		end
		if self:GetOption(bannerMarker) then
			if args.time-prevMarkClear > 5 then
				prevMarkClear = args.time
				icon = 8
				bannerCollector = {}
			end
			if not bannerCollector[args.destGUID] and icon > 6 then -- Limit to skull & cross
				bannerCollector[args.destGUID] = icon
				icon = icon - 1
				self:RegisterTargetEvents("BannerMarking")
			end
		end
	end
end

function mod:SunderingStrikeApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	self:PlaySound(args.spellId, "alert")
end

function mod:ZoneOfAzureMight(args)
	local canDo, ready = self:Interrupter()
	if canDo then
		self:Message(args.spellId, "red", CL.casting:format(args.spellName))
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

do
	local prev = 0
	function mod:ChemistDamage(args)
		if self:Me(args.destGUID) and args.time-prev > 2 then
			prev = args.time
			self:PersonalMessage(args.spellId, "underyou")
			self:PlaySound(args.spellId, "underyou")
		end
	end
end

--[[ Amalgamation Chamber -> Forgotten Experiments ]]--
do
	local prev = 0
	function mod:ViscousBileDamage(args)
		if self:Me(args.destGUID) and args.time-prev > 6 then
			prev = args.time
			self:PersonalMessage(args.spellId, "underyou")
			self:PlaySound(args.spellId, "underyou")
		end
	end
end

function mod:SlimeEjection(args)
	self:CDBar(args.spellId, 13.1)
end

function mod:SlimeEjectionApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:TargetBar(args.spellId, 5, args.destName)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId, nil, nil, "Slime Ejection")
		self:SayCountdown(args.spellId, 5)
	end
end

function mod:SlimeEjectionRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
		self:StopBar(args.spellId, args.destName)
	end
end

function mod:BubblingSlimeKilled()
	self:StopBar(411808) -- Slime Ejection
end

do
	local prev = 0
	function mod:StagnatingPoolDamage(args)
		if self:Me(args.destGUID) and args.time-prev > 2 then
			prev = args.time
			self:PersonalMessage(args.spellId, "underyou")
			self:PlaySound(args.spellId, "underyou")
		end
	end
end

--[[ Echo of Neltharion -> Sarkareth ]]--
function mod:DarkBindingsApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(409576)
		self:PlaySound(409576, "warning")
		self:Say(409576, nil, nil, "Dark Bindings")
		self:SayCountdown(409576, 5)
	end
end

function mod:DarkBindingsRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(409576)
	end
end

function mod:UmbralTorrent(args)
	self:Message(args.spellId, "red", CL.incoming:format(CL.orbs))
	self:PlaySound(args.spellId, "long")
end
