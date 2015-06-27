
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Socrethar the Eternal", 1026, 1427)
if not mod then return end
mod:RegisterEnableMob(90296, 92330) -- Soulbound Construct, Soul of Socrethar
mod.engageId = 1794

--------------------------------------------------------------------------------
-- Locals
--

local dominanceCount = 0
local apocalypseCount = 0
local isHostile = true -- is Soulbound Construct hostile or friendly
local addCount = 1
local addFormat = CL.add.." #%d"
local ghostGUIDS = {}

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
		--[[ Soulbound Construct ]]--
		180008, -- Reverberating Blow
		182038, -- Shattered Defenses
		{180221, "SAY"}, -- Volatile Fel Orb
		{182051, "SAY"}, -- Felblaze Charge
		182218, -- Felblaze Residue
		181288, -- Fel Prison
		-- Voracious Soulstalker (Mythic)
		-11778, -- Voracious Soulstalker
		188692, -- Unstoppable Tenacity
		--[[ Socrethar and friends ]]--
		-- Socrethar
		183331, -- Exert Dominance
		183329, -- Apocalypse
		-- Sargerei Dominator
		-11456, -- Sargerei Dominator
		184053, -- Fel Barrier
		{184124, "SAY", "PROXIMITY", "FLASH"}, -- Gift of the Man'ari
		-- Sargerei Shadowcaller
		182392, -- Shadow Bolt Volley
		-- Haunting Soul
		-11462, -- Haunting Soul
		{182769, "FLASH"}, -- Ghastly Fixation
		--[[ General ]]--
		"stages",
		"berserk",
	}, {
		[180008] = ("%s (%s)"):format(mod:SpellName(-11446), CL.phase:format(1)), -- Soulbound Construct (Phase 1)
		[183331] = ("%s (%s)"):format(mod:SpellName(-11451), CL.phase:format(2)), -- Socrethar and the Sargerei (Phase 2)
		["stages"] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "UnstoppableTenacity", 188692)
	self:Log("SPELL_AURA_APPLIED", "ShatteredDefense", 182038)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShatteredDefense", 182038)
	self:Log("SPELL_CAST_START", "ExertDominance", 183331)
	self:Log("SPELL_CAST_START", "Apocalypse", 183329)
	self:Log("SPELL_AURA_APPLIED", "VolatileFelOrb", 189627)
	self:Log("SPELL_CAST_START", "FelblazeCharge", 182051)
	self:Log("SPELL_AURA_APPLIED", "FelBarrier", 184053)
	self:Log("SPELL_AURA_REMOVED", "FelBarrierRemoved", 184053)
	self:Log("SPELL_AURA_APPLIED", "GiftOfTheManari", 184124)
	self:Log("SPELL_AURA_REMOVED", "GiftOfTheManariRemoved", 184124)
	self:Log("SPELL_CAST_START", "ShadowBoltVolley", 182392)
	self:Log("SPELL_AURA_APPLIED", "GhastlyFixation", 182769)
	self:Log("SPELL_CAST_START", "FelPrison", 181288)
	self:Log("SPELL_CAST_START", "ReverberatingBlow", 180008)
	self:Log("SPELL_CAST_SUCCESS", "SocretharsContingency", 190776) -- add spawning
	self:Log("SPELL_AURA_APPLIED", "FelblazeResidueDamage", 182218)
	self:Log("SPELL_PERIODIC_DAMAGE", "FelblazeResidueDamage", 182218)
	self:Log("SPELL_PERIODIC_MISSED", "FelblazeResidueDamage", 182218)
	self:Log("SPELL_CAST_SUCCESS", "EjectSoul", 183023) -- Phase 2
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2")
end

function mod:OnEngage()
	addCount = 1
	dominanceCount = 0
	apocalypseCount = 0
	ghostGUIDS = {}
	self:CDBar(181288, 48) -- Fel Prison
	self:CDBar(180008, 7) -- Reverberating Blow
	self:CDBar(180221, 13) -- Volatile Fel Orb
	self:CDBar(182051, 29) -- Felblaze Charge
	if self:Mythic() then
		self:Bar(-11778, 20, addFormat:format(addCount), "spell_shadow_summonfelhunter") -- Voracious Soulstalker
	end
	self:Berserk(641)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Phase 1

function mod:SocretharsContingency(args)
	self:Message(-11778, "Attention", nil, addFormat:format(addCount))
	addCount = addCount + 1
	self:Bar(-11778, 60, addFormat:format(addCount), "spell_shadow_summonfelhunter")
end

function mod:UnstoppableTenacity(args)
	self:Message(args.spellId, "Urgent", "Info")
	self:Bar(args.spellId, 20)
end

do
	local list = mod:NewTargetList()
	function mod:ShatteredDefense(args)
		if isHostile then
			list[#list+1] = args.destName
			if #list == 1 then
				self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Attention", "Alarm")
			end
		end
	end
end

function mod:VolatileFelOrb(args)
	self:CDBar(180221, 30)
	self:TargetMessage(180221, args.destName, "Urgent", "Alarm")
	if self:Me(args.destGUID) then
		self:Say(180221)
		self:Flash(180221)
	end
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(182051, name, "Urgent", "Alert")
		if self:Me(guid) then
			self:Say(182051)
		end
	end
	function mod:FelblazeCharge(args)
		self:GetBossTarget(printTarget, 0.3, args.sourceGUID)
		self:Bar(args.spellId, 30)
	end
end

function mod:FelPrison(args)
	self:Message(args.spellId, "Urgent", "Alarm")
	self:CDBar(args.spellId, 45)
end

do
	local prev = 0
	function mod:FelblazeResidueDamage(args)
		local t = GetTime()
		if t-prev > 1.5 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

function mod:ReverberatingBlow(args)
	self:Message(args.spellId, "Urgent", "Info")
	self:CDBar(args.spellId, 17)
end

-- Phase 2

function mod:EjectSoul() -- Phase 2 Start
	-- Stop P1 bars
	self:StopBar(180008) -- Reverberating Blow
	self:StopBar(180221) -- Volatile Fel Orb
	self:StopBar(182051) -- Felblaze Charge
	self:StopBar(181288) -- Fel Prison
	self:StopBar(addFormat:format(addCount)) -- Voracious Soulstalker
	-- Start P2 bars
	self:Bar("stages", 7, 180258, "achievement_boss_hellfire_socrethar") -- Construct is Good
	self:Bar(-11456, 24, nil, "achievement_boss_kiljaedan") -- Sargerei Dominator
	self:CDBar(-11462, 30, nil, "achievement_halloween_ghost_01") -- Haunting Soul
	self:CDBar(183329, 52) -- Apocalypse
	self:Message("stages", "Neutral", "Long", CL.phase:format(2), false)
end

function mod:FelBarrier(args)
	self:CDBar(-11456, 140, nil, "achievement_boss_kiljaedan") -- Sargerei Dominator, XXX i only have data for 3 dominators and they are 140 -> 170 -> 140, just assuming it repeats
	self:CDBar(184124, 11) -- Gift Of The Manari
	self:TargetMessage(args.spellId, args.destName, "Positive")
end

function mod:FelBarrierRemoved(args)
	self:StopBar(184124)
end

function mod:ExertDominance(args)
	dominanceCount = dominanceCount + 1
	self:Message(args.spellId, "Attention", self:Interrupter(args.sourceGUID) and "Alert", CL.count:format(args.spellName, dominanceCount))
end

function mod:Apocalypse(args)
	apocalypseCount = apocalypseCount + 1
	self:Message(args.spellId, "Important", "Long", CL.count:format(args.spellName, apocalypseCount))
	self:Bar(args.spellId, 12, CL.count:format(args.spellName, apocalypseCount))
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

function mod:GhastlyFixation(args)
	if args.sourceGUID and not ghostGUIDS[args.sourceGUID] then
		ghostGUIDS[args.sourceGUID] = true
		self:CDBar(-11462, 30, nil, "achievement_halloween_ghost_01")
	end
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
		self:Flash(args.spellId)
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

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 180258 then -- Construct is Good
		isHostile = false
	elseif spellId == 180257 then -- Construct is Evil (back to phase 1)
		isHostile = true
		--Stop P2 bars
		self:StopBar(-11456) -- Sargerei Dominator
		self:StopBar(-11462) -- Haunting Soul
		self:StopBar(183329) -- Apocalypse
		--Start P1 bars
		self:Message("stages", "Neutral", "Long", CL.phase:format(1), false)
		self:CDBar(181288, 45) -- Fel Prison
		self:CDBar(180221, 7) -- Volatile Fel Orb
		self:CDBar(182051, 25) -- Felblaze Charge
		if self:Mythic() then
			self:CDBar(-11778, 15, addFormat:format(addCount), "spell_shadow_summonfelhunter") -- Voracious Soulstalker
		end
	end
end
