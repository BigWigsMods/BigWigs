if not BigWigsLoader.isBeta then return end -- Beta check

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
	438141, -- Twilight Massacre
	{435534, extra = {436663, 436664, 436665, 436666, 436671, 436677}}, -- Regicide
})

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

-- local L = mod:GetLocale()
-- if L then

-- end

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
		435405, -- Starless Night
		-- {435534, "PRIVATE"}, -- Regicide XXX only a sound right now
		442277, -- Eternal Night
	}, {
		[436867] = -28741,
		[435405] = -28742,
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage") -- XXX No Boss Frame Fix
	self:Log("SPELL_CAST_SUCCESS", "Assassination", 436867, 442573, 440650) -- 3, 4, 5 targets
	self:Log("SPELL_AURA_APPLIED", "QueensbaneApplied", 437343)
	self:Log("SPELL_CAST_START", "TwilightMassacre", 438245)
	self:Log("SPELL_CAST_START", "NetherRift", 437620)
	self:Log("SPELL_CAST_START", "NexusDaggers", 439576)
	self:Log("SPELL_CAST_START", "VoidShredders", 440377)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ChasmalGashApplied", 440576)

	self:Log("SPELL_CAST_START", "StarlessNight", 435405)
	self:Log("SPELL_CAST_START", "EternalNight", 442277)
end

function mod:OnEngage()
	assassinationCount = 1
	twilightMassacreCount = 1
	netherRiftCount = 1
	nexusDaggersCount = 1
	voidShreddersCount = 1
	starlessNightCount = 1

	self:Bar(440377, 6.0, CL.count:format(self:SpellName(440377), voidShreddersCount)) -- Void Shredders
	self:Bar(436867, 10.0, CL.count:format(self:SpellName(436867), assassinationCount)) -- Assassination
	self:Bar(437620, 22.0, CL.count:format(self:SpellName(437620), netherRiftCount)) -- Nether Rift
	self:Bar(438245, 34.0, CL.count:format(self:SpellName(438245), twilightMassacreCount)) -- Twilight Massacre
	self:Bar(439576, 45.0, CL.count:format(self:SpellName(439576), nexusDaggersCount)) -- Nexus Daggers
	self:Bar(435405, 96.1, CL.count:format(self:SpellName(435405), starlessNightCount)) -- Starless Night
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: The Phantom Blade

function mod:Assassination(args)
	self:StopBar(CL.count:format(self:SpellName(436867), assassinationCount))
	self:Message(436867, "cyan", CL.count:format(self:SpellName(436867), assassinationCount))
	assassinationCount = assassinationCount + 1
	if assassinationCount < 4 then
		self:Bar(436867, 130.0, CL.count:format(self:SpellName(436867), assassinationCount))
	end
end

do
	local prev = 0
	function mod:QueensbaneApplied(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Bar(439409, 10) -- Dark Viscera
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "alarm")
			if not self:Easy() then
				self:SayCountdown(args.spellId, 10)
			end
		end
	end
end

function mod:TwilightMassacre(args)
	self:StopBar(CL.count:format(args.spellName, twilightMassacreCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, twilightMassacreCount))
	self:PlaySound(args.spellId, "alert")
	twilightMassacreCount = twilightMassacreCount + 1
	if twilightMassacreCount < 7 then
		self:Bar(args.spellId, twilightMassacreCount % 2 == 0 and 30.0 or 100.0, CL.count:format(args.spellName, twilightMassacreCount))
	end
end

function mod:NetherRift(args)
	if self:MobId(args.sourceGUID) == 217748 then -- boss, not phantoms
		self:StopBar(CL.count:format(args.spellName, netherRiftCount))
		self:Message(args.spellId, "orange", CL.count:format(args.spellName, netherRiftCount))
		self:PlaySound(args.spellId, "alert")
		netherRiftCount = netherRiftCount + 1
		if netherRiftCount < 10 then
			self:Bar(args.spellId, netherRiftCount % 3 == 1 and 70.0 or 30.0, CL.count:format(args.spellName, netherRiftCount))
		end
	end
end

function mod:NexusDaggers(args)
	if self:MobId(args.sourceGUID) == 217748 then -- boss, not phantoms
		self:StopBar(CL.count:format(args.spellName, nexusDaggersCount))
		self:Message(args.spellId, "yellow", CL.count:format(args.spellName, nexusDaggersCount))
		self:PlaySound(args.spellId, "alarm")
		nexusDaggersCount = nexusDaggersCount + 1
		if nexusDaggersCount < 7 then
			self:Bar(args.spellId, nexusDaggersCount % 2 == 0 and 30.0 or 100.0, CL.count:format(args.spellName, nexusDaggersCount))
		end
	end
end

function mod:VoidShredders(args)
	self:StopBar(CL.count:format(args.spellName, voidShreddersCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, voidShreddersCount))
	self:PlaySound(args.spellId, "alert")
	voidShreddersCount = voidShreddersCount + 1
	if voidShreddersCount < 10 then
		local timer = { 30.0, 66.0, 34.0 } -- 6.0, 34.0, 30.0, 66.0, 34.0, 30.0, 66.0
		local cd = timer[voidShreddersCount % 3 + 1]
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
	self:StopBar(CL.count:format(args.spellName, starlessNightCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, starlessNightCount))
	self:PlaySound(args.spellId, "long")
	starlessNightCount = starlessNightCount + 1
	if starlessNightCount == 3 then
		self:Bar(442277, 130.0) -- Eternal Night
	elseif starlessNightCount < 3 then
		self:Bar(args.spellId, 130.0, CL.count:format(args.spellName, starlessNightCount))
	end
end

function mod:EternalNight(args)
	self:StopBar(args.spellName)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
	self:Bar(args.spellId, 34, 15097) -- 15097 = Enrage (cast hits the entire room and ramps)
end
