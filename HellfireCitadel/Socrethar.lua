
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Socrethar the Eternal", 1026, 1427)
if not mod then return end
mod:RegisterEnableMob(90296, 92330) -- Soulbound Construct, Soul of Socrethar
mod.engageId = 1794
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local dominanceCount = 1
local apocalypseCount = 1
local dominatorCount = 1
local prisonCount = 1
local felburstCount = 1
local portalTimer = nil
local isHostile = true -- is Soulbound Construct hostile or friendly
local inBarrier = false
local addCount = 1
local ghostGUIDS = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.dominator = -11456
	L.dominator_desc = "Warnings for when the Sargerei Dominator spawns."
	L.dominator_icon = "achievement_boss_kiljaedan"

	L.portals = "Portals Move"
	L.portals_desc = "Timer for when the portals in phase 2 change positions."
	L.portals_msg = "The portals have moved!"
	L.portals_icon = 109400 -- spell_arcane_portalorgrimmar / Portals
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Soulbound Construct (Phase 1) ]]--
		180008, -- Reverberating Blow
		182038, -- Shattered Defenses
		{180221, "SAY"}, -- Volatile Fel Orb
		{182051, "SAY"}, -- Felblaze Charge
		182218, -- Felblaze Residue
		181288, -- Fel Prison
		188693, -- Apocalyptic Felburst
		-- Voracious Soulstalker (Mythic)
		-11778, -- Voracious Soulstalker
		188692, -- Unstoppable Tenacity
		--[[ Socrethar and the Sargerei (Phase 2) ]]--
		-- Socrethar
		183331, -- Exert Dominance
		183329, -- Apocalypse
		-- Sargerei Dominator
		"dominator", -- Sargerei Dominator
		{184124, "SAY", "PROXIMITY", "FLASH"}, -- Gift of the Man'ari
		-- Sargerei Shadowcaller
		182392, -- Shadow Bolt Volley
		-- Haunting Soul
		-11462, -- Haunting Soul
		{182769, "FLASH"}, -- Ghastly Fixation
		--[[ General ]]--
		"portals",
		"stages",
		"berserk",
	}, {
		[180008] = ("%s (%s)"):format(mod:SpellName(-11446), CL.phase:format(1)), -- Soulbound Construct (Phase 1)
		[183331] = ("%s (%s)"):format(mod:SpellName(-11451), CL.phase:format(2)), -- Socrethar and the Sargerei (Phase 2)
		["portals"] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "UnstoppableTenacity", 188692)
	self:Log("SPELL_AURA_APPLIED", "ShatteredDefense", 182038)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShatteredDefense", 182038)
	self:Log("SPELL_CAST_START", "ExertDominance", 183331)
	self:Log("SPELL_CAST_START", "Apocalypse", 183329)
	self:Log("SPELL_AURA_REMOVED", "ApocalypseEnd", 183329)
	self:Log("SPELL_AURA_APPLIED", "VolatileFelOrb", 189627)
	self:Log("SPELL_CAST_START", "FelblazeCharge", 182051)
	self:Log("SPELL_CAST_START", "ApocalypticFelburst", 188693) -- P1
	self:Log("SPELL_CAST_SUCCESS", "ApocalypticFelburstConstruct", 190651) -- Construct Ability
	self:Log("SPELL_AURA_APPLIED", "FelBarrier", 184053)
	self:Log("SPELL_AURA_REMOVED", "FelBarrierRemoved", 184053)
	self:Log("SPELL_AURA_APPLIED", "GiftOfTheManari", 184124)
	self:Log("SPELL_AURA_REMOVED", "GiftOfTheManariRemoved", 184124)
	self:Log("SPELL_CAST_START", "ShadowBoltVolley", 182392)
	self:Log("SPELL_CAST_SUCCESS", "GhastlyFixationSuccess", 182769)
	self:Log("SPELL_AURA_APPLIED", "GhastlyFixation", 182769)
	self:Log("SPELL_CAST_START", "FelPrison", 181288)
	self:Log("SPELL_AURA_APPLIED", "FelPrisonApplied", 183017)
	self:Log("SPELL_CAST_START", "ReverberatingBlow", 180008)
	self:Log("SPELL_CAST_SUCCESS", "SocretharsContingency", 190776) -- add spawning
	self:Log("SPELL_AURA_APPLIED", "FelblazeResidueDamage", 182218)
	self:Log("SPELL_PERIODIC_DAMAGE", "FelblazeResidueDamage", 182218)
	self:Log("SPELL_PERIODIC_MISSED", "FelblazeResidueDamage", 182218)
	self:Log("SPELL_CAST_SUCCESS", "EjectSoul", 183023) -- Phase 2
	self:Log("SPELL_AURA_REMOVED", "IncompleteBindingRemoved", 190466) -- Phase 1
end

function mod:OnEngage()
	addCount = 1
	felburstCount = 1
	isHostile = true
	inBarrier = false
	portalTimer = nil
	wipe(ghostGUIDS)

	self:Berserk(641)
	self:CDBar(181288, 48) -- Fel Prison
	self:CDBar(180008, 7) -- Reverberating Blow
	self:CDBar(180221, 13) -- Volatile Fel Orb
	self:CDBar(182051, 29) -- Felblaze Charge
	if self:Mythic() then
		self:Bar(188693, 34, CL.count:format(self:SpellName(188693), felburstCount)) -- Apocalyptic Felburst
		self:Bar(-11778, 20, CL.count:format(CL.add, addCount), "spell_shadow_summonfelhunter") -- Voracious Soulstalker
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Phase 1

function mod:SocretharsContingency(args)
	self:Message(-11778, "Attention", nil, CL.count:format(CL.add, addCount))
	addCount = addCount + 1
	self:Bar(-11778, 60, CL.count:format(CL.add, addCount), "spell_shadow_summonfelhunter")
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
				self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Attention", "Alarm")
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
		self:TargetMessage(182051, name, "Urgent", "Alarm")
		if self:Me(guid) then
			self:Say(182051)
		end
	end
	function mod:FelblazeCharge(args)
		self:GetBossTarget(printTarget, 0.3, args.sourceGUID)
		self:Bar(args.spellId, 30)
	end
end


function mod:ApocalypticFelburst(args)
	self:Message(args.spellId, "Important", "Alert", CL.count:format(args.spellName, felburstCount))
	felburstCount = felburstCount + 1
	self:CDBar(args.spellId, 30.5, CL.count:format(args.spellName, felburstCount))
end


function mod:ApocalypticFelburstConstruct()
	self:Message(188693, "Important", "Alert")
end

function mod:FelPrison(args)
	self:Message(args.spellId, "Urgent", "Alarm")
	self:CDBar(args.spellId, 45)
end

do
	local prev = 0
	function mod:FelPrisonApplied(args)
		local t = GetTime()
		if UnitInVehicle("player") and not UnitInRaid(args.destName) and t-prev > 5 then -- show for everyone or only construct? hmm
			prev = t
			self:Bar(181288, 60, CL.count:format(args.spellName, prisonCount))
			prisonCount = prisonCount + 1
		end
	end
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

do
	local function portalsMove(self)
		self:Message("portals", "Neutral", "Info", L.portals_msg, L.portals_icon)
		self:Bar("portals", 130, L.portals, L.portals_icon) -- Portals Move
		self:CDBar(-11462, 23, nil, "achievement_halloween_ghost_01") -- Haunting Soul
		portalTimer = self:ScheduleTimer(portalsMove, 130, self)
	end
	function mod:EjectSoul() -- Phase 2 Start
		isHostile = false
		dominatorCount, dominanceCount, apocalypseCount, prisonCount = 1, 1, 1, 1
		-- Stop P1 bars
		self:StopBar(180008) -- Reverberating Blow
		self:StopBar(180221) -- Volatile Fel Orb
		self:StopBar(182051) -- Felblaze Charge
		self:StopBar(181288) -- Fel Prison
		self:StopBar(CL.count:format(CL.add, addCount)) -- Voracious Soulstalker
		-- Start P2 bars
		self:Bar("stages", 7, 180258, "achievement_boss_hellfire_socrethar") -- Construct is Good
		self:Bar("portals", 138, L.portals, L.portals_icon) -- Portals Move
		portalTimer = self:ScheduleTimer(portalsMove, 138, self)
		self:Bar("dominator", 24, CL.count:format(self:SpellName(L.dominator), dominatorCount), L.dominator_icon) -- Sargerei Dominator
		self:CDBar(-11462, 30, nil, "achievement_halloween_ghost_01") -- Haunting Soul
		self:CDBar(183329, 51.5, CL.count:format(self:SpellName(183329), apocalypseCount)) -- Apocalypse
		self:Message("stages", "Neutral", "Long", CL.phase:format(2), false)
	end
end

function mod:FelBarrier()
	inBarrier = true
	self:Message("dominator", "Neutral", "Warning", CL.count:format(self:SpellName(L.dominator), dominatorCount), L.dominator_icon)
	dominatorCount = dominatorCount + 1
	self:Bar("dominator", self:Mythic() and 130 or (dominatorCount % 2 == 0 and 60 or 70), CL.count:format(self:SpellName(L.dominator), dominatorCount), L.dominator_icon) -- Sargerei Dominator
	self:CDBar(184124, 5) -- Gift of the Man'ari
end

function mod:FelBarrierRemoved()
	inBarrier = false
	self:StopBar(184124) -- Gift of the Man'ari
end

function mod:ExertDominance(args)
	self:Message(args.spellId, "Attention", self:Interrupter(args.sourceGUID) and not inBarrier and "Alert", CL.count:format(args.spellName, dominanceCount))
	dominanceCount = (dominanceCount % 3) + 1
end

function mod:Apocalypse(args)
	self:Message(args.spellId, "Important", "Long", CL.count:format(args.spellName, apocalypseCount))
	self:Bar(args.spellId, 12, CL.count:format(args.spellName, apocalypseCount))
end

function mod:ApocalypseEnd(args)
	apocalypseCount = apocalypseCount + 1
	self:CDBar(args.spellId, 36, CL.count:format(args.spellName, apocalypseCount)) -- 36-37.3
end

do
	local list = mod:NewTargetList()
	function mod:GiftOfTheManari(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Attention", "Alarm")
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:Flash(args.spellId)
			self:OpenProximity(args.spellId, 10)
		end
	end
end

do
	local prev = 0
	function mod:GhastlyFixationSuccess(args) -- Workaround the lack of a spawn event
		local t = GetTime()
		if t-prev > 5 and args.sourceGUID and not ghostGUIDS[args.sourceGUID] then
			prev = t
			ghostGUIDS[args.sourceGUID] = true
			self:CDBar(-11462, 30, nil, "achievement_halloween_ghost_01")
		elseif args.sourceGUID and not ghostGUIDS[args.sourceGUID] then -- Don't spam restart the bar
			ghostGUIDS[args.sourceGUID] = true
		end
	end
end

function mod:GhastlyFixation(args)
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
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "Attention", "Alert", CL.casting:format(args.spellName))
	end
end

function mod:IncompleteBindingRemoved(args) -- Phase 2 End
	isHostile = true
	-- Stop P2 bars
	self:StopBar(CL.count:format(self:SpellName(L.dominator), dominatorCount)) -- Sargerei Dominator
	self:StopBar(L.portals) -- Portals Move
	self:CancelTimer(portalTimer)
	self:StopBar(-11462) -- Haunting Soul
	self:StopBar(CL.count:format(self:SpellName(183329), apocalypseCount)) -- Apocalypse
	-- Start P1 bars
	self:Message("stages", "Neutral", "Long", CL.phase:format(1), false)
	self:CDBar(181288, 46) -- Fel Prison
	self:CDBar(180221, 8) -- Volatile Fel Orb
	self:CDBar(182051, 26) -- Felblaze Charge
	if self:Mythic() then
		self:CDBar(188693, 33, CL.count:format(self:SpellName(188693), felburstCount)) -- Apocalyptic Felburst
		self:CDBar(-11778, 16, CL.count:format(CL.add, addCount), "spell_shadow_summonfelhunter") -- Voracious Soulstalker
	end
end
