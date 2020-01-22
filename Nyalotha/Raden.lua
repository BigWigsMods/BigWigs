--------------------------------------------------------------------------------
-- TODO:
-- -- Timers after absorbing orbs
--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Ra-den the Despoiled", 2217, 2364)
if not mod then return end
mod:RegisterEnableMob(156866) -- Ra-den
mod.engageId = 2331
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local essenceCount = 1
local stage = 1
local voidEruptionCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.essences = "Essences"
	L.essences_desc = "Ra-den periodically draws essences from other realms. Essences that reach Ra-den empower him with energy of that type."
	L.essences_icon = 306168
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		-- Stage 1
		{306819, "TANK"}, -- Nullifying Strike
		"essences", -- Void/Vita Essences (Mythic: +Nightmare)
		306732, -- Vita Empowered
		306273, -- Unstable Vita
		306865, -- Call Crackling Stalker
		306733, -- Void Empowered
		306603, -- Unstable Void
		306866, -- Call Void Hunter
		306881, -- Void Collapse
		-- Stage 2
		{313213, "TANK_HEALER"}, -- Decaying Strike
		310003, -- Void Eruption
		{310019, "SAY", "FLASH"}, -- Charged Bonds
		-- Mythic
		312996, -- Nightmare Empowered
		{313077, "SAY", "FLASH"}, -- Unstable Nightmare
		314484, -- Call Night Terror
		315252, -- Dread Inferno
	},{
		["stages"] = "general",
		[306819] = CL.stage:format(1),
		[313213] = CL.stage:format(2),
		[312996] = CL.mythic,
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "NullifyingStrikeStart", 306819)
	self:Log("SPELL_AURA_APPLIED", "NullifyingStrikeApplied", 306819)
	self:Log("SPELL_AURA_APPLIED_DOSE", "NullifyingStrikeApplied", 306819)
	self:Log("SPELL_CAST_SUCCESS", "Essences", 306090, 306168, 312750) -- Draw Vita, Void, Nightmare

	-- Vita
	self:Log("SPELL_AURA_APPLIED", "VitaEmpowered", 306732)
	self:Log("SPELL_AURA_APPLIED", "UnstableVitaApplied", 306207, 306273) -- Initial debuff, player<->player debuffs
	self:Log("SPELL_CAST_START", "CallCracklingStalkerStart", 306865)

	-- Void
	self:Log("SPELL_AURA_APPLIED", "VoidEmpowered", 306733)
	self:Log("SPELL_CAST_SUCCESS", "UnstableVoid", 306603)
	self:Log("SPELL_CAST_START", "CallVoidHunter", 306866)
	self:Log("SPELL_CAST_START", "VoidCollapse", 306881)
	self:Death("VoidHunterDeath", 157366) -- Void Hunter

	-- Stage 2
	self:Log("SPELL_AURA_APPLIED", "Ruin", 309852)
	self:Log("SPELL_CAST_START", "DecayingStrikeStart", 313213)
	self:Log("SPELL_AURA_APPLIED", "DecayingStrikeApplied", 313227)
	self:Log("SPELL_CAST_START", "VoidEruption", 310003)
	self:Log("SPELL_CAST_SUCCESS", "ChargedBonds", 310019)
	self:Log("SPELL_AURA_APPLIED", "ChargedBondsApplied", 310019)
	self:Log("SPELL_AURA_REMOVED", "ChargedBondsRemoved", 310019)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "NightmareEmpowered", 312996)
	self:Log("SPELL_AURA_APPLIED", "UnstableNightmareApplied", 313077)
	self:Log("SPELL_CAST_START", "CallNightTerrorStart", 314484)
	self:Log("SPELL_AURA_APPLIED", "DreadInfernoFixate", 315252)
end

function mod:OnEngage()
	essenceCount = 1
	stage = 1
	voidEruptionCount = 1

	self:Bar("essences", 10, CL.count:format(L.essences, essenceCount), L.essences_icon) -- Essences (1)
	self:Bar(306819, 15.8) -- Nullifying Strike
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:NullifyingStrikeStart(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, 17)
end

function mod:NullifyingStrikeApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	if amount > 1 then
		self:PlaySound(args.spellId, "alarm", nil, args.destName)
	end
end

do
	local prev = 0
	function mod:Essences(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message2("essences", "red", CL.incoming:format(CL.count:format(L.essences, essenceCount)), false)
			self:PlaySound("essences", "warning")
			essenceCount = essenceCount + 1
			self:Bar("essences", 55.5, CL.count:format(L.essences, essenceCount), L.essences_icon)
		end
	end
end

-- Vita
function mod:VitaEmpowered(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:UnstableVitaApplied(args)
	local _, stacks = self:UnitDebuff(args.destName, args.spellId) -- XXX No CLUE for stacks right now.
	self:StackMessage(306273, args.destName, stacks, "cyan")
	self:TargetBar(306273, 6, args.destName, CL.count:format(args.spellName, stacks))
	if self:Me(args.destGUID) then
		self:PlaySound(306273, "warning", nil, args.destName)
	end
end

function mod:CallCracklingStalkerStart(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

-- Void
function mod:VoidEmpowered(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:UnstableVoid(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

function mod:CallVoidHunter(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:VoidCollapse(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, 11)
end

function mod:VoidHunterDeath(args)
	self:StopBar(306881)
end

-- Stage 2
function mod:Ruin()
	stage = 2
	self:PlaySound("stages", "long")
	self:Message2("stages", "cyan", CL.stage:format(stage), false)
	voidEruptionCount = 1

	self:Bar(313213, 6) -- Decaying Strike
	self:Bar(310003, 12.1) -- Void Eruption
	self:Bar(310019, 4.8) -- Charged Bonds
end

function mod:DecayingStrikeStart(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 17)
end

function mod:DecayingStrikeApplied(args)
	self:TargetMessage2(313213, "red", args.destName, args.spellName) -- Decaying Wound
	self:PlaySound(313213, "alarm", nil, args.destName)
end

function mod:VoidEruption(args)
	self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, voidEruptionCount))
	self:PlaySound(args.spellId, "alert")
	voidEruptionCount = voidEruptionCount + 1
	self:Bar(args.spellId, 19.4, CL.count:format(args.spellName, voidEruptionCount))
end

function mod:ChargedBonds()
	self:Bar(310019, 11)
end

do
	local playerList = mod:NewTargetList()
	function mod:ChargedBondsApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:Flash(args.spellId)
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "cyan", playerList)
	end

	function mod:ChargedBondsRemoved(args)
		if self:Me(args.destGUID) then
			self:Message2(args.spellId, "green", CL.removed:format(args.spellName))
			self:PlaySound(args.spellId, "info")
		end
	end
end

-- Mythic
function mod:NightmareEmpowered(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:UnstableNightmareApplied(args)
	-- XXX Assuming there is no CLUE event for stacks here as well.
	local _, stacks = self:UnitDebuff(args.destName, args.spellId)
	self:StackMessage(args.spellId, args.destName, stacks, "red")
	self:TargetBar(args.spellId, 6, args.destName, CL.count:format(args.spellName, stacks))
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:Flash(args.spellId)
		self:PlaySound(args.spellId, "warning", nil, args.destName)
	end
end

function mod:CallNightTerrorStart(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:DreadInfernoFixate(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm", args.destName)
	end
end
