if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Rashok", 2569, 2525)
if not mod then return end
mod:RegisterEnableMob(201320)
mod:SetEncounterID(2680)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local searingSlamCount = 1
local doomFlameCount = 1
local shadowlavaBlastCount = 1
local chargedSmashCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		405821, -- Searing Slam
		403543, -- Living Lava
		406851, -- Doom Flame
		406333, -- Shadowlava Blast
		400777, -- Charged Smash
		{407641, "TANK_HEALER"}, -- Volcanic Combo
		{407547, "TANK"}, -- Flaming Upsurge
		{407597, "TANK"}, -- Earthen Crush
		-- Conduit
		401419, -- Siphon Energy
		405091, -- Unyielding Rage
		405316, -- Ancient Fury
	}, {
		[401419] = -26237, -- Conduit
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "AncientFuryApplied", 405316)
	self:Log("SPELL_CAST_START", "SearingSlam", 405821)
	self:Log("SPELL_CAST_START", "DoomFlame", 406851)
	self:Log("SPELL_CAST_START", "ShadowlavaBlast", 406333)
	self:Log("SPELL_CAST_START", "ChargedSmash", 400777)
	self:Log("SPELL_CAST_START", "FlamingUpsurge", 407547)
	self:Log("SPELL_CAST_START", "EarthenCrush", 407597)
	self:Log("SPELL_AURA_APPLIED", "VolcanicComboApplied", 407547, 407597) -- Flaming Upsurge, Earthen Crush

	self:Log("SPELL_AURA_APPLIED", "SiphonEnergyApplied", 401419)
	self:Log("SPELL_AURA_REMOVED", "SiphonEnergyRemoved", 401419)
	self:Log("SPELL_AURA_APPLIED", "UnyieldingRageApplied", 405091)
	self:Log("SPELL_AURA_APPLIED_DOSE", "UnyieldingRageApplied", 405091)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 403543) -- Living Lava
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 403543)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 403543)
end

function mod:OnEngage()
	searingSlamCount = 1
	doomFlameCount = 1
	shadowlavaBlastCount = 1
	chargedSmashCount = 1

	-- self:Bar(405316, 92) -- Ancient Fury
	-- self:Bar(405821, 30, CL.count:format(self:SpellName(405821), searingSlamCount)) -- Searing Slam
	-- self:Bar(406851, 30, CL.count:format(self:SpellName(406851), doomFlameCount)) -- Doom Flame
	-- self:Bar(406333, 30, CL.count:format(self:SpellName(406333), shadowlavaBlastCount)) -- Shadowlava Blast
	-- self:Bar(400777, 30, CL.count:format(self:SpellName(400777), chargedSmashCount)) -- Charged Smash
	-- self:Bar(407641, 30) -- Volcanic Combo
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
	self:StopBar(CL.count:format(args.spellName, searingSlamCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, searingSlamCount))
	self:PlaySound(args.spellId, "warning")
	searingSlamCount = searingSlamCount + 1
	-- self:Bar(args.spellId, 30, CL.count:format(args.spellName, searingSlamCount))
end

function mod:DoomFlame(args)
	self:StopBar(CL.count:format(args.spellName, doomFlameCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, searingSlamCount))
	self:PlaySound(args.spellId, "alert") -- stack
	doomFlameCount = doomFlameCount + 1
	-- self:Bar(args.spellId, 30, CL.count:format(args.spellName, doomFlameCount))
end

function mod:ShadowlavaBlast(args)
	self:StopBar(CL.count:format(args.spellName, shadowlavaBlastCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, shadowlavaBlastCount))
	self:PlaySound(args.spellId, "alert") -- frontal
	shadowlavaBlastCount = shadowlavaBlastCount + 1
	-- self:Bar(args.spellId, 30, CL.count:format(args.spellName, shadowlavaBlastCount))
end

function mod:ChargedSmash(args)
	self:StopBar(CL.count:format(args.spellName, chargedSmashCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, chargedSmashCount))
	self:PlaySound(args.spellId, "alarm") -- spread
	chargedSmashCount = chargedSmashCount + 1
	-- self:Bar(args.spellId, 30, CL.count:format(args.spellName, chargedSmashCount))
end

do
	local count = 1
	function mod:FlamingUpsurge(args)
		self:StopBar(407641) -- Volcanic Combo
		self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
		local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
		if bossUnit and self:Tank() and not self:Tanking(bossUnit) and not self:UnitDebuff("player", 407547) then -- Flaming Upsurge
			self:PlaySound(args.spellId, "warning") -- tauntswap
		end
		count = count + 1
		if count > 2 then
			count = 1
			-- self:Bar(407641, 30) -- Volcanic Combo
		end
	end

	function mod:EarthenCrush(args)
		self:StopBar(407641) -- Volcanic Combo
		self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
		local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
		if bossUnit and self:Tank() and not self:Tanking(bossUnit) and not self:UnitDebuff("player", 407597) then -- Earthen Crush
			self:PlaySound(args.spellId, "warning") -- tauntswap
		end
		count = count + 1
		if count > 2 then
			count = 1
			-- self:Bar(407641, 30) -- Volcanic Combo
		end
	end
end

function mod:VolcanicComboApplied(args)
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
	self:Stop(405316) -- Ancient Fury
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:SiphonEnergyRemoved(args)
	self:Message(args.spellId, "cyan", CL.removed:format(args.spellName))
	-- self:PlaySound(args.spellId, "info")

	-- XXX check the boss energy
	-- self:Bar(405316, 92) -- Ancient Fury
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
