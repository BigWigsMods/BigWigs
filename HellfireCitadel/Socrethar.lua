
-- Notes --
-- Fel Orb targetting
-- Charge target

--------------------------------------------------------------------------------
-- Module Declaration
--

if not IsTestBuild() then return end

local mod, CL = BigWigs:NewBoss("Socrethar the Eternal", 1026, 1427)
if not mod then return end
mod:RegisterEnableMob(90296, 92330) -- Soulbound Construct, Soul of Socrethar
--mod.engageId = 0

--------------------------------------------------------------------------------
-- Locals
--

local dominanceCount = 0
local apocalypseCount = 0

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
		188692, -- Unstoppable Tenacity
		183331, -- Exert Dominance
		183329, -- Apocalypse
		{182992, "SAY"}, -- Volatile Fel Orb
		182051, -- Felblaze Charge
		184053, -- Fel Barrier
		{184124, "SAY", "PROXIMITY", "FLASH"}, -- Gift of the Man'ari
		182392, -- Shadow Bolt Volley
		{182769, "SAY", "FLASH"}, -- Ghastly Fixation
		182900, -- Virulent Haunt
		"berserk",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_APPLIED", "UnstoppableTenacity", 188692)
	self:Log("SPELL_CAST_START", "ExertDominance", 183331)
	self:Log("SPELL_CAST_START", "Apocalypse", 183329)

	self:Log("SPELL_CAST_START", "VolatileFelOrb", 182992)
	self:RegisterEvent("RAID_BOSS_WHISPER")

	self:Log("SPELL_CAST_START", "FelblazeCharge", 182051)
	self:Log("SPELL_AURA_APPLIED", "FelBarrier", 184053)
	self:Log("SPELL_AURA_APPLIED", "GiftOfTheManari", 184124)
	self:Log("SPELL_AURA_REMOVED", "GiftOfTheManariRemoved", 184124)
	self:Log("SPELL_CAST_START", "ShadowBoltVolley", 182392)
	self:Log("SPELL_AURA_APPLIED", "GhastlyFixation", 182769)
	self:Log("SPELL_AURA_APPLIED", "VirulentHaunt", 182900)
end

function mod:OnEngage()
	dominanceCount = 0
	apocalypseCount = 0
	self:Message("berserk", "Neutral", nil, "Socrethar (beta) engaged", false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UnstoppableTenacity(args)
	self:Message(args.spellId, "Urgent", "Info")
	self:Bar(args.spellId, 20)
end

function mod:ExertDominance(args)
	dominanceCount = dominanceCount + 1
	self:Message(args.spellId, "Attention", nil, CL.count:format(args.spellName, dominanceCount))
end

function mod:Apocalypse(args)
	apocalypseCount = apocalypseCount + 1
	self:Message(args.spellId, "Important", "Long", CL.count:format(args.spellName, apocalypseCount))
	self:Bar(args.spellId, 12, CL.count:format(args.spellName, apocalypseCount))
end

function mod:VolatileFelOrb(args)
	self:Message(182992, "Attention", nil, CL.incoming:format(args.spellName))
end

function mod:RAID_BOSS_WHISPER(event, msg)
	if msg:find("182992") or msg:find("180221") then
		self:Message(182992, "Personal", "Alarm", CL.you:format(self:SpellName(182992)))
		self:Say(182992)
	end
end

function mod:FelblazeCharge(args)
	self:Message(args.spellId, "Urgent", "Alert")
	self:Bar(args.spellId, 3)
end

function mod:FelBarrier(args)
	self:TargetMessage(args.spellId, args.destName, "Positive", "Warning", nil, nil, true)
end

do
	local list = mod:NewTargetList()
	function mod:GiftOfTheManari(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Attention", "Alarm")
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:Flash(args.spellId)
			self:OpenProximity(args.spellId, 10)
		end
	end
end

function mod:GiftOfTheManariRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

function mod:ShadowBoltVolley(args)
	self:Message(args.spellId, "Attention", nil, CL.casting:format(args.spellName))
end

do
	local list = mod:NewTargetList()
	function mod:GhastlyFixation(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Attention", "Alarm")
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:Flash(args.spellId)
		end
	end
end

do
	local list = mod:NewTargetList()
	function mod:VirulentHaunt(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Positive")
		end
	end
end

