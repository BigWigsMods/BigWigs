if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sennarth, The Cold Breath", 2522, 2482)
if not mod then return end
mod:RegisterEnableMob(187967) -- Sennarth, The Cold Breath
mod:SetEncounterID(2592)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local burstCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.web = "Web"
	L.enveloping_webs = "Webs"
	L.suffocating_webs = "Knock Webs"
	-- these are probably fine, but they're not the typical channeled pull/push
	L.gossamer_burst = mod:SpellName(373405) -- "Pull In"
	L.repelling_burst = mod:SpellName(371983) -- "Knockback"
end

--------------------------------------------------------------------------------
-- Initialization
--

local envelopingWebsMarker = mod:AddMarkerOption(false, "player", 1, 372082, 1, 2, 3) -- Enveloping Webs
local suffocatingWebsMarker = mod:AddMarkerOption(false, "player", 1, 373048, 1, 2) -- Suffocating Webs
function mod:GetOptions()
	return {
		371976, -- Chilling Blast
		371979, -- Frost Expulsion
		372030, -- Sticky Webbing
		372044, -- Wrapped in Webs
		-- Stage 1
		372051, -- Breath of Ice
		{372082, "SAY", "SAY_COUNTDOWN"}, -- Enveloping Webs
		envelopingWebsMarker,
		373405, -- Gossamer Burst
		{385083, "TANK"}, -- Web Blast
		374112, -- Freezing Breath (Frostbreath Arachnid)
		-- Stage 2
		372539, -- Apex of Ice
		{373048, "SAY", "SAY_COUNTDOWN"}, -- Suffocating Webs
		suffocatingWebsMarker,
		371983, -- Repelling Burst
	}, {
		[371976] = "general",
		[372051] = -24883, -- Stage 1
		[374112] = -24899, -- Frostbreath Arachnid
		[372539] = -24885, -- Stage 2
	}, {
		[372082] = L.enveloping_webs, -- Enveloping Webs (Webs)
		-- [373405] = L.gossamer_burst, -- Gossamer Burst (Pull In)
		[373048] = L.suffocating_webs, -- Suffocating Webs (Knock Webs)
		-- [371983] = L.repelling_burst, -- Repelling Burst (Knockback)
	}
end

function mod:OnBossEnable()
	-- Stage 1
	self:Log("SPELL_CAST_SUCCESS", "BreathOfIce", 372051)
	self:Log("SPELL_CAST_START", "ChillingBlast", 371976)
	self:Log("SPELL_AURA_APPLIED", "EnvelopingWebsApplied", 372082)
	self:Log("SPELL_AURA_REMOVED", "EnvelopingWebsRemoved", 372082)
	self:Log("SPELL_AURA_APPLIED_DOSE", "StickyWebbingApplied", 372030)
	self:Log("SPELL_AURA_APPLIED", "WrappedInWebsApplied", 372044)
	self:Log("SPELL_CAST_START", "GossamerBurst", 373405)
	self:Log("SPELL_AURA_APPLIED", "WebBlastApplied", 385083)
	self:Log("SPELL_AURA_APPLIED_DOSE", "WebBlastApplied", 385083)
	-- Frostbreath Arachnid
	self:Log("SPELL_CAST_START", "FreezingBreath", 374112)
	-- Stage 2
	self:Log("SPELL_CAST_START", "ApexOfIce", 372539)
	self:Log("SPELL_AURA_REMOVED", "ApexOfIceRemoved", 372539)
	self:Log("SPELL_AURA_APPLIED", "SuffocatingWebsApplied", 373048)
	self:Log("SPELL_AURA_REMOVED", "SuffocatingWebsRemoved", 373048)
	self:Log("SPELL_CAST_START", "RepellingBurst", 371983)
end

function mod:OnEngage()
	burstCount = 1
	-- self:Bar(385083, 10) -- Web Blast
	-- self:Bar(372051, 30) -- Breath of Ice
	-- self:Bar(371976, 30) -- Chilling Blast
	-- self:Bar(372082, 30) -- Enveloping Webs
	-- self:Bar(373405, 93, CL.count:format(self:SpellName(373405), burstCount)) -- Gossamer Burst
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ChillingBlast(args)
	self:Message(args.spellId, "orange", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alarm") -- spread
	self:Bar(371979, 6) -- Frost Expulsion
	-- self:Bar(args.spellId, 15)
end

function mod:StickyWebbingApplied(args)
	if self:Me(args.destGUID) and (args.amount % 3 == 0 or args.amount > 6) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 7)
		if args.amount > 6 then
			self:PlaySound(args.spellId, "info")
		end
	end
end

function mod:WrappedInWebsApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "blue")
		self:PlaySound(args.spellId, "info")
	end
end

-- Stage 1

function mod:BreathOfIce(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert") -- frontal
	-- self:Bar(args.spellId, 30)
end

do
	local playerList = {}
	local prev = 0
	function mod:EnvelopingWebsApplied(args)
		if args.time - prev > 3 then
			prev = args.time
			playerList = {}
			-- self:Bar(args.spellId, 30)
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.rticon:format(L.web, count))
			self:SayCountdown(args.spellId, 6, count)
			self:PlaySound(args.spellId, "warning") -- debuffmove
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, 3, L.enveloping_webs)
		self:CustomIcon(envelopingWebsMarker, args.destName, count)
	end

	function mod:EnvelopingWebsRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(envelopingWebsMarker, args.destName)
	end
end

function mod:GossamerBurst(args)
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(L.gossamer_burst, burstCount)))
	self:PlaySound(args.spellId, "warning") -- castmove
	self:CastBar(args.spellId, 4, L.gossamer_burst)
	burstCount = burstCount + 1
	-- self:Bar(args.spellId, 95, CL.count:format(L.gossamer_burst, burstCount))
end

do
	local prev = 0
	function mod:FreezingBreath(args)
		if args.time - prev < 3 then return end
		prev = args.time

		self:Message(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alert") -- frontal
	end
end

function mod:WebBlastApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 2)
	-- if (args.amount or 0) > 1 and self:Tank() and not self:Tanking("boss1") then
	-- 	self:PlaySound(args.spellId, "warning") -- tankswap
	-- end
	-- self:Bar(args.spellId, 25)
end

-- Stage 2

function mod:ApexOfIce(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long") -- phase
end

function mod:ApexOfIceRemoved(args)
	self:Message(args.spellId, "green", CL.over:format(args.spellName)) -- removed? interrupted?
	self:PlaySound(args.spellId, "info")

	burstCount = 1
	-- self:Bar(371976, 30) -- Chilling Blast
	-- self:Bar(373048, 30) -- Suffocating Webs
	-- self:Bar(371983, 93, CL.count:format(self:SpellName(371983), burstCount)) -- Repelling Burst
end

do
	local playerList = {}
	local prev = 0
	function mod:SuffocatingWebsApplied(args)
		if args.time - prev > 3 then
			prev = args.time
			playerList = {}
			-- self:Bar(args.spellId, 30)
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.rticon:format(L.web, count))
			self:SayCountdown(args.spellId, 6, count)
			self:PlaySound(args.spellId, "warning") -- debuffmove
		end
		self:CustomIcon(suffocatingWebsMarker, args.destName, count)
		self:TargetsMessage(args.spellId, "yellow", playerList, 2, L.suffocating_webs)
	end

	function mod:SuffocatingWebsRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(suffocatingWebsMarker, args.destName)
	end
end

function mod:RepellingBurst(args)
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(L.repelling_burst, burstCount)))
	self:PlaySound(args.spellId, "warning") -- castmove
	self:CastBar(args.spellId, 4, L.repelling_burst)
	burstCount = burstCount + 1
	-- self:Bar(args.spellId, 95, CL.count:format(L.repelling_burst, burstCount))
end
