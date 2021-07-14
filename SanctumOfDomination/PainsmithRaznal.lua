--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Painsmith Raznal", 2450, 2443)
if not mod then return end
mod:RegisterEnableMob(176523) -- Painsmith Raznal
mod:SetEncounterID(2430)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local nextStageWarning = 73
local instrumentCount = 1
local spikedBallsCount = 1
local trapsCount = 1
local chainsCount = 1
local weaponNames = {
	[348508] = "hammer",
	[355568] = "axe",
	[355778] = "scythe",
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.hammer = "Hammer" -- Short for Rippling Hammer
	L.axe = "Axe" -- Short for Cruciform Axe
	L.scythe = "Scythe" -- Short for Dualblade Scythe
	L.trap = "Trap" -- Short for Flameclasp Trap
	L.chains = "Chains" -- Short for Shadowsteel Chains
	L.ember = "Ember" -- Short for Shadowsteel Ember
end

--------------------------------------------------------------------------------
-- Initialization
--

local shadowsteelChainsMarker = mod:AddMarkerOption(false, "player", 1, 355505, 1, 2, 3) -- Shadowsteel Chains
local flameclaspTrapMarker = mod:AddMarkerOption(false, "player", 4, 348456, 4, 5, 6, 7) -- Flameclasp Trap
function mod:GetOptions()
	return {
		"stages",
		{348508, "SAY", "SAY_COUNTDOWN", "ICON"}, -- Rippling Hammer
		{355568, "SAY", "SAY_COUNTDOWN", "ICON"}, -- Cruciform Axe
		{355778, "SAY", "SAY_COUNTDOWN", "ICON"}, -- Dualblade Scythe
		355786, -- Blackened Armor
		352052, -- Spiked Balls
		{348456, "SAY", "SAY_COUNTDOWN"}, -- Flameclasp Trap
		flameclaspTrapMarker,
		{355505, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Shadowsteel Chains
		shadowsteelChainsMarker,
		{355534}, -- Shadowsteel Ember
	},{
		["stages"] = "general",
	},{
		[348508] = L.hammer, -- Rippling Hammer (Hammer)
		[355568] = L.axe, -- Cruciform Axe (Axe)
		[355778] = L.scythe, -- Dualblade Scythe (Scythe)
		[355534] = L.ember, -- Shadowsteel Ember (Ember)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "InstrumentApplied", 348508, 355568, 355778) -- Rippling Hammer, Cruciform Axe, Dualblade Scythe
	self:Log("SPELL_AURA_REMOVED", "InstrumentRemoved", 348508, 355568, 355778)

	self:Log("SPELL_AURA_APPLIED", "SpikedBalls", 352052)
	self:Log("SPELL_AURA_APPLIED", "BlackenedArmorApplied", 355786)

	self:Log("SPELL_AURA_APPLIED", "FlameclaspTrapApplied", 348456)
	self:Log("SPELL_AURA_REMOVED", "FlameclaspTrapRemoved", 348456)

	self:Log("SPELL_AURA_APPLIED", "ShadowsteelChainsApplied", 355505)
	self:Log("SPELL_AURA_REMOVED", "ShadowsteelChainsRemoved", 355505)
	self:Log("SPELL_AURA_REMOVED", "ShadowsteelChainsEffectRemoved", 355506)

	self:Log("SPELL_AURA_APPLIED", "ForgeWeapon", 355525)
	self:Log("SPELL_AURA_REMOVED", "ForgeWeaponOver", 355525)

	self:Log("SPELL_SUMMON", "ShadowsteelEmber", 355536)
end

function mod:OnEngage()
	nextStageWarning = 73
	instrumentCount = 1
	spikedBallsCount = 1
	trapsCount = 1
	chainsCount = 1
	self:SetStage(1)

	self:CDBar(355505, 8, CL.count:format(L.chains, chainsCount)) -- Shadowsteel Chains
	self:CDBar(355568, self:Mythic() and 12 or 18.1, CL.count:format(L.axe, instrumentCount)) -- Axe
	self:CDBar(352052, self:Mythic() and 26.8 or 24, CL.count:format(self:SpellName(352052), spikedBallsCount)) -- Spiked Balls
	self:CDBar(348456, self:Mythic() and 42 or 45, CL.count:format(CL.traps, trapsCount)) -- Flameclasp Trap

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < nextStageWarning then -- Stage changes at 70% and 40%
		self:Message("stages", "green", CL.soon:format(CL.intermission), false)
		self:PlaySound("stages", "info")
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
	self:Bar(args.spellId, 19.5, CL.count:format(equippedWeapon, instrumentCount))
end

function mod:InstrumentRemoved(args)
	self:PrimaryIcon(args.spellId)
	self:StopBar(CL.count:format(L.hammer, instrumentCount), args.destName)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:SpikedBalls(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, spikedBallsCount))
	self:PlaySound(args.spellId, "alarm")
	spikedBallsCount = spikedBallsCount + 1
	self:Bar(args.spellId, 41.4, CL.count:format(args.spellName, spikedBallsCount))
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

do
	local playerList = {}
	local prev = 0
	function mod:FlameclaspTrapApplied(args)
		local t = args.time -- new set of debuffs
		if t-prev > 5 then
			prev = t
			playerList = {}
			trapsCount = trapsCount + 1
			self:Bar(args.spellId, 40, CL.count:format(CL.traps, trapsCount))
		end
		playerList[#playerList+1] = args.destName
		local mark = #playerList + 3
		playerList[args.destName] = mark -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.rticon:format(L.trap, mark))
			self:SayCountdown(args.spellId, 5, mark)
			self:PlaySound(args.spellId, "alert")
		end
		self:NewTargetsMessage(args.spellId, "orange", playerList, nil, CL.count:format(CL.traps, trapsCount-1))
		self:CustomIcon(flameclaspTrapMarker, args.destName, mark)
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
			self:Bar(args.spellId, 40.3, CL.count:format(L.chains, chainsCount))
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.rticon:format(L.chains, count))
			self:SayCountdown(args.spellId, 3, count, 2) -- XXX workaround timer going negative
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(L.chains, chainsCount-1))
		self:CustomIcon(shadowsteelChainsMarker, args.destName, count)
	end

	function mod:ShadowsteelChainsRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end

	function mod:ShadowsteelChainsEffectRemoved(args)
		self:CustomIcon(shadowsteelChainsMarker, args.destName)
	end
end

do
	local emberCount = 0
	function mod:ShadowsteelEmber()
		if self:Mythic() then
			self:Message(355534, "yellow", CL.count:format(L.ember, emberCount))
			self:PlaySound(355534, "alert")
		end
		emberCount = emberCount + 1
		if emberCount < 9 then
			self:Bar(355534, 5, CL.count:format(L.ember, emberCount))
			if not self:Mythic() then
				self:ScheduleTimer("ShadowsteelEmber", 5)
			end
		end
	end

	function mod:ForgeWeapon(args)
		self:StopBar(CL.count:format(CL.traps, trapsCount)) -- Flameclasp Trap
		self:StopBar(CL.count:format(self:SpellName(352052), spikedBallsCount)) -- Spiked Balls
		self:StopBar(CL.count:format(L.chains, chainsCount)) -- Chains
		self:StopBar(CL.count:format(L.hammer, instrumentCount)) -- Hammer
		self:StopBar(CL.count:format(L.axe, instrumentCount)) -- Axe

		self:Message("stages", "cyan", CL.intermission, args.spellId)
		self:PlaySound("stages", "info")

		emberCount = 1
		self:Bar(355534, 2, CL.count:format(L.ember, emberCount))
		if not self:Mythic() then
			self:ScheduleTimer("ShadowsteelEmber", 2)
		end

		self:Bar("stages", 41.8, CL.intermission, args.spellId) -- 35s Forge Weapon + 6.8s to jump down
	end

	function mod:ForgeWeaponOver(args)
		instrumentCount = 1
		spikedBallsCount = 1
		trapsCount = 1
		chainsCount = 1
		self:SetStage(self:GetStage() + 1)
		self:Message("stages", "cyan", CL.soon:format(args.sourceName), false)
		self:PlaySound("stages", "long")

		self:Bar(355505, 15, CL.count:format(L.chains, chainsCount)) -- Shadowsteel Chains
		-- Axe -> Hammer -> Scythe
		local spellId = self:GetStage() == 3 and 355778 or 348508
		self:Bar(spellId, 17, CL.count:format(L[weaponNames[spellId]], instrumentCount)) -- Instruments of Pain
		self:Bar(352052, self:Mythic() and 6.8 or 24, CL.count:format(self:SpellName(352052), spikedBallsCount)) -- Spiked Balls
		self:Bar(348456, self:Mythic() and 51.8 or 36, CL.count:format(CL.traps, trapsCount)) -- Flameclasp Trap
	end
end
