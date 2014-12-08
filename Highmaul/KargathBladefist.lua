
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kargath Bladefist", 994, 1128)
if not mod then return end
mod:RegisterEnableMob(78714)
mod.engageId = 1721

--------------------------------------------------------------------------------
-- Locals
--

local tigers = {}
local sweeperCount = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.tiger_trigger = ""

	L.blade_dance_bar = "Dancing"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Mythic ]]--
		-9396, -- Ravenous Bloodmaw
		{162497, "FLASH"}, -- On the Hunt
		--177776, -- Arena Sweeper
		--[[ General ]]--
		-9394, -- Fire Pillar
		{159113, "TANK_HEALER"}, -- Impale
		159250, -- Blade Dance
		{158986, "SAY", "ICON", "FLASH"}, -- Berserker Rush
		159947, -- Chain Hurl
		159413, -- Mauling Brew
		159311, -- Flame Jet
		160521, -- Vile Breath
		"bosskill"
	}, {
		[-9396] = "mythic",
		[-9394] = "general"
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")

	self:Log("SPELL_AURA_APPLIED", "FlamePillar", 159202)
	self:Log("SPELL_CAST_START", "Impale", 159113)
	self:Log("SPELL_AURA_APPLIED", "BladeDance", 159250)
	self:Log("SPELL_CAST_START", "BerserkerRush", 158986)
	self:Log("SPELL_AURA_REMOVED", "BerserkerRushRemoved", 158986)
	self:Log("SPELL_CAST_START", "ChainHurl", 159947)
	self:Log("SPELL_AURA_APPLIED", "ChainHurlApplied", 159947)
	self:Log("SPELL_PERIODIC_DAMAGE", "FlameJetDamage", 159311)
	self:Log("SPELL_PERIODIC_MISSED", "FlameJetDamage", 159311)
	self:Log("SPELL_PERIODIC_DAMAGE", "MaulingBrewDamage", 159413)
	self:Log("SPELL_PERIODIC_MISSED", "MaulingBrewDamage", 159413)
	self:Log("SPELL_CAST_START", "VileBreath", 160521)
	-- Mythic
	--self:Emote("TigerSpawn", L.tiger_trigger)
	self:Log("SPELL_AURA_APPLIED", "OnTheHunt", 162497)
	--self:Log("SPELL_AURA_APPLIED", "ArenaSweeper", 177776)
end

function mod:OnEngage()
	self:Bar(-9394, 20) -- Flame Pillar
	self:CDBar(159113, 37) -- Impale
	self:CDBar(158986, 48) -- Berserker Rush
	self:CDBar(159947, 90) -- Chain Hurl
	if self:Mythic() then
		wipe(tigers)
		self:Bar(-9396, 110, nil, "ability_druid_tigersroar") -- Ravenous Bloodmaw
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	self:CheckForEncounterEngage()
	if self:Mythic() then
		for i=1, 5 do
			local guid = UnitGUID(("boss%d"):format(i))
			if guid and self:MobId(guid) == 79296 and not tigers[guid] then -- or 80474?
				tigers[guid] = true
				self:Message(-9396, "Neutral", nil, nil, false) -- Ravenous Bloodmaw
				self:Bar(-9396, 110, nil, "ability_druid_tigersroar")
			end
		end
	end
end

function mod:OnTheHunt(args)
	self:TargetMessage(args.spellId, args.destName, "Important", "Alarm")
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	end
end

function mod:ArenaSweeper(args)
	--sweeperCount = sweeperCount + 1 -- odd clockwise, even anti-clockwise
	if UnitDebuff("player", self:SpellName(159213)) then -- Monster's Brawl (hurled)
		self:Message(args.spellId, "Urgent", "Alert", CL.incoming(args.spellName))
	end
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(159113, name, "Urgent", "Warning", nil, nil, true)
		self:TargetBar(159113, 8.8, name) -- cast+channel
	end
	function mod:Impale(args)
		self:GetBossTarget(printTarget, 0.5, args.sourceGUID)
		self:CDBar(args.spellId, 43) -- delayed by chain hurl/berserker rush
	end
end

function mod:BladeDance(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 10, L.blade_dance_bar)
	--self:CDBar(args.spellId, 20)
end

do
	local function printTarget(self, name, guid)
		self:PrimaryIcon(158986, name)
		if self:Me(guid) then
			self:Say(158986)
			self:Flash(158986)
		end
		self:TargetMessage(158986, name, "Important", "Alarm", nil, nil, true)
	end
	function mod:BerserkerRush(args)
		self:GetBossTarget(printTarget, 0.5, args.sourceGUID)
		-- cd is 45-70 :\
	end
end

function mod:FlamePillar(args)
	self:Bar(-9394, 20)
end

function mod:BerserkerRushRemoved(args)
	self:PrimaryIcon(args.spellId)
end

do
	local hurlList, scheduled = mod:NewTargetList(), nil

	local function printTargets(spellId)
		mod:TargetMessage(spellId, hurlList, "Attention")
		scheduled = nil
	end

	function mod:ChainHurl(args)
		self:Message(args.spellId, "Urgent", "Alert", CL.incoming:format(args.spellName))
		self:Bar(args.spellId, 3.4)
		--sweeperCount = 0
	end

	function mod:ChainHurlApplied(args)
		hurlList[#hurlList+1] = args.destName
		if self:Me(args.destGUID) then
			--self:Bar(177776, 44) -- Arena Sweeper
		end
		if not scheduled then
			self:Bar(args.spellId, 103)
			scheduled = self:ScheduleTimer(printTargets, 0.1, args.spellId)
		end
	end
end

do
	local prev = 0
	function mod:MaulingBrewDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			self:Message(args.spellId, "Personal", "Info", CL.underyou:format(args.spellName))
			prev = t
		end
	end
end

do
	local prev = 0
	function mod:FlameJetDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			self:Message(args.spellId, "Personal", "Info", CL.underyou:format(args.spellName))
			prev = t
		end
	end
end

function mod:VileBreath(args)
	if UnitDebuff("player", self:SpellName(159213)) then -- Monster's Brawl (hurled)
		self:Message(args.spellId, "Attention", "Alarm")
	end
end

