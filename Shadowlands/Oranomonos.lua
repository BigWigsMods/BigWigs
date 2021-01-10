--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Oranomonos the Everbranching", -1565, 2432)
if not mod then return end
mod:RegisterEnableMob(167527)
mod.otherMenu = -1647
mod.worldBoss = 167527

--------------------------------------------------------------------------------
-- Locals
--

local rapidGrowthCount = 0

--------------------------------------------------------------------------------
-- Initialization
--

local rapidGrowthMarker = mod:AddMarkerOption(true, "player", 1, 338853, 1, 2, 3, 4, 5, 6, 7, 8) -- Rapid Growth
function mod:GetOptions()
	return {
		338855, -- Seeds of Sorrow
		338856, -- Dirge of the Fallen Sanctum
		{338853, "DISPEL"}, -- Rapid Growth
		rapidGrowthMarker,
		{338852, "TANK"}, -- Implant
		338857, -- Regrowth
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("BOSS_KILL")

	self:Log("SPELL_CAST_START", "SeedsOfSorrow", 338855)
	self:Log("SPELL_CAST_START", "DirgeOfTheFallenSanctum", 338856)
	self:Log("SPELL_CAST_START", "RapidGrowth", 338853)
	self:Log("SPELL_CAST_SUCCESS", "RapidGrowthSuccess", 338853)
	self:Log("SPELL_AURA_APPLIED", "RapidGrowthApplied", 338853)
	self:Log("SPELL_AURA_REMOVED", "RapidGrowthRemoved", 338853)
	self:Log("SPELL_AURA_APPLIED", "ImplantApplied", 338852)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ImplantApplied", 338852)
	self:Log("SPELL_CAST_START", "Regrowth", 338857)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 2409 then
		self:Win()
	end
end

function mod:SeedsOfSorrow(args)
	self:Message(args.spellId, "red")
	self:CDBar(args.spellId, 44)
	if self:Melee() then
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:DirgeOfTheFallenSanctum(args)
	self:Message(args.spellId, "red", CL.percent:format(50, args.spellName))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 18) -- 3s cast + 15s channel
end

function mod:RapidGrowth(args)
	rapidGrowthCount = 0
	if self:Dispeller("magic", nil, args.spellId) then
		self:Message(args.spellId, "yellow", CL.incoming:format(args.spellName))
		self:CDBar(args.spellId, 17)
	end
end

function mod:RapidGrowthSuccess(args)
	if self:Dispeller("magic", nil, args.spellId) then
		self:Message(args.spellId, "yellow", CL.on_group:format(args.spellName))
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:RapidGrowthApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
	rapidGrowthCount = rapidGrowthCount + 1
	if rapidGrowthCount < 9 then
		self:CustomIcon(rapidGrowthMarker, args.destName, rapidGrowthCount)
	end
end

function mod:RapidGrowthRemoved(args)
	self:CustomIcon(rapidGrowthMarker, args.destName)
end

function mod:ImplantApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple") -- Mostly a pointless warning?
end

function mod:Regrowth(args)
	self:Message(args.spellId, "orange", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 52)
	local _, ready = self:Interrupter(args.sourceGUID)
	if ready then
		self:PlaySound(args.spellId, "alert")
	end
end
