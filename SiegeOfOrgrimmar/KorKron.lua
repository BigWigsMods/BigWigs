--[[
TODO:

]]--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kor'kron Dark Shaman", 953, 856)
if not mod then return end
mod:RegisterEnableMob(71859, 71858, 71923, 71921) -- Earthbreaker Haromm, Wavebinder Kardris, Bloodclaw, Darkfang

--------------------------------------------------------------------------------
-- Locals
--

local marksUsed = {}
local ashCounter = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.blobs = "Blobs"

	L.custom_off_mist_marks = "Toxic Mist marker"
	L.custom_off_mist_marks_desc = "To help healing assignments, mark the people who have Toxic Mist on them with {rt1}{rt2}{rt3}{rt4}{rt5}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
	L.custom_off_mist_marks_icon = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_1"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{144330, "FLASH"}, 144328,
		{-8132, "FLASH", "ICON", "SAY"}, {144215, "TANK"}, 144070, -- Earthbreaker Haromm
		"custom_off_mist_marks",
		{144005, "FLASH"}, {143990, "FLASH", "ICON"}, 143973, -- Wavebinder Kardris
		144302, "berserk", "bosskill",
	}, {
		[144330] = "heroic",
		[-8132] = -8128, -- Earthbreaker Haromm
		["custom_off_mist_marks"] = L.custom_off_mist_marks,
		[144005] = -8134, -- Wavebinder Kardris
		[144302] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_CAST_SUCCESS", "Bloodlust", 144302)
	-- Earthbreaker Haromm
	self:Log("SPELL_AURA_APPLIED", "ToxicMistApplied", 144089)
	self:Log("SPELL_AURA_REMOVED", "ToxicMistRemoved", 144089)
	self:Log("SPELL_CAST_START", "FoulStream", 144090) -- SUCCESS has destName but is way too late, and "boss1target" should be reliable for it
	self:Log("SPELL_AURA_APPLIED_DOSE", "FroststormStrike", 144215)
	self:Log("SPELL_CAST_START", "AshenWall", 144070)
	-- Wavebinder Kardris
	self:Log("SPELL_CAST_START", "FallingAsh", 143973)
	self:Log("SPELL_CAST_SUCCESS", "FoulGeyser", 143990)
	self:Log("SPELL_AURA_REMOVED", "FoulGeyserRemoved", 143990)
	self:Log("SPELL_CAST_START", "ToxicStorm", 144005)
	self:Log("SPELL_DAMAGE", "ToxicStormDamage", 144017)
	-- heroic
	self:Log("SPELL_AURA_APPLIED", "IronPrison", 144330)
	self:Log("SPELL_CAST_START", "IronTomb", 144328)

	self:Death("Win", 71859)
end

function mod:OnEngage()
	self:Berserk(555)
	wipe(marksUsed)
	ashCounter = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- heroic
function mod:IronTomb(args)
	self:Bar(args.spellId, 31)
	self:Message(args.spellId, "Important", "Long")
end

do
	local function ironPrisonOverSoon(spellId, spellName)
		mod:Message(spellId, "Attention", "Warning", CL["soon"]:format(CL["removed"]:format(spellName)))
		mod:Flash(spellId)
	end
	function mod:IronPrison(args)
		if self:Me(args.destGUID) then
			self:Bar(args.spellId, 60)
			self:ScheduleTimer(ironPrisonOverSoon, 57, args.spellId, args.spellName)
		end
	end
end

-- Earthbreaker Haromm

do
	function mod:ToxicMistRemoved(args)
		if self.db.profile.custom_off_mist_marks then
			for i = 1, 7 do
				if marksUsed[i] == args.destName then
					marksUsed[i] = false
					SetRaidTarget(args.destName, 0)
				end
			end
		end
	end

	local function markMist(destName)
		for i = 1, 7 do
			if not marksUsed[i] then
				SetRaidTarget(destName, i)
				marksUsed[i] = destName
				return
			end
		end
	end
	function mod:ToxicMistApplied(args)
		if self.db.profile.custom_off_mist_marks then
			markMist(args.destName)
		end
	end
end

do
	local function printTarget(self, name, guid)
		self:PrimaryIcon(-8132, name)
		if self:Me(guid) then
			self:Say(-8132)
			self:Flash(-8132)
		elseif self:Range(name) < 8 then -- 8 is assumed, also a circular distance check is not the best for this
			self:RangeMessage(-8132)
			return
		end
		self:TargetMessage(-8132, name, "Positive", "Alarm")
	end
	function mod:FoulStream(args)
		self:CDBar(-8132, 32)
		self:GetBossTarget(printTarget, 0.4, args.sourceGUID)
	end
end

function mod:FroststormStrike(args)
	if args.amount > 3 then
		self:StackMessage(args.spellId, args.destName, args.amount, "Attention", args.amount > 4 and "Warning")
	end
end

function mod:AshenWall(args)
	self:Message(args.spellId, "Neutral")
	self:Bar(args.spellId, 32.2)
end

-- Wavebinder Kardris

function mod:FallingAsh(args)
	-- this is for when the damage happens
	self:ScheduleTimer("Message", 15, args.spellId, "Attention", self:Healer() and "Info", CL["soon"]:format(CL["count"]:format(args.spellName, ashCounter)))
	ashCounter = ashCounter + 1
	self:Bar(args.spellId, 18, CL["count"]:format(args.spellName, ashCounter))
end

function mod:FoulGeyser(args) -- Blobs
	self:PrimaryIcon(-8132)
	self:SecondaryIcon(args.spellId, args.destName)
	self:Bar(args.spellId, 32, L["blobs"])
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	elseif self:Range(args.destName) < 5 then -- splash is 3 but want bigger warning so people know that blobs will be around that area
		self:RangeMessage(args.spellId, "Personal", "Alert", L["blobs"])
		self:Flash(args.spellId)
		return
	end
	self:TargetMessage(args.spellId, args.destName, "Important", "Alert", L["blobs"])
end

function mod:FoulGeyserRemoved(args)
	if self:MobId(args.destGUID) == 71858 then -- Wavebinder Kardris
		self:SecondaryIcon(args.spellId)
	end
end

do
	local prev = 0
	function mod:ToxicStormDamage(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

do
	local function printTarget(self, name)
		self:TargetMessage(144005, name, "Urgent", "Alert")
	end
	function mod:ToxicStorm(args)
		self:Bar(args.spellId, 32)
		self:GetBossTarget(printTarget, 0.2, args.sourceGUID)
	end
end

-- General

function mod:Bloodlust(args)
	self:Message(args.spellId, "Neutral", "Info")
end

