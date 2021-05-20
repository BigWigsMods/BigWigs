--------------------------------------------------------------------------------
-- Module Declaration
--

if not IsTestBuild() then return end
local mod, CL = BigWigs:NewBoss("Soulrender Dormazain", 2450, 2445)
if not mod then return end
mod:RegisterEnableMob(175727, 175728) -- Soulrender Dormazain, Garrosh Hellscream
mod:SetEncounterID(2434)
mod:SetRespawnTime(30)
--mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--



--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then

end

--------------------------------------------------------------------------------
-- Initialization
--

local brandOfTormentMarker = mod:AddMarkerOption(false, "player", 1, 350647, 1, 2) -- Brand of Torment
function mod:GetOptions()
	return {
		-- Soulrender Dormazain
		350217, -- Torment
		349985, -- Encore of Torment
		{350647, "SAY"}, -- Brand of Torment
		brandOfTormentMarker,
		{350422, "TANK"}, -- Ruinblade
		350615, -- Call Mawsworn
		351779, -- Agonizing Spike
		350650, -- Defiance
		350411, -- Hellscream
		354231, -- Soul Manacles
		351229, -- Rendered Soul
	},{
		[350217] = mod:SpellName(-22914), -- Soulrender Dormazain
	}
end

function mod:OnBossEnable()
	-- Soulrender Dormazain
	self:Log("SPELL_CAST_SUCCESS", "Torment", 351581)
	self:Log("SPELL_CAST_SUCCESS", "EncoreOfTorment", 349985)
	self:Log("SPELL_AURA_APPLIED", "BrandOfTormentApplied", 350647)
	self:Log("SPELL_AURA_REMOVED", "BrandOfTormentRemoved", 350647)
	self:Log("SPELL_AURA_APPLIED", "RuinbladeApplied", 350422)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RuinbladeApplied", 350422)
	self:Log("SPELL_CAST_START", "CallMawsworn", 350615)
	self:Log("SPELL_CAST_START", "AgonizingSpike", 351779)
	self:Log("SPELL_AURA_APPLIED", "DefianceApplied", 350650)
	self:Log("SPELL_CAST_START", "Hellscream", 350411)
	self:Log("SPELL_AURA_APPLIED", "SoulManacles", 354231)
end

function mod:OnEngage()
	self:Bar(350422, 10.7) -- Ruinblade
	self:Bar(350217, 12) -- Torment
	self:Bar(350615, 29.2) -- Call Mawsworn
	self:Bar(350647, 36.8) -- Brand of Torment
	self:Bar(350411, 81.1) -- Hellscream
	self:Bar(349985, 132) -- Encore of Torment

	-- self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- function mod:UNIT_POWER_FREQUENT(event, unit)
-- 	local power = UnitPower(unit)
-- 	if power >= 90 then
-- 		self:Message(349985, "cyan", CL.soon:format(self:SpellName(349985)), false) -- Encore of Torment
-- 		self:PlaySound(349985, "info")
-- 		self:UnregisterUnitEvent(event, unit)
-- 	end
-- end

function mod:Torment(args)
	self:Message(350217, "yellow")
	self:PlaySound(350217, "alert")
	-- self:CastBar(350217, 6)
	self:Bar(350217, 45)

	-- Rendered Soul hits, it targets 3s before hitting
	self:Bar(351229, 8, CL.count:format(self:SpellName(351229), 1))
	self:Bar(351229, 13, CL.count:format(self:SpellName(351229), 2))
end

function mod:EncoreOfTorment(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 163)

	self:Bar(350422, 41) -- Ruinblade
	self:Bar(350217, 45) -- Torment
	self:Bar(350615, 59) -- Call Mawsworn
	self:Bar(350647, 66) -- Brand of Torment
	self:Bar(350411, 111) -- Hellscream
end

do
	local playerList = {}
	local prev = 0
	function mod:BrandOfTormentApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
			self:Bar(args.spellId, 17)
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:PlaySound(args.spellId, "warning")
			self:TargetBar(args.spellId, 16, args.destName)
		end
		self:NewTargetsMessage(args.spellId, "orange", playerList)
		self:CustomIcon(brandOfTormentMarker, args.destName, count)
	end

	function mod:BrandOfTormentRemoved(args)
		if self:Me(args.destGUID) then
			self:StopBar(args.spellId, args.destName)
		end
		self:CustomIcon(brandOfTormentMarker, args.destName)
	end
end

function mod:RuinbladeApplied(args)
	local amount = args.amount or 1
	self:NewStackMessage(args.spellId, "purple", args.destName, amount)
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, 32)
end

function mod:CallMawsworn(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "info")
end

function mod:AgonizingSpike(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

do
	local prev = 0
	function mod:DefianceApplied(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:TargetMessage(args.spellId, "orange", args.destName)
		end
	end
end

function mod:Hellscream(args)
	self:StopBar(350217) -- Torment
	self:StopBar(350647) -- Brand of Torment

	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
	-- self:CastBar(args.spellId, 35, CL.cast:format(args.spellName))
end

function mod:SoulManacles(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info")
	end
end
