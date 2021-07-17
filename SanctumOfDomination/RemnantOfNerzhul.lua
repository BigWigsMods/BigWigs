--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Remnant of Ner'zhul", 2450, 2444)
if not mod then return end
mod:RegisterEnableMob(175729, 177117) -- Remnant of Ner'zhul, Orb of Torment
mod:SetEncounterID(2432)
mod:SetRespawnTime(50)

--------------------------------------------------------------------------------
-- Locals
--

local nextShatterWarning = 83
local prevBombsRemoved = 0
local shatterCount = 0
local malevolenceCount = 1
local orbOfTormentCount = 1
local graspOfMaliceCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_stop_timers = "Always show ability bars"
	L.custom_on_stop_timers_desc = "Remnant of Ner'zhul can delay its abilities. Like, everything is random and the timers are meaningless. When this option is enabled, the bars for those abilities will stay on your screen."

	L.slow = mod:SpellName(31589) -- Slow
	L.cones = "Cones" -- Grasp of Malice
	L.orbs = "Orbs" -- Orb of Torment
	L.orb = "Orb" -- Orb of Torment
end

--------------------------------------------------------------------------------
-- Initialization
--

local malevolenceMarker = mod:AddMarkerOption(false, "player", 1, 350469, 1, 2, 3) -- Malevolence
function mod:GetOptions()
	return {
		"custom_on_stop_timers",
		350676, -- Orb of Torment
		350073, -- Torment
		350388, -- Sorrowful Procession
		{350469, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Malevolence
		malevolenceMarker,
		350489, -- Lingering Malevolence
		{349890, "SAY", "SAY_COUNTDOWN"}, -- Suffering
		355123, -- Grasp of Malice
		351066, -- Shatter
	},{
	},{
		[350676] = L.orbs, -- Orb of Torment (Orbs)
		[350388] = L.slow, -- Thermal Lament (Slow)
		[350469] = CL.bombs, -- Malevolence (Bombs)
		[349890] = CL.beam, -- Suffering (Beam)
		[355123] = L.cones, -- Grasp of Malice (Cones)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Log("SPELL_AURA_APPLIED", "TormentApplied", 350073)
	self:Log("SPELL_AURA_APPLIED", "SorrowfulProcessionApplied", 350388)
	self:Log("SPELL_CAST_START", "MalevolenceStart", 350469)
	self:Log("SPELL_CAST_SUCCESS", "MalevolenceSuccess", 350469)
	self:Log("SPELL_AURA_APPLIED", "MalevolenceApplied", 350469)
	self:Log("SPELL_AURA_REMOVED", "MalevolenceRemoved", 350469)
	self:Log("SPELL_AURA_APPLIED", "RattlecageMalevolenceApplied", 355151)
	self:Log("SPELL_AURA_REMOVED", "RattlecageMalevolenceRemoved", 355151)
	self:Log("SPELL_CAST_START", "Suffering", 350894)
	self:Log("SPELL_AURA_APPLIED", "SufferingApplied", 349890)
	self:Log("SPELL_CAST_START", "GraspOfMalice", 355123)
	self:Log("SPELL_CAST_START", "Shatter", 351066, 351067, 351073) -- 1st, 2nd, 3rd Armor Piece

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 350489) -- Lingering Malevolence
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 350489)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 350489)

	self:RegisterMessage("BigWigs_BarCreated", "BarCreated")
end

function mod:OnEngage()
	nextShatterWarning = 83
	shatterCount = 0
	malevolenceCount = 1
	orbOfTormentCount = 1
	graspOfMaliceCount = 1


	self:CDBar(350676, 13, CL.count:format(L.orbs, orbOfTormentCount)) -- Orb of Torment
	self:CDBar(349890, 20.3, CL.count:format(self:SpellName(349890), shatterCount)) -- Suffering
	self:CDBar(350469, 26, CL.count:format(CL.bombs, malevolenceCount)) -- Malevolence 26~49??
	self:CDBar(355123, 39, CL.count:format(L.cones, graspOfMaliceCount)) -- Grasp of Malice 39~65??

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < nextShatterWarning then -- Shatter at 80/60/30
		self:Message(351066, "green", CL.soon:format(self:SpellName(351066)), false) -- Shatter
		self:PlaySound(351066, "info")
		if nextShatterWarning == 83 then
			nextShatterWarning = 63
		elseif nextShatterWarning == 63 then
			nextShatterWarning = 33
		elseif nextShatterWarning == 33 then
			self:UnregisterUnitEvent(event, unit)
		end
	end
end

do
	local abilitysToPause = {
		[350676] = true, -- Orb of Torment (Orbs)
		[350469] = true, -- Malevolence (Bombs)
		[353332] = true, -- Grasp of Malice (Cones)
		[350894] = true, -- Suffering (Beam)
	}

	local castPattern = CL.cast:gsub("%%s", ".+")

	local function stopAtZeroSec(bar)
		if bar.remaining < 0.15 then -- Pause at 0.0
			bar:SetDuration(0.01) -- Make the bar look full
			bar:Start()
			bar:Pause()
			bar:SetTimeVisibility(false)
		end
	end

	function mod:BarCreated(_, _, bar, _, key, text)
		if self:GetOption("custom_on_stop_timers") and abilitysToPause[key] and not text:match(castPattern) then
			bar:AddUpdateFunction(stopAtZeroSec)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 350676 then -- Orb of Torment
	orbOfTormentCount = orbOfTormentCount + 1
		self:StopBar(L.orbs)
		self:Message(spellId, "yellow", L.orbs)
		self:PlaySound(spellId, "alert")
		self:CDBar(spellId, self:Mythic() and 40 or 50, CL.count:format(L.orbs, orbOfTormentCount)) -- ???
		-- Shatter (Helm), 53.5, Shatter (Gauntlet), 51.1, 48.6, Shatter (Rattlecage), 58.5, 46.1
		-- Shatter (Helm), 54.7, Shatter (Gauntlet), 74.1, 42.6, Shatter (Rattlecage), 60.8, 52.2
	end
end

function mod:TormentApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:SorrowfulProcessionApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, L.orb)
		self:PlaySound(args.spellId, "info")
	end
end

do
	local playerList, onMe = {}, false
	local oldIcon = nil
	function mod:MalevolenceStart(args)
		playerList = {}
		onMe = false
		oldIcon = nil
		self:Message(args.spellId, "yellow", CL.incoming:format(CL.bombs))
	end

	function mod:MalevolenceSuccess(args)
		malevolenceCount = malevolenceCount + 1
		self:StopBar(CL.count:format(CL.bombs, malevolenceCount))
		self:CDBar(args.spellId, 36, CL.count:format(CL.bombs, malevolenceCount)) -- ???
		-- Shatter (Helm), Shatter (Gauntlet), 49.9, 43.8, 31.7, Shatter (Rattlecage), 46.3, 46.1
		-- Shatter (Helm), 36.5, Shatter (Gauntlet), 51.1, 38.8, 31.6, Shatter (Rattlecage), 55.9, 43.7
		self:SimpleTimer(function()
			if not onMe then
				self:PlaySound(args.spellId, "alert") -- so alert seems to be the "move around!" sound
			end
		end, 0.3)
	end

	function mod:MalevolenceApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			onMe = true
			local _, _, _, expires = self:UnitDebuff("player", args.spellId)
			if expires and expires > 0 then
				local timeLeft = expires - GetTime()
				self:TargetBar(args.spellId, timeLeft, args.destName, CL.bomb)
				self:Say(args.spellId, CL.bomb)
				self:SayCountdown(args.spellId, timeLeft)
				self:PlaySound(args.spellId, "warning")
			end
		end
		self:NewTargetsMessage(args.spellId, "orange", playerList, 2, CL.bomb)
		self:CustomIcon(malevolenceMarker, args.destName, count)
	end

	function mod:MalevolenceRemoved(args)
		prevBombsRemoved = args.time
		if self:Me(args.destGUID) then
			self:StopBar(CL.bomb, args.destName)
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(malevolenceMarker, args.destName)
	end

	function mod:RattlecageMalevolenceApplied(args)
		local unit = self:GetBossId(args.destGUID)
		if unit then
			local _, _, _, expires = self:UnitDebuff(unit, args.spellId)
			local timeLeft = expires - GetTime()
			self:CastBar(350469, timeLeft, CL.bomb)
			oldIcon = GetRaidTargetIndex(unit)
			self:CustomIcon(malevolenceMarker, unit, 3)
		end
	end

	function mod:RattlecageMalevolenceRemoved(args)
		self:StopBar(CL.cast:format(CL.bomb))
		local unit = self:GetBossId(args.destGUID)
		if unit then
			self:CustomIcon(malevolenceMarker, unit, oldIcon)
		end
	end
end

do
	local function printTarget(self, name, guid)
		if self:Me(guid) then
			self:PlaySound(349890, "warning")
			self:Say(349890, CL.beam)
			self:SayCountdown(349890, 3, nil, 2)
		else
			self:PlaySound(349890, "alert")
		end

		self:TargetMessage(349890, "purple", name, CL.beam)
	end

	function mod:Suffering(args)
		local cd = 13
		if self:BarTimeLeft(CL.bombs) < cd then
            self:CDBar(350469, cd, CL.count:format(CL.bombs, malevolenceCount)) -- Malevolence
        end
        if self:BarTimeLeft(L.cones) < cd then
        	self:CDBar(355123, cd, CL.count:format(L.cones, graspOfMaliceCount)) -- Grasp of Malice
        end
        self:GetBossTarget(printTarget, 0.1, args.sourceGUID)
        self:CDBar(349890, 24.4, CL.beam)
		-- 32.8, Shatter (Gauntlet), 31.6, 19.5, 24.3, 24.3, 25.6, Shatter (Rattlecage), 28.1, 21.9, 24.3, 21.9
		-- 28.0, 27.9, 24.4, Shatter (Gauntlet), 26.7, 20.6, 23.1, 26.8, Shatter (Rattlecage), 32.9, 23.1, 24.3, 23.1
	end
end

function mod:SufferingApplied(args)
	if self:Me(args.destGUID) and not self:Tank() then -- Non-tank player warnings
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	elseif self:Tank() and self:Tank(args.destName) then -- Tank warnings
		self:TargetMessage(args.spellId, "purple", args.destName)
		local bossUnit = self:GetBossId(args.sourceGUID)
		if bossUnit and not self:Me(args.destGUID) and not self:Tanking(bossUnit) then
			self:PlaySound(args.spellId, "warning") -- Swap
		elseif self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:GraspOfMalice(args)
	graspOfMaliceCount = graspOfMaliceCount + 1
	self:StopBar(L.cones)
	self:Message(args.spellId, "yellow", L.cones)
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, self:Mythic() and 30 or 24, CL.count:format(L.cones, graspOfMaliceCount)) -- ???
	-- 31.6, Shatter (Gauntlet), 51.1, 25.5, 23.2, Shatter (Rattlecage), 73.0
	-- 28.0, Shatter (Gauntlet), 76.6, 21.9, 24.3, Shatter (Rattlecage), 56.0, 46.1
end

function mod:Shatter(args)
	shatterCount = shatterCount + 1
	if self:Mythic() then
		self:StopBar(L.orbs)
		self:CDBar(350676, 35, CL.count:format(L.orbs, orbOfTormentCount)) -- Orb of Torment
		if shatterCount == 3 then
			self:CDBar(350469, 29, CL.count:format(CL.bombs, malevolenceCount)) -- Malevolence
			self:CDBar(355123, 45, L.cones) -- Grasp of Maliceend
		end
	end
	self:Message(351066, "cyan")
	self:PlaySound(351066, "long")
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 and t-prevBombsRemoved > 0.5 then -- Don't warn every time bomb is removed
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
