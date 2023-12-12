
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sennarth, The Cold Breath", 2522, 2482)
if not mod then return end
mod:RegisterEnableMob(187967) -- Sennarth, The Cold Breath
mod:SetEncounterID(2592)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local ascendCount = 1
local bigAddCount = 1
local chillingBlastCount = 1
local callSpiderlingsCount = 1
local burstCount = 1
local webCount = 1
local stageCount = 0

local timersTable = { -- Stage 1
	[14] = { -- Normal
		[371976] = {16.1, 36.5, 37.7, 30.4, 36.5, 36.5, 26.6, 40.1}, -- Chilling Blast
		[372082] = {18.5, 28, 29.1, 26.7, 20.6, 26.7, 30.3, 42.5, 27.9, 32.8, 29.9}, -- Enveloping Webs
		[373405] = {33.2, 36.5, 68.1, 36.4, 64.8, 38.4, 35.1}, -- Gossamer Burst
		[372238] = {2.7, 20.6, 20.7, 21.9, 20.6, 31.6, 26.7, 21.8, 20.7, 27.9, 20.6, 20.7, 20.6}, -- Call Spiderlings
	},
	[15] = { -- Heroic
		[371976] = {15.5, 37.6, 37.4, 29.1, 37.2, 37.5, 21.9, 36.5, 37.3}, -- Chilling Blast
		[372082] = {18.1, 26.7, 30.5, 44.8, 26.7, 30.4, 38.9, 26.4, 30.4, 32.8}, -- Enveloping Webs
		[373405] = {32.8, 37.7, 65.5, 36.5, 59.6, 37.6}, -- Gossamer Burst
		[372238] = {0, 25.5, 25.5, 26.7, 38.8, 25.5, 25.5, 25.5, 20.7, 26.7, 26.7, 25.4}, -- Call Spiderlings
	},
	[16] = { -- Mythic
		[371976] = {15.7, 36.6, 37.6, 30.4, 40.1, 37.6, 22.0, 39.0}, -- Chilling Blast
		[372082] = {19.1, 26.8, 31.6, 46.2, 26.7, 27.9, 45.0, 26.8, 34.1, 30.4}, -- Enveloping Webs
		[373405] = {32.8, 37.6, 69.3, 38.8, 60.8, 37.8}, -- Gossamer Burst
		[372238] = {0, 31.7, 30.3, 30.4, 23.2, 30.3, 30.4, 37.7, 31.7, 30.4}, -- Call Spiderlings
	},
	[17] = { -- LFR
		[371976] = {0}, -- Chilling Blast
		[372082] = {17.1, 27.9, 27.9, 27.9, 19.4, 28.0, 29.1, 42.5, 27.9, 27.6}, -- Enveloping Webs
		[373405] = {30.7, 35.2, 35.2, 34.0, 35.2, 63.2, 34.8}, -- Gossamer Burst
		[372238] = {1.5, 35.2, 35.2, 43.7, 31.6, 30.3, 37.7, 31.6, 32.4, 30.3}, -- Call Spiderlings
	},
}
local timers = timersTable[mod:Difficulty()]

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.ascend = "Ascend"
	L.ascend_desc = "Sennarth ascends the room towards the frozen percipice."
	L.ascend_icon = "misc_arrowlup"
	L.chilling_blast = "Spread"
	L.freezing_breath = "Add Breath"
	L.webs = "Webs"
	L.web = "Web"
	L.gossamer_burst = "Grip"
end

--------------------------------------------------------------------------------
-- Initialization
--

local envelopingWebsMarker = mod:AddMarkerOption(false, "player", 1, 372082, 1, 2, 3) -- Enveloping Webs
local suffocatingWebsMarker = mod:AddMarkerOption(false, "player", 1, 373048, 1, 2, 3) -- Suffocating Webs
function mod:GetOptions()
	return {
		-- General
		"stages",
		371976, -- Chilling Blast
		371979, -- Frost Expulsion
		372030, -- Sticky Webbing
		372044, -- Wrapped in Webs
		372238, -- Call Spiderlings
		-- Stage 1
		"ascend",
		{372082, "SAY", "SAY_COUNTDOWN"}, -- Enveloping Webs
		envelopingWebsMarker,
		{373405, "CASTBAR", "CASTBAR_COUNTDOWN"}, -- Gossamer Burst
		{385083, "TANK"}, -- Web Blast
		-24899, -- Frostbreath Arachnid
		374112, -- Freezing Breath
		-- Stage 2
		372539, -- Apex of Ice
		{373048, "SAY", "SAY_COUNTDOWN"}, -- Suffocating Webs
		suffocatingWebsMarker,
		{371983, "CASTBAR"}, -- Repelling Burst
	}, {
		["stages"] = "general",
		["ascend"] = -24883, -- Stage 1
		[-24899] = -24899, -- Frostbreath Arachnid
		[372539] = -24885, -- Stage 2
	}, {
		[371976] = L.chilling_blast, -- Chilling Blast (Spread Debuff)
		[371979] = CL.explosion, -- Frost Expulsion (Spread)
		[372238] = CL.small_adds, -- Call Spiderlings (Small Adds)
		[372082] = L.webs, -- Enveloping Webs (Webs)
		[373405] = L.gossamer_burst, -- Gossamer Burst (Grip)
		[373048] = L.webs, -- Suffocating Webs (Webs)
		[-24899] = CL.big_add, -- Frostbreath Arachnid (Big Add)
		[374112] = L.freezing_breath, -- Freezing Breath (Add Breath)
		[371983] = CL.pushback, -- Repelling Burst (Pushback)
	}
end

function mod:OnBossEnable()
	-- General
	self:Log("SPELL_CAST_START", "ChillingBlast", 371976)
	self:Log("SPELL_AURA_APPLIED", "ChillingBlastApplied", 371976)
	self:Log("SPELL_AURA_APPLIED_DOSE", "StickyWebbingApplied", 372030)
	self:Log("SPELL_AURA_APPLIED", "WrappedInWebsApplied", 372044)
	self:Log("SPELL_CAST_SUCCESS", "CallSpiderlings", 372238)

	-- Stage 1
	self:Log("SPELL_CAST_SUCCESS", "EnvelopingWebs", 372082)
	self:Log("SPELL_AURA_APPLIED", "EnvelopingWebsApplied", 372082)
	self:Log("SPELL_AURA_REMOVED", "EnvelopingWebsRemoved", 372082)
	self:Log("SPELL_CAST_START", "GossamerBurst", 373405)
	self:Log("SPELL_AURA_APPLIED", "WebBlastApplied", 385083)
	self:Log("SPELL_AURA_APPLIED_DOSE", "WebBlastApplied", 385083)

	-- Frostbreath Arachnid
	self:Log("SPELL_CAST_SUCCESS", "EncounterSpawn", 181113)
	self:Log("SPELL_CAST_START", "FreezingBreath", 374112)
	self:Death("FrostbreathArachnidDeath", 189234) -- Frostbreath Arachnid

	-- Stage 2
	self:Log("SPELL_CAST_SUCCESS", "EncounterEvent", 181089)
	self:Log("SPELL_INTERRUPT", "ApexOfIceRemoved", "*")
	self:Log("SPELL_CAST_SUCCESS", "SuffocatingWebs", 373027)
	self:Log("SPELL_AURA_APPLIED", "SuffocatingWebsApplied", 373048)
	self:Log("SPELL_AURA_REMOVED", "SuffocatingWebsRemoved", 373048)
	self:Log("SPELL_CAST_START", "RepellingBurst", 371983)

	-- XXX Ground Effects?
end

function mod:OnEngage(diff)
	timers = timersTable[diff]
	self:SetStage(1)
	stageCount = 0
	ascendCount = 1
	bigAddCount = 1
	chillingBlastCount = 1
	callSpiderlingsCount = 1
	burstCount = 1
	webCount = 1

	--self:CDBar(372238, timers[372238][callSpiderlingsCount], CL.count:format(CL.small_adds, callSpiderlingsCount)) -- Call Spiderlings // This happens at 0~1s right now
	self:Bar(371976, timers[371976][chillingBlastCount], CL.count:format(L.chilling_blast, chillingBlastCount)) -- Chilling Blast
	self:Bar(372082, timers[372082][webCount], CL.count:format(L.webs, webCount)) -- Enveloping Webs
	self:Bar(373405, timers[373405][burstCount], CL.count:format(L.gossamer_burst, burstCount)) -- Gossamer Burst
	self:Bar("ascend", 42.5, CL.count:format(L.ascend, ascendCount), L.ascend_icon) -- Boss moving
	self:Bar(-24899, 104.5, CL.count:format(CL.big_add, bigAddCount), "inv_minespider2_crystal") -- Frostbreath Arachnid
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:EncounterEvent(args)
	stageCount = stageCount + 1
	if stageCount % 2 == 0 then
		self:StopBar(CL.count:format(L.ascend, ascendCount))
		self:Message("ascend", "yellow", CL.count:format(L.ascend, ascendCount), L.ascend_icon)
		self:PlaySound("ascend", "long")
		ascendCount = ascendCount + 1
		if ascendCount < 4 then -- Reached the top
			self:Bar("ascend", ascendCount == 2 and 100 or 98.5, CL.count:format(L.ascend, ascendCount), L.ascend_icon)
		elseif ascendCount == 4 then
			self:Bar("stages", 57, CL.stage:format(2), "achievement_raidprimalist_sennarth")
		end

	elseif stageCount == 7 then -- Apex of Ice cast (in non-mythic)
		self:StopBar(CL.stage:format(2))
		self:StopBar(CL.count:format(L.ascend, ascendCount), L.ascend_icon) -- Boss moving
		self:StopBar(CL.count:format(CL.big_add, bigAddCount)) -- Frostbreath Arachnid
		self:StopBar(CL.small_adds) -- Call Spiderling
		self:StopBar(CL.count:format(L.chilling_blast, chillingBlastCount)) -- Chilling Blast
		self:StopBar(CL.count:format(L.webs, webCount)) -- Enveloping Webs
		self:StopBar(CL.count:format(L.gossamer_burst, burstCount)) -- Gossamer Burst

		self:Message("stages", "red", CL.stage:format(2), false)
		self:PlaySound("stages", "long")
		self:SetStage(2)

		chillingBlastCount = 1
		burstCount = 1
		webCount = 1
		callSpiderlingsCount = 1

		if self:Mythic() then
			self:CDBar(372238, 13.3, CL.small_adds) -- Call Spiderlings
			self:Bar(371976, 15.7, CL.count:format(L.chilling_blast, chillingBlastCount)) -- Chilling Blast
			self:Bar(373048, 26.2, CL.count:format(L.webs, webCount)) -- Suffocating Webs
			self:Bar(371983, 32.8, CL.count:format(CL.pushback, burstCount)) -- Repelling Burst
		end
	end
end

-- General
function mod:ChillingBlast(args)
	self:StopBar(CL.count:format(L.chilling_blast, chillingBlastCount))
	self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(L.chilling_blast, chillingBlastCount)))
	self:PlaySound(args.spellId, "alarm") -- spread
	self:Bar(371979, 6, CL.count:format(CL.explosion, chillingBlastCount)) -- Frost Expulsion
	chillingBlastCount = chillingBlastCount + 1
	self:Bar(args.spellId, self:GetStage() == 2 and 34 or timers[args.spellId][chillingBlastCount], CL.count:format(L.chilling_blast, chillingBlastCount))
end

function mod:ChillingBlastApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.chilling_blast)
		self:PlaySound(args.spellId, "info")
	end
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

function mod:CallSpiderlings(args)
	self:StopBar(CL.count:format(CL.small_adds, callSpiderlingsCount))
	callSpiderlingsCount = callSpiderlingsCount + 1
	local cd
	if self:GetStage() == 1 then
		cd = timers[args.spellId][callSpiderlingsCount]
	else
		cd = self:Heroic() and 34 or 30
	end
	self:CDBar(args.spellId, cd, CL.small_adds)
end

-- Stage 1
do
	local playerList = {}
	function mod:EnvelopingWebs(args)
		self:StopBar(CL.count:format(L.webs, webCount))
		playerList = {}
		webCount = webCount + 1
		self:Bar(args.spellId, timers[args.spellId][webCount], CL.count:format(L.webs, webCount))
	end

	local prev = 0
	function mod:EnvelopingWebsApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.rticon:format(L.web, count), nil, ("Web ({rt%d})"):format(count))
			self:SayCountdown(args.spellId, 6, count)
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, 3, CL.count:format(L.webs, webCount-1), nil, 1)
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
	self:StopBar(CL.count:format(L.gossamer_burst, burstCount))
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(L.gossamer_burst, burstCount)))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 4, L.gossamer_burst)
	burstCount = burstCount + 1
	self:Bar(args.spellId, timers[args.spellId][burstCount], CL.count:format(L.gossamer_burst, burstCount))
end

-- Frostbreath Arachnid
function mod:EncounterSpawn(args)
	if self:IsEngaged() and self:MobId(args.sourceGUID) == 189234 then -- Frostbreath Arachnid
		self:StopBar(CL.count:format(CL.big_add, bigAddCount))
		self:Message(-24899, "cyan", CL.count:format(CL.big_add, bigAddCount), "inv_minespider2_crystal")
		self:PlaySound(-24899, "info")
		bigAddCount = bigAddCount + 1
		if bigAddCount < 3 then -- only 2 in the encounter
			self:Bar(-24899, 99, CL.count:format(CL.big_add, bigAddCount), "inv_minespider2_crystal")
		end
		self:Bar(374112, 11, L.freezing_breath) -- Freezing Breath
	end
end

function mod:FreezingBreath(args)
	self:Message(args.spellId, "yellow", L.freezing_breath)
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 11, L.freezing_breath)
end

function mod:FrostbreathArachnidDeath(args)
	self:StopBar(L.freezing_breath)
end

function mod:WebBlastApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 2)
	if (args.amount or 0) > 4 and self:Tank() and not self:Tanking("boss1") then
		self:PlaySound(args.spellId, "warning")
	end
end

-- Stage 2
function mod:ApexOfIceRemoved(args)
	if args.extraSpellId ~= 372539 then return end

	self:Message(372539, "green", CL.interrupted:format(args.extraSpellName))
	self:PlaySound(372539, "info")

	self:CDBar(372238, self:Easy() and 13 or 9, CL.small_adds) -- Call Spiderlings 8.5~10.5
	self:Bar(371976, self:Easy() and 15 or 11, CL.count:format(L.chilling_blast, chillingBlastCount)) -- Chilling Blast
	self:Bar(373048, self:Easy() and 25 or 21, CL.count:format(L.webs, webCount)) -- Suffocating Webs
	self:Bar(371983, self:Easy() and 34 or 28, CL.count:format(CL.pushback, burstCount)) -- Repelling Burst
end

do
	local playerList = {}
	function mod:SuffocatingWebs()
		self:StopBar(CL.count:format(L.webs, webCount))
		playerList = {}
		webCount = webCount + 1
		self:Bar(373048, not self:Mythic() and 49 or webCount % 2 == 0 and 39 or 45, CL.count:format(L.webs, webCount))
	end

	function mod:SuffocatingWebsApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.rticon:format(L.web, count), nil, ("Web ({rt%d})"):format(count))
			self:SayCountdown(args.spellId, 6, count)
			self:PlaySound(args.spellId, "warning")
		end
		self:CustomIcon(suffocatingWebsMarker, args.destName, count)
		self:TargetsMessage(args.spellId, "yellow", playerList, 2, CL.count:format(L.webs, webCount-1), nil, 1)
	end

	function mod:SuffocatingWebsRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(suffocatingWebsMarker, args.destName)
	end
end

function mod:RepellingBurst(args)
	self:StopBar(CL.count:format(CL.pushback, burstCount))
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(CL.pushback, burstCount)))
	self:PlaySound(args.spellId, "warning") -- castmove
	self:CastBar(args.spellId, 4, CL.pushback)
	burstCount = burstCount + 1
	self:Bar(args.spellId, 34.2, CL.count:format(CL.pushback, burstCount))
end
