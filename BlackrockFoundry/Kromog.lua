
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kromog", 988, 1162)
if not mod then return end
mod:RegisterEnableMob(77692)
mod.engageId = 1713
mod.respawnTime = 29.5

--------------------------------------------------------------------------------
-- Locals
--

local breathCount = 1
local callOfTheMountainCount = 1
local tank1Skull, tank2Cross = nil, nil
local handsMarks = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.custom_off_hands_marker = "Grasping Earth tank marker"
	L.custom_off_hands_marker_desc = "Mark the Grasping Earth that picks up the tanks with {rt7}{rt8}, requires promoted or leader."
	L.custom_off_hands_marker_icon = 8

	L.prox = "Tank Proximity"
	L.prox_desc = "Open a 15 yard proximity showing the other tanks to help you deal with the Fists of Stone ability."
	L.prox_icon = 162349 -- Fists of Stone / warrior_talent_icon_singlemindedfury

	L.destroy_pillars = "Destroy Pillars"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Mythic ]]--
		173917, -- Rune of Trembling Earth
		158217, -- Call of the Mountain
		--[[ General ]]--
		{156766, "TANK"}, -- Warped Armor
		156852, -- Stone Breath
		156704, -- Slam
		157592, -- Rippling Smash
		-9702, -- Rune of Crushing Earth
		157060, -- Rune of Grasping Earth
		157054, -- Thundering Blows
		156861, -- Frenzy
		"custom_off_hands_marker",
		{"prox", "TANK", "PROXIMITY"},
		"berserk",
	}, {
		[173917] = "mythic",
		[156766] = "general"
	}
end

local function updateTanks(self)
	local _, _, _, myMapId = UnitPosition("player")
	local tankList = {}
	for unit in self:IterateGroup() do
		local _, _, _, tarMapId = UnitPosition(unit)
		if tarMapId == myMapId and self:Tank(unit) then
			local guid = UnitGUID(unit)
			if not self:Me(guid) then
				tankList[#tankList+1] = unit
			end
			if self:GetOption("custom_off_hands_marker") then
				if not tank1Skull then
					tank1Skull = guid
				elseif not tank2Cross then
					tank2Cross = guid
				end
			end
		end
	end
	if tankList[1] then
		self:OpenProximity("prox", 15, tankList, true)
	end
end

function mod:OnBossEnable()
	if IsEncounterInProgress() then
		updateTanks(self) -- Backup for disconnecting mid-combat
	end

	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_AURA_APPLIED", "WarpedArmor", 156766)
	self:Log("SPELL_AURA_APPLIED_DOSE", "WarpedArmor", 156766)
	self:Log("SPELL_CAST_SUCCESS", "StoneBreath", 156852)
	self:Log("SPELL_CAST_START", "Slam", 156704)
	self:Log("SPELL_CAST_START", "RipplingSmash", 157592, 173813) -- Standard smash, Mythic Call of the Mountain smash
	self:Log("SPELL_CAST_START", "GraspingEarth", 157060)
	self:Log("SPELL_CAST_START", "ThunderingBlows", 157054)
	self:Log("SPELL_AURA_REMOVED", "ThunderingBlowsOver", 157054)
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 156861)
	-- Mythic
	self:Log("SPELL_CAST_SUCCESS", "TremblingEarth", 173917)
	self:Log("SPELL_CAST_START", "CallOfTheMountainStart", 158217)
	self:Log("SPELL_CAST_SUCCESS", "CallOfTheMountainSuccess", 158217)
end

function mod:OnEngage()
	breathCount = 1
	callOfTheMountainCount = 1
	tank1Skull, tank2Cross = nil, nil
	self:CDBar(156852, 9, CL.count:format(self:SpellName(156852), breathCount)) -- Stone Breath
	self:CDBar(156766, 14) -- Warped Armor
	--self:CDBar(157592, 23) -- Rippling Smash -- Varies between 23 and 38 seconds...
	--self:CDBar(156704, 17) -- Slam -- Varies between 15 and 30 seconds...
	self:CDBar(157060, 50) -- Grasping Earth
	if self:Mythic() then
		self:CDBar(173917, 82) -- Trembling Earth
	end
	self:Berserk(540)
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")

	updateTanks(self)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Mythic

function mod:TremblingEarth(args)
	self:StopBar(CL.count:format(self:SpellName(156852), breathCount)) -- Stone Breath
	self:StopBar(157592) -- Rippling Smash
	self:StopBar(156766) -- Warped Armor
	self:StopBar(156704) -- Slam
	self:StopBar(args.spellName)

	callOfTheMountainCount = 1
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 25, L.destroy_pillars)
	self:Bar(158217, 31, CL.count:format(self:SpellName(158217), callOfTheMountainCount)) -- Call of the Mountain
end

function mod:CallOfTheMountainStart(args)
	self:Message(args.spellId, "Important", nil, CL.count:format(args.spellName, callOfTheMountainCount))
	callOfTheMountainCount = callOfTheMountainCount + 1
end

function mod:CallOfTheMountainSuccess(args)
	if callOfTheMountainCount < 4 then
		self:Bar(args.spellId, 12, CL.count:format(args.spellName, callOfTheMountainCount))
	else -- Last Call of the Mountain ends, start other ability bars
		self:CDBar(173917, 125) -- Trembling Earth
		self:CDBar(157592, 17) -- Rippling Smash
		self:CDBar(156852, 6, CL.count:format(self:SpellName(156852), breathCount)) -- Stone Breath
	end
end

-- General

function mod:UNIT_HEALTH_FREQUENT(unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < 35 then
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
		self:Message(156861, "Neutral", "Info", CL.soon:format(self:SpellName(156861))) -- Frenzy
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 156980 then -- Rune of Crushing Earth
		self:Message(-9702, "Attention")
		--self:Bar(spellId, 5, "Clap!")
	end
end

function mod:WarpedArmor(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Attention", args.amount and "Warning") -- swap at 2 or 3 stacks
	self:CDBar(args.spellId, 14)
end

function mod:StoneBreath(args)
	self:Message(args.spellId, "Urgent", nil, CL.casting:format(CL.count:format(args.spellName, breathCount)))
	breathCount = breathCount + 1
	self:CDBar(args.spellId, 24, CL.count:format(args.spellName, breathCount))
end

function mod:Slam(args)
	self:Message(args.spellId, "Urgent", self:Melee() and "Alarm", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 24)
end

function mod:RipplingSmash(args)
	self:Message(157592, "Urgent", "Alert")
	if args.spellId == 157592 then
		self:CDBar(args.spellId, self:Mythic() and 41 or 24) -- 22-29
	end
	-- second cast is always skipped in mythic, it comes off cd during a stone breath->pillars->call combo
	-- next cast happens 72-88s after pillars, so what happened to the third cast? sigh.
end

do
	function mod:UNIT_TARGET(_, firedUnit)
		local unit = firedUnit and firedUnit.."target" or "mouseover"
		local guid = UnitGUID(unit)
		if not handsMarks[guid] and self:MobId(guid) == 77893 then -- Grasping Earth
			local unitTarget = unit.."target"
			local tarGuid = UnitGUID(unitTarget)
			if tarGuid then
				handsMarks[guid] = true
				if tarGuid == tank1Skull then
					SetRaidTarget(unit, 8)
				elseif tarGuid == tank2Cross then
					SetRaidTarget(unit, 7)
				end
			end
		end
	end

	function mod:GraspingEarth(args)
		self:Message(args.spellId, "Positive", "Info")
		self:CDBar(args.spellId, 112) -- 112-114
		self:CDBar(157054, 13) -- Thundering Blows

		self:StopBar(156766) -- Warped Armor
		self:StopBar(156704) -- Slam
		self:StopBar(157592) -- Rippling Smash

		self:CDBar(156852, 31, CL.count:format(self:SpellName(156852), breathCount)) -- Stone Breath

		if self:GetOption("custom_off_hands_marker") then
			wipe(handsMarks)
			self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "UNIT_TARGET")
			self:RegisterEvent("UNIT_TARGET")
		end
	end

	function mod:ThunderingBlowsOver()
		if self:GetOption("custom_off_hands_marker") then
			self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
			self:UnregisterEvent("UNIT_TARGET")
		end
	end
end

function mod:ThunderingBlows(args)
	self:Message(args.spellId, "Important", nil, CL.casting:format(args.spellName))
	self:Bar(args.spellId, 7, CL.cast:format(args.spellName))
end

function mod:Frenzy(args)
	self:Message(args.spellId, "Important", "Alarm")
end

