--------------------------------------------------------------------------------
-- Module Declaration
--
if not IsTestBuild() then return end
local mod, CL = BigWigs:NewBoss("Fatescribe Roh-Kalo", 2450, 2447)
if not mod then return end
mod:RegisterEnableMob(175730)
mod:SetEncounterID(2431)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local realignFateCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.rings = "Rings"
	L.runes = "Runes"
end

--------------------------------------------------------------------------------
-- Initialization
--

local callOfEternityMarker = mod:AddMarkerOption(false, "player", 1, 350568, 1, 2, 3, 4, 5) -- Call of Eternity
function mod:GetOptions()
	return {
		"stages",
		"berserk",
		-- Stage One: Scrying Fate
		{351680, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Heroic Destiny
		353432, -- Burden of Destiny (Fixate)
		353398, -- Anomalous Blast
		{353603, "TANK"}, -- Diviner's Probe
		353931, -- Twist Fate
		350421, -- Fated Conjunction (Beams)
		{350568, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Call of Eternity (Bombs)
		-- Stage Two: Defying Destiny
		351969, -- Realign Fate
		353122, -- Darkest Destiny
		-- Stage Three: Fated Terminus
		353195, -- Extemporaneous Fate
		354367, -- Grim Portent
		354964, -- Runic Affinity
	},{
		[351680] = mod:SpellName(-22926), -- Stage One: Scrying Fate
		[351969] = mod:SpellName(-22927), -- Stage Two: Defying Destiny
		[353195] = mod:SpellName(-23486), -- Stage Three: Fated Terminus
	},{
		[351680] = CL.add, -- Heroic Destiny (Add)
		[353432] = CL.fixate, -- Burden of Destiny (Fixate)
		[350421] = CL.beams, -- Fated Conjunction (Beams)
		[350568] = CL.bombs, -- Call of Eternity (Bombs)
		[351969] = L.rings, -- Realign Fate (Rings)
		[353195] = L.rings, -- Extemporaneous Fate (Rings)
		[354367] = L.runes, -- Grim Portent (Runes)
	}
end

function mod:OnBossEnable()
	-- Stage One: Scrying Fate
	self:Log("SPELL_CAST_START", "HeroicDestiny", 351680)
	self:Log("SPELL_AURA_APPLIED", "HeroicDestinyApplied", 351680)
	self:Log("SPELL_AURA_REMOVED", "HeroicDestinyRemoved", 351680)
	self:Log("SPELL_AURA_APPLIED", "BurdenOfDestinyApplied", 353432)
	self:Log("SPELL_AURA_APPLIED", "AnomalousBlastApplied", 353398)
	self:Log("SPELL_CAST_START", "DivinersProbe", 353603)
	self:Log("SPELL_AURA_APPLIED", "TwistFateApplied", 353931)
	self:Log("SPELL_CAST_START", "FatedConjunction", 350421)
	self:Log("SPELL_CAST_START", "CallOfEternity", 350554)
	self:Log("SPELL_AURA_APPLIED", "CallOfEternityApplied", 350568, 356065) -- Heroic, Normal
	self:Log("SPELL_AURA_REMOVED", "CallOfEternityRemoved", 350568, 356065)

	-- Stage Two: Defying Destiny
	self:Log("SPELL_CAST_START", "RealignFate", 351969)
	self:Log("SPELL_AURA_APPLIED", "UnstableFateApplied", 353693)
	self:Log("SPELL_AURA_REMOVED", "RealignFateRemoved", 351969)

	-- Stage Three: Fated Terminus
	self:Log("SPELL_AURA_APPLIED", "ExtemporaneousFateApplied", 353195)
	self:Log("SPELL_AURA_REMOVED", "ExtemporaneousFateRemoved", 353195)

	-- Mythic
	self:Log("SPELL_CAST_START", "GrimPortent", 354367) -- XXX Are there debuffs?
	self:Log("SPELL_AURA_APPLIED", "RunicAffinityApplied", 354964)
end

function mod:OnEngage()
	self:SetStage(1)
	stage = 1
	realignFateCount = 1

	self:Bar(350421, 13.5, CL.beams) -- Fated Conjunction (Beams)
	--self:Bar(350568, 36, CL.bombs) -- Call of Eternity (Bombs)
	--self:CDBar(351680, 36, CL.add) -- Heroic Destiny (Add)

	--if self:Mythic() then
		--self:CDBar(354367, 36, L.runes) -- Grim Portent (Runes)
	--end

	self:Berserk(600) -- Heroic PTR
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: Scrying Fate
function mod:HeroicDestiny(args)
	if self:Tank() then
		self:Message(args.spellId, "purple", CL.casting:format(CL.add))
		self:PlaySound(args.spellId, "alert")
	end
	self:CDBar(args.spellId, 36, CL.add) -- 36~40~53s
end

function mod:HeroicDestinyApplied(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId, CL.add)
		self:SayCountdown(args.spellId, 8)
		self:PlaySound(args.spellId, "warning")
	end
	self:TargetBar(args.spellId, 8, args.destName, CL.add)
	self:TargetMessage(args.spellId, "purple", args.destName, CL.add)
end

function mod:HeroicDestinyRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	self:StopBar(CL.add, args.destName)
end

function mod:BurdenOfDestinyApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.fixate)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:AnomalousBlastApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:DivinersProbe(args)
	if self:Tanking("boss1") then
		self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:TwistFateApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:FatedConjunction(args)
	self:Message(args.spellId, "yellow", CL.beams)
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, 9.8, CL.beams)
	--self:Bar(args.spellId, 30, CL.beams)
end

do
	local playerList = {}
	function mod:CallOfEternity(args)
		playerList = {}
		self:CastBar(350568, 10, CL.bombs)
		self:Bar(350568, 39, CL.bombs)
	end

	function mod:CallOfEternityApplied(args)
		local count = #playerList+1
		local icon = count
		playerList[count] = args.destName
		playerList[args.destName] = icon -- Set raid marker
		if self:Me(args.destGUID) then
			self:TargetBar(350568, 8, args.destName, CL.bomb)
			self:Say(350568, CL.bomb)
			self:SayCountdown(350568, 8)
			self:PlaySound(350568, "warning")
		end
		self:NewTargetsMessage(350568, "orange", playerList, nil, CL.bomb)
		self:CustomIcon(callOfEternityMarker, args.destName, icon)
	end

	function mod:CallOfEternityRemoved(args)
		if self:Me(args.destGUID) then
			self:StopBar(CL.bomb, args.destName)
			self:CancelSayCountdown(350568)
		end
		self:CustomIcon(callOfEternityMarker, args.destName)
	end
end

-- Stage Two: Defying Destiny
function mod:RealignFate(args)
	self:StopBar(CL.bombs)
	self:StopBar(CL.beams)
	self:StopBar(CL.add)
	self:StopBar(L.runes)

	self:SetStage(2)
	self:Message("stages", "cyan", CL.stage:format(2), nil)
	self:PlaySound("stages", "long")
	self:Bar(351969, 17, CL.active:format(L.rings), args.spellId) -- 16-18s
	realignFateCount = realignFateCount + 1
end

do
	local prev = 0
	function mod:UnstableFateApplied(args) -- Best way to track it atm
		local t = args.time
		if t-prev > 40 then
			prev = t
			self:CastBar(353122, 40) -- Darkest Destiny
		end
	end
end

function mod:RealignFateRemoved(args)
	if realignFateCount > 3 then -- Stage 3 after 3x Realign Fate
		stage = 3
	else
		stage = 1
	end
	self:StopBar(CL.cast:format(self:SpellName(353122))) -- Darkest Destiny
	self:SetStage(stage)
	self:Message("stages", "cyan", CL.stage:format(stage), nil)
	self:PlaySound("stages", "long")

	self:Bar(350421, stage == 3 and 8.3 or 15.5, CL.beams) -- Fated Conjunction (Beams)
	self:Bar(350568, stage == 3 and 10.7 or 27, CL.bombs) -- Call of Eternity (Bombs)
	self:Bar(351680, stage == 3 and 24.2 or 37.8, CL.add) -- Heroic Destiny (Add)

	if stage == 3 then
		self:Bar(353195, 35.9, L.rings) -- Extemporaneous Fate (Rings)
	end

	--if self:Mythic() and stage == 1 then
		--self:CDBar(354367, 36, L.runes) -- Grim Portent (Runes)
	--end
end

-- Stage Three: Fated Terminus
function mod:ExtemporaneousFateApplied(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, 30)
end

function mod:ExtemporaneousFateRemoved(args)
	self:Message(args.spellId, "green", CL.removed:format(args.spellName))
	self:StopBar(CL.cast:format(args.spellName))
end

-- Mythic
function mod:GrimPortent(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 14) -- XXX if _CAST start is correct players have 14s
end

do
	local prev = 0
	local playerList = {}
	function mod:RunicAffinityApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "orange", playerList)
	end
end
