
--------------------------------------------------------------------------------
-- Module Declaration
--
if not IsTestBuild() then return end
local mod, CL = BigWigs:NewBoss("Fatescribe Roh-Kalo", 2450, 2447)
if not mod then return end
mod:RegisterEnableMob(175730, 178235, 177940, 179390) -- Fatescribe Roh-Kalo x4
mod:SetEncounterID(2431)
mod:SetRespawnTime(30)
--mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--



--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then

end

--------------------------------------------------------------------------------
-- Initialization
--

local callOfEternityMarker = mod:AddMarkerOption(false, "player", 1, 350568, 1, 2, 3, 4, 5) -- Call of Eternity
function mod:GetOptions()
	return {
		-- Stage One: Scrying Fate
		{351680, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Heroic Destiny // XXX [Tank] Bomb?
		353432, -- Burden of Destiny (Fixate)
		{353603, "TANK"}, -- Diviner's Probe
		353931, -- Twist Fate
		350355, -- Fated Conjunction (Beams)
		{350568, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Call of Eternity (Bombs)
		-- Stage Two: Defying Destiny
		353149, -- Realignment: Clockwise
		353150, -- Realignment: Counterclockwise
		351969, -- Realign Fate
		-- Stage Three: Fated Terminus
		353195, -- Extemporaneous Fate
	},{
		[351680] = mod:SpellName(-22926), -- Stage One: Scrying Fate
		[353149] = mod:SpellName(-22927), -- Stage Two: Defying Destiny
		[353195] = mod:SpellName(-23486), -- Stage Three: Fated Terminus
	},{
		[353432] = CL.fixate, -- Burden of Destiny (Fixate)
		[350355] = CL.beams, -- Fated Conjunction (Beams)
		[350568] = CL.bombs, -- Call of Eternity (Bombs)
	}
end

function mod:OnBossEnable()
	-- Stage One: Scrying Fate
	self:Log("SPELL_CAST_START", "HeroicDestiny", 351680)
	self:Log("SPELL_AURA_APPLIED", "HeroicDestinyApplied", 351680)
	self:Log("SPELL_AURA_REMOVED", "HeroicDestinyRemoved", 351680)
	self:Log("SPELL_AURA_APPLIED", "BurdenOfDestinyApplied", 353432)
	self:Log("SPELL_CAST_START", "DivinersProbe", 353603)
	self:Log("SPELL_AURA_APPLIED", "TwistFateApplied", 353931)
	self:Log("SPELL_CAST_SUCCESS", "FatedConjunction", 350355)
	self:Log("SPELL_AURA_APPLIED", "CallOfEternityApplied", 350568, 356065) -- Heroic, Normal
	self:Log("SPELL_AURA_REMOVED", "CallOfEternityRemoved", 350568, 356065)

	-- Stage Two: Defying Destiny
	self:Log("SPELL_CAST_SUCCESS", "Realignment", 353149, 353150) -- Clockwise, Counterclockwise
	self:Log("SPELL_CAST_START", "RealignFate", 351969)

	-- Stage Three: Fated Terminus
	self:Log("SPELL_AURA_APPLIED", "ExtemporaneousFateApplied", 353195)
	self:Log("SPELL_AURA_REMOVED", "ExtemporaneousFateRemoved", 353195)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: Scrying Fate
function mod:HeroicDestiny(args)
	if self:Tank() then
		self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
		self:PlaySound(args.spellId, "alert")
	end
	--self:Bar(args.spellId,20)
end

function mod:HeroicDestinyApplied(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 8)
		self:PlaySound(args.spellId, "warning")
	end
	self:TargetBar(args.spellId, 8, args.destName)
	self:TargetMessage(args.spellId, "purple", args.destName)
end

function mod:HeroicDestinyRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	self:StopBar(args.spellId, args.destName)
end

function mod:BurdenOfDestinyApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.fixate)
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
	--self:Bar(args.spellId, 20, CL.beams)
end

do
	local playerList = {}
	local prev = 0
	function mod:CallOfEternityApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
			--self:Bar(args.spellId, 20, CL.bombs)
		end
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
function mod:Realignment(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:RealignFate(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
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
