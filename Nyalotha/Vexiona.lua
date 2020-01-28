--------------------------------------------------------------------------------
-- TODO:
-- -- Mythic Timers

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Vexiona", 2217, 2370)
if not mod then return end
mod:RegisterEnableMob(157354) -- Vexiona
mod.engageId = 2336
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local nextStageTwoTime = 0
local decimatorCount = 1
local lastPower = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.killed = "%s killed"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		{307314, "SAY", "SAY_COUNTDOWN", "FLASH"}, -- Encroaching Shadows
		307343, -- Shadowy Residue
		307020, -- Twilight Breath
		307359, -- Despair
		307403, -- Annihilation
		307057, -- Dark Gateway
		307729, -- Fanatical Ascension
		{315762, "FLASH", "EMPHASIZE"}, -- Twilight Decimator
		307116, -- Power of the Chosen
		307639, -- Heart of Darkness
		{310323, "SAY", "SAY_COUNTDOWN"}, -- Desolation
		309882, -- Brutal Smash
	},{
		["stages"] = "general",
		[307314] = CL.stage:format(1),
		[315762] = CL.stage:format(2),
		[307639] = CL.stage:format(3),
		[309882] = "mythic",
	}
end

function mod:VerifyEnable(unit)
	return UnitCanAttack("player", unit)
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1") -- Dark Gateway, Power of the Chosen

	-- Stage 1
	self:Log("SPELL_AURA_APPLIED", "EncroachingShadowsApplied", 307314)
	self:Log("SPELL_AURA_REMOVED", "EncroachingShadowsRemoved", 307314)
	self:Log("SPELL_CAST_START", "TwilightBreath", 307020)
	self:Log("SPELL_CAST_SUCCESS", "DespairSuccess", 307359)
	self:Log("SPELL_AURA_APPLIED", "DespairApplied", 307359)
	self:Log("SPELL_CAST_START", "Annihilation", 307403)
	self:Death("AscendantDeath", 157467) -- Void Ascendant
	self:Log("SPELL_CAST_START", "FanaticalAscension", 307729)

	-- Stage 2
	self:Log("SPELL_CAST_START", "TwilightDecimator", 315762)

	-- Stage 3
	self:Log("SPELL_CAST_SUCCESS", "TheVoidUnleashed", 307453)
	self:Log("SPELL_CAST_START", "HeartofDarkness", 307639)
	self:Log("SPELL_AURA_APPLIED", "DesolationApplied", 310323)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 307343) -- Shadowy Residue
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 307343)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 307343)

	-- Mythic
	self:Log("SPELL_CAST_START", "BrutalSmash", 309882)
end

function mod:OnEngage()
	stage = 1
	decimatorCount = 1
	lastPower = 0

	self:Bar(307020, 5.7) -- Twilight Breath
	self:Bar(307359, 10) -- Despair
	self:Bar(307403, 13) -- Annihilation
	self:Bar(307314, 15) -- Encroaching Shadows
	self:Bar(307057, 32.6) -- Dark Gateway
	self:CDBar("stages", 80, CL.stage:format(2), 315762)
	nextStageTwoTime = GetTime() + 80

	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_POWER_FREQUENT(event, unit)
	local power = UnitPower(unit)
	if power < lastPower and stage ~= 3 then -- Used 100 Energy, Stage 2 start
		stage = 2
		self:Message2("stages", "cyan", CL.stage:format(2), false)
		self:PlaySound("stages", "long")
		decimatorCount = 1
		self:CDBar("stages", 55, CL.stage:format(1), 307057) -- Dark Gateway
	elseif stage == 2 and power > lastPower then -- Stage 1 starts when energy regen starts again
		stage = 1
		self:Message2("stages", "cyan", CL.stage:format(1), false)
		self:PlaySound("stages", "long")
		self:Bar(307057, 3.9) -- Dark Gateway
		self:Bar(307020, 5) -- Twilight Breath
		self:Bar(307359, 10) -- Despair
		self:CDBar("stages", 80, CL.stage:format(2), 315762) -- Twilight Decimator
	end
	lastPower = power
end

do
	local prev = 0
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
		if spellId == 307043 then -- Dark Gateway
			self:Message2(307057, "cyan")
			self:PlaySound(307057, "info")
			if nextStageTwoTime < GetTime() + 33 then
				self:Bar(307057, 33)
			end
		elseif spellId == 307116 then -- Stage 2 // Power of the Chosen
			-- XXX This spell is casted a few seconds after stage 2 starts, more reliable than energy to start the Decimator bar
			self:Message2(307116, "cyan")
			self:PlaySound(307116, "info")
			self:Bar(315762, 10.7, CL.count:format(self:SpellName(315762), decimatorCount))
		end
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:EncroachingShadowsApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 8)
			self:Flash(args.spellId)
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
		if #playerList == 1 then
			self:CDBar(args.spellId, 15)
		end
	end

	function mod:EncroachingShadowsRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:TwilightBreath(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	if nextStageTwoTime < GetTime() + 17 then
		self:Bar(args.spellId, 17)
	end
end

function mod:DespairSuccess(args)
	if nextStageTwoTime < GetTime() + 35.3 then
		self:Bar(args.spellId, 35.3)
	end
end

function mod:DespairApplied(args)
	self:TargetMessage2(args.spellId, "red", args.destName)
	if self:Me(args.destGUID) or self:Healer() then
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:Annihilation(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 13.5)
end

function mod:AscendantDeath(args)
	self:Message2("stages", "cyan", L.killed:format(args.destName), false)
	self:PlaySound("stages", "info")
	self:StopBar(307403) -- Annihilation
end

function mod:FanaticalAscension(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
end

function mod:TwilightDecimator(args)
	self:StopBar(CL.count:format(args.spellName, decimatorCount))
	self:Message2(args.spellId, "red", CL.count:format(args.spellName, decimatorCount))
	self:PlaySound(args.spellId, "warning")
	self:Flash(args.spellId)
	self:CastBar(args.spellId, 4, CL.count:format(args.spellName, decimatorCount))
	decimatorCount = decimatorCount + 1
	if decimatorCount < 4 or (self:Mythic() and stage == 3) then
		self:Bar(args.spellId, 12.1, CL.count:format(args.spellName, decimatorCount))
	end
end

function mod:TheVoidUnleashed(args)
	stage = 3
	self:Message2("stages", "cyan", CL.stage:format(3), false)
	self:PlaySound("stages", "long")
	self:StopBar(CL.stage:format(1))
	self:StopBar(CL.stage:format(2))
	self:StopBar(307359) -- Despair
	self:StopBar(307057) -- Dark Gateway
	self:CDBar(307639, 16.5) -- Heart of Darkness
	self:Bar(310323, 30.3) -- Desolation
end

function mod:HeartofDarkness(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 31.5)
	self:CastBar(args.spellId, 4)
end

function mod:DesolationApplied(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	self:PlaySound(args.spellId, "warning", args.destName)
	self:Bar(args.spellId, 32.5)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 5)
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end

function mod:BrutalSmash(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
	self:CastBar(args.spellId, 3)
end
