--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Remnant of Ner'zhul", 2450, 2444)
if not mod then return end
mod:RegisterEnableMob(175729, 177117) -- Remnant of Ner'zhul, Orb of Torment
mod:SetEncounterID(2432)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_stop_timers = "Always show ability bars"
	L.custom_on_stop_timers_desc = "Remnant of Ner'zhul can delay its abilities. When this option is enabled, the bars for those abilities will stay on your screen."

	L.slow = mod:SpellName(31589) -- Slow
	L.cones = "Cones" -- Grasp of Malice
	L.orbs = "Orbs" -- Orb of Torment
	L.orb = "Orb" -- Orb of Torment
end

--------------------------------------------------------------------------------
-- Initialization
--

local malevolenceMarker = mod:AddMarkerOption(false, "player", 1, 350469, 1, 2, 3, 4, 5) -- Malevolence
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
		--350671, -- Aura of Spite
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
	self:Log("SPELL_CAST_START", "Suffering", 350894)
	self:Log("SPELL_AURA_APPLIED", "SufferingApplied", 349890)
	self:Log("SPELL_CAST_START", "GraspOfMalice", 355123)
	--self:Log("SPELL_AURA_APPLIED", "AuraOfSpiteApplied", 350671)
	--self:Log("SPELL_AURA_APPLIED_DOSE", "AuraOfSpiteApplied", 350671)
	self:Log("SPELL_CAST_START", "Shatter", 351066, 351067, 351073) -- 1st, 2nd, 3rd Armor Piece

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 350489) -- Lingering Malevolence
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 350489)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 350489)

	self:RegisterMessage("BigWigs_BarCreated", "BarCreated")
end

function mod:OnEngage()
	self:CDBar(350676, self:Mythic() and 15.6 or 12, L.orbs) -- Orbs
	self:CDBar(350469, self:Mythic() and 26.7 or 21.7, CL.bombs) -- Malevolence
	self:CDBar(355123, self:Mythic() and 39 or 23.5, L.cones) -- Grasp of Malice
end

--------------------------------------------------------------------------------
-- Event Handlers
--
do
	local abilitysToPause = {
		[350676] = true, -- Orb of Torment (Orbs)
		[350469] = true, -- Malevolence (Bombs)
		[353332] = true, -- Grasp of Malice (Cones)
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
		self:StopBar(L.orbs)
		self:Message(spellId, "yellow", L.orbs)
		self:PlaySound(spellId, "alert")
		self:CDBar(spellId, 50, L.orbs)
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
	local playerList = {}
	function mod:MalevolenceStart(args)
		playerList = {}
		self:Message(args.spellId, "yellow", CL.incoming:format(CL.bombs))
	end

	function mod:MalevolenceSuccess(args)
		self:StopBar(CL.bombs)
		self:CDBar(args.spellId, 36, CL.bombs)
	end

	function mod:MalevolenceApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
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
		if self:Me(args.destGUID) then
			self:StopBar(CL.bomb, args.destName)
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(malevolenceMarker, args.destName)
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
		self:GetBossTarget(printTarget, 0.1, args.sourceGUID)
		self:Bar(349890, 17, CL.beam)
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

-- function mod:AuraOfSpiteApplied(args)
-- 	local amount = args.amount or 1
-- 	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, amount)) -- Aura of Spite (4) // 4 = level/stacks on boss
-- 	self:PlaySound(args.spellId, "info")
-- end

function mod:GraspOfMalice(args)
	self:StopBar(L.cones)
	self:Message(args.spellId, "yellow", L.cones)
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 20, L.cones)
end

function mod:Shatter(args)
	self:Message(351066, "cyan")
	self:PlaySound(351066, "long")
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
