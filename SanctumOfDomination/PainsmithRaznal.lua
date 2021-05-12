--------------------------------------------------------------------------------
-- Module Declaration
--
if not IsTestBuild() then return end
local mod, CL = BigWigs:NewBoss("Painsmith Raznal", 2450, 2443)
if not mod then return end
mod:RegisterEnableMob(176523) -- Painsmith Raznal
mod:SetEncounterID(2430)
mod:SetRespawnTime(30)
--mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local nextStageWarning = 73
local instrumentCount = 1
local spikedBallsCount = 1
local trapsCount = 1
local chainsCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.hammer = "Hammer" -- Short for Rippling Hammer
	L.axe = "Axe" -- Short for Cruciform Axe
	L.scythe = "Scythe" -- Short for Dualblade Scythe

	L.trap = "Trap" -- Short for Flameclasp Trap
	L.traps = "Traps" -- Multiple for Flameclasp Trap

	L.chains = "Chains" -- Short for Shadowsteel Chains
end

--------------------------------------------------------------------------------
-- Initialization
--

local flameclaspTrapMarker = mod:AddMarkerOption(false, "player", 1, 348456, 1, 2, 3, 4) -- Flameclasp Trap
local shadowsteelChainsMarker = mod:AddMarkerOption(false, "player", 1, 355505, 1, 2) -- Shadowsteel Chains
function mod:GetOptions()
	return {
		"stages",
		{348508, "SAY", "SAY_COUNTDOWN", "ICON"}, -- Rippling Hammer
		{355568, "SAY", "SAY_COUNTDOWN", "ICON"}, -- Cruciform Axe
		{355778, "SAY", "SAY_COUNTDOWN", "ICON"}, -- Dualblade Scythe
		355786, -- Blackened Armor
		352052, -- Spiked Balls
		{348456, "SAY", "SAY_COUNTDOWN"}, -- Flameclasp Trap
		{355505, "SAY", "SAY_COUNTDOWN"}, -- Shadowsteel Chains
	},{
		["stages"] = "general",
	},{
		[348508] = L.hammer, -- Rippling Hammer (Hammer)
		[355568] = L.axe, -- Cruciform Axe (Axe)
		[355778] = L.scythe, -- Dualblade Scythe (Scythe)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "InstrumentApplied", 348508, 355568, 355778) -- Rippling Hammer, Cruciform Axe, Dualblade Scythe
	self:Log("SPELL_AURA_REMOVED", "InstrumentRemoved", 348508, 355568, 355778)
	self:Log("SPELL_AURA_APPLIED", "BlackenedArmorApplied", 355786)
	self:Log("SPELL_CAST_SUCCESS", "SpikedBalls", 352052)

	self:Log("SPELL_AURA_APPLIED", "FlameclaspTrapApplied", 348456)
	self:Log("SPELL_AURA_REMOVED", "FlameclaspTrapRemoved", 348456)

	self:Log("SPELL_AURA_APPLIED", "ShadowsteelChainsApplied", 355505)
	self:Log("SPELL_AURA_REMOVED", "ShadowsteelChainsRemoved", 355505)
end

function mod:OnEngage()
	nextStageWarning = 73
	instrumentCount = 1
	spikedBallsCount = 1
	trapsCount = 1
	chainsCount = 1

	--self:Bar(348508, 20, CL.count:format(L.hammer, instrumentCount)) -- Hammer
	--self:Bar(352052, 20, CL.count:format(self:SpellName(352052),spikedBallsCount)) -- Spiked Balls
	--self:Bar(348456, 20, CL.count:format(L.traps, trapsCount)) -- Spiked Balls
	--self:Bar(355505, 20, CL.count:format(L.chains, chainsCount)) -- Shadowsteel Chains

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < nextStageWarning then -- Stage changes at 70% and 40%
		self:Message("stages", "green", CL.soon:format(CL.intermission), false)
		nextStageWarning = nextStageWarning - 30
		if nextStageWarning < 30 then
			self:UnregisterUnitEvent(event, unit)
		end
	end
end

function mod:InstrumentApplied(args)
	local equippedWeapon = args.spellId == 348508 and L.hammer or args.spellId == 355568 and L.axe or L.scythe
	self:TargetMessage(args.spellId, "yellow", args.destName, CL.count:format(equippedWeapon, instrumentCount))
	self:PrimaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId, CL.count:format(equippedWeapon, instrumentCount))
		self:SayCountdown(args.spellId, 6)
		self:PlaySound(args.spellId, "warning")
	else
		self:PlaySound(args.spellId, "alert")
	end
	self:TargetBar(args.spellId, 6, args.destName, CL.count:format(equippedWeapon, instrumentCount))
	instrumentCount = instrumentCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(equippedWeapon, instrumentCount))
end

function mod:InstrumentRemoved(args)
	self:PrimaryIcon(args.spellId)
	self:StopBar(CL.count:format(L.hammer, instrumentCount), args.destName)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:BlackenedArmorApplied(args)
	if self:Tank() and self:Tank(args.destName) then
		self:TargetMessage(args.spellId, "purple", args.destName)
		if not self:Me(args.destGUID) and not self:Tanking("boss1") then -- Taunt
			self:PlaySound(args.spellId, "warning")
		elseif self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:SpikedBalls(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName,spikedBallsCount))
	self:PlaySound(args.spellId, "alarm")
	spikedBallsCount = spikedBallsCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(args.spellName,spikedBallsCount))
end

do
	local playerList = {}
	local prev = 0
	function mod:FlameclaspTrapApplied(args)
		local t = args.time -- new set of debuffs
		if t-prev > 5 then
			prev = t
			playerList = {}
			trapsCount = trapsCount + 1
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.count_rticon:format(L.trap, count, count))
			self:SayCountdown(args.spellId, 6, count)
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "orange", playerList, nil, CL.count:format(L.traps, trapsCount-1))
		--self:Bar(args.spellId, 20, CL.count:format(L.traps, trapsCount))
		self:CustomIcon(flameclaspTrapMarker, args.destName, count)
	end

	function mod:FlameclaspTrapRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(flameclaspTrapMarker, args.destName)
	end
end

do
	local playerList = {}
	local prev = 0
	function mod:ShadowsteelChainsApplied(args)
		local t = args.time -- new set of debuffs
		if t-prev > 5 then
			prev = t
			playerList = {}
			chainsCount = chainsCount + 1
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.count_rticon:format(L.chains, count, count))
			self:SayCountdown(args.spellId, 6, count)
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(L.chains, chainsCount-1))
		--self:Bar(args.spellId, 20, CL.count:format(L.chains, chainsCount))
		self:CustomIcon(shadowsteelChainsMarker, args.destName, count)
	end

	function mod:ShadowsteelChainsRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(shadowsteelChainsMarker, args.destName)
	end
end
