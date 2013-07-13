--[[
TODO:
	-- look into if tank or healers need some special warning for the inside phase
]]--

if select(4, GetBuildInfo()) < 50400 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Norushen", 953, 866)
if not mod then return end
mod:RegisterEnableMob(72276, 71977, 71976, 71967) -- Amalgam of Corruption, Manifestation of Corruption, Essence of Corruption, Norushen

--------------------------------------------------------------------------------
-- Locals
--

local bigAddCounter = 0
local lookWithinList = mod:NewTargetList()
local phase = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.big_adds = "Big adds"
	L.big_adds_desc = "Warning for killing big adds inside/outside"
	L.big_add = "Big add! (%d)"
	L.big_add_killed = "Big add killed! (%d)"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{-8218, "TANK_HEALER"}, 145226, 145132,-- Amalgam of Corruption
		"big_adds",
		-8220, 144482,
		"stages", "berserk", "bosskill",
	}, {
		[-8218] = -8216, -- Amalgam of Corruption
		["big_adds"] = L.big_adds, -- Big add
		[-8220] = -8220, -- Look Within
		["stages"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- Look Within
	self:Log("SPELL_CAST_START", "TearReality", 144482)
	self:Log("SPELL_AURA_REMOVED", "LookWithinRemoved", 144851, 144850, 144849) -- Test of Serenity (DPS), Test of Reliance (HEALER), Test of Confiidence (TANK)
	self:Log("SPELL_AURA_APPLIED", "LookWithinApplied", 144851, 144850, 144849) -- Test of Serenity (DPS), Test of Reliance (HEALER), Test of Confiidence (TANK)
	-- Amalgam of Corruption
	self:Log("SPELL_AURA_APPLIED_DOSE", "Fusion", 145132)
	self:Log("SPELL_AURA_APPLIED", "Fusion", 145132)
	self:Log("SPELL_AURA_APPLIED", "BlindHatred", 145226)
	self:Log("SPELL_CAST_START", "UnleashedAnger", 145216)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEDED", nil, "boss1")
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")

	self:AddSyncListener("BlindHatred")
	self:AddSyncListener("InsideBigAddDeath")
	self:AddSyncListener("OutsideBigAddDeath")

	self:Death("Deaths", 72276, 71977, 72264) -- Amalgam of Corruption, Manifestation of Corruption, Unleashed Manifestation of Corruption
end

function mod:OnEngage()
	bigAddCounter = 0
	phase = 1
	self:Berserk(420)
	self:Bar(145226, 25) -- Blind Hatred
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Look Within
function mod:TearReality(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:CDBar(args.spellID, 8) -- any point for this?
end

function mod:LookWithinRemoved(args)
	lookWithinList[#lookWithinList+1] = args.destName
	self:ScheduleTimer("TargetMessage", 1, -8220, lookWithinList, "Neutral", nil, CL["over"]:format(EJ_GetSectionInfo(-8220))) -- we care about people coming out, not so much going in
	self:StopBar(-8220) -- personal bar
	self:StopBar(144849, args.destName) -- other tank bar
end

function mod:LookWithinApplied(args)
	if args.spellId == 144849 and self:Tank() then -- Test of Confiidence (TANK) mainly for the other tank
		self:TargetBar(-8220, 60, args.destName, nil, args.spellId)
	elseif self:Me(args.destGUID) then
		self:Bar(-8220, 60, nil, args.spellId)
	end
end

-- General and syncing
function mod:UNIT_SPELLCAST_SUCCEDED(unitId, spellName, _, _, spellId)
	if spellId == 146179 then -- Frayed -- p2 trigger
		phase = 2
		self:Message("stages", "Neutral", "Warning", CL["phase"]:format(phase), 146179)
	elseif spellId == 145007 then -- Unleash Corruption -- spawns adds in p2
		-- don't think this needs sync
		bigAddCounter = bigAddCounter + 1
		self:Message("big_adds", "Urgent", "Alarm", L["big_add"]:format(bigAddCounter))
	end
end

function mod:OnSync(sync)
	if sync == "BlindHatred" then
		self:Message(145226, "Important", "Long")
		self:Bar(145226, 60)
	-- Big add messages are assuming you are not having two up at the same time
	elseif sync == "InsideBigAddDeath" then
		bigAddCounter = bigAddCounter + 1
		self:Message("big_adds", "Urgent", "Alarm", L["big_add"]:format(bigAddCounter))
	elseif sync == "OutsideBigAddDeath" then
		self:Message("big_adds", "Attention", "Alert", L["big_add_killed"]:format(bigAddCounter)) -- this could probably live wouthout sound but this way people know for sure that they need to check if it is their turn to soak
	end
end

function mod:Deaths(args)
	if args.mobId == 72276 then
		self:Win()
	elseif args.mobId == 71977 then -- Big add inside (Manifestation of Corruption)
		self:Sync("InsideBigAddDeath")
	elseif args.mobId == 72264 then -- Big add outside (Unleashed Manifestation of Corruption)
		if phase == 1 then
			self:Sync("OutsideBigAddDeath")
		else -- don't do unnecesary syncing
			self:Message("big_adds", "Attention", nil, L["big_add_killed"]:format(bigAddCounter))
		end
	end
end

-- Amalgam of Corruption
function mod:Fusion(args)
	local amount = args.amount or 1
	self:Message(args.spellId, "Attention", nil, CL["count"]:format(amount))
end

function mod:UNIT_HEALTH_FREQUENT(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if hp < 53 then -- 50%
		self:Message("stages", "Neutral", "Info", CL["soon"]:format(CL["phase"]:format(2)))
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1")
	end
end

function mod:BlindHatred()
	self:Sync("BlindHatred")
end

function mod:UnleashedAnger(args)
	self:Message(-8218, "Attention")
	self:CDBar(-8218, 10)
end

