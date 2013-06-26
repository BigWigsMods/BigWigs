--[[
TODO:

]]--

if GetBuildInfo() ~= "5.4.0" then return end -- 4th return is 50300 on the PTR ATM so can't use that
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kor'kron Dark Shaman", 956, 856)
if not mod then return end
mod:RegisterEnableMob(71859, 71858) -- Earthbreaker Haromm, Wavebinder Kardris

--------------------------------------------------------------------------------
-- Locals
--

local marksUsed = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.blobs = "Blobs"

	L.custom_off_mist_marks = "Toxic Mist"
	L.custom_off_mist_marks_desc = "To help healing assignments, mark the people who have Toxic Mist on them with %s%s%s%s%s%s%s (in that order)(not all marks may be used), requires promoted or leader."

end
L = mod:GetLocale()
L.custom_off_mist_marks_desc = L.custom_off_mist_marks_desc:format( -- XXX cut down the number of marks used once we know the max amount used in 25H
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_1.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_2.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_3.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_4.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_5.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_6.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_7.blp:15\124t"
)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{-8132, "FLASH", "ICON", "SAY"}, -- Earthbreaker Haromm
		"custom_off_mist_marks",
		{144005, "FLASH"}, 143990, 143973, -- Wavebinder Kardris
		144302, "berserk", "bosskill",
	}, {
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
	self:Log("SPELL_AURA_Removed", "ToxicMistRemoved", 144089)
	self:Log("SPELL_CAST_START", "FoulStream", 137399) -- SUCCESS has destName but is way too late, and "boss1target" should be reliable for it
	self:Log("SPELL_CAST_SUCCESS", "FoulStreamFallback", 137399)
	-- Wavebinder Kardris
	self:Log("SPELL_CAST_START", "FallingAsh", 143973)
	self:Log("SPELL_CAST_START", "FoulGeyser", 143990)
	self:Log("SPELL_CAST_START", "ToxicStorm", 144005)
	self:Log("SPELL_DAMAGE", "ToxicStormDamage", 144017)

	self:Death("Win", 71859)
end

function mod:OnEngage()
	self:Berserk(600) -- XXX Assumed
	wipe(marksUsed)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Earthbreaker Haromm


do
	-- Parasite marking
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
	local timer, foulStreamTarget = nil, nil
	local function warnFoulStream(player, guid)
		mod:PrimaryIcon(-8132, player)
		if mod:Me(guid) then
			mod:Say(-8132)
		end
		if mod:Range(player) < 8 then -- 8 is assumed, also a circular distance check is not the best for this
			mod:RangeMessage(-8132)
			mod:Flash(-8132)
		else
			mod:TargetMessage(-8132, player, "Positive", "Alarm")
		end
	end
	local function checkFoulStream()
		local boss = mod:MobId(UnitGUID("boss1")) == 71859 and "boss1" or "boss2"
		local player = mod:UnitName(boss.."target")
		if player and (not UnitDetailedThreatSituation(boss.."target", boss) and not mod:Tank(boss.."target")) then -- assuming tanks can't get it
			foulStreamTarget = UnitGUID(boss.."target")
			warnFoulStream(player, foulStreamTarget)
			mod:CancelTimer(timer)
			timer = nil
		end
	end
	function mod:FoulStream(args)
		self:CDBar(-8132, 32)
		foulStreamTarget = nil
		if not timer then
			timer = self:ScheduleRepeatingTimer(checkFoulStream, 0.05)
		end
	end
	function mod:FoulStreamFallback(args)
		if timer then
			self:CancelTimer(timer)
			timer = nil
		end
		 -- don't do anything if we warned for the target already
		if args.destGUID ~= foulStreamTarget then
			warnFoulStream(args.destName, args.destGUID)
		end
	end
end

-- Wavebinder Kardris

function mod:FallingAsh(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 32)
end

function mod:FoulGeyser(args)
	self:Message(args.spellId, "Important", "Alert", CL["soon"]:format(L["blobs"]))
	self:Bar(args.spellId, 35, L["blobs"]) --32+3
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

function mod:ToxicStorm(args)
	self:Message(args.spellId, "Urgent", "Alarm")
	self:Bar(args.spellId, 32)
end

-- General

function mod:Bloodlust(args)
	self:Message(args.spellId, "Neutral")
end

