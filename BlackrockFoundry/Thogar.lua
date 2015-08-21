
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Operator Thogar", 988, 1147)
if not mod then return end
mod:RegisterEnableMob(76906, 80791) -- Operator Thogar, Grom'kar Man-at-Arms
mod.engageId = 1692
mod.respawnTime = 29.5

--------------------------------------------------------------------------------
-- Locals
--

local engageTime = 0
-- times are for when the train is about to enter the room, ~5s after the door opens

local trainData = {
	-- heroic/normal data
	[1] = {
		{ 32, "adds_train"},
		{107, "train"},
		{162, "train"},
		{172, "cannon_train"},
		{237, "train"},
		{272, "train"},
		{307, "cannon_train", 4},
		{407, "train"},
		{417, "cannon_train", 4},
		{467, "train"},
		{495, "train"},
	},
	[2] = {
		{ 27, "train"},
		{ 77, "train"},
		{122, "adds_train", 3},
		{187, "train"},
		{227, "train"},
		{252, "big_add_train", 4},
		{317, "train"},
		{342, "train"},
		{372, "adds_train", 3},
		{433, "train"},
		{490, "train"},
	},
	[3] = {
		{ 47, "train"},
		{ 82, "big_add_train"},
		{122, "adds_train", 2},
		{217, "train"},
		{277, "train"},
		{372, "big_add_train", 2},
		{442, "train"},
		{462, "adds_train"},
		{487, "train"},
	},
	[4] = {
		{ 17, "train"},
		{ 52, "cannon_train"},
		{162, "train"},
		{197, "adds_train"},
		{252, "cannon_train", 2},
		{307, "cannon_train", 1},
		{387, "train"},
		{417, "adds_train", 1},
		{467, "train"},
	},
}

local trainDataLFR = {
	-- LFR data
	[1] = {
		{ 32, "adds_train"},
		{107, "train"},
		{162, "train"},
		{172, "cannon_train"},
		{237, "train"},
		{272, "train"},
		{307, "cannon_train", 4},
		{407, "train"},
		{417, "cannon_train", 4},
		{467, "train"},
		{495, "train"},
	},
	[2] = {
		{ 27, "train"},
		{ 77, "train"},
	--	{122, "adds_train", 3}, -- No first split in LFR
		{187, "train"},
		{227, "train"},
		{252, "big_add_train", 4},
		{317, "train"},
		{342, "train"},
		{372, "adds_train", 3},
		{433, "train"},
		{490, "train"},
	},
	[3] = {
		{ 47, "train"},
		{ 82, "big_add_train"},
		{122, "adds_train", 2},
		{217, "train"},
		{277, "train"},
		{372, "big_add_train", 2},
		{442, "train"},
		{462, "adds_train"},
		{487, "train"},
	},
	[4] = {
		{ 17, "train"},
		{ 52, "cannon_train"},
		{162, "train"},
		{197, "adds_train"},
		{252, "cannon_train", 2},
		{307, "cannon_train", 1},
		{387, "train"},
		{417, "adds_train", 1},
		{467, "train"},
	},
}

local trainDataMythic = {
	-- mythic data
	[1] = {
		{ 17, "deforester"},
		{ 57, "random"},
		{ 72, "random"},
		{ 82, "cannon_train", 4},
		{172, "train", 4},
		{177, "deforester", 4},
		{217, "random"},
		{232, "random"},
		{246, "big_add_train", 4},
		{262, "deforester"},
		{322, "train", 4},
		{347, "random"},
		{363, "random"},
		{370, "cannon_train", 4},
		{412, "train", 4},
		{427, "adds_train", 4},
		{467, "big_add_train"},
		{477, "random"},
		{491, "random"},
	},
	[2] = {
		{ 23, "train"},
		{ 57, "random"},
		{ 72, "random"},
		{ 97, "train"},
		{146, "adds_train", 3},
		{199, "train", 3},
		{217, "random"},
		{232, "random"},
		{267, "train", 3},
		{288, "train", 3},
		{302, "adds_train", 3},
		{333, "train", 3},
		{347, "random"},
		{363, "random"},
		{393, "deforester", 3},
		{427, "train"},
		{452, "train"},
		{477, "random"},
		{491, "random"},
	},
	[3] = {
		{ 37, "train"},
		{ 57, "random"},
		{ 72, "random"},
		{ 112, "train"},
		{146, "adds_train", 2},
		{187, "train"},
		{199, "train", 2},
		{217, "random"},
		{232, "random"},
		{267, "train", 2},
		{288, "train", 2},
		{302, "big_add_train", 2},
		{333, "train", 2},
		{347, "random"},
		{363, "random"},
		{393, "deforester", 2},
		{442, "deforester"},
		{477, "random"},
		{491, "random"},
	},
	[4] = {
		{ 12, "big_add_train"},
		{ 57, "random"},
		{ 72, "random"},
		{ 84, "cannon_train", 1},
		{172, "train", 1},
		{177, "deforester", 1},
		{217, "random"},
		{232, "random"},
		{246, "cannon_train", 1},
		{322, "train", 1},
		{347, "random"},
		{363, "random"},
		{370, "adds_train", 1},
		{412, "train", 1},
		{427, "deforester", 1},
		{477, "random"},
		{491, "random"},
	},
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.custom_on_firemender_marker = "Grom'kar Firemender marker"
	L.custom_on_firemender_marker_desc = "Marks Grom'kar Firemender with {rt7}, requires promoted or leader."
	L.custom_on_firemender_marker_icon = 7

	L.custom_on_manatarms_marker = "Grom'kar Man-at-Arms marker"
	L.custom_on_manatarms_marker_desc = "Marks Man-at-Arms with {rt8}, requires promoted or leader."
	L.custom_on_manatarms_marker_icon = 8

	L.trains = "Train warnings"
	L.trains_desc = "Shows timers and messages for each lane for when the next train is coming. Lanes are numbered from the boss to the entrace, ie, Boss 1 2 3 4 Entrance."
	L.trains_icon = "achievement_dungeon_blackrockdepot"

	L.lane = "Lane %s: %s"
	L.train = "Train"
	L.adds_train = "Adds train"
	L.big_add_train = "Big add train"
	L.cannon_train = "Cannon train"
	L.deforester = "Deforester" -- /dump (EJ_GetSectionInfo(10329))
	L.random = "Random trains"

	L.train_you = "Train on your lane! (%d)"
end

local icons = { -- pull these out of the locale table
	train = "achievement_dungeon_blackrockdepot",
	adds_train = "warrior_talent_icon_furyintheblood", -- angry orc face
	big_add_train = "warrior_talent_icon_skirmisher", -- one dude standing alone
	cannon_train = "ability_vehicle_siegeenginecannon",
	deforester = "spell_shaman_lavasurge",
	random = "ability_foundryraid_traindeath",
}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Reinforcements ]]--
		"custom_on_manatarms_marker",
		"custom_on_firemender_marker",
		163753, -- Iron Bellow
		160140, -- Cauterizing Bolt
		{159481, "FLASH", "SAY"}, -- Delayed Siege Bomb (Bombs)
		--[[ General ]]--
		{155921, "TANK"}, -- Enkindle
		{155864, "SAY"}, -- Prototype Pulse Grenade (Grenade)
		{"trains", "FLASH"},
	}, {
		["custom_on_manatarms_marker"] = -9537, -- Reinforcements
		[155921] = "general",
	}
end

function mod:VerifyEnable()
	local y = UnitPosition("player")
	if y > 430 then
		return true
	end
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Enkindle", 155921)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Enkindle", 155921)
	self:Log("SPELL_CAST_SUCCESS", "PulseGrenade", 155864)
	self:Log("SPELL_AURA_APPLIED", "PulseGrenadeDamage", 165195)
	self:Log("SPELL_AURA_APPLIED_DOSE", "PulseGrenadeDamage", 165195)
	self:Log("SPELL_CAST_START", "IronBellow", 163753)
	self:Log("SPELL_CAST_START", "CauterizingBolt", 160140)
	self:Log("SPELL_AURA_APPLIED", "CauterizingBoltApplied", 160140)
	self:Log("SPELL_CAST_START", "DelayedSiegeBomb", 159481)
	self:Log("SPELL_AURA_APPLIED", "DelayedSiegeBombApplied", 159481)
	self:Log("SPELL_AURA_REMOVED", "DelayedSiegeBombRemoved", 159481)

	self:Death("Deaths", 80791) -- Grom'kar Man-at-Arms
end

function mod:OnEngage()
	self:CDBar(155864, 7, 135592, 155864) -- Pulse Grenade, 135592 = "Grenade"
	self:CDBar(155921, 4) -- Enkindle
	engageTime = GetTime()
	-- bar for each lane seemed to make the most sense
	for i = 1, 4 do
		self:StartTrainTimer(i, 1)
	end
	-- 15s warning on splits
	local split = self:SpellName(143020)
	if self:Mythic() then
		self:DelayedMessage("trains", 130, "Neutral", CL.custom_sec:format(CL.count:format(split, 1), 15), false, "Long")
		self:DelayedMessage("trains", 286, "Neutral", CL.custom_sec:format(CL.count:format(split, 2), 15), false, "Long")
	else
		if not self:LFR() then
			self:DelayedMessage("trains", 106, "Neutral", CL.custom_sec:format(CL.count:format(split, 1), 15), false, "Long")
		end
		self:DelayedMessage("trains", 356, "Neutral", CL.custom_sec:format(CL.count:format(split, 2), 15), false, "Long")
	end
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	self:RegisterUnitEvent("UNIT_TARGET", "GrenadeTarget", "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	for i = 1, 5 do
		local unit = ("boss%d"):format(i)
		local id = self:MobId(UnitGUID(unit))
		if id == 80791 and self:GetOption("custom_on_manatarms_marker") then -- Grom'kar Man-at-Arms
			SetRaidTarget(unit, 8)
		elseif id == 77487 and self:GetOption("custom_on_firemender_marker") then -- Grom'kar Firemender
			SetRaidTarget(unit, 7)
		end
	end
end

local function checkLane(warnLane)
	if UnitIsDead("player") then return end
	-- nice square room!
	local lane = 0
	local pos = UnitPosition("player")
	if pos < 529.7 then lane = 4
	elseif pos > 577.7 then lane = 1
	elseif pos > 553.7 then lane = 2
	elseif pos < 553.8 then	lane = 3 end

	if lane == warnLane then
		mod:Message("trains", "Personal", "Info", L.train_you:format(lane), false)
		mod:Flash("trains", L.trains_icon)
	end
end

local randomCount = 0
function mod:StartTrainTimer(lane, count)
	local data = self:Mythic() and trainDataMythic or self:LFR() and trainDataLFR or trainData
	local info = data and data[lane][count]
	if not info then
		-- all out of lane data
		return
	end

	local time, type = unpack(info)
	local length = floor(time - (GetTime() - engageTime))
	if type ~= "random" then
		if type ~= "train" then -- no messages for the non-stop trains
			self:DelayedMessage("trains", length-1, "Neutral", CL.incoming:format(L[type]), false) -- Incoming Adds train!
		end
		self:CDBar("trains", length, L.lane:format(type ~= "random" and lane or "?", L[type]), icons[type]) -- Lane 1: Adds train
		self:ScheduleTimer("StartTrainTimer", length, lane, count+1)
		self:ScheduleTimer(checkLane, length-1, lane) -- gives you ~2s to move
	else -- random
		if lane == 1 then -- only show one bar
			local pad = strrep(" ", randomCount) -- hack so i can have two bars/messages for the same thing up
			self:DelayedMessage("trains", length-5, "Neutral", CL.soon:format(L[type])..pad, false) -- Random trains soon!
			self:CDBar("trains", length, L[type]..pad, icons[type]) -- Random trains
			randomCount = 1 - randomCount
		end
		self:StartTrainTimer(lane, count+1)
	end
end

-- General

function mod:Enkindle(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Attention", args.amount and "Warning")
	self:CDBar(args.spellId, 12) -- can be delayed by Pulse Grenade for ~2s
end

do
	function mod:GrenadeTarget(unit)
		local target = unit.."target"
		local guid = UnitGUID(target)
		if not guid or UnitDetailedThreatSituation(target, unit) ~= false or self:MobId(guid) ~= 1 then return end

		local grenade = self:SpellName(135592) -- Grenade
		if self:Me(guid) and not self:LFR() then
			self:Say(155864, grenade)
		elseif self:Range(target) < 10 then
			self:RangeMessage(155864, "Personal", "Alarm", grenade)
			return
		end
		self:TargetMessage(155864, self:UnitName(target), "Attention", nil, grenade)
	end

	local prev = 0
	function mod:PulseGrenade(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:CDBar(args.spellId, 12, 135592, args.spellId) -- 135592 = "Grenade"
		end
	end
end

function mod:PulseGrenadeDamage(args)
	if self:Me(args.destGUID) then
		self:Message(155864, "Personal", "Alarm", CL.underyou:format(self:SpellName(135592))) -- 135592 = "Grenade"
	end
end

function mod:IronBellow(args)
	self:Message(args.spellId, "Urgent")
	self:CDBar(args.spellId, 12)
end

function mod:CauterizingBolt(args)
	self:Message(args.spellId, "Important", "Alert")
end

function mod:CauterizingBoltApplied(args)
	if UnitGUID("target") == args.destGUID and self:Dispeller("magic", true) then
		self:TargetMessage(args.spellId, args.destName, "Important", "Alert", nil, nil, true)
	end
end

do
	local function printTarget(self, name, guid)
		-- 119342 = Bombs
		self:TargetMessage(159481, name, "Attention", "Warning", 119342, 159481)
		if self:Me(guid) then
			self:Flash(159481)
			self:Say(159481, 119342)
			self:TargetBar(159481, 4.9, name, CL.count:format(self:SpellName(155192), 1)) -- 155192 = "Bomb"
		end
	end

	function mod:DelayedSiegeBomb(args)
		self:GetBossTarget(printTarget, 0.2, args.sourceGUID)
	end
end

do
	local timer, bombCount = nil, 1
	local function sayBombCount(self, name)
		-- 155192 = "Bomb"
		self:Say(159481, CL.count:format(self:SpellName(155192), bombCount), true)
		bombCount = bombCount + 1
		if bombCount < 4 then
			self:TargetBar(159481, 3, name, CL.count:format(self:SpellName(155192), bombCount))
			timer = self:ScheduleTimer(sayBombCount, bombCount == 3 and 2.8 or 3, self, name)
		end
	end

	function mod:DelayedSiegeBombApplied(args)
		if self:Me(args.destGUID) then
			if timer then self:CancelTimer(timer) end
			bombCount = 1
			sayBombCount(self, args.destName)
		end
	end

	function mod:DelayedSiegeBombRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelTimer(timer)
			timer = nil
			self:StopBar(CL.count:format(self:SpellName(155192), bombCount), args.destName)
		else
			self:StopBar(119342, args.destName) -- 119342 = Bombs
		end
	end
end

function mod:Deaths(args)
	if args.mobId == 80791 then
		self:StopBar(163753) -- Iron Bellow
	end
end

