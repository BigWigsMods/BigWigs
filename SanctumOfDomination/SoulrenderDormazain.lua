--------------------------------------------------------------------------------
-- Module Declaration
--

if not IsTestBuild() then return end
local mod, CL = BigWigs:NewBoss("Soulrender Dormazain", 2450, 2445)
if not mod then return end
mod:RegisterEnableMob(
	175727, 178921, -- Soulrender Dormazain
	179177, -- Mawsworn Overlord
	175728, 178922 -- Garrosh Hellscream
)
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
		350647, -- Brand of Torment
		{350422, "TANK"}, -- Ruinblade
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
	self:Log("SPELL_CAST_SUCCESS", "Torment", 350217)
	self:Log("SPELL_CAST_SUCCESS", "EncoreOfTorment", 349985)
	self:Log("SPELL_AURA_APPLIED", "BrandOfTormentApplied", 350647)
	--self:Log("SPELL_AURA_APPLIED", "BrandOfTormentApplied", 350647)
	self:Log("SPELL_AURA_APPLIED", "RuinbladeApplied", 350422)
	self:Log("SPELL_CAST_START", "AgonizingSpike", 351779)
	self:Log("SPELL_AURA_APPLIED", "DefianceApplied", 350650)
	self:Log("SPELL_CAST_SUCCESS", "Hellscream", 350411)
	self:Log("SPELL_AURA_APPLIED", "SoulManacles", 354231)
	self:Log("SPELL_CAST_SUCCESS", "RenderedSoul", 351229)
end

function mod:OnEngage()
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_POWER_FREQUENT(event, unit)
	local power = UnitPower(unit)
	if power >= 90 then
		--self:Message(349985, "cyan", CL.soon:format(self:SpellName(349985)), false) -- Encore of Torment
		--self:PlaySound(349985, "info")
		--self:UnregisterUnitEvent(event, unit)
	end
end

function mod:Torment(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, 6)
	--self:Bar(args.spellId, 42)
end

function mod:EncoreOfTorment(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 42)
end

do
	local playerList = {}
	local prev = 0
	function mod:BrandOfTormentApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
			--self:Bar(args.spellId, 6.3)
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "orange", playerList)
		self:CustomIcon(brandOfTormentMarker, args.destName, count)
	end
end

function mod:RuinbladeApplied(args)
	local amount = args.amount or 1
	self:NewStackMessage(args.spellId, "purple", args.destName, amount)
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, 6.3)
end

function mod:AgonizingSpike(args)
	local canDo, ready = self:Interrupter()
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:DefianceApplied(args)
	self:TargetMessage(args.spellId, "orange", args.destName)
end

function mod:Hellscream(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
	--self:CastBar(args.spellId, 6)
end

function mod:SoulManacles(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info")
	end
end

function mod:RenderedSoul(args)
	self:Message(args.spellId, "yellow", CL.incoming:format(args.spellName))
	--self:PlaySound(args.spellId, "long")
	--self:CastBar(args.spellId, 6)
end
