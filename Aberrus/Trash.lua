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
	203939, -- Animation Fluid
	205651 -- Bubbling Slime
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

	--[[ Amalgamation Chamber -> Forgotten Experiments ]]--
	L.fluid = "Animation Fluid"
	L.slime = "Bubbling Slime"
end

--------------------------------------------------------------------------------
-- Initialization
--

local bannerMarker
function mod:GetOptions()
	return {
		--[[ Pre-Kazzara ]]--
		408975, -- Dancing Steel

		--[[ Kazzara -> Amalgamation Chamber ]]--
		{406282, "SAY", "SAY_COUNTDOWN"}, -- Dream Burst
		406210, -- Healing Bloom
		408811, -- Form Ranks
		bannerMarker,
		{411439, "TANK_HEALER"}, -- Sundering Strike

		--[[ Amalgamation Chamber -> Forgotten Experiments ]]--
		411892, -- Viscous Bile
		{411808, "SAY", "SAY_COUNTDOWN"}, -- Slime Ejection
		412498, -- Stagnating Pool
	},{
		[408975] = L.edgelord,
		[406282] = L.naturalist,
		[408811] = L.siegemaster,
		[411892] = L.fluid,
		[411808] = L.slime,
	},{
		[408811] = L.banner, -- Form Ranks (Banner)
	}
end

function mod:OnRegister()
	-- Delayed for custom locale
	bannerMarker = self:AddMarkerOption(true, "npc", 8, "banner", 8, 7) -- Banner (short for Sundered Flame Banner)
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	--[[ Pre-Kazzara ]]--
	self:Log("SPELL_CAST_START", "DancingSteel", 408975)

	--[[ Kazzara -> Amalgamation Chamber ]]--
	self:Log("SPELL_CAST_START", "DreamBurst", 406282)
	self:Log("SPELL_CAST_START", "HealingBloom", 406210)
	self:Log("SPELL_SUMMON", "FormRanks", 408811)
	self:Log("SPELL_AURA_APPLIED", "SunderingStrikeApplied", 411439)

	--[[ Amalgamation Chamber -> Forgotten Experiments ]]--
	self:Log("SPELL_AURA_APPLIED", "ViscousBileDamage", 411892)
	self:Log("SPELL_PERIODIC_DAMAGE", "ViscousBileDamage", 411892)
	self:Log("SPELL_PERIODIC_MISSED", "ViscousBileDamage", 411892)
	self:Log("SPELL_CAST_SUCCESS", "SlimeEjection", 411808)
	self:Log("SPELL_AURA_APPLIED", "SlimeEjectionApplied", 411808)
	self:Log("SPELL_AURA_REMOVED", "SlimeEjectionRemoved", 411808)
	self:Death("BubblingSlimeKilled", 205651) -- Bubbling Slime
	self:Log("SPELL_AURA_APPLIED", "StagnatingPoolDamage", 412498)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ Pre-Kazzara ]]--
function mod:DancingSteel(args)
	if self:Melee() then
		self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
		self:PlaySound(args.spellId, "long")
	end
end

--[[ Kazzara -> Amalgamation Chamber ]]--
do
	local function printTarget(self, player, guid)
		self:TargetMessage(406282, "yellow", player)
		if self:Me(guid) then
			self:PlaySound(406282, "warning")
			self:Say(406282)
			self:SayCountdown(406282, 3.5)
		end
	end
	function mod:DreamBurst(args)
		self:GetUnitTarget(printTarget, 0.5, args.sourceGUID)
	end
end

function mod:HealingBloom(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "red", CL.casting:format(args.spellName))
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

do
	local bannerCollector, icon, prev = {}, 8, 0
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
		self:Message(args.spellId, "orange", CL.spawned:format(L.banner))
		if self:GetOption(bannerMarker) then
			if args.time-prev > 5 then
				prev = args.time
				icon = 8
				bannerCollector = {}
			end
			if not bannerCollector[args.destGUID] then
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

--[[ Amalgamation Chamber -> Forgotten Experiments ]]--
do
	local prev = 0
	function mod:ViscousBileDamage(args)
		if self:Me(args.destGUID) and args.time-prev > 5 then
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
		self:Say(args.spellId)
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
