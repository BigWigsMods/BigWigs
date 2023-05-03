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
local doomFlamesCount = 1
local shadowlavaBlastCount = 1
local chargedSmashCount = 1
local wrathOfDjaruunCount = 1
local siphonEnergyCount = 1
local unleashShadowflameCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.doom_flames = "Small Soaks"
	L.shadowlave_blast = "Frontal Cone"
	L.charged_smash = "Big Soak"
	L.energy_gained = "Energy Gained: %d"

	-- Mythic
	L.unleash_shadowflame = "Mythic Orbs"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{405821, "SAY"}, -- Searing Slam
		403543, -- Living Lava
		406851, -- Doom Flames
		406333, -- Shadowlava Blast
		400777, -- Charged Smash
		{407641, "TANK_HEALER"}, -- Wrath of Djaruun
		{407547, "TANK"}, -- Flaming Slash
		{407597, "TANK"}, -- Earthen Crush
		-- Conduit
		401419, -- Siphon Energy
		405091, -- Unyielding Rage
		405316, -- Ancient Fury
		-- Mythic
		410070, -- Unleash Shadowflame
	}, {
		[401419] = -26237, -- Conduit
		[410070] = "mythic",
	},{
		[405821] = CL.leap, -- Searing Slam (Leap)
		[406851] = L.doom_flames, -- Doom Flames (Small Soaks)
		[406333] = L.shadowlave_blast, -- Shadowlava Blast (Frontal Cone)
		[400777] = L.charged_smash, -- Charged Smash (Big Soak)
		[407641] = CL.tank_combo, -- Wrath of Djaruun (Tank Combo)
		[405316] = CL.full_energy, -- Ancient Fury (Full Energy)
		[410070] = L.unleash_shadowflame, -- Unleash Shadowflame (Mythic Orbs)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "AncientFuryApplied", 405316)
	self:Log("SPELL_CAST_START", "SearingSlam", 405821)
	self:Log("SPELL_AURA_APPLIED", "SearingSlamApplied", 405819, 407642)
	self:Log("SPELL_CAST_START", "DoomFlames", 406851)
	self:Log("SPELL_CAST_START", "ShadowlavaBlast", 406333)
	self:Log("SPELL_CAST_START", "ChargedSmash", 400777)
	self:Log("SPELL_CAST_SUCCESS", "WrathOfDjaruun", 407641)
	self:Log("SPELL_CAST_START", "FlamingUpsurge", 407547)
	self:Log("SPELL_CAST_START", "EarthenCrush", 407597)
	self:Log("SPELL_AURA_APPLIED", "TankComboApplied", 407547, 407597) -- Flaming Slash, Earthen Crush

	self:Log("SPELL_AURA_APPLIED", "SiphonEnergyApplied", 401419)
	self:Log("SPELL_AURA_REMOVED", "SiphonEnergyRemoved", 401419)
	self:Log("SPELL_AURA_APPLIED", "UnyieldingRageApplied", 405091)
	self:Log("SPELL_AURA_APPLIED_DOSE", "UnyieldingRageApplied", 405091)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 403543) -- Living Lava
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 403543)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 403543)

	-- Mythic
	self:Log("SPELL_ENERGIZE", "FailedSoak", 405825) -- Charged Smash
	self:Log("SPELL_CAST_START", "UnleashShadowflame", 410070)
end

function mod:OnEngage()
	searingSlamCount = 1
	doomFlamesCount = 1
	shadowlavaBlastCount = 1
	chargedSmashCount = 1
	wrathOfDjaruunCount = 1
	siphonEnergyCount = 1
	unleashShadowflameCount = 1

	self:Bar(405821, 9, CL.count:format(CL.leap, searingSlamCount)) -- Searing Slam
	self:Bar(407641, 29, CL.count:format(CL.tank_combo, wrathOfDjaruunCount)) -- Wrath of Djaruun
	self:Bar(406851, 39, CL.count:format(L.doom_flames, doomFlamesCount)) -- Doom Flames
	self:Bar(400777, 21, CL.count:format(L.charged_smash, chargedSmashCount)) -- Charged Smash
	self:Bar(406333, 92.5, CL.count:format(L.shadowlave_blast, shadowlavaBlastCount)) -- Shadowlava Blast
	self:Bar(405316, 110, CL.count:format(CL.full_energy, siphonEnergyCount)) -- Ancient Fury

	if self:Mythic() then
		self:Bar(410070, 4, CL.count:format(L.unleash_shadowflame, shadowlavaBlastCount)) -- Unleash Shadowflame
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:AncientFuryApplied(args)
	self:StopBar(405316)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

function mod:SearingSlam(args)
	self:StopBar(CL.count:format(CL.leap, searingSlamCount))
	searingSlamCount = searingSlamCount + 1
	if searingSlamCount < 4 then -- 3 per rotation
		self:Bar(args.spellId, searingSlamCount == 2 and 43 or 33, CL.count:format(CL.leap, searingSlamCount))
	end
end

function mod:SearingSlamApplied(args)
	self:TargetMessage(405821, "yellow", args.destName, CL.count:format(CL.leap, searingSlamCount-1))
	if self:Me(args.destGUID) then
		self:PlaySound(405821, "warning")
		self:Say(405821, CL.leap)
	end
end

function mod:DoomFlames(args)
	self:StopBar(CL.count:format(L.doom_flames, doomFlamesCount))
	self:Message(args.spellId, "orange", CL.count:format(L.doom_flames, searingSlamCount))
	self:PlaySound(args.spellId, "alert") -- stack
	doomFlamesCount = doomFlamesCount + 1
	-- 1 per rotation
	--self:Bar(args.spellId, 30, CL.count:format(L.doom_flames, doomFlamesCount))
end

function mod:ShadowlavaBlast(args)
	self:StopBar(CL.count:format(L.shadowlave_blast, shadowlavaBlastCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.shadowlave_blast, shadowlavaBlastCount))
	self:PlaySound(args.spellId, "alert") -- frontal
	shadowlavaBlastCount = shadowlavaBlastCount + 1
	-- 1 per rotation
	-- self:Bar(args.spellId, 30, CL.count:format(L.shadowlave_blast, shadowlavaBlastCount))
end

function mod:ChargedSmash(args)
	self:StopBar(CL.count:format(L.charged_smash, chargedSmashCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.charged_smash, chargedSmashCount))
	self:PlaySound(args.spellId, "alarm") -- spread
	chargedSmashCount = chargedSmashCount + 1
	if searingSlamCount < 3 then -- 2 per rotation
		self:Bar(args.spellId, 43, CL.count:format(L.charged_smash, chargedSmashCount))
	end
end

function mod:WrathOfDjaruun(args)
	self:StopBar(CL.count:format(CL.tank_combo, wrathOfDjaruunCount))
	wrathOfDjaruunCount = wrathOfDjaruunCount + 1
	if wrathOfDjaruunCount < 3 then -- 2 per rotation
		self:Bar(args.spellId, 45, CL.count:format(CL.tank_combo, wrathOfDjaruunCount))
	end
end

function mod:FlamingUpsurge(args)
	self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	if bossUnit and self:Tank() and not self:Tanking(bossUnit) and not self:UnitDebuff("player", 407547) then -- Flaming Slash
		self:PlaySound(args.spellId, "warning") -- tauntswap
	end
end

function mod:EarthenCrush(args)
	self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	if bossUnit and self:Tank() and not self:Tanking(bossUnit) and not self:UnitDebuff("player", 407597) then -- Earthen Crush
		self:PlaySound(args.spellId, "warning") -- tauntswap
	end
end

function mod:TankComboApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm")
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
function mod:SiphonEnergyApplied(args)
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, siphonEnergyCount))
	self:PlaySound(args.spellId, "info")

	self:StopBar(CL.count:format(CL.full_energy, siphonEnergyCount)) -- Ancient Fury
	self:StopBar(CL.count:format(CL.leap, searingSlamCount)) -- Searing Slam
	self:StopBar(CL.count:format(L.doom_flames, doomFlamesCount)) -- Doom Flames
	self:StopBar(CL.count:format(L.shadowlave_blast, shadowlavaBlastCount)) -- Shadowlava Blast
	self:StopBar(CL.count:format(L.charged_smash, chargedSmashCount)) -- Charged Smash
	self:StopBar(CL.count:format(CL.tank_combo, wrathOfDjaruunCount)) -- Wrath of Djaruun
	self:StopBar(CL.count:format(L.unleash_shadowflame, unleashShadowflameCount)) -- Unleash Shadowflame

	local bossUnit = self:UnitTokenFromGUID(args.destGUID)
	if bossUnit then
		local stunTime = floor(UnitPower(bossUnit) / 5) + 2-- 5 / s energy loss, extra 2s at the end
		self:Bar(args.spellId, stunTime, CL.count:format(args.spellName, siphonEnergyCount))
	end
	siphonEnergyCount = siphonEnergyCount + 1
end

function mod:SiphonEnergyRemoved(args)
	self:StopBar(CL.count:format(args.spellName, siphonEnergyCount))

	self:Message(args.spellId, "cyan", CL.removed:format(args.spellName))
	self:PlaySound(args.spellId, "long")

	searingSlamCount = 1
	doomFlamesCount = 1
	shadowlavaBlastCount = 1
	chargedSmashCount = 1
	wrathOfDjaruunCount = 1
	unleashShadowflameCount = 1

	self:Bar(405821, 11, CL.count:format(CL.leap, searingSlamCount)) -- Searing Slam
	self:Bar(400777, 23, CL.count:format(L.charged_smash, chargedSmashCount)) -- Charged Smash
	self:Bar(407641, 31, CL.count:format(CL.tank_combo, wrathOfDjaruunCount)) -- Wrath of Djaruun
	self:Bar(406851, 41, CL.count:format(L.doom_flames, doomFlamesCount)) -- Doom Flames
	self:Bar(406333, 94.5, CL.count:format(L.shadowlave_blast, shadowlavaBlastCount)) -- Shadowlava Blast
	self:Bar(405316, 112, CL.count:format(CL.full_energy, siphonEnergyCount)) -- Ancient Fury
	if self:Mythic() then
		self:Bar(410070, 6, CL.count:format(L.unleash_shadowflame, unleashShadowflameCount)) -- Unleash Shadowflame
	end
end

function mod:UnyieldingRageApplied(args)
	local amount = args.amount or 1
	if amount == 1 then
		self:Message(args.spellId, "yellow")
		self:PlaySound(args.spellId, "long")
	elseif amount == 5 or amount > 7 then -- 5, 8, 9, 10
		self:Message(args.spellId, "yellow", CL.count:format(args.spellName, amount))
		self:PlaySound(args.spellId, amount > 7 and "alarm" or "info")
	end
end


-- Mythic
function mod:FailedSoak(args)
	self:Message(400777, "cyan", L.energy_gained:format(args.extraSpellId), false) -- args.extraSpellId is the energy gained from SPELL_ENERGIZE
	local timeLeft = (100 - UnitPower("boss1")) * 1.12 -- Energy slightly more than 1/s
	self:Bar(405316, {timeLeft, 112}, CL.count:format(CL.full_energy, siphonEnergyCount)) -- Ancient Fury
end

function mod:UnleashShadowflame(args)
	self:StopBar(CL.count:format(L.unleash_shadowflame, unleashShadowflameCount))
	self:Message(args.spellId, "orange", CL.count:format(L.unleash_shadowflame, unleashShadowflameCount))
	self:PlaySound(args.spellId, "alert")
	unleashShadowflameCount = unleashShadowflameCount + 1
	if unleashShadowflameCount < 4 then -- 3 per rotation
		self:Bar(args.spellId, unleashShadowflameCount == 3 and 33 or 43, CL.count:format(L.unleash_shadowflame, unleashShadowflameCount))
	end
end
