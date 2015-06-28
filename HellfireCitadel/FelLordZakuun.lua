
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Fel Lord Zakuun", 1026, 1391)
if not mod then return end
mod:RegisterEnableMob(89890, 90108) -- Fel Lord Zakuun, Fel Axe
mod.engageId = 1777

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.seed = "Seed (%d)"

	L.custom_off_seed_marker = "Seed of Destruction marker"
	L.custom_off_seed_marker_desc = "Mark Seed of Destruction targets with {rt1}{rt2}{rt3}{rt4}{rt5}, requires promoted or leader."
	L.custom_off_seed_marker_icon = 1
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{179711, "PROXIMITY", "SAY"}, -- Befouled
		179671, -- Heavily Armed
		179407, -- Disembodied
		179583, -- Rumbling Fissures
		181653, -- Fel Crystal
		{181508, "SAY"}, -- Seed of Destruction
		"custom_off_seed_marker",
		179681, -- Enrage
		179406, -- Soul Cleave
		189009, -- Cavitation
		179667, -- Disarmed
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Foul", 179709) -- Applies Befouled on targets
	self:Log("SPELL_AURA_APPLIED", "Befouled", 189030, 189031, 189032) -- 189030 = red, 31 = yellow, 32 = green
	self:Log("SPELL_AURA_REMOVED", "BefouledRemovedCheck", 189032, 189031, 189032)
	self:Log("SPELL_AURA_APPLIED", "HeavilyArmed", 179671)
	self:Log("SPELL_AURA_APPLIED", "Disembodied", 179407)
	self:Log("SPELL_CAST_SUCCESS", "RumblingFissures", 179583)
	self:Log("SPELL_AURA_APPLIED", "SeedOfDestruction", 181508, 181515)
	self:Log("SPELL_AURA_REMOVED", "SeedOfDestructionRemoved", 181508, 181515)
	self:Log("SPELL_AURA_APPLIED", "Enrage", 179681)
	self:Log("SPELL_CAST_SUCCESS", "Cavitation", 189009)
	self:Log("SPELL_AURA_APPLIED", "DisarmedApplied", 179667) -- phase 2 trigger, could also use Throw Axe _success, but throw axe doesn't have cleu event for phase ending?
	self:Log("SPELL_AURA_REMOVED", "DisarmedRemoved", 179667) -- phase 2 untrigger
	self:Log("SPELL_CAST_SUCCESS", "SoulCleave", 179406)
	self:Log("SPELL_AURA_APPLIED", "FelCrystalDamage", 181653)
	self:Log("SPELL_PERIODIC_DAMAGE", "FelCrystalDamage", 181653)
	self:Log("SPELL_PERIODIC_MISSED", "FelCrystalDamage", 181653)
end

function mod:OnEngage()
	if self:Mythic() or self:Tank() then
		self:Bar(179406, 28.5) -- Soul Cleave
	end
	self:Bar(189009, 36.5) -- Cavitation
	self:Bar(179583, 7) -- Rumbling Fissures
	self:Bar(179711, 16, 179709) -- Foul
	self:Bar(179667, 87) -- P2/Disarmed
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:SoulCleave(args)
	if self:Mythic() or self:Tank() then
		self:Bar(args.spellId, 40.2)
	end
end

function mod:DisarmedApplied(args)
	self:Message(args.spellId, "Attention", "Info")
	self:CDBar(args.spellId, 33.5) -- approx for phase ending
	self:Bar(181508, 9) -- Seed of Destruction
	self:Bar(179583, self:BarTimeLeft(179583) + 40) -- Rumbling Fissures
	if self:Mythic() or self:Tank() then
		self:Bar(179406, self:BarTimeLeft(179406) + 30) -- Soul Cleave
	end
	self:Bar(189009, self:BarTimeLeft(189009) + 40) -- Cavitation
end

function mod:DisarmedRemoved(args)
	self:Message(args.spellId, "Attention", "Info", CL.over:format(args.spellName))
	self:StopBar(181508) -- Seed of Destruction
	self:Bar(179667, 85) -- P2/Disarmed
end

function mod:Cavitation(args)
	self:Message(args.spellId, "Attention", "Info", args.spellName)
	self:Bar(args.spellId, 40)
end

function mod:Foul()
	self:CDBar(179711, 40)
end

do
	local list, removedTimer = mod:NewTargetList(), nil
	function mod:Befouled(args)
		if args.spellId == 189030 then -- Red debuff gets applied initially
			list[#list+1] = args.destName
			if #list == 1 then
				self:ScheduleTimer("TargetMessage", 0.2, 179711, list, "Attention", "Alarm")
			end
			if self:Me(args.destGUID) then
				self:Say(179711)
				self:OpenProximity(179711, 6)
			end
		elseif self:Me(args.destGUID) then -- Yellow or Green AND on Me
			if removedTimer then
				self:CancelTimer(removedTimer)
				removedTimer = nil
			end
		end
	end

	local function BefouledRemoved(self, spellName)
		self:Message(179711, "Personal", "Info", CL.removed:format(spellName))
		self:CloseProximity(179711)
	end

	function mod:BefouledRemovedCheck(args)
		if self:Me(args.destGUID) then
			removedTimer = self:ScheduleTimer(BefouledRemoved, 0.2, self, args.spellName)
		end
	end
end

function mod:HeavilyArmed(args)
	self:Message(args.spellId, "Positive", self:Tank() and "Warning")
end

function mod:Disembodied(args)
	self:TargetMessage(args.spellId, args.destName, "Important")
	self:Bar(args.spellId, 40)
end

function mod:RumblingFissures(args)
	self:Message(args.spellId, "Urgent", "Info")
	self:Bar(args.spellId, 40)
end

do
	local list, isOnMe = {}, nil
	local function seedSay(self, spellName)
		if isOnMe then
			table.sort(list)
			for i = 1, #list do
				local target = list[i]
				if target == isOnMe then
					local seed = L.seed:format(i)
					self:Say(181508, seed, true)
					self:Message(181508, "Positive", nil, CL.you:format(seed))
				end
				if self:GetOption("custom_off_seed_marker") then
					SetRaidTarget(target, i)
				end
				list[i] = self:ColorName(target)
			end
		end
		self:TargetMessage(181508, list, "Attention", "Alarm")
		isOnMe = nil
	end

	function mod:SeedOfDestruction(args)
		if self:Me(args.destGUID) then
			isOnMe = args.destName
		end

		list[#list+1] = args.destName
		if #list == 1 then
			self:CDBar(181508, 14.5)
			self:Bar(181508, 5, 84474) -- 84474 = "Explosion"
			self:ScheduleTimer(seedSay, 0.3, self, args.spellName)
		end
	end

	function mod:SeedOfDestructionRemoved(args)
		if self:GetOption("custom_off_seed_marker") then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:Enrage(args)
	self:Message(args.spellId, "Important", "Long")
end

do
	local prev = 0
	function mod:FelCrystalDamage(args)
		local t = GetTime()
		if t-prev > 1.5 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
		end
	end
end

