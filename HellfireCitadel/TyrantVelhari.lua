
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Tyrant Velhari", 1026, 1394)
if not mod then return end
mod:RegisterEnableMob(90269)
mod.engageId = 1784
mod.respawnTime = 40

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local strikeCount = 0
local mendingCount = 1
local inverseFontTargets = {}
local fontOnMe = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.font_removed_soon = "Your Font expires soon!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Stage One: Oppression ]]--
		{180260, "SAY"}, -- Annihilating Strike
		{180300, "PROXIMITY"}, -- Infernal Tempest
		-11155, -- Ancient Enforcer
		180004, -- Enforcer's Onslaught
		--[[ Stage Two: Contempt ]]--
		180533, -- Tainted Shadows
		{180526, "SAY", "FLASH", "PROXIMITY"}, -- Font of Corruption
		-11163, -- Ancient Harbinger
		180025, -- Harbinger's Mending
		--[[ Stage Three: Malice ]]--
		{180600, "FLASH"}, -- Bulwark of the Tyrant
		180608, -- Gavel of the Tyrant
		-11170, -- Ancient Sovereign
		180040, -- Sovereign's Ward
		--[[ General ]]--
		{180000, "TANK"}, -- Seal of Decay
		{185237, "FLASH"}, -- Touch of Harm
		{182459, "SAY", "ICON"}, -- Edict of Condemnation
		"stages",
	}, {
		[180260] = -11151, -- Stage One: Oppression
		[180533] = -11158, -- Stage Two: Contempt
		[180600] = -11166, -- Stage Three: Malice
		[180000] = "general",
	}
end

function mod:OnBossEnable()
	-- Phase 1
	self:Log("SPELL_CAST_START", "EnforcersOnslaught", 180004)
	self:Log("SPELL_CAST_START", "AnnihilatingStrike", 180260)
	self:Log("SPELL_CAST_START", "InfernalTempestStart", 180300)
	self:Log("SPELL_AURA_REMOVED", "InfernalTempestEnd", 180300)
	-- Phase 2
	self:Log("SPELL_CAST_SUCCESS", "AuraOfContempt", 179986)
	self:Log("SPELL_AURA_APPLIED", "FontOfCorruption", 180526)
	self:Log("SPELL_AURA_REMOVED", "FontOfCorruptionRemoved", 180526)
	self:Log("SPELL_CAST_START", "TaintedShadows", 180533)
	self:Log("SPELL_CAST_START", "HarbingersMending", 180025, 181990)
	self:Log("SPELL_AURA_APPLIED", "HarbingersMendingApplied", 180025, 181990)
	-- Phase 3
	self:Log("SPELL_CAST_SUCCESS", "AuraOfMalice", 179991)
	self:Log("SPELL_CAST_START", "GavelOfTheTyrant", 180608)
	self:Log("SPELL_CAST_SUCCESS", "BulwarkOfTheTyrant", 180600)
	self:Log("SPELL_AURA_APPLIED", "SovereignsWard", 180040)
	self:Log("SPELL_AURA_REMOVED", "SovereignsWardRemoved", 180040)
	self:Log("SPELL_AURA_APPLIED", "DespoiledGroundDamage", 180604)
	self:Log("SPELL_PERIODIC_DAMAGE", "DespoiledGroundDamage", 180604)
	self:Log("SPELL_PERIODIC_MISSED", "DespoiledGroundDamage", 180604)
	-- General
	self:Log("SPELL_AURA_APPLIED", "SealOfDecay", 180000)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SealOfDecay", 180000)
	self:Log("SPELL_AURA_APPLIED", "TouchOfHarm", 185237, 180166) -- Mythic, Heroic/Normal
	self:Log("SPELL_AURA_APPLIED", "TouchOfHarmJumper", 185238, 180164) -- Mythic, Heroic/Normal (Dispelled version)
	self:Log("SPELL_AURA_APPLIED", "EdictOfCondemnation", 182459, 185241)
	self:Log("SPELL_AURA_REMOVED", "EdictOfCondemnationRemoved", 182459, 185241)

	self:Death("Deaths", 90270, 90271, 90272) -- Ancient Enforcer, Ancient Harbinger, Ancient Sovereign
end

function mod:OnEngage()
	wipe(mobCollector)
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")

	self:Bar(180260, 10, CL.count:format(self:SpellName(180260), 1)) -- Annihilating Strike
	self:Bar(185237, 16) -- Touch of Harm
	self:Bar(180300, 40) -- Infernal Tempest
	self:Bar(182459, 57) -- Edict of Condemnation

	strikeCount = 0
	mendingCount = 1
	phase = 1

	-- Adding all players to a list, since they are the "bad" players to Font targets (for proximity)
	fontOnMe = nil
	wipe(inverseFontTargets)
	local _, _, _, mapId = UnitPosition("player")
	for unit in self:IterateGroup() do
		local _, _, _, tarMapId = UnitPosition(unit)
		if tarMapId == mapId and not UnitIsUnit("player", unit) and UnitIsConnected(unit) then
			inverseFontTargets[#inverseFontTargets+1] = self:UnitName(unit)
		end
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	for i = 1, 5 do
		local guid = UnitGUID("boss"..i)
		if guid and not mobCollector[guid] then
			mobCollector[guid] = true
			mobId = self:MobId(guid)
			if mobId == 90270 then
				self:Message(-11155, "Neutral", nil, "90% - ".. CL.spawned:format(self:SpellName(-11155)), false)
				self:Bar(180004, 12) -- Enforcer's Onslaught
			elseif mobId == 90271 then
				self:Message(-11163, "Neutral", nil, "60% - ".. CL.spawned:format(self:SpellName(-11163)), false)
				self:Bar(180025, 15, CL.count:format(self:SpellName(180025), 1)) -- Harbinger's Mending
			elseif id == 90272 then
				self:Message(-11170, "Neutral", nil, "30% - ".. CL.spawned:format(self:SpellName(-11170)), false)
				self:Bar(180040, 14) -- Sovereign's Ward
			end
		end
	end
end

function mod:Deaths(args)
	if args.mobId == 90270 then
		self:StopBar(180004) -- Enforcer's Onslaught
	elseif args.mobId == 90271 then
		self:StopBar(CL.count:format(self:SpellName(180025), mendingCount)) -- Harbinger's Mending
	elseif args.mobId == 90272 then
		self:StopBar(180040) -- Sovereign's Ward
	end
end

-- Stage 1

function mod:EnforcersOnslaught(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, self:Mythic() and 11 or 18) -- 18.2-18.7
end

do
	local function printTarget(self, name, guid)
		local count = strikeCount > 0 and strikeCount or 3 -- delayed
		self:TargetMessage(180260, name, "Attention", "Info", CL.count:format(self:SpellName(180260), count), nil, nil, true)
		if self:Me(guid) then
			self:Say(180260)
		end
	end
	function mod:AnnihilatingStrike(args)
		strikeCount = strikeCount + 1
		self:GetBossTarget(printTarget, 0.7, args.sourceGUID)
		self:Bar(args.spellId, 3, CL.cast:format(CL.count:format(args.spellName, strikeCount)))
		if strikeCount > 2 then
			strikeCount = 0
		end
		self:Bar(args.spellId, strikeCount == 0 and 20 or 10, CL.count:format(args.spellName, strikeCount + 1)) -- 3 strikes between tempest
	end
end

function mod:InfernalTempestStart(args)
	self:Message(args.spellId, "Important", "Long", CL.incoming:format(args.spellName))
	self:Bar(args.spellId, 6.5, CL.cast:format(args.spellName))
	self:Bar(args.spellId, 40)
	self:OpenProximity(args.spellId, 3) -- 2+1 for safety
end

function mod:InfernalTempestEnd(args)
	self:CloseProximity(args.spellId)
end

-- Stage 2

function mod:AuraOfContempt()
	self:StopBar(CL.count:format(self:SpellName(180260), strikeCount)) -- Annihilating Strike
	self:StopBar(180300) -- Infernal Tempest
	phase = 2
	strikeCount = 0
	self:Message("stages", "Neutral", nil, "70% - ".. CL.phase:format(phase), false)
	self:Bar(180533, 5) -- Tainted Shadows
	self:Bar(180526, 22) -- Font of Corruption, 20sec timer + 2sec cast
end

function mod:HarbingersMending(args)
	self:Message(180025, "Attention", self:Interrupter() and "Alert", CL.casting:format(CL.count:format(args.spellName, mendingCount)))
	mendingCount = mendingCount + 1
	self:Bar(180025, self:Normal() and 16 or 11, CL.count:format(args.spellName, mendingCount))
end

function mod:HarbingersMendingApplied(args)
	self:TargetMessage(180025, args.destName, "Attention", self:Dispeller("magic", true) and "Alert", nil, nil, true)
end

function mod:TaintedShadows(args)
	strikeCount = strikeCount + 1
	if strikeCount > 2 then
		strikeCount = 0
	end
	self:Bar(args.spellId, strikeCount == 0 and 10 or 5, CL.count:format(args.spellName, strikeCount + 1)) -- 3 shadows between font
end

do
	local list = mod:NewTargetList()
	local function updateProximity(self, spellId)
		self:TargetMessage(spellId, list, "Important", "Alarm")
		if fontOnMe then -- stack near other fonts of corruption / away from the raid
			self:OpenProximity(spellId, 5, inverseFontTargets)
		end
	end
	function mod:FontOfCorruption(args)
		list[#list + 1] = args.destName
		if #list == 1 then
			self:ScheduleTimer(updateProximity, 0.3, self, args.spellId)
			self:Bar(args.spellId, 20)
		end
		if self:Me(args.destGUID) then
			local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
			if expires and expires > 0 then
				local timeLeft = expires - GetTime()
				self:TargetBar(args.spellId, timeLeft, args.destName)
				self:DelayedMessage(args.spellId, timeLeft - 5, "Personal", L.font_removed_soon, nil, "Alarm")
				self:ScheduleTimer("Flash", timeLeft - 5, args.spellId)
			end
			self:Flash(args.spellId)
			self:Say(args.spellId)
			fontOnMe = true
		else
			tDeleteItem(inverseFontTargets, args.destName)
		end
	end
end

do
	local scheduled = nil
	local function updateProximity(self, spellId)
		if fontOnMe then -- stack near other fonts of corruption / away from the raid
			self:OpenProximity(spellId, 5, inverseFontTargets)
		end
		scheduled = nil
	end
	function mod:FontOfCorruptionRemoved(args)
		if self:Me(args.destGUID) then
			self:CloseProximity(args.spellId)
			fontOnMe = nil
		elseif not tContains(inverseFontTargets, args.destName) then
			inverseFontTargets[#inverseFontTargets + 1] = args.destName
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(updateProximity, 0.3, self, args.spellId)
		end
	end
end

-- Stage 3

function mod:AuraOfMalice()
	self:StopBar(CL.count:format(self:SpellName(180533), strikeCount)) -- Tainted Shadows
	self:StopBar(180526) -- Font of Corruption
	phase = 3
	strikeCount = 0
	self:Message("stages", "Neutral", nil, "40% - ".. CL.phase:format(phase), false)
	self:Bar(180600, 10) -- Bulwark of the Tyrant
	self:Bar(180608, 40) -- Gavel of the Tyrant
end

function mod:SovereignsWard(args)
	self:Message(args.spellId, "Urgent", "Long")
	self:Bar(args.spellId, 25)
end

function mod:SovereignsWardRemoved(args)
	self:Message(args.spellId, "Positive", nil, CL.removed:format(args.spellName))
end

function mod:BulwarkOfTheTyrant(args)
	strikeCount = strikeCount + 1
	self:Message(args.spellId, "Attention", "Info", CL.count:format(args.spellName, strikeCount))
	if strikeCount > 2 then
		strikeCount = 0
	end
	self:Bar(args.spellId, strikeCount == 0 and 20 or 10, CL.count:format(args.spellName, strikeCount + 1)) -- 3 bulwarks between gavel
end

do
	local prev = 0
	function mod:DespoiledGroundDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Flash(180600) -- 180600 = Bulwark of the Tyrant
			self:Message(180600, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

function mod:GavelOfTheTyrant(args)
	self:Message(args.spellId, "Important", "Alert", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 40)
end

-- General

function mod:SealOfDecay(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 2 and "Warning")
end

function mod:TouchOfHarm(args)
	self:TargetMessage(185237, args.destName, "Urgent")
	self:Bar(185237, 45)
	if self:Me(args.destGUID) then
		self:Flash(185237) -- why is this flash?
	end
end

function mod:TouchOfHarmJumper(args)
	self:TargetMessage(185237, args.destName, "Urgent")
	if self:Me(args.destGUID) then
		self:Flash(185237)
	end
end

function mod:EdictOfCondemnation(args)
	self:TargetMessage(182459, args.destName, "Important", "Warning", nil, nil, true)
	self:TargetBar(182459, 9, args.destName)
	self:Bar(182459, 60)
	if self:Me(args.destGUID) then
		self:Say(182459)
	end
	self:PrimaryIcon(182459, args.destName)
end

function mod:EdictOfCondemnationRemoved(args)
	self:StopBar(args.spellName, args.destName)
	self:PrimaryIcon(182459)
end

