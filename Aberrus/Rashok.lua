--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Rashok, the Elder", 2569, 2525)
if not mod then return end
mod:RegisterEnableMob(201320) -- Rashok
mod:SetEncounterID(2680)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local searingSlamCount = 1
local chargedSmashCount = 1
local wrathOfDjaruunCount = 1
local siphonEnergyCount = 1
local unleashShadowflameCount = 1

local timers = {
	[405821] = { 11.3, 46.0, 33.0, 0 }, -- Searing Slam
	[400777] = { 23.3, 46.0, 0 }, -- Charged Smash
	[407641] = { 31.3, 15.0, 33.0, 0 }, -- Wrath of Djaruun
	[410070] = { 6.3, 46.0, 33.0, 0 }, -- Unleash Shadowflame
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.doom_flames = "Small Soaks"
	L.charged_smash = "Big Soak"
	L.energy_gained = "Energy Gained: %d"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- General
		405316, -- Ancient Fury
		{405821, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Searing Slam
		403543, -- Living Lava (damage)
		406851, -- Doom Flames
		406333, -- Shadowlava Blast
		400777, -- Charged Smash
		{407641, "TANK_HEALER"}, -- Wrath of Djaruun
		{407547, "TANK"}, -- Flaming Slash
		{407597, "TANK"}, -- Earthen Crush
		-- Elder's Conduit
		401419, -- Elder's Conduit
		405091, -- Smoldering Rage
		-- Mythic
		410070, -- Unleash Shadowflame
		410075, -- Shadowflame Energy
	}, {
		[405316] = "general",
		[401419] = -26237, -- Elder's Conduit
		[410070] = "mythic",
	}, {
		[410070] = CL.orbs, -- Unleash Shadowflame (Orbs)
		[410075] = CL.heal_absorb, -- Shadowflame Energy (Heal Absorb)
		[405316] = CL.full_energy, -- Ancient Fury (Full Energy)
		[405821] = CL.leap, -- Searing Slam (Leap)
		[406851] = L.doom_flames, -- Doom Flames (Small Soaks)
		[406333] = CL.frontal_cone, -- Shadowlava Blast (Frontal Cone)
		[400777] = L.charged_smash, -- Charged Smash (Big Soak)
		[407641] = CL.tank_combo, -- Wrath of Djaruun (Tank Combo)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "AncientFury", 405316)
	self:Log("SPELL_AURA_APPLIED", "SearingSlamApplied", 405819)
	self:Log("SPELL_AURA_REMOVED", "SearingSlamRemoved", 405819)
	self:Log("SPELL_CAST_START", "DoomFlames", 406851)
	self:Log("SPELL_CAST_START", "ShadowlavaBlast", 406333)
	self:Log("SPELL_CAST_START", "ChargedSmash", 400777)
	self:Log("SPELL_CAST_SUCCESS", "WrathOfDjaruun", 407641)
	self:Log("SPELL_CAST_START", "FlamingSlash", 407544)
	self:Log("SPELL_CAST_START", "EarthenCrush", 407596)
	self:Log("SPELL_AURA_APPLIED", "TankComboApplied", 407547, 407597) -- Flaming Slash, Earthen Crush
	self:Log("SPELL_AURA_REMOVED", "TankComboRemoved", 407547, 407597)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TankComboFailed", 407547, 407597)

	self:Log("SPELL_AURA_APPLIED", "EldersConduitApplied", 401419)
	self:Log("SPELL_AURA_REMOVED", "EldersConduitRemoved", 401419)
	self:Log("SPELL_AURA_REMOVED", "SmolderingRageRemoved", 405091)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 403543) -- Living Lava
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 403543)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 403543)

	-- Mythic
	self:Log("SPELL_ENERGIZE", "FailedSoak", 405825) -- Charged Smash
	self:Log("SPELL_CAST_START", "UnleashShadowflame", 410070)
end

function mod:OnEngage()
	searingSlamCount = 1
	chargedSmashCount = 1
	wrathOfDjaruunCount = 1
	siphonEnergyCount = 1
	unleashShadowflameCount = 1
	self:SetStage(1)

	self:Bar(405821, 9, CL.count:format(CL.leap, searingSlamCount)) -- Searing Slam
	self:Bar(400777, 21, CL.count:format(L.charged_smash, chargedSmashCount)) -- Charged Smash
	self:Bar(407641, 29, CL.count:format(CL.tank_combo, wrathOfDjaruunCount)) -- Wrath of Djaruun
	self:Bar(406851, 39, L.doom_flames) -- Doom Flames
	self:Bar(406333, 95.6, CL.frontal_cone) -- Shadowlava Blast
	self:Bar(405316, 113, CL.count:format(CL.full_energy, siphonEnergyCount)) -- Ancient Fury
	if self:Mythic() then
		self:Bar(410070, 4, CL.count:format(CL.orbs, unleashShadowflameCount)) -- Unleash Shadowflame
	end

	self:RegisterUnitEvent("UNIT_POWER_UPDATE", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_POWER_UPDATE(event, unit)
	local power = UnitPower(unit)
	if power > 91 then
		self:UnregisterUnitEvent(event, unit)
		self:Message(405316, "cyan", CL.soon:format(CL.full_energy), false)
		self:PlaySound(405316, "info")
	end
end

function mod:AncientFury(args)
	self:StopBar(CL.count:format(CL.full_energy, siphonEnergyCount))
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

function mod:SearingSlamApplied(args)
	local msg = CL.count:format(CL.leap, searingSlamCount)
	self:StopBar(msg)
	self:TargetMessage(405821, "yellow", args.destName, msg)
	if self:Me(args.destGUID) then
		self:PlaySound(405821, "warning")
		self:Say(405821, CL.leap, nil, "Leap")
		self:SayCountdown(405821, 4.9)
	end
	searingSlamCount = searingSlamCount + 1
	self:Bar(405821, timers[405821][searingSlamCount], CL.count:format(CL.leap, searingSlamCount))
end

function mod:SearingSlamRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(405821)
	end
end

function mod:DoomFlames(args)
	self:StopBar(L.doom_flames)
	self:Message(args.spellId, "orange", L.doom_flames)
	self:PlaySound(args.spellId, "alert") -- stack
	-- 1 per rotation
end

function mod:ShadowlavaBlast(args)
	self:StopBar(CL.frontal_cone)
	self:Message(args.spellId, "yellow", CL.frontal_cone)
	self:PlaySound(args.spellId, "alert") -- frontal
	-- 1 per rotation
end

function mod:ChargedSmash(args)
	local msg = CL.count:format(L.charged_smash, chargedSmashCount)
	self:StopBar(msg)
	self:Message(args.spellId, "yellow", msg)
	self:PlaySound(args.spellId, "alarm") -- spread
	chargedSmashCount = chargedSmashCount + 1
	self:Bar(args.spellId, timers[args.spellId][chargedSmashCount], CL.count:format(L.charged_smash, chargedSmashCount))
end

do
	local flamingSlashCount, earthenCrushCount = 1, 1
	local myStacks = {}

	function mod:WrathOfDjaruun(args)
		flamingSlashCount, earthenCrushCount = 1, 1
		myStacks = {}
		self:StopBar(CL.count:format(CL.tank_combo, wrathOfDjaruunCount))
		wrathOfDjaruunCount = wrathOfDjaruunCount + 1
		self:Bar(args.spellId, timers[args.spellId][wrathOfDjaruunCount], CL.count:format(CL.tank_combo, wrathOfDjaruunCount))
	end

	function mod:FlamingSlash(args)
		self:Message(407547, "purple", CL.count:format(args.spellName, flamingSlashCount))
		if flamingSlashCount > 1 then
			if self:Tank() and not myStacks[407547] then
				self:PlaySound(407547, "warning") -- tauntswap
			end
		elseif self:Tank() then
			local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
			if bossUnit and self:Tanking(bossUnit) then
				self:PlaySound(407547, "alarm") -- defensive
			end
		end
		flamingSlashCount = flamingSlashCount + 1
	end

	function mod:EarthenCrush(args)
		self:Message(407597, "purple", CL.count:format(args.spellName, earthenCrushCount))
		if earthenCrushCount > 1 then
			if self:Tank() and not myStacks[407597] then
				self:PlaySound(407597, "warning") -- tauntswap
			end
		elseif self:Tank() then
			local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
			if bossUnit and self:Tanking(bossUnit) then
				self:PlaySound(407597, "alarm") -- defensive
			end
		end
		earthenCrushCount = earthenCrushCount + 1
	end

	function mod:TankComboApplied(args)
		if self:Me(args.destGUID) then
			myStacks[args.spellId] = true
		end
	end

	function mod:TankComboRemoved(args)
		if self:Me(args.destGUID) then
			myStacks[args.spellId] = nil
		end
	end

	function mod:TankComboFailed(args)
		self:StackMessage(407641, "purple", args.destName, args.amount, 1) -- Wrath of Djaruun option key
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

-- Conduit
function mod:EldersConduitApplied(args)
	self:StopBar(CL.count:format(CL.full_energy, siphonEnergyCount)) -- Ancient Fury
	self:StopBar(CL.count:format(CL.leap, searingSlamCount)) -- Searing Slam
	self:StopBar(L.doom_flames) -- Doom Flames
	self:StopBar(CL.frontal_cone) -- Shadowlava Blast
	self:StopBar(CL.count:format(L.charged_smash, chargedSmashCount)) -- Charged Smash
	self:StopBar(CL.count:format(CL.tank_combo, wrathOfDjaruunCount)) -- Wrath of Djaruun
	self:StopBar(CL.count:format(CL.orbs, unleashShadowflameCount)) -- Unleash Shadowflame

	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, siphonEnergyCount))
	self:PlaySound(args.spellId, "long")

	local bossUnit = self:UnitTokenFromGUID(args.destGUID)
	if bossUnit then
		local stunTime = floor(UnitPower(bossUnit) / 5) + 1.2 -- 5/s energy loss, and idle time at the end
		self:Bar(args.spellId, stunTime, CL.count:format(args.spellName, siphonEnergyCount))
	end
end

function mod:EldersConduitRemoved(args)
	self:StopBar(CL.count:format(args.spellName, siphonEnergyCount))

	self:Message(args.spellId, "cyan", CL.removed:format(args.spellName))
	self:PlaySound(args.spellId, "long")
	siphonEnergyCount = siphonEnergyCount + 1

	self:SetStage(self:GetStage() + 1)

	searingSlamCount = 1
	chargedSmashCount = 1
	wrathOfDjaruunCount = 1
	unleashShadowflameCount = 1

	self:Bar(405821, timers[405821][searingSlamCount], CL.count:format(CL.leap, searingSlamCount)) -- Searing Slam
	self:Bar(400777, timers[400777][chargedSmashCount], CL.count:format(L.charged_smash, chargedSmashCount)) -- Charged Smash
	self:Bar(407641, timers[407641][wrathOfDjaruunCount], CL.count:format(CL.tank_combo, wrathOfDjaruunCount)) -- Wrath of Djaruun
	self:Bar(406851, 41, L.doom_flames) -- Doom Flames
	self:Bar(406333, 97.8, CL.frontal_cone) -- Shadowlava Blast
	self:Bar(405316, 113, CL.count:format(CL.full_energy, siphonEnergyCount)) -- Ancient Fury
	if self:Mythic() then
		self:Bar(410070, timers[410070][unleashShadowflameCount], CL.count:format(CL.orbs, unleashShadowflameCount)) -- Unleash Shadowflame
	end

	self:RegisterUnitEvent("UNIT_POWER_UPDATE", nil, "boss1")
end

function mod:SmolderingRageRemoved(args)
	self:Message(args.spellId, "green", CL.removed:format(args.spellName))
end

-- Mythic
function mod:FailedSoak(args)
	self:Message(400777, "cyan", L.energy_gained:format(args.extraSpellId), false) -- args.extraSpellId is the energy gained from SPELL_ENERGIZE
	local timeLeft = (100 - UnitPower("boss1")) * 1.12 -- Energy slightly more than 1/s
	self:Bar(405316, {timeLeft, 113}, CL.count:format(CL.full_energy, siphonEnergyCount)) -- Ancient Fury
end

function mod:UnleashShadowflame(args)
	local msg = CL.count:format(CL.orbs, unleashShadowflameCount)
	self:StopBar(msg)
	self:Message(args.spellId, "orange", msg)
	self:PlaySound(args.spellId, "alert")
	unleashShadowflameCount = unleashShadowflameCount + 1
	self:Bar(args.spellId, timers[args.spellId][unleashShadowflameCount], CL.count:format(CL.orbs, unleashShadowflameCount))

	self:Bar(410075, 18.5, CL.heal_absorb) -- Shadowflame Energy
end
