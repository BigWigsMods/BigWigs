--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nexus-Princess Ky'veza", 2657, 2601)
if not mod then return end
mod:RegisterEnableMob(217748) -- Nexus-Princess Ky'veza
mod:SetEncounterID(2920)
mod:SetRespawnTime(30)
mod:SetPrivateAuraSounds({
	436870, -- Assassination
	{437343, extra = {463273, 463276}}, -- Queensbane (Also A & B) XXX Initial spell not private yet, but they flagged the other 2 already.
	438141, -- Twilight Massacre
	{435534, extra = {436663, 436664, 436665, 436666, 436671}}, -- Regicide
})
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local assassinationCount = 1
local twilightMassacreCount = 1
local netherRiftCount = 1
local nexusDaggersCount = 1
local voidShreddersCount = 1
local starlessNightCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.assasination = "Phantoms"
	L.twiligt_massacre = "Dashes"
	L.nexus_daggers = "Daggers"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Stage One: The Phantom Blade
		{436867, "PRIVATE"}, -- Assassination
		{437343, "SAY_COUNTDOWN"}, -- Queensbane
		439409, -- Dark Viscera
		{438245, "PRIVATE"}, -- Twilight Massacre
		437620, -- Nether Rift
		439576, -- Nexus Daggers
		{440377, "TANK_HEALER"}, -- Void Shredders
		{440576, "TANK"}, -- Chasmal Gash

		-- Stage Two: Starless Night
		{435405, "CASTBAR"}, -- Starless Night
		-- {435534, "PRIVATE"}, -- Regicide PA Sounds only
		{442277, "CASTBAR"}, -- Eternal Night
	}, {
		[436867] = -28741, -- Stage One: The Phantom Blade
		[435405] = -28742, -- Stage Two: Starless Night
	}, {
		[436867] = L.assasination, -- Assassination (Phantoms)
		[439409] = CL.orbs, -- Dark Visera (Orbs)
		[438245] = L.twiligt_massacre, -- Twilight Massacre (Dashes)
		[437620] = CL.rifts, -- Nether Rift (Rifts)
		[439576] = L.nexus_daggers, -- Nexus Daggers (Daggers)
		[435405] = CL.stage:format(2), -- Starless Night (Stage 2)
		[442277] = CL.count:format(CL.stage:format(2), 3), -- Eternal Night (Stage 2 (3))
	}
end

function mod:OnRegister()
	self:SetSpellRename(439409, CL.orbs) -- Dark Visera (Orbs)
	self:SetSpellRename(438245, L.twiligt_massacre) -- Twilight Massacre (Dashes)
	self:SetSpellRename(437620, CL.rifts) -- Nether Rift (Rifts)
	self:SetSpellRename(439576, L.nexus_daggers) -- Nexus Daggers (Daggers)
end

function mod:OnBossEnable()
	-- Stage One: The Phantom Blade
	self:Log("SPELL_CAST_SUCCESS", "Assassination", 436867, 442573, 440650) -- 3, 4, 5 targets
	self:Log("SPELL_AURA_APPLIED", "QueensbaneApplied", 437343)
	self:Log("SPELL_CAST_START", "TwilightMassacre", 438245)
	self:Log("SPELL_CAST_START", "NetherRift", 437620)
	self:Log("SPELL_CAST_START", "NexusDaggers", 439576)
	self:Log("SPELL_CAST_START", "VoidShredders", 440377)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ChasmalGashApplied", 440576)
	-- Stage Two: Starless Night
	self:Log("SPELL_CAST_START", "StarlessNight", 435405)
	self:Log("SPELL_AURA_REMOVED", "StarlessNightOver", 435405)
	self:Log("SPELL_CAST_START", "EternalNight", 442277)
end

function mod:OnEngage()
	self:SetStage(1)
	assassinationCount = 1
	twilightMassacreCount = 1
	netherRiftCount = 1
	nexusDaggersCount = 1
	voidShreddersCount = 1
	starlessNightCount = 1

	self:Bar(436867, 8.5, CL.count:format(L.assasination, assassinationCount)) -- Assassination
	self:Bar(440377, 10.0, CL.count:format(self:SpellName(440377), voidShreddersCount)) -- Void Shredders
	self:Bar(437620, 22.0, CL.count:format(CL.rifts, netherRiftCount)) -- Nether Rift
	self:Bar(438245, 34.0, CL.count:format(L.twiligt_massacre, twilightMassacreCount)) -- Twilight Massacre
	self:Bar(439576, 45.0, CL.count:format(L.nexus_daggers, nexusDaggersCount)) -- Nexus Daggers
	self:Bar(435405, 96.1, CL.count:format(CL.stage:format(2), starlessNightCount)) -- Starless Night
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: The Phantom Blade

function mod:Assassination(args)
	self:StopBar(CL.count:format(L.assasination, assassinationCount))
	self:Message(436867, "cyan", CL.count:format(L.assasination, assassinationCount))
	-- self:PlaySound(436867, "alert") -- Private sound when affected
	assassinationCount = assassinationCount + 1
	if assassinationCount < 4 then
		self:Bar(436867, 130.0, CL.count:format(L.assasination, assassinationCount))
	end
end

do
	local prev = 0
	function mod:QueensbaneApplied(args)
		if not self:Easy() and args.time - prev > 2 then
			prev = args.time
			self:Bar(439409, 9, CL.orbs) -- Dark Viscera
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "alarm")
			if not self:Easy() then
				self:SayCountdown(args.spellId, 9)
			end
		end
	end
end

function mod:TwilightMassacre(args)
	self:StopBar(CL.count:format(L.twiligt_massacre, twilightMassacreCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.twiligt_massacre, twilightMassacreCount))
	self:PlaySound(args.spellId, "alert")
	twilightMassacreCount = twilightMassacreCount + 1
	if twilightMassacreCount < 7 then
		self:Bar(args.spellId, twilightMassacreCount % 2 == 0 and 30.0 or 100.0, CL.count:format(L.twiligt_massacre, twilightMassacreCount))
	end
end

function mod:NetherRift(args)
	if self:MobId(args.sourceGUID) == 217748 then -- boss, not phantoms
		self:StopBar(CL.count:format(CL.rifts, netherRiftCount))
		self:Message(args.spellId, "orange", CL.count:format(CL.rifts, netherRiftCount))
		self:PlaySound(args.spellId, "alert")
		netherRiftCount = netherRiftCount + 1
		if netherRiftCount < 10 then
			self:Bar(args.spellId, netherRiftCount % 3 == 1 and 70.0 or 30.0, CL.count:format(CL.rifts, netherRiftCount))
		end
	end
end

do
	local daggerCastedCount = 0
	function mod:NexusDaggers(args)
		if self:MobId(args.sourceGUID) == 217748 then -- boss, not phantoms
			self:StopBar(CL.count:format(L.nexus_daggers, nexusDaggersCount))
			self:Message(args.spellId, "yellow", CL.count:format(L.nexus_daggers, nexusDaggersCount))
			self:PlaySound(args.spellId, "alarm")
			nexusDaggersCount = nexusDaggersCount + 1
			if nexusDaggersCount < 7 then
				self:Bar(args.spellId, nexusDaggersCount % 2 == 0 and 30.0 or 100.0, CL.count:format(L.nexus_daggers, nexusDaggersCount))
			end
			daggerCastedCount = 0
		else -- phantoms
			daggerCastedCount = daggerCastedCount + 1
			if daggerCastedCount == 5 then
				self:Message(args.spellId, "cyan", CL.over:format(L.nexus_daggers))
				self:PlaySound(args.spellId, "info")
			end
		end
	end
end

function mod:VoidShredders(args)
	self:StopBar(CL.count:format(args.spellName, voidShreddersCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, voidShreddersCount))
	self:PlaySound(args.spellId, "alert")
	voidShreddersCount = voidShreddersCount + 1
	if voidShreddersCount < 10 then
		-- 10.0, 30.0, 30.0, 70.0, 30.0, 30.0, 70.0, 30.0, 30.0
		local cd = voidShreddersCount % 3 == 1 and 70 or 30
		self:Bar(args.spellId, cd, CL.count:format(args.spellName, voidShreddersCount))
	end
end

function mod:ChasmalGashApplied(args)
	-- 4 stacks in 1.5s
	if args.amount % 4 == 0 then
		self:StackMessage(args.spellId, "purple", args.destName, args.amount, 4)
		if self:Tank() and not self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning") -- tankswap?
		end
	end
end

-- Stage Two: Starless Night
function mod:StarlessNight(args)
	self:SetStage(2)
	self:StopBar(CL.count:format(CL.stage:format(2), starlessNightCount))
	self:Message(args.spellId, "cyan", CL.count:format(CL.stage:format(2), starlessNightCount))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 29, CL.count:format(CL.stage:format(2), starlessNightCount))
	starlessNightCount = starlessNightCount + 1
	local cd = 130.0
	if starlessNightCount == 3 then
		self:Bar(442277, cd, CL.count:format(CL.stage:format(2), starlessNightCount)) -- Eternal Night
	elseif starlessNightCount < 3 then
		self:Bar(args.spellId, cd, CL.count:format(CL.stage:format(2), starlessNightCount))
	end
end

function mod:StarlessNightOver()
	self:SetStage(1)
end

function mod:EternalNight(args)
	self:SetStage(2)
	self:StopBar(CL.count:format(CL.stage:format(2), starlessNightCount))
	self:Message(args.spellId, "red", CL.count:format(CL.stage:format(2), starlessNightCount))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 38, CL.count:format(CL.stage:format(2), starlessNightCount))
end
