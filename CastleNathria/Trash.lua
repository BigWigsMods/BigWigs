
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Castle Nathria Trash", 2296)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	--[[ Pre Shriekwing ]]--
	168337, -- Moldovaak
	173444, -- Caramain
	173445, -- Sindrel
	173446, -- Hargitas

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	173798, -- Rat of Unusual Size
	173142 -- Dread Feaster
)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	--[[ Pre Shriekwing ]]--
	L.moldovaak = "Moldovaak"
	L.caramain = "Caramain"
	L.sindrel = "Sindrel"
	L.hargitas = "Hargitas"

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	L.feaster = "Dread Feaster"
	L.rat = "Rat of Unusual Size"
	L.miasma = "Miasma" -- Short for Gluttonous Miasma
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Pre Shriekwing ]]--
		343322, -- Curse of Moldovaak
		343320, -- Curse of Caramain
		343325, -- Curse of Sindrel
		343316, -- Curse of Hargitas
		343155, -- Stoneskin
		343302, -- Granite Wings

		--[[ Huntsman Altimor -> Hungering Destroyer ]]--
		340630, -- Rotting
		{329298, "SAY"}, -- Gluttonous Miasma
	},{
		[343322] = L.moldovaak,
		[343320] = L.caramain,
		[343325] = L.sindrel,
		[343316] = L.hargitas,
		[343155] = L.moldovaak .."/".. L.caramain .."/".. L.sindrel .."/".. L.hargitas,
		[340630] = L.rat,
		[329298] = L.feaster,
	},{
		[343302] = CL.knockback, -- Granite Wings (Knockback)
		[329298] = L.miasma, -- Gluttonous Miasma (Miasma)
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	--[[ Pre Shriekwing ]]--
	self:Log("SPELL_CAST_SUCCESS", "Curse", 343322, 343320, 343325, 343316)
	self:Log("SPELL_CAST_START", "Stoneskin", 343155)
	self:Log("SPELL_AURA_APPLIED", "StoneskinApplied", 343155)
	self:Log("SPELL_CAST_START", "GraniteWings", 343302)

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	self:Log("SPELL_AURA_APPLIED_DOSE", "Rotting", 340630)
	self:Log("SPELL_AURA_APPLIED", "GluttonousMiasma", 329298)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ Pre Shriekwing ]]--
function mod:Curse(args)
	self:Message(args.spellId, "yellow", CL.on_group:format(args.spellName))
	self:PlaySound(args.spellId, "alarm")
end

function mod:Stoneskin(args)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	local _, ready = self:Interrupter()
	if ready then
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:StoneskinApplied(args)
	self:Message(args.spellId, "orange", CL.buff_other:format(args.destName, args.spellName))
	self:PlaySound(args.spellId, "warning")
end

function mod:GraniteWings(args)
	self:Message(args.spellId, "orange", CL.casting:format(CL.knockback))
	self:PlaySound(args.spellId, "long")
end

--[[ Huntsman Altimor -> Hungering Destroyer ]]--
function mod:Rotting(args)
	local amount = args.amount or 1
	if amount % 3 == 0 and (self:Me(args.destGUID) or self:Tank(args.destName)) then
		self:StackMessage(args.spellId, args.destName, amount, "purple")
		self:PlaySound(args.spellId, "info")
	end
end

function mod:GluttonousMiasma(args)
	if self:MobId(args.sourceGUID) == 173142 then -- Dread Feaster
		if self:Me(args.destGUID) then
			self:Yell(args.spellId, L.miasma)
		end
		self:TargetMessage(args.spellId, "yellow", args.destName, L.miasma)
		self:PlaySound(args.spellId, "alarm", nil, args.destName)
	end
end
