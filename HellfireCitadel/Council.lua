
-- Notes --
-- Demolishing Leap is instant?
-- Fel Blade is instant or hidden

--------------------------------------------------------------------------------
-- Module Declaration
--

if not IsTestBuild() then return end

local mod, CL = BigWigs:NewBoss("Hellfire High Council", 1026, 1432)
if not mod then return end
mod:RegisterEnableMob(92142, 92144, 92146) -- Blademaster Jubei'thos, Dia Darkwhisper, Gurtogg Bloodboil
mod.engageId = 1798

--------------------------------------------------------------------------------
-- Locals
--

local horrorCount = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		184449, -- Mark of the Necromancer
		184476, -- Reap
		{184657, "TANK_HEALER"}, -- Nightmare Visage
		184681, -- Wailing Horror

		{184358, "ICON"}, -- Fel Rage
		184355, -- Bloodboil
		{184847, "TANK"}, -- Acidic Wound

		183885, -- Mirror Images
		"berserk",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_APPLIED", "MarkOfTheNecromancer", 184449, 184450, 184676, 185065, 185066, 185074, 187183)
	self:Log("SPELL_CAST_START", "Reap", 184476)
	self:Log("SPELL_CAST_START", "NightmareVisage", 184657)
	--self:Log("SPELL_CAST_SUCCESS", "WailingHorror", 184681)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:Log("SPELL_AURA_APPLIED", "FelRage", 184360)
	self:Log("SPELL_AURA_REMOVED", "FelRageRemoved", 184360)
	self:Log("SPELL_AURA_APPLIED", "Bloodboil", 184355)
	self:Log("SPELL_AURA_APPLIED_DOSE", "AcidicWound", 184847)

	self:Log("SPELL_CAST_SUCCESS", "MirrorImages", 183885)

	self:Log("SPELL_AURA_APPLIED", "ReapDamage", 184652)
	self:Log("SPELL_PERIODIC_DAMAGE", "ReapDamage", 184652)
	self:Log("SPELL_PERIODIC_MISSED", "ReapDamage", 184652)
end

function mod:OnEngage()
	horrorCount = 0
	self:Berserk(600)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local list = mod:NewTargetList()
	function mod:MarkOfTheNecromancer(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 1, 184449, list, "Attention", "Alarm")
		end
	end
end

function mod:Reap(args)
	self:Message(args.spellId, "Attention", "Info", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 4)
end

function mod:FelRage(args)
	self:TargetMessage(184358, args.destName, "Urgent", "Warning")
	self:TargetBar(184358, 25, args.destName)
	self:PrimaryIcon(184358, args.destName)
end

function mod:FelRageRemoved(args)
	self:StopBar(args.spellName, args.destName)
	self:PrimaryIcon(184358)
end

function mod:NightmareVisage(args)
	self:Message(args.spellId, "Important", "Long")
	self:Bar(args.spellId, 16)
end

--function mod:WailingHorror(args)
--	horrorCount = horrorCount + 1
--	self:Message(args.spellId, "Positive", "Alert", CL.count:format(args.spellName, horrorCount))
--end
function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg)
	if msg:find("184681", nil, true) then
		horrorCount = horrorCount + 1
		self:Message(184681, "Positive", "Alert", CL.count:format(self:SpellName(184681), horrorCount))
	end
end

do
	local list = mod:NewTargetList()
	function mod:Bloodboil(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Attention", "Alarm")
		end
	end
end

function mod:AcidicWound(args)
	if args.amount % 5 == 0 then
		self:StackMessage(args.spellId, args.destName, args.amount, "Urgent")
	end
end

function mod:MirrorImages(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 45)
end

do
	local prev = 0
	function mod:ReapDamage(args)
		local t = GetTime()
		if t-prev > 1.5 and self:Me(args.destGUID) then
			prev = t
			self:Message(184476, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

