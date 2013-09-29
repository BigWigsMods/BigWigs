--[[
TODO:
	look into doing :win without trigger that requires localization
	could maybe hook into the world state timer, but I'm not sure if there is much point to work on a code just for that
	could maybe pre warn for keg toss at least for one of the targets
]]--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Spoils of Pandaria", 953, 870)
if not mod then return end
mod:RegisterEnableMob(71889, 73720, 71512) -- Secured Stockpile of Pandaren Spoils, Mogu Spoils, Mantid Spoils

--------------------------------------------------------------------------------
-- Locals
--

local setToBlow = {}
local remaining
local brewmasterMarked

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.win_trigger = "System resetting. Don't turn the power off, or the whole thing will probably explode."

	L.matter_scramble_explosion = "Matter Scramble explosion" -- shorten maybe?

	L.custom_off_mark_brewmaster = "Brewmaster marker"
	L.custom_off_mark_brewmaster_desc = "Mark the Ancient Brewmaster Spirit with %s"
end
L = mod:GetLocale()
L.custom_off_mark_brewmaster_desc = L.custom_off_mark_brewmaster_desc:format("\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_4.blp:15\124t")

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		145288, {145461, "TANK"}, {142947, "TANK"}, -- Mogu crate
		{145987, "PROXIMITY", "FLASH"}, 145747, {145692, "TANK"}, 145715, 145786,-- Mantid crate
		{146217, "FLASH"}, 146222, 146257, -- Crate of Panderan Relics
		"custom_off_mark_brewmaster",
		"proximity", "bosskill",
	}, {
		[145288] = -8434, -- Mogu crate
		[145987] = -8439, -- Mantid crate
		[146217] = -8366, -- Crate of Panderan Relics
		["custom_off_mark_brewmaster"] = L.custom_off_mark_brewmaster,
		["proximity"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- Crate of Panderan Relics
	self:Log("SPELL_DAMAGE", "PathOfBlossoms", 146257)
	self:Log("SPELL_CAST_START", "BreathOfFire", 146222)
	self:Log("SPELL_AURA_APPLIED", "KegToss", 146217)
	-- Mogu crate
	self:Log("SPELL_CAST_START", "CrimsonReconstitution", 142947)
	self:Log("SPELL_CAST_START", "MoguRuneOfPower", 145461)
	self:Log("SPELL_CAST_START", "MatterScramble", 145288)
	-- Mantid crate
	self:Log("SPELL_CAST_START", "Residue", 145790)
	self:Log("SPELL_CAST_START", "ResidueStart", 145786)
	self:Log("SPELL_DAMAGE", "BlazingCharge", 145715)
	self:Log("SPELL_AURA_APPLIED", "BlazingCharge", 145716)
	self:Log("SPELL_AURA_APPLIED", "WarcallerEnrage", 145692)
	self:Log("SPELL_DAMAGE", "BubblingAmber", 145748)
	self:Log("SPELL_AURA_APPLIED", "BubblingAmber", 145747)
	self:Log("SPELL_AURA_APPLIED", "SetToBlowApplied", 145987)
	self:Log("SPELL_AURA_REMOVED", "SetToBlowRemoved", 145987)

	self:Yell("Win", L.win_trigger)
end

function mod:OnEngage()
	wipe(setToBlow)
	self:OpenProximity("proximity", 3)
	remaining = nil
	brewmasterMarked = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Crate of Panderan Relics

do
	local prev = 0
	function mod:PathOfBlossoms(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then -- don't spam
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
		end
	end
end

do
	local timer
	local function markBrewmaster(GUID)
		local brewmaster = mod:GetUnitIdByGUID(GUID)
		if brewmaster and brewmasterMarked ~= GUID then
			brewmasterMarked = GUID
			mod:CancelTimer(timer)
			timer = nil
			SetRaidTarget(brewmaster, 4)
		end
	end
	function mod:BreathOfFire(args)
		if self.db.profile.custom_off_mark_brewmaster and not timer then
			timer = self:ScheduleRepeatingTimer(markBrewmaster, 0.1, args.sourceGUID)
		end
		local debuffed =  UnitDebuff("player", self:SpellName(146217)) -- Keg Toss
		self:Message(args.spellId, "Attention", debuffed and "Long")
		if debuffed then
			self:Flash(146217) -- flash again
		end
	end
	function mod:KegToss(args)
		if self.db.profile.custom_off_mark_brewmaster and not timer then
			timer = self:ScheduleRepeatingTimer(markBrewmaster, 0.1, args.sourceGUID)
		end
		markBrewmaster(args.sourceGUID)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", "Info")
			self:Flash(args.spellId)
		end
	end
end

-- Mogu crate
function mod:CrimsonReconstitution(args)
	self:Message(args.spellId, "Urgent", "Alarm")
end

function mod:MoguRuneOfPower(args)
	self:Message(args.spellId, "Urgent", "Alarm")
end

function mod:MatterScramble(args)
	self:Message(args.spellId, "Important", "Alert")
	self:Bar(args.spellId, 8, L["matter_scramble_explosion"])
end

-- Mantid crate
do
	local prev = 0
	function mod:Residue(args)
		local t = GetTime()
		if t-prev > 2 and self:Dispeller("magic", true) then
			self:Message(args.spellId, "Urgent", "Alarm")
		end
	end
end

function mod:ResidueStart(args)
	if self:Dispeller("magic", true) then
		self:Message(args.spellId, "Attention", nil, CL["casting"]:format(args.spellName))
	end
end

function mod:WarcallerEnrage(args)
	self:Message(args.spellId, "Urgent", "Alarm")
end

do
	local prev = 0
	function mod:BlazingCharge(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then -- don't spam
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
		end
	end
end

do
	local prev = 0
	function mod:BubblingAmber(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then -- don't spam
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
		end
	end
end

do
	local function findPlayerInIndexedTable(t, player)
		for k, name in next, t do
			if name == player then
				return k
			end
		end
		return false
	end
	function mod:SetToBlowRemoved(args)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Positive", nil, CL["over"]:format(args.spellName))
			self:StopBar(args.spellId, args.destName)
			if #setToBlow > 0 then
				self:CloseProximity("proximity")
				self:OpenProximity(args.spellId, 12, setToBlow)
			end
		else
			local index = findPlayerInIndexedTable(setToBlow, args.destName)
			if index then
				tremove(setToBlow, index)
			end
			if #setToBlow == 0 then
				self:CloseProximity(args.spellId)
				self:OpenProximity("proximity", 3)
			else
				self:CloseProximity("proximity")
				self:OpenProximity(args.spellId, 12, setToBlow)
			end
		end
	end
end

function mod:SetToBlowApplied(args)
	if self:Me(args.destGUID) then
		self:CloseProximity("proximity")
		self:OpenProximity(args.spellId, 12) -- 10, but be more safe
		self:Message(args.spellId, "Important", "Warning", CL["you"]:format(args.spellName))
		self:TargetBar(args.spellId, 30, args.destName)
		self:Flash(args.spellId)
	else
		setToBlow[#setToBlow+1] = args.destName
		self:CloseProximity("proximity")
		self:OpenProximity(args.spellId, 12, setToBlow)
	end
end

