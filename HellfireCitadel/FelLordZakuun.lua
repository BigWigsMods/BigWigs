
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
		179681, -- Enrage
		179406, -- Soul Cleave
		189009, -- Cavitation
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Foul", 179709) -- Applies Befouled on targets
	self:Log("SPELL_AURA_APPLIED", "Befouled", 179711)
	self:Log("SPELL_AURA_REMOVED", "BefouledRemoved", 179711)
	self:Log("SPELL_AURA_APPLIED", "HeavilyArmed", 179671)
	self:Log("SPELL_AURA_APPLIED", "Disembodied", 179407)
	self:Log("SPELL_CAST_SUCCESS", "RumblingFissures", 179583)
	self:Log("SPELL_AURA_APPLIED", "SeedOfDestruction", 181508, 181515)
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
	self:Bar(179709, 16) -- Foul
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
	self:Message(args.spellId, "Attention", "Info", CL.phase:format(2))
	self:CDBar(args.spellId, 33.5) -- approx for phase ending
	self:Bar(181515, 9) -- Seed of Destruction
	self:Bar(178583, self:BarTimeLeft(179583) + 40) -- Rumbling Fissures
	if self:Mythic() or self:Tank() then
		self:Bar(179406, self:BarTimeLeft(179406) + 30) -- Soul Cleave
	end
	self:Bar(189009, self:BarTimeLeft(189009) + 40) -- Cavitation
end

function mod:DisarmedRemoved(args)
	self:Message(args.spellId, "Attention", "Info", CL.phase:format(1))
	self:StopBar(181515) -- Seed of Destruction
end

function mod:Cavitation(args)
	self:Message(args.spellId, "Attention", "Info", args.spellName)
	self:Bar(args.spellId, 40)
end

function mod:Foul()
	self:CDBar(179711, 40)
end

do
	local list = mod:NewTargetList()
	function mod:Befouled(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Attention", "Alarm")
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:OpenProximity(args.spellId, 10)
		end
	end
end

function mod:BefouledRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
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
	local list = mod:NewTargetList()
	function mod:SeedOfDestruction(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:CDBar(args.spellId, 14.5)
			self:Bar(args.spellId, 5, 84474)
			self:ScheduleTimer("TargetMessage", 0.2, 181508, list, "Attention", "Alarm")
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
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

