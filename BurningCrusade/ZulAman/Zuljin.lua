-------------------------------------------------------------------------------
--  Module Declaration
--

local mod, CL = BigWigs:NewBoss("Zul'jin", 568, 191)
if not mod then return end
mod:RegisterEnableMob(23863)
mod:SetEncounterID(1194)
mod:SetRespawnTime(30)

-------------------------------------------------------------------------------
--  Localization
--

local L = mod:GetLocale()
if L then
	L[42594] = "Bear Form" -- short form for "Essence of the Bear"
	L[42607] = "Lynx Form"
	L[42606] = "Eagle Form"
	L[42608] = "Dragonhawk Form"
end

-------------------------------------------------------------------------------
--  Initialization
--

function mod:GetOptions()
	return {
		"stages",
		{43093, "ICON"}, -- Grievous Throw
		43095, -- Creeping Paralysis
		43150, -- Claw Rage
	}, {
		["stages"] = "general",
		[43095] = L[42594],
		[43150] = L[42607],
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "GrievousThrow", 43093)
	self:Log("SPELL_AURA_REMOVED", "GrievousThrowRemoved", 43093)
	self:Log("SPELL_CAST_SUCCESS", "CreepingParalysis", 43095)
	self:Log("SPELL_AURA_APPLIED", "ClawRage", 43150)
	self:Log("SPELL_CAST_START", "Forms", 42594, 42606, 42607, 42608) -- Bear, Eagle, Lynx, Dragonhawk
end

-------------------------------------------------------------------------------
--  Event Handlers
--

do
	function mod:GrievousThrow(args)
		self:TargetMessageOld(args.spellId, args.destName, "yellow", "alarm")
		self:PrimaryIcon(args.spellId, args.destName)
	end
	function mod:GrievousThrowRemoved(args)
		self:StopBar(args.spellId, args.destName)
		self:PrimaryIcon(args.spellId)
	end
end

function mod:CreepingParalysis(args)
	self:MessageOld(args.spellId, "yellow", self:Dispeller("magic") and "warning", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 6)
	self:CDBar(args.spellId, 27)
end

function mod:ClawRage(args)
	self:TargetMessageOld(args.spellId, args.destName, "red", "alert")
end

function mod:Forms(args)
	self:MessageOld("stages", "red", nil, L[args.spellId], args.spellId)
end
