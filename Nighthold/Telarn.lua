
--------------------------------------------------------------------------------
-- TODO List:

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("High Botanist Tel'arn", 1088, 1761)
if not mod then return end
mod:RegisterEnableMob(104528)
mod.engageId = 1886
mod.respawnTime = 7 -- fix me

--------------------------------------------------------------------------------
-- Locals
--

local nextPhaseSoon = 80
local phase = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

local callOfTheNightMarker = mod:AddMarkerOption(false, "player", 1, 218809, 1, 2, 3, 4, 5, 6)
local fetterMarker = mod:AddMarkerOption(false, "player", 8, 218304, 8)
function mod:GetOptions()
	return {
		--[[ General ]]--
		"stages",

		--[[ Arcanist Tel'arn ]]--
		{218809, "SAY", "FLASH", "PROXIMITY"}, -- Call of Night
		callOfTheNightMarker,
		{218503, "TANK"}, -- Recursive Strikes
		218438, -- Controlled Chaos

		--[[ Solarist Tel'arn ]]--
		218148, -- Solar Collapse
		218774, -- Summon Plasma Spheres

		--[[ Naturalist Tel'arn ]]--
		219235, -- Toxic Spores
		218927, -- Grace of Nature
		{218304, "SAY"}, -- Parasitic Fetter
		fetterMarker,
		{218342, "FLASH"}, -- Parasitic Fixate
	}, {
		["stages"] = "general",
		[218809] = -13694, -- Arcanist Tel'arn
		[218148] = -13682, -- Solarist Tel'arn
		[219235] = -13684, -- Naturalist Tel'arn
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:Log("SPELL_CAST_START", "Nightosis1", 216830) -- P2
	self:Log("SPELL_CAST_START", "Nightosis2", 216877) -- P3

	--[[ Arcanist Tel'arn ]]--
	self:Log("SPELL_AURA_APPLIED", "CallOfNight", 218809)
	self:Log("SPELL_AURA_REMOVED", "CallOfNightRemoved", 218809)
	self:Log("SPELL_AURA_APPLIED", "RecursiveStrikes", 218503)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RecursiveStrikes", 218503)
	self:Log("SPELL_CAST_START", "ControlledChaos", 218438)

	--[[ Solarist Tel'arn ]]--
	self:Log("SPELL_CAST_START", "SolarCollapse", 218148)
	self:Log("SPELL_CAST_START", "SummonPlasmaSpheres", 218774)

	--[[ Naturalist Tel'arn ]]--
	self:Log("SPELL_AURA_APPLIED", "ToxicSpores", 219235)
	self:Log("SPELL_AURA_REMOVED", "ToxicSporesRemoved", 219235)
	self:Log("SPELL_CAST_START", "GraceOfNature", 218927)
	self:Log("SPELL_AURA_APPLIED", "GraceOfNatureAura", 219009)
	self:Log("SPELL_CAST_SUCCESS", "ParasiticFetterSuccess", 218424)
	self:Log("SPELL_AURA_APPLIED", "ParasiticFetter", 218304)
	self:Log("SPELL_AURA_REMOVED", "ParasiticFetterRemoved", 218304)
	self:Log("SPELL_AURA_APPLIED", "Fixate", 218342) -- Parasitic Fixate
end

function mod:OnEngage()
	nextPhaseSoon = 80
	phase = 1
	self:Bar(218148, 10) -- Solar Collapse, to _start
	self:Bar(218304, 21.5) -- Parasitic Fetter, to _success
	self:Bar(218438, 35) -- Controlled Chaos, to_start
	if not self:Mythic() then
		self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ General ]]--
function mod:Nightosis1(args)
	self:Message("stages", "Neutral", "Info", "75% - ".. self:SpellName(-13681), false) -- Stage Two: Nightosis
	phase = 2
	self:Bar(218774, 12) -- Summon Plasma Spheres, to _start
	self:Bar(218304, 23.5) -- Parasitic Fetter, to _success
	self:Bar(218148, 32) -- Solar Collapse, to _start
	self:Bar(218438, 42) -- Controlled Chaos, to _start
end

function mod:Nightosis2(args)
	self:Message("stages", "Neutral", "Info", "50% - ".. self:SpellName(-13683), false) -- Stage Three: Pure Forms
	phase = 3
	self:Bar(218927, 10.5) -- Grace of Nature, to _start
	self:Bar(218809, 20) -- Call of Night, to _success
	self:Bar(218774, 26) -- Summon Plasma Spheres, to _start
	self:Bar(218304, 34) -- Parasitic Fetter, to _success
	self:Bar(218148, 42) -- Solar Collapse, to _start
	self:Bar(218438, 52) -- Controlled Chaos, to _start
end

function mod:UNIT_HEALTH_FREQUENT(unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < nextPhaseSoon then
		self:Message("stages", "Neutral", "Info", CL.soon:format(CL.stage:format(phase+1)), false)
		nextPhaseSoon = nextPhaseSoon - 25
		if nextPhaseSoon < 50 then
			self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
		end
	end
end

--[[ Arcanist Tel'arn ]]--
do
	local playerList, proxList, isOnMe, iconsUnused = mod:NewTargetList(), {}, nil, {1,2,3,4,5,6}

	function mod:CallOfNight(args)
		proxList[#proxList+1] = args.destName

		if self:Me(args.destGUID) then
			isOnMe = true
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:OpenProximity(args.spellId, 8, proxList) -- don't stand near others with the debuff
			self:TargetBar(args.spellId, 45, args.destName)
		end

		if not isOnMe then
			self:OpenProximity(args.spellId, 8, proxList, true) -- stand near debuffed players
		end

		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, playerList, "Important", "Alert")
			self:Bar(args.spellId, 50)
		end

		if self:GetOption(callOfTheNightMarker) then
			local icon = iconsUnused[1]
			if icon then -- At least one icon unused
				SetRaidTarget(args.destName, icon)
				tDeleteItem(iconsUnused, icon)
			end
		end
	end

	function mod:CallOfNightRemoved(args)
		if self:Me(args.destGUID) then
			isOnMe = nil
			self:CloseProximity(args.spellId)
			self:StopBar(args.spellId, args.destName)
		end

		tDeleteItem(proxList, args.destName)
		if not isOnMe then -- stand near others
			if #proxList == 0 then
				self:CloseProximity(args.spellId)
			else
				self:OpenProximity(args.spellId, 8, proxList, true)
			end
		end

		if self:GetOption(callOfTheNightMarker) then
			local icon = GetRaidTargetIndex(args.destName)
			if icon and icon > 0 and icon < 7 and not tContains(iconsUnused, icon) then
				table.insert(iconsUnused, icon)
				SetRaidTarget(args.destName, 0)
			end
		end
	end
end

function mod:RecursiveStrikes(args)
	local amount = args.amount or 1
	if amount > 5 and amount % 2 == 0 then
		self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 7 and "Warning")
	end
end

function mod:ControlledChaos(args)
	self:Message(args.spellId, "Important", "Alert", CL.incoming:format(args.spellName))
	self:Bar(args.spellId, phase == 2 and 40 or phase == 3 and 50 or 35)
end

--[[ Solarist Tel'arn ]]--
function mod:SolarCollapse(args)
	self:Message(args.spellId, "Important", "Long", CL.incoming:format(args.spellName))
	self:Bar(args.spellId, phase == 2 and 40 or phase == 3 and 50 or 35)
end

function mod:SummonPlasmaSpheres(args)
	self:Message(args.spellId, "Urgent", "Alert")
	self:Bar(args.spellId, phase == 2 and 40 or 50)
end

--[[ Naturalist Tel'arn ]]--
function mod:ToxicSpores(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Info")
		self:TargetBar(args.spellId, 12, args.destName)
	end
end

function mod:ToxicSporesRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellId, args.destName)
	end
end

function mod:GraceOfNature(args)
	self:Message(args.spellId, "Important", "Long", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 50)
end

do
	local prev = 0
	function mod:GraceOfNatureAura(args)
		local t = GetTime()
		if t-prev > 1.5 then
			prev = t
			self:TargetMessage(218927, args.destName, "Urgent", self:Tank() and "Alarm")
		end
	end
end

function mod:ParasiticFetterSuccess(args)
	self:Bar(218304, phase == 2 and 40 or phase == 3 and 50 or 35)
end

do
	local prev = 0
	function mod:ParasiticFetter(args)
		local t = GetTime()
		if t-prev > 5 then
			prev = t
			self:TargetMessage(args.spellId, args.destName, "Urgent", self:Dispeller("magic") and "Alarm")
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
		if self:GetOption(fetterMarker) then
			SetRaidTarget(args.destName, 8)
		end
	end
end

do
	local prev = 0
	function mod:ParasiticFetterRemoved(args)
		local t = GetTime()
		if t-prev > 5 then
			prev = t
			self:Message(args.spellId, "Attention", self:Damager() and "Alarm", CL.spawned:format(self:SpellName(-13699))) -- Parasitic Lasher
		end
		if self:GetOption(fetterMarker) and GetRaidTargetIndex(args.destName) == 8 then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:Fixate(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Info", self:SpellName(177643)) -- Fixate
		self:Flash(args.spellId)
	end
end
