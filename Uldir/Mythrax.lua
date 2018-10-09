
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Mythrax the Unraveler", 1861, 2194)
if not mod then return end
mod:RegisterEnableMob(134546)
mod.engageId = 2135
mod.respawnTime = 34

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local nextStageWarning = 69
local annihilationList = {}
local visionCount = 1
local beamCount = 1
local ruinCount = 0
local mobCollector = {}
local voidEchoesCount = 1
local ruinCounter = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.destroyer_cast = "%s (N'raqi Destroyer)" -- npc id: 139381
	L.xalzaix_returned = "Xalzaix returned!"
	L.add_blast = "Add Blast"
	L.boss_blast = "Boss Blast"
end

--------------------------------------------------------------------------------
-- Initialization
--

local imminentRuinMarker = mod:AddMarkerOption(false, "player", 1, 272536, 1, 2) -- Imminent Ruin
local visionMarker = mod:AddMarkerOption(false, "npc", 1, 273949, 1, 2, 3, 4, 5) -- Visions of Madness
function mod:GetOptions()
	return {
		"stages",
		{272146, "INFOBOX"}, -- Annihilation
		{273282, "TANK"}, -- Essence Shear
		273538, -- Obliteration Blast
		{272404, "PROXIMITY"}, -- Oblivion Sphere
		{272536, "SAY", "SAY_COUNTDOWN"}, -- Imminent Ruin
		imminentRuinMarker,
		279013, -- Essence Shatter
		273810, -- Xalzaix's Awakening
		274230, -- Oblivion's Veil
		272115, -- Obliteration Beam
		273949, -- Visions of Madness
		visionMarker,
		276922, -- Living Weapon
		279157, -- Void Echoes
	}, {
		["stages"] = CL.general,
		[273282] = CL.stage:format(1),
		[273810] = CL.stage:format(2),
		[276922] = CL.mythic,
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:RegisterUnitEvent("UNIT_TARGETABLE_CHANGED", nil, "boss2")

	self:Log("SPELL_AURA_APPLIED", "Annihilation", 272146)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Annihilation", 272146)
	self:Log("SPELL_AURA_REMOVED", "Annihilation", 272146)
	self:Log("SPELL_AURA_REMOVED_DOSE", "Annihilation", 272146)

	self:Log("SPELL_CAST_START", "EssenceShear", 273282)
	self:Log("SPELL_AURA_APPLIED", "EssenceShearApplied", 274693)
	self:Log("SPELL_CAST_START", "ObliterationBlast", 273538)
	self:Log("SPELL_CAST_SUCCESS", "OblivionSphere", 272404)
	self:Log("SPELL_CAST_SUCCESS", "ImminentRuin", 272533)
	self:Log("SPELL_AURA_APPLIED", "ImminentRuinApplied", 272536)
	self:Log("SPELL_AURA_REMOVED", "ImminentRuinRemoved", 272536)
	self:Log("SPELL_CAST_START", "XalzaixsAwakening", 273810)
	self:Log("SPELL_AURA_REMOVED", "OblivionsVeilRemoved", 274230)
	self:Log("SPELL_CAST_START", "ObliterationBeam", 272115)
	self:Log("SPELL_CAST_SUCCESS", "VisionsofMadness", 273949)
	self:Log("SPELL_CAST_START", "EssenceShatter", 279013)

	-- Mythic
	self:Log("SPELL_CAST_SUCCESS", "LivingWeapon", 276922)
	self:Log("SPELL_CAST_START", "VoidEchoes", 279157)
end

function mod:OnEngage()
	stage = 1
	ruinCount = 0
	nextStageWarning = 69
	annihilationList = {}
	mobCollector = {}
	ruinCounter = 1

	self:OpenInfo(272146, self:SpellName(272146)) -- Annihilation

	self:Bar(272536, 5, CL.count:format(self:SpellName(272536), ruinCounter)) -- Imminent Ruin
	self:Bar(272404, self:Mythic() and 7 or 9) -- Oblivion Sphere
	self:Bar(273538, 15, L.boss_blast) -- Obliteration Blast
	self:Bar(273282, 20.5) -- Essence Shear

	if self:Mythic() then
		self:CDBar(276922, 10) -- Living Weapon
	end

	self:OpenProximity(272404, 8) -- Oblivion Sphere
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_TARGETABLE_CHANGED(_, unit)
	if self:MobId(UnitGUID(unit)) == 138324 and not UnitCanAttack("player", unit) then -- Xalzaix
		self:Message2(276922, "green", L.xalzaix_returned, false)
		self:StopBar(L.add_blast)
		self:StopBar(CL.count:format(self:SpellName(279157), voidEchoesCount))
	end
end

function mod:UNIT_HEALTH_FREQUENT(event, unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < nextStageWarning then -- Intermission at 66% & 33%
		self:Message2("stages", "green", CL.soon:format(CL.stage:format(2)), false)
		nextStageWarning = nextStageWarning - 33
		if nextStageWarning < 33 then
			self:UnregisterUnitEvent(event, unit)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 279749 then -- Intermission Start
		stage = 2
		self:PlaySound("stages", "long")
		self:Message2("stages", "cyan",CL.stage:format(stage), false)

		self:StopBar(CL.count:format(self:SpellName(272536), ruinCounter)) -- Imminent Ruin
		self:StopBar(273282) -- Essence Shear
		self:StopBar(L.boss_blast) -- Obliteration Blast
		self:StopBar(272404) -- Oblivion Sphere
		-- Mythic
		self:StopBar(276922) -- Living Weapon
		self:StopBar(L.add_blast)
		self:StopBar(CL.count:format(self:SpellName(279157), voidEchoesCount))

		visionCount = 1
		beamCount = 1
		ruinCounter = 1

		self:CDBar("stages", self:Mythic() and 79 or 84, CL.intermission, 274230) -- 274230 = inv_icon_shadowcouncilorb_purple
	elseif spellId == 279748 then -- Intermission End
		stage = 1
		self:PlaySound("stages", "long")
		self:Message2("stages", "cyan", CL.stage:format(stage), false)
		self:OpenProximity(272404, 8) -- Oblivion Sphere

		self:Bar(272536, 5, CL.count:format(self:SpellName(272536), ruinCounter)) -- Imminent Ruin
		self:Bar(272404, self:Mythic() and 7 or 9) -- Oblivion Sphere
		self:Bar(273538, 15, L.boss_blast) -- Obliteration Blast
		self:Bar(273282, self:Mythic() and 23 or 20.5) -- Essence Shear
		if self:Mythic() then
			self:Bar(276922, 10) -- Living Weapon
		end
	elseif spellId == 276905 then -- Living Weapon
		self:Message2(276922, "orange", CL.spawning:format(self:SpellName(276922)))
		self:PlaySound(276922, "long")
		voidEchoesCount = 1
		self:Bar(276922, 60) -- Living Weapon
		self:Bar(276922, 5, CL.spawning:format(self:SpellName(276922))) -- Living Weapon Spawning
		self:Bar(273538, 12.5, L.add_blast) -- Obliteration Blast
		self:Bar(279157, 8, CL.count:format(self:SpellName(279157), voidEchoesCount)) -- Void Echoes (x)
	end
end

function mod:Annihilation(args)
	annihilationList[args.destName] = args.amount or 1
	self:SetInfoByTable(args.spellId, annihilationList)
end

do
	local prev = 0
	function mod:EssenceShear(args)
		self:Message2(args.spellId, "purple")
		self:PlaySound(args.spellId, "alert")
		if self:MobId(args.sourceGUID) == 134546 then -- Mythrax the Unraveler
			self:Bar(args.spellId, 20.5)
		else -- Intermission Adds
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:CDBar(args.spellId, 20.5, L.destroyer_cast:format(args.spellName))
			end
		end
	end
end

function mod:EssenceShearApplied(args)
	if self:Tank(args.destName) then
		self:TargetMessage2(273282, "red", args.destName)
		self:PlaySound(273282, "alarm", nil, args.destName)
	end
end

function mod:ObliterationBlast(args)
	self:PlaySound(args.spellId, "alert")
	if self:MobId(args.sourceGUID) == 138324 then -- Living Weapon
		self:Message2(args.spellId, "orange", L.add_blast)
		self:Bar(args.spellId, 15, L.add_blast)
	else
		self:Message2(args.spellId, "orange", L.boss_blast)
		self:Bar(args.spellId, self:Mythic() and 20 or 12.2, L.boss_blast)
	end
end

function mod:OblivionSphere(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	if stage == 1 then
		self:Bar(args.spellId, 15)
	elseif stage == 2 then
		self:CloseProximity(272404) -- Oblivion Sphere
	end
end

function mod:ImminentRuin(args)
	ruinCount = 0
	self:Bar(272536, self:Mythic() and 20 or 15, CL.count:format(args.spellName, ruinCounter))
	ruinCounter = ruinCounter + 1
end

do
	local playerList = mod:NewTargetList()
	function mod:ImminentRuinApplied(args)
		ruinCount = ruinCount + 1
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:CastBar(args.spellId, 12) -- Explosion
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, 2)
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.count_rticon:format(args.spellName, ruinCount, ruinCount))
			self:SayCountdown(args.spellId, 12)
			self:PlaySound(args.spellId, "alert")
		end
		if self:GetOption(imminentRuinMarker) then
			SetRaidTarget(args.destName, ruinCount)
		end
	end
end

function mod:ImminentRuinRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	if self:GetOption(imminentRuinMarker) then
		SetRaidTarget(args.destName, 0)
	end
end

function mod:XalzaixsAwakening(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 8) -- 2s cast, 6s channel

	self:Bar(272404, 7) -- Oblivion Sphere
	self:CDBar(272115, 18.5) -- Obliteration Beam
	self:CDBar(273949, self:Mythic() and 26.1 or 30) -- Visions of Madness
	self:CDBar(273282, self:Mythic() and 32 or 30, L.destroyer_cast:format(self:SpellName(273282))) -- Essence Shear
end

function mod:OblivionsVeilRemoved(args)
	self:Message2(args.spellId, "green", CL.removed:format(args.spellName))
	self:PlaySound(args.spellId, "info")
end

function mod:ObliterationBeam(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 7.5) -- 2.5s cast, 5s channel

	beamCount = beamCount + 1
	local maxBeams = self:Mythic() and 4 or 5 -- XXX VERIFY Looks like heroic skips 1 beam as well for max 4 now?
	if beamCount <= maxBeams then
		self:CDBar(args.spellId, self:Mythic() and 15 or 12)
	end
end

do
	local visionAddMarks = {}
	function mod:visionAddMark(event, unit, guid)
		if self:MobId(guid) == 139487 and not mobCollector[guid] then
			for i = 1, 5 do
				if not visionAddMarks[i] then
					SetRaidTarget(unit, i)
					visionAddMarks[i] = guid
					mobCollector[guid] = true
					if i == 5 then
						self:UnregisterTargetEvents()
					end
					return
				end
			end
		end
	end

	function mod:VisionsofMadness(args)
		self:Message(args.spellId, "red")
		self:PlaySound(args.spellId, "warning")
		visionCount = visionCount + 1
		if visionCount <= 2 then
			self:Bar(args.spellId, self:Mythic() and 30 or 20)
		end
		if self:GetOption(visionMarker) then
			wipe(visionAddMarks)
			self:RegisterTargetEvents("visionAddMark")
			self:ScheduleTimer("UnregisterTargetEvents", 10)
		end
	end
end

function mod:EssenceShatter(args)
	self:Message2(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "long")
end

-- Mythic

function mod:LivingWeapon(args)
	self:Message2(args.spellId, "cyan", CL.spawned:format(args.spellName))
	self:PlaySound(args.spellId, "info")
end

function mod:VoidEchoes(args)
	self:Message2(args.spellId, "orange", CL.count:format(args.spellName, voidEchoesCount))
	self:PlaySound(args.spellId, "alarm")
	self:StopBar(CL.count:format(args.spellName, voidEchoesCount))
	voidEchoesCount = voidEchoesCount + 1
	self:CDBar(args.spellId, voidEchoesCount == 2 and 8.5 or 12.2, CL.count:format(args.spellName, voidEchoesCount)) -- Void Echoes (x)
end
