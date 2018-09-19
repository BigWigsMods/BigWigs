if UnitFactionGroup("player") ~= "Alliance" then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Doom's Howl", -14, 2213)
if not mod then return end
mod:RegisterEnableMob(138122)
mod.otherMenu = -947
mod.worldBoss = 138122

--------------------------------------------------------------------------------
-- Locals
--

local castCollector = {} -- for all UNIT casts
local markerIcon = 8

--------------------------------------------------------------------------------
-- Initialization
--

local engineerMarker = mod:AddMarkerOption(true, "npc", 8, -18702, 8, 7) -- Doom's Howl Engineer
function mod:GetOptions()
	return {
		271163, -- Shattering Pulse
		{271164, "PROXIMITY"}, -- Mortar Shot
		271120, -- Flame Exhausts
		271223, -- Siege Up
		271800, -- Battle Field Repair
		engineerMarker,
		--271789, -- Sentry Protection
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")

	self:Log("SPELL_CAST_START", "ShatteringPulse", 271163)
	self:Log("SPELL_CAST_START", "SiegeUp", 271223)
	self:Log("SPELL_AURA_REMOVED", "SiegeUpOver", 271223)
	self:Log("SPELL_AURA_APPLIED", "BattleFieldRepair", 271800)
	--self:Log("SPELL_AURA_APPLIED", "SentryProtection", 271789)
	--self:Log("SPELL_AURA_REMOVED", "SentryProtectionRemoved", 271789)
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

	self:Log("SPELL_AURA_APPLIED", "FlameExhausts", 271120)
end

function mod:OnEngage()
	castCollector = {}
	self:CheckForWipe()
	self:CDBar(271223, 78) -- Siege Up
	self:OpenProximity(271164, 8) -- Mortar Shot
	if self:GetOption(engineerMarker) then
		markerIcon = 8
		self:RegisterTargetEvents("MarkEngineer")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 2253 then
		castCollector = {}
		self:Win()
	end
end

function mod:ShatteringPulse(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 20) -- 20-25
end

function mod:SiegeUp(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
	self:StopBar(args.spellName)
	self:CastBar(args.spellId, 65)
	self:CloseProximity(271164) -- Mortar Shot
end

function mod:SiegeUpOver(args)
	self:Message2(args.spellId, "cyan", CL.over:format(args.spellName))
	self:PlaySound(args.spellId, "long")
	self:CDBar(args.spellId, 85)
	self:OpenProximity(271164, 8) -- Mortar Shot
	self:CDBar(271164, 8.5) -- Mortar Shot
	self:CDBar(271163, 15) -- Shattering Pulse
end

do
	local prev = 0
	function mod:BattleFieldRepair(args)
		local raidIcon = CombatLog_String_GetIcon(args.sourceRaidFlags)
		self:Message2(args.spellId, "red", raidIcon .. args.spellName)
		local t = args.time
		if t-prev > 0.5 then
			prev = t
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:MarkEngineer(_, unit, guid)
	if not castCollector[guid] and self:MobId(guid) == 138129 then -- Doom's Howl Engineer
		castCollector[guid] = true -- Just reuse this table
		SetRaidTarget(unit, markerIcon)
		markerIcon = markerIcon - 1
		if markerIcon < 7 then
			markerIcon = 8
		end
	end
end


--function mod:SentryProtection(args)
--	
--end

--function mod:SentryProtectionRemoved(args)
--	
--end

do
	local prev = 0
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, castGUID, spellId)
		if castCollector[castGUID] then return end -- don't fire twice for the same cast

		if spellId == 271164 then -- Mortar Shot
			castCollector[castGUID] = true
			local t = args.time
			if t-prev > 0.5 then
				prev = t
				self:Message2(spellId, "orange")
				self:PlaySound(spellId, "info")
				self:CDBar(spellId, 12) -- 12-14
			end
		end
	end
end

function mod:FlameExhausts(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, "underyou")
		self:PlaySound(args.spellId, "alarm")
	end
end
